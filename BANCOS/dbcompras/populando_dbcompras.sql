USE dbcompras;
GO

-- Povoando a Tabela de Usuario
-- Insere os usuários que ainda não estiverem cadastrados.
INSERT INTO Usuario (NomeUsuario, ContagemPedidos)
SELECT dados.NomeUsuario, dados.ContagemPedidos
FROM (VALUES
    (N'Maria Carla', 0),
    (N'Pedro Lima', 0),
    (N'Joao Carlos', 0),
    (N'Adalberto Silva', 0),
    (N'Emanuel Salerno', 0),
    (N'Silvano Dantas', 0)
) AS dados(NomeUsuario, ContagemPedidos)
WHERE NOT EXISTS (
    SELECT 1
    FROM Usuario u
    WHERE u.NomeUsuario = dados.NomeUsuario
);
GO

-- Povoando a Tabela de Pedidos
-- Insere os pedidos que ainda não estiverem cadastrados.
INSERT INTO PedidoUsuario (IDUsuario, DataPedido)
SELECT dados.IDUsuario, dados.DataPedido
FROM (VALUES
    (1, CAST(N'2023-10-02' AS DATE)),
    (2, CAST(N'2023-10-03' AS DATE)),
    (3, CAST(N'2023-10-03' AS DATE)),
    (4, CAST(N'2023-10-04' AS DATE)),
    (1, CAST(N'2023-10-05' AS DATE)),
    (2, CAST(N'2023-10-05' AS DATE)),
    (3, CAST(N'2023-10-05' AS DATE)),
    (4, CAST(N'2023-10-06' AS DATE)),
    (1, CAST(N'2023-10-06' AS DATE)),
    (2, CAST(N'2023-10-07' AS DATE)),
    (3, CAST(N'2023-10-07' AS DATE)),
    (4, CAST(N'2023-10-07' AS DATE)),
    (1, CAST(N'2023-10-08' AS DATE)),
    (2, CAST(N'2023-10-08' AS DATE))
) AS dados(IDUsuario, DataPedido)
WHERE NOT EXISTS (
    SELECT 1
    FROM PedidoUsuario p
    WHERE p.IDUsuario = dados.IDUsuario
      AND p.DataPedido = dados.DataPedido
);
GO
