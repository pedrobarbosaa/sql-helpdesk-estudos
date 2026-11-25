/* =====================================================================
   Exercício 01 — Explorando os dados
   Enunciado: exercicios/README.md (Exercício 01)
   Status   : [] em andamento   [x] revisado   [x] concluído
   ===================================================================== */

USE HelpDeskTI;
GO

-- ---------------------------------------------------------------------
-- Item a) Liste todas as colunas da tabela de colaboradores.
SELECT * FROM dbo.Colaboradores;
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
-- Item b) liste somente o nome, o e-mail e o cargo de cada colaborador, com cabeçalhos amigáveis: Colaborador, E-mail e Cargo.
SELECT Nome as 'Colaborador', 
	   Email as 'E-mail', 
	   Cargo as 'Cargo' 
FROM dbo.Colaboradores;
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
-- Item c) Liste os técnicos de suporte mostrando nome, nível e custo por hora.
SELECT Nome as 'nome',
	   Nivel as 'nível', 
	   CustoHora as 'custo por hora'
FROM dbo.Tecnicos;
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
/*Item d) Liste as categorias de chamado com o nome, o SLA em horas e uma 
**coluna calculada** `SLA_Dias` com o SLA convertido para dias 
(com casas decimais, ex.: 8 horas = 0,33 dia).*/
SELECT Nome, SLAHoras, 
	CAST(SLAHoras / 24.0 AS DECIMAL(5, 2)) AS SLA_Dias 
FROM dbo.Categorias;
-- ---------------------------------------------------------------------


/* INTERPRETAÇÃO DOS RESULTADOS
   - Select é um comando essencial para consultas, permite retornar dados de diversas formas, porém o uso do * não é indicado para
	 extensas consultas pois pode demandar tempo dependendo do tamanho da fonte de dados e também expor dados sensíveis.

   O QUE APRENDI / DÚVIDAS
   - O exercício D me tomou mais tempo, pois não recordava a sintaxe correta do uso do decimal
   - usei de pesquisas em forúns e tutoriais para conseguir resolver essa dúvida, encontrei o CAST na documentação da Microsoft SQLServer
*/
