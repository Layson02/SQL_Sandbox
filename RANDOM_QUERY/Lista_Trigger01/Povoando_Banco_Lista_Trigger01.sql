USE [Lista_Trigger01];
GO

IF EXISTS (
    SELECT 1
    FROM dbo.Departamento
    WHERE DepartamentoID = 2
      AND Nome <> N'RH'
)
BEGIN
    THROW 50010, N'O DepartamentoID 2 já existe e não está cadastrado como RH.', 1;
END;
GO

INSERT INTO dbo.Departamento (DepartamentoID, Nome)
SELECT dados.DepartamentoID, dados.Nome
FROM (VALUES
    (1, N'Administrativo'),
    (2, N'RH'),
    (3, N'Tecnologia')
) AS dados(DepartamentoID, Nome)
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Departamento AS d
    WHERE d.DepartamentoID = dados.DepartamentoID
);
GO

INSERT INTO dbo.Funcionarios (DepartamentoID, Nome, Cargo, Salario)
SELECT dados.DepartamentoID, dados.Nome, dados.Cargo, dados.Salario
FROM (VALUES
    (1, N'Ana Silva', N'Analista', 3200.00),
    (2, N'Bruno Costa', N'Analista de RH', 3500.00),
    (3, N'Carla Mendes', N'Estagiário', NULL),
    (3, N'Diego Rocha', N'Diretor', 12000.00),
    (1, N'Elisa Ferreira', N'Gerente', 5000.00)
) AS dados(DepartamentoID, Nome, Cargo, Salario)
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Funcionarios AS f
    WHERE f.Nome = dados.Nome
);
GO
