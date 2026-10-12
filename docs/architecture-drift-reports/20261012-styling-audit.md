# ARCHITECTURE DRIFT AUDIT — ESTILIZAÇÃO

**Data:** 2026-10-12
**Branch:** master
**Auditor:** Claude Code (Fable 5.1, com agentes Sonnet 5.5 de varredura)
**Escopo:** decisões de estilização (Tailwind v4, tokens, cores do tema) — invariantes A8, T2, F4, L1, F3, R4 de `docs/architecture-map.md`

---

## Resumo

Auditoria focada em estilização. Foram encontradas 8 violações reais de cores hardcoded (3 grupos de arquivos), 13 casos ambíguos que expõem uma lacuna na regra (sem política para constantes de marca além de `--color-highlight`, nem para a opção "white" do admin) e várias derivas de consistência em relação a tokens que já existem. A maior parte das violações vem do scaffolding inicial (jan–mar/2026), anterior ao commit do contrato (`d9172b1`, 2026-07-31). O trabalho spec-driven do PDP foi o mais disciplinado com tokens.

As correções ao contrato e as decisões de política estão sendo registradas em `docs/adr/` (ADR-0003 cores e tokens, ADR-0004 CSS custom e estilos inline) — ver `docs/adr/`. As 8 correções (a) são a feature de validação da nova stack de testes. Este relatório **não** altera `architecture-map.md`.

---

## Tabela de classificação de invariantes

| Invariante | Descrição | Status | Observação |
|------------|-----------|--------|------------|
| **A8 / T2 / F4** | Cadeia de cores do tema, sem cores hardcoded | DRIFTED | 8 bugs remanescentes; 13 ambíguos mostram lacuna na regra (sem política para constantes de marca além de `--color-highlight`, nem para a opção "white" do admin). A lista de known bugs em A8 está incompleta: falta `home-vip-group.tpl` (`#FFFFF6`) |
| **L1 / F3** | Regras de biblioteca (Tailwind v4 sem config, sem importar libs) | VALID | — |
| **R4** | Registro de seletores `js-*` usados em CSS | VALID, redação FRACA | Lista os `js-*` como registro permitido, mas na prática são ganchos de estilo |

---

## Fato estrutural: camada Bootstrap removida

A camada bootstrap/helpers foi removida no commit `c0bea4c` (2026-01-25, "build: remove bootstrap and helpers layers from project"). As classes `row`, `col-*`, `no-gutters`, `d-none`, `d-block`, `btn-primary`, `alert-*`, `form-control`, `position-relative` e `float-*` **não estão definidas em nenhum CSS do repo** (verificado em `static/css/style-critical.tpl`, `style-async.scss.tpl` e `app.tpl`). Templates que ainda as usam ficam, na prática, sem estilo.

- ~167 tokens de classe distintos sem definição.
- Sobrevivem apenas em style-critical/style-async: `.btn`, `.alert`, `.textbanner`, `.swiper-*`, `.h5`, `.fade-in`, `.label`, `.btn-whatsapp`, `.btn-transition`.

---

## (a) Violações reais — 8

| # | Arquivo:linha | Problema | Correção sugerida |
|---|---------------|----------|-------------------|
| 1 | `__src/js/modules/home/product-carousel.js:18` | fallback `"#410911"` | usar token/variável do tema |
| 2 | `__src/js/modules/home/product-carousel.js:19` | `const inactiveColor = "#C4C4C0"` | `color-mix(in srgb, var(--text-color) 40%, transparent)`, padrão dos irmãos (`product-gallery.js:15`, `menu.js:84`) |
| 3 | `templates/category.tpl:91` | `[background:rgba(255,255,246,0.7)]` | `bg-bg/70` (já usado 3x em outros pontos) |
| 4 | `snipplets/home/home-product-carousel.tpl:50` | idem | `bg-bg/70` |
| 5–8 | `snipplets/home/home-vip-group.tpl:106-109` | quatro `fill="#FFFFF6"` nos paths do logo "4 seeds" | `fill="currentColor"` em pai com `text-bg`, ou `var(--background-color)` |

