# ADR-0005 — Camada dual de JS: legado como referência, vanilla JS em `__src/`

- **Status:** Aceito
- **Data:** 2026-01-25 (`50081b6`); formalizado em 2026-10-12
- **Decisores:** Caio Marques

## Contexto

A plataforma entrega `static/js/store.js.tpl` (~100 KB de jQuery) e
`external*.js.tpl` (jQuery, Swiper 6, lazysizes…), carregados dentro de
`LS.ready.then()`. Esse código é da Nuvemshop, mal estruturado e difícil de
testar; estendê-lo significaria herdar jQuery para sempre. A filosofia
registrada à época: *"legado mal escrito, sempre reescrevemos melhor"*.

## Decisão

1. **Duas camadas, uma direção.** `store.js.tpl` e `external*.js.tpl` são
   *referência*: podem ser lidos para entender um comportamento da plataforma
   e podem ser editados só para atualizar vendor. Nunca recebem feature.
2. **Todo JS novo é vanilla, em `__src/js/modules/<contexto>/`**, bundlado
   por esbuild (ADR-0007) em um único IIFE carregado **depois** do legado e
   do Lucide (ordem em A12).
3. **Zero jQuery no custom** (`$`, `jQueryNuvem`, `.on()`…). DOM nativo.
4. Quando uma feature precisa de algo que só o legado faz (ex.: AJAX de busca
   via `LS.search`), o custom **delega** em vez de duplicar (ADR-0010).

## Consequências

- Reescrita de componentes (header, menu, busca, carrinho, PDP) em vez de
  patch do tema base — mais trabalho inicial, código testável depois.
- Partes do site ainda são 100% legado (conta, blog, contato). Elas continuam
  funcionando pela camada da plataforma, sem CSS Bootstrap (ADR-0002).
- A stack de teste local (ADR-0014) exercita **só** a camada custom: o legado
  fica desligado no preview por desenho.

## Referências

- `docs/architecture-map.md` §2 (camadas), A1, A4, A12, F2, L5.
- `docs/searches/important-project-stufs.md` ("Filosofia").
