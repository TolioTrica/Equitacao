using System;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Collections.Generic;
using System.Configuration;

namespace Quitacao2
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CarregarEstatisticas();
            }
        }

        private void CarregarEstatisticas()
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NewDatabaseConnection"].ConnectionString))
            {
                conn.Open();

                // Total de certificados
                lblTotalCertificados.Text = GetTotalCertificados(conn);

                // Total de concursos públicos
                lblTotalConcursos.Text = GetTotalConcursos(conn);

                // Total de cadastros únicos
                lblTotalCadastros.Text = GetTotalCadastros(conn);

                // Média mensal
                lblMediaMensal.Text = GetMediaMensal(conn);
            }
        }

        private string GetTotalCertificados(SqlConnection conn)
        {
            using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Certificados", conn))
            {
                return cmd.ExecuteScalar().ToString();
            }
        }

        private string GetTotalConcursos(SqlConnection conn)
        {
            using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Certificados WHERE tipoCertificado LIKE '%concurso%'", conn))
            {
                return cmd.ExecuteScalar().ToString();
            }
        }

        private string GetTotalCadastros(SqlConnection conn)
        {
            using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Certificados WHERE tipoCertificado LIKE '%cadastro%'", conn))
            {
                return cmd.ExecuteScalar().ToString();
            }
        }

        private string GetMediaMensal(SqlConnection conn)
        {
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT CAST(COUNT(*) AS FLOAT) / 
                       NULLIF(DATEDIFF(MONTH, MIN(dataEmissao), MAX(dataEmissao)), 0) 
                FROM Certificados", conn))
            {
                var result = cmd.ExecuteScalar();
                return result != DBNull.Value ? Math.Round(Convert.ToDouble(result), 2).ToString() : "0";
            }
        }

        // Métodos para gerar dados para os gráficos
        protected string GetMonthlyChartData() => GenerateChartData(-1);
        protected string GetQuarterChartData() => GenerateChartData(-3);
        protected string GetSemesterChartData() => GenerateChartData(-6);
        protected string GetNineMonthsChartData() => GenerateChartData(-9);
        protected string GetAnnualChartData() => GenerateChartData(-12);

        private string GenerateChartData(int months)
        {
            var dados = new
            {
                labels = new List<string>(),
                datasets = new[]
                {
                    new { label = "Concursos Públicos", data = new List<int>(), backgroundColor = "#28a745" },
                    new { label = "Cadastros Únicos", data = new List<int>(), backgroundColor = "#17a2b8" }
                }
            };

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NewDatabaseConnection"].ConnectionString))
            {
                conn.Open();
                string query = $@"
                    WITH Periodo AS (
                        SELECT DISTINCT FORMAT(dataEmissao, 'MMM yyyy') as mes,
                               DATEFROMPARTS(YEAR(dataEmissao), MONTH(dataEmissao), 1) as data
                        FROM Certificados
                        WHERE dataEmissao >= DATEADD(MONTH, {months}, GETDATE())
                    )
                    SELECT 
                        P.mes,
                        COUNT(CASE WHEN C.tipoCertificado LIKE '%concurso%' THEN 1 END) as concursos,
                        COUNT(CASE WHEN C.tipoCertificado LIKE '%cadastro%' THEN 1 END) as cadastros
                    FROM Periodo P
                    LEFT JOIN Certificados C ON FORMAT(C.dataEmissao, 'MMM yyyy') = P.mes
                    GROUP BY P.mes, P.data
                    ORDER BY P.data";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        dados.labels.Add(reader["mes"].ToString());
                        dados.datasets[0].data.Add(Convert.ToInt32(reader["concursos"]));
                        dados.datasets[1].data.Add(Convert.ToInt32(reader["cadastros"]));
                    }
                }
            }

            return new JavaScriptSerializer().Serialize(dados);
        }
    }
}
