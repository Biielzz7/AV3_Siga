CREATE DATABASE Siga
GO

USE Siga
GO

CREATE TABLE aluno (
ra			 INT			NOT NULL,
nome	  VARCHAR(100)		NOT NULL
PRIMARY KEY (ra)
)
GO

CREATE TABLE disciplina (
codigo       VARCHAR(10)           NOT NULL,
nome      VARCHAR(100)      NOT NULL,
sigla     VARCHAR(10)           NOT NULL,
turno     CHAR(5)           NOT NULL,
num_aulas     INT			NOT NULL
PRIMARY KEY (codigo)

)
GO

CREATE TABLE avaliacao (
codigo		  INT          NOT NULL,
tipo          VARCHAR(20)   NOT NULL
PRIMARY KEY (codigo)
)
GO

CREATE TABLE faltas (
ra_aluno			  INT			NOT NULL,
codigo_disciplina     VARCHAR(10)	NOT NULL,
data				  DATE          NOT NULL,
presenca              CHAR(4)       NULL,
num_faltas            INT           NULL
PRIMARY KEY (ra_aluno, codigo_disciplina, data),
FOREIGN KEY (ra_aluno) REFERENCES aluno (ra),
FOREIGN KEY (codigo_disciplina) REFERENCES disciplina (codigo)
)
GO

CREATE TABLE notas (
ra_aluno              INT            NOT NULL,
codigo_disciplina     VARCHAR(10)    NOT NULL,
codigo_avaliacao      INT            NOT NULL,
nota                  DECIMAL(7, 1)  NOT NULL,
peso                  DECIMAL(7, 3)  NULL
PRIMARY KEY(ra_aluno, codigo_disciplina, codigo_avaliacao),
FOREIGN KEY (ra_aluno) REFERENCES aluno (ra),
FOREIGN KEY (codigo_disciplina) REFERENCES disciplina (codigo),
FOREIGN KEY (codigo_avaliacao) REFERENCES avaliacao (codigo)
)
GO

INSERT INTO aluno (ra, nome) VALUES
(1111, 'Gabriel Elias da Silva'),
(2222, 'Lucas Bezerra Coelho'),
(3333, 'Knull')
GO

INSERT INTO disciplina (codigo, nome, sigla, turno, num_aulas) VALUES 
('4203-010', 'Arquitetura e Organizacao de Computadores', 'AOC', 'T', 80),
('4203-020', 'Arquitetura e Organizacao de Computadores', 'AOC', 'N', 80),
('4208-10', 'Laboratorio de Hardware', 'LabHw', 'T', 40),
('4226-004', 'Banco de Dados', 'BD', 'T', 80),
('4213-003', 'Sistemas Operacionais I', 'SO I', 'T', 80),
('4213-013', 'Sistemas Operacionais I', 'SO I', 'N', 80),
('4233-005', 'Laboratorio de Banco De Dados', 'LabBD', 'T', 80),
('5005-220', 'Metodos para a Producao do Conhecimento', 'MPC', 'T', 40)
GO

INSERT INTO avaliacao (codigo, tipo) VALUES
(1, 'P1'),
(2, 'P2'),
(3, 'P3'),
(4, 'Trabalho'),
(5, 'Monografia Completa'),
(6, 'Monografia Resumida')
GO


-- a) Fazer o sistema para inserção de notas;
CREATE PROCEDURE p_insercao_notas(@nome_aluno VARCHAR(30),
                                  @sigla_disciplina VARCHAR(10),
								  @turno CHAR(1),
								  @tipo_avaliacao VARCHAR(30),
                                  @nota_aluno DECIMAL(7,2))
AS
BEGIN
     DECLARE @ra_aluno INT,
	         @codigo_disciplina VARCHAR(10),
			 @codigo_avaliacao VARCHAR(10)

     SET @ra_aluno = (SELECT ra FROM aluno WHERE nome = @nome_aluno)
	 Print(@ra_aluno)

	 SET @codigo_disciplina = (SELECT codigo FROM disciplina WHERE sigla = @sigla_disciplina AND turno = @turno)
	 PRINT(@codigo_disciplina)

	 SET @codigo_avaliacao = (SELECT codigo FROM avaliacao WHERE tipo = @tipo_avaliacao)
	 PRINT(@codigo_avaliacao)


	 INSERT INTO notas (ra_aluno, codigo_disciplina, codigo_avaliacao, nota)
	 VALUES            (@ra_aluno, @codigo_disciplina, @codigo_avaliacao, @nota_aluno)
END

-- TRIGGER que inseri os pesos da notas das devidas disciplinas
DROP TRIGGER t_inserir_peso_das_notas

