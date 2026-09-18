USE [bdpedido]
GO

-- Q1

SELECT SUM(Frete) AS TotalFrete
FROM Pedidos;

-- Q2

SELECT COUNT(*) AS Contratados1992
FROM Funcionarios
WHERE YEAR(DataDeContratacao) = 1992;

-- Q3

SELECT COUNT(*) AS FornecedoresAlemanha
FROM Fornecedores
WHERE Pais = 'Alemanha';

-- Q4

SELECT SUM(Quantidade) AS TotalQuantidadesVendidas
FROM Detalhes_do_Pedido;

-- Q5

SELECT MAX(Frete) AS FreteMaisCaro
FROM Pedidos;

-- Q6

SELECT MIN(Desconto) AS MenorDesconto
FROM Detalhes_do_Pedido;

-- Q7

SELECT COUNT(*) AS TotalProdutosCondimentos
FROM Produtos
WHERE CodigoDaCategoria = 2;

-- Q8

SELECT COUNT(*) AS CategoriasIniciadasComC
FROM Categorias
WHERE NomeDaCategoria LIKE 'C%';

-- Q9

SELECT COUNT(*) AS EstoqueAbaixoDoNivel
FROM Produtos
WHERE UnidadesEmEstoque < NivelDeReposicao;

-- Q10

SELECT SUM(PrecoUnitario) AS SomaPrecosUnitarios
FROM Produtos;

-- Q11

SELECT SUM([PrecoUnitário] * Quantidade) AS TotalVendidoProduto51
FROM Detalhes_do_Pedido
WHERE CodigoDoProduto = 51;

-- Q12

SELECT COUNT(*) AS PedidosRomey1996
FROM Pedidos
WHERE CodigoDoCliente = 'ROMEY' 
  AND YEAR(DataDoPedido) = 1996;

-- Q13

SELECT COUNT(*) AS AniversariantesJulho
FROM Funcionarios
WHERE MONTH(DataDeNascimento) = 7;

-- Q14

SELECT COUNT(*) AS ProdutosCGN
FROM Produtos
WHERE NomeDoProduto LIKE '[CGN]%';

-- Q15

SELECT COUNT(*) AS ClientesPaisesEspecificos
FROM Clientes
WHERE Pais IN ('Alemanha', 'México', 'Reino Unido');

-- Q16

SELECT COUNT(*) AS ClientesSemFax
FROM Clientes
WHERE Fax IS NULL;

-- Q17

SELECT SUM(PrecoUnitario * UnidadesEmEstoque) AS ValorTotalEstoque
FROM Produtos;

-- Q18

SELECT SUM([PrecoUnitário] * Quantidade) AS TotalGeralVendido
FROM Detalhes_do_Pedido;

-- Q19

SELECT SUM([PrecoUnitário] * Quantidade) AS TotalVendidoProduto19
FROM Detalhes_do_Pedido
WHERE CodigoDoProduto = 19;

-- Q20

SELECT SUM(Frete) AS FreteTotalLILAS
FROM Pedidos
WHERE CodigoDoCliente = 'LILAS';