---
feature: pagina-de-produto
spec: 11-barra-de-compra-mobile
status: done
depends_on: ["07-barra-fixa-de-compra"]
---

<!-- Nasceu da validação da spec 07 no preview real (2026-08-18): o desktop
foi aprovado, mas no mobile a barra fixa ficou com ~250px (~38% do viewport
de um iPhone). Ao conferir o Figma, descobriu-se que a altura não era o
problema em si — o `addCartContainer` real tem 116px e a implementação da
spec 07 desviou do layout desenhado. Esta spec traz a barra mobile de volta
para o Figma.

VALIDADA no preview real da Nuvemshop em 2026-08-20 (deploy manual via
FTP a partir da branch `feat/pdp-barra-mobile-e-fundo`): o usuário aprovou
a barra mobile. Os critérios visuais abaixo seguem com as caixas
desmarcadas, mesma convenção das outras specs `done` desta feature — o
`status` é o registro da aprovação. -->

## Objetivo

Reimplementar a barra fixa de compra do mobile fiel ao Figma
`addCartContainer` (node `52:1686`, 393×116) — preço + badges à esquerda,
botão "Comprar" auto-width à direita na mesma linha, barra de progresso
compacta embaixo — e corrigir a cor do botão para o mesmo `bg-secondary` do
checkout do cart drawer. **O layout do desktop (`lg:`+) não muda**; a única
alteração que atinge o desktop é a cor do botão.

## O que está errado hoje (spec 07 vs Figma `52:1686`)

| | Figma | Implementado |
|---|---|---|
| botão | auto-width, à direita, na mesma linha do preço; `bg` `#410911` | linha própria, `w-full`; `bg-fg` (`#CB2C30`) |
| preço | `18px` extrabold | `text-2xl` (24px) |
| preço riscado | `12px` medium | `text-base` (16px) |
| badges | texto `10px` verde-limão, separados por bolinha de 4px | pills `bg-control`, `text-xs`, em linha própria |
| label do progresso | centralizado, `12px`, verde-limão, sem ícone | à esquerda, `text-secondary`, com ícone Lucide à direita |
| container | `px-6 py-4`, `gap-y-3`, `border-t`, `backdrop-blur-[8px]` | `p-4`, `gap-3`, sem borda, `blur(0.75rem)` |
| altura | 116px | ~250px |

## Escopo

- `snipplets/product/product-sticky-buy-bar.tpl` — reestruturação do markup
  mobile.
- `__src/css/app.css` — seção `PRODUCT STICKY BUY BAR STYLES`: ajuste do
  blur, override PDP-scoped das barras de progresso e espaçador de rodapé.
- Proibido nesta spec:
  - `snipplets/cart/cart-drawer-progress-bars.tpl` — compartilhado com o
    cart drawer. O visual do Figma é obtido por **CSS escopado à PDP**, não
    editando o snipplet.
  - `__src/js/modules/product/product-add-to-cart.js` e
    `__src/js/modules/system/cart-drawer.js` — nenhuma mudança de
    comportamento.
  - `snipplets/product/product-form.tpl` — o ponto do include não muda.
  - Qualquer mudança de **layout** no desktop (a cor do botão é a única
    exceção, ver abaixo).

## Medidas do Figma (node `52:1686`)

Container `addCartContainer`:

- `px-[24px] py-[16px]` → `px-6 py-4`
- `flex flex-wrap gap-y-[12px] items-center justify-between` → duas linhas
  com 12px entre elas (`flex flex-col gap-3` resolve igual)
- `backdrop-blur-[8px]` → `blur(0.5rem)` (hoje está `0.75rem`)
- fundo `rgba(255,255,246,0.85)` → **manter** `color-mix(in srgb,
  var(--background-color) 85%, transparent)`; `#FFFFF6` é justamente o
  `background_color` do tema, então o `color-mix` já reproduz o Figma sem
  hardcode (A8/F4)
- `border-t` sólida `#80807b`

`priceInfosContainer` (`flex items-center justify-between w-full`):

