CREATE DATABASE escola;
use escola;

create table Aluno (
id_aluno INT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE
);

create table Curso (
id_curso INT PRIMARY KEY,
nome_curso VARCHAR(100) NOT NULL,
carga_horaria INT NOT NULL
);

CREATE TABLE Matricula (
    Cod_aluno INT,
    Cod_curso INT,
    data_matricula DATE NOT NULL,
    PRIMARY KEY (Cod_aluno, Cod_curso),
    FOREIGN KEY (Cod_aluno) REFERENCES ALUNO(id_aluno),
    FOREIGN KEY (Cod_curso) REFERENCES CURSO(id_curso)
);

INSERT INTO Aluno (id_aluno, nome, email) VALUES
(1, 'Layson Victor', 'layson@email.com'), (2, 'Ana Oliveira', 'ana@email.com'),
(3, 'Bruno Costa', 'bruno@email.com'), (4, 'Carla Souza', 'carla@email.com'),
(5, 'Diego Lima', 'diego@email.com'), (6, 'Fernanda Rocha', 'fernanda@email.com'),
(7, 'Gabriel Matos', 'gabriel@email.com'), (8, 'Helena Peixoto', 'helena@email.com'),
(9, 'Igor Gomes', 'igor@email.com'), (10, 'Julia Santos', 'julia@email.com');

INSERT INTO Curso (id_curso, nome_curso, carga_horaria) VALUES 
(101, 'Ciência da Computação', 3600), (102, 'Sistemas de Informação', 3200),
(103, 'Engenharia de Software', 3400), (104, 'Banco de Dados', 120),
(105, 'Desenvolvimento Web', 180), (106, 'Inteligência Artificial', 200),
(107, 'Redes de Computadores', 160), (108, 'Segurança da Informação', 140),
(109, 'Lógica de Programação', 80), (110, 'Estrutura de Dados', 100);

INSERT INTO Matricula (Cod_aluno, Cod_curso, data_matricula) VALUES 
(1, 101, '2026-05-01'), (2, 102, '2026-05-02'), (3, 103, '2026-05-03'),
(4, 104, '2026-05-04'), (5, 105, '2026-05-05'), (6, 106, '2026-05-06'),
(7, 107, '2026-05-07'), (8, 108, '2026-05-08'), (9, 109, '2026-05-09'),
(10, 110, '2026-05-10');

select *from Aluno;
select *from Curso;
select *from Matricula;