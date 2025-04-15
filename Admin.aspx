<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="Quitacao2.Admin" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cadastro e Login de Administrador</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        img{
                    width: 100%;
        border-radius: 8px;
        }
        form {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 300px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 4px;
            color: #fff;
            cursor: pointer;
            margin-bottom: 10px;
        }
        #btnLogin {
            background-color: #007BFF;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            padding: 12px;
            border-radius: 6px;
            transition: background-color 0.3s ease;
                    margin-top: 20px;
        width: 100%;
        }
        #btnLogin:hover {
background-color: #0056b3;
        }
        #btnLogout {
                  background-color: red;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            padding: 12px;
            border-radius: 6px;
            transition: background-color 0.3s ease;
            margin-top: 20px;
            width: 100%;
        }
        #btnLogout:hover {
               background-color: darkred;
        }
        .message {
            text-align: center;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="img"><img src="imagens/ine.png" alt="logo" /></div>
            <h2>Login de Administrador</h2>
            <asp:Label ID="lblLoginMessage" runat="server" ForeColor="Red" CssClass="message"></asp:Label><br />
            <asp:TextBox ID="txtLoginUsername" runat="server" AutoComplete="off" Placeholder="Nome de Administrador" Width="100%"></asp:TextBox><br /><br />
            <asp:TextBox ID="txtLoginPassword" runat="server" TextMode="Password" Placeholder="Senha" Width="100%"></asp:TextBox><br /><br />
            <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" CssClass="button-login" />
            <asp:Button ID="btnLogout" runat="server" Text="Sair" OnClick="btnLogout_Click" CssClass="button-logout" />
        </div>
    </form>



</body>
</html>