- coluna esquerda `flex flex-col gap-1`:
  - linha de preço `flex gap-1 items-start`:
    - preço: `18px` / extrabold / `leading-[1.2]` / `#410911`
      → `text-lg font-extrabold leading-[120%] text-secondary`
    - preço riscado: `12px` / medium / `leading-[1.2]` / `#80807b`
      → `text-xs font-medium leading-[120%]`, mantendo o risco por
      `<span>` absoluto como já é feito hoje
  - linha de badges `flex gap-[13px] items-center`:
    - cada badge: `10px` / medium / `leading-[1.2]` / `#2dcc57`
      → `text-[0.625rem] font-medium leading-[120%] text-highlight`
      (`--color-highlight: #2dcc57` **já existe** no `@theme` de
      `app.css` — é o verde-limão do design system; usar o token, nunca o
      hex)
    - separador: bolinha de 4px entre os dois badges → `<span class="size-1
      rounded-full bg-highlight">`, renderizada **somente** quando os dois
      badges existem
- botão (`14:1091`): `bg-[#410911] p-[8px] rounded-[8px]`, texto `16px` /
  semibold / `#fffff6` / `tracking-[0.08px]` / `leading-[1.5]`
  → `bg-secondary text-bg p-2 rounded-lg text-base font-semibold
  tracking-[0.08px] leading-[150%]`, largura automática (`shrink-0`, **sem**
  `w-full` no mobile). Altura resultante: 8+24+8 = 40px, o mesmo `h-10` de
  hoje.

`itensProgressContainer` (`flex flex-col gap-2 items-center`):

- trilho: `h-[6px] rounded-[6px] bg-[rgba(0,0,0,0.1)]` — equivale ao
  `h-1.5 rounded-full bg-secondary/10` que o snipplet compartilhado já usa
- preenchimento: `#2dcc57` — o snipplet usa `var(--accent-color)`; **não
  alterar**, é o comportamento já aprovado no cart drawer
- label: **centralizado**, `12px`, `leading-[1.5]`, verde-limão, números em
  extrabold, resto regular, **sem ícone**

## Decisões e desvios assumidos

1. **Duas barras de progresso, não uma.** O Figma desenhou só a de desconto
   progressivo, mas o projeto também tem a de frete grátis (`settings.
   cart_free_shipping_bar`), e remover uma delas é decisão de merchandising,
   fora do escopo desta spec. As duas continuam, no estilo compacto do
   Figma. Com as duas ativas a barra fica ≈160px; com só a de desconto,
   ≈116px (exatamente o Figma).
2. **Cor do botão muda também no desktop.** O Figma mobile usa `#410911`
   (= `text_color` do tema = `bg-secondary`), que é a mesma cor do botão de
   checkout do cart drawer (`cart-drawer.tpl:150`, `bg-secondary text-bg`).
   O desktop hoje usa `bg-fg` (`#CB2C30`) e foi aprovado sem que a cor
   fosse notada; manter dois vermelhos diferentes por breakpoint no mesmo
   botão seria pior. **É a única mudança desta spec que atinge o desktop —
   confirmar com o usuário na validação.**
3. **`#80807b` não é adotado literalmente.** É um cinza neutro que não sai
   de nenhuma cor do admin; usar o hex violaria A8/F4. Para o preço riscado
   manter `text-fg-muted` (já em uso) e para a borda superior usar
   `border-t border-secondary/20`. Se na validação a diferença incomodar,
   a saída correta é um token de marca novo no `@theme` (mesmo padrão do
   `--color-highlight`), nunca um hex solto no template.
4. **Estilo Figma das barras de progresso via CSS escopado.** O snipplet é
   compartilhado com o cart drawer, que continua com label à esquerda +
   ícone. Dentro da PDP, sobrescrever em `app.css` (algo como
   `.js-product-sticky-buy-bar .js-cart-progress-bar`): esconder o `<i
   data-lucide>`, centralizar o label, aplicar `--color-highlight`. Nenhuma
   alteração no HTML do snipplet, e `syncProgressBars` continua funcionando
   porque as classes e a estrutura não mudam.

## Critérios de aceite

- [ ] No mobile (< `lg:`) a barra reproduz o Figma `52:1686`: preço +
      preço riscado + badges verdes com bolinha à esquerda, botão "Comprar"
      auto-width à direita **na mesma linha do preço**, progresso embaixo.
      Altura ≈116px com uma barra de progresso ativa, ≈160px com as duas.
