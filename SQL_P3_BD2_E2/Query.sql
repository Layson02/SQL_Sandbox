-- Q1

SELECT CodigoDoCliente, NomeDaEmpresa, Endereco 
FROM Clientes;

-- Q2

SELECT SobreNome, Nome, DataDeNascimento, DataDeContratacao 
FROM Funcionarios;

-- Q3

SELECT CodigoDaCategoria, NomeDaCategoria, Descricao 
FROM Categorias;

-- Q4

SELECT NomeDaEmpresa, NomeDoContato, Telefone 
FROM Fornecedores;

-- Q5

SELECT CodigoDoProduto, NomeDoProduto, PrecoUnitario 
FROM Produtos;

-- Q6

SELECT CodigoDaTransportadora, NomeDaEmpresa, Telefone 
FROM Transportadoras;

-- Q7

SELECT NomeDaEmpresa, Endereco, 'Cliente preferencial' AS Classificação 
FROM Clientes;

-- Q8

SELECT CodigoDoProduto, 'Produto existente' AS Status, NomeDoProduto 
FROM Produtos;

-- Q9

SELECT Endereco, TelefoneResidencial, 'Ramal' AS PertenceaoQuadro, 'Ativo' AS Situação 
FROM Funcionarios;

-- Q10

SELECT NomeDaCategoria, Descricao, 'InformaçãoAdicional' AS Definição 
FROM Categorias;

-- Q11

SELECT TOP 5 * 
FROM Pedidos;

-- Q12

SELECT TOP 15 * 
FROM Funcionarios;

-- Q13

SELECT TOP 3 NomeDaEmpresa 
FROM Fornecedores;

-- Q14

SELECT TOP 20 * 
FROM Produtos;

-- Q15

SELECT TOP 2 * 
FROM Categorias;

-- Q16

SELECT Nome AS Funcionário, Cargo AS Função, Tratamento AS Título 
FROM Funcionarios;

-- Q17

SELECT NomeDaEmpresa AS Empresa, NomeDoContato AS Contato, CargoDoContato AS Cargo 
FROM Fornecedores;

-- Q18

SELECT Nome, TelefoneResidencial AS Fone, Observacoes AS Obs 
FROM Funcionarios;

-- Q19

SELECT NomeDaCategoria AS Categoria, Descricao AS Observação, 'Aprovado' AS Situação 
FROM Categorias;

-- Q20

SELECT CodigoDoProduto, NomeDoProduto, PrecoUnitario, (PrecoUnitario * 1.07) AS PreçoComAcréscimo 
FROM Produtos;

-- Q21

SELECT Nome, SobreNome 
FROM Funcionarios 
ORDER BY Nome DESC;

-- Q22

SELECT CodigoDoProduto, NomeDoProduto, PrecoUnitario 
FROM Produtos 
ORDER BY NomeDoProduto ASC;

-- Q23

SELECT CodigoDoProduto AS "Cód.", NomeDoProduto AS Produto, PrecoUnitario AS "P. Unitário" 
FROM Produtos 
ORDER BY CodigoDoProduto DESC;

-- Q24

SELECT Pais, Regiao, CodigoDoFornecedor, NomeDaEmpresa, NomeDoContato 
FROM Fornecedores 
ORDER BY Pais ASC, Regiao DESC, NomeDaEmpresa ASC;

-- Q25

SELECT CodigoDoFuncionario, SobreNome, Nome 
FROM Funcionarios 
ORDER BY Pais ASC;

