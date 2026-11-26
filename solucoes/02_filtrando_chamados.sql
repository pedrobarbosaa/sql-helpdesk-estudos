/* =====================================================================
   Exercício 02 — Filtrando chamados
   Enunciado: exercicios/README.md (Exercício 02)
   Status   : [ ] em andamento   [ ] revisado   [x] concluído
   ===================================================================== */

USE HelpDeskTI;
GO

/* Contexto
  A coordenação quer uma visão rápida da fila de atendimento 
  e de alguns pontos do inventário.
*/

-- ---------------------------------------------------------------------
-- Item a) Chamados de prioridade **Alta ou Crítica**.
SELECT ChamadoID, Titulo, Descricao, Prioridade 
	FROM dbo.Chamados 
WHERE Prioridade = 'Alta' OR Prioridade = 'Crítica';
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
-- Item b) Chamados que **ainda não foram encerrados** (status diferente de *Resolvido* e de *Fechado*).
SELECT ChamadoID, Titulo, Descricao, Status
	FROM dbo.Chamados 
WHERE Status <> 'Resolvido'and Status <> 'Fechado';
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
-- Item c) Chamados que **ainda não têm técnico** atribuído.
SELECT ChamadoID, Titulo, Descricao, TecnicoID	
	FROM dbo.Chamados 
WHERE TecnicoID IS NULL;
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
-- Item d) Chamados de prioridade Alta ou Crítica que **ainda não foram encerrados** (combinação de a e b).
SELECT ChamadoID, Titulo, Descricao, Prioridade, Status 
	FROM dbo.Chamados 
WHERE( Prioridade = 'Alta' OR Prioridade = 'Crítica') AND Status <> 'Resolvido' AND Status <> 'Fechado';
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
-- Item e) Equipamentos adquiridos em **2025** com valor **acima de R$ 3.000,00**.
SELECT EquipamentoId, DataAquisicao, ValorAquisicao 
	FROM dbo.Equipamentos
WHERE DataAquisicao >= '2025-01-01' AND DataAquisicao <= '2025-12-31' AND ValorAquisicao > '3000';
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
-- Item f) Colaboradores cujo nome **começa com a letra R**.
SELECT Nome 
	FROM dbo.Colaboradores 
WHERE Nome LIKE 'R%';
-- ---------------------------------------------------------------------



-- ---------------------------------------------------------------------
-- Item g) Colaboradores **desligados** (inativos).
SELECT ColaboradorId, Nome, Ativo 
	FROM dbo.Colaboradores
WHERE Ativo <> 1;
-- ---------------------------------------------------------------------



/* INTERPRETAÇÃO DOS RESULTADOS
   - Busquei deixar as consultas mais limpas, evitando o uso do * conforme usei nos exercícios passados 
   e também aplicar boas práticas com o uso do prefixo dbo para quando referenciarmos alguma tabela

   O QUE APRENDI / DÚVIDAS
   - Na letra D Lembrei do uso da precedência de parênteses, fiquei um tempo 
	tentando combinar os valores lógicos até perceber
   - Na letra E a primeira tentativa coloquei apenas o valor sem intervalo 
	depois refiz a leitura e entendi que eram apenas do ano de 2025
	- Usei muito no meu primeiro emprego a letra F, realizava busca de nome de alunos no banco
	e facilitava muito usar o like com %%.
*/
