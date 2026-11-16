-- Faz a inserção de um registro na tabela Transportadores
insert Transportadoras (NomeDaEmpresa,Telefone) 
Values ('Teste2','(83)96666-7777')

-- Faz a inserção de um registro na tabela Transportadores
insert Transportadoras Values ('Teste3','(83)98888-7777')

-- Faz uma alteração no registro cujo CodigoDaTranportadora é igual a 6
update Transportadoras
set NomeDaEmpresa='Teste4'
where CodigoDaTransportadora=6

-- Faz uma alteração nos registros 4, 5 e 6
update Transportadoras
set NomeDaEmpresa='Teste777'
where CodigoDaTransportadora>=4

-- Apagando registros na minha tabela Transportadoras
delete from Transportadoras where CodigoDaTransportadora=6

delete from Transportadoras where CodigoDaTransportadora>=4

-- Trabalhando com o Select simples
-- Listando os atributos de Pedidos
select *
from Pedidos

select NumeroDoPedido, Via, DataDoPedido
from Pedidos

select NumeroDoPedido Pedido, DataDoPedido
from Pedidos

select CidadeDeDestino, Frete
from Pedidos

Select *
from Detalhes_do_Pedido

-- Trabalhando com o Select e os operadores - in, between, like, not, is null...
select *
from Funcionarios
where CodigoDoFuncionario in (4,7,9)

select *
from Funcionarios
where CodigoDoFuncionario between 4 and 9

select *
from Funcionarios
where Nome like 'M%'

select *
from Funcionarios
where Nome like '_____'

select *
from Funcionarios
where Supervisor is null

select *
from Funcionarios
where Supervisor is not null

-- Trabalhando com as Funções de Agregação
-- Selecionando todos os produtos que possuem mais de 900 unidades vendidas
Select SUM(Quantidade)
from Detalhes_do_Pedido

Select AVG(Quantidade)
from Detalhes_do_Pedido

Select SUM(PrecoUnitario)
from Produtos

Select MAX(PrecoUnitario)
from Produtos

Select MIN(PrecoUnitario)
from Produtos

Select p.NomeDoProduto, SUM(d.Quantidade) SomaQuant
from Produtos p
Join Detalhes_do_Pedido d
on p.CodigoDoProduto = d.CodigoDoProduto
Group by p.NomeDoProduto Having SUM(d.Quantidade)>=900

-- Trabalhando com o Group By e Having
-- Exibir a quantidade de pedidos por funcionários e cidade de destino
Select f.Nome, p.CidadeDeDestino, Count(*) as ContPedidos
From Funcionarios f
Join Pedidos p
on f.CodigoDoFuncionario = p.CodigoDoFuncionario
Group By f.Nome, p.CidadeDeDestino Having Count(*) >=5
Order By f.Nome, p.CidadeDeDestino

select NomeDoDestinatario,sum(Frete) SomaTotal, sum(Frete)*1.1 'Valor total com 10%', sum(Frete)*0.1 'Valor de 10%'
from Pedidos
Group By NomeDoDestinatario

-- Trabalhando com o Join
-- Trabalhando com o Join em quatro tabelas

Select Tratamento, count(*)
From Funcionarios
Group By Tratamento

Select Pais, count(*) Contador
From Clientes
Group by Pais
Order By Contador Desc

Select CodigoDoProduto, Max(Quantidade) Máximo
from Detalhes_do_Pedido
Group By CodigoDoProduto

Select CodigoDoProduto, Min(Quantidade) Mínimo
from Detalhes_do_Pedido
Group By CodigoDoProduto

Select p.CodigoDoProduto, p.NomeDoProduto, AVG(Quantidade) Média
from Detalhes_do_Pedido d
join Produtos p
on d.CodigoDoProduto = p.CodigoDoProduto
Group By p.CodigoDoProduto, p.NomeDoProduto

Select p.CodigoDoProduto, p.NomeDoProduto, Count(*) Contador,
Max(Quantidade) Máximo, Min(Quantidade) Mínimo, AVG(Quantidade) Média
from Detalhes_do_Pedido d
join Produtos p
on d.CodigoDoProduto = p.CodigoDoProduto
Group By p.CodigoDoProduto, p.NomeDoProduto

Select p.CodigoDoProduto, p.NomeDoProduto, Count(*) Contador,
Max(Quantidade) Máximo, Min(Quantidade) Mínimo, AVG(Quantidade) Média
from Detalhes_do_Pedido d
join Produtos p
on d.CodigoDoProduto = p.CodigoDoProduto
Group By p.CodigoDoProduto, p.NomeDoProduto Having Count(*)>=50

select pr.NomeDoProduto, count(*) Contador
from Funcionarios f
Join Pedidos p
on f.CodigoDoFuncionario = p.CodigoDoFuncionario
Join Detalhes_do_Pedido d
on d.NumeroDoPedido = p.NumeroDoPedido
Join Produtos pr
on d.CodigoDoProduto = pr.CodigoDoProduto
Group By pr.NomeDoProduto
Order By Contador Desc