Notas:
- `#FFFFF6` é o default do fundo do tema, não branco. Por isso a troca correta é `bg-bg/70`, e não `bg-white/70`.
- Itens 1–2 e 3–4 são known bugs listados em A8 desde `9d8d16a` (2026-02-02) / `2cfdeca` e nunca corrigidos. Os itens 5–8 **não** estão na lista de known bugs.

---

## (c) Ambíguos — 13, precisam de política

| Grupo | Ocorrências | Local | Dúvida |
|-------|-------------|-------|--------|
| `text-red-600` | ×6 | `snipplets/product/product-shipping-calculator.tpl:33,51,52` (erros); `snipplets/header/header-new.tpl:82,93`; `snipplets/navigation/menu-accordion.tpl:52` (item de menu destacado) | Não existe token de "danger"/"highlighted"; `--color-highlight` é verde |
| "white" da opção do admin como literal | ×2 | `snipplets/home/home-promo-marquee.tpl:30` (`'white': '#FFFFFF'`), `:37` (`default('#FFFFFF')`) | Literal espelha uma opção de admin |
| idem em JS | ×2 | `__src/js/modules/home/hero-banner-2-carousel.js:25,30` (`#FFFFFF`) | idem |
| `text-white` | ×3 | `snipplets/home/hero-banner-2-slide.tpl:9`; `snipplets/home/home-hero-banner.tpl:16` (set `text_color_class`); `snipplets/product/product-gallery-modal.tpl:6` (botão fechar sobre backdrop escuro) | Depende de a política tratar "branco sobre mídia/escuro" como permitido |

---

## (b) Exceções permitidas — informativo

- `text-white` sobre gradiente/overlay preto próprio: `menu-carousel.tpl:77`; `home-vip-group.tpl:72,79,86,97`.
- `bg-black/5|10|20` como fill de hover/active: ×21 — `category.tpl:93,99,126,141,155,185,198,227,269`; `menu-mobile.tpl:22,30`; `home-product-carousel.tpl:52,57,62`; `item-card.tpl:51`; `filters.tpl:13,51,59`; `categories.tpl:11`; `menu.js:52,54`.
- `border-black/10`: ×3 — `product-accordions.tpl:6,22`; `product-variants.tpl:17`.
- `bg-black/30|35` (backdrops): ×6. `bg-white/*`: ×4.
- JS com rgba: `rgba(0,0,0,0.05/0.15)` em `item-card-quickbuy.js:96,99,242,264,269` e `toast.js:49`; `rgba(255,255,255,*)` em `hero-banner-2-carousel.js:33,36` e `product-gallery-zoom.js:15`.

---

## Deriva de consistência (não é violação)

### Fill de controle repetido em vez do token existente

| Padrão | Qtd. | Local |
|--------|------|-------|
| `[background:rgba(0,0,0,0.05)]` | ×18 | `templates/category.tpl:78,112,155,172,198,227,269`; `snipplets/grid/item-card.tpl:18,23,44,63,76,84,96`; `snipplets/grid/filters.tpl:13,59`; `snipplets/grid/categories.tpl:11`; `snipplets/home/home-product-carousel.tpl:37` |
| `rgba(0,0,0,0.12)` | ×1 | `filters.tpl:51` |
| `rgba(0,0,0,0.15)` | ×1 | `item-card.tpl:84` |
| `rgba(255,255,255,0.30)` | ×1 | `home-vip-group.tpl:97` |

O token `--color-control` (`bg-control`, = `color-mix(--text-color 5%, transparent)`) foi criado na feature do PDP (`5288aed`) exatamente para essa intenção e já é usado 8x. O quickbuy JS do item-card espelha o mesmo rgba em `item-card-quickbuy.js`. Atenção: `bg-control` ≠ `rgba(0,0,0,.05)` quando `--text-color` não é preto, então unificar é decisão de design.

### Variáveis cruas da plataforma onde há token

- `toast.js:86-137`: `color:var(--primary-color)` / `var(--text-color)`.
- `modal.js:84-89`.
- `templates/category.tpl:61,257`: `style="background-color: var(--background-color)"` (-> `bg-bg`).
- `templates/category.tpl:246`: `color-mix` inline (-> `bg-bg/80`).

### Tamanhos arbitrários recorrentes (candidatos a token)

