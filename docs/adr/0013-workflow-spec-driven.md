# ADR-0013 — Desenvolvimento spec-driven com contrato auditável

- **Status:** Substituído por ADR-0016

> Substituído pelo [ADR-0016](0016-tasks-do-fibery-em-ondas.md): o trabalho passa a ser Tasks do Fibery em ondas; `docs/specs/` e `/implement-spec` foram removidos.

- **Data:** 2026-07-31 (`d9172b1`, contrato versionado) e 2026-08-04 (`b07df34`, specs); formalizado em 2026-10-12
- **Decisores:** Caio Marques

## Contexto

O desenvolvimento é feito com IA (Claude Code). O esquema anterior —
`research-prompt.md` → `plan-prompt.md` → `implementation-prompt.md` — não
sobrevivia entre sessões: cada feature era re-digitada como prompt avulso, e o
contrato de arquitetura vivia em `.claude/` ignorado pelo git. Features
grandes (PDP) precisavam de fatias pequenas, revisáveis uma a uma.

## Decisão

1. **Contrato versionado**: `docs/architecture-map.md` é a fonte de regras
   (MUST/NEVER) e registros; tem prioridade sobre spec e pedido. Rationale
   vai para ADRs (ADR-0001).
2. **Feature = `docs/specs/<slug>/plan.md` + specs numeradas**, cada uma com
   objetivo, escopo explícito de arquivos, critérios de aceite, invariantes
   e ADRs aplicáveis, referências de padrão. Spec tem `status`.
3. **`/implement-spec` implementa uma spec por vez**: valida contra o
   contrato, acha 2+ padrões existentes, implementa dentro do escopo, roda
   build se `__src/` mudou, roda os testes locais (ADR-0014), confere
   critérios, atualiza status, relata conformidade. Nunca commita.
4. **`/pr` commita, builda se preciso, roda lint + testes, abre PR em
   português e para.** `/main` só sincroniza.
5. **Auditoria de drift** (`docs/update-architecture.md`) classifica cada
   invariante (VALID/WEAK/DRIFTED/REDUNDANT), corrige o contrato e grava em
   `docs/architecture-drift-reports/`.
6. Commits em inglês (conventional), PRs e docs em português.

## Consequências

- Trabalho sobrevive à sessão; o que foi decidido numa spec fica rastreável.
- `docs/plans/` e `docs/researches/` são histórico, não destino de trabalho
  novo.
- Custo: specs demais para mudanças triviais. Regra prática: correção de
  uma linha não precisa de spec; precisa de teste.

## Referências

- `docs/specs/README.md`, `.claude/skills/implement-spec/SKILL.md`, `.claude/skills/pr/SKILL.md`.
- `docs/update-architecture.md`.
