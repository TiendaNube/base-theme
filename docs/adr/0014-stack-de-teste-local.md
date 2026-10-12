# ADR-0014 — Stack de teste local: renderer Twig + fixtures + Playwright + lint de estilos

- **Status:** Substituído em parte por ADR-0015 — o renderer local deixou de ser o alvo de teste no mesmo dia; `lint:styles` e a suíte Playwright (projetos `real-*`) continuam valendo
- **Data:** 2026-10-12
- **Decisores:** Caio Marques (owner), implementado por Claude Code

## Contexto

Até aqui "zero testes" era decisão registrada (RISK 6 do contrato): a única
validação era o preview da Nuvemshop, que na prática é a loja em produção
(ADR-0012). Isso tem três custos que ficaram visíveis com desenvolvimento por
IA:

1. A IA não consegue ver o resultado do que fez. Nas specs da PDP, 36
   critérios de aceite ficaram marcados "pendente — requer preview real" e
   alguns foram fechados por decisão do usuário sem validação.
2. Cada ciclo de "ver se ficou certo" exige `/ftp-deploy` em produção.
3. As regras de estilização (ADR-0002/0003/0004) eram só revisão humana — e
   foram desrespeitadas (auditoria de 2026-10-12: 8 violações reais, 13
   ambíguas, nenhuma pega).

Pesquisa de viabilidade: os templates são ~90% Twig padrão; o que é da
plataforma são 4 tags (`snipplet`, `template_content`, `head_content`,
`paginate`), ~25 filtros/funções e `component()`. O bundle custom é um IIFE
auto-contido que só precisa de `Swiper` (vendorado em `static/`), `lucide`
(vendorado) e um `LS` mínimo. Chromium já estava em cache na máquina.

Alternativas consideradas:
- **Playwright contra a loja real** — maior fidelidade, mas sem URL de
  preview/rascunho, testa em produção com carrinho real. Fica como validação
  manual final, não como loop.
- **Testes JS puros com fixtures HTML à mão (jsdom)** — barato, mas as
  fixtures derivam dos templates e o contrato `js-*` (o maior risco de
  regressão) não é testado. jsdom não faz layout, scroll, Swiper.
- **Renderer local + Playwright** (escolhida) — testa template + CSS + JS
  juntos no browser real, com fixtures de dados em vez de HTML.

## Decisão

1. **`tools/preview/`** renderiza as páginas localmente com **twig.js**:
   - `engine.mjs`: loader que aplica um pré-processamento (tags da
     plataforma → Twig padrão; shims para o que o twig.js não parseia) e
     registra os filtros/funções da Nuvemshop como stubs honestos
     (`translate` lê `config/translations.txt`; `money` formata BRL;
     imagens viram placeholders SVG; `component()` vira comentário HTML).
   - `platform-head.mjs`: o que `{% head_content %}` daria — as CSS vars
     de `style-colors.scss.tpl` a partir das settings, um `LS` stub com
     `ready` **pendente** (o bloco jQuery legado nunca roda) e um
     `jQueryNuvem` no-op para os `<script>` inline antigos.
   - `fixtures/`: `settings.mjs` (defaults.txt + paleta real da Roma +
     seções da home), `catalog.mjs` (fábrica de produtos com
     `variants_object` no formato que o JS lê), `pages.mjs` (contexto de
     `home`, `product`, `category`).
   - `serve.mjs`: servidor em `:4321` que re-renderiza a cada request, serve
     `static/` (compilando `*.tpl` de CSS via Twig) e responde 200 aos
     endpoints que o JS custom chama (cart, search).
2. **Playwright** (`playwright.config.mjs`, `tests/*.spec.mjs`) sobe o
   servidor e roda em dois projetos: `mobile` (Pixel 7) e `desktop`
   (1440px). Rede externa é bloqueada — o preview é offline por desenho.
   Testes base: smoke por página (renderiza, bundle boota sem erro,
   `window.*` registrado, tokens resolvem para a paleta do admin) e fluxos
   de componente (cart drawer via `data-state`).
3. **`scripts/lint-styles.mjs`** (`npm run lint:styles`) é o enforcement
   do ADR-0003: falha em hex, rgb não-universal e classe de paleta fora das
   exceções; `lint-styles: allow <motivo>` na linha é a válvula auditável.
4. **Fluxo obrigatório**: `/implement-spec` roda `npm run lint:styles` e
   `npm test` antes de marcar uma spec `done` e anexa screenshots das
   páginas afetadas ao relatório; `/pr` roda os dois antes de abrir o PR.
   A validação no preview real da Nuvemshop continua sendo o passo final
   humano — o preview local não substitui, reduz.
5. **Escopo explícito do que o preview NÃO reproduz**: saída real de
   `component()` (parcelas, promoções, placeholders), formatação real de
   `money`/`translate` da plataforma, a camada jQuery legada
   (`store.js.tpl`, `LS.search`, `LS.changeQuantity`), `style-async.scss.tpl`
   compilado (servido como SCSS cru; regras inválidas são ignoradas pelo
   browser), e templates 100% legados (conta, blog, contato) que não têm
   fixture. Uma feature que depende disso é validada no real.

6. **Segundo alvo: a loja de dev.** `https://democamisetasromadev.lojavirtualnuvem.com.br/`
   é o ambiente real sem clientes. A suíte é escrita por página lógica e roda
   também lá (`ROMA_STORE_URL=… npx playwright test --project=real-*`); os
   testes que dependem das fixtures se auto-pulam. A Nuvemshop está atrás de
   um challenge do Cloudflare que bloqueia IPs de datacenter — o alvo real só
   roda de uma estação de trabalho (headed), nunca do Claude Code na nuvem.
   Isso mantém o preview local como loop de desenvolvimento da IA e o real
   como validação humana (ou de CI com IP permitido, se um dia existir).

## Consequências

- A IA tem loop: muda → `npm test` → screenshot → ajusta, sem FTP.
- O contrato `js-*` template↔JS passa a ser testado de verdade, porque o
  HTML vem dos templates, não de fixture manual.
- Nova página/seção custom exige fixture (`fixtures/pages.mjs`) — é parte
  do escopo da spec que a cria.
- `devDependencies` ganham `twig`, `playwright`, `@playwright/test`
  (Chromium vem do cache do Playwright; sem download no repo).
- Dívidas conhecidas do renderer, para fechar sob demanda: `paginate`
  ignorado (fixture já vem fatiada); `attribute()`/`#{}` dependem do twig.js;
  `shuffle` é aleatório (screenshots do carrossel de relacionados variam);
  o shim de `product.get_max_installments` é por regex.
- RISK 6 do contrato deixa de ser "zero testes" e passa a ser "testes só na
  camada custom; plataforma validada manualmente".

## Referências

- `tools/preview/README.md` — como rodar e como adicionar fixture.
- `playwright.config.mjs`, `tests/`, `scripts/lint-styles.mjs`.
- `docs/architecture-map.md` RISK 6, A12, D1.
- Pesquisa de viabilidade (2026-10-12) resumida no Contexto acima.
