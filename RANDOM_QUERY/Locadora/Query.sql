USE Locadora;
GO

-- Q1

-- CREATE DATABASE Locadora;
-- GO

-- Q2

-- CREATE TABLE Filme (
    -- IDFilme INT NOT NULL,
    -- Nome VARCHAR(30) NOT NULL,
    -- Duracao INT,
    -- Categoria VARCHAR(13)
-- );

-- CREATE TABLE Ator (
    -- IDAtor INT NOT NULL,
    -- Ator VARCHAR(20) NOT NULL,
    -- Cache SMALLINT,
    -- Produtora VARCHAR(30)
-- );

-- CREATE TABLE TipoParticipacao (
    -- IDTipo INT NOT NULL,
    -- Tipo VARCHAR(30) NOT NULL
-- );

-- CREATE TABLE Filme_Ator (
    -- IDFilme INT NOT NULL,
    -- IDAtor INT NOT NULL,
    -- IDTipo INT NOT NULL
-- );

-- Q3 -----------------------

-- Chaves Primárias (PK)

ALTER TABLE Filme
    ADD CONSTRAINT PK_Filme PRIMARY KEY (IDFilme);

ALTER TABLE Ator
    ADD CONSTRAINT PK_Ator PRIMARY KEY (IDAtor);

ALTER TABLE TipoParticipacao
    ADD CONSTRAINT PK_TipoParticipacao PRIMARY KEY (IDTipo);

ALTER TABLE Filme_Ator
    ADD CONSTRAINT PK_Filme_Ator PRIMARY KEY (IDFilme, IDAtor);

-- Constraints

ALTER TABLE Filme
    ADD CONSTRAINT CHK_Filme_ID CHECK (IDFilme >= 1 AND IDFilme <= 2000);

ALTER TABLE Ator
    ADD CONSTRAINT CHK_Ator_ID CHECK (IDAtor >= 1 AND IDAtor <= 999),
    CONSTRAINT CHK_Ator_Cache CHECK (Cache <= 45000);

ALTER TABLE TipoParticipacao
    ADD CONSTRAINT CHK_Tipo_ID CHECK (IDTipo >= 1 AND IDTipo <= 100);

-- Chaves Estrangeiras (FK)
ALTER TABLE Filme_Ator
    ADD CONSTRAINT FK_FilmeAtor_Filme FOREIGN KEY (IDFilme) REFERENCES Filme(IDFilme),
    CONSTRAINT FK_FilmeAtor_Ator FOREIGN KEY (IDAtor) REFERENCES Ator(IDAtor),
    CONSTRAINT FK_FilmeAtor_Tipo FOREIGN KEY (IDTipo) REFERENCES TipoParticipacao(IDTipo);

-- Q4

INSERT INTO Filme (IDFilme, Nome, Duracao, Categoria) VALUES
(1, 'Xuxa e os duendes', 180, 'Infantil'),
(2, 'Super-Homem', 200, 'Aventura'),
(3, 'Senhor dos Anéis', 450, 'Ficção'),
(4, 'Triplo X', 180, 'Ação'),
(5, 'A procura de Nemo', 180, 'Infantil'),
(6, 'Connan', 300, 'Ação');

INSERT INTO TipoParticipacao (IDTipo, Tipo) VALUES
(1, 'Ator Principal'),
(2, 'Ator Secundário'),
(3, 'Figurante'),
(4, 'Duble'),
(5, 'Participação Especial');

INSERT INTO Ator (IDAtor, Ator, Cache, Produtora) VALUES
(1, 'Tom Hanks', 20000, 'Universal Pictures'),
(2, 'Meryl Streep', 15000, 'Warner Bros.'),
(3, 'Leonardo DiCaprio', 25000, 'Paramount Pictures'),
(4, 'Jennifer Lawrence', 18000, '20th Century Studios'),
(5, 'Robert Downey Jr.', 13000, 'Marvel Studios'),
(6, 'Angelina Jolie', 22000, 'Columbia Pictures'),
(7, 'Will Smith', 28000, 'Sony Pictures'),
(8, 'Scarlett Johansson', 27000, 'Disney');

-- Q5
INSERT INTO Filme_Ator (IDFilme, IDAtor, IDTipo) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 1),
(4, 4, 1),
(5, 5, 5);

-- Q6
UPDATE Filme
SET Duracao = 200
WHERE Nome = 'Triplo X';

-- Q7
UPDATE Filme
SET Categoria = 'Aventura'
WHERE Nome = 'Connan';

-- Q8
-- Se houver constraint de chave estrangeira ativa, remova o vínculo em Filme_Ator primeiro:
-- DELETE FROM Filme_Ator WHERE IDTipo = 2;
DELETE FROM TipoParticipacao
WHERE IDTipo = 2;

-- Q9
-- Se houver constraint de chave estrangeira ativa, remova o vínculo em Filme_Ator primeiro:
-- DELETE FROM Filme_Ator WHERE IDFilme IN (SELECT IDFilme FROM Filme WHERE Duracao > 410);
DELETE FROM Filme
WHERE Duracao > 410;

-- Q10
CREATE TABLE Controle_Exclusao (
    IDExclusao INT IDENTITY(1,1) PRIMARY KEY,
    IDFilme INT,
    IDAtor INT,
    IDTipo INT
);