CREATE TRIGGER t_inserir_peso_das_notas ON notas
FOR INSERT 
AS
BEGIN
    SELECT * FROM INSERTED

    DECLARE @peso              DECIMAL(7, 3),
	        @codigo_disciplina VARCHAR(10),
			@codigo_avaliacao  INT,
			@ra_aluno INT
    
    SET @codigo_disciplina = (SELECT codigo_disciplina FROM INSERTED)
	SET @codigo_avaliacao = (SELECT codigo_avaliacao FROM INSERTED)
	SET @ra_aluno = (SELECT ra_aluno FROM INSERTED)

    IF((@codigo_disciplina = '4203-010' OR @codigo_disciplina = '4203-020') AND @codigo_avaliacao = 1)
	BEGIN
	     SET @peso = 0.3
	END
	ELSE IF((@codigo_disciplina = '4203-010' OR @codigo_disciplina = '4203-020') AND @codigo_avaliacao = 2)
	BEGIN
	     SET @peso = 0.5
	END

	ELSE IF((@codigo_disciplina = '4203-010' OR @codigo_disciplina = '4203-020') AND @codigo_avaliacao = 4)
    BEGIN
		 SET @peso = 0.2
    END 

	ELSE IF((@codigo_disciplina = '4208-10') AND @codigo_avaliacao = 1)
    BEGIN
		 SET @peso = 0.3		      
    END

	ELSE IF((@codigo_disciplina = '4208-10') AND @codigo_avaliacao = 2)
    BEGIN
		 SET @peso = 0.5	      
    END

	ELSE IF((@codigo_disciplina = '4208-10') AND @codigo_avaliacao = 4)
    BEGIN
		 SET @peso = 0.2	      
	END

	ELSE IF((@codigo_disciplina = '4213-003' OR @codigo_disciplina = '4213-013') AND @codigo_avaliacao = 1)
	BEGIN
		 SET @peso = 0.35
    END

	ELSE IF((@codigo_disciplina = '4213-003' OR @codigo_disciplina = '4213-013') AND @codigo_avaliacao = 2)
    BEGIN
		 SET @peso = 0.35
	END

	ELSE IF((@codigo_disciplina = '4213-003' OR @codigo_disciplina = '4213-013') AND @codigo_avaliacao = 4)
	BEGIN
		 SET @peso = 0.3
	END

	ELSE IF(@codigo_disciplina = '4226-004' AND @codigo_avaliacao = 1)
	BEGIN
		 SET @peso = 0.3
	END

	ELSE IF(@codigo_disciplina = '4226-004' AND @codigo_avaliacao = 2)
	BEGIN
		 SET @peso = 0.5
	END

	ELSE IF(@codigo_disciplina = '4226-004' AND @codigo_avaliacao = 4)
	BEGIN
		 SET @peso = 0.2
	END

	ELSE IF(@codigo_disciplina = '4233-005' AND @codigo_avaliacao = 1)
	BEGIN
		 SET @peso = 0.333
	END

	ELSE IF(@codigo_disciplina = '4233-005' AND @codigo_avaliacao = 2)
	BEGIN
		 SET @peso = 0.333
	END

	ELSE IF(@codigo_disciplina = '4233-005' AND @codigo_avaliacao = 3)
	BEGIN
		 SET @peso = 0.333
	END 
											  
	ELSE IF(@codigo_disciplina = '5005-220' AND @codigo_avaliacao = 5)
	BEGIN
		 SET @peso = 0.8
	END

	ELSE IF(@codigo_disciplina = '5005-220' AND @codigo_avaliacao = 6)
	BEGIN
	     SET @peso = 0.2
	END
												    
	UPDATE notas 
	SET peso = @peso
	WHERE codigo_disciplina = @codigo_disciplina 
	  AND codigo_avaliacao = @codigo_avaliacao
	  AND ra_aluno = @ra_aluno
END

SELECT * FROM disciplina
SELECT * FROM avaliacao
SELECT * FROM notas

DELETE notas

EXEC p_insercao_notas 'Knull', 'MPC', 'T', 'Monografia Completa', 8
EXEC p_insercao_notas 'Knull', 'MPC', 'T', 'Monografia Resumida', 8

EXEC p_insercao_notas 'Knull', 'LabBD', 'T', 'P1', 9
EXEC p_insercao_notas 'Knull', 'LabBD', 'T', 'P2', 9
EXEC p_insercao_notas 'Knull', 'LabBD', 'T', 'P3', 9

EXEC p_insercao_notas 'Knull', 'BD', 'T', 'P1', 8
EXEC p_insercao_notas 'Knull', 'BD', 'T', 'P2', 8
EXEC p_insercao_notas 'Knull', 'BD', 'T', 'Trabalho', 8

EXEC p_insercao_notas 'Knull', 'SO I', 'T', 'P1', 7
EXEC p_insercao_notas 'Knull', 'SO I', 'T', 'P2', 7
EXEC p_insercao_notas 'Knull', 'SO I', 'T', 'Trabalho', 9.5

EXEC p_insercao_notas 'Knull', 'LabHw', 'T', 'P1', 3
EXEC p_insercao_notas 'Knull', 'LabHw', 'T', 'P2', 4
EXEC p_insercao_notas 'Knull', 'LabHw', 'T', 'Trabalho', 3

EXEC p_insercao_notas 'Knull', 'AOC', 'T', 'P1', 9.5
EXEC p_insercao_notas 'Knull', 'AOC', 'T', 'P2', 8
EXEC p_insercao_notas 'Knull', 'AOC', 'T', 'Trabalho', 10

EXEC p_insercao_notas 'Lucas Bezerra Coelho', 'AOC', 'T', 'P1', 9
EXEC p_insercao_notas 'Lucas Bezerra Coelho', 'AOC', 'T', 'P2', 8.5
EXEC p_insercao_notas 'Lucas Bezerra Coelho', 'AOC', 'T', 'Trabalho', 8.5

EXEC p_insercao_notas 'Gabriel Elias da Silva', 'AOC', 'T', 'P1', 10
EXEC p_insercao_notas 'Gabriel Elias da Silva', 'AOC', 'T', 'P2', 10
EXEC p_insercao_notas 'Gabriel Elias da Silva', 'AOC', 'T', 'Trabalho', 10

select * from aluno


-- b) Fazer o sistema para inserção de faltas;
DROP PROCEDURE p_insere_faltas_presencas

CREATE PROCEDURE p_insere_faltas_presencas (@nome_aluno VARCHAR(30),
                                            @sigla_disciplina VARCHAR(10),
											@turno CHAR(1),
											@data DATE,
											@presenca CHAR(4))
AS
BEGIN
     DECLARE @ra_aluno          INT,
	         @codigo_disciplina VARCHAR(10),
			 @data_inicio       DATE,
			 @data_aula         DATE,
			 @data_fim          DATE
			 
		
        SET @ra_aluno = (SELECT ra FROM aluno WHERE nome = @nome_aluno)
		SET @codigo_disciplina = (SELECT codigo FROM disciplina WHERE sigla = @sigla_disciplina AND turno = @turno)

		 PRINT(@ra_aluno)
		 PRINT(@codigo_disciplina)
		 PRINT(@data)
		 PRINT(@presenca)		 

		 INSERT INTO faltas (ra_aluno, codigo_disciplina, data, presenca)
		 VALUES             (@ra_aluno, @codigo_disciplina, @data, @presenca)
END

EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '03/02/2023', 'FPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '10/02/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '17/02/2023', 'PPFF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '24/02/2023', 'PPPF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '03/03/2023', 'FFPP'

EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '10/03/2023', 'FFPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '17/03/2023', 'FFPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '24/03/2023', 'FFPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '31/03/2023', 'FFPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '07/04/2023', 'FFPP'

EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '14/04/2023', 'FFPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '21/04/2023', 'FFPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '28/04/2023', 'FFPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '04/05/2023', 'FFPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '11/05/2023', 'FFPP'

EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '18/05/2023', 'FFPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '25/05/2023', 'FFPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '01/06/2023', 'FFPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '08/06/2023', 'FFPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '15/06/2023', 'FFPP'



