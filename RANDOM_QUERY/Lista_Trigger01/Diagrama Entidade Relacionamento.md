# Diagrama Entidade Relacionamento

```mermaid
erDiagram
    Departamento ||--o{ Funcionarios : possui
    Departamento ||--o| ContagemFuncionarios : contabiliza

    Departamento {
        INT DepartamentoID PK "NOT NULL"
        NVARCHAR Nome "100; NOT NULL"
    }

    Funcionarios {
        INT FuncionarioID PK "IDENTITY(1,1); NOT NULL"
        INT DepartamentoID FK "NOT NULL"
        NVARCHAR Nome "100; NOT NULL"
        NVARCHAR Cargo "50; NULL"
        DECIMAL Salario "10,2; NULL"
    }

    AuditoriaDelete {
        INT AuditoriaID PK "IDENTITY(1,1); NOT NULL"
        INT FuncionarioID "NOT NULL; sem FK"
        VARCHAR Nome "100; NOT NULL"
        NVARCHAR Cargo "50; NULL"
        DECIMAL Salario "10,2; NULL"
        DATETIME DataExclusao "NOT NULL; DEFAULT GETDATE()"
    }

    LogSalario {
        INT LogID PK "IDENTITY(1,1); NOT NULL"
        INT FuncionarioID "NOT NULL; sem FK"
        DECIMAL SalarioAntigo "10,2; NULL"
        DECIMAL SalarioNovo "10,2; NULL"
        DATETIME DataAlteracao "NOT NULL; DEFAULT GETDATE()"
    }

    AuditoriaInsert {
        INT AuditoriaID PK "IDENTITY(1,1); NOT NULL"
        INT FuncionarioID "NOT NULL; sem FK"
        NVARCHAR Nome "100; NOT NULL"
        NVARCHAR Cargo "50; NULL"
        DATETIME DataInsercao "NOT NULL; DEFAULT GETDATE()"
    }

    ContagemFuncionarios {
        INT DepartamentoID PK "FK; NOT NULL; ON DELETE CASCADE"
        INT QuantidadeFuncionarios "NOT NULL; DEFAULT 0"
    }
```

`DepartamentoID` em `Departamento` é informado manualmente; o exercício usa o ID 2 para representar o RH. `FuncionarioID`, `AuditoriaID` e `LogID` são `IDENTITY(1,1)`. Os `FuncionarioID` das tabelas de auditoria e histórico não são chaves estrangeiras, para preservar os registros mesmo após a exclusão de um funcionário.
