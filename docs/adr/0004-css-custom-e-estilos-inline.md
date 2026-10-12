# ADR-0004 — CSS custom só em `app.css`; sem `<style>` autoral nem inline estático

- **Status:** Aceito
- **Data:** 2026-01-24 (prática desde `4dc3f70`); formalizado em 2026-10-12
- **Decisores:** Caio Marques

## Contexto

Com Tailwind como único sistema (ADR-0002), ainda sobra CSS que utilitário não
expressa: estado via `[data-state]`, animações, hacks de scrollbar/backdrop,
estilos de SVG injetado pela plataforma. Esse CSS precisa de um lugar único,
senão volta a se espalhar por `<style>` em templates e `style=""` em
elementos. A auditoria de 2026-10-12 encontrou 134 atributos `style=` (113
deles `display:none` de estado inicial, alternados por JS), 6 estáticos que
deveriam ser classes, e zero `<style>` autoral — os 7 blocos `<style>` são
wrappers de injeção (fontes, `style-critical`, `app.tpl`, `settings.css_code`).

## Decisão

1. **CSS custom vive só em `__src/css/app.css`**, abaixo do `@theme`, para o
   que Tailwind não expressa: seletores de estado (`[data-state=…]`,
   `[aria-expanded=…]`, `[data-selected=…]`), `@keyframes`, hacks de
   plataforma (`.powered-by-wrapper svg`), overrides de vendor (swiper).
2. **`js-*` em `app.css` só para estado ou chrome do componente que o JS
   controla.** O registro R4 do contrato lista os seletores permitidos; um
   `js-*` novo em CSS entra no registro. `js-*` nunca é usado para estilo em
   template (`[&_.js-x]`) nem em `<style>`.
3. **Sem `<style>` autoral em template.** Exceção fixa: os wrappers de injeção
   do `layout.tpl`/`password.tpl` (componente `fonts`, include de
   `style-critical.tpl` e `app.tpl`, `settings.css_code`).
4. **Sem `style=""` estático.** Inline só para valor que vem do Twig em tempo
   de render (largura de progresso, swatch do lojista, `--accent-color`
   mapeado de dropdown). Layout/cor fixos viram classe.
5. **`display:none` inline de estado inicial é dívida, não padrão.** Código
   novo usa `hidden` ou `data-state` (S3 do contrato). Os 113 existentes
   ficam até o módulo JS correspondente ser migrado — trocar só o template
   quebra `el.style.display = ""`.
6. `@apply` é evitado; o único uso (`.powered-by-wrapper svg`) é dívida.

## Consequências

- `snipplets/notification/modal.tpl:1` e `toast.tpl:1` (inline estático de
  layout), `category.tpl:61,246,257`, `menu-carousel.tpl:69` são dívida a
  migrar quando o arquivo for tocado.
- Qualquer `<style>` novo em template é violação sem exceção.
- Dívida: as regras de estado do header em `app.css`
  (`.js-new-header[data-state=…] .nav-link { color }`) têm especificidade
  maior que qualquer utilitário no template, o que anula o destaque de item
  de menu (`text-fg`) no desktop. Resolver numa spec (provavelmente
  `.nav-link:not(.text-fg)` ou mover o destaque para `data-highlighted`).
- Custo: migração de `display:none` exige mexer em JS e template juntos;
  por isso é por módulo, em spec, nunca em massa.

## Referências

- `docs/architecture-map.md` S3, R4.
- `docs/architecture-drift-reports/20261012-styling-audit.md` §"Inline style", §"app.css".