-- TRIGGER que inseri um numero de faltas baseado nas presenças dos alunos
DROP TRIGGER t_insere_valor_faltas

CREATE TRIGGER t_insere_valor_faltas ON faltas
FOR INSERT
AS
BEGIN
     DECLARE @presenca CHAR(4),
             @ra_aluno INT,
			 @codigo_disciplina varchar(10),
			 @data DATE,
             @num_faltas INT

	     SELECT * FROM INSERTED

		 SET @presenca = (SELECT presenca FROM INSERTED)
		 SET @ra_aluno = (SELECT ra_aluno FROM INSERTED)
		 SET @codigo_disciplina = (SELECT codigo_disciplina FROM INSERTED)
		 SET @data = (SELECT data FROM INSERTED)

		 -- Condições para as aulas com 4 presenças ou faltas
		 IF(SUBSTRING(@presenca, 1, 1) = 'P' AND SUBSTRING(@presenca, 2, 1) = 'P' AND SUBSTRING(@presenca, 3, 1) = 'P' AND SUBSTRING(@presenca, 4, 1) = 'P')
		 BEGIN
		      SET @num_faltas = 0
		 END
		 ELSE IF ((SUBSTRING(@presenca, 1, 1) = 'F' AND SUBSTRING(@presenca, 2, 1) = 'P' AND SUBSTRING(@presenca, 3, 1) = 'P' AND SUBSTRING(@presenca, 4, 1) = 'P') OR
		          (SUBSTRING(@presenca, 1, 1) = 'P' AND SUBSTRING(@presenca, 2, 1) = 'P' AND SUBSTRING(@presenca, 3, 1) = 'P' AND SUBSTRING(@presenca, 4, 1) = 'F')) 
		 BEGIN
		      SET @num_faltas = 1
		 END 
		 ELSE IF ((SUBSTRING(@presenca, 1, 1) = 'F' AND SUBSTRING(@presenca, 2, 1) = 'F' AND SUBSTRING(@presenca, 3, 1) = 'P' AND SUBSTRING(@presenca, 4, 1) = 'P') OR
		          (SUBSTRING(@presenca, 1, 1) = 'P' AND SUBSTRING(@presenca, 2, 1) = 'P' AND SUBSTRING(@presenca, 3, 1) = 'F' AND SUBSTRING(@presenca, 4, 1) = 'F'))
		 BEGIN
		      SET @num_faltas = 2
		 END
		 ELSE IF (SUBSTRING(@presenca, 1, 1) = 'F' AND SUBSTRING(@presenca, 2, 1) = 'F' AND SUBSTRING(@presenca, 3, 1) = 'F' AND SUBSTRING(@presenca, 4, 1) = 'P')
		 BEGIN
		      SET @num_faltas = 3
		 END
		 ELSE IF (SUBSTRING(@presenca, 1, 1) = 'F' AND SUBSTRING(@presenca, 2, 1) = 'F' AND SUBSTRING(@presenca, 3, 1) = 'F' AND SUBSTRING(@presenca, 4, 1) = 'F')
		 BEGIN
		      SET @num_faltas = 4
		 END

		 -- Condições para as aulas com 2 presenças ou faltas
		 IF((@codigo_disciplina = '4208-10' OR @codigo_disciplina = '5005-220') AND SUBSTRING(@presenca, 1, 1) = 'P' AND SUBSTRING(@presenca, 2, 1) = 'P')
		 BEGIN
		      SET @num_faltas = 0
		 END
		 ELSE IF((@codigo_disciplina = '4208-10' OR @codigo_disciplina = '5005-220') AND (SUBSTRING(@presenca, 1, 1) = 'F' AND SUBSTRING(@presenca, 2, 1) = 'P' OR 
		                                                                                  SUBSTRING(@presenca, 1, 1) = 'P' AND SUBSTRING(@presenca, 2, 1) = 'F'))
		 BEGIN
		      SET @num_faltas = 1
		 END
		 ELSE IF((@codigo_disciplina = '4208-10' OR @codigo_disciplina = '5005-220') AND SUBSTRING(@presenca, 1, 1) = 'F' AND SUBSTRING(@presenca, 2, 1) = 'F') 
		 BEGIN
		      SET @num_faltas = 2
		 END


		 UPDATE faltas
		 SET num_faltas = @num_faltas
		 WHERE ra_aluno = @ra_aluno
		   AND codigo_disciplina = @codigo_disciplina
		   AND data = @data
		   AND presenca = @presenca
		  		 		 		 		     
END

SELECT * FROM faltas
SELECT * FROM disciplina
SELECT * FROM notas









DROP FUNCTION fn_notas_turma

CREATE FUNCTION fn_notas_turma(@sigla_disciplina VARCHAR(10), @turno CHAR(1))
RETURNS @tabela TABLE (
Ra_Aluno INT,
Nome_Aluno VARCHAR(100),
Nota1 VARCHAR(100),
Nota2 VARCHAR(100),
Nota3 VARCHAR(100),
Trabalho VARCHAR(100),
Monografia_Completa VARCHAR(100),
Monografia_Resumida VARCHAR(100),
Media_Final DECIMAL(7, 1),
Situacao VARCHAR(20)
)
BEGIN
     DECLARE @nome_aluno VARCHAR(100),

	         @p1 DECIMAL(7,1),
	         @p2 DECIMAL(7,1),
			 @p3 DECIMAL(7,1),
			 @trabalho DECIMAL(7, 1),
			 @monografia_completa DECIMAL(7,1),
			 @monografia_resumida DECIMAL(7,1),

	         @peso_p1 DECIMAL(7,3),
	         @peso_p2 DECIMAL(7,3),
			 @peso_p3 DECIMAL(7,3),
			 @peso_trabalho DECIMAL(7, 1),
			 @peso_monografia_completa DECIMAL(7,1),
			 @peso_monografia_resumida DECIMAL(7,1),

			 @media_final DECIMAL(7,1),
			 @situacao VARCHAR(20)
     
     DECLARE @ra_aluno INT,
	         @codigo_disciplina VARCHAR(10),
	         @codigo_avaliacao INT,
			 @nota DECIMAL(7, 3),
			 @peso DECIMAL(7, 3)

	         
	DECLARE	 @p1_texto VARCHAR(100),
	         @p2_texto VARCHAR(100),
			 @p3_texto VARCHAR(100),
			 @trabalho_texto VARCHAR(100),
			 @monografia_completa_texto VARCHAR(100),
			 @monografia_resumida_texto VARCHAR(100)



