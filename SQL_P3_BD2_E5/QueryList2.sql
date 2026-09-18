USE [bdpedido]
GO

-- Q1
SELECT NomeDoProduto, PrecoUnitario
FROM Produtos
WHERE PrecoUnitario > (
    SELECT AVG(PrecoUnitario) 
    FROM Produtos
);

-- Q2
SELECT NomeDaEmpresa
FROM Clientes
WHERE CodigoDoCliente IN (
    SELECT CodigoDoCliente
    FROM Pedidos
    WHERE NumeroDoPedido IN (
        SELECT NumeroDoPedido
        FROM Detalhes_do_Pedido
        WHERE CodigoDoProduto IN (
            SELECT CodigoDoProduto
            FROM Produtos
            WHERE NomeDoProduto = 'Maxilaku'
        )
    )
);

-- Q3
SELECT NumeroDoPedido
FROM Pedidos
WHERE NumeroDoPedido IN (
    SELECT NumeroDoPedido
    FROM Detalhes_do_Pedido
    GROUP BY NumeroDoPedido
    HAVING COUNT(*) > 5
);

-- Q4
SELECT C.NomeDaEmpresa,
       (
           SELECT MAX(TotalPedido)
           FROM (
               SELECT P.NumeroDoPedido, 
                      SUM([PrecoUnitário] * Quantidade - Desconto) AS TotalPedido
               FROM Pedidos P
               JOIN Detalhes_do_Pedido DP ON P.NumeroDoPedido = DP.NumeroDoPedido
               WHERE P.CodigoDoCliente = C.CodigoDoCliente
               GROUP BY P.NumeroDoPedido
           ) AS PedidosCliente
       ) AS MaiorPedido
FROM Clientes C
WHERE C.CodigoDoCliente IN (SELECT DISTINCT CodigoDoCliente FROM Pedidos);

-- Q5
SELECT P.NomeDoProduto,
       (
           SELECT MAX(DP.Quantidade)
           FROM Detalhes_do_Pedido DP
           WHERE DP.CodigoDoProduto = P.CodigoDoProduto
       ) AS MaiorQuantidadeVendida
FROM Produtos P
WHERE P.CodigoDoProduto IN (SELECT DISTINCT CodigoDoProduto FROM Detalhes_do_Pedido);

-- Q6
SELECT P.NomeDoProduto,
       (
           SELECT MIN(DP.[PrecoUnitário])
           FROM Detalhes_do_Pedido DP
           WHERE DP.CodigoDoProduto = P.CodigoDoProduto
       ) AS PrecoMaisBaixoVendido
FROM Produtos P
WHERE P.CodigoDoProduto IN (SELECT DISTINCT CodigoDoProduto FROM Detalhes_do_Pedido);

-- Q7
SELECT NumeroDoPedido
FROM Pedidos
WHERE CodigoDaTransportadora = (
    SELECT CodigoDaTransportadora
    FROM Transportadoras
    WHERE NomeDaEmpresa = 'Speedy Express'
)
AND YEAR(DataDoPedido) = 1996
AND DATEPART(quarter, DataDoPedido) = 2;

-- Q8
SELECT NumeroDoPedido
FROM Pedidos
WHERE (YEAR(DataDoPedido) = 1996 AND MONTH(DataDoPedido) = 4)
   OR (YEAR(DataDoPedido) = 1997 AND MONTH(DataDoPedido) = 3);

-- Q9
SELECT P.NumeroDoPedido
FROM Pedidos P
WHERE (
    SELECT SUM([PrecoUnitário] * Quantidade - Desconto)
    FROM Detalhes_do_Pedido DP
    WHERE DP.NumeroDoPedido = P.NumeroDoPedido
) > (
    SELECT AVG(TotalVenda)
    FROM (
        SELECT SUM(DP2.[PrecoUnitário] * DP2.Quantidade - DP2.Desconto) AS TotalVenda
        FROM Pedidos P2
        JOIN Detalhes_do_Pedido DP2 ON P2.NumeroDoPedido = DP2.NumeroDoPedido
        WHERE YEAR(P2.DataDoPedido) = 1997 
          AND DATEPART(quarter, P2.DataDoPedido) = 2
        GROUP BY P2.NumeroDoPedido
    ) AS VendasSegundoTri1997
);

-- Q10
SELECT DISTINCT NomeDaEmpresa
FROM Fornecedores
WHERE CodigoDoFornecedor IN (
    SELECT CodigoDoFornecedor
    FROM Produtos
    WHERE PrecoUnitario > (
        SELECT AVG(PrecoUnitario) 
        FROM Produtos
    )
);

-- Q11
SELECT NomeDoProduto, PrecoUnitario
FROM Produtos
WHERE CodigoDaCategoria = (
    SELECT CodigoDaCategoria
    FROM Categorias
    WHERE NomeDaCategoria = 'Confeitos'
);

-- Q12
SELECT NumeroDoPedido, CodigoDoCliente, DataDoPedido
FROM Pedidos
WHERE CodigoDaTransportadora IN (
    SELECT CodigoDaTransportadora
    FROM Transportadoras
    WHERE NomeDaEmpresa IN ('Speedy Express', 'Federal Shipping')
);

