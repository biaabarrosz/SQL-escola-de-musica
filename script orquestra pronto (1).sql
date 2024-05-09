CREATE TABLE Orquestra (
    id_orquestra INT PRIMARY KEY,
    nome VARCHAR(100),
    cidade VARCHAR(100),
    pais VARCHAR(100),
    data_criacao DATE
);

CREATE TABLE Sinfonia (
    id_sinfonia INT PRIMARY KEY,
    nome VARCHAR(100),
    compositor VARCHAR(100),
    data_criacao DATE,
    id_orquestra INT,
    FOREIGN KEY (id_orquestra) REFERENCES Orquestra(id_orquestra)
);

CREATE TABLE Musico (
    id_musico INT PRIMARY KEY,
    nome VARCHAR(100),
    identidade VARCHAR(100),
    nacionalidade VARCHAR(100),
    data_nascimento DATE,
    id_orquestra INT,
    FOREIGN KEY (id_orquestra) REFERENCES Orquestra(id_orquestra)
);

CREATE TABLE Funcao (
    id_funcao INT PRIMARY KEY,
    data_inicio DATE,
    data_termino DATE,
    id_musico INT,
    id_sinfonia INT,
    FOREIGN KEY (id_musico) REFERENCES Musico(id_musico),
    FOREIGN KEY (id_sinfonia) REFERENCES Sinfonia(id_sinfonia)
);

CREATE TABLE Instrumento (
    id_instrumento INT PRIMARY KEY,
    nome VARCHAR(100)
);

CREATE TABLE Musico_Instrumento (
    id_musico INT,
    id_instrumento INT,
    PRIMARY KEY (id_musico, id_instrumento),
    FOREIGN KEY (id_musico) REFERENCES Musico(id_musico),
    FOREIGN KEY (id_instrumento) REFERENCES Instrumento(id_instrumento)
);

ALTER TABLE Musico
ADD COLUMN email VARCHAR(100);

ALTER TABLE Musico
RENAME COLUMN identidade TO documento;

ALTER TABLE Instrumento
ADD COLUMN descricao TEXT;

ALTER TABLE Funcao
RENAME TO Funcoes;

ALTER TABLE Sinfonia
ADD COLUMN descricao TEXT;

ALTER TABLE Orquestra
ALTER COLUMN cidade VARCHAR(150);

ALTER TABLE Orquestra
ADD COLUMN telefone VARCHAR(20);

ALTER TABLE Instrumento
ADD CONSTRAINT unique_nome UNIQUE (nome);

ALTER TABLE Orquestra
ADD COLUMN endereco VARCHAR(200);

ALTER TABLE Sinfonia
ALTER COLUMN compositor TYPE TEXT;

DROP TABLE IF EXISTS Musico_Instrumento;
DROP TABLE IF EXISTS Instrumento;
DROP TABLE IF EXISTS Funcao;
DROP TABLE IF EXISTS Musico;
DROP TABLE IF EXISTS Sinfonia;
DROP TABLE IF EXISTS Orquestra;

CREATE VIEW Orquestras_Sinfonias AS
SELECT o.nome AS nome_orquestra, o.cidade, o.pais, s.nome AS nome_sinfonia, s.compositor
FROM Orquestra o
LEFT JOIN Sinfonia s ON o.id_orquestra = s.id_orquestra;

CREATE VIEW Musicos_Por_Orquestra AS
SELECT o.nome AS nome_orquestra, m.nome AS nome_musico, m.identidade, m.nacionalidade
FROM Orquestra o
INNER JOIN Musico m ON o.id_orquestra = m.id_orquestra;

CREATE VIEW Sinfonias_Compositores AS
SELECT nome AS nome_sinfonia, compositor
FROM Sinfonia;

CREATE VIEW Musicos_Instrumentos AS
SELECT m.nome AS nome_musico, i.nome AS nome_instrumento
FROM Musico m
LEFT JOIN Musico_Instrumento mi ON m.id_musico = mi.id_musico
LEFT JOIN Instrumento i ON mi.id_instrumento = i.id_instrumento;

