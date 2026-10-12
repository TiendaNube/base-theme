# ADR-0003 — Cores do tema só via variáveis da plataforma e tokens `@theme`

- **Status:** Aceito
- **Data:** 2025-12-28 (cadeia de cores, `0c19db6`) / 2026-01-24 (tokens, `4dc3f70`); política completa em 2026-10-12
- **Decisores:** Caio Marques

## Contexto

O lojista escolhe as cores no admin. A plataforma injeta `--primary-color`,
`--text-color`, `--text-muted`, `--background-color` e `--accent-color` via
`style-colors.scss.tpl`; o `@theme` de `app.css` mapeia três delas para tokens
semânticos (`--color-bg`, `--color-fg`, `--color-secondary`, derivados
`--color-bg-subtle`, `--color-fg-muted`, `--color-control`). Qualquer cor
escrita "na mão" quebra quando o lojista troca a paleta — e a paleta atual
(fundo `#FFFFF6`, não branco) já expôs isso: `rgba(255,255,246,0.7)` em dois
templates e `#FFFFF6` no logo do VIP são o fundo do tema hardcoded.

A regra existia (A8/F4) mas tinha lacunas que a auditoria de 2026-10-12
mostrou: não dizia o que fazer com cores **de marca** fora do admin (o verde
`--color-highlight` foi a primeira), nem com a opção "branco" que o admin
escolhe em dropdowns de banner, nem com o vermelho de erro. Resultado: 8
violações reais e 13 casos ambíguos sem política.

## Decisão

1. **Cor dependente do tema nunca é literal.** Nos templates, `__src/js` e
   `app.css`, cor de tema entra só como classe de token (`bg-bg`, `text-fg`,
   `text-secondary`, `bg-control`, `text-fg-muted`) ou `var(--*-color)`.
   Preferir o token à variável crua quando o token existe.
2. **Constantes de marca vivem no `@theme`, e só lá.** São cores que o admin
   não controla e que o design define: `--color-highlight` (verde
   parcelamento/pix) e, a partir deste ADR, `--color-danger` (vermelho de
   erro de formulário — precisa ser vermelho em qualquer paleta). Um hex fora
   do `@theme` é violação mesmo que seja "a cor da marca". Nova constante
   exige ADR curto ou nota em spec. Item de menu em destaque **não** é
   constante: usa `text-fg` (o primary do tema, que na paleta da Roma é o
   vermelho `#CB2C30`).
3. **Overlays universais são a única exceção a literal.** `rgba(0,0,0,α)`,
   `rgba(255,255,255,α)`, `bg-black/N`, `bg-white/N`, `from-black/N` — preto
   e branco com opacidade, usados para contraste sobre imagem/backdrop. O
   fill de controles (`[background:rgba(0,0,0,0.05)]`) **não** é overlay: é
   `bg-control`.
4. **Opção "branco" escolhida pelo admin** (dropdowns de cor de texto dos
   hero banners e marquee) pode mapear para branco literal, porque é uma
   escolha explícita do lojista, não uma cor do tema. A linha recebe a marca
   `lint-styles: allow admin-white`. Texto branco sobre overlay preto próprio
   recebe `lint-styles: allow overlay`.
5. **Enforcement automático.** `npm run lint:styles`
   (`scripts/lint-styles.mjs`) falha o build em hex, rgb/rgba não-universal e
   classes de paleta Tailwind (`text-red-600`, `bg-gray-100`, `text-white`…)
   fora das exceções acima. Roda no `/implement-spec` e no `/pr`.

## Consequências

- Os 8 bugs de cor conhecidos são corrigidos como feature de validação da
  stack de testes (ADR-0014): `product-carousel.js` (`#410911`, `#C4C4C0`),
  `category.tpl:91` e `home-product-carousel.tpl:50` (`rgba(255,255,246,.7)`
  → `bg-bg/70`), `home-vip-group.tpl:106-109` (`#FFFFF6` → `currentColor`).
- `text-red-600` migra para `text-danger` nos 3 erros do calculador de frete
  e para `text-fg` nos 3 destaques de menu.
- `--color-control` passa a ser o único fill de controle. Migrar as 18
  ocorrências de `[background:rgba(0,0,0,0.05)]` (+ o espelho em
  `item-card-quickbuy.js`) é uma spec à parte — muda levemente o visual em
  paletas de texto não-preto, por design.
- A8/T2/F4 do contrato passam a referenciar este ADR e a lista de "known
  bugs" sai de lá quando os bugs forem fechados.
- Custo: o lint tem falsos positivos possíveis em casos novos; a válvula é a
  marca `lint-styles: allow <motivo>` na linha, que é auditável por grep.

## Referências

- `docs/architecture-map.md` A8, T2, F4.
- `docs/architecture-drift-reports/20261012-styling-audit.md`.
- `docs/specs/pagina-de-produto/11-*.md` (decisão de recusar `#80807b` do Figma).
- `scripts/lint-styles.mjs`.
