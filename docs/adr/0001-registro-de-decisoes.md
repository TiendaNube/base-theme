# ADR-0001 — Registro de decisões em ADRs

- **Status:** Aceito
- **Data:** 2026-10-12
- **Decisores:** Caio Marques (owner), com apoio de Claude Code

## Contexto

Até aqui as decisões do tema viviam espalhadas: parte em `CLAUDE.md`, parte
como notas dentro de invariantes do `docs/architecture-map.md` (ex.: a nota
sobre variantes da PDP em D1, a exceção de `LS.*` em L6), parte em relatórios
de drift e parte só no histórico de commits. O contrato de arquitetura é bom em
dizer **o que** é obrigatório, mas misturar nele o **porquê** o deixou longo e
fez `CLAUDE.md` virar um segundo lugar de regras. Resultado prático: ao longo de
2026 algumas decisões de estilização (ADR-0002, ADR-0003) foram desrespeitadas
porque o rationale não estava onde quem implementava olhava.

## Decisão

Registrar toda decisão de arquitetura como um ADR em `docs/adr/`, no formato
descrito em `docs/adr/README.md`. `CLAUDE.md` passa a ser orientação
operacional curta e aponta para os ADRs; `architecture-map.md` continua sendo o
contrato de regras e registros exaustivos, sem rationale longo.

Toda decisão nova que afete mais de um arquivo ou que crie/relaxe uma regra
nasce como ADR **antes** da implementação (pode nascer `Proposto` e virar
`Aceito` depois da validação). Specs referenciam os ADRs aplicáveis, não só
códigos de invariante.

## Consequências

- Rationale tem um endereço estável; auditorias de drift e specs citam ADRs.
- `CLAUDE.md` encolhe e deixa de ser lugar de regra — se uma regra só existe
  lá, está no lugar errado.
- Decisões antigas foram reconstruídas a partir do histórico (ADR-0002 a 0013)
  com as datas e commits de origem; onde a data é a da formalização e não da
  decisão original, o ADR diz isso.
- Custo: mais um documento para manter. Mitigação: ADR é curto e imutável.

## Referências

- `docs/adr/README.md` — formato e prioridade entre documentos.
- `docs/architecture-drift-reports/20261012-styling-audit.md` — auditoria que
  motivou a formalização.
