<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pdfQuit.aspx.cs" Inherits="Quitacao2.pdfQuit" %><!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <title>Certidão de Quitação</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.6.0/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.6.0/css/bootstrap.min.css" />


    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 20px;
            background-color: #e6f2ff; /* Azul claro */
        }
        main {
            max-width: 60%;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1); /* Sombra suave */
            border-radius: 4px; /* Adicionado border-radius */
        }
        h1, h2 {
            text-align: center; /* Centraliza h1 e h2 */
        }
        h1 {
            color: #333;
            padding-bottom: 10px;
        }
        h2 {
            color: black;
            display: inline-block; /* Permite que o ano fique ao lado */
        }
        .paragrafos{
            text-align: justify;
        }

        #currentYear {
            color: red;
            font-size: 1em; /* Ajuste conforme necessário */
            margin-left: 10px;
        }
        aside {
            padding: 15px;
            margin-top: 20px;
            border-radius: 5px;
            text-align: center; /* Centraliza o conteúdo do aside */
        }
        aside p {
            margin: 10px 0; /* Adiciona um pouco de espaço entre os parágrafos do aside */
        }
        .logout-button {
    background-color: #ff0000;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 16px;
    transition: background-color 0.3s;
}

.logout-button:hover {
    background-color: #cc0000;
}
  
        main {
            max-width: 60%;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 4px;
            position: relative;
        }

        .logo-container {
            position: absolute;
            top: 20px;
            left: 20px;
            z-index: 1;
          
        }

        .logo {
            max-width: 200px;
            max-height: 200px;
            opacity: 1;
  
        }

        .main-content {
            padding-top: 220px; /* Adjust this value based on your logo size */
        }
  
    .pdf-button {
        background-color: #268D64;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 16px;
        transition: background-color 0.3s;
    }

    .pdf-button:hover {
        background-color: #45a049;
    }

         .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 500px;
            border-radius: 5px;
            position: relative;
        }

        .modal-header {
            padding: 10px 0;
            border-bottom: 1px solid #ddd;
        }

        .modal-body {
            padding: 20px 0;
        }

        .modal-footer {
            padding: 10px 0;
            border-top: 1px solid #ddd;
            text-align: right;
        }

        .close-button {
            padding: 8px 16px;
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .close-button:hover {
            background-color: #c82333;
        }

        .warning-icon {
            color: #dc3545;
            font-size: 24px;
            margin-right: 10px;
        }
/* Estilo geral para o modal */
.modal {
    display: none; /* Ocultar por padrão */
    position: fixed;
    z-index: 1050;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: hidden;
    background-color: rgba(0, 0, 0, 0.5); /* Fundo escurecido */
}

/* Centralizar o modal */
.modal-dialog {
    position: relative;
    margin: auto;
    top: 20%;
    width: 90%;
    max-width: 800px;
    border-radius:3px;
}

/* Estilo do conteúdo do modal */
.modal-content {
    background-color: #fff;
    border-radius: 5px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    padding: 15px;
}

/* Cabeçalho do modal */
.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid #dee2e6;
}

.modal-title {
    margin: 0;
    font-size: 1.25rem;
}

.close {
    background: none;
    border: none;
    font-size: 1.5rem;
    cursor: pointer;
    line-height: 1;
}

/* Corpo do modal */
.modal-body {
    padding: 10px 0;
}

/* Rodapé do modal */
.modal-footer {
    display: flex;
    justify-content: center;
  
}

/* Botões */
.btn {
    padding: 5px 10px;
    border-radius: 4px;
    border: none;
    cursor: pointer;
}

.btn-secondary {
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
       width: 50%;
       
}

.btn-secondary:hover {
    background-color: darkred;
}

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <main>
            <div class="logo-container">
                <img src="imagens/ine.png" alt="Logo" class="logo" id="logoImage"/>
            </div>
            
            <div>
                <h1>Certidão de Quitação</h1> <br />
                <div style="text-align: center;">
                    <h2><span>&#8470;</span>0000/DPINE11/GD/420/<span id="currentYear"></span></h2>
                </div>
                <div class="paragrafos">
                    <p>A Delegação do Instituto Nacional de Estatística da Cidade de Maputo
                    (DPINE11), certifica que a <strong style='color:red'><span id="empresaSpan" runat="server"></span></strong> com NUIT <strong style='color:red'><span id="nuitSpan" runat="server"></span></strong>, registada no Ficheiro de Unidades
                    Estatísticas(FUE), está quite com as suas obrigações estatísticas, ao abrigo do disposto na alínea c, do artigo 27, do Decreto79/2022, de
                    30 de Dezembro, conjugadocom o artigo 6 da Lei n.º 7/96, de 05 de Julho.</p>

                    <p>A presente certidão serve para efeitos de participação em <span id="quitSpan" runat="server"></span> de contratação de empreitada de obras públicas, 
                        fornecimento de bens e prestação de serviços ao Estado, sendo válida por um período de 90 (noventa) dias, contados a partir da 
                        data da sua emissão.</p>
