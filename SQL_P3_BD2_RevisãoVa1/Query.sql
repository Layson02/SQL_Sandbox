USE [bdpedido]
GO

-- Q1:A empresa deseja identificar os 2 funcionários que realizaram a maior quantidade 
-- de  pedidos.  Elabore  uma  consulta  que  apresente  o  nome  do  funcionário  e  a 
-- quantidade de pedidos realizados, mostrando somente os dois primeiros colocados.

select p.CodigoDoFuncionario, f.Nome, COUNT(*) quantidade,
count(*)/707.0*100 as porcentagem
from Pedidos p
join Funcionarios f
on p.CodigoDoFuncionario = f.CodigoDoFuncionario
group by p.CodigoDoFuncionario, f.Nome
order by quantidade desc

-- Q2: A  empresa  deseja  saber  quais  são  os  5  produtos  que  apresentam  a  maior 
-- quantidade total vendida. Elabore uma consulta que apresente o nome do produto 
-- e a soma das quantidades vendidas, ordenando do maior para o menor e limitando 
-- o resultado aos 5 primeiros produtos. 

select top 5 d.CodigoDoProduto,
p.NomeDoProduto, 
sum(d.Quantidade) Total,
SUM(d.Quantidade)*1.1 'Nova meta' 
from Detalhes_do_Pedido d
join Produtos p
on d.CodigoDoProduto = p.CodigoDoProduto
group by d.CodigoDoProduto, p.NomeDoProduto
order by sum(d.Quantidade) desc

-- Q3: A  área  comercial  deseja  identificar  os  países  para  os  quais  foram  realizados 
-- pedidos. Elabore uma consulta que apresente cada país de destino uma única vez, 
-- sem repetir países. 

select distinct p.PaisDeDestino
from Pedidos p

-- Q10: A  direção  deseja  saber  quais  funcionários  possuem  uma  quantidade  de  pedidos 
-- superior à média de pedidos realizados pelos funcionários. Elabore uma consulta 
-- utilizando  agrupamento e  uma subquery  para comparar  a  quantidade  de  pedidos 
-- de cada funcionário com a média.

select count(*) quantidade
	from Pedidos p
	group by p.CodigoDoFuncionario
having count(*) > (
select AVG(quantidade) from (
	select count(*) quantidade
	from Pedidos p
	group by p.CodigoDoFuncionario
) as subquery
)