-- Identificar as categorias mais vendidas
select c.NomeDaCategoria, count(*)
from Categorias c
join Produtos p
on c.CodigoDaCategoria = p.CodigoDaCategoria
join Detalhes_do_Pedido d
on p.CodigoDoProduto = d.CodigoDoProduto
group by c.NomeDaCategoria
order by count(*) desc

-- Identificar qual o país dos fornecedores que mais foi comercializado
select f.Pais, Count(*) Contador, Sum(d.Quantidade) SomaQuantidade
from Fornecedores f
join Produtos p
on f.CodigoDoFornecedor = p.CodigoDoFornecedor
join Detalhes_do_Pedido d
on p.CodigoDoProduto = d.CodigoDoProduto
Group By f.Pais
Order By Sum(d.Quantidade) Desc

-- Trabalhando com o comando TOP
select top 5 f.Pais, Count(*) Contador, Sum(d.Quantidade) SomaQuantidade
from Fornecedores f
join Produtos p
on f.CodigoDoFornecedor = p.CodigoDoFornecedor
join Detalhes_do_Pedido d
on p.CodigoDoProduto = d.CodigoDoProduto
Group By f.Pais
Order By Sum(d.Quantidade) Desc

-- Trabalhando com o Distinct
Select Distinct Pais
From Clientes
Order By Pais

select Distinct Pais, Regiao
from Clientes

select Distinct cidade, Regiao, Pais
from Clientes

-- Trabalhando com CONSTRAINTS

-- Criando uma constraint UNIQUE
-- Impede que duas transportadoras possuam exatamente o mesmo
-- telefone.
-- Atenção: se já houver telefones repetidos, a criação falhará.
ALTER TABLE Transportadoras
ADD CONSTRAINT UQ_Transportadoras_Telefone
UNIQUE (Telefone);


-- Criando uma constraint CHECK
-- Impede que sejam cadastrados preços unitários negativos.
ALTER TABLE Produtos
ADD CONSTRAINT CK_Produtos_PrecoUnitario
CHECK (PrecoUnitario >= 0);


-- Criando uma constraint DEFAULT
-- Quando o frete não for informado em um novo pedido, será
-- utilizado o valor 0.
ALTER TABLE Pedidos
ADD CONSTRAINT DF_Pedidos_Frete
DEFAULT 0 FOR Frete;

-- Trabalhando com Subquery
-- 
-- Lista os produtos cujo preço é maior que o preço médio de
-- todos os produtos.
SELECT NomeDoProduto, PrecoUnitario
FROM Produtos
WHERE PrecoUnitario > (
    SELECT AVG(PrecoUnitario)
    FROM Produtos
);


-- Subquery com IN
-- Lista os clientes que possuem pelo menos um pedido.
SELECT CodigoDoCliente, NomeDaEmpresa
FROM Clientes
WHERE CodigoDoCliente IN (
    SELECT CodigoDoCliente
    FROM Pedidos
);


-- Subquery com NOT IN
-- Lista os clientes que não aparecem na tabela Pedidos.
SELECT CodigoDoCliente, NomeDaEmpresa
FROM Clientes
WHERE CodigoDoCliente NOT IN (
    SELECT CodigoDoCliente
    FROM Pedidos
    WHERE CodigoDoCliente IS NOT NULL
);

-- Subquery com EXISTS
-- Lista os fornecedores que possuem pelo menos um produto
-- cadastrado.
SELECT f.CodigoDoFornecedor, f.NomeDaEmpresa
FROM Fornecedores f
WHERE EXISTS (
    SELECT 1
    FROM Produtos p
    WHERE p.CodigoDoFornecedor = f.CodigoDoFornecedor
);


-- Subquery com NOT EXISTS
-- Lista os fornecedores que não possuem produtos cadastrados.
SELECT f.CodigoDoFornecedor, f.NomeDaEmpresa
FROM Fornecedores f
WHERE NOT EXISTS (
    SELECT 1
    FROM Produtos p
    WHERE p.CodigoDoFornecedor = f.CodigoDoFornecedor
);


-- Subquery correlacionada
-- Para cada produto, compara o seu preço com o preço médio
-- dos produtos da mesma categoria.
SELECT
    p.NomeDoProduto,
    p.CodigoDaCategoria,
    p.PrecoUnitario
FROM Produtos p
WHERE p.PrecoUnitario > (
    SELECT AVG(p2.PrecoUnitario)
    FROM Produtos p2
    WHERE p2.CodigoDaCategoria = p.CodigoDaCategoria
);


-- Subquery na cláusula FROM
-- Primeiro calcula a quantidade total vendida por produto.
-- Depois seleciona somente os produtos cuja soma seja maior
-- ou igual a 100 unidades.
SELECT CodigoDoProduto, TotalVendido
FROM (
    SELECT CodigoDoProduto, SUM(Quantidade) AS TotalVendido
    FROM Detalhes_do_Pedido
    GROUP BY CodigoDoProduto
) AS Totais
WHERE TotalVendido >= 100;

-- Subquery com ALL
-- Lista os produtos cujo preço é maior ou igual ao preço de
-- todos os produtos da categoria 1.
SELECT NomeDoProduto, PrecoUnitario
FROM Produtos
WHERE PrecoUnitario >= ALL (
    SELECT PrecoUnitario
    FROM Produtos
    WHERE CodigoDaCategoria = 1
);