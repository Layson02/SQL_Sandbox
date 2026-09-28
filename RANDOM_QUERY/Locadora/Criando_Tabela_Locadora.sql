-- 1. Abrir o banco de dados
 IF DB_ID(N'Locadora') IS NULL
 BEGIN
     CREATE DATABASE Locadora;
 END
 GO


-- Usar o banco de dados Locadora

USE Locadora;
GO

-- 2. Criar as tabelas
CREATE TABLE Filme (
    IDFilme INT PRIMARY KEY
        CONSTRAINT CHK_Filme_ID CHECK (IDFilme >= 1 AND IDFilme <= 2000),
    Nome VARCHAR(30) NOT NULL,
    Duracao INT,
    Categoria VARCHAR(13)
);

CREATE TABLE Ator (
    IDAtor INT PRIMARY KEY
        CONSTRAINT CHK_Ator_ID CHECK (IDAtor >= 1 AND IDAtor <= 999),
    Ator VARCHAR(20) NOT NULL,
    Cache SMALLINT CONSTRAINT chk_cache CHECK (Cache <= 45000),
    Produtora VARCHAR(30)
);

CREATE TABLE TipoParticipacao (
    IDTipo INT PRIMARY KEY
        CONSTRAINT CHK_Tipo_ID CHECK (IDTipo >= 1 AND IDTipo <= 100),
    Tipo VARCHAR(30) NOT NULL
);

CREATE TABLE Filme_Ator (
    IDFilme INT NOT NULL,
    IDAtor INT NOT NULL,
    IDTipo INT NOT NULL,
    CONSTRAINT PK_Filme_Ator PRIMARY KEY (IDFilme, IDAtor),
    CONSTRAINT FK_FilmeAtor_Filme FOREIGN KEY (IDFilme) REFERENCES Filme(IDFilme),
    CONSTRAINT FK_FilmeAtor_Ator FOREIGN KEY (IDAtor) REFERENCES Ator(IDAtor),
    CONSTRAINT FK_FilmeAtor_Tipo FOREIGN KEY (IDTipo) REFERENCES TipoParticipacao(IDTipo)
);
GO
