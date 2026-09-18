USE Locadora;
GO

-- 4. Inserir dados na tabela Filme
INSERT INTO Filme (IDFilme, Nome, Duracao, Categoria) VALUES
(1, 'Xuxa e os duendes', 180, 'Infantil'),
(2, 'Super-Homem', 200, 'Aventura'),
(3, 'Senhor dos Anéis', 450, 'Ficção'),
(4, 'Triplo X', 180, 'Ação'),
(5, 'A procura de Nemo', 180, 'Infantil'),
(6, 'Connan', 300, 'Ação');

-- 4. Inserir dados na tabela TipoParticipacao
INSERT INTO TipoParticipacao (IDTipo, Tipo) VALUES
(1, 'Ator Principal'),
(2, 'Ator Secundário'),
(3, 'Figurante'),
(4, 'Duble'),
(5, 'Participação Especial');

-- 4. Inserir dados na tabela Ator
-- Nota: Cache ajustado para numérico sem ponto/vírgula. Produtora inserida como ID conforme o tipo SmallInt da tabela.
INSERT INTO Ator (IDAtor, Ator, Cache) VALUES
(1, 'Tom Hanks', 20000),
(2, 'Meryl Streep', 15000),
(3, 'Leonardo DiCaprio', 25000),
(4, 'Jennifer Lawrence', 18000),
(5, 'Robert Downey Jr.', 13000),
(6, 'Angelina Jolie', 22000),
(7, 'Will Smith', 28000),
(8, 'Scarlett Johansson', 27000);

-- 5. Insira alguns registros na tabela Filme_Ator [cite: 40]
INSERT INTO Filme_Ator (IDFilme, IDAtor, IDTipo) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 1),
(4, 4, 1),
(5, 5, 5);
GO