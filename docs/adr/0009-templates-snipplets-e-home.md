# ADR-0009 — Snipplets por domínio e home roteada pelo admin

- **Status:** Aceito
- **Data:** 2026-02/03 (prática); endurecido no drift audit de 2026-03-14; formalizado em 2026-10-12
- **Decisores:** Caio Marques

## Contexto

O tema base deixa snipplets soltos na raiz de `snipplets/` (23 arquivos hoje:
`card.tpl`, `cart-totals.tpl`, `footer.tpl`, `whatsapp-chat.tpl`…). Conforme
o projeto criou componentes próprios, eles foram para pastas por domínio
(`header/`, `home/`, `navigation/`, `grid/`, `product/`, `cart/`,
`notification/`…). A home é composta pelo admin: `home_order_position_0..12`
escolhe a seção de cada slot, e `home-section-switch.tpl` roteia.

## Decisão

1. **Snipplet novo vai em pasta de domínio** (existente ou nova). A raiz de
   `snipplets/` não é precedente; os 23 arquivos ali ficam até serem
   migrados ou removidos.
2. **Include por `{% snipplet %}` ou `{% include %}`** — os dois são válidos
   na plataforma e os dois existem no código.
3. **Home nunca assume ordem.** Seção nova = `elseif` no router + snipplet em
   `snipplets/home/` + opção no dropdown de `settings.txt` + `has_*` em
   `home.tpl` se tiver visibilidade condicional. Nada entra em `home.tpl`
   fora do loop.
4. **Toda customização exposta ao lojista passa por `config/settings.txt`**
   (`snake_case`, agrupada por categoria/meta/title/field) e é lida como
   `settings.x`. Texto, cor, toggle e URL que o lojista deveria controlar
   nunca são hardcoded.

## Consequências

- Os 23 flat files na raiz são dívida visível (CLAUDE.md dizia "a handful").
- Templates das páginas são finos; a composição vive nos snipplets e no
  router — o que torna o preview por fixtures (ADR-0014) viável.

## Referências

- `docs/architecture-map.md` A10, A11, A13, T1, T4, F10, D3.
- `docs/architecture-drift-reports/20260314-drift-audit.md` (A10 endurecido).
