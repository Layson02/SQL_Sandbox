USE [bdpedido]
GO

-- 1. Produtos da categoria Bebidas com preço unitário abaixo da média da categoria.
SELECT p.NomeDoProduto, p.PrecoUnitario
FROM Produtos AS p
INNER JOIN Categorias AS c
    ON c.CodigoDaCategoria = p.CodigoDaCategoria
WHERE c.NomeDaCategoria = 'Bebidas'
  AND p.PrecoUnitario < (
      SELECT AVG(p2.PrecoUnitario)
      FROM Produtos AS p2
      INNER JOIN Categorias AS c2
          ON c2.CodigoDaCategoria = p2.CodigoDaCategoria
      WHERE c2.NomeDaCategoria = 'Bebidas'
  );
GO

-- 2. Produtos de Laticínios que já foram comercializados em mais de 1000 unidades.
SELECT p.NomeDoProduto,
       SUM(d.Quantidade) AS TotalComercializado
FROM Produtos AS p
INNER JOIN Categorias AS c
    ON c.CodigoDaCategoria = p.CodigoDaCategoria
INNER JOIN Detalhes_do_Pedido AS d
    ON d.CodigoDoProduto = p.CodigoDoProduto
WHERE c.NomeDaCategoria = 'Laticínios'
GROUP BY p.CodigoDoProduto, p.NomeDoProduto
HAVING SUM(d.Quantidade) > 1000;
GO
-- 3. Clientes que fizeram pedidos no segundo trimestre (abril a junho).
SELECT DISTINCT c.CodigoDoCliente,
       c.NomeDaEmpresa
FROM Pedidos AS p
INNER JOIN Clientes AS c
    ON c.CodigoDoCliente = p.CodigoDoCliente
WHERE MONTH(p.DataDoPedido) BETWEEN 4 AND 6;
GO

-- 4. Funcionários que emitiram pedidos até o dia 5 de janeiro, independentemente do ano.
SELECT DISTINCT f.CodigoDoFuncionario,
       f.Nome,
       f.Sobrenome
FROM Pedidos AS p
INNER JOIN Funcionarios AS f
    ON f.CodigoDoFuncionario = p.CodigoDoFuncionario
WHERE MONTH(p.DataDoPedido) = 1
  AND DAY(p.DataDoPedido) <= 5;

-- 5.
-- a) Foram criadas 4 constraints: NOT NULL em nome, CHECK em uf,
--    NOT NULL em idade e FOREIGN KEY em id_funcionario.
-- b) No atributo uf foi criada uma constraint CHECK.

-- 6. CHECK para impedir NivelDeReposicao menor ou igual a zero.
IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_Produtos_NivelDeReposicao'
      AND parent_object_id = OBJECT_ID('dbo.Produtos')
)
BEGIN
    ALTER TABLE dbo.Produtos
    ADD CONSTRAINT CK_Produtos_NivelDeReposicao
    CHECK (NivelDeReposicao > 0);
END
GO

-- 7. CHECK para permitir apenas descontos entre 5 e 8.
IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_DetalhesDoPedido_Desconto'
      AND parent_object_id = OBJECT_ID('dbo.Detalhes_do_Pedido')
)
BEGIN
    ALTER TABLE dbo.Detalhes_do_Pedido
    ADD CONSTRAINT CK_DetalhesDoPedido_Desconto
    CHECK (Desconto BETWEEN 5 AND 8);
END
GO

-- 8. Tabela Alunos com identificador único aplicado à coluna ID.
CREATE TABLE dbo.Alunos (
    ID INT CONSTRAINT PK_Alunos PRIMARY KEY,
    ClienteID INT,
    DataPedido DATE
);
GO

-- 9. Visão com o total de pedidos por código da transportadora.
CREATE OR ALTER VIEW dbo.View_Transportadora AS
SELECT t.CodigoDaTransportadora,
       t.NomeDaEmpresa,
       COUNT(p.NumeroDoPedido) AS TotalPedidos
FROM Transportadoras AS t
LEFT JOIN Pedidos AS p
    ON p.CodigoDaTransportadora = t.CodigoDaTransportadora
GROUP BY t.CodigoDaTransportadora, t.NomeDaEmpresa;
GO

SELECT * FROM dbo.View_Transportadora;

