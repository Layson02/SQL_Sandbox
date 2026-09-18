USE [bdpedido]
GO

-- Q1

SELECT SUM(Frete) AS TotalFrete
FROM Pedidos;

-- Q2

SELECT COUNT(*) AS Contratados1992
FROM Funcionarios
WHERE YEAR(DataDeContratacao) = 1992;

-- Q3

SELECT COUNT(*) AS FornecedoresAlemanha
FROM Fornecedores
WHERE Pais = 'Alemanha';

