USE [bdpedido]
GO

-- Q1

CREATE OR ALTER VIEW View_FornecedorPais
AS
SELECT
    NomeDaEmpresa,
    Endereco,
    Pais
FROM Fornecedores;
GO


-- Q2

CREATE OR ALTER VIEW View_Funcionarios
AS
SELECT
    *
FROM Funcionarios
WHERE Tratamento = 'Sra.';
GO


-- Q3

CREATE OR ALTER VIEW View_TotalPedidosPorCliente
AS
SELECT
    c.NomeDaEmpresa,
    COUNT(p.NumeroDoPedido) AS TotalPedidos
FROM Clientes c
LEFT JOIN Pedidos p
    ON p.CodigoDoCliente = c.CodigoDoCliente
GROUP BY
    c.CodigoDoCliente,
    c.NomeDaEmpresa;
GO


-- Q4

CREATE OR ALTER VIEW View_TotalFuncionario
AS
SELECT
    f.Nome,
    f.Cargo,
    COUNT(p.NumeroDoPedido) AS TotalPedidos
FROM Funcionarios f
LEFT JOIN Pedidos p
    ON p.CodigoDoFuncionario = f.CodigoDoFuncionario
GROUP BY
    f.CodigoDoFuncionario,
    f.Nome,
    f.Cargo;
GO


-- Q5

ALTER VIEW View_FornecedorPais
AS
SELECT
    NomeDaEmpresa,
    Endereco,
    Pais,
    Cidade
FROM Fornecedores;
GO


-- Q6

CREATE OR ALTER VIEW View_TotalCargo
AS
SELECT
    f.Cargo,
    COUNT(p.NumeroDoPedido) AS TotalPedidos
FROM Funcionarios f
LEFT JOIN Pedidos p
    ON p.CodigoDoFuncionario = f.CodigoDoFuncionario
GROUP BY f.Cargo;
GO


-- Q7

DROP VIEW IF EXISTS View_TotalFuncionario;
GO


-- Q8

CREATE OR ALTER VIEW View_FornecedoresCidade
AS
SELECT
    NomeDaEmpresa,
    Endereco,
    Cidade
FROM Fornecedores
WHERE Cidade IN ('London', 'Osaka', 'Berlin', 'São Paulo');
GO


-- Q9

SELECT
    NomeDaEmpresa,
    Endereco,
    Cidade
FROM View_FornecedoresCidade
WHERE Cidade = 'São Paulo';
GO


-- Q10

SELECT
    Cargo,
    TotalPedidos
FROM View_TotalCargo
WHERE Cargo = 'Representante de Vendas';
GO
