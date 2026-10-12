# ADR-0008 — Lucide canônico; Swiper e Lucide como globais vendorados

- **Status:** Aceito
- **Data:** 2025-12-28 (`046ed0a`, Lucide); formalizado em 2026-10-12
- **Decisores:** Caio Marques

## Contexto

O tema base usava ~100 snipplets SVG em `snipplets/svg/`, um arquivo por
ícone, com classes de tamanho próprias. Swiper 6 já vinha vendorado em
`external-no-dependencies.js.tpl`. Instalar qualquer um dos dois via npm
criaria uma segunda cópia no bundle, carregada depois da primeira.

## Decisão

1. **Lucide é o sistema de ícones.** Markup `<i data-lucide="nome">`, render
   por `lucide.createIcons()` (no layout após o load e nos módulos após
   inserir HTML). `static/js/lucide.min.js` é vendorado, nunca npm.
2. **`snipplets/svg/` está congelado.** Não entra arquivo novo. Usar um SVG
   existente só quando o ícone não existe no Lucide. Ao refatorar um
   template, trocar todos os SVGs dele por Lucide.
3. **Swiper é o global `window.Swiper`** do script da plataforma. Nunca npm,
   nunca `import`. O bundle assume que `Swiper` e `lucide` existem porque a
   ordem de carga (A12) garante.

## Consequências

- Migração SVG→Lucide é oportunista e incompleta (~105 usos em 48 templates
  legados na última contagem).
- Se a plataforma trocar a versão do Swiper, os módulos que o usam
  (`product-carousel`, `menu`, `product-gallery*`) precisam de revisão.
- O preview local (ADR-0014) serve os dois a partir de `static/`, como no
  site.

## Referências

- `docs/architecture-map.md` A6, A12, A14, L3, L4, F5, F8, RISK 3.
