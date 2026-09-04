USE [bdpedido];
GO

select * from Categorias

select * from Produtos
where CodigoDaCategoria=3

select * from Produtos p 
join Fornecedores f
on p.CodigoDoFornecedor = f.CodigoDoFornecedor

select p.DataDoPedido, p.CodigoDoFuncionario,f.Nome,MONTH(p.DataDoPedido),YEAR(p.DataDoPedido)
from Pedidos p
join Funcionarios f
on p.CodigoDoFuncionario = f.CodigoDoFuncionario
WHERE YEAR(p.DataDoPedido) = 1996 AND MONTH(p.DataDoPedido) = 8
ORDER BY p.CodigoDoFuncionario

select c.CodigoDoCliente, c.NomeDoContato,p.NumeroDoPedido 
from Clientes c
LEFT JOIN Pedidos p
on c.CodigoDoCliente = p.CodigoDoCliente
where p.NumeroDoPedido IS NULL