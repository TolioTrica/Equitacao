<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Certidão de Quitação</title>
    <link rel="icon" href="/imagens/favicon.ico" type="image/x-icon" />
    <style>
        body, html {
            height: 100%;
            margin: 0;
            font-family: Arial, sans-serif;
            overflow: hidden;
        } 

        .logo {
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 3;
            width: 200px; /* Ajuste o tamanho conforme necessário */
            height: auto;
        }

        .carousel-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: #000;
        }

        .carousel-slide {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            transition: opacity 1s ease-in-out;
        }

        .carousel-slide.active {
            opacity: 1;
        }

        .carousel-slide img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.4);
            z-index: 1;
        }

        .content {
            position: relative;
            z-index: 2;
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
        }

        .title {
            font-size: 2.5rem;
            font-weight: bold;
            text-align: center;
            margin-bottom: 2rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
            padding: 0 1rem;
        }

        .button-container {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            justify-content: center;
            padding: 0 1rem;
        }

        .button {
            display: inline-block;
            padding: 1rem 2rem;
            font-size: 1.2rem;
            text-decoration: none;
            border-radius: 5px;
            transition: transform 0.2s, background-color 0.2s;
        }

        .button:hover {
            transform: translateY(-2px);
        }

        .button-primary {
            background-color: #4CAF50;
            color: white;
        }

        .button-primary:hover {
            background-color: #45a049;
        }

        .button-secondary {
            background-color: #2196F3;
            color: white;
        }

        .button-secondary:hover {
            background-color: #0b7dda;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <img src="/imagens/ine-logo.jpg" alt="Logo INE" class="logo">
        <div class="carousel-container">
            <div class="carousel-slide">
                <img src="/imagens/comput.jpg" alt="INE Image 1">
            </div>
            <div class="carousel-slide">
                <img src="/imagens/empresa1.jpg" alt="INE Image 2">
            </div>
            <div class="carousel-slide">
                <img src="/imagens/predio.jpg" alt="INE Image 3">
            </div>
            <div class="carousel-slide">
                <img src="/imagens/empresa.jpg" alt="INE Image 4">
            </div>
        </div>
        <div class="overlay"></div>
        <div class="content">
            <h1 class="title">Certidão de Quitação</h1>
            <div class="button-container">
                <a href="home.aspx" class="button button-primary">Emitir Quitação</a>
                <a href="Admin.aspx" class="button button-secondary">Gráficos Quitação</a>
            </div>
        </div>
    </form>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const slides = document.querySelectorAll('.carousel-slide');
            let currentSlide = 0;

            function showSlide(index) {
                slides.forEach(slide => slide.classList.remove('active'));
                slides[index].classList.add('active');
            }

            function nextSlide() {
                currentSlide = (currentSlide + 1) % slides.length;
                showSlide(currentSlide);
            }

            // Mostrar primeiro slide
            showSlide(0);

            // Trocar slide a cada 4 segundos
            setInterval(nextSlide, 4000);
        });
    </script>
</body>
</html>