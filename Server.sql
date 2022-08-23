/* ORGANIZAR FISICAMENTE E LOGICAMENTE UM BANCO DE DADOS

1 - CRIANDO O BANCO COM ARQUIVOS PARA OS SETORES DE MKT E VENDAS

2 - CRIAR UM ARQUIVO GERAL 

3 - DEIXAR O MDF APENAS COM O DICIONARIO DE DADOS

4 - CRIANDO 2 GRUPOS DE AQUIVOS (PRIMARY)MDF */


/* CONECTANDO A UM BANCO */

USE EMPRESA
GO

/* CRIANDO TABELAS */

CREATE TABLE ALUNO(
	IDALUNO INT PRIMARY KEY IDENTITY,
	NOME VARCHAR(30) NOT NULL,
	SEXO CHAR(1) NOT NULL,
	NACIMENTO DATE NOT NULL,
	EMAIL VARCHAR(30) UNIQUE
)
GO

/* CONSTRAINTS */

ALTER TABLE ALUNO 
ADD CONSTRAINT CK_SEXO CHECK (SEXO IN('M','F'))
GO

/* 1 X 1 */

CREATE TABLE ENDERECO(
	IDENDERECO INT PRIMARY KEY IDENTITY(100,10),
	BAIRRO VARCHAR(30),
	UF CHAR(2) NOT NULL,
	CHECK (UF IN('RJ','SP','MG')),
	ID_ALUNO INT UNIQUE
)
GO

/* CRIANDO A FK */

ALTER TABLE ENDERECO ADD CONSTRAINT FK_ENDERECO_ALUNO
FOREIGN KEY(ID_ALUNO) REFERENCES ALUNO(IDALUNO)
GO

/* COMANDO DE DESCRICAO */

/* PROCEDURES - JA CRIADAS E ARMAZENADAS NO SISTEMA */

SP_COLUMNS ALUNO
GO

SP_HELP ALUNO
GO

/* INSERINDO DADOS */

INSERT INTO ALUNO VALUES('ANDRE','M','1992/07/12','ANDRE@IG.COM')
INSERT INTO ALUNO VALUES('ANA','F','1991/12/09','ANA@IG.COM')
INSERT INTO ALUNO VALUES('RUI','M','1990/03/18','RUI@IG.COM')
INSERT INTO ALUNO VALUES('JOAO','M','1989/11/16','JOAO@IG.COM')
GO

SELECT * FROM ALUNO
GO

/* ENDERECO */

INSERT INTO ENDERECO VALUES('FLAMENGO','RJ',1)
INSERT INTO ENDERECO VALUES('MORUMBI','SP',2)
INSERT INTO ENDERECO VALUES('CENTRO','MG',3)
INSERT INTO ENDERECO VALUES('CENTRO','SP',4)
GO

/* CRIANDO TABELA TELEFONE */

CREATE TABLE TELEFONE(
	IDTELEFONE INT PRIMARY KEY IDENTITY,
	TIPO CHAR(3) NOT NULL,
	NUMERO VARCHAR(10) NOT NULL,
	ID_ALUNO INT,
	CHECK (TIPO IN('RES','COM','CEL'))
)
GO

INSERT INTO TELEFONE VALUES('CEL','2899-4981',1)
INSERT INTO TELEFONE VALUES('RES','3546-1651',1)
INSERT INTO TELEFONE VALUES('CEL','4684-4151',2)
INSERT INTO TELEFONE VALUES('COM','3684-4982',2)
GO

SELECT * FROM ALUNO
GO

/* PEGAR DATA ATUAL */

SELECT GETDATE()
GO

/* CLAUSULA AMBIGUA */

SELECT A.NOME, T.TIPO, T.NUMERO, E.BAIRRO, E.UF 
FROM ALUNO A
INNER JOIN TELEFONE T
ON A.IDALUNO = T.ID_ALUNO
INNER JOIN ENDERECO E
ON A.IDALUNO = E.ID_ALUNO
GO

SELECT A.NOME, T.TIPO, T.NUMERO, E.BAIRRO, E.UF 
FROM ALUNO A LEFT JOIN TELEFONE T
ON A.IDALUNO = T.ID_ALUNO
INNER JOIN ENDERECO E
ON A.IDALUNO = E.ID_ALUNO
GO

