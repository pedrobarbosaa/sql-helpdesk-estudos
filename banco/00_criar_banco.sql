/* =====================================================================
   Projeto : SQL Help Desk - Estudos de SQL Server
   Script  : 00_criar_banco.sql
   Objetivo: (Re)criar o banco de dados HelpDeskTI do zero.

   ATENÇÃO: se o banco já existir, ele será APAGADO e recriado.
            Use este script sempre que quiser "resetar" o ambiente
            (por exemplo, depois do Exercício 04, que altera dados).

   Ordem de execução: 00 -> 01 -> 02 -> 03
   ===================================================================== */

USE master;
GO

IF DB_ID(N'HelpDeskTI') IS NOT NULL
BEGIN
    -- Derruba conexões abertas (ex.: outra aba do SSMS) antes de excluir
    ALTER DATABASE HelpDeskTI SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HelpDeskTI;
END
GO

CREATE DATABASE HelpDeskTI;
GO

PRINT N'Banco HelpDeskTI criado com sucesso. Próximo passo: 01_criar_tabelas.sql';
GO