-- Passagem de parametro da function que exibi as notas turma da disciplina do turno escolhido
	 DECLARE @codigo_disciplina_escolhido VARCHAR(10)

	 SET @codigo_disciplina_escolhido = (SELECT codigo FROM disciplina WHERE sigla = @sigla_disciplina AND turno = @turno)


     DECLARE c CURSOR FOR SELECT n.ra_aluno, a.nome, n.codigo_disciplina, n.codigo_avaliacao, n.nota, n.peso 
	                      FROM notas n, aluno a, disciplina d 
						  WHERE n.ra_aluno = a.ra 
						    AND d.codigo = n.codigo_disciplina 
							AND d.codigo = @codigo_disciplina_escolhido 
	 OPEN c
	 FETCH NEXT FROM c INTO @ra_aluno, @nome_aluno, @codigo_disciplina, @codigo_avaliacao, @nota, @peso
	 WHILE @@FETCH_STATUS = 0
	 BEGIN
--- AOC	      
	      IF((@codigo_disciplina = '4203-010' OR @codigo_disciplina = '4203-020') AND @codigo_avaliacao = 1)
		  BEGIN
		      SET @p1 = @nota 
			  SET @peso_p1 = @peso
			  SET @p1_texto = CAST(@p1 AS VARCHAR(5))
			  
		  END

	      ELSE IF((@codigo_disciplina = '4203-010' OR @codigo_disciplina = '4203-020') AND @codigo_avaliacao = 2)
		  BEGIN
		      SET @p2 = @nota 
			  SET @peso_p2 = @peso
			  SET @p2_texto = CAST(@p2 AS VARCHAR(5))
		  END 
	      ELSE IF((@codigo_disciplina = '4203-010' OR @codigo_disciplina = '4203-020') AND @codigo_avaliacao = 4)
		  BEGIN
		      SET @trabalho = @nota 
			  SET @peso_trabalho = @peso
			  SET @media_final = (@p1 * @peso_p1) + (@p2 * @peso_p2) + (@trabalho * @peso_trabalho)
			  SET @trabalho_texto = CAST(@trabalho AS VARCHAR(10))

		     IF(@media_final >= 6)
			 BEGIN
			      SET @situacao = 'Aprovado'
			 END 
			 ELSE IF(@media_final < 6)
			 BEGIN
			      SET @situacao = 'Reprovado'
			 END

			 SET @p3_texto = '-'
		     SET @monografia_completa_texto = '-'
		     SET @monografia_resumida_texto = '-'

			 INSERT INTO @tabela(Ra_Aluno, Nome_Aluno, Nota1, Nota2, Nota3, Trabalho, Monografia_Completa, Monografia_Resumida, Media_Final, Situacao)
			 VALUES (@ra_aluno, @nome_aluno, @p1_texto, @p2_texto, @p3_texto, @trabalho_texto, @monografia_completa_texto, @monografia_resumida_texto, @media_final, @situacao)

		  END
--- LabHW
	      ELSE IF((@codigo_disciplina = '4208-10') AND @codigo_avaliacao = 1)
		  BEGIN
		      SET @p1 = @nota 
			  SET @peso_p1 = @peso
			  SET @p1_texto = CAST(@p1 AS VARCHAR(5))
		  END
	      ELSE IF((@codigo_disciplina = '4208-10') AND @codigo_avaliacao = 2)
		  BEGIN
		      SET @p2 = @nota 
			  SET @peso_p2 = @peso
			  SET @p2_texto = CAST(@p2 AS VARCHAR(5))
		  END 
	      ELSE IF((@codigo_disciplina = '4208-10') AND @codigo_avaliacao = 4)
		  BEGIN
		      SET @trabalho = @nota 
			  SET @peso_trabalho = @peso
			  SET @media_final = (@p1 * @peso_p1) + (@p2 * @peso_p2) + (@trabalho * @peso_trabalho)
		      SET @trabalho_texto = CAST(@trabalho AS VARCHAR(10))

			 IF(@media_final >= 6)
			 BEGIN
			      SET @situacao = 'Aprovado'
			 END 
			 ELSE IF(@media_final < 6)
			 BEGIN
			      SET @situacao = 'Reprovado'
			 END

			 SET @p3_texto = '-'
			 SET @monografia_completa_texto = '-'
		     SET @monografia_resumida_texto = '-'

			 INSERT INTO @tabela(Ra_Aluno, Nome_Aluno, Nota1, Nota2, Nota3, Trabalho, Monografia_Completa, Monografia_Resumida, Media_Final, Situacao)
			 VALUES (@ra_aluno, @nome_aluno, @p1_texto, @p2_texto, @p3_texto, @trabalho_texto, @monografia_completa_texto, @monografia_resumida_texto, @media_final, @situacao)

		  END
--- SO I
	      ELSE IF((@codigo_disciplina = '4213-003' OR @codigo_disciplina = '4213-013') AND @codigo_avaliacao = 1)
		  BEGIN
		      SET @p1 = @nota 
			  SET @peso_p1 = @peso
			  SET @p1_texto = CAST(@p1 AS VARCHAR(100))
		  END
	      ELSE IF((@codigo_disciplina = '4213-003' OR @codigo_disciplina = '4213-013') AND @codigo_avaliacao = 2)
		  BEGIN
		      SET @p2 = @nota 
			  SET @peso_p2 = @peso
			  SET @p2_texto = CAST(@p2 AS VARCHAR(100))
		  END 
	      ELSE IF((@codigo_disciplina = '4213-003' OR @codigo_disciplina = '4213-013') AND @codigo_avaliacao = 4)
		  BEGIN
		      SET @trabalho = @nota 
			  SET @peso_trabalho = @peso
			  SET @media_final = (@p1 * @peso_p1) + (@p2 * @peso_p2) + (@trabalho * @peso_trabalho)
			  SET @trabalho_texto = CAST(@trabalho AS VARCHAR(100))

		     IF(@media_final >= 6)
			 BEGIN
			      SET @situacao = 'Aprovado'
			 END 
			 ELSE IF(@media_final < 6)
			 BEGIN
			      SET @situacao = 'Reprovado'
			 END
			 SET @p3_texto = '-'
			 SET @monografia_completa_texto = '-'
		     SET @monografia_resumida_texto = '-'

			 INSERT INTO @tabela(Ra_Aluno, Nome_Aluno, Nota1, Nota2, Nota3, Trabalho, Monografia_Completa, Monografia_Resumida, Media_Final, Situacao)
			 VALUES (@ra_aluno, @nome_aluno, @p1_texto, @p2_texto, @p3_texto, @trabalho_texto, @monografia_completa_texto, @monografia_resumida_texto, @media_final, @situacao)
		  END
