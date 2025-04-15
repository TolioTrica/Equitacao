<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="homeFue.aspx.cs" Inherits="Quitacao2.homeFue" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quitação</title>
 
 <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.6.0/css/bootstrap.min.css"/>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.6.0/js/bootstrap.bundle.min.js"></script>

      <!-- ... other head content ... -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.6.0/css/bootstrap.min.css"/>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.6.0/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>


    <style>
        main {
        background-color: #ffffff;
        padding: 20px;
        border-radius: 8px;
        margin-top: 50px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        max-width: 600px;
        width: 100%;
        margin:auto
    }
    img {
        width: 100%;
        border-radius: 8px;
    }
    #form1 {
        width: 100%;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        padding: 20px;
        background-color: #f9f9f9;
        border-radius: 8px;
    }
    body {
        background-color: rgba(224, 242, 254, 0.945);
        font-family: 'Arial', sans-serif;
        margin: 0;
        padding: 20px;
        display: flex;
        flex-direction: column;
        align-items: center;
        height: 100vh;
        justify-content: center;
    }
    .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 100%;
        margin-bottom: 30px;
    }
    h1,h2 {
        text-align: center;
        flex-grow: 1;
        margin: 0;
        font-size: 24px;
      font-weight:bold;
    }
    .content {
        display: flex;
        flex-direction: column;
        align-items: center;
        width: 100%;
        max-width: 600px;
    }
    .form-group {
        margin-bottom: 20px;
        width: 100%;
    }
    label {
        display: block;
        margin-bottom: 8px;
        font-size: 14px;
        font-weight: bold;
        color: #333;
    }
    select, input, button {
        width: 100%;
        padding: 12px;
        font-size: 14px;
        border-radius: 6px;
        border: 1px solid #ccc;
        box-sizing: border-box;
        outline: none;
        transition: border-color 0.3s ease;
    }
    select:focus, input:focus {
        border-color: #007BFF;
    }
    #btnVerificarConformidade {
        background-color: #0056b3;
        color: white;
        border: none;
        cursor: pointer;
        font-size: 16px;
        font-weight: bold;
        padding: 12px;
        border-radius: 6px;
        transition: background-color 0.3s ease;
    }
    #btnVerificarConformidade:hover {
        background-color:  #0053AB;
    }
    /* Estilo geral do modal */
.modal.fade {
    display: none;
    transition: opacity 0.3s ease-in-out;
    background-color: rgba(0, 0, 0, 0.5); /* Fundo semitransparente */
    justify-content: center;
    align-items: center;
}

/* Alinhamento do conteúdo do modal */
.modal-dialog {
    max-width: 500px;
    width: 100%;
    margin: auto;
}

/* Estilo do conteúdo do modal */
.modal-content {
    background-color: #ffffff;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
    position: relative;
    transition: transform 0.3s ease-in-out;
}

/* Cabeçalho do modal */
.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-bottom: 10px;
    border-bottom: 1px solid #e9ecef;
}

/* Título do modal */
.modal-title {
    font-size: 18px;
    font-weight: bold;
    color: red;
}

/* Botão de fechar */
.modal-header .close {
    border: none;
    background: transparent;
    font-size: 24px;
    cursor: pointer;
    color: red;
    outline: none;
    padding: 0;
    margin: 0;
}

/* Corpo do modal */
.modal-body {
    padding-top: 20px;
    padding-bottom: 20px;
    color: #555;
    font-size: 16px;
}

/* Rodapé do modal */
.modal-footer {
    display: flex;
    justify-content: space-between;
    padding-top: 10px;
    border-top: 1px solid #e9ecef;
}

/* Estilo dos botões */
.modal-footer .btn {
    padding: 10px 20px;
    font-size: 16px;
    border-radius: 6px;
    cursor: pointer;
    border: none;
    transition: background-color 0.3s ease-in-out;
}

.modal-footer .btn-primary {
    background-color: #007BFF;
    color: white;
}

.modal-footer .btn-primary:hover {
    background-color: #0056b3;
}

