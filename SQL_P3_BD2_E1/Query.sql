CREATE DATABASE bd2_e1;
GO

USE bd2_e1;
GO

-- Q1

SELECT COUNT(DISTINCT unidade) AS total_unidades
FROM bebida;
GO

-- Q2

SELECT COUNT(DISTINCT categoria) AS total_categorias
FROM bebida;
GO

-- Q3

SELECT COUNT(*) AS total_bebidas_copo
FROM bebida
WHERE bebida LIKE '%COPO%';
GO

-- Q4

SELECT bebida, custobebida
FROM bebida;
GO

-- Q5

SELECT 
    bebida AS [Bebida],
    custobebida AS [Custobebida],
    ROUND(custobebida * 1.10, 2) AS [Custobebida + 10%],
    precocardapio AS [Precocardapio],
    ROUND(precocardapio * 0.85, 2) AS [Precocardapio - 15%]
FROM bebida;
GO

-- Q6

SELECT *
FROM bebida
WHERE idbebida BETWEEN 100 AND 150;
GO

-- Q7

SELECT *
FROM bebida
WHERE bebida LIKE 'V%';
GO

-- Q8

SELECT TOP 10 *
FROM bebida
ORDER BY precocardapio DESC;
GO

-- Q9

SELECT TOP 20 *
FROM bebida
ORDER BY precocardapio ASC;
GO

-- Q10

SELECT TOP 30 *
FROM bebida
ORDER BY precocardapio DESC;
GO

-- Q11

SELECT *
FROM bebida
WHERE codigo LIKE 'RV4%';
GO

-- Q12

SELECT 
    bebida AS [Produto],
    precocardapio AS [Preço Venda],
    custobebida AS [Custo Bebida]
FROM bebida;
GO

-- Q13

SELECT *
FROM bebida
WHERE bebida LIKE '%ZERO%';
GO