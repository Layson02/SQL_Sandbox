USE [bdpedido]
GO

-- Q1

SELECT 
    SUM(Frete) AS TotalFretePago
FROM Pedidos;


-- Q2

SELECT 
    COUNT(*) AS TotalFuncionarios1992
FROM Funcionarios
WHERE YEAR(DataDeContratacao) = 1992;


-- Q3

SELECT 
    Pais,
    COUNT(*) AS TotalFornecedores
FROM Fornecedores
GROUP BY Pais
HAVING Pais = 'Alemanha';

-- Q4

SELECT 
    SUM(Quantidade) AS TotalQuantidadesVendidas
FROM Detalhes_do_Pedido;


-- Q5

SELECT 
    MAX(Frete) AS FreteMaisCaro
FROM Pedidos;


-- Q6

SELECT 
    MIN(Desconto) AS MenorDesconto
FROM Detalhes_do_Pedido;


-- Q7

SELECT 
    CodigoDaCategoria,
    COUNT(*) AS TotalProdutos
FROM Produtos
WHERE CodigoDaCategoria = 2
GROUP BY CodigoDaCategoria;

-- Q8

SELECT 
    COUNT(*) AS TotalCategoriasComC
FROM Categorias
WHERE NomeDaCategoria LIKE 'C%';


-- Q9

SELECT 
    COUNT(*) AS TotalProdutosAbaixoReposicao
FROM Produtos
WHERE UnidadesEmEstoque < NivelDeReposicao;


-- Q10

SELECT 
    SUM(PrecoUnitario) AS ValorTotalPrecosUnitarios
FROM Produtos;


-- Q11

SELECT 
    CodigoDoProduto,
    SUM(PrecoUnitário * Quantidade) AS TotalVendido
FROM Detalhes_do_Pedido
WHERE CodigoDoProduto = 51
GROUP BY CodigoDoProduto;

-- Q12

SELECT 
    CodigoDoCliente,
    YEAR(DataDoPedido) AS Ano,
    COUNT(*) AS TotalPedidos
FROM Pedidos
WHERE CodigoDoCliente = 'ROMEY' 
  AND YEAR(DataDoPedido) = 1996
GROUP BY CodigoDoCliente, YEAR(DataDoPedido);

-- Q13

SELECT 
    MONTH(DataDeNascimento) AS Mes,
    COUNT(*) AS Aniversariantes
FROM Funcionarios
GROUP BY MONTH(DataDeNascimento)
HAVING MONTH(DataDeNascimento) = 7;


-- Q14

SELECT 
    COUNT(*) AS TotalProdutosCGN
FROM Produtos
WHERE NomeDoProduto LIKE 'C%' 
   OR NomeDoProduto LIKE 'G%' 
   OR NomeDoProduto LIKE 'N%';


-- Q15

SELECT 
    Pais,
    COUNT(*) AS TotalClientes
FROM Clientes
WHERE Pais IN ('Alemanha', 'México', 'Reino Unido')
GROUP BY Pais;

-- Q16

SELECT 
    COUNT(*) AS ClientesSemFax
FROM Clientes
WHERE Fax IS NULL;


-- Q17

SELECT 
    SUM(PrecoUnitario * UnidadesEmEstoque) AS TotalValorEstoque
FROM Produtos;


-- Q18

SELECT 
    SUM(PrecoUnitário * Quantidade) AS TotalGeralVendido
FROM Detalhes_do_Pedido;


-- Q19

SELECT 
    CodigoDoProduto,
    SUM(PrecoUnitário * Quantidade) AS TotalVendido
FROM Detalhes_do_Pedido
WHERE CodigoDoProduto = 19
GROUP BY CodigoDoProduto;

-- Q20

SELECT 
    CodigoDoCliente,
    SUM(Frete) AS TotalFrete
FROM Pedidos
WHERE CodigoDoCliente = 'LILAS'
GROUP BY CodigoDoCliente;