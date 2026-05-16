create database estoque;
use estoque;

create table Categoria (
	id_Categoria INT PRIMARY KEY,
	nomeCategoria VARCHAR(50) NOT NULL
);

create table Produto (
	id_Produto INT PRIMARY KEY,
	descricao VARCHAR(50) NOT NULL,
	unidade VARCHAR(2) NOT NULL,
	valor INT NOT NULL,
	codigoCategoria INT,
	FOREIGN KEY (codigoCategoria) REFERENCES Categoria(id_Categoria)
)

INSERT INTO Categoria (id_Categoria, nomeCategoria) VALUES 
(1, 'Informática'),
(2, 'Alimentos'),
(3, 'Limpeza'),
(4, 'Papelaria'),
(5, 'Eletrônicos');

INSERT INTO Produto (id_Produto, descricao, unidade, valor, CodigoCategoria) VALUES 
(101, 'Mouse sem fio', 'un', 85, 1),
(102, 'Teclado Mecânico', 'un', 250, 1),
(103, 'Monitor 24 pol', 'un', 800, 1),
(104, 'Arroz 5kg', 'un', 25, 2),
(105, 'Feijão 1kg', 'un', 9, 2),
(106, 'Detergente', 'un', 3, 3),
(107, 'Caderno 10 matérias', 'un', 35, 4),
(108, 'Caneta Azul', 'un', 2, 4),
(109, 'Smartphone X', 'un', 1500, 5),
(110, 'Fone Bluetooth', 'un', 120, 5);

SELECT * FROM Produto;
SELECT descricao, valor FROM PRODUTO;
SELECT * FROM PRODUTO WHERE valor > 100;
SELECT * FROM PRODUTO ORDER BY valor ASC;
SELECT P.descricao, P.valor, C.nomeCategoria 
FROM PRODUTO P
INNER JOIN CATEGORIA C ON P.CodigoCategoria = C.id_Categoria;
SELECT P.descricao, C.nomeCategoria
FROM PRODUTO P
INNER JOIN CATEGORIA C ON P.CodigoCategoria = C.id_Categoria
WHERE C.nomeCategoria = 'Informática';
SELECT COUNT(*) AS 'Total de Produtos' FROM PRODUTO;