.modal-footer .btn-secondary {
    background-color: red;
    color: white;
    width:50%;
    margin-left:25%;
 
}

.modal-footer .btn-secondary:hover {
    background-color: darkred;
}

/* Animação ao abrir o modal */
.modal.fade.show .modal-content {
    transform: scale(1.05);
    transition: transform 0.3s ease-in-out;
}

/* Animação ao fechar o modal */
.modal.fade:not(.show) {
    opacity: 0;
}

  /* Adicionando estilo para o botão voltar */
        .btn-voltar {
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

        .btn-voltar:hover {
            background-color: darkred;
        }
  
        /* Ajustando o layout dos botões */
        .buttons-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
            width: 100%;
        }

        main {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            margin-top: 50px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            max-width: 450px;
            width: 100%;
            margin:auto
        }
        img {
            width:100%;
            border-radius: 8px;
        }
        #form1 {
            width: 50%;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
        }
        body {
            background-color: rgba(224, 242, 254, 0.945);
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            height: 100vh;
            justify-content: center;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            margin-bottom: 30px;
        }
        h1 {
            text-align: center;
            flex-grow: 1;
            margin: 0;
            font-size: 24px;
            font-weight:bold;
        }
        .content {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
            max-width: 600px;
        }
        .form-group {
            margin-bottom: 20px;
            width: 100%;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: bold;
            color: #333;
        }
        select, input, button {
            width: 100%;
            padding: 12px;
            font-size: 14px;
            border-radius: 6px;
            border: 1px solid #ccc;
            box-sizing: border-box;
            outline: none;
            transition: border-color 0.3s ease;
        }
        select:focus, input:focus {
            border-color: #007BFF;
        }
        #btnVerificarConformidade {
            background-color: #007BFF;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            padding: 12px;
            border-radius: 6px;
            transition: background-color 0.3s ease;
        }
        #btnVerificarConformidade:hover {
            background-color: #0056b3;
        }
        
    </style> 
</head>
<body>
    <form id="form1" runat="server">
        <main>
            <div id="img"><img src="imagens/ine.png" alt="logo" /></div>
            <div class="header">
                <h1>Quitação</h1>
              
            </div>
            <div class="content">
                <div class="form-group">
                    <label for="txtAno">Digite o ano:</label>
                    <asp:TextBox ID="txtAno" runat="server" AutoComplete="off" TextMode="Number" min="1975" max="2100" step="1"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label for="txtNUIT">Digite o NUIT:</label>
                    <asp:TextBox ID="txtNUIT" runat="server" TextMode="Number"></asp:TextBox>
                </div>
                <!-- Botão Verificar Conformidade -->
                <asp:Button ID="btnVerificarConformidade" runat="server" Text="Verificar Conformidade" OnClick="btnVerificarConformidade_Click" CssClass="btn btn-success" />
            
                    <!-- Novo Botão Voltar -->
                    <asp:Button ID="btnVoltar" runat="server" Text="Voltar" CssClass="btn-voltar" OnClientClick="window.location.href='BoasVindas.aspx'; return false;" />
                
            </div>
        </main>
      <div class="modal fade" id="modalEscolha" tabindex="-1" role="dialog" aria-labelledby="modalEscolhaLabel" aria-hidden="true" style="padding: 80px 0;">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalEscolhaLabel" style="color:black">Escolha uma opção</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"></button>
        
                    </div>
                    <div class="modal-body">
                        <p>Por favor, escolha uma das seguintes opções:</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" onclick="redirectToPdfQuit('cadastroUnico');">Cadastro Único</button>
                        <button type="button" class="btn btn-secondary" onclick="redirectToPdfQuit('concursoPublico');" style="background-color:mediumseagreen; width:98%; margin:auto;">Concurso Público</button>
                    </div>
                </div>
            </div>
        </div>

        <!--Modal para exibir alerta ano e nuit não inseridos-->
           <div class="modal fade" id="modalAlertLabel" tabindex="-1" role="dialog" aria-labelledby="modalAlertLabel" aria-hidden="true" style="padding: 80px 0;">
         <div class="modal-dialog" role="document">
             <div class="modal-content">
                 <div class="modal-header">
                     <h5 class="modal-title" id="modalAlert" style="color:red; display:flex; justify-content:center;" >Alerta⚠️</h5>
                     <button type="button" class="close" data-dismiss="modal" aria-label="Close"></button>
     
                 </div>
                 <div class="modal-body">
                 <p> Por favor, insira o Ano e o Nuit!</p>
                 </div>
                 <div class="modal-footer">
     <button type="button" class="btn btn-secondary" data-dismiss="modal">Fechar</button>
 </div>
             </div>
         </div>
     </div>

        <!--MOdal para exibir os meses em falta-->
