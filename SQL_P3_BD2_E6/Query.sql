USE [bdpedido];
GO

-- Q1

SELECT 
    pr.NomeDoProduto,
    pr.PrecoUnitario
FROM Produtos pr
WHERE pr.PrecoUnitario > (
    SELECT AVG(PrecoUnitario) 
    FROM Produtos
);

-- Q2

SELECT 
    c.NomeDaEmpresa
FROM Clientes c
WHERE c.CodigoDoCliente IN (
    SELECT p.CodigoDoCliente
    FROM Pedidos p
    WHERE p.NumeroDoPedido IN (
        SELECT dp.NumeroDoPedido
        FROM Detalhes_do_Pedido dp
        WHERE dp.CodigoDoProduto = (
            SELECT pr.CodigoDoProduto
            FROM Produtos pr
            WHERE pr.NomeDoProduto = 'Maxilaku'
        )
    )
);

-- Q3

SELECT 
    p.NumeroDoPedido
FROM Pedidos p
WHERE p.NumeroDoPedido IN (
    SELECT dp.NumeroDoPedido
    FROM Detalhes_do_Pedido dp
    GROUP BY dp.NumeroDoPedido
    HAVING COUNT(dp.CodigoDoProduto) > 5
);

-- Q4

SELECT 
    c.NomeDaEmpresa,
    (
        SELECT MAX(ped.TotalPedido)
        FROM (
            SELECT 
                p.CodigoDoCliente,
                SUM(dp.PrecoUnitário * dp.Quantidade) AS TotalPedido
            FROM Pedidos p
            INNER JOIN Detalhes_do_Pedido dp ON p.NumeroDoPedido = dp.NumeroDoPedido
            GROUP BY p.NumeroDoPedido, p.CodigoDoCliente
        ) ped
        WHERE ped.CodigoDoCliente = c.CodigoDoCliente
    ) AS MaiorPedido
FROM Clientes c
WHERE c.CodigoDoCliente IN (SELECT CodigoDoCliente FROM Pedidos);

-- Q5

SELECT 
    pr.NomeDoProduto,
    (
        SELECT MAX(dp.Quantidade)
        FROM Detalhes_do_Pedido dp
        WHERE dp.CodigoDoProduto = pr.CodigoDoProduto
    ) AS MaiorQuantidadeVendida
FROM Produtos pr
WHERE pr.CodigoDoProduto IN (SELECT CodigoDoProduto FROM Detalhes_do_Pedido);

-- Q6

SELECT 
    pr.NomeDoProduto,
    (
        SELECT MIN(dp.PrecoUnitário)
        FROM Detalhes_do_Pedido dp
        WHERE dp.CodigoDoProduto = pr.CodigoDoProduto
    ) AS MenorPrecoVendido
FROM Produtos pr
WHERE pr.CodigoDoProduto IN (SELECT CodigoDoProduto FROM Detalhes_do_Pedido);

-- Q7

SELECT 
    p.NumeroDoPedido
FROM Pedidos p
WHERE p.CodigoDaTransportadora = (
    SELECT t.CodigoDaTransportadora
    FROM Transportadoras t
    WHERE t.NomeDaEmpresa = 'Speedy Express'
)
AND YEAR(p.DataDoPedido) = 1996
AND DATEPART(QUARTER, p.DataDoPedido) = 2;

-- Q8

SELECT 
    p.NumeroDoPedido
FROM Pedidos p
WHERE p.NumeroDoPedido IN (
    SELECT ped.NumeroDoPedido
    FROM Pedidos ped
    WHERE (YEAR(ped.DataDoPedido) = 1996 AND MONTH(ped.DataDoPedido) = 4)
       OR (YEAR(ped.DataDoPedido) = 1997 AND MONTH(ped.DataDoPedido) = 3)
);

-- Q9

SELECT 
    dp.NumeroDoPedido
FROM Detalhes_do_Pedido dp
GROUP BY dp.NumeroDoPedido
HAVING SUM((dp.PrecoUnitário * dp.Quantidade) - dp.Desconto) > (
    SELECT AVG(totais.ValorTotal)
    FROM (
        SELECT 
            SUM((d.PrecoUnitário * d.Quantidade) - d.Desconto) AS ValorTotal
        FROM Pedidos p
        INNER JOIN Detalhes_do_Pedido d ON p.NumeroDoPedido = d.NumeroDoPedido
        WHERE YEAR(p.DataDoPedido) = 1997
          AND DATEPART(QUARTER, p.DataDoPedido) = 2
        GROUP BY p.NumeroDoPedido
    ) totais
);

-- Q10

SELECT DISTINCT 
    f.NomeDaEmpresa
FROM Fornecedores f
WHERE f.CodigoDoFornecedor IN (
    SELECT pr.CodigoDoFornecedor
    FROM Produtos pr
    WHERE pr.PrecoUnitario > (
        SELECT AVG(PrecoUnitario) 
        FROM Produtos
    )
);

-- Q11

SELECT 
    pr.NomeDoProduto,
    pr.PrecoUnitario
FROM Produtos pr
WHERE pr.CodigoDaCategoria = (
    SELECT c.CodigoDaCategoria
    FROM Categorias c
    WHERE c.NomeDaCategoria = 'Confeitos'
);

-- Q12

SELECT 
    p.NumeroDoPedido,
    p.CodigoDoCliente,
    p.DataDoPedido
FROM Pedidos p
WHERE p.CodigoDaTransportadora IN (
    SELECT t.CodigoDaTransportadora
    FROM Transportadoras t
    WHERE t.NomeDaEmpresa IN ('Speedy Express', 'Federal Shipping')
);

