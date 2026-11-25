/* =====================================================================
   Projeto : SQL Help Desk - Estudos de SQL Server
   Script  : 01_criar_tabelas.sql
   Objetivo: Criar as 7 tabelas do modelo, com chaves primárias,
             chaves estrangeiras e restrições (NOT NULL, UNIQUE,
             DEFAULT e CHECK).

   Convenção de nomes das restrições:
     PK_Tabela            -> chave primária
     FK_Filha_Pai         -> chave estrangeira
     UQ_Tabela_Coluna     -> valor único
     CK_Tabela_Regra      -> regra de validação (CHECK)
     DF_Tabela_Coluna     -> valor padrão (DEFAULT)
     IX_Tabela_Coluna     -> índice

   Ordem de criação: primeiro as tabelas "pai" (que não dependem de
   ninguém), depois as tabelas "filhas" (que têm chave estrangeira).
   ===================================================================== */

USE HelpDeskTI;
GO

/* ---------------------------------------------------------------------
   1) Departamentos - setores da empresa fictícia Aurora Distribuidora
   --------------------------------------------------------------------- */
CREATE TABLE dbo.Departamentos (
    DepartamentoID  INT IDENTITY(1,1)  NOT NULL,
    Nome            NVARCHAR(60)       NOT NULL,
    Andar           TINYINT            NOT NULL,
    Ramal           CHAR(4)            NOT NULL,

    CONSTRAINT PK_Departamentos        PRIMARY KEY (DepartamentoID),
    CONSTRAINT UQ_Departamentos_Nome   UNIQUE (Nome),
    CONSTRAINT UQ_Departamentos_Ramal  UNIQUE (Ramal),
    CONSTRAINT CK_Departamentos_Andar  CHECK (Andar BETWEEN 0 AND 10)
);
GO

/* ---------------------------------------------------------------------
   2) Colaboradores - funcionários que ABREM chamados (usuários finais)
   --------------------------------------------------------------------- */
CREATE TABLE dbo.Colaboradores (
    ColaboradorID   INT IDENTITY(1,1)  NOT NULL,
    Nome            NVARCHAR(100)      NOT NULL,
    Email           VARCHAR(150)       NOT NULL,
    Cargo           NVARCHAR(60)       NOT NULL,
    DepartamentoID  INT                NOT NULL,
    DataAdmissao    DATE               NOT NULL,
    Ativo           BIT                NOT NULL
        CONSTRAINT DF_Colaboradores_Ativo DEFAULT (1),

    CONSTRAINT PK_Colaboradores        PRIMARY KEY (ColaboradorID),
    CONSTRAINT UQ_Colaboradores_Email  UNIQUE (Email),
    CONSTRAINT CK_Colaboradores_Email  CHECK (Email LIKE '%_@_%._%'),
    CONSTRAINT FK_Colaboradores_Departamentos
        FOREIGN KEY (DepartamentoID) REFERENCES dbo.Departamentos (DepartamentoID)
);
GO

/* ---------------------------------------------------------------------
   3) Tecnicos - equipe de suporte que ATENDE os chamados
   --------------------------------------------------------------------- */
CREATE TABLE dbo.Tecnicos (
    TecnicoID        INT IDENTITY(1,1)  NOT NULL,
    Nome             NVARCHAR(100)      NOT NULL,
    Email            VARCHAR(150)       NOT NULL,
    Nivel            CHAR(2)            NOT NULL,   -- N1, N2 ou N3
    CustoHora        DECIMAL(8,2)       NOT NULL,   -- custo interno por hora (R$)
    DataContratacao  DATE               NOT NULL,
    Ativo            BIT                NOT NULL
        CONSTRAINT DF_Tecnicos_Ativo DEFAULT (1),

    CONSTRAINT PK_Tecnicos            PRIMARY KEY (TecnicoID),
    CONSTRAINT UQ_Tecnicos_Email      UNIQUE (Email),
    CONSTRAINT CK_Tecnicos_Nivel      CHECK (Nivel IN ('N1', 'N2', 'N3')),
    CONSTRAINT CK_Tecnicos_CustoHora  CHECK (CustoHora > 0)
);
GO

