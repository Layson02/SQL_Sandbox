USE [bdpedido];
GO

-- Q1

SELECT CodigoDoProduto, Desconto
FROM Detalhes_do_Pedido;

-- Q2

SELECT CodigoDoProduto
FROM Detalhes_do_Pedido;

-- Q3

SELECT CodigoDoCliente
FROM Pedidos;

-- Q4

SELECT NomeDaEmpresa AS [NomeDoCliente], Endereco, 'Cliente preferencial' AS [Classificacao]
FROM Clientes;

-- Q5

SELECT TOP 25 PERCENT *
FROM Produtos;

-- Q6

SELECT TOP 50 PERCENT *
FROM Funcionarios;

-- Q7

SELECT TOP 10 PERCENT *
FROM Pedidos;

-- Q8

SELECT TOP 17 PERCENT *
FROM Fornecedores;

-- Q9

SELECT TOP 85 PERCENT *
FROM Categorias;

-- Q10

SELECT DISTINCT Cidade
FROM Funcionarios;

-- Q11

SELECT DISTINCT Regiao
FROM Funcionarios;

-- Q12

SELECT DISTINCT Pais
FROM Fornecedores;

-- Q13

SELECT DISTINCT CodigoDoCliente
FROM Pedidos;

-- Q14

SELECT DISTINCT CodigoDoProduto
FROM Detalhes_do_Pedido;

-- Q15

SELECT CodigoDoProduto, NomeDoProduto, PrecoUnitario,
       (PrecoUnitario * 1.07) AS [PrecoComAcrescimo]
FROM Produtos;

-- Q16

SELECT NumeroDoPedido, PrecoUnitário, Desconto,
       (PrecoUnitário - (PrecoUnitário * Desconto)) AS [Preço Final]
FROM Detalhes_do_Pedido;

-- Q17

SELECT NumeroDoPedido,
       (PrecoUnitário * Quantidade) AS [Preço Total],
       ((PrecoUnitário * Quantidade) - ((PrecoUnitário * Quantidade) * Desconto)) AS [Preço Final]
FROM Detalhes_do_Pedido;

-- Q18

SELECT PrecoUnitario,
       (PrecoUnitario * 1.25) AS [PrecoComAcrescimoDe25],
       (PrecoUnitario * 1.35) AS [PrecoComAcrescimoDe35],
       (PrecoUnitario * 1.45) AS [PrecoComAcrescimoDe45]
FROM Produtos;

-- Q19

SELECT NumeroDoPedido, Frete,
       (Frete * 1.05) AS [FreteComAcrescimoDe5],
       (Frete * 1.10) AS [FreteComAcrescimoDe10]
FROM Pedidos;

-- Q20

SELECT CodigoDoProduto, NomeDoProduto, NivelDeReposicao,
       (NivelDeReposicao + 5) AS [NivelDeReposicaoComAcrescimo]
FROM Produtos;

-- Q21

SELECT CodigoDoProduto,
       (PrecoUnitario * UnidadesEmEstoque) AS [Total em Estoque]
FROM Produtos;

-- Q22

SELECT NumeroDoPedido, CodigoDoProduto, PrecoUnitário, Quantidade,
       (PrecoUnitário * Quantidade * 1.20) AS [Cheque p/ 30 dias],
       (PrecoUnitário * Quantidade * 1.30) AS [Cheque p/ 60 dias],
       (PrecoUnitário * Quantidade * 0.85) AS [À vista]
FROM Detalhes_do_Pedido;

-- Q23

SELECT CodigoDoProduto, NomeDoProduto, NivelDeReposicao,
       (NivelDeReposicao + 5) AS [NivelDeReposicaoComAcrescimo]
FROM Produtos;

-- Q24

SELECT NumeroDoPedido, CodigoDoCliente AS [Cliente], CodigoDoFuncionario,
       (Frete * 0.93) AS [Frete c/ desconto]
FROM Pedidos;

-- Q25

SELECT Nome, Sobrenome
FROM Funcionarios
ORDER BY Nome DESC;

-- Q26

SELECT CodigoDoProduto, NomeDoProduto, PrecoUnitario
FROM Produtos
ORDER BY NomeDoProduto ASC;

-- Q27

SELECT CodigoDoProduto AS [Cód.],
       NomeDoProduto AS [Produto],
       PrecoUnitario AS [P. Unitário]
FROM Produtos
ORDER BY CodigoDoProduto DESC;

-- Q28

SELECT Pais, Regiao, CodigoDoFornecedor, NomeDaEmpresa, NomeDoContato
FROM Fornecedores
ORDER BY Pais ASC, Regiao DESC, NomeDaEmpresa ASC;

-- Q29

SELECT CodigoDoFuncionario, Sobrenome, Nome
FROM Funcionarios
ORDER BY Pais ASC;