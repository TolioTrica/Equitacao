using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Collections.Generic;
using System.Globalization;

namespace Quitacao2
{
    public partial class home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Recuperar as variáveis da sessão
                string alertCompanyName = Session["AlertCompanyName"]?.ToString();
                string alertMissingMonths = Session["AlertMissingMonths"]?.ToString();

                if (!string.IsNullOrEmpty(alertCompanyName) && !string.IsNullOrEmpty(alertMissingMonths))
                {
                    // Passar as informações para o JavaScript
                    string script = $@"
                document.addEventListener('DOMContentLoaded', function() {{
                    var message = 'A empresa {alertCompanyName} não cumpriu com os deveres para os seguintes meses: {alertMissingMonths}';
                    document.getElementById('modalMessage').innerText = message;
                }});
            ";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "setModalMessage", script, true);
                }
            
            hiddenQuitContent.Value = "default quit content";
            }
        }

        protected void btnVerificarConformidade_Click(object sender, EventArgs e)
        {
            string ano = txtAno.Text.Trim();
            string nuit = txtNUIT.Text.Trim();

            if (string.IsNullOrEmpty(nuit) || string.IsNullOrEmpty(ano))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "openModal", "$('#modalAlertLabel').modal('show');", true);
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["NewDatabaseConnection"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    // Verificar a existência do NUIT e Ano antes de fazer a consulta
                    string checkExistenceQuery = @"
SELECT COUNT(*) 
FROM tbl_fue 
WHERE NUIT = @NUIT AND Ano = @Ano";

                    using (SqlCommand existenceCommand = new SqlCommand(checkExistenceQuery, connection))
                    {
                        existenceCommand.Parameters.AddWithValue("@NUIT", nuit);
                        existenceCommand.Parameters.AddWithValue("@Ano", ano);

                        var result = existenceCommand.ExecuteScalar();
                        int count = Convert.ToInt32(result);

                        if (count == 0)
                        {
                            // NUIT ou Ano não encontrados, abrir modal de erro
                            ScriptManager.RegisterStartupScript(this, GetType(), "openModal", "$('#modalFindLabel').modal('show');", true);
                            return;
                        }
                    }

                    // Verificar os valores da amostra para o ano e NUIT
                    string checkAmostraQuery = @"
SELECT COUNT(*) 
FROM tbl_fue
WHERE NUIT = @NUIT AND Ano = @Ano AND amostra = 1";

                    using (SqlCommand amostraCommand = new SqlCommand(checkAmostraQuery, connection))
                    {
                        amostraCommand.Parameters.AddWithValue("@NUIT", nuit);
                        amostraCommand.Parameters.AddWithValue("@Ano", ano);

                        var amostraResult = amostraCommand.ExecuteScalar();
                        int amostraCount = Convert.ToInt32(amostraResult);

                        if (amostraCount == 0)
                        {
                            // Caso a amostra não seja 1, exibir um modal de erro
                            ScriptManager.RegisterStartupScript(this, GetType(), "openModal", "$('#modalFindLabel').modal('show');", true);
                            return;
                        }
                    }

                    // Continuar o fluxo normal caso todas as condições sejam atendidas
                    string getCompanyNameQuery = @"
SELECT TOP 1 nome
FROM tbl_fue
WHERE NUIT = @NUIT AND Ano = @Ano";

                    using (SqlCommand getCompanyNameCommand = new SqlCommand(getCompanyNameQuery, connection))
                    {
                        getCompanyNameCommand.Parameters.AddWithValue("@NUIT", nuit);
                        getCompanyNameCommand.Parameters.AddWithValue("@Ano", ano);

                        object nameResult = getCompanyNameCommand.ExecuteScalar();
                        string companyName = nameResult != null ? nameResult.ToString() : "Nome não encontrado";

                        Session["CompanyName"] = companyName;
                    }

                    Session["NUIT"] = nuit;
                    Session["Ano"] = ano;

                    hiddenQuitContent.Value = $"NUIT: {nuit}, Ano: {ano}, Empresa: {Session["CompanyName"]}";

                    // Query para a pesquisa de meses com campos nullos
                    string missingFieldsQuery = @"
SELECT DISTINCT Mes
FROM tbl_fue
WHERE NUIT = @NUIT and Ano = @Ano
AND amostra = 1  -- Verifica se amostra é igual a 1
AND (
    CodProv IS NULL OR CAE IS NULL OR TOTALNPS IS NULL OR TotREM IS NULL OR
    TotalHora_Trab IS NULL OR TOTALNPS1 IS NULL OR TotREM1 IS NULL OR
    TotalHora_Trab1 IS NULL OR NPS_H_Nac IS NULL OR NPS_M_Nac IS NULL OR
    NPS_H_Estr IS NULL OR NPS_M_Estr IS NULL OR rem_H_Nac IS NULL OR
    rem_M_Nac IS NULL OR rem_H_Estr IS NULL OR rem_M_Estr IS NULL OR
    Hora_Trab_H_Nac IS NULL OR Hora_Trab_M_Nac IS NULL OR Hora_Trab_H_Estr IS NULL OR
    Hora_Trab_M_Estr IS NULL OR STA IS NULL OR Cond IS NULL OR CAE_Seg1 IS NULL OR
    CAE_Seg2 IS NULL OR CodtipoEstab IS NULL OR PassagUrb IS NULL OR PassagInterUrb IS NULL OR
    PassagIntern IS NULL OR TotaisPassag IS NULL OR TotaisPassag1 IS NULL OR
    CargaUrb IS NULL OR CargaInterUrb IS NULL OR CargaIntern IS NULL OR
    TotaisCarga IS NULL OR TotaisCarga1 IS NULL OR DistancUrb IS NULL OR
    DistancInterUrb IS NULL OR DistancIntern IS NULL OR TotaisDistanc IS NULL OR
    TotaisDistanc1 IS NULL OR NumVeicUrb IS NULL OR NumVeicInterUrb IS NULL OR
    NumVeicIntern IS NULL OR TotaisVeic IS NULL OR TotaisVeic1 IS NULL OR
    RecPassagUrb IS NULL OR RecPassagInterUrb IS NULL OR RecPassagIntern IS NULL OR
    TotaisRecPassag IS NULL OR TotaisRecPassag1 IS NULL OR RecCargaUrb IS NULL OR
    RecCargaInterUrb IS NULL OR RecCargaIntern IS NULL OR TotaisRecCargas IS NULL OR
    TotaisRecCargas1 IS NULL OR OutraReceita IS NULL OR ReceitasTotaisUrb IS NULL OR
    ReceitasTotaisUrb1 IS NULL OR ReceitasTotaisInterUrb IS NULL OR
    ReceitasTotaisInterUrb1 IS NULL OR ReceitasTotaisIntern IS NULL OR
    ReceitasTotaisIntern1 IS NULL OR ReceitasTotais IS NULL OR ReceitasTotais1 IS NULL
)
ORDER BY Mes";

                    using (SqlCommand command = new SqlCommand(missingFieldsQuery, connection))
                    {
                        command.Parameters.AddWithValue("@NUIT", nuit);
                        command.Parameters.AddWithValue("@Ano", ano);

                        List<string> missingMonths = new List<string>();
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string monthNumber = reader["Mes"].ToString();
                                string monthName = GetMonthName(monthNumber);
                                missingMonths.Add(monthName);
                            }
                        }

                        if (missingMonths.Count > 0)
                        {
                            string monthsList = string.Join(", ", missingMonths);
                            string companyName = Session["CompanyName"]?.ToString() ?? "Empresa não identificada";

                            // Salvar as informações na sessão
                            Session["AlertCompanyName"] = companyName;
                            Session["AlertMissingMonths"] = monthsList;

                            // Acionar o modal
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "openModal", "$('#modalMeses').modal('show');", true);
                        }
                        else
                        {
                            // Nenhum campo ausente, abrir o modalEscolha
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "openModalEscolha", "$('#modalEscolha').modal('show');", true);
                        }
                    }
                }

                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('Erro ao verificar conformidade: {ex.Message}');", true);
                }
            }
        }


        private string GetMonthName(string monthNumber)
        {
            if (int.TryParse(monthNumber, out int month) && month >= 1 && month <= 12)
            {
                return new DateTime(2000, month, 1).ToString("MMMM", new CultureInfo("pt-PT"));
            }
            return monthNumber; // Return the original value if it's not a valid month number
        }
    }
}