--- BD
	      ELSE IF((@codigo_disciplina = '4226-004') AND @codigo_avaliacao = 1)
		  BEGIN
		      SET @p1 = @nota 
			  SET @peso_p1 = @peso
			  SET @p1_texto = CAST(@p1 AS VARCHAR(100))
		  END
	      ELSE IF((@codigo_disciplina = '4226-004') AND @codigo_avaliacao = 2)
		  BEGIN
		      SET @p2 = @nota 
			  SET @peso_p2 = @peso
			  SET @p2_texto = CAST(@p2 AS VARCHAR(100))
		  END 
	      ELSE IF((@codigo_disciplina = '4226-004') AND @codigo_avaliacao = 4)
		  BEGIN
		      SET @trabalho = @nota 
			  SET @peso_trabalho = @peso
			  SET @media_final = (@p1 * @peso_p1) + (@p2 * @peso_p2) + (@trabalho * @peso_trabalho)
			  SET @trabalho_texto = CAST(@trabalho AS VARCHAR(100))

		     IF(@media_final >= 6)
			 BEGIN
			      SET @situacao = 'Aprovado'
			 END 
			 ELSE IF(@media_final < 6)
			 BEGIN
			      SET @situacao = 'Reprovado'
			 END

             SET @p3_texto = '-'
			 SET @monografia_completa_texto = '-'
			 SET @monografia_resumida_texto = '-'

			 INSERT INTO @tabela(Ra_Aluno, Nome_Aluno, Nota1, Nota2, Nota3, Trabalho, Monografia_Completa, Monografia_Resumida, Media_Final, Situacao)
			 VALUES (@ra_aluno, @nome_aluno, @p1_texto, @p2_texto, @p3_texto, @trabalho_texto, @monografia_completa_texto, @monografia_resumida_texto, @media_final, @situacao)
		  END
--- LabBD
	      ELSE IF((@codigo_disciplina = '4233-005') AND @codigo_avaliacao = 1)
		  BEGIN
		      SET @p1 = @nota 
			  SET @peso_p1 = @peso
			  SET @p1_texto = CAST(@p1 AS VARCHAR(100))
		  END

	      ELSE IF((@codigo_disciplina = '4233-005') AND @codigo_avaliacao = 2)
		  BEGIN
		      SET @p2 = @nota 
			  SET @peso_p2 = @peso
			  SET @p2_texto = CAST(@p2 AS VARCHAR(100))
		  END 
	      ELSE IF((@codigo_disciplina = '4233-005') AND @codigo_avaliacao = 3)
		  BEGIN
		      SET @p3 = @nota 
			  SET @peso_p3 = @peso
			  SET @media_final = (@p1 * @peso_p1) + (@p2 * @peso_p2) + (@p3 * @peso_p3)
			  SET @p3_texto = CAST(@p3 AS VARCHAR(100))

		     IF(@media_final >= 6)
			 BEGIN
			      SET @situacao = 'Aprovado'
			 END 
			 ELSE IF(@media_final < 6)
			 BEGIN
			      SET @situacao = 'Reprovado'
			 END

			 SET @trabalho_texto = '-'
			 SET @monografia_completa_texto = '-'
		     SET @monografia_resumida_texto = '-'

			 INSERT INTO @tabela(Ra_Aluno, Nome_Aluno, Nota1, Nota2, Nota3, Trabalho, Monografia_Completa, Monografia_Resumida, Media_Final, Situacao)
			 VALUES (@ra_aluno, @nome_aluno, @p1_texto, @p2_texto, @p3_texto, @trabalho_texto, @monografia_completa_texto, @monografia_resumida_texto, @media_final, @situacao)

		  END
-- MPC 
	      ELSE IF((@codigo_disciplina = '5005-220') AND @codigo_avaliacao = 5)
		  BEGIN
		      SET @monografia_completa = @nota 
			  SET @peso_monografia_completa = @peso
			  SET @monografia_completa_texto = CAST(@monografia_completa AS VARCHAR(100))
		  END

	      ELSE IF((@codigo_disciplina = '5005-220') AND @codigo_avaliacao = 6)
		  BEGIN
		      SET @monografia_resumida = @nota 
			  SET @peso_monografia_resumida = @peso
			  SET @media_final = (@monografia_completa * @peso_monografia_completa) + (@monografia_resumida * @peso_monografia_resumida)
		      SET @monografia_resumida_texto = CAST(@monografia_resumida AS VARCHAR(100))
			 IF(@media_final >= 6)
			 BEGIN
			      SET @situacao = 'Aprovado'
			 END 
			 ELSE IF(@media_final < 6)
			 BEGIN
			      SET @situacao = 'Reprovado'
			 END

			 SET @p1_texto = '-'
             SET @p2_texto = '-'
			 SET @p3_texto = '-'
			 SET @trabalho_texto = '-'

			 INSERT INTO @tabela(Ra_Aluno, Nome_Aluno, Nota1, Nota2, Nota3, Trabalho, Monografia_Completa, Monografia_Resumida, Media_Final, Situacao)
			 VALUES (@ra_aluno, @nome_aluno, @p1_texto, @p2_texto, @p3_texto, @trabalho_texto, @monografia_completa_texto, @monografia_resumida_texto, @media_final, @situacao)
		  END		  

			 FETCH NEXT FROM c INTO @ra_aluno, @nome_aluno, @codigo_disciplina, @codigo_avaliacao, @nota, @peso
     END
	 CLOSE c
	 DEALLOCATE c
     RETURN
END





SELECT * FROM dbo.fn_notas_turma('MPC', 'T')
SELECT * FROM dbo.fn_notas_turma('LabBD', 'T')
SELECT * FROM dbo.fn_notas_turma('BD', 'T')
SELECT * FROM dbo.fn_notas_turma('SO I', 'T')
SELECT * FROM dbo.fn_notas_turma('LabHW', 'T')
SELECT * FROM dbo.fn_notas_turma('AOC', 'T')

