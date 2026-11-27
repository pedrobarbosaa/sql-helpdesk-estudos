/* =====================================================================
   Exercício 03 — Ordenando e removendo duplicatas
   Enunciado: exercicios/README.md (Exercício 03)
   Status   : [ ] em andamento   [ ] revisado   [X] concluído
   ===================================================================== */

USE HelpDeskTI;
GO

/* 
O setor de compras está planejando a renovação do 
parque de equipamentos e precisa de algumas listas organizadas.
*/

-- ---------------------------------------------------------------------
-- Item a) Lista das **marcas** de equipamentos, **sem repetição**, em ordem alfabética.
SELECT DISTINCT Marca 
	FROM dbo.Equipamentos ORDER BY Marca ASC;
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
-- Item b) Os **5 equipamentos mais caros** (patrimônio, tipo, modelo e valor), do mais caro para o mais barato.
SELECT TOP 5 Patrimonio AS Patrimônio, 
			Tipo, 
			Modelo, 
			ValorAquisicao AS Valor 
FROM dbo.Equipamentos ORDER BY ValorAquisicao DESC;
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
-- Item c) Todas as **combinações distintas de tipo e marca** existentes no inventário, ordenadas por tipo e depois por marca.
SELECT DISTINCT tipo, 
				marca 
	FROM dbo.Equipamentos ORDER BY Tipo, Marca;
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
/* Item d) Colaboradores ativos ordenados pelo **departamento** (código) e, dentro de cada departamento, 
		   pela **data de admissão mais recente primeiro**. */
SELECT ColaboradorId, 
	   Nome, 
	   DepartamentoID, 
	   DataAdmissao, 
	   Ativo 
	FROM DBO.Colaboradores WHERE Ativo = 1 ORDER BY DepartamentoID, DataAdmissao DESC;
-- ---------------------------------------------------------------------



/* INTERPRETAÇÃO DOS RESULTADOS
   - Posso ter mais de uma marca de tipo de equipamentos e mais de um equipamento de outras marcas
   - Eu acha que deveria usar o parentênses para ordem de execução do ORDER BY mas lendo a documentação vi que apenas a vírgula resolvia
   O QUE APRENDI / DÚVIDAS
   - Relembrei o uso do TOP, usei da documentação do https://www.w3schools.com/sql/sql_top.asp para conferir se a sintaxe estava correta
*/
