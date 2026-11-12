USE [bdpedido]
GO

-- Q1

IF COL_LENGTH(N'Pedidos', N'Total_Pedido') IS NULL
BEGIN
    ALTER TABLE Pedidos
    ADD Total_Pedido smallmoney;
END;
GO


-- Q2

UPDATE p
SET Total_Pedido = COALESCE(t.TotalPedido, 0)
FROM Pedidos p
LEFT JOIN (
    SELECT
        NumeroDoPedido,
        SUM(
            PrecoUnitário * Quantidade
            * (1 - Desconto / 100.0)
        ) AS TotalPedido
    FROM Detalhes_do_Pedido
    GROUP BY NumeroDoPedido
) t ON p.NumeroDoPedido = t.NumeroDoPedido;
GO


-- Q3

CREATE OR ALTER TRIGGER trg_Clientes_AposInsercao
ON Clientes
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @QuantidadeClientes int;

    SELECT @QuantidadeClientes = COUNT(*)
    FROM Clientes;

    RAISERROR(
        'A tabela Clientes possui %d linha(s).',
        10,
        1,
        @QuantidadeClientes
    ) WITH NOWAIT;
END;
GO


-- Q4

CREATE OR ALTER TRIGGER trg_Detalhes_AposInsercao
ON Detalhes_do_Pedido
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE p
    SET Total_Pedido = t.TotalPedido
    FROM Pedidos p
    INNER JOIN (
        SELECT
            d.NumeroDoPedido,
            SUM(
                d.PrecoUnitário * d.Quantidade
                * (1 - d.Desconto / 100.0)
            ) AS TotalPedido
        FROM Detalhes_do_Pedido d
        INNER JOIN (
            SELECT DISTINCT NumeroDoPedido
            FROM inserted
        ) i ON i.NumeroDoPedido = d.NumeroDoPedido
        GROUP BY d.NumeroDoPedido
    ) t ON t.NumeroDoPedido = p.NumeroDoPedido;
END;
GO


-- Q5

CREATE OR ALTER TRIGGER trg_Detalhes_VerificaEstoque
ON Detalhes_do_Pedido
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM (
            SELECT
                CodigoDoProduto,
                SUM(Quantidade) AS QuantidadeSolicitada
            FROM inserted
            GROUP BY CodigoDoProduto
        ) i
        INNER JOIN Produtos p
            ON p.CodigoDoProduto = i.CodigoDoProduto
        WHERE i.QuantidadeSolicitada > p.UnidadesEmEstoque
    )
    BEGIN
        THROW 50001,
            'Impossivel fornecer o produto: estoque insuficiente.',
            1;
    END;
END;
GO


-- Q6

CREATE OR ALTER TRIGGER trg_Pedidos_AntesDaExclusao
ON Pedidos
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DELETE d
    FROM Detalhes_do_Pedido d
    INNER JOIN deleted x
        ON x.NumeroDoPedido = d.NumeroDoPedido;

    DELETE p
    FROM Pedidos p
    INNER JOIN deleted x
        ON x.NumeroDoPedido = p.NumeroDoPedido;
END;
GO
