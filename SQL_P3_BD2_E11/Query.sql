USE [bdpedido];
GO

-- Q1

CREATE OR ALTER PROCEDURE dbo.usp_AumentarPrecoBebidas
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE p
    SET p.PrecoUnitario = p.PrecoUnitario * 1.05
    FROM dbo.Produtos AS p
    INNER JOIN dbo.Categorias AS c
        ON c.CodigoDaCategoria = p.CodigoDaCategoria
    WHERE c.NomeDaCategoria = 'Bebidas';
END;
GO


-- Q2

CREATE OR ALTER PROCEDURE dbo.usp_ReduzirFretePorTransportadora
AS
BEGIN
    SET NOCOUNT ON;

    -- Reducao de 30% (0.3) para Speedy Express e 70% (0.7) para United Package.
    UPDATE p
    SET p.Frete = CASE t.NomeDaEmpresa
        WHEN 'Speedy Express' THEN p.Frete * 0.70
        WHEN 'United Package' THEN p.Frete * 0.30
        ELSE p.Frete
    END
    FROM dbo.Pedidos AS p
    INNER JOIN dbo.Transportadoras AS t
        ON t.CodigoDaTransportadora = p.CodigoDaTransportadora
    WHERE t.NomeDaEmpresa IN ('Speedy Express', 'United Package');
END;
GO


-- Q3

CREATE OR ALTER PROCEDURE dbo.usp_AumentarEstoqueNorskeMeierier
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE p
    SET p.UnidadesEmEstoque = COALESCE(p.UnidadesEmEstoque, 0) + 5
    FROM dbo.Produtos AS p
    INNER JOIN dbo.Fornecedores AS f
        ON f.CodigoDoFornecedor = p.CodigoDoFornecedor
    WHERE f.NomeDaEmpresa = 'Norske Meierier';
END;
GO


-- Q4

CREATE OR ALTER PROCEDURE dbo.usp_CompararPrecoProdutoComMedia
    @CodigoDoProduto INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NomeDoProduto VARCHAR(40);
    DECLARE @PrecoUnitario DECIMAL(19, 4);
    DECLARE @PrecoMedio DECIMAL(19, 4);
    DECLARE @Situacao NVARCHAR(40);

    SELECT
        @NomeDoProduto = NomeDoProduto,
        @PrecoUnitario = PrecoUnitario
    FROM dbo.Produtos
    WHERE CodigoDoProduto = @CodigoDoProduto;

    IF @NomeDoProduto IS NULL
    BEGIN
        SELECT N'Produto nao encontrado.' AS Mensagem;
        RETURN;
    END;

    SELECT @PrecoMedio = AVG(PrecoUnitario)
    FROM dbo.Produtos;

    IF @PrecoUnitario > @PrecoMedio
        SET @Situacao = N'Maior que a media';
    ELSE IF @PrecoUnitario < @PrecoMedio
        SET @Situacao = N'Menor que a media';
    ELSE
        SET @Situacao = N'Igual a media';

    SELECT
        @CodigoDoProduto AS CodigoDoProduto,
        @NomeDoProduto AS NomeDoProduto,
        @PrecoUnitario AS PrecoUnitario,
        @PrecoMedio AS PrecoMedio,
        @Situacao AS Situacao;
END;
GO


-- Q5

CREATE OR ALTER PROCEDURE dbo.usp_ExcluirProdutosPorCategoria
    @CodigoDaCategoria INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Conforme o enunciado, esta procedure nao deve ser executada diretamente na base real.
    DELETE FROM dbo.Produtos
    WHERE CodigoDaCategoria = @CodigoDaCategoria;
END;
GO


-- Q6

CREATE OR ALTER PROCEDURE dbo.usp_ListarProdutosEstoqueAbaixo
    @Quantidade INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM dbo.Produtos
        WHERE UnidadesEmEstoque < @Quantidade
    )
    BEGIN
        SELECT
            NomeDoProduto,
            UnidadesEmEstoque
        FROM dbo.Produtos
        WHERE UnidadesEmEstoque < @Quantidade
        ORDER BY UnidadesEmEstoque ASC, NomeDoProduto ASC;
    END
    ELSE
    BEGIN
        SELECT N'Nenhum produto encontrado com estoque abaixo da quantidade informada.' AS Mensagem;
    END;
END;
GO


-- Q7

