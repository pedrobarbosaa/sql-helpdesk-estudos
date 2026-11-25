# Metodologia de estudo

O objetivo aqui não é decorar comandos, e sim aprender a **pensar em consultas**: transformar uma pergunta de negócio em SQL e depois conferir se a resposta faz sentido.

## O ciclo de cada exercício

Para cada item, siga estas seis etapas:

1. **Entenda a pergunta.** Reescreva o pedido com suas palavras. O que exatamente precisa aparecer no resultado: uma lista, um número, um ranking?
2. **Mapeie os dados.** Quais tabelas têm essa informação? Quais colunas? Como as tabelas se ligam (quais chaves)? Consulte o diagrama no README principal.
3. **Construa aos poucos.** Comece pelo `SELECT ... FROM` mais simples possível e execute. Acrescente **uma** cláusula por vez (`WHERE`, depois `JOIN`, depois `GROUP BY`...), executando a cada passo. Assim fica fácil descobrir qual parte quebrou ou mudou o resultado.
4. **Confira o resultado.** Compare com os critérios do exercício. Faça uma "prova real": se o total por grupo deveria somar 96, some. Se uma linha parecer estranha, procure ela na tabela original.
5. **Interprete.** Escreva em uma frase o que o resultado diz para o negócio (ex.: *"Rede e Internet tem o pior cumprimento de SLA; vale revisar o prazo ou reforçar o N2."*).
6. **Registre.** Salve a consulta final no arquivo de `solucoes/` com comentários sobre o raciocínio e o que você aprendeu.

## A ordem lógica de execução

Grande parte das dúvidas de SQL se resolve entendendo que o banco **não** executa a consulta na ordem em que ela é escrita:

```
Escrita:   SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY
Execução:  FROM/JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
```

É por isso que um apelido criado no `SELECT` não pode ser usado no `WHERE`, mas pode no `ORDER BY`, e que um filtro sobre `COUNT(*)` precisa ir no `HAVING`.

## Regras para avançar de fase

- **Fase 1 (01–03) → Fase 2:** você escreve filtros com `AND`/`OR`/`NULL` sem errar a lógica.
- **Fase 2 (04) → Fase 3:** você nunca roda `UPDATE`/`DELETE` sem antes conferir as linhas afetadas com um `SELECT`.
- **Fase 3 (05–06) → Fase 4:** você sabe explicar a diferença entre `COUNT(*)` e `COUNT(coluna)`, e entre `WHERE` e `HAVING`.
- **Fase 4 (07–08) → Fase 5:** você prevê, **antes de executar**, se um `JOIN` vai aumentar, manter ou reduzir o número de linhas.

Se travar numa regra, volte ao exercício anterior e refaça-o **sem olhar** sua solução antiga.

## Revisão espaçada

- Uma semana depois de concluir um exercício, refaça **um item** dele do zero.
- Ao terminar os dez, invente **três perguntas novas** sobre a base (ex.: *"qual técnico mais escala chamados para outro nível?"*) e resolva. Elas também podem entrar no portfólio.

## Como pedir revisão

Envie a consulta junto com:
- o número do exercício e do item;
- o resultado que você obteve (quantidade de linhas ou as primeiras linhas);
- a mensagem de erro completa, se houver.

A revisão aponta os erros, explica o motivo e sugere melhorias, sem entregar a resposta pronta: a ideia é você chegar lá.