- [ ] Botão usa `bg-secondary text-bg` (mesma cor do
      `.js-cart-drawer-checkout`), em **ambos** os breakpoints.
- [ ] No mobile o botão é auto-width; em `lg:` continua ocupando a largura
      da coluna com o inset de 16px (Figma desktop `131:4254`: 532px dentro
      de 564px, que é o `lg:px-4` atual).
- [ ] Badges renderizam como texto `text-highlight` de 10px com bolinha
      separadora de 4px — sem `bg-control`, sem pill. A bolinha só aparece
      quando os dois badges existem (parcelamento **e** desconto pix).
- [ ] Label das barras de progresso, **apenas dentro da PDP**, fica
      centralizado, em `--color-highlight`, sem o ícone Lucide. No cart
      drawer o label continua à esquerda com o ícone — verificar as duas
      telas.
- [ ] Container: `px-6 py-4`, 12px entre as duas linhas, `border-t`
      derivada do tema, `backdrop-filter: blur(0.5rem)`, fundo por
      `color-mix` (A8/F4 — nenhum hex de cor de tema no template ou no CSS).
- [ ] Em `lg:`+ o **layout** é idêntico ao atual (mesma posição, mesmo
      espaçamento, botão em largura cheia, sem `fixed`, sem blur, sem
      fundo diferenciado). A única diferença aceitável no desktop é a cor
      do botão.
- [ ] Existe espaçador para a barra fixa não cobrir o fim da página:
      `padding-bottom` extra no `<footer class="js-footer">`, escopado a
      `body.template-product` e a `@media (max-width: 1023px)`. **Aplicar
      no rodapé, não no `body`** — o rodapé é `bg-secondary`, e um padding
      no `body` deixaria uma faixa da cor de fundo da página abaixo dele.
      Validar rolando até o fim da PDP no mobile.
- [ ] Contratos de classe preservados — `product-add-to-cart.js` consulta
      `.js-sticky-price-display`, `.js-sticky-compare-price-display` e
      `.js-product-sticky-buy-btn` (este último via
      `form.querySelector`, então precisa continuar **dentro** de
      `#product_form`); `cart-drawer.js` consulta `.js-cart-progress-bars`.
      Nenhuma dessas classes muda de nome ou sai do DOM do form.
- [ ] Add-to-cart continua como validado na spec 07: fetch, toast,
      cart-drawer, e as barras de progresso da PDP animando junto com as do
      drawer.
- [ ] Estados `cart`/`contact`/`nostock`/`catalog` do botão preservados,
      incluindo o `disabled` de `nostock` com o novo `bg-secondary`.
- [ ] `npm run build` executado sem erros (roda `pre-build.js` antes —
      nunca `node esbuild.config.mjs` direto).

## Invariantes aplicáveis

- A8/F4 — sem cor de tema hardcoded; `--color-highlight` é token existente,
  `#80807b`/`#410911`/`#FFFFF6` não entram como hex.
- R3/R4 — classes `js-*` são o contrato de binding template↔JS (R3) e os
  seletores que `app.css` usa para estilo dirigido por estado (R4); ver
  critério acima.
- A5/S2 — nenhum `window.*` novo.
- F1/A4 — `static/js/store.js.tpl` não é editado.
- L1 — Tailwind v4 configurado só pelo `@theme` de `__src/css/app.css`;
  `--color-highlight` já existe lá e é o token do verde-limão.
- F1/A4 — nada escrito à mão em `static/css/app.tpl` (é gerado).

## Referências de padrão

- **Figma node `52:1686`** (`addCartContainer`, mobile) — fonte das medidas
  acima; e **`131:4254`/`131:4155`** no node `131:1503` ("Desktop - 3") —
  confirmam que o desktop já está correto em layout.
- `snipplets/cart/cart-drawer.tpl:150` (`.js-cart-drawer-checkout`) — o
  botão de referência para a cor: `bg-secondary text-bg rounded-lg
  font-semibold`.
- `__src/css/app.css`, seção `PRODUCT STICKY BUY BAR STYLES` — padrão de
  como o componente troca de `fixed` para `static` em `@media (min-width:
  1024px)`; as regras novas seguem o mesmo formato e ficam na mesma seção.
- `snipplets/footer.tpl` — `.js-footer` é a âncora do espaçador.