-- Q13

SELECT 
    (
        SELECT c.NomeDaEmpresa 
        FROM Clientes c 
        WHERE c.CodigoDoCliente = p.CodigoDoCliente
    ) AS NomeDaEmpresa,
    p.NumeroDoPedido,
    p.DataDoPedido
FROM Pedidos p
WHERE (YEAR(p.DataDoPedido) = 1996 AND MONTH(p.DataDoPedido) = 8)
   OR (YEAR(p.DataDoPedido) = 1997 AND MONTH(p.DataDoPedido) = 9);

-- Q14

SELECT 
    p.NumeroDoPedido,
    p.CodigoDoCliente,
    p.DataDoPedido
FROM Pedidos p
WHERE p.CodigoDoCliente IN (
    SELECT c.CodigoDoCliente
    FROM Clientes c
    WHERE c.Fax IS NULL
);

-- Q15

SELECT 
    c.NomeDaEmpresa
FROM Clientes c
WHERE (
    SELECT SUM(dp.PrecoUnitário * dp.Quantidade)
    FROM Pedidos p
    INNER JOIN Detalhes_do_Pedido dp ON p.NumeroDoPedido = dp.NumeroDoPedido
    WHERE p.CodigoDoCliente = c.CodigoDoCliente
) > (
    SELECT AVG(ped.ValorPedido)
    FROM (
        SELECT 
            SUM(dp2.PrecoUnitário * dp2.Quantidade) AS ValorPedido
        FROM Detalhes_do_Pedido dp2
        GROUP BY dp2.NumeroDoPedido
    ) ped
);

-- Q16

SELECT 
    f.Nome,
    f.Sobrenome
FROM Funcionarios f
WHERE DATEDIFF(YEAR, f.DataDeNascimento, GETDATE()) < (
    SELECT AVG(DATEDIFF(YEAR, DataDeNascimento, GETDATE()) * 1.0)
    FROM Funcionarios
);

-- Q17

SELECT 
    f.Nome,
    f.Sobrenome
FROM Funcionarios f
WHERE (
    SELECT COUNT(*) 
    FROM Pedidos p 
    WHERE p.CodigoDoFuncionario = f.CodigoDoFuncionario
) > (
    SELECT AVG(contagem.QtdPedidos * 1.0)
    FROM (
        SELECT COUNT(*) AS QtdPedidos
        FROM Pedidos
        GROUP BY CodigoDoFuncionario
    ) contagem
);

-- Q18

SELECT 
    p.NumeroDoPedido
FROM Pedidos p
WHERE p.CodigoDoCliente IN (
    SELECT c.CodigoDoCliente
    FROM Clientes c
    WHERE c.Fax IS NULL
);

-- Q19

SELECT 
    c.NomeDaEmpresa
FROM Clientes c
WHERE c.CodigoDoCliente NOT IN (
    SELECT p.CodigoDoCliente
    FROM Pedidos p
    WHERE p.CodigoDoCliente IS NOT NULL
);

-- Q20

SELECT 
    p.NumeroDoPedido,
    p.CodigoDoCliente,
    p.DataDoPedido
FROM Pedidos p
WHERE p.NumeroDoPedido IN (
    SELECT dp.NumeroDoPedido
    FROM Detalhes_do_Pedido dp
    WHERE dp.CodigoDoProduto IN (
        SELECT pr.CodigoDoProduto
        FROM Produtos pr
        WHERE pr.CodigoDaCategoria = (
            SELECT cat.CodigoDaCategoria
            FROM Categorias cat
            WHERE cat.NomeDaCategoria = 'Bebidas'
        )
    )
);

-- Q21

SELECT DISTINCT 
    f.Nome,
    f.Sobrenome
FROM Funcionarios f
WHERE f.CodigoDoFuncionario IN (
    SELECT p.CodigoDoFuncionario
    FROM Pedidos p
    WHERE p.CodigoDoCliente IN (
        SELECT c.CodigoDoCliente
        FROM Clientes c
        WHERE c.NomeDaEmpresa IN (
            'Antonio Moreno Taquería',
            'Blauer See Delikatessen',
            'Ernst Handel'
        )
    )
);

-- Q22

SELECT DISTINCT 
    c.NomeDaEmpresa
FROM Clientes c
WHERE c.CodigoDoCliente IN (
    SELECT p.CodigoDoCliente
    FROM Pedidos p
    WHERE p.Frete > (
        SELECT AVG(Frete) 
        FROM Pedidos
    )
);

-- Q23

SELECT DISTINCT 
    pr.NomeDoProduto
FROM Produtos pr
WHERE pr.CodigoDoProduto IN (
    SELECT dp.CodigoDoProduto
    FROM Detalhes_do_Pedido dp
    WHERE dp.Desconto < (
        SELECT AVG(CAST(Desconto AS float)) 
        FROM Detalhes_do_Pedido
    )
);

-- Q24

SELECT DISTINCT 
    forn.NomeDaEmpresa
FROM Fornecedores forn
WHERE forn.CodigoDoFornecedor IN (
    SELECT pr.CodigoDoFornecedor
    FROM Produtos pr
    WHERE pr.PrecoUnitario > (
        SELECT AVG(PrecoUnitario) 
        FROM Produtos
    )
);

-- Q25

SELECT 
    pr.NomeDoProduto,
    pr.UnidadesEmEstoque
FROM Produtos pr
WHERE pr.UnidadesEmEstoque < (
    SELECT AVG(CAST(dp.Quantidade AS float))
    FROM Detalhes_do_Pedido dp
);