/* ---------------------------------------------------------------------
   4) Categorias - tipos de chamado e seu prazo de atendimento (SLA)
   --------------------------------------------------------------------- */
CREATE TABLE dbo.Categorias (
    CategoriaID  INT IDENTITY(1,1)  NOT NULL,
    Nome         NVARCHAR(50)       NOT NULL,
    Descricao    NVARCHAR(200)      NULL,
    SLAHoras     INT                NOT NULL,   -- prazo máximo para resolver, em horas

    CONSTRAINT PK_Categorias           PRIMARY KEY (CategoriaID),
    CONSTRAINT UQ_Categorias_Nome      UNIQUE (Nome),
    CONSTRAINT CK_Categorias_SLAHoras  CHECK (SLAHoras > 0)
);
GO

/* ---------------------------------------------------------------------
   5) Equipamentos - inventário de TI (patrimônio)
      ColaboradorID é opcional (NULL): equipamento em estoque ou
      compartilhado (impressoras, roteadores).
   --------------------------------------------------------------------- */
CREATE TABLE dbo.Equipamentos (
    EquipamentoID   INT IDENTITY(1,1)  NOT NULL,
    Patrimonio      VARCHAR(10)        NOT NULL,
    Tipo            NVARCHAR(30)       NOT NULL,
    Marca           NVARCHAR(40)       NOT NULL,
    Modelo          NVARCHAR(60)       NOT NULL,
    DataAquisicao   DATE               NOT NULL,
    ValorAquisicao  DECIMAL(10,2)      NOT NULL,
    ColaboradorID   INT                NULL,

    CONSTRAINT PK_Equipamentos             PRIMARY KEY (EquipamentoID),
    CONSTRAINT UQ_Equipamentos_Patrimonio  UNIQUE (Patrimonio),
    CONSTRAINT CK_Equipamentos_Tipo        CHECK (Tipo IN (N'Notebook', N'Desktop', N'Monitor',
                                                           N'Impressora', N'Smartphone', N'Roteador')),
    CONSTRAINT CK_Equipamentos_Valor       CHECK (ValorAquisicao >= 0),
    CONSTRAINT FK_Equipamentos_Colaboradores
        FOREIGN KEY (ColaboradorID) REFERENCES dbo.Colaboradores (ColaboradorID)
);
GO

/* ---------------------------------------------------------------------
   6) Chamados - tabela central: cada solicitação/incidente aberto
      TecnicoID   NULL -> chamado ainda não atribuído (triagem)
      EquipamentoID NULL -> chamado não envolve um equipamento específico
      DataFechamento NULL -> chamado ainda não resolvido
      AvaliacaoNota NULL -> usuário não avaliou (ou ainda não fechou)
   --------------------------------------------------------------------- */
