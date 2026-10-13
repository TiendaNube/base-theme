# Bateria de testes (Playwright, loja de dev)

Roda contra a loja de dev da Nuvemshop (ADR-0015). Não há renderer local nem
mock: cada teste abre a página real, com `component()`, `money`, `LS.*` e o
jQuery legado de verdade.

```bash
npm test                                         # desktop + mobile, headed
npx playwright test --project=desktop            # só um viewport
npx playwright test tests/product                # só um domínio
npx playwright test -g "quick buy"               # por nome
PW_HEADLESS=1 npx playwright test tests/smoke.spec.mjs   # só leitura (GET)
npx playwright show-report                       # relatório HTML da última execução
```

Headed é o padrão porque o Cloudflare da Nuvemshop responde 403 ao
`POST /comprar/` em Chromium headless; GETs passam. `PW_WORKERS` (padrão 3) e
`PW_RETRIES` (padrão 1) ajustam paralelismo e retentativas. Um teste marcado
como *flaky* no relatório passou só na retentativa: trate como sinal, não como
verde.

## Layout

Um arquivo por contexto, espelhando `__src/js/modules/<contexto>/` (ADR-0006):

```
tests/
  helpers.mjs              # PATHS/PRODUCTS da loja de dev, gotoStore, cart, variantes
  smoke.spec.mjs           # cada página sobe limpa, globais window.* registrados
  theme-colors.spec.mjs    # regressão das cores hardcoded (ADR-0003)
  usability.spec.mjs       # heurísticas: overflow, nomes acessíveis, alt, alvos de toque
  system/                  # header + menus, busca, cart drawer, toast + modal
  home/                    # seções novas da home (carrossel, hero 2, FAQ, grid, VIP)
  category/                # grid, ordenação, filtros, subcategorias, scroll infinito, quick buy
  product/                 # PDP (cobre as antigas specs 01–12, no histórico do git)
```

O que fica de fora, de propósito: `/cart` legado, página de busca (só smoke),
contas, contato, 404, seções legadas da home, "Leve junto" da PDP (spec 09
bloqueada). Ver seção B do inventário de 2026-10-12 nos drift reports.

## Convenções

- **Página lógica, não URL.** Use `gotoStore(page, "product")` e as chaves de
  `PATHS`; slugs são sobrescritos por `ROMA_*_PATH` no `.env`.
- **Dados vêm da página.** Estoque, preço e opções são lidos do JSON que a
  própria PDP/card serializa (`readVariants`, `.js-quickbuy-variants-data`).
  Nunca fixe um preço ou um tamanho no teste.
- **Pule em vez de fingir.** Se o catálogo não oferece o cenário (produto com
  uma foto só, loja sem tabela de medidas), `test.skip(cond, "motivo")`. Quando
  o cenário sumir de vez, troque o slug em `PRODUCTS`.
- **Dois viewports.** Vários componentes existem duas vezes no DOM (desktop e
  mobile). Use `visible(locator)` ou `isMobile(testInfo)`.
- **Carrinho.** Cada teste tem contexto novo, logo carrinho vazio. Os testes
  que adicionam fazem POST real; não assuma estado entre testes.
- **Bug conhecido = teste vermelho esperado.** Um bug confirmado e registrado
  no Fibery fica no teste com `test.fail(true, "Fibery #NNN — resumo")`. O
  teste descreve o comportamento certo; quando o bug for corrigido o Playwright
  acusa "expected to fail, but passed" e a anotação é removida. Nunca afrouxe o
  assert para passar.

## TDD numa task nova

1. Escreva o teste em `tests/<contexto>/` a partir dos critérios de aceite da
   task do Fibery, usando os `js-*` e `data-*` que o template vai expor.
2. Rode só ele (`-g` ou o caminho). Vermelho pelo motivo certo.
3. Implemente, `npm run build` se tocou `__src/`, suba para a loja de dev,
   rode de novo até ficar verde em desktop e mobile.
4. `npm run lint:styles` e a suíte inteira antes do `/pr`.
