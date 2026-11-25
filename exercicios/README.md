# Exercícios — SQL Help Desk

Dez desafios com dificuldade progressiva sobre a base **HelpDeskTI**. Cada exercício parte de um problema real do dia a dia de uma equipe de suporte. A ideia é praticar o comando e, principalmente, o raciocínio de transformar uma pergunta de negócio em consulta.

> **Antes de começar:** execute os scripts da pasta [`banco/`](../banco) na ordem `00 → 01 → 02 → 03`.
> Todos os critérios de correção consideram a base **recém-criada**. Se você alterou dados (no Exercício 04, por exemplo), rode os scripts de novo para resetar.

## Trilha de estudo

| Fase | Exercícios | Foco |
|---|---|---|
| 1. Ler dados | 01 a 03 | Selecionar, filtrar e ordenar registros de uma tabela |
| 2. Alterar dados | 04 | Inserir, atualizar e excluir com segurança |
| 3. Resumir dados | 05 e 06 | Transformar muitas linhas em indicadores |
| 4. Relacionar tabelas | 07 e 08 | Juntar informações espalhadas pelo modelo |
| 5. Analisar | 09 e 10 | Combinar tudo em relatórios e perguntas mais complexas |

Só avance de fase quando conseguir resolver os exercícios **sem consultar a anotação anterior**. Veja o método completo em [`docs/metodologia.md`](../docs/metodologia.md).

## Como registrar suas respostas

Cada exercício tem um arquivo correspondente em [`solucoes/`](../solucoes) (ex.: `solucoes/01_explorando_os_dados.sql`). Escreva lá:

1. **Raciocínio:** quais tabelas e colunas você precisa, e por quê;
2. **Consulta(s):** uma por item (a, b, c...);
3. **Interpretação:** o que o resultado significa para o negócio;
4. **O que aprendi / dúvidas.**

---

## Exercício 01 — Explorando os dados

**Contexto**
Você acabou de entrar na equipe de suporte da Aurora Distribuidora. Antes de atender o primeiro chamado, seu coordenador pede que você conheça as pessoas e as regras de atendimento da empresa.

**O que desenvolver**
- a) Liste **todas as colunas** da tabela de colaboradores.
- b) Agora liste **somente** o nome, o e-mail e o cargo de cada colaborador, com cabeçalhos amigáveis: `Colaborador`, `E-mail` e `Cargo`.
- c) Liste os técnicos de suporte mostrando nome, nível e custo por hora.
- d) Liste as categorias de chamado com o nome, o SLA em horas e uma **coluna calculada** `SLA_Dias` com o SLA convertido para dias (com casas decimais, ex.: 8 horas = 0,33 dia).

**Conceitos praticados**
`SELECT`, `FROM`, `SELECT *` vs. colunas específicas, apelidos (`AS`), expressões aritméticas e divisão inteira vs. decimal.

**Critérios de correção**
- a) e b) retornam **32 linhas**; c) retorna **7 linhas**; d) retorna **8 linhas**.
- Em b), os cabeçalhos aparecem exatamente como pedido (repare que `E-mail` tem hífen).
- Em d), a categoria *Acesso e Senhas* (4 h) deve mostrar aproximadamente **0,17** e **não 0**. Se apareceu 0, investigue por quê.
- **Reflexão:** por que é recomendado evitar `SELECT *` em consultas de sistemas e relatórios?

---

## Exercício 02 — Filtrando chamados

**Contexto**
A coordenação quer uma visão rápida da fila de atendimento e de alguns pontos do inventário.

**O que desenvolver**
- a) Chamados de prioridade **Alta ou Crítica**.
- b) Chamados que **ainda não foram encerrados** (status diferente de *Resolvido* e de *Fechado*).
- c) Chamados que **ainda não têm técnico** atribuído.
- d) Chamados de prioridade Alta ou Crítica que **ainda não foram encerrados** (combinação de a e b).
- e) Equipamentos adquiridos em **2025** com valor **acima de R$ 3.000,00**.
- f) Colaboradores cujo nome **começa com a letra R**.
- g) Colaboradores **desligados** (inativos).