CREATE TABLE dbo.Chamados (
    ChamadoID       INT IDENTITY(1,1)  NOT NULL,
    Titulo          NVARCHAR(120)      NOT NULL,
    Descricao       NVARCHAR(1000)     NULL,
    ColaboradorID   INT                NOT NULL,
    TecnicoID       INT                NULL,
    CategoriaID     INT                NOT NULL,
    EquipamentoID   INT                NULL,
    Prioridade      NVARCHAR(10)       NOT NULL
        CONSTRAINT DF_Chamados_Prioridade DEFAULT (N'Média'),
    Status          NVARCHAR(20)       NOT NULL
        CONSTRAINT DF_Chamados_Status DEFAULT (N'Aberto'),
    DataAbertura    DATETIME2(0)       NOT NULL
        CONSTRAINT DF_Chamados_DataAbertura DEFAULT (SYSDATETIME()),
    DataFechamento  DATETIME2(0)       NULL,
    AvaliacaoNota   TINYINT            NULL,

    CONSTRAINT PK_Chamados             PRIMARY KEY (ChamadoID),
    CONSTRAINT CK_Chamados_Prioridade  CHECK (Prioridade IN (N'Baixa', N'Média', N'Alta', N'Crítica')),
    CONSTRAINT CK_Chamados_Status      CHECK (Status IN (N'Aberto', N'Em andamento', N'Aguardando usuário',
                                                         N'Resolvido', N'Fechado')),
    CONSTRAINT CK_Chamados_Datas       CHECK (DataFechamento IS NULL OR DataFechamento >= DataAbertura),
    CONSTRAINT CK_Chamados_Nota        CHECK (AvaliacaoNota BETWEEN 1 AND 5),
    CONSTRAINT FK_Chamados_Colaboradores
        FOREIGN KEY (ColaboradorID) REFERENCES dbo.Colaboradores (ColaboradorID),
    CONSTRAINT FK_Chamados_Tecnicos
        FOREIGN KEY (TecnicoID)     REFERENCES dbo.Tecnicos (TecnicoID),
    CONSTRAINT FK_Chamados_Categorias
        FOREIGN KEY (CategoriaID)   REFERENCES dbo.Categorias (CategoriaID),
    CONSTRAINT FK_Chamados_Equipamentos
        FOREIGN KEY (EquipamentoID) REFERENCES dbo.Equipamentos (EquipamentoID)
);
GO

/* ---------------------------------------------------------------------
   7) Interacoes - histórico de atendimento de cada chamado
      (cada registro = uma ação de um técnico e o tempo gasto nela)
      ON DELETE CASCADE: se um chamado for excluído, o histórico dele
      também é excluído automaticamente.
   --------------------------------------------------------------------- */
CREATE TABLE dbo.Interacoes (
    InteracaoID    INT IDENTITY(1,1)  NOT NULL,
    ChamadoID      INT                NOT NULL,
    TecnicoID      INT                NOT NULL,
    DataHora       DATETIME2(0)       NOT NULL
        CONSTRAINT DF_Interacoes_DataHora DEFAULT (SYSDATETIME()),
    Descricao      NVARCHAR(500)      NOT NULL,
    MinutosGastos  INT                NOT NULL,

    CONSTRAINT PK_Interacoes          PRIMARY KEY (InteracaoID),
    CONSTRAINT CK_Interacoes_Minutos  CHECK (MinutosGastos > 0),
    CONSTRAINT FK_Interacoes_Chamados
        FOREIGN KEY (ChamadoID) REFERENCES dbo.Chamados (ChamadoID) ON DELETE CASCADE,
    CONSTRAINT FK_Interacoes_Tecnicos
        FOREIGN KEY (TecnicoID) REFERENCES dbo.Tecnicos (TecnicoID)
);
GO

/* ---------------------------------------------------------------------
   Índices nas chaves estrangeiras mais consultadas.
   O SQL Server cria índice automaticamente para PK e UNIQUE,
   mas NÃO para chaves estrangeiras.
   --------------------------------------------------------------------- */
CREATE INDEX IX_Colaboradores_DepartamentoID ON dbo.Colaboradores (DepartamentoID);
CREATE INDEX IX_Equipamentos_ColaboradorID   ON dbo.Equipamentos (ColaboradorID);
CREATE INDEX IX_Chamados_ColaboradorID       ON dbo.Chamados (ColaboradorID);
CREATE INDEX IX_Chamados_TecnicoID           ON dbo.Chamados (TecnicoID);
CREATE INDEX IX_Chamados_CategoriaID         ON dbo.Chamados (CategoriaID);
CREATE INDEX IX_Chamados_Status              ON dbo.Chamados (Status);
CREATE INDEX IX_Interacoes_ChamadoID         ON dbo.Interacoes (ChamadoID);
CREATE INDEX IX_Interacoes_TecnicoID         ON dbo.Interacoes (TecnicoID);
GO

PRINT N'Tabelas criadas com sucesso. Próximo passo: 02_inserir_dados.sql';
GO