CREATE VIEW Musicos_Funcoes AS
SELECT m.nome AS nome_musico, f.data_inicio, f.data_termino, s.nome AS nome_sinfonia, f.id_funcao
FROM Musico m
INNER JOIN Funcao f ON m.id_musico = f.id_musico
INNER JOIN Sinfonia s ON f.id_sinfonia = s.id_sinfonia;

CREATE VIEW Sinfonias_Por_Compositor AS
SELECT compositor, COUNT(*) AS total_sinfonias
FROM Sinfonia
GROUP BY compositor;

CREATE VIEW Orquestras_Por_Pais AS
SELECT pais, COUNT(*) AS total_orquestras
FROM Orquestra
GROUP BY pais;

CREATE VIEW Musicos_Por_Nacionalidade AS
SELECT nacionalidade, COUNT(*) AS total_musicos
FROM Musico
GROUP BY nacionalidade;

CREATE VIEW Musicos_Por_Funcao AS
SELECT f.id_funcao, m.nome AS nome_musico, f.data_inicio, f.data_termino
FROM Funcao f
INNER JOIN Musico m ON f.id_musico = m.id_musico;

CREATE VIEW Musicos_Sem_Funcao AS
SELECT m.nome AS nome_musico, m.identidade, m.nacionalidade
FROM Musico m
LEFT JOIN Funcao f ON m.id_musico = f.id_musico
WHERE f.id_funcao IS NULL;


INSERT INTO Orquestra (id_orquestra, nome, cidade, pais, data_criacao) 
VALUES 
    (1, 'Orquestra Harmonia Celestial', 'São Paulo', 'Brasil', '2000-05-15'),
    (2, 'Orquestra Celestial do Crepúsculo', 'Recife', 'Brasil', '1995-10-20'),
    (3, 'Orquestra Sinfônica', 'Rio de Janeiro', 'Brasil', '1980-03-28'),
    (4, 'Orquestra Melodia', 'Nova York', 'Estados Unidos', '1975-09-12'),
    (5, 'Orquestra Aurora', 'Paris', 'França', '1990-07-04'),
    (6, 'Orquestra Luminosa', 'Londres', 'Reino Unido', '1988-11-30'),
    (7, 'Orquestra Imperial', 'Moscou', 'Rússia', '1950-02-18'),
    (8, 'Orquestra Serenata', 'Viena', 'Áustria', '1963-06-25'),
    (9, 'Orquestra Estrelar', 'Los Angeles', 'Estados Unidos', '1978-04-17'),
    (10, 'Orquestra Harmoniosa', 'Berlim', 'Alemanha', '1998-08-22');
    
INSERT INTO Sinfonia (id_sinfonia, nome, compositor, data_criacao, id_orquestra) 
VALUES 
    (1, 'Sinfonia da Aurora', 'Ludwig van Beethoven', '1808-04-07', 5),
    (2, 'Sinfonia da Paixão', 'Johann Sebastian Bach', '1729-09-12', 7),
    (3, 'Sinfonia da Primavera', 'Franz Joseph Haydn', '1786-03-21', 8),
    (4, 'Sinfonia da Floresta Encantada', 'Wolfgang Amadeus Mozart', '1788-02-25', 9),
    (5, 'Sinfonia da Harmonia Celestial', 'Pyotr Ilyich Tchaikovsky', '1878-06-14', 2),
    (6, 'Sinfonia das Estrelas', 'Gustav Mahler', '1902-11-30', 10),
    (7, 'Sinfonia do Luar', 'Antonín Dvořák', '1896-08-03', 1),
    (8, 'Sinfonia do Amanhecer', 'Frédéric Franciszek  Chopin', '1810-10-17', 4),
    (9, 'Sinfonia da Harmonia Cósmica', 'Richard Wagner', '1863-05-08', 3),
    (10, 'Sinfonia Dourada', 'Ludwig van Beethoven', '1813-12-30', 6);
    