SELECT * FROM notas


EXEC p_insercao_notas 'Knull', 'MPC', 'T', 'Monografia Completa', 8
EXEC p_insercao_notas 'Knull', 'MPC', 'T', 'Monografia Resumida', 8

EXEC p_insercao_notas 'Knull', 'LabBD', 'T', 'P1', 9
EXEC p_insercao_notas 'Knull', 'LabBD', 'T', 'P2', 9
EXEC p_insercao_notas 'Knull', 'LabBD', 'T', 'P3', 9

EXEC p_insercao_notas 'Knull', 'BD', 'T', 'P1', 8
EXEC p_insercao_notas 'Knull', 'BD', 'T', 'P2', 8
EXEC p_insercao_notas 'Knull', 'BD', 'T', 'Trabalho', 8

EXEC p_insercao_notas 'Knull', 'SO I', 'T', 'P1', 7
EXEC p_insercao_notas 'Knull', 'SO I', 'T', 'P2', 7
EXEC p_insercao_notas 'Knull', 'SO I', 'T', 'Trabalho', 9.5

EXEC p_insercao_notas 'Knull', 'LabHw', 'T', 'P1', 3
EXEC p_insercao_notas 'Knull', 'LabHw', 'T', 'P2', 4
EXEC p_insercao_notas 'Knull', 'LabHw', 'T', 'Trabalho', 3

EXEC p_insercao_notas 'Knull', 'AOC', 'T', 'P1', 9.5
EXEC p_insercao_notas 'Knull', 'AOC', 'T', 'P2', 8
EXEC p_insercao_notas 'Knull', 'AOC', 'T', 'Trabalho', 10

EXEC p_insercao_notas 'Lucas Bezerra Coelho', 'AOC', 'T', 'P1', 9
EXEC p_insercao_notas 'Lucas Bezerra Coelho', 'AOC', 'T', 'P2', 8.5
EXEC p_insercao_notas 'Lucas Bezerra Coelho', 'AOC', 'T', 'Trabalho', 8.5

EXEC p_insercao_notas 'Gabriel Elias da Silva', 'AOC', 'T', 'P1', 10
EXEC p_insercao_notas 'Gabriel Elias da Silva', 'AOC', 'T', 'P2', 10
EXEC p_insercao_notas 'Gabriel Elias da Silva', 'AOC', 'T', 'Trabalho', 10

EXEC p_insercao_notas 'Knull', 'LabBD', 'T', 'P1', 9
EXEC p_insercao_notas 'Knull', 'LabBD', 'T', 'P2', 9
EXEC p_insercao_notas 'Knull', 'LabBD', 'T', 'P3', 9

EXEC p_insercao_notas 'Gabriel Elias da Silva', 'LabBD', 'T', 'P1', 8
EXEC p_insercao_notas 'Gabriel Elias da Silva', 'LabBD', 'T', 'P2', 8
EXEC p_insercao_notas 'Gabriel Elias da Silva', 'LabBD', 'T', 'P3', 8

EXEC p_insercao_notas 'Lucas Bezerra Coelho', 'LabBD', 'T', 'P1', 7
EXEC p_insercao_notas 'Lucas Bezerra Coelho', 'LabBD', 'T', 'P2', 7
EXEC p_insercao_notas 'Lucas Bezerra Coelho', 'LabBD', 'T', 'P3', 7

EXEC p_insercao_notas 'Knull', 'BD', 'T', 'P1', 8
EXEC p_insercao_notas 'Knull', 'BD', 'T', 'P2', 8
EXEC p_insercao_notas 'Knull', 'BD', 'T', 'Trabalho', 8

EXEC p_insercao_notas 'Knull', 'LabHw', 'T', 'P1', 3
EXEC p_insercao_notas 'Knull', 'LabHw', 'T', 'P2', 4
EXEC p_insercao_notas 'Knull', 'LabHw', 'T', 'Trabalho', 3

EXEC p_insercao_notas 'Knull', 'MPC', 'T', 'Monografia Completa', 8
EXEC p_insercao_notas 'Knull', 'MPC', 'T', 'Monografia Resumida', 8


DELETE notas



-- Function que exibe as presenças e faltas 
DROP FUNCTION fn_presenca_turma