-- 10. Visão com o dia e o total de pedidos realizados em cada dia do mês.
GO
CREATE OR ALTER VIEW dbo.View_TotalPedidosDia AS
SELECT DAY(DataDoPedido) AS Dia,
       COUNT(*) AS TotalPedidos
FROM Pedidos
WHERE DataDoPedido IS NOT NULL
GROUP BY DAY(DataDoPedido);
GO

-- 11. Exclusão da visão View_Transportadora.
DROP VIEW IF EXISTS dbo.View_Transportadora;
GO

-- 12. Visão com funcionário, transportadora e total de pedidos.
CREATE OR ALTER VIEW dbo.View_FuncionarioTransportadora AS
SELECT f.CodigoDoFuncionario,
       f.Nome + ' ' + f.Sobrenome AS NomeFuncionario,
       t.CodigoDaTransportadora,
       t.NomeDaEmpresa AS NomeTransportadora,
       COUNT(p.NumeroDoPedido) AS TotalPedidos
FROM Funcionarios AS f
INNER JOIN Pedidos AS p
    ON p.CodigoDoFuncionario = f.CodigoDoFuncionario
INNER JOIN Transportadoras AS t
    ON t.CodigoDaTransportadora = p.CodigoDaTransportadora
GROUP BY f.CodigoDoFuncionario,
         f.Nome,
         f.Sobrenome,
         t.CodigoDaTransportadora,
         t.NomeDaEmpresa;
GO

-- 13. Visão com todos os pedidos realizados no primeiro trimestre de cada ano.
CREATE OR ALTER VIEW dbo.View_FuncionarioPedidos AS
SELECT p.NumeroDoPedido,
       f.CodigoDoFuncionario,
       f.Nome + ' ' + f.Sobrenome AS NomeFuncionario,
       p.DataDoPedido
FROM Pedidos AS p
INNER JOIN Funcionarios AS f
    ON f.CodigoDoFuncionario = p.CodigoDoFuncionario
WHERE MONTH(p.DataDoPedido) BETWEEN 1 AND 3;
GO

-- 14. Stored procedure para aumentar em 2% o preço dos produtos de uma categoria.
CREATE OR ALTER PROCEDURE dbo.sp_aumentoproduto
    @NomeDaCategoria VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE p
    SET p.PrecoUnitario = p.PrecoUnitario * 1.02
    FROM Produtos AS p
    INNER JOIN Categorias AS c
        ON c.CodigoDaCategoria = p.CodigoDaCategoria
    WHERE c.NomeDaCategoria = @NomeDaCategoria;
END
GO

-- 15. Stored procedure com clientes e endereços dos pedidos de uma cidade de destino.
CREATE OR ALTER PROCEDURE dbo.sp_cidadededestino
    @CidadeDeDestino VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT c.NomeDaEmpresa AS NomeDoCliente,
           c.Endereco AS EnderecoDoCliente,
           p.EndereçoDoDestinatario AS EnderecoDoPedido,
           p.CidadeDeDestino
    FROM Pedidos AS p
    INNER JOIN Clientes AS c
        ON c.CodigoDoCliente = p.CodigoDoCliente
    WHERE p.CidadeDeDestino = @CidadeDeDestino;
END
GO

-- 16. Stored procedure com nome do funcionário e quantidade de pedidos por mês.
CREATE OR ALTER PROCEDURE dbo.sp_funcionariomes
    @Mes INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT f.Nome + ' ' + f.Sobrenome AS NomeFuncionario,
           COUNT(p.NumeroDoPedido) AS QuantidadePedidos
    FROM Pedidos AS p
    INNER JOIN Funcionarios AS f
        ON f.CodigoDoFuncionario = p.CodigoDoFuncionario
    WHERE MONTH(p.DataDoPedido) = @Mes
    GROUP BY f.CodigoDoFuncionario, f.Nome, f.Sobrenome;
END
GO

-- 17. Stored procedure com produtos comercializados por fornecedores de um país.
CREATE OR ALTER PROCEDURE dbo.sp_produtospais
    @Pais VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT f.NomeDaEmpresa AS NomeFornecedor,
           f.Pais,
           p.CodigoDoProduto,
           p.NomeDoProduto
    FROM Fornecedores AS f
    INNER JOIN Produtos AS p
        ON p.CodigoDoFornecedor = f.CodigoDoFornecedor
    WHERE f.Pais = @Pais;
END
GO