INSERT INTO Musico (id_musico, nome, identidade, nacionalidade, data_nascimento, id_orquestra)  
VALUES
	(1, "Dário Rodrigues Queiroz", "39.986.097-6", "Brasileiro", '2004-03-24', 1), 
    (2, "Alfredo Melo Oliveira", "35.556.099-9", "Brasileiro", '2004-02-21', 2), 
    (3, "Maria Reis Silva", "35.935.387-3", "Brasileiro", '1994-02-24', 3),
    (4, "Dondi Diaz", "11.231.976-2", "Estadunidense", '1995-01-19', 9),
    (5, "Alice Lee", "19.598.957-0", "Inglês", '1980-02-14', 6),
    (6, "Avva Denisovich Mamonov", "26.698.839-8", "Russo", '1987-04-26', 7),
    (7, "Roman Marshall", "15.673.072-8", "Estadunidense", '1973-04-11', 4),
    (8, "Célestine Phaneuf", "34.820.150-3", "Francês", '1993-05-06', 5),
    (9, "Wilfried Gaus", "33.337.212-8", "Alemão", '1983-05-03', 10),
    (10, "Charlotte Andris", "17.606.189-7", "Austríaco", '1976-03-18', 8);
    
INSERT INTO Funcao (id_funcao, data_inicio, data_termino, id_musico, id_sinfonia) 
VALUES 
    (9, '2023-01-01', '2023-12-31', 9, 5),
    (1, '2023-01-01', '2023-12-31', 1, 1),
    (2, '2022-05-01', '2022-12-31', 2, 1),
    (5, '2023-01-01', '2023-12-31', 5, 3),
    (10, '2022-08-01', '2022-12-31', 10, 5),
    (3, '2023-01-01', '2023-12-31', 3, 2),
    (7, '2023-01-01', '2023-12-31', 7, 4),
    (6, '2022-11-01', '2022-12-31', 6, 3),
    (8, '2022-06-01', '2022-12-31', 8, 4),
    (4, '2022-07-01', '2022-12-31', 4, 2);

INSERT INTO Instrumento (id_instrumento, nome) 
VALUES
	(1, "Violino"),
    (2, "Violão"),
    (3, "Clarinete"),
    (4, "Xilofone"),	
    (5, "Harpa"),
    (6, "Piano"),
    (7, "Violoncelo"),
    (8, "Flauta"),
    (9, "Oboé"),
    (10, "Saxofone"),
    (11, "Contrabaixo");
    
INSERT INTO Musico_Instrumento(id_musico, id_instrumento) 
VALUES
	(1, 7),
    (2, 8),
    (3, 4),
    (4, 6),	
    (5, 9),
    (6, 5),
    (7, 3),
    (8, 2),
    (9, 1),
    (10, 10);

DELETE FROM Instrumento WHERE id_musico=9;
DELETE FROM Musico WHERE timestampdiff(year, now(), data_nascimento)>70;
DELETE FROM Musico WHERE data_nascimento>'1983-05-03' AND data_nascimento<'1994-02-24';
DELETE FROM Instrumento WHERE id_instrumento=11;
UPDATE Musico SET nacionalidade='Estado-unidense' WHERE nome='Roman Marshall';
UPDATE Orquestra SET nome = CONCAT('Orquestra', ' ', nome) WHERE nome NOT LIKE '%Orquestra%';
UPDATE Musico SET id_orquestra = (SELECT Sinfonia.id_orquestra FROM Sinfonia WHERE Sinfonia.id_sinfonia = Funcao.id_sinfonia) WHERE EXISTS (SELECT 1 FROM Funcao WHERE Funcao.id_musico = Musico.id_musico);
UPDATE Musico_Instrumento SET id_instrumento = (SELECT MAX(id_instrumento) FROM Instrumento);
UPDATE Orquestra SET cidade='Marselha' WHERE cidade='Paris';
UPDATE Funcao SET data_inicio='2023-01-02' WHERE id_funcao=2;
UPDATE Funcao SET data_termino = '2024-08-01' WHERE YEAR(data_termino) NOT IN (2024, 2022, 2020);
UPDATE Sinfonia SET compositor = UPPER(compositor);
UPDATE Sinfonia SET compositor = CONCAT(
          UPPER(SUBSTRING(compositor, 1, 1)), 
          LOWER(SUBSTRING(compositor, 2, LENGTH(compositor) - 1))
       );
