# ADR-0010 — Fronteira com `LS.*`: delegar ao legado, exceto carrinho e PDP

- **Status:** Aceito
- **Data:** 2026-03-11 (`e37ce19`, cart drawer) e 2026-08-17 (`5288aed`, PDP); formalizado em 2026-10-12
- **Decisores:** Caio Marques

## Contexto

`LS.*` é a API JS da plataforma, injetada por `{% head_content %}` e
acoplada ao jQuery. A regra geral (ADR-0005) é não chamá-la do custom. Dois
casos forçaram exceções explícitas:

- **Carrinho.** Mutar o carrinho (`LS.addItem`, `LS.removeItem`) é API
  stateful da plataforma sem alternativa de delegação via binding jQuery.
- **PDP.** O fluxo legado de variantes (`LS.changeVariant`,
  `registerOnChangeVariant`, `<select>` por variação) não se encaixava no
  design da nova página. O custom assumiu a seleção.

## Decisão

1. **Regra:** custom JS não chama `LS.*`. O que a plataforma já faz via
   jQuery (busca AJAX com `LS.search`) é delegado, não duplicado.
2. **Exceção 1 — módulos de carrinho** (`cart-drawer.js`,
   `item-card-quickbuy.js`) podem chamar `LS.addItem` / `LS.removeItem`.
3. **Exceção 2 — PDP é dona das variantes.** `product-variants.js` lê
   `variants_object` do template e atualiza preço, galeria e botão sozinho.
   `LS.changeVariant` **não** é chamado. Trade-off aceito: `installments` e
   `promotions-details` ficam renderizados para a variante padrão e não
   recalculam. Não "corrigir" reintroduzindo o legado.
4. **`fetch` em duas formas apenas:** GET de página renderizada para
   paginação (parse por `DOMParser`), e POST do `action` do próprio form
   (`#product_form`) com `X-Requested-With`. Sem endpoint ou payload
   hardcoded; sucesso por `res.ok`; estado do carrinho via
   `window.onCartUpdate?.()`.
5. Nova integração com a plataforma fora disso entra em `store.js.tpl` e é
   exposta por `window.*`.

## Consequências

- O preview local (ADR-0014) precisa só de um stub mínimo de `LS` (ready
  pendente + funções gravadoras) para a camada custom bootar.
- O `#product_form` por id e a classe `.js-addtocart` deliberadamente não
  usada (evita o double-fire de `store.js.tpl:1724`) são detalhes que
  precisam continuar documentados no contrato.

## Referências

- `docs/architecture-map.md` D1, D2, L6, nota "PDP variant selection".
- `docs/architecture-drift-reports/20260314-drift-audit.md` (relaxamento formal de D1/L6).
- `docs/specs/pagina-de-produto/plan.md` (riscos) e spec 04.
