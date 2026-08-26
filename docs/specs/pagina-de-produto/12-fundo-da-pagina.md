---
feature: pagina-de-produto
spec: 12-fundo-da-pagina
status: done
depends_on: ["01-fundacao-layout-e-preco"]
---

<!-- Pedido do usuário em 2026-08-18, durante a validação da PDP no preview:
"a página de produto pode pegar a cor de fundo principal também".

Marcada `done` em 2026-08-20 por decisão do usuário, junto com a spec 11,
depois do deploy manual via FTP para o preview real. A confirmação
explícita dele foi sobre a barra mobile (spec 11); o fundo da página subiu
no mesmo deploy e foi aceito na mesma rodada. Se aparecer faixa branca em
produção, tratar como bug novo, não reabrindo esta spec. Não exigiu build —
o utilitário `bg-bg` já estava em `static/css/app.tpl:1762`. -->

## Objetivo

Fazer a PDP renderizar sobre a cor de fundo principal do tema
(`--background-color`, `#FFFFF6` na variante Romã) em vez do branco padrão
do navegador, como já acontece na categoria.

## Contexto

`body` não define `background-color` em lugar nenhum do tema — a única
regra de `body` está em `static/css/style-critical.tpl:103` e só traz
`margin` e `font-size`. Por isso cada página pinta o próprio fundo:
`templates/category.tpl` faz isso nas linhas 61 e 257
(`style="background-color: var(--background-color)"` por seção).
`templates/product.tpl` não pinta nada, então a PDP inteira cai no branco
do navegador.

## Escopo

- `templates/product.tpl` — aplicar o fundo do tema cobrindo **toda** a
  página, incluindo a seção de relacionados que fica fora de
  `#single-product`.
- Proibido nesta spec:
  - `snipplets/product/product-related.tpl` — fora de escopo em toda esta
    feature (spec 09 adiada). Envolver o `{% include %}` em
    `product.tpl` é permitido; editar o arquivo não.
  - `static/css/style-critical.tpl` e demais SCSS de plataforma (F1/A4) —
    não adicionar `background-color` no `body` por lá.
  - Qualquer outro template de página (home, categoria, carrinho): esta
    spec é só da PDP.

## Critérios de aceite

- [ ] A PDP inteira renderiza sobre `--background-color`: área do produto,
      seção de relacionados e qualquer espaço entre elas. Nenhuma faixa
      branca visível entre seções nem abaixo da última, em mobile e desktop.
- [ ] Usar o token Tailwind `bg-bg` (que já mapeia
      `--color-bg: var(--background-color)` no `@theme` de `app.css`), e
      **não** repetir o `style="background-color: var(--background-color)"`
      inline da categoria — o inline lá é resíduo, não padrão a seguir
      (A8/F4: a cor vem do token, nunca hardcoded).
- [ ] Trocar a cor de fundo no admin da Nuvemshop muda o fundo da PDP junto,
      sem nenhum ajuste de código.
- [ ] Nenhuma mudança de layout, espaçamento ou de qualquer outra cor.
- [ ] Não requer `npm run build` (nada em `__src/` muda) — se por algum
      motivo `app.css` for tocado, aí sim rodar `npm run build`.

## Invariantes aplicáveis

- A8/F4 — cor de tema sempre via token/variável, nunca hex.
- F1/A4 — SCSS de plataforma não é editado.

## Referências de padrão

- `templates/category.tpl:61` e `:257` — o precedente de "cada página pinta
  o próprio fundo" (o *o quê*; o *como* aqui é `bg-bg`, não inline style).
- `__src/css/app.css`, bloco `@theme` — `--color-bg: var(--background-color)`,
  o token que expõe `bg-bg` ao Tailwind.