</div>
                </div>
           
            <aside>
                <p>Maputo, <span id="currentDate"></span></p>
                <p>A Delegada</p>
                <p>________________________</p>
                <p>Noélia Paulo Mabunda Massangaia</p>
                <p>/Técnica Superior N1/</p>
            </aside>
        </main>
        <div style="text-align: center; margin-top: 20px;">
            <asp:Button ID="btnLogout" runat="server" Text="Sair" OnClick="btnLogout_Click" CssClass="logout-button" />
            <asp:Button ID="btnGerarPDF" runat="server" Text="Gerar PDF" OnClick="btnGerarPDF_Click" CssClass="pdf-button" />
        </div>
    </form>

            <!--certificateModal-->
<div class="modal fade" id="certificateModal" tabindex="-1" role="dialog" aria-labelledby="modalMesesLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalMesesLabel">Alerta ⚠️</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p id="modalMessage">Impossível emitir certidão de quitação, pois emitiu uma ainda dentro da validade dos 3 meses!</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Fechar</button>
            </div>
        </div>
    </div>
</div>


     <!-- Modal -->
             <!--Modal para Ano e nuit não encontrados-->
                  <div class="modal fade" id="modalFindLabel" tabindex="-1" role="dialog" aria-labelledby="modalFindLabel" aria-hidden="true" style="padding: 80px 0;">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalFind" style="color:red; display:flex; justify-content:center;" >Alerta⚠️</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"></button>
    
                </div>
                <div class="modal-body">
                <p>Ano e o Nuit não encontrados na <strong style='color:red'>amostra</strong>, por favor verifique os dados inseridos ou clique no botao <strong style="color:red">Ir para Fue</strong> e faça login!</p>
                </div>
                <div class="modal-footer">
    <button type="button" class="btn btn-secondary" data-dismiss="modal">Fechar</button>
</div>
            </div>
        </div>
    </div>
>
    <script>
        // Adiciona a data atual
        document.getElementById('currentDate').textContent = new Date().toLocaleDateString('pt-BR');
        // Adiciona o ano atual
        document.getElementById('currentYear').textContent = new Date().getFullYear();
        document.getElementById('logoImage').style.visibility = 'visible';

        //formatacao do mes em extenso para o codigo HTML
        document.addEventListener('DOMContentLoaded', function () {
            const currentDateElement = document.getElementById('currentDate');

            // Opções para formatar a data em extenso em português de Portugal
            const options = {
    
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            };

            const currentDate = new Date();
            const formattedDate = currentDate.toLocaleDateString('pt-PT', options);

            // Atualizar o conteúdo do span com a data formatada
            currentDateElement.textContent = formattedDate;
        });

       
        // Função para definir o conteúdo do quitSpan com base na URL
        window.onload = function () {
            const urlParams = new URLSearchParams(window.location.search);
            const tipoCertificado = urlParams.get('type');
            const quitSpan = document.getElementById('quitSpan');

            // Definindo o conteúdo baseado no tipo de certificado
            if (tipoCertificado === 'cadastroUnico') {
                quitSpan.innerText = 'Cadastro Único.';
            } else if (tipoCertificado === 'concursoPublico') {
                quitSpan.innerText = 'Concurso Público.';
            } else {
                quitSpan.innerText = ' Certificado não especificado.';
            }
        }


    
        function verificarCertificado(nuit) {
            // Função que verifica se o certificado foi emitido nos últimos 3 meses
            if (CertificadoEmitidoNosUltimosTresMeses(nuit)) {
                showModal();
                return false;
            }
            return true; 
        }
         //Função para exibir o modal
        function showModal() {
            const modal = document.getElementById('certificateModal');
            modal.style.display = 'block';
        }

        // Função para fechar o modal
        function closeModal() {
            const modal = document.getElementById('certificateModal');
            modal.style.display = 'none';
        }

        // Adiciona eventos ao botão de fechar
        document.querySelector('.close').addEventListener('click', closeModal);
        document.querySelector('.btn-secondary').addEventListener('click', closeModal);

        // Exemplo de como abrir o modal (chamar essa função no evento necessário)
        showModal();

    </script>
</body>
</html>

