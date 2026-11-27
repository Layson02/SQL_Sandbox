USE [bdpedido];
GO

SET XACT_ABORT ON;

-- Executa os testes em uma transacao que sera desfeita ao final.
BEGIN TRANSACTION;

-- Q1: Aumento de 5% nos produtos da categoria Bebidas
EXEC dbo.usp_AumentarPrecoBebidas;

-- Q2: Reducao de frete por transportadora (Speedy Express e United Package)
EXEC dbo.usp_ReduzirFretePorTransportadora;

-- Q3: Aumento de 5 unidades no estoque dos produtos da Norske Meierier
EXEC dbo.usp_AumentarEstoqueNorskeMeierier;

-- Q4: Comparacao do preco do produto com a media
EXEC dbo.usp_CompararPrecoProdutoComMedia @CodigoDoProduto = 1;

-- Q5: Nao executar conforme instrucao do enunciado ("nao execute essa procedure").
-- EXEC dbo.usp_ExcluirProdutosPorCategoria @CodigoDaCategoria = 1;

-- Q6: Produtos abaixo da quantidade informada (com resultados e sem resultados)
EXEC dbo.usp_ListarProdutosEstoqueAbaixo @Quantidade = 10;
EXEC dbo.usp_ListarProdutosEstoqueAbaixo @Quantidade = -1;

-- Q7: Aniversariantes do mes
EXEC dbo.usp_AniversariantesDoMes @Mes = 7;

-- Q8: Insercao de nova transportadora
EXEC dbo.usp_InserirTransportadora
    @NomeDaEmpresa = 'Transportadora Teste',
    @Telefone = '(83) 99999-0000';

-- Q9: Diminuir frete por transportadora e mes
EXEC dbo.usp_DiminuirFreteTransportadoraMes
    @NomeTransportadora = 'Speedy Express',
    @Mes = 7,
    @PercentualReducao = 10.00;

-- Q10: Consulta de detalhes por preco e operador
EXEC dbo.usp_ConsultarDetalhesPorPreco @Preco = 20, @Operador = 'ACIMA';
EXEC dbo.usp_ConsultarDetalhesPorPreco @Preco = 20, @Operador = 'ABAIXO';
EXEC dbo.usp_ConsultarDetalhesPorPreco @Preco = 20, @Operador = 'IGUAL';

ROLLBACK TRANSACTION;

SELECT N'Testes das stored procedures concluidos com sucesso.' AS Resultado;
GO
