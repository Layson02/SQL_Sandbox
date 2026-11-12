-- Criando o Banco de Dados
-- Cria o banco somente se ele ainda não existir.
IF DB_ID(N'dbcompras') IS NULL
BEGIN
    EXEC(N'CREATE DATABASE dbcompras');
END;
GO

-- Acessando o Banco de Dados
USE dbcompras;
GO

-- Criar a tabela Usuario
-- Armazena os usuários e a quantidade de pedidos de cada um.
IF OBJECT_ID(N'dbo.Usuario', N'U') IS NULL
BEGIN
    CREATE TABLE Usuario (
        IDUsuario INT IDENTITY(1,1) PRIMARY KEY,
        NomeUsuario VARCHAR(50) NOT NULL,
        ContagemPedidos INT NOT NULL
            CONSTRAINT DF_Usuario_ContagemPedidos DEFAULT (0)
    );
END;
GO

-- Criar a tabela Pedidos
-- Armazena os pedidos e relaciona cada registro ao seu usuário.
IF OBJECT_ID(N'dbo.PedidoUsuario', N'U') IS NULL
BEGIN
    CREATE TABLE PedidoUsuario (
        IDPedidoUsuario INT IDENTITY(1,1) PRIMARY KEY,
        IDUsuario INT NOT NULL,
        DataPedido DATE NOT NULL,
        CONSTRAINT FK_PedidoUsuario_Usuario
            FOREIGN KEY (IDUsuario) REFERENCES Usuario(IDUsuario)
    );
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = N'FK_PedidoUsuario_Usuario'
      AND parent_object_id = OBJECT_ID(N'dbo.PedidoUsuario')
)
BEGIN
    -- Garante o relacionamento entre pedidos e usuários em bancos já existentes.
    ALTER TABLE PedidoUsuario
        ADD CONSTRAINT FK_PedidoUsuario_Usuario
            FOREIGN KEY (IDUsuario) REFERENCES Usuario(IDUsuario);
END;
