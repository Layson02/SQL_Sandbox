USE [bdpedido]
GO

-- 1

SELECT 
    c.CodigoDoCliente,
    c.NomeDaEmpresa
FROM Clientes c
LEFT JOIN Pedidos p ON c.CodigoDoCliente = p.CodigoDoCliente
WHERE p.NumeroDoPedido IS NULL;

-- 2

SELECT 
    p.NomeDoProduto,
    c.NomeDaCategoria
FROM Produtos p
INNER JOIN Categorias c ON p.CodigoDaCategoria = c.CodigoDaCategoria;

-- 3

SELECT 
    p.NumeroDoPedido,
    CONCAT(f.Nome, ' ', f.Sobrenome) AS NomeDoFuncionario
FROM Pedidos p
INNER JOIN Funcionarios f ON p.CodigoDoFuncionario = f.CodigoDoFuncionario;

-- 4

SELECT 
    p.NomeDoProduto,
    f.NomeDaEmpresa AS Fornecedor
FROM Produtos p
INNER JOIN Fornecedores f ON p.CodigoDoFornecedor = f.CodigoDoFornecedor
ORDER BY f.NomeDaEmpresa ASC;

-- 5

SELECT DISTINCT
    CONCAT(f.Nome, ' ', f.Sobrenome) AS NomeDoFuncionario,
    pr.NomeDoProduto
FROM Funcionarios f
INNER JOIN Pedidos p ON f.CodigoDoFuncionario = p.CodigoDoFuncionario
INNER JOIN Detalhes_do_Pedido dp ON p.NumeroDoPedido = dp.NumeroDoPedido
INNER JOIN Produtos pr ON dp.CodigoDoProduto = pr.CodigoDoProduto;

-- 6

SELECT 
    p.NomeDoProduto
FROM Produtos p
INNER JOIN Fornecedores f ON p.CodigoDoFornecedor = f.CodigoDoFornecedor
WHERE f.Pais = 'Japão';

-- 7

SELECT DISTINCT
    pr.NomeDoProduto,
    c.NomeDaEmpresa AS NomeDoCliente
FROM Produtos pr
INNER JOIN Detalhes_do_Pedido dp ON pr.CodigoDoProduto = dp.CodigoDoProduto
INNER JOIN Pedidos p ON dp.NumeroDoPedido = p.NumeroDoPedido
INNER JOIN Clientes c ON p.CodigoDoCliente = c.CodigoDoCliente;

-- 8

SELECT DISTINCT
    f.NomeDaEmpresa AS Fornecedor,
    c.NomeDaCategoria
FROM Fornecedores f
INNER JOIN Produtos p ON f.CodigoDoFornecedor = p.CodigoDoFornecedor
INNER JOIN Categorias c ON p.CodigoDaCategoria = c.CodigoDaCategoria;