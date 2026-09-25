-- 1. Abrir o banco de dados
 IF DB_ID(N'Locadora') IS NULL
 BEGIN
     CREATE DATABASE Locadora;
 END
 GO

-- 2. Criar as tabelas
CREATE TABLE Filme (
    IDFilme INT PRIMARY KEY,
    Nome VARCHAR(30) NOT NULL,
    Duracao INT,
    Categoria VARCHAR(13)
);

CREATE TABLE Ator (
    IDAtor INT PRIMARY KEY,
    Ator VARCHAR(20) NOT NULL,
    Cache SMALLINT CONSTRAINT chk_cache CHECK (Cache <= 45000)
);

CREATE TABLE TipoParticipacao (
    IDTipo INT PRIMARY KEY,
    Tipo VARCHAR(30) NOT NULL
);

CREATE TABLE Filme_Ator (
    IDFilme INT NOT NULL,
    IDAtor INT NOT NULL,
    IDTipo INT NOT NULL,
);

-- 10. Criar tabela Controle Exclusao
CREATE TABLE Controle_Exclusao (
    IDExclusao INT IDENTITY(1,1) PRIMARY KEY,
    IDFilme INT,
    IDAtor INT,
    IDTipo INT
);
GO
