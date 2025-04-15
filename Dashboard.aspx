<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Quitacao2.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Dashboard para gerenciamento de certificados." />
    <title>Dashboard de Certificados</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container mt-4">
            <h2 class="text-center mb-4">Dashboard de Certificados</h2>

            <!-- Gráficos Comparativos -->
            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-header bg-primary text-white">Comparação Mensal</div>
                        <div class="card-body">
                            <canvas id="monthlyChart" aria-label="Gráfico mensal" role="img"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-header bg-secondary text-white">Comparação Trimestral</div>
                        <div class="card-body">
                            <canvas id="quarterChart" aria-label="Gráfico trimestral" role="img"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-header bg-success text-white">Comparação Semestral</div>
                        <div class="card-body">
                            <canvas id="semesterChart" aria-label="Gráfico semestral" role="img"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-header bg-info text-white">Comparação de 9 Meses</div>
                        <div class="card-body">
                            <canvas id="nineMonthsChart" aria-label="Gráfico de 9 meses" role="img"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Gráfico Anual de Quitações -->
            <div class="container mt-4">
                <h2 class="text-center mb-4">Resumo Anual de Quitações</h2>
                <div class="row">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header bg-dark text-white">Total de Quitações Anuais</div>
                            <div class="card-body">
                                <canvas id="annualChart" aria-label="Gráfico anual de quitações" role="img"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Estatísticas Gerais -->
            <div class="container mt-4">
                <h3 class="mb-3">Estatísticas Gerais</h3>
                <div class="row">
                    <div class="col-md-6">
                        <label>Total de Certificados:</label>
                        <asp:Label ID="lblTotalCertificados" runat="server" CssClass="form-label"></asp:Label>
                    </div>
                    <div class="col-md-6">
                        <label>Total de Concursos Públicos:</label>
                        <asp:Label ID="lblTotalConcursos" runat="server" CssClass="form-label"></asp:Label>
                    </div>
                    <div class="col-md-6">
                        <label>Total de Cadastros Únicos:</label>
                        <asp:Label ID="lblTotalCadastros" runat="server" CssClass="form-label"></asp:Label>
                    </div>
                    <div class="col-md-6">
                        <label>Média Mensal:</label>
                        <asp:Label ID="lblMediaMensal" runat="server" CssClass="form-label"></asp:Label>
                    </div>
                </div>
            </div>

            <!-- Botão Voltar -->
            <div class="text-center mt-4">
                <button type="button" class="btn btn-danger btn-lg" onclick="redirectToBoasVindas();">
                    Voltar
                </button>
            </div>
        </div>
    </form>

    <script>
        // Dados obtidos do backend
        const monthlyData = <%= GetMonthlyChartData() %> || { labels: [], datasets: [] };
        const quarterData = <%= GetQuarterChartData() %> || { labels: [], datasets: [] };
        const semesterData = <%= GetSemesterChartData() %> || { labels: [], datasets: [] };
        const nineMonthsData = <%= GetNineMonthsChartData() %> || { labels: [], datasets: [] };
        const annualData = <%= GetAnnualChartData() %> || { labels: [], datasets: [] };

        // Função para renderizar gráficos
        function renderChart(id, type, data, options) {
            const ctx = document.getElementById(id);
            if (ctx) {
                new Chart(ctx, {
                    type: type,
                    data: data,
                    options: options
                });
            }
        }

        // Configuração dos gráficos
        renderChart('monthlyChart', 'bar', monthlyData, { responsive: true, plugins: { legend: { position: 'bottom' } } });
        renderChart('quarterChart', 'bar', quarterData, { responsive: true, plugins: { legend: { position: 'bottom' } } });
        renderChart('semesterChart', 'bar', semesterData, { responsive: true, plugins: { legend: { position: 'bottom' } } });
        renderChart('nineMonthsChart', 'bar', nineMonthsData, { responsive: true, plugins: { legend: { position: 'bottom' } } });
        renderChart('annualChart', 'bar', annualData, { responsive: true, plugins: { legend: { position: 'bottom' } } });

        // Redirecionamento ao clicar no botão Voltar
        function redirectToBoasVindas() {
            window.location.href = 'BoasVindas.aspx';
        }
    </script>
</body>
</html>
