using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Quitacao2
{
    public partial class Admin : System.Web.UI.Page
    {
        string connectionString = WebConfigurationManager.ConnectionStrings["NewDatabaseConnection"].ConnectionString;

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtLoginUsername.Text.Trim();
            string password = txtLoginPassword.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                lblLoginMessage.Text = "Por favor, preencha todos os campos.";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Administrador WHERE Usuario = @Username AND Senha = @Password";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", password);

                try
                {
                    conn.Open();
                    int count = (int)cmd.ExecuteScalar();

                    if (count > 0)
                    {
                        // Credenciais corretas, redirecionar para Dashboard.aspx
                        Response.Redirect("Dashboard.aspx");
                    }
                    else
                    {
                        // Credenciais incorretas
                        lblLoginMessage.Text = "Nome de usuário ou senha incorretos.";
                    }
                }
                catch (Exception ex)
                {
                    lblLoginMessage.Text = "Erro ao tentar logar: " + ex.Message;
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Redirecionar para a página de Boas Vindas
            Response.Redirect("BoasVindas.aspx");
        }
    }
}
