# Preview local

Renderiza os templates da Nuvemshop localmente (twig.js + stubs da
plataforma) para que a camada custom (Tailwind + `__src/js`) possa ser vista e
testada num browser real sem publicar no FTP. Decisão e limites em
[`docs/adr/0014-stack-de-teste-local.md`](../../docs/adr/0014-stack-de-teste-local.md).

```bash
npm run preview          # http://localhost:4321  (home.html, product.html, category.html)
npm run preview:build    # só gera .preview/*.html
npm test                 # Playwright (sobe o servidor sozinho), mobile + desktop
npm run test:ui          # Playwright UI
npm run lint:styles      # guard do ADR-0003 (cores hardcoded)
```

Depois de mudar `__src/`, rode `npm run build` antes — o preview serve o que
está em `static/`, como a loja.

## Estrutura

| Arquivo | Papel |
|---|---|
| `engine.mjs` | twig.js: loader com pré-processamento das tags da plataforma, filtros e funções Nuvemshop (stubs) |
| `translations.mjs` | lê `config/translations.txt` (chave `es` → `pt`) |
| `platform-head.mjs` | o que `{% head_content %}` injetaria: CSS vars das settings, `LS` stub, `jQueryNuvem` no-op |
| `fixtures/settings.mjs` | `config/defaults.txt` + paleta real + seções da home + imagens "enviadas" |
| `fixtures/catalog.mjs` | fábrica de produtos (`variants_object` no formato que o JS lê), seções, menu, filtros |
| `fixtures/pages.mjs` | contexto completo de cada página (`home`, `product`, `category`) |
| `build.mjs` | renderiza para `.preview/<page>.html` |
| `serve.mjs` | servidor dev: re-renderiza a cada request, serve `static/`, placeholders SVG, stubs de endpoint |

## Adicionar uma página ou seção

1. Crie o contexto em `fixtures/pages.mjs` (copie o mais parecido). Variáveis
   que o template lê e não existem renderizam vazio — sem erro — então
   confira o HTML gerado.
2. Se o template usa um filtro/função da plataforma que ainda não está em
   `engine.mjs`, adicione um stub honesto (nunca faça o stub "fingir" lógica
   da plataforma que você não conhece).
3. Escreva um teste em `tests/` cobrindo o que a spec promete.

## O que o preview não reproduz

`component()` (parcelas, promoções, placeholders de ajuda), `money`/`translate`
reais, a camada jQuery legada (`store.js.tpl` — `LS.ready` fica pendente de
propósito), `style-async.scss.tpl` compilado, templates 100% legados sem
fixture. Isso continua sendo validado no preview real da Nuvemshop.

## Erros comuns

- **`Unable to find filter X`** — adicione em `engine.mjs` (`filters`).
- **`CreateListFromArrayLike called on non-object`** — twig.js não parseia
  objeto aninhado em argumento de função nem método acessado como
  propriedade; veja os shims no `prePass`.
- **`Swiper is not defined` só numa página** — um `{{ var }}` vazio dentro de
  `store.js.tpl` virou erro de sintaxe no bloco inline e matou o script
  vendorado. Rode `node --check` no script extraído de `.preview/<page>.html`.

## Rodar a mesma suíte contra a loja de dev

A loja de dev (`https://democamisetasromadev.lojavirtualnuvem.com.br/`) é o
alvo "real". Os testes são escritos por página lógica (`home`, `product`,
`category`) e rodam nos dois alvos; os que dependem das fixtures (paleta,
itens do carrinho) se auto-pulam no real.

```bash
ROMA_STORE_URL=https://democamisetasromadev.lojavirtualnuvem.com.br \
ROMA_PRODUCT_PATH=/produtos/<slug-de-um-produto>/ \
ROMA_CATEGORY_PATH=/<slug-de-uma-categoria>/ \
npx playwright test --project=real-desktop --project=real-mobile --headed
```

A Nuvemshop fica atrás de um challenge do Cloudflare: **bloqueia IPs de
datacenter** (o Claude Code na nuvem não consegue) e às vezes headless. Rode
de uma estação de trabalho, com `--headed`; se aparecer "Just a moment…", o
helper falha com uma mensagem explícita em vez de um timeout.