<div class="modal fade" id="modalMeses" tabindex="-1" role="dialog" aria-labelledby="modalMesesLabel" aria-hidden="true" style="padding:80px 0">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalMesesLabel">Alerta ⚠️</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    
                </button>
            </div>
            <div class="modal-body">
                <p id="modalMessage">A empresa [companyName] não cumpriu com os deveres para os seguintes meses: [monthslist]
</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Fechar</button>
            </div>
        </div>
    </div>
</div>

            <!--Modal para Ano e nuit não encontrados-->
                  <div class="modal fade" id="modalFindLabel" tabindex="-1" role="dialog" aria-labelledby="modalFindLabel" aria-hidden="true" style="padding: 80px 0;">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalFind" style="color:red; display:flex; justify-content:center;" >Alerta⚠️</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"></button>
    
                </div>
                <div class="modal-body">
                <p>Ano e o Nuit não encontrados, por favor verifique os dados inseridos</p>
                </div>
                <div class="modal-footer">
    <button type="button" class="btn btn-secondary" data-dismiss="modal">Fechar</button>
</div>
            </div>
        </div>
    </div>



        <asp:HiddenField ID="hiddenQuitContent" runat="server" />
        <asp:HiddenField ID="hiddenTipoCertificado" runat="server" />

        <!-- Elemento para exibir o tipo de certificado -->
        <div id="certificadoTipo" style="margin-top: 20px; font-weight: bold;"></div>

    </form>

    <script>


        function redirectToPdfQuit(type) {
            let tipoCertificado = '';
            if (type === 'cadastroUnico') {
                tipoCertificado = 'Cadastro Único';
            } else if (type === 'concursoPublico') {
                tipoCertificado = 'Concurso Público';
            }

            // Update the hidden field with the certificate type
            document.getElementById('<%= hiddenTipoCertificado.ClientID %>').value = tipoCertificado;

            // Update the visible element to show the selected certificate type
            document.getElementById('certificadoTipo').innerText = 'Tipo de Certificado: ' + tipoCertificado;

            var quitContent = document.getElementById('<%= hiddenQuitContent.ClientID %>').value || "default content";
            var ano = document.getElementById('<%= txtAno.ClientID %>').value;
            var nuit = document.getElementById('<%= txtNUIT.ClientID %>').value;

            var url = 'pdfQuit.aspx?type=' + encodeURIComponent(type) +
                '&quitContent=' + encodeURIComponent(quitContent) +
                '&ano=' + encodeURIComponent(ano) +
                '&nuit=' + encodeURIComponent(nuit) +
                '&quitSpan=' + encodeURIComponent(tipoCertificado);

            window.location.href = url;
        }

        document.addEventListener('DOMContentLoaded', function () {
            var companyName = '<%= Session["AlertCompanyName"] ?? "Empresa não identificada" %>';
       var missingMonths = '<%= Session["AlertMissingMonths"] ?? "" %>';

            // Substituir o texto no modal
            var modalMessage = document.getElementById('modalMessage');
            modalMessage.innerText = "A empresa " + companyName + " não cumpriu com os deveres para os seguintes meses: " + missingMonths;
        });

    </script>
</body>
</html>