`leading-[80%]`, `leading-[100%]`, `leading-[120%]`, `text-[10px]`, `text-[13px]`, `text-[32px]` — ~61 ocorrências no total: `product-form.tpl` ×17, `product-sticky-buy-bar.tpl` ×9, `item-card.tpl` ×6, `menu-accordion.tpl` ×5, `category.tpl` ×4, `home-faq.tpl` ×4, `home-vip-group.tpl` ×3, entre outros. Px fracionados: `h-[596.4px]` e `h-[819.2px]` nos hero banners.

---

## Estilos inline

**134 atributos `style=` em 50 arquivos.**

| Categoria | Qtd. | Detalhe |
|-----------|------|---------|
| Dinâmicos / legítimos (valores Twig) | 15 | largura de progresso, hex de swatch, vars mapeadas do admin |
| Estáticos que deveriam ser Tailwind | 6 | `snipplets/notification/modal.tpl:1` (`fixed inset-0 flex ... z-(--z-modal)`); `snipplets/notification/toast.tpl:1`; `templates/category.tpl:61,257` (`bg-bg`); `category.tpl:246`; `menu-carousel.tpl:69` (`w-auto`) |
| `display:none` / `inline-block` como estado inicial alternado por JS | 113 | ver abaixo |

Os 113 são alternados via `el.style.display` em `product-variants.js:59,66`, `cart-drawer.js:185,192,429-436`, `item-card-quickbuy.js:278,289`, `search.js:61`, `menu.js:131`, `product-add-to-cart.js:20,24`, além de ~119 pontos de show/hide jQuery no legado `store.js.tpl`. Não dá para trocar por `hidden` sem migrar o JS. Maiores concentrações: `snipplets/cart-totals.tpl` ×24 e `product-form.tpl` ×10.

### Blocos `<style>`

7 blocos em `layouts/layout.tpl:30,43,62` e `password.tpl:22,36,39,54`. Todos são wrappers de injeção (componente de fontes, include de style-critical, include de app.tpl, `settings.css_code`); **zero CSS autoral**. `password.tpl` duplica o head do layout.

---

## `app.css`

- Único `@apply h-4.5` em `app.css:313` (`.powered-by-wrapper svg`) — evitável.
- Seletores `js-*` usados como ganchos de estilo simples (sem `data-state`/`aria`):
  - `.js-search-panel` / `.js-search-input` (126-142)
  - `.js-gaius-modal-overlay` / `-content` / `-drawer` / `-body` (183-245)
  - `.js-price-filter-wrapper` (251-300)
  - `.js-menu-carousel` (370)
  - `.js-cart-drawer-backdrop` / `-panel` / `-footer`, `.js-ajax-cart-list`, `.js-cart-input-spinner` (390-430)
  - `.js-product-gallery-zoom-backdrop` / `-content` (463-469)
  - `.js-product-sticky-buy-bar` + descendentes (489-532)
  - `body.template-product .js-footer` (526)

  R4 lista esses seletores como registro permitido, então não é drift contra o contrato; ainda assim é "js-* usado para estilização", o que enfraquece a redação de R4.

---

## Histórico

- As violações vêm do scaffolding inicial (jan–mar/2026: `9d8d16a`, `30d6525`, `2cfdeca`, `c744b4d`), antes do contrato (`d9172b1`, 2026-07-31).
- O trabalho spec-driven do PDP (`5288aed`, 2026-08-17; `21cc54d`; `a3ae1e5`) foi o mais disciplinado: a spec 11 recusou o `#80807b` do Figma e criou `--color-control` / `--color-highlight`. Desvios pequenos: `text-red-600` ×3, `text-white` ×1 e `[background:rgba(0,0,0,0.05)]` repetido nas specs 05/06, mesmo elas tendo criado `bg-control`.
- Snipplets flat legados na raiz: 23 arquivos (o CLAUDE.md diz "um punhado"), mais `snipplets/.DS_Store` perdido e diretório `snipplets/footer/` vazio.

---

## Ação

- Correções ao contrato e decisões de política (danger/highlight, "white" do admin, fill de controle, tokens tipográficos, estilos inline) estão sendo registradas em `docs/adr/`: **ADR-0003** (cores e tokens) e **ADR-0004** (CSS custom e estilos inline). Ver `docs/adr/`.
- As 8 correções da seção (a) são a feature de validação da nova stack de testes.
- `docs/architecture-map.md` não foi modificado por esta auditoria.

