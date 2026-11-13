IF DB_ID(N'Lista_Trigger01') IS NULL
BEGIN
    EXEC(N'CREATE DATABASE Lista_Trigger01');
END;
GO

USE Lista_Trigger01;
GO

IF OBJECT_ID(N'dbo.Departamento', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Departamento (
        DepartamentoID INT NOT NULL,
        Nome NVARCHAR(100) NOT NULL,
        CONSTRAINT PK_Departamento PRIMARY KEY (DepartamentoID)
    );
END;
GO

IF OBJECT_ID(N'dbo.Funcionarios', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Funcionarios (
        FuncionarioID INT IDENTITY(1,1) NOT NULL,
        DepartamentoID INT NOT NULL,
        Nome NVARCHAR(100) NOT NULL,
        Cargo NVARCHAR(50) NULL,
        Salario DECIMAL(10,2) NULL,
        CONSTRAINT PK_Funcionarios PRIMARY KEY (FuncionarioID),
        CONSTRAINT FK_Funcionarios_Departamento
            FOREIGN KEY (DepartamentoID)
            REFERENCES dbo.Departamento (DepartamentoID)
    );
END;
GO

IF OBJECT_ID(N'dbo.AuditoriaDelete', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.AuditoriaDelete (
        AuditoriaID INT IDENTITY(1,1) NOT NULL,
        FuncionarioID INT NOT NULL,
        Nome VARCHAR(100) NOT NULL,
        Cargo NVARCHAR(50) NULL,
        Salario DECIMAL(10,2) NULL,
        DataExclusao DATETIME NOT NULL
            CONSTRAINT DF_AuditoriaDelete_DataExclusao DEFAULT (GETDATE()),
        CONSTRAINT PK_AuditoriaDelete PRIMARY KEY (AuditoriaID)
    );
END;
GO

IF COL_LENGTH(N'dbo.AuditoriaDelete', N'Cargo') IS NULL
BEGIN
    ALTER TABLE dbo.AuditoriaDelete ADD Cargo NVARCHAR(50) NULL;
END;
GO

IF COL_LENGTH(N'dbo.AuditoriaDelete', N'Salario') IS NULL
BEGIN
    ALTER TABLE dbo.AuditoriaDelete ADD Salario DECIMAL(10,2) NULL;
END;
GO

IF OBJECT_ID(N'dbo.LogSalario', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.LogSalario (
        LogID INT IDENTITY(1,1) NOT NULL,
        FuncionarioID INT NOT NULL,
        SalarioAntigo DECIMAL(10,2) NULL,
        SalarioNovo DECIMAL(10,2) NULL,
        DataAlteracao DATETIME NOT NULL
            CONSTRAINT DF_LogSalario_DataAlteracao DEFAULT (GETDATE()),
        CONSTRAINT PK_LogSalario PRIMARY KEY (LogID)
    );
END;
GO

IF OBJECT_ID(N'dbo.AuditoriaInsert', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.AuditoriaInsert (
        AuditoriaID INT IDENTITY(1,1) NOT NULL,
        FuncionarioID INT NOT NULL,
        Nome NVARCHAR(100) NOT NULL,
        Cargo NVARCHAR(50) NULL,
        DataInsercao DATETIME NOT NULL
            CONSTRAINT DF_AuditoriaInsert_DataInsercao DEFAULT (GETDATE()),
        CONSTRAINT PK_AuditoriaInsert PRIMARY KEY (AuditoriaID)
    );
END;
GO

IF OBJECT_ID(N'dbo.ContagemFuncionarios', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ContagemFuncionarios (
        DepartamentoID INT NOT NULL,
        QuantidadeFuncionarios INT NOT NULL
            CONSTRAINT DF_ContagemFuncionarios_Quantidade DEFAULT (0),
        CONSTRAINT PK_ContagemFuncionarios PRIMARY KEY (DepartamentoID),
        CONSTRAINT FK_ContagemFuncionarios_Departamento
            FOREIGN KEY (DepartamentoID)
            REFERENCES dbo.Departamento (DepartamentoID)
            ON DELETE CASCADE
    );
END;
GO

INSERT INTO dbo.ContagemFuncionarios (DepartamentoID, QuantidadeFuncionarios)
SELECT d.DepartamentoID, COUNT(f.FuncionarioID)
FROM dbo.Departamento AS d
LEFT JOIN dbo.Funcionarios AS f
    ON f.DepartamentoID = d.DepartamentoID
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.ContagemFuncionarios AS c
    WHERE c.DepartamentoID = d.DepartamentoID
)
GROUP BY d.DepartamentoID;
GO
