USE dbcompras;
GO

-- Criar a trigger para atualizar a contagem de pedidos quando um novo pedido é inserido
CREATE OR ALTER TRIGGER trg_AfterInsertPedidoUsuario
ON PedidoUsuario
AFTER INSERT
AS
BEGIN
    UPDATE Usuario
    SET ContagemPedidos = ContagemPedidos + i.Quantidade
    FROM Usuario u
    INNER JOIN (
        SELECT IDUsuario, COUNT(*) AS Quantidade
        FROM inserted
        GROUP BY IDUsuario
    ) i ON u.IDUsuario = i.IDUsuario;
END;
GO

-- Criar a trigger para atualizar a contagem de pedidos quando um pedido é excluído
CREATE OR ALTER TRIGGER trg_AfterDeletePedido
ON PedidoUsuario
AFTER DELETE
AS
BEGIN
    UPDATE Usuario
    SET ContagemPedidos = ContagemPedidos - d.Quantidade
    FROM Usuario u
    INNER JOIN (
        SELECT IDUsuario, COUNT(*) AS Quantidade
        FROM deleted
        GROUP BY IDUsuario
    ) d ON u.IDUsuario = d.IDUsuario;
END;
GO