---

## Totais

- Invariantes: A8/T2/F4 DRIFTED; L1/F3 VALID; R4 VALID (redação fraca).
- Violações reais (a): **8** (2 em `product-carousel.js`, 2 em templates de `rgba(255,255,246,.7)`, 4 em `home-vip-group.tpl`).
- Ambíguos (c): **13** (6 `text-red-600`, 4 literais "white", 3 `text-white`).
- Exceções permitidas (b): informativas, sem ação.
- Deriva de consistência: 18 `rgba(0,0,0,0.05)` + 3 rgba avulsos, 4 usos de vars cruas, ~61 tamanhos arbitrários.
- Estilos inline: 134 em 50 arquivos (15 legítimos, 6 migráveis, 113 de toggle JS); 7 blocos `<style>` sem CSS autoral.
- Classes Bootstrap sem definição: ~167 tokens distintos.
- `app.css`: 1 `@apply` evitável; seletores `js-*` como gancho de estilo em ~8 grupos.

---

## Adendo — achados durante a correção (mesmo dia)

Encontrados ao escrever os testes de regressão da stack local (ADR-0014):

1. **Destaque de item de menu no header desktop nunca funcionou.** A classe
   condicional (`text-red-600`, agora `text-fg`) em `snipplets/header/header-new.tpl`
   é vencida pela regra de estado do header em `app.css`
   (`.js-new-header[data-state="transparent"|"active"] .nav-link { color: … }`,
   especificidade 0,3,0 contra 0,1,0 do utilitário). O destaque só aparece no
   menu mobile (`menu-accordion.tpl`). Não corrigido aqui — é decisão de design
   (o destaque deve sobreviver ao estado transparente sobre imagem?) e vai para
   uma spec; registrado como dívida em ADR-0004 §2 (js-* em app.css).
2. **twig.js (preview) e nested ternary.** `a ? b ? 'x' : 'y' : 'z'` é avaliado
   errado pelo twig.js; o preview parentiza no pré-processamento. A plataforma
   avalia certo. Três ocorrências (`product-sticky-buy-bar.tpl:16`,
   `grid/item.tpl:109,166`) — vale parentizar no template também por legibilidade.
3. **`bg-bg/70` compila para `color-mix(in oklab …)`** no Tailwind v4; o valor
   computado no browser é `oklab(… / 0.7)`, não `rgba`. Irrelevante para o
   usuário, relevante para quem escreve asserções de cor nos testes.

## Correções aplicadas (2026-10-12)

| Arquivo | Antes | Depois |
|---|---|---|
| `__src/css/app.css` | — | `--color-danger: #dc2626` no `@theme` |
| `__src/js/modules/home/product-carousel.js:17-19` | `"#410911"` fallback, `"#C4C4C0"` | `var(--text-color)`, `color-mix(in srgb, var(--text-color) 40%, transparent)` |
| `templates/category.tpl:91` | `[background:rgba(255,255,246,0.7)]` | `bg-bg/70` |
| `snipplets/home/home-product-carousel.tpl:50` | idem | `bg-bg/70` |
| `snipplets/home/home-vip-group.tpl:104-109` | `fill="#FFFFF6"` ×4 | `fill="currentColor"` + `text-bg` no wrapper |
| `snipplets/product/product-shipping-calculator.tpl:33,51,52` | `text-red-600` | `text-danger` |
| `snipplets/header/header-new.tpl:82,93`, `menu-accordion.tpl:52` | `text-red-600` | `text-fg` |
| `snipplets/home/home-promo-marquee.tpl` | `'#FFFFFF'` ×2 | `admin_white` em uma linha marcada `lint-styles: allow admin-white` |
| `hero-banner-2-carousel.js`, `hero-banner-2-slide.tpl`, `home-hero-banner.tpl` | `#FFFFFF` / `text-white` (opção "branco") | mantidos, marcados `lint-styles: allow admin-white` |
| `home-vip-group.tpl`, `menu-carousel.tpl`, `product-gallery-modal.tpl` | `text-white` sobre overlay preto | mantidos, marcados `lint-styles: allow overlay` |

`npm run lint:styles` passa com 0 violações; `tests/theme-colors.spec.mjs` cobre
cada correção no preview local em mobile e desktop.