-- Q13
SELECT (
           SELECT C.NomeDaEmpresa 
           FROM Clientes C 
           WHERE C.CodigoDoCliente = P.CodigoDoCliente
       ) AS NomeDaEmpresa,
       P.NumeroDoPedido,
       P.DataDoPedido
FROM Pedidos P
WHERE (YEAR(P.DataDoPedido) = 1996 AND MONTH(P.DataDoPedido) = 8)
   OR (YEAR(P.DataDoPedido) = 1997 AND MONTH(P.DataDoPedido) = 9);

-- Q14
SELECT *
FROM Pedidos
WHERE CodigoDoCliente IN (
    SELECT CodigoDoCliente
    FROM Clientes
    WHERE Fax IS NULL
);

-- Q15
SELECT NomeDaEmpresa
FROM Clientes
WHERE CodigoDoCliente IN (
    SELECT P.CodigoDoCliente
    FROM Pedidos P
    JOIN Detalhes_do_Pedido DP ON P.NumeroDoPedido = DP.NumeroDoPedido
    GROUP BY P.CodigoDoCliente
    HAVING SUM([PrecoUnitário] * Quantidade - Desconto) > (
        SELECT AVG(TotalPorPedido)
        FROM (
            SELECT SUM([PrecoUnitário] * Quantidade - Desconto) AS TotalPorPedido
            FROM Detalhes_do_Pedido
            GROUP BY NumeroDoPedido
        ) AS MediaDosPedidos
    )
);

-- Q16
SELECT Nome, Sobrenome
FROM Funcionarios
WHERE DATEDIFF(year, DataDeNascimento, GETDATE()) < (
    SELECT AVG(DATEDIFF(year, DataDeNascimento, GETDATE()))
    FROM Funcionarios
);

-- Q17
SELECT Nome, Sobrenome
FROM Funcionarios
WHERE CodigoDoFuncionario IN (
    SELECT CodigoDoFuncionario
    FROM Pedidos
    GROUP BY CodigoDoFuncionario
    HAVING COUNT(NumeroDoPedido) > (
        SELECT AVG(TotalPedidosPorFunc)
        FROM (
            SELECT COUNT(NumeroDoPedido) * 1.0 AS TotalPedidosPorFunc
            FROM Pedidos
            GROUP BY CodigoDoFuncionario
        ) AS MediaPedidos
    )
);

-- Q18
SELECT NumeroDoPedido
FROM Pedidos
WHERE CodigoDoCliente IN (
    SELECT CodigoDoCliente
    FROM Clientes
    WHERE Fax IS NULL
);

-- Q19
SELECT NomeDaEmpresa
FROM Clientes
WHERE CodigoDoCliente NOT IN (
    SELECT DISTINCT CodigoDoCliente
    FROM Pedidos
    WHERE CodigoDoCliente IS NOT NULL
);

-- Q20
SELECT *
FROM Pedidos
WHERE NumeroDoPedido IN (
    SELECT NumeroDoPedido
    FROM Detalhes_do_Pedido
    WHERE CodigoDoProduto IN (
        SELECT CodigoDoProduto
        FROM Produtos
        WHERE CodigoDaCategoria = (
            SELECT CodigoDaCategoria
            FROM Categorias
            WHERE NomeDaCategoria = 'Bebidas'
        )
    )
);

-- Q21
SELECT DISTINCT Nome, Sobrenome
FROM Funcionarios
WHERE CodigoDoFuncionario IN (
    SELECT CodigoDoFuncionario
    FROM Pedidos
    WHERE CodigoDoCliente IN (
        SELECT CodigoDoCliente
        FROM Clientes
        WHERE NomeDaEmpresa IN ('Antonio Moreno Taquería', 'Blauer See Delikatessen', 'Ernst Handel')
    )
);

-- Q22
SELECT DISTINCT NomeDaEmpresa
FROM Clientes
WHERE CodigoDoCliente IN (
    SELECT CodigoDoCliente
    FROM Pedidos
    WHERE Frete > (
        SELECT AVG(Frete) 
        FROM Pedidos
    )
);

-- Q23
SELECT DISTINCT NomeDoProduto
FROM Produtos
WHERE CodigoDoProduto IN (
    SELECT CodigoDoProduto
    FROM Detalhes_do_Pedido
    WHERE Desconto < (
        SELECT AVG(CAST(Desconto AS float)) 
        FROM Detalhes_do_Pedido
    )
);

-- Q24
SELECT DISTINCT NomeDaEmpresa
FROM Fornecedores
WHERE CodigoDoFornecedor IN (
    SELECT CodigoDoFornecedor
    FROM Produtos
    WHERE PrecoUnitario > (
        SELECT AVG(PrecoUnitario) 
        FROM Produtos
    )
);

-- Q25
SELECT NomeDoProduto
FROM Produtos
WHERE UnidadesEmEstoque < (
    SELECT AVG(CAST(Quantidade AS float))
    FROM Detalhes_do_Pedido
);