CREATE FUNCTION fn_presenca_turma(@sigla VARCHAR(10), @turno CHAR(1))
RETURNS @tabela TABLE (
ra_aluno INT,
nome_aluno VARCHAR(100),
data_1 CHAR(4),
data_2 CHAR(4),
data_3 CHAR(4),
data_4 CHAR(4),
data_5 CHAR(4),
data_6 CHAR(4),
data_7 CHAR(4),
data_8 CHAR(4),
data_9 CHAR(4),
data_10 CHAR(4),
data_11 CHAR(4),
data_12 CHAR(4),
data_13 CHAR(4),
data_14 CHAR(4),
data_15 CHAR(4),
data_16 CHAR(4),
data_17 CHAR(4),
data_18 CHAR(4),
data_19 CHAR(4),
data_20 CHAR(4),
total_faltas INT,
estado VARCHAR(20)
)
AS
BEGIN
     DECLARE 
	         @presencas_data_1 CHAR(4),
	         @presencas_data_2 CHAR(4),
			 @presencas_data_3 CHAR(4),
			 @presencas_data_4 CHAR(4),
			 @presencas_data_5 CHAR(4),
			 @presencas_data_6 CHAR(4),
			 @presencas_data_7 CHAR(4),
			 @presencas_data_8 CHAR(4),
			 @presencas_data_9 CHAR(4),
			 @presencas_data_10 CHAR(4),
			 @presencas_data_11 CHAR(4),
			 @presencas_data_12 CHAR(4),
			 @presencas_data_13 CHAR(4),
			 @presencas_data_14 CHAR(4),
			 @presencas_data_15 CHAR(4),
			 @presencas_data_16 CHAR(4),
			 @presencas_data_17 CHAR(4),
			 @presencas_data_18 CHAR(4),
			 @presencas_data_19 CHAR(4),
			 @presencas_data_20 CHAR(4),
			 @total_faltas INT,
             @estado VARCHAR(20)

     DECLARE @data_1 DATE,
	         @data_2 DATE,
			 @data_3 DATE,
			 @data_4 DATE,
			 @data_5 DATE,
			 @data_6 DATE,
			 @data_7 DATE,
			 @data_8 DATE,
			 @data_9 DATE,
			 @data_10 DATE,
			 @data_11 DATE,
			 @data_12 DATE,
			 @data_13 DATE,
			 @data_14 DATE,
			 @data_15 DATE,
			 @data_16 DATE,
			 @data_17 DATE,
			 @data_18 DATE,
			 @data_19 DATE,
			 @data_20 DATE

	DECLARE @num_faltas_1 INT,
	        @num_faltas_2 INT,
			@num_faltas_3 INT,
			@num_faltas_4 INT,
			@num_faltas_5 INT,
			@num_faltas_6 INT,
			@num_faltas_7 INT,
			@num_faltas_8 INT,
			@num_faltas_9 INT,
			@num_faltas_10 INT,
			@num_faltas_11 INT,
			@num_faltas_12 INT,
			@num_faltas_13 INT,
			@num_faltas_14 INT,
			@num_faltas_15 INT,
			@num_faltas_16 INT,
			@num_faltas_17 INT,
			@num_faltas_18 INT,
			@num_faltas_19 INT,
			@num_faltas_20 INT


		SET @data_1 = (SELECT MIN(data) FROM faltas f, disciplina d WHERE f.codigo_disciplina = d.codigo AND d.sigla = @sigla AND d.turno = @turno)

	 DECLARE @ra_aluno INT,
	         @nome_aluno VARCHAR(30),
	         @codigo_disciplina VARCHAR(10),
			 @data DATE,
			 @presenca CHAR(4),
			 @num_faltas INT

	DECLARE @codigo_disciplina_escolhido VARCHAR(10)

	     SET @codigo_disciplina_escolhido = (SELECT codigo FROM disciplina WHERE sigla = @sigla AND turno = @turno)

    DECLARE @disciplina_num_aulas INT
	   
	    SET @disciplina_num_aulas = (SELECT num_aulas FROM disciplina WHERE sigla = @sigla AND turno = @turno)

	DECLARE C CURSOR FOR SELECT f.ra_aluno, a.nome, f.codigo_disciplina, f.data, f.presenca, f.num_faltas 
                         FROM faltas f, aluno a, disciplina d
                         WHERE f.ra_aluno = a.ra
                         AND d.codigo = f.codigo_disciplina
						 AND f.codigo_disciplina = @codigo_disciplina_escolhido

    OPEN C
	FETCH NEXT FROM C INTO @ra_aluno, @nome_aluno, @codigo_disciplina, @data, @presenca, @num_faltas
	WHILE @@FETCH_STATUS = 0
	BEGIN
	     IF(@data_1 = @data)
		 BEGIN
		      SET @presencas_data_1 = @presenca
		      SET @num_faltas_1 = @num_faltas

			  SET @data_2 = DATEADD(DAY, 7, @data_1)
		      
		 END

	     ELSE IF(@data_2 = @data)
		 BEGIN
		      SET @presencas_data_2 = @presenca
		      SET @num_faltas_2 = @num_faltas

			  SET @data_3 = DATEADD(DAY, 7, @data_2)

               
		
		 END

		 ELSE IF(@data_3 = @data)
		 BEGIN
		      SET @presencas_data_3 = @presenca
		      SET @num_faltas_3 = @num_faltas

			  SET @data_4 = DATEADD(DAY, 7, @data_3)
		
		 END

		 ELSE IF(@data_4 = @data)
		 BEGIN
		      SET @presencas_data_4 = @presenca
		      SET @num_faltas_4 = @num_faltas

			  SET @data_5 = DATEADD(DAY, 7, @data_4)
		
		 END

		 ELSE IF(@data_5 = @data)
		 BEGIN
		      SET @presencas_data_5 = @presenca
		      SET @num_faltas_5 = @num_faltas

			  SET @data_6 = DATEADD(DAY, 7, @data_5)
		
		 END	
		  
		 ELSE IF(@data_6 = @data)
		 BEGIN
		      SET @presencas_data_6 = @presenca
		      SET @num_faltas_6 = @num_faltas

			  SET @data_7 = DATEADD(DAY, 7, @data_6)
		
		 END

		 ELSE IF(@data_7 = @data)
		 BEGIN
		      SET @presencas_data_7 = @presenca
		      SET @num_faltas_7 = @num_faltas

			  SET @data_8 = DATEADD(DAY, 7, @data_7)
		
		 END

		 ELSE IF(@data_8 = @data)
		 BEGIN
		      SET @presencas_data_8 = @presenca
		      SET @num_faltas_8 = @num_faltas

			  SET @data_9 = DATEADD(DAY, 7, @data_8)
		
		 END

		 ELSE IF(@data_9 = @data)
		 BEGIN
		      SET @presencas_data_9 = @presenca
		      SET @num_faltas_9 = @num_faltas

			  SET @data_10 = DATEADD(DAY, 7, @data_9)
		
		 END	

		 ELSE IF(@data_10 = @data)
		 BEGIN
		      SET @presencas_data_10 = @presenca
			  SET @num_faltas_10 = @num_faltas

			  SET @data_11 = DATEADD(DAY, 7, @data_10)
		
		 END

		 ELSE IF(@data_11 = @data)
		 BEGIN
		      SET @presencas_data_11 = @presenca
		      SET @num_faltas_11 = @num_faltas

			  SET @data_12 = DATEADD(DAY, 7, @data_11)
		
		 END

		 ELSE IF(@data_12 = @data)
		 BEGIN
		      SET @presencas_data_12 = @presenca
		      SET @num_faltas_12 = @num_faltas

			  SET @data_13 = DATEADD(DAY, 7, @data_12)
		
		 END
		     
		 ELSE IF(@data_13 = @data)
		 BEGIN
		      SET @presencas_data_13 = @presenca
		      SET @num_faltas_13 = @num_faltas

			  SET @data_14 = DATEADD(DAY, 7, @data_13)
		
		 END  

		 ELSE IF(@data_14 = @data)
		 BEGIN
		      SET @presencas_data_14 = @presenca
		      SET @num_faltas_14 = @num_faltas

			  SET @data_15 = DATEADD(DAY, 7, @data_14)
		
		 END

		 ELSE IF(@data_15 = @data)
		 BEGIN
		      SET @presencas_data_15 = @presenca
		      SET @num_faltas_15 = @num_faltas

			  SET @data_16 = DATEADD(DAY, 7, @data_15)
		
		 END

		 ELSE IF(@data_16 = @data)
		 BEGIN
		      SET @presencas_data_16 = @presenca
		      SET @num_faltas_16 = @num_faltas

			  SET @data_17 = DATEADD(DAY, 7, @data_16)
		
		 END

		 ELSE IF(@data_17 = @data)
		 BEGIN
		      SET @presencas_data_17 = @presenca
		      SET @num_faltas_17 = @num_faltas

			  SET @data_18 = DATEADD(DAY, 7, @data_17)
		
		 END

		 ELSE IF(@data_18 = @data)
		 BEGIN
		      SET @presencas_data_18 = @presenca
		      SET @num_faltas_18 = @num_faltas

			  SET @data_19 = DATEADD(DAY, 7, @data_18)
		
		 END

		 ELSE IF(@data_19 = @data)
		 BEGIN
		      SET @presencas_data_19 = @presenca
		      SET @num_faltas_19 = @num_faltas
			  SET @data_20 = DATEADD(DAY, 7, @data_19)
		
		 END

		 ELSE IF(@data_20 = @data)
		 BEGIN
		      SET @presencas_data_20 = @presenca
              SET @num_faltas_20 = @num_faltas
		      SET @total_faltas = @num_faltas_1 + @num_faltas_2 + @num_faltas_3 + @num_faltas_4 + @num_faltas_5 + @num_faltas_6 + @num_faltas_7 + @num_faltas_8 + @num_faltas_9 + @num_faltas_10 + @num_faltas_11 + @num_faltas_12 + @num_faltas_13 + @num_faltas_14 + @num_faltas_15 + @num_faltas_16 + @num_faltas_17 + @num_faltas_18 + @num_faltas_19 + @num_faltas_20

			  IF((@disciplina_num_aulas * 0.25) <= @total_faltas)
			  BEGIN
			       SET @estado = 'Reprovado por Faltas'
			  END
			  ELSE IF ((@disciplina_num_aulas * 0.25) > @total_faltas)
			  BEGIN
			       SET @estado = 'Aprovado'
			  END

		      INSERT INTO @tabela(ra_aluno, nome_aluno, data_1, data_2, data_3, data_4, data_5, data_6, data_7, data_8, data_9, data_10, data_11, data_12, data_13, data_14,  data_15,  data_16,  data_17,  data_18,  data_19,  data_20, total_faltas, estado)
		      VALUES             (@ra_aluno, @nome_aluno, @presencas_data_1, @presencas_data_2, @presencas_data_3, @presencas_data_4, @presencas_data_5, @presencas_data_6, @presencas_data_7, @presencas_data_8, @presencas_data_9,  @presencas_data_10, @presencas_data_11,  @presencas_data_12, @presencas_data_13,  @presencas_data_14, @presencas_data_15, @presencas_data_16,  @presencas_data_17, @presencas_data_18, @presencas_data_19, @presencas_data_20, @total_faltas, @estado)


		
		 END
	     FETCH NEXT FROM C INTO @ra_aluno, @nome_aluno, @codigo_disciplina, @data, @presenca, @num_faltas
	END
	CLOSE C
	DEALLOCATE C
    RETURN