/* IFNULL */

SELECT A.NOME, 
			ISNULL(T.TIPO, 'SEM') AS "TIPO",
			ISNULL(T.NUMERO, 'NUMERO') AS "TELEFONE",
			E.BAIRRO, 
			E.UF 
FROM ALUNO A LEFT JOIN TELEFONE T
ON A.IDALUNO = T.ID_ALUNO
INNER JOIN ENDERECO E
ON A.IDALUNO = E.ID_ALUNO
GO

/* DATAS */

SELECT * FROM ALUNO
GO

SELECT NOME, NACIMENTO
FROM ALUNO
GO

/* DATEDIFE - CALCULA A DIFERENCA ENTRE 2 DATAS FUNCAO GETDATE() TRAZ DIA E HORA */

SELECT NOME, GETDATE() AS DIA_HORA FROM ALUNO
GO

/* 1 PASSO */

SELECT NOME, DATEDIFF(DAY,NACIMENTO,GETDATE())
FROM ALUNO 
GO

/* 2 PASSO */

SELECT NOME, DATEDIFF(DAY,NACIMENTO,GETDATE()) AS "IDADE"
FROM ALUNO
GO

/* 3 PASSO - RETORNO EM INTEIRO + OPER MATEMATICA */

SELECT NOME, (DATEDIFF(DAY,NACIMENTO,GETDATE())/365) AS "IDADE"
FROM ALUNO
GO

SELECT NOME, (DATEDIFF(MONTH,NACIMENTO,GETDATE())/12) AS "IDADE"
FROM ALUNO
GO

