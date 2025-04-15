using System;
using System.IO;
using System.Globalization;
using System.Data.SqlClient;
using System.Configuration;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.Web.UI;

namespace Quitacao2
{
    public partial class pdfQuit : System.Web.UI.Page
    {
        protected string nuit;
        protected string companyName;
        protected string quitSpan;
        protected int numeroCertificado;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["NUIT"] != null)
                {
                    nuit = Session["NUIT"].ToString();
                    nuitSpan.InnerText = nuit;
                }
                else
                {
                    Response.Write("NUIT não encontrado na sessão. Por favor, retorne à página inicial.");
                    return;
                }

                if (Session["CompanyName"] != null)
                {
                    companyName = Session["CompanyName"].ToString();
                    empresaSpan.InnerText = companyName;
                }
                else
                {
                    empresaSpan.InnerText = "Nome da empresa não encontrado";
                    companyName = string.Empty;
                }

                quitSpan = Request.QueryString["quitSpan"] ?? "informação padrão";

                ViewState["NUIT"] = nuit;
                ViewState["CompanyName"] = companyName;
                ViewState["QuitSpan"] = quitSpan;
            }
            else
            {
                nuit = ViewState["NUIT"] as string;
                companyName = ViewState["CompanyName"] as string;
                quitSpan = ViewState["QuitSpan"] as string;
            }
        }

        protected void btnGerarPDF_Click(object sender, EventArgs e)
        {
            try
            {
                // Recupera e valida os dados necessários
                quitSpan = ViewState["QuitSpan"] as string ?? "informação padrão";
                nuit = ViewState["NUIT"] as string;
                companyName = ViewState["CompanyName"] as string;

                if (string.IsNullOrEmpty(nuit) || string.IsNullOrEmpty(companyName))
                {
                    throw new Exception("NUIT ou nome da empresa não podem estar vazios.");
                }

                // Verifica se o certificado já foi emitido nos últimos 3 meses
                if (CertificadoEmitidoNosUltimosTresMeses(nuit))
                {
                    // Em vez de usar Response.Write, chame a função JavaScript para abrir o modal
                    ScriptManager.RegisterStartupScript(this, GetType(), "openModal", "$('#certificateModal').modal('show');", true);
                    return;
                }


                // Gerar número de certificado e inserir no banco (transação gerenciada)
                numeroCertificado = GerarNumeroCertificado(quitSpan);

                // Gerar o PDF
                GerarPDF();
            }
            catch (Exception ex)
            {
                Response.Clear();
                Response.Write($"Erro durante o processo: {ex.Message}");
                // Opcional: Log do erro
                LogError(ex);
            }
        }

        private bool CertificadoEmitidoNosUltimosTresMeses(string nuit)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["NewDatabaseConnection"].ConnectionString;

            using (var conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Consulta para verificar se o certificado já foi emitido nos últimos 3 meses
                string query = @"
                    SELECT COUNT(*)
                    FROM Certificados
                    WHERE Nuit = @Nuit
                    AND DataEmissao >= @DataLimite";

                using (var cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Nuit", nuit);
                    cmd.Parameters.AddWithValue("@DataLimite", DateTime.Now.AddMonths(-3)); // 3 meses atrás

                    int count = (int)cmd.ExecuteScalar();
                    return count > 0; // Retorna true se já existe um certificado emitido nos últimos 3 meses
                }
            }
        }

        private int GerarNumeroCertificado(string tipoCertificado)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["NewDatabaseConnection"].ConnectionString;

            using (var conn = new SqlConnection(connectionString))
            {
                conn.Open();

                using (var transaction = conn.BeginTransaction())
                {
                    try
                    {
                        // Incrementar número do certificado
                        int novoNumero = IncrementarNumeroCertificado(conn, transaction);

                        // Inserir o certificado no banco de dados
                        InserirCertificado(conn, transaction, novoNumero, tipoCertificado);

                        transaction.Commit();
                        return novoNumero;
                    }
                    catch
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }
        }

        public int IncrementarNumeroCertificado(SqlConnection conn, SqlTransaction transaction)
        {
            // Configura o nível de isolamento para garantir consistência
            using (var isolationCmd = new SqlCommand("SET TRANSACTION ISOLATION LEVEL SERIALIZABLE", conn, transaction))
            {
                isolationCmd.ExecuteNonQuery();
            }

            // Seleciona o maior número de certificado do ano atual
            string query = @"
        SELECT ISNULL(MAX(NumeroCertificado), 0) + 1 
        FROM Certificados 
        WHERE Ano = @Ano";

            using (var cmd = new SqlCommand(query, conn, transaction))
            {
                cmd.Parameters.AddWithValue("@Ano", DateTime.Now.Year);
                int novoNumero = Convert.ToInt32(cmd.ExecuteScalar());

                // Log de depuração
                System.Diagnostics.Debug.WriteLine($"Novo número de certificado: {novoNumero}");

                return novoNumero;
            }
        }

        private void InserirCertificado(SqlConnection conn, SqlTransaction transaction, int numeroCertificado, string tipoCertificado)
        {
            // Verifica se o certificado já existe
            string checkQuery = @"
        SELECT COUNT(*)
        FROM Certificados
        WHERE Nuit = @Nuit
        AND Ano = @Ano
        AND NumeroCertificado = @NumeroCertificado";

            using (SqlCommand checkCommand = new SqlCommand(checkQuery, conn, transaction))
            {
                checkCommand.Parameters.AddWithValue("@Nuit", nuit);
                checkCommand.Parameters.AddWithValue("@Ano", DateTime.Now.Year);
                checkCommand.Parameters.AddWithValue("@NumeroCertificado", numeroCertificado);

                int count = (int)checkCommand.ExecuteScalar();
                if (count > 0)
                {
                    // Log de depuração
                    System.Diagnostics.Debug.WriteLine("Certificado já existe.");

                    return; // Certificado já existe
                }
            }

            // Insere novo certificado
            string insertQuery = @"
        INSERT INTO Certificados (
            Ano, 
            Nuit, 
            NumeroCertificado, 
            DataEmissao, 
            NomeEmpresa, 
            TipoCertificado
        ) VALUES (
            @Ano, 
            @Nuit, 
            @NumeroCertificado, 
            @DataEmissao, 
            @NomeEmpresa, 
            @TipoCertificado
        )";

            using (SqlCommand command = new SqlCommand(insertQuery, conn, transaction))
            {
                command.Parameters.AddWithValue("@Ano", DateTime.Now.Year);
                command.Parameters.AddWithValue("@Nuit", nuit);
                command.Parameters.AddWithValue("@NumeroCertificado", numeroCertificado);
                command.Parameters.AddWithValue("@DataEmissao", DateTime.Now);
                command.Parameters.AddWithValue("@NomeEmpresa", companyName);
                command.Parameters.AddWithValue("@TipoCertificado", tipoCertificado);

                int rowsAffected = command.ExecuteNonQuery();

                // Log de depuração
                System.Diagnostics.Debug.WriteLine($"Linhas afetadas na inserção do certificado: {rowsAffected}");

                if (rowsAffected == 0)
                {
                    throw new Exception("Nenhuma linha inserida na tabela Certificados.");
                }
            }
        }


        private void LogError(Exception ex)
        {
            string logPath = Server.MapPath("~/App_Data/ErrorLog.txt");
            string errorMessage = $"{DateTime.Now}: {ex.Message}\n{ex.StackTrace}\n\n";
            File.AppendAllText(logPath, errorMessage);
        }

        private void GerarPDF()
        {
            // Definir margens em milímetros convertidos para pontos (1 mm = 2.83465 pontos)
            float marginLeft = 40f;    // Margem esquerda: 30mm
            float marginRight = 40f;   // Margem direita: 30mm
            float marginTop = 45f;     // Margem superior: 40mm
            float marginBottom = 45f;  // Margem inferior: 40mm

            // Criar documento com as novas margens
            Document doc = new Document(
                PageSize.A4,           // Tamanho A4 padrão
                marginLeft,            // Margem esquerda
                marginRight,           // Margem direita
                marginTop,             // Margem superior
                marginBottom           // Margem inferior
            );

            try
            {
                // Caminho do arquivo no servidor
                string fileName = $"CertidaoQuitacao_{nuit}_{numeroCertificado}.pdf";
                string filePath = Server.MapPath($"~/GeneratedPDFs/{fileName}");

                // Garantir que o diretório existe
                string directory = Path.GetDirectoryName(filePath);
                if (!Directory.Exists(directory))
                {
                    Directory.CreateDirectory(directory);
                }

                // Criar o PDF no servidor
                using (FileStream fs = new FileStream(filePath, FileMode.Create))
                {
                    PdfWriter writer = PdfWriter.GetInstance(doc, fs);
                    doc.Open();

                    // Adicionar logo
                    string logoPath = Server.MapPath("~/imagens/ine.png");
                    if (File.Exists(logoPath))
                    {
                        iTextSharp.text.Image logo = iTextSharp.text.Image.GetInstance(logoPath);
                        logo.ScaleToFit(120f, 120f);
                        logo.Alignment = Element.ALIGN_LEFT;
                        logo.SpacingAfter = 20f;
                        doc.Add(logo);
                    }

                    // Título
                    Paragraph title = new Paragraph("CERTIDÃO DE QUITAÇÃO\n", new Font(Font.FontFamily.TIMES_ROMAN, 16, Font.BOLD))
                    {
                        Alignment = Element.ALIGN_CENTER,
                        SpacingBefore = 20f,
                        SpacingAfter = 30f
                    };
                    doc.Add(title);

                    // Número do certificado
                    Paragraph number = new Paragraph
                    {
                        Alignment = Element.ALIGN_CENTER,
                        SpacingAfter = 25f
                    };
                    number.Add(new Chunk("Nº ", new Font(Font.FontFamily.TIMES_ROMAN, 12)));
                    number.Add(new Chunk(numeroCertificado.ToString(), new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLD)));
                    number.Add(new Chunk("/DPINE11/GD/420/", new Font(Font.FontFamily.TIMES_ROMAN, 12)));
                    number.Add(new Chunk($"{DateTime.Now.Year}", new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLD)));
                    doc.Add(number);

                    // Conteúdo principal
                    Font regularFont = new Font(Font.FontFamily.TIMES_ROMAN, 12);
                    Font boldFont = new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.BOLD);

                    // Primeiro parágrafo
                    Paragraph para1 = new Paragraph
                    {
                        Alignment = Element.ALIGN_JUSTIFIED,
                        Leading = 18f,
                        SpacingAfter = 20f
                    };
                    para1.Add(new Chunk("A Delegação do Instituto Nacional de Estatística da Cidade de Maputo (DPINE11), certifica que a ", regularFont));
                    para1.Add(new Chunk(companyName, boldFont));
                    para1.Add(new Chunk(" com NUIT ", regularFont));
                    para1.Add(new Chunk(nuit, boldFont));
                    para1.Add(new Chunk(", registada no Ficheiro de Unidades Estatísticas (FUE), está quite com as suas obrigações estatísticas, ao abrigo do disposto na alínea c, do artigo 27, do Decreto 79/2022, de 30 de Dezembro, conjugado com o artigo 6 da Lei n.º 7/96, de 05 de Julho.", regularFont));
                    doc.Add(para1);

                    // Segundo parágrafo
                    Paragraph para2 = new Paragraph
                    {
                        Alignment = Element.ALIGN_JUSTIFIED,
                        Leading = 18f,
                        SpacingAfter = 30f
                    };
                    para2.Add(new Chunk("A presente certidão serve para efeitos de participação em ", regularFont));
                    para2.Add(new Chunk(quitSpan, boldFont));
                    para2.Add(new Chunk(" de contratação de empreitada de obras públicas, fornecimento de bens e prestação de serviços ao Estado, sendo válida por um período de 90 (noventa) dias, contados a partir da data da sua emissão.\n\n\n\n\n\n", regularFont));
                    doc.Add(para2);

                    // Informações finais (Maputo, data, assinatura)
                    Paragraph footer = new Paragraph
                    {
                        Alignment = Element.ALIGN_CENTER,
                        Leading = 18f
                    };

                    // Converter o mês para extenso
                    string mesExtenso = DateTime.Now.ToString("MMMM", new CultureInfo("pt-PT"));
                    mesExtenso = char.ToUpper(mesExtenso[0]) + mesExtenso.Substring(1); // Capitalizar primeira letra

                    // Adicionar a data com o mês em extenso
                    footer.Add(new Chunk($"Maputo, {DateTime.Now:dd} de {mesExtenso} de {DateTime.Now:yyyy}\n\n", regularFont));

                    // Adicionar a delegada
                    footer.Add(new Chunk("A Delegada\n", regularFont));

                    // Adicionar imagem de assinatura
                    string assinaturaPath = Server.MapPath("~/imagens/signature.png");
                    if (File.Exists(assinaturaPath))
                    {
                        iTextSharp.text.Image assinatura = iTextSharp.text.Image.GetInstance(assinaturaPath);

                        // Ajustar tamanho para que pareça ideal para uma assinatura digital
                        assinatura.ScaleToFit(100f, 50f); // Reduzir tamanho para parecer uma assinatura digital
                        assinatura.Alignment = Element.ALIGN_CENTER;

                        // Adicionar quebra de linha antes da assinatura
                        footer.Add(new Chunk("\n", regularFont));

                        // Adicionar a imagem da assinatura
                        footer.Add(new Chunk(new Chunk(assinatura, 0, -20))); // Ajuste de posicionamento vertical

                        // Adicionar quebra de linha depois da assinatura
                        footer.Add(new Chunk("\n", regularFont));
                    }

                    // Adicionar linha de assinatura e informações da delegada
                    footer.Add(new Chunk("________________________\nNoélia Paulo Mabunda Massangaia\n/Técnica Superior N1/\n", regularFont));

                    // Adicionar o rodapé ao documento
                    doc.Add(footer);

                    // Fecha o documento
                    doc.Close();
                }

                // Redirecionar para o arquivo gerado
                Response.Redirect($"~/GeneratedPDFs/{fileName}");
            }
            catch (Exception ex)
            {
                throw new Exception($"Erro ao gerar PDF: {ex.Message}", ex);
            }
        }


        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Session.Clear();
            Response.Redirect("home.aspx");
        }
    }
}
