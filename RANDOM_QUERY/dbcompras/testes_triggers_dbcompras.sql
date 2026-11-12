USE dbcompras;
GO

SET XACT_ABORT ON;

-- Executa os testes em uma transação que será desfeita ao final.
BEGIN TRANSACTION;

DECLARE @IDUsuario INT = 1;
DECLARE @ContagemInicial INT;
DECLARE @PedidosTeste TABLE (IDPedidoUsuario INT);

SELECT @ContagemInicial = ContagemPedidos
FROM Usuario
WHERE IDUsuario = @IDUsuario;

INSERT INTO PedidoUsuario (IDUsuario, DataPedido)

-- Testa a inserção de vários pedidos para o mesmo usuário.
OUTPUT inserted.IDPedidoUsuario INTO @PedidosTeste
VALUES
    (@IDUsuario, CAST(N'2023-11-03' AS DATE)),
    (@IDUsuario, CAST(N'2023-11-04' AS DATE)),
    (@IDUsuario, CAST(N'2023-11-05' AS DATE));

IF (SELECT ContagemPedidos FROM Usuario WHERE IDUsuario = @IDUsuario)
    <> @ContagemInicial + 3
BEGIN
    ROLLBACK TRANSACTION;
    THROW 50001, 'A trigger de insercao nao atualizou a contagem em lote.', 1;
END;

DELETE FROM PedidoUsuario

-- Testa a exclusão dos pedidos inseridos acima.
WHERE IDPedidoUsuario IN (SELECT IDPedidoUsuario FROM @PedidosTeste);

IF (SELECT ContagemPedidos FROM Usuario WHERE IDUsuario = @IDUsuario)
    <> @ContagemInicial
BEGIN
    ROLLBACK TRANSACTION;
    THROW 50002, 'A trigger de exclusao nao atualizou a contagem em lote.', 1;
END;

ROLLBACK TRANSACTION;

SELECT N'Testes das triggers concluídos com sucesso.' AS Resultado;