**Conceitos praticados**
`WHERE`, operadores de comparação (`=`, `<>`, `>`, `>=`, `<`), `AND`/`OR` e precedência com parênteses, `IN`/`NOT IN`, `BETWEEN`, `LIKE`, `IS NULL`.

**Critérios de correção**
- a) **35** linhas · b) **10** · c) **4** · d) **2** · e) **2** · f) **3** · g) **2**.
- Em c), a consulta **não** usa `= NULL`. Teste as duas formas e explique a diferença.
- Em d), se você obteve um número maior que 2, revise como `AND` e `OR` estão sendo combinados.
- Em e), o filtro de ano funciona **sem** aplicar função sobre a coluna de data (dica de desempenho: pense em intervalo).
- Textos com acento usam o prefixo `N` (ex.: `N'Crítica'`).

---

## Exercício 03 — Ordenando e removendo duplicatas

**Contexto**
O setor de compras está planejando a renovação do parque de equipamentos e precisa de algumas listas organizadas.

**O que desenvolver**
- a) Lista das **marcas** de equipamentos, **sem repetição**, em ordem alfabética.
- b) Os **5 equipamentos mais caros** (patrimônio, tipo, modelo e valor), do mais caro para o mais barato.
- c) Todas as **combinações distintas de tipo e marca** existentes no inventário, ordenadas por tipo e depois por marca.
- d) Colaboradores ativos ordenados pelo **departamento** (código) e, dentro de cada departamento, pela **data de admissão mais recente primeiro**.

**Conceitos praticados**
`ORDER BY` (`ASC`/`DESC`, múltiplas colunas), `DISTINCT` (com uma e com várias colunas), `TOP`.

**Critérios de correção**
- a) **10** marcas, começando por *Brother* e terminando em *TP-Link*.
- b) **5** linhas; a primeira é o patrimônio **PAT-00022**, de R$ **6.326,07**.
- c) **16** linhas. Explique por que o número é maior que o de a).
- d) **30** linhas; repare que cada coluna do `ORDER BY` pode ter sua própria direção.
- **Bônus:** em b), pesquise o que muda com `TOP 5 WITH TIES` e quando isso é útil.

---

## Exercício 04 — Manutenção de dados com segurança

**Contexto**
O Paulo Sérgio Tavares foi contratado hoje (24/11/2026) como *Analista de Auditoria* no departamento **Auditoria Interna**, o único departamento que ainda não tem colaboradores. Você vai registrar a chegada dele no sistema e o primeiro chamado que ele abriu.

**Regra de ouro deste exercício:** faça tudo dentro de uma transação (`BEGIN TRANSACTION`). Antes de cada `UPDATE` ou `DELETE`, rode um `SELECT` com o mesmo `WHERE` para ver quais linhas serão afetadas. No final, decida entre `COMMIT` e `ROLLBACK`.

**O que desenvolver**
1. Cadastre o colaborador (e-mail: `paulo.tavares@aurora.example`) **sem informar** a coluna `Ativo`. Confira que o valor padrão foi aplicado.
2. Registre um chamado aberto por ele: título *"Instalação do Power BI Desktop"*, categoria *Software*. **Não informe** prioridade, status nem data de abertura. Observe quais valores o banco preencheu sozinho.
3. Atribua o chamado à técnica **Aline Cordeiro Viana** e mude o status para *Em andamento*.
4. Registre uma interação da Aline nesse chamado: *"Contato com o usuário para levantamento do problema."*, 15 minutos.
5. Entregue a ele um dos **notebooks em estoque** (sem responsável): o de menor número de patrimônio.
6. A interação foi registrada por engano: **exclua-a**.
7. Tente cadastrar um chamado com prioridade *"Urgente"* e depois tente excluir o colaborador de ID 1. Leia as mensagens de erro e identifique qual restrição bloqueou cada operação.
8. Finalize a transação.