UPDATE Sinfonia SET compositor=concat("Compos.", compositor);
UPDATE Instrumento SET nome="Viola" WHERE nome="Contrabaixo";
UPDATE Orquestra SET pais=CONCAT("Estados Unidos", " ", "(EUA)") WHERE pais="Estados Unidos";
UPDATE Musico SET data_nascimento = DATEADD(year, (1999 - YEAR(data_nascimento)), data_nascimento) WHERE id_musico=4;
UPDATE Sinfonia SET data_criacao='1809-05-06' WHERE data_criacao='1810-10-17';
UPDATE Instrumento SET nome="Violão Clássico" WHERE nome="Violão";
UPDATE Musico SET nome="Alice Lee Montgomery" WHERE nome="Alice Lee";

-- DQL--

-- seleciona da tabela orquesta os nomes, cidades e países-- 
SELECT nome, cidade, pais FROM Orquestra;

-- seleciona da tabela Sinfonia o nome delas e seus respectivos compositores --
SELECT nome, compositor FROM Sinfonia;

-- Lista todos os músicos e suas nacionalidades--
SELECT nome, nacionalidade FROM Musico;

-- seleciona todos os músicos que tocam violino--
SELECT m.nome AS nome_musico, i.nome AS instrumento
FROM Musico m
INNER JOIN Musico_Instrumento mi ON m.id_musico = mi.id_musico
INNER JOIN Instrumento i ON mi.id_instrumento = i.id_instrumento
WHERE i.nome = 'Violino';

-- Lista todas as sinfonias compostas por Ludwig van Beethoven--
SELECT nome AS nome_sinfonia
FROM Sinfonia
WHERE compositor = 'Ludwig van Beethoven';

-- Lista todos os músicos que nasceram após 1990--
SELECT nome, data_nascimento
FROM Musico
WHERE data_nascimento > '1990-01-01';

-- Lista todos os músicos que fazem parte da Orquestra Sinfônica--
SELECT m.nome AS nome_musico
FROM Musico m
INNER JOIN Orquestra o ON m.id_orquestra = o.id_orquestra
WHERE o.nome = 'Orquestra Sinfônica';

-- Lista todas as sinfonias criadas após 1800--
SELECT nome AS nome_sinfonia, data_criacao
FROM Sinfonia
WHERE data_criacao > '1800-01-01';

-- Lista todos os músicos e os instrumentos que tocam--
SELECT m.nome AS nome_musico, i.nome AS instrumento
FROM Musico m
LEFT JOIN Musico_Instrumento mi ON m.id_musico = mi.id_musico
LEFT JOIN Instrumento i ON mi.id_instrumento = i.id_instrumento;

-- Listar todas as sinfonias e suas respectivas orquestras--
SELECT s.nome AS nome_sinfonia, o.nome AS nome_orquestra
FROM Sinfonia s
INNER JOIN Orquestra o ON s.id_orquestra = o.id_orquestra;

-- Lista todos os músicos que tocaram em uma sinfonia específica--
SELECT m.nome AS nome_musico
FROM Musico m
INNER JOIN Funcao f ON m.id_musico = f.id_musico
WHERE f.id_sinfonia = (SELECT id_sinfonia FROM Sinfonia WHERE nome = 'Sinfonia da Aurora');

-- Lista todos os músicos e as funções que desempenharam em uma sinfonia específica--
SELECT m.nome AS nome_musico, f.id_funcao, f.data_inicio, f.data_termino
FROM Musico m
INNER JOIN Funcao f ON m.id_musico = f.id_musico
WHERE f.id_sinfonia = (SELECT id_sinfonia FROM Sinfonia WHERE nome = 'Sinfonia da Aurora');

-- Lista todas as sinfonias e o número de músicos que participaram--
SELECT s.nome AS nome_sinfonia, COUNT(f.id_musico) AS num_musicos
FROM Sinfonia s
LEFT JOIN Funcao f ON s.id_sinfonia = f.id_sinfonia
GROUP BY s.nome;

-- Lista todas as sinfonias compostas por Beethoven e Mozart--
SELECT nome AS nome_sinfonia, compositor
FROM Sinfonia
WHERE compositor IN ('Ludwig van Beethoven', 'Wolfgang Amadeus Mozart');

-- Lista todos os músicos que nasceram antes de 1980 e são brasileiros--
SELECT nome, data_nascimento, nacionalidade
FROM Musico
WHERE nacionalidade = 'Brasileiro' AND data_nascimento < '1980-01-01';