END

SELECT * FROM dbo.fn_presenca_turma('AOC', 'T')
SELECT * FROM dbo.fn_presenca_turma('LabHw', 'T')
SELECT * FROM dbo.fn_presenca_turma('BD', 'T')

SELECT * FROM faltas
SELECT * FROM aluno
SELECT * FROM disciplina


DELETE faltas

--Teste AOC
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '03/02/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '10/02/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '17/02/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '24/02/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '03/03/2023', 'PPPP'

EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '10/03/2023', 'FFFF'
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '17/03/2023', 'FFFF'
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '24/03/2023', 'FFFF'
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '31/03/2023', 'FFFF'
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '07/04/2023', 'FFFF'

EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '14/04/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '21/04/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '28/04/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '05/05/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '12/05/2023', 'PPPP'

EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '19/05/2023', 'FFFF'
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '26/05/2023', 'FFFF'
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '02/06/2023', 'FFFF'
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '09/06/2023', 'FFFF'
EXEC p_insere_faltas_presencas 'Gabriel Elias da Silva', 'AOC', 'T', '16/06/2023', 'FFFF'

EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '03/02/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '10/02/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '17/02/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '24/02/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '03/03/2023', 'PPPP'

EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '10/03/2023', 'FFFF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '17/03/2023', 'FFFF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '24/03/2023', 'FFFF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '31/03/2023', 'FFFF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '07/04/2023', 'FFFF'

EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '14/04/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '21/04/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '28/04/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '05/05/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '12/05/2023', 'PPPP'

EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '19/05/2023', 'FFFF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '26/05/2023', 'FFFF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '02/06/2023', 'FFFF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '09/06/2023', 'FFFF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'AOC', 'T', '16/06/2023', 'FFFF'

-- Teste BD
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '03/02/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '10/02/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '17/02/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '24/02/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '03/03/2023', 'PPPP'

EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '10/03/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '17/03/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '24/03/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '31/03/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '07/04/2023', 'PPPP'

EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '14/04/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '21/04/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '28/04/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '05/05/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '12/05/2023', 'PPPP'

EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '19/05/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '26/05/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '02/06/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '09/06/2023', 'PPPP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'BD', 'T', '16/06/2023', 'FFFF'

--Teste LabHW
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '03/02/2023', 'FP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '10/02/2023', 'PP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '17/02/2023', 'PP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '24/02/2023', 'PP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '03/03/2023', 'FF'

EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '10/03/2023', 'FF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '17/03/2023', 'FF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '24/03/2023', 'FF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '31/03/2023', 'FF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '07/04/2023', 'FF'

EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '14/04/2023', 'FF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '21/04/2023', 'FF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '28/04/2023', 'FF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '05/05/2023', 'FF'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '12/05/2023', 'FF'

EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '19/05/2023', 'PP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '26/05/2023', 'PP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '02/06/2023', 'PP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '09/06/2023', 'PP'
EXEC p_insere_faltas_presencas 'Lucas Bezerra Coelho', 'LabHw', 'T', '16/06/2023', 'PP'




SELECT * FROM faltas


SELECT * FROM notas
SELECT * FROM avaliacao


DELETE faltas






