**Conceitos praticados**
`INSERT INTO ... VALUES`, colunas `IDENTITY`, `DEFAULT`, `UPDATE ... SET ... WHERE`, `DELETE ... WHERE`, `BEGIN TRANSACTION`/`COMMIT`/`ROLLBACK`, `@@ROWCOUNT`, integridade referencial (FK) e `CHECK`.

**Critérios de correção**
- O colaborador recebe o **ID 33**, o chamado o **ID 97** e a interação o **ID 225** (se não for o caso, você provavelmente já tinha inserido algo antes; resete a base).
- O chamado aparece com prioridade **Média**, status **Aberto** e data/hora atual, sem que você tenha informado esses valores.
- Todo `UPDATE` e `DELETE` usa a **chave primária** no `WHERE` e afeta **exatamente 1 linha**.
- O notebook entregue é o **PAT-00052**.
- O item 7 gera **dois erros diferentes**; você consegue dizer o nome da restrição em cada um (ex.: `CK_...`, `FK_...`).
- **Reflexão:** o que aconteceria em um `UPDATE` sem `WHERE`? E por que, na prática, usamos `ROLLBACK` ao testar?

> Depois deste exercício, rode novamente os scripts `00 → 03` para voltar à base original.

---

## Exercício 05 — Indicadores gerais do help desk

**Contexto**
A diretoria pediu um painel com números consolidados do ano. Nada de listas: só os totais.

**O que desenvolver**
Em **uma única consulta** sobre a tabela de chamados, retorne:
- a) total de chamados; b) quantos já têm data de fechamento; c) quantos receberam avaliação; d) a nota média de satisfação, **com 2 casas decimais**; e) a data do primeiro e do último chamado aberto.

Em outra consulta, sobre o inventário:
- f) valor total do patrimônio, equipamento mais caro, mais barato e valor médio.

E sobre as interações:
- g) total de minutos trabalhados e o equivalente em **horas** (com casas decimais).

**Conceitos praticados**
`COUNT(*)` vs. `COUNT(coluna)`, `SUM`, `AVG`, `MIN`, `MAX`, tratamento de `NULL` nas agregações, conversão de tipos (`CAST`/`CONVERT`), `ROUND`.

**Critérios de correção**
- a) **96** · b) **86** · c) **58**.
- d) **3,72**. Se apareceu **3**, descubra por que o `AVG` "perdeu" as casas decimais (dica: olhe o tipo da coluna no script de criação).
- e) primeiro: **07/01/2026 13:45** · último: **24/11/2026 11:15**.
- f) total **R$ 181.224,31** · máximo **R$ 6.326,07** · mínimo **R$ 695,98** · médio **≈ R$ 3.356,01**.
- g) **10.105** minutos ≈ **168,42** horas.
- **Reflexão:** a média de notas é calculada sobre 96, 86 ou 58 chamados? Por quê?

---

## Exercício 06 — Agrupando para enxergar padrões

**Contexto**
O coordenador quer entender **onde** está a demanda para redistribuir a equipe.

**O que desenvolver**
- a) Quantidade de chamados **por status**, do maior para o menor.
- b) Quantidade de chamados **por prioridade**.
- c) Quantidade de chamados abertos **por mês** de 2026, em ordem cronológica.
- d) Categorias (pelo código) com **12 ou mais** chamados.
- e) Tipos de equipamento cujo **valor médio** é superior a R$ 2.000,00, mostrando também a quantidade de itens de cada tipo.

**Conceitos praticados**
`GROUP BY` (com coluna e com expressão), `HAVING` vs. `WHERE`, ordenação por agregação, funções de data (`YEAR`, `MONTH`).

