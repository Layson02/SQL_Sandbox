USE Lista_Trigger01;
GO

-- Q1: registra os funcionários inseridos.
CREATE OR ALTER TRIGGER dbo.trg_Funcionarios_AuditoriaInsert
ON dbo.Funcionarios
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.AuditoriaInsert (FuncionarioID, Nome, Cargo)
    SELECT FuncionarioID, Nome, Cargo
    FROM inserted;
END;
GO

-- Q2, Q8 e Q10: valida salários e aplica os valores automáticos da lista.
CREATE OR ALTER TRIGGER dbo.trg_Funcionarios_RegrasSalarioInsert
ON dbo.Funcionarios
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE f
    SET Salario = CASE
        WHEN i.Cargo = N'Diretor' THEN 15000.00
        WHEN i.Cargo = N'Estagiário' AND i.Salario IS NULL THEN 3000.00
        ELSE i.Salario
    END
    FROM dbo.Funcionarios AS f
    INNER JOIN inserted AS i
        ON i.FuncionarioID = f.FuncionarioID
    WHERE i.Cargo = N'Diretor'
       OR (i.Cargo = N'Estagiário' AND i.Salario IS NULL);

    IF EXISTS (
        SELECT 1
        FROM dbo.Funcionarios AS f
        INNER JOIN inserted AS i
            ON i.FuncionarioID = f.FuncionarioID
        WHERE f.Salario < 1000.00
    )
    BEGIN
        THROW 50001, N'O salário do funcionário não pode ser inferior a R$ 1.000,00.', 1;
    END;
END;
GO

-- Q2 e Q3: rejeita salários inválidos e registra alterações salariais.
CREATE OR ALTER TRIGGER dbo.trg_Funcionarios_RegrasSalarioUpdate
ON dbo.Funcionarios
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT UPDATE(Salario)
    BEGIN
        RETURN;
    END;

    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        WHERE i.Salario < 1000.00
    )
    BEGIN
        THROW 50002, N'O salário do funcionário não pode ser inferior a R$ 1.000,00.', 1;
    END;

    INSERT INTO dbo.LogSalario
        (FuncionarioID, SalarioAntigo, SalarioNovo)
    SELECT i.FuncionarioID, d.Salario, i.Salario
    FROM inserted AS i
    INNER JOIN deleted AS d
        ON d.FuncionarioID = i.FuncionarioID
    WHERE i.Salario <> d.Salario
       OR (i.Salario IS NULL AND d.Salario IS NOT NULL)
       OR (i.Salario IS NOT NULL AND d.Salario IS NULL);
END;
GO

-- Q4: impede a exclusão de funcionários vinculados ao departamento RH (ID 2).
CREATE OR ALTER TRIGGER dbo.trg_Funcionarios_ImpedirExclusaoRH
ON dbo.Funcionarios
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM deleted
        WHERE DepartamentoID = 2
    )
    BEGIN
        THROW 50003, N'Não é permitido excluir funcionários do departamento RH (ID 2).', 1;
    END;
END;
GO

-- Q5: mantém a contagem auxiliar após inserções, exclusões ou mudanças de departamento.
CREATE OR ALTER TRIGGER dbo.trg_Funcionarios_AtualizarContagem
ON dbo.Funcionarios
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH Alteracoes AS (
        SELECT DepartamentoID, COUNT(*) AS Variacao
        FROM inserted
        GROUP BY DepartamentoID

        UNION ALL

        SELECT DepartamentoID, -COUNT(*) AS Variacao
        FROM deleted
        GROUP BY DepartamentoID
    ),
    Totais AS (
        SELECT DepartamentoID, SUM(Variacao) AS Variacao
        FROM Alteracoes
        GROUP BY DepartamentoID
    )
    UPDATE c
    SET QuantidadeFuncionarios = c.QuantidadeFuncionarios + t.Variacao
    FROM dbo.ContagemFuncionarios AS c
    INNER JOIN Totais AS t
        ON t.DepartamentoID = c.DepartamentoID
    WHERE t.Variacao <> 0;
END;
GO

-- Q6: bloqueia nomes que contenham algarismos.
CREATE OR ALTER TRIGGER dbo.trg_Funcionarios_ValidarNome
ON dbo.Funcionarios
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE Nome LIKE N'%[0-9]%'
    )
    BEGIN
        THROW 50004, N'O nome do funcionário não pode conter números.', 1;
    END;
END;
GO

-- Q7: armazena os dados dos funcionários excluídos.
CREATE OR ALTER TRIGGER dbo.trg_Funcionarios_AuditoriaDelete
ON dbo.Funcionarios
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.AuditoriaDelete
        (FuncionarioID, Nome, Cargo, Salario)
    SELECT FuncionarioID, Nome, Cargo, Salario
    FROM deleted;
END;
GO

-- Q9: impede a mudança de departamento de funcionários gerentes.
CREATE OR ALTER TRIGGER dbo.trg_Funcionarios_ImpedirMudancaDepartamentoGerente
ON dbo.Funcionarios
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(DepartamentoID) AND EXISTS (
        SELECT 1
        FROM inserted AS i
        INNER JOIN deleted AS d
            ON d.FuncionarioID = i.FuncionarioID
        WHERE i.DepartamentoID <> d.DepartamentoID
          AND (i.Cargo = N'Gerente' OR d.Cargo = N'Gerente')
    )
    BEGIN
        THROW 50005, N'Não é permitido alterar o departamento de um funcionário Gerente.', 1;
    END;
END;
GO

CREATE OR ALTER TRIGGER dbo.trg_Departamento_CriarContagem
ON dbo.Departamento
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.ContagemFuncionarios (DepartamentoID, QuantidadeFuncionarios)
    SELECT i.DepartamentoID, 0
    FROM inserted AS i
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.ContagemFuncionarios AS c
        WHERE c.DepartamentoID = i.DepartamentoID
    );
END;
GO