SELECT NOME, (DATEDIFF(YEAR,NACIMENTO,GETDATE()) AS "IDADE"
FROM ALUNO
GO

/* DATENAME - TRAZ O NOME PARTE DA DATA EM QUESTAO - STRING */

SELECT NOME, DATENAME(MONTH, NACIMENTO)
FROM ALUNO
GO

SELECT NOME, DATENAME(YEAR, NACIMENTO)
FROM ALUNO
GO

SELECT NOME, DATENAME(WEEKDAY, NACIMENTO)
FROM ALUNO
GO

/* DATEPART - POREM O RETORNO E UM INTEIRO */

SELECT NOME, DATEPART(MONTH,NACIMENTO), DATENAME(MONTH,NACIMENTO)
FROM ALUNO
GO

/* DATEADD - RETORNA UMA DATA SOMANDO A OUTRA DATA */

SELECT DATEADD(DAY,365,GETDATE())
SELECT DATEADD(YEAR,10,GETDATE())

/*CONVERSAO DE DADOS */

SELECT 1 + '1'
GO

SELECT '1' + '1'
GO

SELECT 'CURSO DE BANCO DE DADOS' + '1'
GO

SELECT 'CURSO DE BANCO DE DADOS' + '1'
GO

/* FUNCOES DE CONVERSAO DE DADOS */

SELECT CAST('1' AS INT) + CAST('1' AS INT)
GO

/* CONVERSAO E CONCATENACAO */
--https://msdn.microsoft.com/en-us/library/ms191530.aspx

SELECT NOME,
NACIMENTO
FROM ALUNO
GO

SELECT NOME,
DAY(NACIMENTO) + '/' + MONTH(NACIMENTO) + '/' + YEAR(NACIMENTO)
FROM ALUNO
GO

/* EXERCICIO */

SELECT NOME,
DAY(NACIMENTO) + '/' +
MONT(NACIMENTO) + '/' +
YEAR(NACIMENTO)
FROM ALUNO
GO

/* CORRECAO */

SELECT NOME,
CAST(DAY(NACIMENTO) AS VARCHAR) + '/' +
CAST(MONTH(NACIMENTO) AS VARCHAR) + '/' +
CAST(YEAR(NACIMENTO) AS VARCHAR) AS "NACIMENTO"
FROM ALUNO
GO

/* CHARINDEX - RETORNA UM INTEIRO CONTAGEM DEFAULT - INICIA EM 01 */

SELECT NOME, CHARINDEX('A',NOME) AS INDICE
FROM ALUNO
GO

SELECT NOME, CHARINDEX('A',NOME,2) AS INDICE
FROM ALUNO
GO

/* BULK INSERT - IMPORTACAO DE ARQUIVOS */

CREATE TABLE LANCAMENTO_CONTABIL(
	CONTA INT,
	VALOR INT,
	DEB_CRED CHAR(1)
)
GO

SELECT * FROM LANCAMENTO_CONTABIL
GO

/* \T = TAB */

BULK INSERT LANCAMENTO_CONTABIL
FROM 'Z:\CONTAS.txt'
WITH
(
	FIRSTROW = 2,
	DATAFILETYPE = 'char',
	FIELDTERMINATOR = '\t',
	ROWTERMINATOR = '\n'
)
GO

SELECT * FROM LANCAMENTO_CONTABIL
GO

DELETE FROM LANCAMENTO_CONTABIL
GO

/* DESAFIO DO SALDO QUERY QUE TRAGA O NUMERO DA CONTA SALDO - DEVEDOR OU CREDOR */

SELECT CONTA, VALOR, DEB_CRED,
CHARINDEX('D',DEB_CRED) AS DEBITO,
CHARINDEX('C',DEB_CRED) AS CREDITO,
CHARINDEX('C',DEB_CRED) * 2 - 1 AS MULTIPLICADOR
FROM LANCAMENTO_CONTABIL
GO

SELECT CONTA,
SUM(VALOR * (CHARINDEX('C',DEB_CRED) * 2 - 1)) AS SALDO
FROM LANCAMENTO_CONTABIL
GROUP BY CONTA
GO

/* TRIGGERS */

CREATE TABLE PRODUTOS(
	IDPRODUTO INT IDENTITY PRIMARY KEY,
	NOME VARCHAR(50) NOT NULL,
	CATEGORIA VARCHAR(30) NOT NULL,
	PRECO NUMERIC(10,2) NOT NULL
)
GO 

CREATE TABLE HISTORICO(
	IDOPERACAO INT PRIMARY KEY IDENTITY,
	PRODUTO VARCHAR(50) NOT NULL,
	CATEGORIA VARCHAR(30) NOT NULL,
	PRECOANTIGO NUMERIC(10,2) NOT NULL,
	PRECONOVO NUMERIC(10,2) NOT NULL,
	DATA DATETIME,
	USUARIO VARCHAR(30),
	MENSAGEM VARCHAR(100)
)
GO 

INSERT INTO PRODUTOS VALUES('LIVRO SQL SERVER','LIVROS',98.00)
INSERT INTO PRODUTOS VALUES('LIVRO ORACLE','LIVROS',50.00)
INSERT INTO PRODUTOS VALUES('LICENCA POWERCENTER','SOFTWARES',45000.00)
INSERT INTO PRODUTOS VALUES('NOTBOOK I7','COMPUTADORES',3150.00)
INSERT INTO PRODUTOS VALUES('LIVRO BUSINESS INTELLIGENCE','LIVROS',90.00)
GO

SELECT * FROM PRODUTOS
SELECT * FROM HISTORICO
GO

/* VERIFICANDO O USUARIO */

SELECT SUSER_NAME()
GO

/*TRIGGER DE DADOS - DATA MANIPULATION LANGUAGE */

CREATE TRIGGER TRG_ATUALIZA_PRECO
ON DBO.PRODUTOS
FOR UPDATE
AS
		
		DECLARE @IDPRODUTO INT
		DECLARE @PRODUTO VARCHAR(30)
		DECLARE @CATEGORIA VARCHAR(10)
		DECLARE @PRECO NUMERIC(10,2)
		DECLARE @PRECONOVO NUMERIC(10,2)
		DECLARE @DATA DATETIME
		DECLARE @USUARIO VARCHAR(30)
		DECLARE @ACAO VARCHAR(100)
		
		--PRIMEIRO BLOCO
		SELECT @IDPRODUTO = IDPRODUTO FROM INSERTED
		SELECT @PRODUTO = NOME FROM INSERTED
		SELECT @CATEGORIA = CATEGORIA FROM INSERTED
		SELECT @PRECO = PRECO FROM DELETED
		SELECT @PRECONOVO = PRECO FROM INSERTED
		
		--SEGUNDO BLOCO
		SET @DATA = GETDATE()
		SET @USUARIO = SUSER_NAME()
		SET @ACAO = 'VALOR INSERIDO PELA TRIGGER TRG_ATUALIZA_PRECO'
		INSERT INTO HISTORICO
		(PRODUTO,CATEGORIA,PRECOANTIGO,PRECONOVO,DATA,USUARIO,MENSAGEM)
		VALUES(@PRODUTO,@CATEGORIA,@PRECO,@PRECONOVO,@DATA,@USUARIO,@ACAO)
		PRINT 'TRIGGER EXECUTADA COM SUCESSO'
GO

/* EXECUTAR UM UPDATE */

UPDATE PRODUTOS SET PRECO = 100.00
WHERE IDPRODUTO = 1
GO

SELECT * FROM PRODUTOS
SELECT * FROM HISTORICO
GO

UPDATE PRODUTOS SET NOME = 'LIVRO C#'
WHERE IDPRODUTO = 1
GO

DROP TRIGGER TRG_ATUALIZA_PRECO

CREATE TRIGGER TRG_ATUALIZA_PRECO
ON DBO.PRODUTOS
FOR UPDATE AS
IF UPDATE(PRECO)
BEGIN
		DECLARE @IDPRODUTO INT
		DECLARE @PRODUTO VARCHAR(30)
		DECLARE @CATEGORIA VARCHAR(10)
		DECLARE @PRECO NUMERIC(10,2)
		DECLARE @PRECONOVO NUMERIC(10,2)
		DECLARE @DATA DATETIME
		DECLARE @USUARIO VARCHAR(30)
		DECLARE @ACAO VARCHAR(100)
		
		--PRIMEIRO BLOCO
		SELECT @IDPRODUTO = IDPRODUTO FROM INSERTED
		SELECT @PRODUTO = NOME FROM INSERTED
		SELECT @CATEGORIA = CATEGORIA FROM INSERTED
		SELECT @PRECO = PRECO FROM DELETED
		SELECT @PRECONOVO = PRECO FROM INSERTED
		
		--SEGUNDO BLOCO
		SET @DATA = GETDATE()
		SET @USUARIO = SUSER_NAME()
		SET @ACAO = 'VALOR INSERIDO PELA TRIGGER TRG_ATUALIZA_PRECO'
		INSERT INTO HISTORICO
		(PRODUTO,CATEGORIA,PRECOANTIGO,PRECONOVO,DATA,USUARIO,MENSAGEM)
		VALUES(@PRODUTO,@CATEGORIA,@PRECO,@PRECONOVO,@DATA,@USUARIO,@ACAO)
		PRINT 'TRIGGER EXECUTADA COM SUCESSO'
END
GO

UPDATE PRODUTOS SET PRECO = 300,00
WHERE IDPRODUTO = 2
GO

SELECT * FROM HISTORICO

UPDATE PRODUTOS SET NOME = 'LIVRO JAVA'
WHERE IDPRODUTO = 2
GO

/* VARIAVES COM SELECT */

SELECT 10 + 10
GO

CREATE TABLE RESULTADO(
	IDRESULTADO INT PRIMARY KEY IDENTITY,
	RESULTADO INT
)
GO

INSERT INTO RESULTADO VALUES((SELECT 10 + 10))
GO

SELECT * FROM RESULTADO
GO

/* ATRIBUIR SELECT A VARIAVEIS - ANONIMO */

DECLARE
		@RESULTADO INT
		SET @RESULTADO = (SELECT 50 + 50)
		INSERT INTO RESULTADO VALUES(@RESULTADO)
		GO
		
DECLARE
		@RESULTADO INT
		SET @RESULTADO = (SELECT 50 + 50)
		INSERT INTO RESULTADO VALUES(@RESULTADO)
		PRINT 'VALOR INSERIDO NA TABELA: ' + CAST(@RESULTADO AS VARCHAR)
		GO

/* TRIGGER UPDATE */

CREATE TABLE EMPREGADO(
	IDEMP INT PRIMARY KEY,
	NOME VARCHAR(30),
	SALARIO MONEY,
	IDGERENTE INT
)
GO

ALTER TABLE EMPREGADO ADD CONSTRAINT FK_GERENTE
FOREIGN KEY(IDGERENTE) REFERENCES EMPREGADO(IDEMP)
GO

INSERT INTO EMPREGADO VALUES(1,'CLARA',5000.00,NULL)
INSERT INTO EMPREGADO VALUES(2,'CELIA',4000.00,1)
INSERT INTO EMPREGADO VALUES(3,'JOAO',4000.00,1)
GO

CREATE TABLE HIST_SALARIO(
	IDEMPREGADO INT,
	ANTIGOSAL MONEY,
	NOVOSAL MONEY,
	DATA DATETIME
)
GO

CREATE TRIGGER TG_SALARIO
ON DBO.EMPREGADO
FOR UPDATE AS
IF UPDATE(SALARIO)
BEGIN
	INSERT INTO HIST_SALARIO
	(IDEMPREGADO,ANTIGOSAL,NOVOSAL,DATA)
	SELECT D.IDEMP,D.SALARIO,I.SALARIO,GETDATE()
	FROM DELETED D, INSERTED
	WHERE D.IDEMP = I.IDEMP
END
GO

UPDATE EMPREGADO SET SALARIO = SALARIO * 1.1
GO
SELECT * FROM EMPREGADO
SELECT * FROM HIST_SALARIO
GO

/* SALARIO ANTIGO, NOVO, DATA ENOME DO EMPREGADO */

CREATE TABLE SALARIO_RANGE(
	MINSAL MONEY,
	MAXSAL MONEY
)
GO

INSERT INTO SALARIO_RANGE VALUES(3000.00,6000.00)
GO

CREATE TRIGGER TG_RANGE
ON DBO.EMPREGADO
FOR INSERT,UPDATE
AS
	DECLARE
		@MINSAL MONEY,
		@MAXSAL MONEY,
		@ATUALSAL MONEY
	SELECT @MINSAL = MINSAL, @MAXSAL = MAXSAL FROM SALARIO_RANGE
	SELECT @ATUALSAL = I.SALARIO
	FROM INSERTED I
	IF(@ATUALSAL < @MINSAL)
	BEGIN
			RAISERROR('SALARIO MENOR QUE O PISO',16,1)
			ROLLBACK TRANSACTION
	END
	IF(@ATUALSAL > @MAXSAL)
	BEGIN
			RAISERROR('SALARIO MENOR QUE 0 TETO',16,1)
			ROLLBACK TRANSACTION
	END
GO

UPDATE EMPREGADO SET SALARIO = 9000,00
WHERE IDEMP = 1
GO

UPDATE EMPREGADO SET SALARIO = 1000,00
WHERE IDEMP = 1
GO

/* VERIFICANDO TEXTO DE NA TRIGGER */

SP_HELPTEXT TG_RANGE
GO

/* PROCEDURES */

--SP_ STORAGE PROCEDURE

CREATE TABLE PESSOA(
	IDPESSOA INT PRIMARY KEY IDENTITY,
	NOME VARCHAR(30) NOT NULL,
	SEXO CHAR(1) NOT NULL CHECK (SEXO IN('M','F')), --ENUM
	NACIMENTO DATE NOT NULL
)
GO

CREATE TABLE TELEFONE(
	IDTELEFONE INT PRIMARY KEY IDENTITY,
	TIPO CHAR(3) NOT NULL CHECK (TIPO IN('CEL','COM')),
	NUMERO VARCHAR(10) NOT NULL, 
	ID_PESSOA INT
)
GO

ALTER TABLE TELEFONE ADD CONSTRAINT FK_TELEFONE_PESSOA
FOREIGN KEY(ID_PESSOA) REFERENCES PESSOA(IDPESSOA)
ON DELETE CASCADE
GO

INSERT INTO PESSOA VALUES('ANTONIO','M','1980-10-12')
INSERT INTO PESSOA VALUES('DANIEL','M','1995-02-20')
INSERT INTO PESSOA VALUES('CELIA','F','1985-02-15')
INSERT INTO PESSOA VALUES('MAFRA','M','1990-03-08')

SELECT @@IDENTITY --GUARDA O UTIMO IDENTITY INSERIDO NA SECAO
GO

SELECT * FROM PESSOA

INSERT INTO TELEFONE VALUES('CEL','95614-8499',1)
INSERT INTO TELEFONE VALUES('COM','95614-8499',1)
INSERT INTO TELEFONE VALUES('CEL','95614-8499',2)
INSERT INTO TELEFONE VALUES('CEL','95614-8499',2)
INSERT INTO TELEFONE VALUES('COM','95614-8499',3)
INSERT INTO TELEFONE VALUES('COM','95614-8499',2)
INSERT INTO TELEFONE VALUES('CEL','95614-8499',3)
GO

/* CRIANDO A PROCEDURE */

CREATE PROC SOMA
AS
	SELECT 10 + 10 AS SOMA
GO

/* EXECUCAO DA PROCEDURE */

SOMA

EXEC SOMA
GO

/* DINAMICAS - COM PARAMETROS */

CREATE PROC CONTA @NUM1 INT, @NUM2 INT
AS
	SELECT @NUM1 + @NUM2 AS RESULTADO
GO

/* EXECUTANDO */

EXEC CONTA 90, 78
GO

/* APAGANDO PROCEDURE */

DROP PROC CONTA
GO

/* PROCEDURE EM TABELAS */

SELECT NOME, NUMERO
FROM PESSOA
INNER JOIN TELEFONE
ON IDPESSOA = ID_PESSOA
WHERE TIPO = 'CEL'
GO

/* TRAZER OS TELEFONES DE ACORDO COM TIPO PASSADO */

CREATE PROC TELEFONES @TIPO CHAR(3)
AS
	SELECT NOME, NUMERO
	FROM PESSOA
	INNER JOIN TELEFONE
	ON IDPESSOA = ID_PESSOA
	WHERE TIPO = @TIPO
GO

EXEC TELEFONES 'CEL'
GO

EXEC TELEFONE 'COM'
GO

/* PARAMENTROS DE OUTOUT */

SELECT TIPO, COUNT(*) AS QUANTIDADE
FROM TELEFONE 
GROUP BY TIPO
GO

/* CRIANDO PROCEDURE COM PARAMETROS DE ENTRADA E PARAMETROS DE SAIDA */

CREATE PROCEDURE GETTIPO @TIPO CHAR(3), @CONTADOR INT OUTPUT
AS
	SELECT @CONTADOR = COUNT(*)
	FROM TELEFONE
	WHERE TIPO = @TIPO
GO

/* EXECUCAO DE PRO COM PARAMETRO DE SAIDA */

/* TRANSACTION SQL -> LINGUAGEM QUE O SQL SERVE TRABALHA */

DECLARE @SAIDA INT
EXEC GETTIPO @TIPO ='CEL',@CONTADOR = @SAIDA OUTPUT
SELECT @SAIDA
GO

DECLARE @SAIDA INT
EXEC GETTIPO 'COM',@SAIDA OUTPUT
SELECT @SAIDA
GO

/* PROCEDURE DE CADASTRO */

CREATE PROC CADASTRO @NOME VARCHAR(30), @SEXO CHAR(1), 
@NASCIMENTO DATE, @TIPO CHAR(3), @NUMERO VARCHAR(10)
AS
	DECLARE @FK INT
	INSERT INTO PESSOA VALUES(@NOME,@SEXO,@NASCIMENTO) --GERAR UM ID
	SET @FK = (SELECT IDPESSOA FROM PESSOA WHERE IDPESSOA = @@IDENTITY)
	INSERT INTO TELEFONE VALUES(@TIPO,@NUMERO,@FK)
GO

CADASTRO 'JORGE','M','1981'-01-01',CEL','93546-1245'
GO

SELECT PESSOA.*,TELEFONE.*
FROM PESSOA
INNER JOIN TELEFONE
ON IDPESSOA = ID_PESSOA
GO

/* TSQL E UM BLOCO DE LIGUAGEM DE PROGRAMACAO.
PROGRAMACAO SAO UNIDADES QUE PODEM SER CHAMADAS DE BLOCOS ANONIMOS.
BLOCOS ANONIMOS NAO RECEBEM NOME, POIS NAO SAO SALVO NO BLOCO.
CRIANDO BLOCOS ANONIMOS QUANDO IREMOS EXECUTA-LOS UMA SO VEZ OU TESTAR ALGO */

/* BLOCO DE EXECUCAO */

BEGIN
	PRINT 'PRIMEIRO BLOCO'
END
GO

/* BLOCOS DE ATRIBUICAO DE VARIAVEIS */

DECLARE
	@CONTADOR INT
BEGIN
	SET @CONTADOR = 5
	PRINT @CONTADOR
END
GO

/* NO SQL CADA COLUNA, VARIAVEL COLUNA, EXPRECAO E PARAMETRO TEM UM TIPO. */

DECLARE
	@V_NUMERO NUMERIC(10,2) = 100.52,
	@V_DATA DATETIME = '20170207'
BEGIN
	PRINT 'VALOR NUMERICO: ' + CAST(@V_NUMERO AS VARCHAR)
	PRINT 'VALOR NUMERICO: ' + CONVERT(VARCHAR, @V_NUMERO)
	PRINT 'VALOR DATA: ' + CAST(@V_DATA AS VARCHAR)
	PRINT 'VALOR DATA: ' + CONVERT(VARCHAR, @V_DATA, 121)
	PRINT 'VALOR DATA: ' + CONVERT(VARCHAR, @V_DATA, 120)
	PRINT 'VALOR DATA: ' + CONVERT(VARCHAR, @V_DATA, 105)
END
GO

/* ATRIBUNINDO RESULTADOS A UMA VARIAVEL */

CREATE TABLE CARROS(
	CARRO VARCHAR(20),
	FABRICANTE VARCHAR(30)
)
GO

INSERT INTO CARROS VALUES('KA','FORD')
INSERT INTO CARROS VALUES('FIESTA','FORD')
INSERT INTO CARROS VALUES('PRISMA','FORD')
INSERT INTO CARROS VALUES('CLIO','RENAULT')
INSERT INTO CARROS VALUES('SANDERO','RENAULT')
INSERT INTO CARROS VALUES('CHEVETE','CHEVROLET')
INSERT INTO CARROS VALUES('OMEGA','CHEVROLET')
INSERT INTO CARROS VALUES('PALIO','FIAT')
INSERT INTO CARROS VALUES('DOBLO','FIAT')
INSERT INTO CARROS VALUES('UNO','FIAT')
INSERT INTO CARROS VALUES('GOL','VOLKSWAGEN')
GO

DECLARE
	@V_CONT_FORD INT,
	@V_CONT_FIAT INT
BEGIN
	--METODO 1 - O SELECT PRECISA RETORNAR UMA SIMPLES COLUNA
	--E UM SO RESULTADO
	SET @V_CONT_FORD = (SELECT COUNT(*) FROM CARROS
	WHERE FABRICANTE = 'FORD')
	
	PRINT 'QUANTIDADE FORD: ' + CAST(@V_CONT_FORD AS VARCHAR)
	
	--METODO 2
	SELECT @V_CONT_FIAT = COUNT(*) FROM CARROS WHERE FABRICANTE = 'FIAT'
	
	PRINT 'QUANTIDADE FIAT: ' + CONVERT(VARCHAR, @V_CONT_FIAT)
END
GO

/* BLOCO IF E ELSE BLOCO NOMEADO - PROCEDURES */

DECLARE
	@NUMERO INT = 6 --DINAMICO
BEGIN
	IF @NUMERO = 5 --EXPRECAO BOOLEANA - TRUE
		PRINT 'O VALOR E VERDADEIRO'
	ELSE
		PRINT 'O VALOR E FALSO'
END
GO

/* CASE */

DECLARE
	@CONTADOR INT
BEGIN
	SELECT --O CASE REPRESENTA UMA COLUNA
	CASE
		WHEN FABRICANTE = 'FIAT' THEN 'FAIXA 1'
		WHEN FABRICANTE = 'CHEVROLET' THEN 'FAIXA 2'
		ELSE 'OUTRAS FAIXAS'
	END AS "INFORMACOES",
	*
	FROM CARROS
END
GO
	SELECT --O CASE REPRESENTA UMA COLUNA 
	CASE
		WHEN FABRICANTE = 'FIAT' THEN 'FAIXA 1'
		WHEN FABRICANTE = 'CHEVROLET' THEN 'FAIXA 2'
		ELSE 'OUTRAS FAIXAS'
	END AS "INFORMACOES",
	*
	FROM CARROS
GO

/* LOOPS WHILE */

DECLARE
		@I INT = 1
BEGIN
		WHILE (@I < 15)
		BEGIN
			PRINT 'VALOR DE @I = ' + CAST(@I AS VARCHAR)
			SET @I = @I + 1
		END
END
GO