CREATE OR ALTER PROCEDURE dbo.usp_AniversariantesDoMes
    @Mes INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @Mes < 1 OR @Mes > 12 OR @Mes IS NULL
    BEGIN
        THROW 50001, N'Mes invalido. Informe um valor entre 1 e 12.', 1;
    END;

    IF EXISTS (
        SELECT 1
        FROM dbo.Funcionarios
        WHERE MONTH(DataDeNascimento) = @Mes
    )
    BEGIN
        SELECT
            CodigoDoFuncionario,
            Nome,
            Sobrenome,
            DataDeNascimento,
            DATEDIFF(YEAR, DataDeNascimento, GETDATE())
                - CASE
                    WHEN DATEADD(YEAR, DATEDIFF(YEAR, DataDeNascimento, GETDATE()), DataDeNascimento)
                        > CAST(GETDATE() AS DATE)
                    THEN 1
                    ELSE 0
                  END AS Idade
        FROM dbo.Funcionarios
        WHERE MONTH(DataDeNascimento) = @Mes
        ORDER BY DAY(DataDeNascimento) ASC, Nome ASC;
    END
    ELSE
    BEGIN
        SELECT N'Nenhum funcionario faz aniversario no mes informado.' AS Mensagem;
    END;
END;
GO


-- Q8

CREATE OR ALTER PROCEDURE dbo.usp_InserirTransportadora
    @NomeDaEmpresa VARCHAR(40),
    @Telefone VARCHAR(24)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Transportadoras (NomeDaEmpresa, Telefone)
    VALUES (@NomeDaEmpresa, @Telefone);

    SELECT CAST(SCOPE_IDENTITY() AS INT) AS CodigoDaTransportadora;
END;
GO


-- Q9

CREATE OR ALTER PROCEDURE dbo.usp_DiminuirFreteTransportadoraMes
    @NomeTransportadora VARCHAR(40),
    @Mes INT,
    @PercentualReducao DECIMAL(5, 2) = 10.00
AS
BEGIN
    SET NOCOUNT ON;

    IF @Mes < 1 OR @Mes > 12 OR @Mes IS NULL
    BEGIN
        THROW 50002, N'Mes invalido. Informe um valor entre 1 e 12.', 1;
    END;

    IF @PercentualReducao IS NULL OR @PercentualReducao <= 0 OR @PercentualReducao > 100
    BEGIN
        THROW 50003, N'Percentual de reducao invalido. Informe um valor entre 0.01 e 100.', 1;
    END;

    UPDATE p
    SET p.Frete = p.Frete * (1 - (@PercentualReducao / 100.0))
    FROM dbo.Pedidos AS p
    INNER JOIN dbo.Transportadoras AS t
        ON t.CodigoDaTransportadora = p.CodigoDaTransportadora
    WHERE t.NomeDaEmpresa = @NomeTransportadora
      AND MONTH(p.DataDoPedido) = @Mes;
END;
GO


-- Q10

CREATE OR ALTER PROCEDURE dbo.usp_ConsultarDetalhesPorPreco
    @Preco DECIMAL(19, 4),
    @Operador VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OpNormalizado VARCHAR(10) = UPPER(LTRIM(RTRIM(@Operador)));

    IF @OpNormalizado IN ('>', 'ACIMA')
    BEGIN
        SELECT
            dp.NumeroDoPedido,
            dp.CodigoDoProduto,
            p.NomeDoProduto,
            dp.[PrecoUnitário],
            dp.Quantidade,
            dp.Desconto
        FROM dbo.Detalhes_do_Pedido AS dp
        LEFT JOIN dbo.Produtos AS p
            ON p.CodigoDoProduto = dp.CodigoDoProduto
        WHERE dp.[PrecoUnitário] > @Preco
        ORDER BY dp.[PrecoUnitário] ASC, dp.NumeroDoPedido ASC;
    END
    ELSE IF @OpNormalizado IN ('<', 'ABAIXO')
    BEGIN
        SELECT
            dp.NumeroDoPedido,
            dp.CodigoDoProduto,
            p.NomeDoProduto,
            dp.[PrecoUnitário],
            dp.Quantidade,
            dp.Desconto
        FROM dbo.Detalhes_do_Pedido AS dp
        LEFT JOIN dbo.Produtos AS p
            ON p.CodigoDoProduto = dp.CodigoDoProduto
        WHERE dp.[PrecoUnitário] < @Preco
        ORDER BY dp.[PrecoUnitário] ASC, dp.NumeroDoPedido ASC;
    END
    ELSE IF @OpNormalizado IN ('=', 'IGUAL')
    BEGIN
        SELECT
            dp.NumeroDoPedido,
            dp.CodigoDoProduto,
            p.NomeDoProduto,
            dp.[PrecoUnitário],
            dp.Quantidade,
            dp.Desconto
        FROM dbo.Detalhes_do_Pedido AS dp
        LEFT JOIN dbo.Produtos AS p
            ON p.CodigoDoProduto = dp.CodigoDoProduto
        WHERE dp.[PrecoUnitário] = @Preco
        ORDER BY dp.NumeroDoPedido ASC;
    END
    ELSE
    BEGIN
        THROW 50004, N'Operador invalido. Utilize ''>''/''ACIMA'', ''<''/''ABAIXO'' ou ''=''/''IGUAL''.', 1;
    END;
END;
GO
