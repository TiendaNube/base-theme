# ADR-0006 — Contrato de módulos: exports nomeados, guard de DOM, `window.*`, `js-*`/`data-*`

- **Status:** Aceito
- **Data:** 2026-02-02 a 2026-03-01 (padrão emergiu com `c744b4d`, `eab742e`, `b2fc3d4`); formalizado em 2026-10-12
- **Decisores:** Caio Marques

## Contexto

Um único bundle serve todas as páginas (ADR-0007). Módulos de home, categoria
e produto são carregados em toda página, então precisam saber quando não
agir. Módulos também precisam se falar (abrir carrinho a partir do toast,
reinicializar quickbuy depois do infinite scroll) sem virar um grafo de
imports. E o JS precisa de um vínculo com o template que não se confunda com
estilo.

## Decisão

1. **Um módulo = uma função nomeada exportada**, importada e invocada
   explicitamente em `index.js`, agrupada por contexto (`//System`,
   `//Home`, `//Category`, `//Product`). Sem default export, sem import com
   efeito colateral, sem auto-execução.
2. **Primeira instrução é o guard do DOM raiz** (`if (!el) return;`). Página
   sem o markup → módulo é no-op.
3. **Sem import entre módulos irmãos.** Comunicação só por `window.*`:
   provedor define `window.fn = …`, consumidor chama `window.fn?.()`. Todo
   global entra no registro A5/S2 do contrato.
4. **`js-*` é o contrato template↔JS** (seletor), nunca estilo. **`data-*`**
   carrega dado e estado. Renomear um exige mudar o outro lado.
5. **Estado de UI, nesta ordem de preferência:** `hidden` → `data-state`
   (com CSS em `app.css`) → `aria-expanded` → toggle de classe → `el.style`
   só para valor computado em runtime.
6. Após inserir HTML com `<i data-lucide>`, chamar `lucide.createIcons()`
   com guard `typeof lucide !== "undefined"`.

## Consequências

- O bundle é previsível e testável: cada módulo pode ser exercitado numa
  página que só tem o seu markup (ADR-0014).
- O registro de `js-*`, `window.*` e estado no contrato é exaustivo e precisa
  ser mantido — é o custo de não ter tipagem.
- Exceções documentadas, não precedentes: `product-add-to-cart.js` guarda em
  `#product_form` (id renderizado pela plataforma); `product-accordion.js`
  guarda em NodeList.

## Referências

- `docs/architecture-map.md` A2, A3, A5, A6, A9, S1–S3, R1, R3, F6, F9.