-- seleciona da tabela orquestra, todas as orquestras brasileiras--
SELECT nome, cidade, pais
FROM Orquestra
WHERE pais = 'Brasil';

-- Lista todos os músicos que tocam violão e seus respectivos países--
SELECT m.nome AS nome_musico, m.nacionalidade, i.nome AS instrumento
FROM Musico m
INNER JOIN Musico_Instrumento mi ON m.id_musico = mi.id_musico
INNER JOIN Instrumento i ON mi.id_instrumento = i.id_instrumento
WHERE i.nome = 'Violão';

-- Lista todas as sinfonias compostas por Beethoven e suas datas de criação--
SELECT nome AS nome_sinfonia, data_criacao
FROM Sinfonia
WHERE compositor = 'Ludwig van Beethoven';

-- Lista todos os músicos e suas funções em uma sinfonia específica--
SELECT m.nome AS nome_musico, f.id_funcao
FROM Musico m
INNER JOIN Funcao f ON m.id_musico = f.id_musico
WHERE f.id_sinfonia = (SELECT id_sinfonia FROM Sinfonia WHERE nome = 'Sinfonia da Aurora');

-- Lista todas as orquestras e a quantidade de músicos que possuem-- 
SELECT o.nome AS nome_orquestra, COUNT(m.id_musico) AS num_musicos
FROM Orquestra o
LEFT JOIN Musico m ON o.id_orquestra = m.id_orquestra
GROUP BY o.nome;

-- Views dos relatorios elaborados-- 

-- View para listar todas as orquestras e suas respectivas cidades e países--
CREATE VIEW vw_orquestras_info AS
SELECT nome, cidade, pais FROM Orquestra;

-- View para listar todas as sinfonias e seus respectivos compositores--
CREATE VIEW vw_sinfonias_compositores AS
SELECT nome, compositor FROM Sinfonia;

-- View para listar todos os músicos e suas nacionalidades--
CREATE VIEW vw_musicos_nacionalidades AS
SELECT nome, nacionalidade FROM Musico;

-- View para listar todos os músicos que tocam violino--
CREATE VIEW vw_musicos_violino AS
SELECT m.nome AS nome_musico, i.nome AS instrumento
FROM Musico m
INNER JOIN Musico_Instrumento mi ON m.id_musico = mi.id_musico
INNER JOIN Instrumento i ON mi.id_instrumento = i.id_instrumento
WHERE i.nome = 'Violino';

-- View para listar todas as sinfonias compostas por Ludwig van Beethoven--
CREATE VIEW vw_sinfonias_beethoven AS
SELECT nome AS nome_sinfonia
FROM Sinfonia
WHERE compositor = 'Ludwig van Beethoven';

-- View para listar todos os músicos que nasceram após 1990--
CREATE VIEW vw_musicos_nascidos_apos_1990 AS
SELECT nome, data_nascimento
FROM Musico
WHERE data_nascimento > '1990-01-01';

-- View para listar todas as orquestras brasileiras-- 
CREATE VIEW vw_orquestras_brasileiras AS
SELECT nome, cidade, pais
FROM Orquestra
WHERE pais = 'Brasil';

-- View para listar todas as sinfonias e suas respectivas orquestras--
CREATE VIEW vw_sinfonias_orquestras AS
SELECT s.nome AS nome_sinfonia, o.nome AS nome_orquestra
FROM Sinfonia s
INNER JOIN Orquestra o ON s.id_orquestra = o.id_orquestra;

-- View para listar todas as sinfonias e o número de músicos que participaram--
CREATE VIEW vw_sinfonias_num_musicos AS
SELECT s.nome AS nome_sinfonia, COUNT(f.id_musico) AS num_musicos
FROM Sinfonia s
LEFT JOIN Funcao f ON s.id_sinfonia = f.id_sinfonia
GROUP BY s.nome;

-- View para listar todas as sinfonias compostas por Beethoven e datas de criação--
CREATE VIEW vw_sinfonias_beethoven_datas AS
SELECT nome AS nome_sinfonia, data_criacao
FROM Sinfonia
WHERE compositor = 'Ludwig van Beethoven';