# CLAUDE.md

Orientação operacional para o Claude Code neste repositório. Regras vivem no
contrato (`docs/architecture-map.md`); o **porquê** de cada regra vive nos ADRs
(`docs/adr/`). Se algo aqui contradiz um ADR ou o contrato, eles vencem.

## O que é este repo

Tema de loja para **Nuvemshop/Tiendanube** (plataforma hospedada — sem backend
próprio). Contém só:

- **Templates** `.tpl` (Twig com tags/filtros da Nuvemshop), renderizados pela
  plataforma — `layouts/`, `templates/`, `snipplets/<domínio>/`.
- **Build** Tailwind v4 + esbuild que compila `__src/` em `static/` (commitado).
- **Config** `config/*.txt` com as opções que o lojista vê no admin.

## Comandos

```bash
npm run dev            # watch CSS + JS
npm run build          # produção: Tailwind + pre-build (cache-busting) + esbuild — SEMPRE este após mudar __src/
npm run ftp:deploy     # sobe o disco para o FTP da loja de dev (via /ftp-deploy)
npm test               # Playwright contra a loja de dev, headed (Cloudflare) — ver tests/README.md
npm run lint:styles    # guard de cores hardcoded (ADR-0003)
```

O loop de uma mudança é **máquina → loja de dev** (ADR-0015): editar → build →
subir para a loja de dev → `npm test` + screenshots na loja → ajustar. Não há
preview local no fluxo (`tools/preview/` está descontinuado e será removido).
Sessões na nuvem não alcançam a loja (Cloudflare) — fazem só docs/planejamento.

Nunca rode `node esbuild.config.mjs` sozinho para entregar — o `pre-build.js`
gera `gaius-v{epoch}.js` e reescreve `esbuild.config.mjs` + `layouts/layout.tpl`
(ADR-0007). O deploy não builda: o que está em `static/` no git vai pro ar.

## Decisões que você precisa conhecer (resumo — leia o ADR antes de tocar)

| Tema | Regra em uma linha | ADR |
|---|---|---|
| Estilo | Tailwind v4 via `@theme` em `__src/css/app.css`; Bootstrap foi removido e suas classes não existem mais | 0002 |
| Cores | Nunca literal: tokens (`bg-bg`, `text-fg`, `text-secondary`, `bg-control`) ou `var(--*-color)`; constantes de marca só no `@theme` (`--color-highlight`, `--color-danger`); overlays preto/branco com opacidade são a única exceção | 0003 |
| CSS custom | Só em `app.css`, só para o que Tailwind não expressa; sem `<style>` autoral nem `style=""` estático | 0004 |
| JS | Legado jQuery (`static/js/*.tpl`) é referência; tudo novo é vanilla em `__src/js/modules/<contexto>/` | 0005 |
| Módulos | Export nomeado + guard `if (!el) return;` + invocação em `index.js`; irmãos só se falam por `window.fn?.()`; `js-*` liga template↔JS, `data-*` carrega estado | 0006 |
| Ícones/vendors | Lucide canônico (`<i data-lucide>` + `lucide.createIcons()`); Swiper e Lucide são globais vendorados, nunca npm | 0008 |
| Templates | Snipplet novo em pasta de domínio; home roteada por `home-section-switch.tpl`; customização via `settings.txt` | 0009 |
| Plataforma | Não chamar `LS.*` do custom, exceto `LS.addItem/removeItem` em módulos de carrinho; PDP é dona das variantes (sem `LS.changeVariant`) | 0010 |
| Figma | Design → tokens, nunca hex verbatim; breakpoints são decisão nossa; valida com screenshot | 0011 |
| Deploy | Merge em `master` = deploy via FTPS na loja Nuvemshop (hoje só existe a loja de dev `democamisetasromadev`; produção ainda não subiu); `/ftp-deploy` só a pedido explícito | 0012 |
| Workflow | Task do Fibery é a unidade; ondas com linhas (worktree + branch `wave-N/<linha>`); só a integração builda/sobe/testa; `/pr` abre PR e para | 0016 |
| Testes | Desenvolve na máquina, valida na loja de dev `democamisetasromadev` (Playwright `desktop`/`mobile` em `tests/` + screenshots) + `lint:styles`; o renderer local do 0014 foi descontinuado | 0015 |

## Fluxo de uma feature

1. O trabalho é uma **Task no Fibery** (workspace `camisetas-roma-dev`, space
   "Project Tracking", projeto "Roma Theme V2"); a descrição traz contexto,
   nós do Figma e aceite. Implemente direto dela — as regras são os ADRs e o
   contrato. Não há plan/specs no repo.
2. Tasks andam em **ondas**; cada **linha** é um worktree + branch
   `wave-N/<linha>` (de `wave/N`) dono exclusivo dos seus templates. Fora do
   escopo: pare e reporte.
3. Em uma linha: rode só `npm run lint:styles`. **Nunca** `npm run build`,
   deploy, `npm test`, nem commite `static/`, `esbuild.config.mjs` ou a linha
   `gaius-v` do `layout.tpl` (pre-build reescreve: conflito garantido).
4. A sessão principal integra a onda: merge em `wave/N` → um build → deploy
   na loja de dev → `npm test` + screenshots 393/1440 vs. Figma → um PR por
   onda (`/pr`). Merge é manual; depois, tasks Done no Fibery.
5. Correção de uma linha também exige lint + teste.

## Onde olhar

- `docs/architecture-map.md` — contrato: invariantes A1–A14, D1–D3, S1–S5,
  L1–L6, R1–R7, F1–F10, registros exaustivos de `js-*`, `window.*`, estado.
- `docs/adr/README.md` — índice dos ADRs e prioridade entre documentos.
- `docs/adr/0015-*.md` — o loop máquina → loja de dev e as pendências para fechá-lo.
- `docs/architecture-drift-reports/` — auditorias; a de 2026-10-12 lista as
  violações de estilo conhecidas e o que ainda é dívida.
- `docs/plans/`, `docs/researches/` — histórico do workflow antigo, só leitura.