**Critérios de correção**
- a) **5** grupos; *Fechado* lidera com **68**.
- b) **4** grupos; *Média* tem **42**. **Bônus:** ordene na sequência lógica Crítica → Alta → Média → Baixa, e não em ordem alfabética.
- c) **11** linhas; **novembro** tem o maior volume (**18**) e **julho** o menor (**4**).
- d) **4** categorias.
- e) **3** tipos: Notebook, Desktop e Impressora.
- Você sabe explicar por que o filtro de d) **não** pode ser feito no `WHERE`.

---

## Exercício 07 — Relatório de chamados encerrados (INNER JOIN)

**Contexto**
Até aqui você viu só códigos (ColaboradorID 6, CategoriaID 3...). O gestor precisa de um relatório **legível** dos chamados encerrados em **outubro de 2026** para a reunião mensal.

**O que desenvolver**
- a) Para cada chamado com data de fechamento em outubro/2026, mostre: número do chamado, título, **nome do colaborador**, **nome do departamento**, **nome da categoria**, **nome do técnico**, prioridade, data de abertura e data de fechamento, ordenados pela data de fechamento.
- b) Quantidade de chamados **por departamento** (nome do departamento), do maior para o menor.

**Conceitos praticados**
`INNER JOIN` com várias tabelas, apelidos de tabela, qualificação de colunas (`c.Nome` vs. `t.Nome`), filtro de intervalo em `DATETIME2`, `JOIN` + `GROUP BY`.

**Critérios de correção**
- a) **10** linhas, todas com nomes (nenhum código "solto" no lugar de nomes).
- O filtro de outubro precisa funcionar para um chamado fechado em **31/10 às 22h**. Nesta base o resultado pode até coincidir, mas explique por que `BETWEEN '2026-10-01' AND '2026-10-31'` é arriscado com colunas `DATETIME2`.
- Não há ambiguidade de colunas: como várias tabelas têm a coluna `Nome`, cada uma recebe um apelido claro no resultado.
- b) **8** departamentos; **Diretoria** lidera com **18**. Por que a *Auditoria Interna* não aparece?

---

## Exercício 08 — Encontrando o que está faltando (LEFT JOIN)

**Contexto**
Auditoria de cadastros: a TI quer descobrir registros "órfãos" ou sem uso, que um `INNER JOIN` esconderia.

**O que desenvolver**
- a) Colaboradores que **nunca abriram** um chamado.
- b) Técnicos que **não têm** nenhum chamado atribuído.
- c) **Todas** as categorias com a quantidade de chamados de cada uma, **inclusive as que têm zero**.
- d) Equipamentos **sem responsável**, mostrando patrimônio, tipo e modelo.
- e) Departamentos **sem colaboradores**.
- f) Os chamados que ainda não têm técnico, com o nome de quem abriu e a coluna do técnico exibindo o texto *"Não atribuído"*.

**Conceitos praticados**
`LEFT JOIN`, padrão *anti-join* (`LEFT JOIN ... WHERE chave IS NULL`), `COUNT(*)` vs. `COUNT(coluna)` após `LEFT JOIN`, `ISNULL`/`COALESCE`, filtro no `ON` vs. no `WHERE`.

**Critérios de correção**
- a) **3** pessoas · b) **1** técnica (contratada recentemente) · d) **10** equipamentos · e) **1** departamento · f) **4** chamados.
- c) **8** linhas, e *Telefonia* aparece com **0**. Se aparecer **1**, revise o que está sendo contado.
- Você sabe explicar em que caso um `INNER JOIN` e um `LEFT JOIN` retornariam o mesmo resultado.

---

## Exercício 09 — Painel de desempenho e SLA

**Contexto**
Fim de ano: hora da avaliação de desempenho da equipe e do cumprimento dos prazos (SLA) prometidos às áreas.

