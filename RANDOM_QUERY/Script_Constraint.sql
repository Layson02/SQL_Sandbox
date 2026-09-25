USE [bdpedido];
GO
SELECT NomeDoProduto, PrecoUnitario from Produtos
WHERE PrecoUnitario = 0;

-- Criando uma Constraint para o atributo do PrecoUnit�rio
ALTER TABLE Produtos
	ADD CONSTRAINT CHK_PrecoValido CHECK (PrecoUnitario >= 0);

-- Apagando a Constraint
ALTER TABLE Produtos
	DROP CONSTRAINT CHK_PrecoValido;

-- Criando novamente a Constraint apagada
ALTER TABLE Produtos
	ADD CONSTRAINT CHK_PrecoValido CHECK (PrecoUnitario > 0);

-- Criando uma Constraint em Funcion�rios
-- para definir os tipos de Cargos Existente
ALTER TABLE Funcionarios
ADD CONSTRAINT CHK_Cargo CHECK (Cargo in ('Coordenador de Vendas Internas',
'Gerente de Vendas', 'Representante de Vendas', 'Vice-Presidente de Vendas'));

-- Criando uma Constraint em Fornecedor
-- para definir os tipos de Cargos Existente
ALTER TABLE Fornecedores
ADD CONSTRAINT UQ_Telefone UNIQUE (Telefone);

ALTER TABLE Pedidos
ADD CONSTRAINT FK_ClienteID FOREIGN KEY (CodigoDoCliente) REFERENCES Clientes(CodigoDoCliente);

ALTER TABLE Clientes
ADD CONSTRAINT PK_ClienteID PRIMARY KEY (CodigoDoCliente);

