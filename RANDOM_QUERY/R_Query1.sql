USE [bdpedido];
GO

select * from Categorias

select * from Produtos
where CodigoDaCategoria=3

select * from Produtos p 
join Fornecedores f
on p.CodigoDoFornecedor = f.CodigoDoFornecedor