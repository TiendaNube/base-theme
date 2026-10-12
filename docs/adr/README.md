# Architecture Decision Records (ADRs)

Registro das decisões de arquitetura do Roma Theme V2 — **o que** foi decidido,
**por que**, e **o que isso implica**. Cada ADR é imutável depois de aceito: uma
decisão nova que contradiz uma antiga nasce como um ADR novo que marca o antigo
como `Substituído por ADR-NNNN`.

## Por que existe (e como se relaciona com os outros docs)

| Documento | Papel | Responde |
|---|---|---|
| `docs/adr/` | **Decisões** com contexto e rationale | "Por que é assim?" |
| `docs/architecture-map.md` | **Contrato** — regras MUST/NEVER, registros exaustivos (`js-*`, `window.*`, estado) | "O que é obrigatório hoje?" |
| `CLAUDE.md` | **Orientação operacional** curta para a IA (build, workflow, onde olhar) | "Por onde começo?" |
| `docs/specs/` | **Trabalho** em andamento — plano + fatias implementáveis | "O que estamos fazendo?" |
| `docs/architecture-drift-reports/` | **Auditorias** do contrato vs. código | "Onde o código desviou?" |

Prioridade em conflito: ADR aceito > `architecture-map.md` > spec > pedido avulso.
Se o contrato contradiz um ADR, o contrato está desatualizado — corrija o contrato.

## Índice

| ADR | Título | Status |
|---|---|---|
| [0001](0001-registro-de-decisoes.md) | Registro de decisões em ADRs | Aceito |
| [0002](0002-tailwind-v4-unico-sistema-de-estilo.md) | Tailwind v4 (CSS-first) como único sistema de estilo | Aceito |
| [0003](0003-cores-do-tema-e-tokens.md) | Cores do tema só via variáveis da plataforma e tokens `@theme` | Aceito |
| [0004](0004-css-custom-e-estilos-inline.md) | CSS custom só em `app.css`; sem `<style>` autoral nem inline estático | Aceito |
| [0005](0005-camada-dual-de-js.md) | Camada dual de JS: legado como referência, vanilla JS em `__src/` | Aceito |
| [0006](0006-contrato-de-modulos-js.md) | Contrato de módulos: exports nomeados, guard de DOM, `window.*`, `js-*`/`data-*` | Aceito |
| [0007](0007-build-e-cache-busting.md) | esbuild IIFE + bundle `gaius-v{epoch}.js` com `static/` commitado | Aceito |
| [0008](0008-icones-e-bibliotecas-vendoradas.md) | Lucide canônico; Swiper e Lucide como globais vendorados | Aceito |
| [0009](0009-templates-snipplets-e-home.md) | Snipplets por domínio e home roteada pelo admin | Aceito |
| [0010](0010-fronteira-com-a-plataforma.md) | Fronteira com `LS.*`: delegar ao legado, exceto carrinho e PDP | Aceito |
| [0011](0011-figma-para-tokens.md) | Figma é fonte de intenção, não de valores | Aceito |
| [0012](0012-deploy-ftp-e-producao.md) | Merge em `master` = deploy em produção via FTPS; `/ftp-deploy` manual | Aceito |
| [0013](0013-workflow-spec-driven.md) | Desenvolvimento spec-driven com contrato auditável | Aceito |
| [0014](0014-stack-de-teste-local.md) | Stack de teste local: renderer Twig + fixtures + Playwright + lint de estilos | Substituído em parte por 0015 |
| [0015](0015-desenvolver-na-maquina-testar-na-loja-de-dev.md) | Desenvolver na máquina, testar na loja de dev | Aceito |

## Anatomia de um ADR

```markdown
# ADR-NNNN — Título

- **Status:** Proposto | Aceito | Substituído por ADR-NNNN
- **Data:** AAAA-MM-DD
- **Decisores:** quem decidiu

## Contexto
O problema e as forças em jogo. Fatos, não opiniões.

## Decisão
O que foi decidido, no imperativo. Curto.

## Consequências
O que fica melhor, o que fica pior, o que passa a ser obrigatório.
Dívidas conhecidas que a decisão deixa.

## Referências
Commits, specs, invariantes do contrato (A1…F10), relatórios de drift.
```

Numeração sequencial, slug em kebab-case, texto em português. Um ADR por
decisão — se o texto precisa de "e também", provavelmente são dois.
