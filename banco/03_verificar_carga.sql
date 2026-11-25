/* =====================================================================
   Projeto : SQL Help Desk - Estudos de SQL Server
   Script  : 03_verificar_carga.sql
   Objetivo: Conferir se a base foi criada e populada corretamente.

   Resultado esperado (base recém-criada):
     Departamentos .....   9     Equipamentos ......  54
     Colaboradores .....  32     Chamados ..........  96
     Tecnicos ..........   7     Interacoes ........ 224
     Categorias ........   8
   ===================================================================== */

USE HelpDeskTI;
GO

SELECT 'Departamentos' AS Tabela, COUNT(*) AS Registros FROM dbo.Departamentos
UNION ALL SELECT 'Colaboradores', COUNT(*) FROM dbo.Colaboradores
UNION ALL SELECT 'Tecnicos',      COUNT(*) FROM dbo.Tecnicos
UNION ALL SELECT 'Categorias',    COUNT(*) FROM dbo.Categorias
UNION ALL SELECT 'Equipamentos',  COUNT(*) FROM dbo.Equipamentos
UNION ALL SELECT 'Chamados',      COUNT(*) FROM dbo.Chamados
UNION ALL SELECT 'Interacoes',    COUNT(*) FROM dbo.Interacoes;
GO

-- Restrições criadas no banco (PK, FK, UNIQUE, CHECK e DEFAULT)
SELECT  OBJECT_NAME(parent_object_id) AS Tabela,
        name                          AS Restricao,
        type_desc                     AS Tipo
FROM    sys.objects
WHERE   type IN ('PK', 'F', 'UQ', 'C', 'D')
ORDER BY Tabela, Tipo, Restricao;
GO

-- Teste rápido de acentuação: deve aparecer "Média", "Crítica", "Segurança da Informação"
SELECT DISTINCT Prioridade FROM dbo.Chamados;
SELECT Nome FROM dbo.Categorias WHERE CategoriaID = 8;
GO