**O que desenvolver**
- a) Para **cada técnico** (inclusive quem ainda não atendeu): nome, nível, total de chamados atribuídos, quantos estão encerrados, **tempo médio de resolução em horas** (1 casa decimal) e **nota média** (2 casas decimais), considerando apenas os chamados encerrados.
- b) Para cada categoria: quantidade de chamados encerrados, quantos foram resolvidos **dentro do SLA**, quantos ficaram **fora** e o **percentual dentro do SLA** (1 casa decimal).
- c) Crie uma coluna `FaixaTempo` que classifique cada chamado encerrado em *"Até 4h"*, *"4h a 24h"* ou *"Mais de 24h"* e conte quantos chamados há em cada faixa.

**Conceitos praticados**
`DATEDIFF`, `CASE WHEN` (dentro e fora de agregações), agregação condicional (`SUM(CASE ...)`), `LEFT JOIN` + `GROUP BY`, conversões para evitar divisão inteira.

**Critérios de correção**
- a) **7** linhas. Exemplo de conferência: **Juliana Prates Moura**: 19 atribuídos, 18 encerrados, ≈ **10,8 h** e nota **4,25**. A técnica sem atendimentos aparece com contagem 0 (e não some do relatório).
- b) Compare a duração em **minutos** com o SLA convertido para minutos (veja por que `DATEDIFF(HOUR, ...)` pode enganar). No total, **55** chamados dentro e **31** fora do SLA. *Hardware* ≈ **85,7%** e *Rede e Internet* ≈ **45,5%**.
- c) As três faixas somam **86**.
- **Interpretação:** escreva 2 ou 3 frases, como se fosse para o gestor, sobre qual categoria merece atenção e por quê.

---

## Exercício 10 — Subconsultas, CTEs e perguntas compostas

**Contexto**
Agora as perguntas da gestão dependem de **outras perguntas**: "acima da média", "nunca teve", "o maior de cada grupo".

**O que desenvolver**
- a) Equipamentos com valor **acima da média geral** do inventário.
- b) Colaboradores que **já abriram pelo menos um chamado Crítico** (resolva com `IN` e depois com `EXISTS`).
- c) Departamentos que **nunca** tiveram chamado da categoria *Segurança da Informação*.
- d) Chamados encerrados cujo tempo de resolução foi **maior que a média da própria categoria**.
- e) **Custo de atendimento por técnico**: minutos trabalhados (tabela de interações) × custo por hora, mostrando também a quantidade de chamados atribuídos (tabela de chamados), tudo **na mesma linha**.
- f) **Desafio bônus:** o colaborador que mais abriu chamados **em cada departamento**.

**Conceitos praticados**
Subconsulta escalar, subconsulta com `IN`, `EXISTS`/`NOT EXISTS`, subconsulta correlacionada, CTE (`WITH`), pré-agregação para evitar multiplicação de linhas (*fan-out*). No bônus: funções de janela (`ROW_NUMBER`/`RANK` com `PARTITION BY`).

**Critérios de correção**
- a) **30** equipamentos · b) **9** colaboradores (as duas versões dão o mesmo resultado) · c) **4** departamentos · d) **31** chamados.
- e) **7** linhas; **Leonardo Furtado Sá** tem o maior custo: **2.585 min → R$ 3.123,54**. A quantidade de chamados de cada técnico deve ser a mesma do Exercício 09. Se ficou maior, você caiu na armadilha de juntar duas tabelas "filhas" antes de agregar.
- e) Cuidado com `MinutosGastos / 60`: com tipos inteiros, 2585 / 60 vira 43, e não 43,08.
- f) **8** linhas (um por departamento com chamados); *Ana Paula Ribeiro* (Financeiro) e *Natália Rezende Cunha* (Diretoria) aparecem com **7** chamados cada.
- **Reflexão:** em d) e e), compare a versão com subconsulta e a versão com CTE. Qual ficou mais fácil de ler?
