# ADR-0011 — Figma é fonte de intenção, não de valores

- **Status:** Aceito
- **Data:** 2026-08-17/18 (specs 05, 11 e 12 da PDP); formalizado em 2026-10-12
- **Decisores:** Caio Marques

## Contexto

O redesign da PDP foi feito a partir do Figma, com o MCP entregando CSS
literal: `#80807b` para texto apagado, `rgba(0,0,0,0.05)` para fundo de
controle, `1440px` de canvas sem mockup de tablet. Copiar isso verbatim
viola ADR-0003 e ignora que o tema é configurável pelo lojista. A spec 11
registrou a recusa explícita de `#80807b` em favor de `text-fg-muted`, e a
spec 05 criou `--color-control` derivado de `--text-color` em vez do rgba.

## Decisão

1. **Design → tokens.** Toda cor do Figma é traduzida para um token
   existente (`text-fg-muted`, `bg-control`) ou para uma constante de marca
   nova no `@theme` (ADR-0003 §2). Nunca hex no template.
2. **Medidas → escala.** Espaçamentos, tamanhos e line-heights usam a escala
   do Tailwind/`@theme`; valor arbitrário só quando o design exige e não se
   repete.
3. **Breakpoints são decisão nossa.** O Figma não define tablet; o tema
   escolhe (ex.: PDP troca para duas colunas em `lg`, 1024px, porque 564px +
   galeria não cabe entre 768 e 1023).
4. **Verificar antes de dar "done":** screenshot no viewport certo +
   comportamento no preview (local ADR-0014 ou real), não só o CSS gerado.

## Consequências

- Fica explícito que "ficou igual ao Figma" não é critério de aceite
  isolado; "igual ao Figma, dentro dos tokens, respondendo ao tema" é.
- Pequenas diferenças de cor entre Figma e site em paletas não-padrão são
  esperadas e desejadas.

## Referências

- `docs/specs/pagina-de-produto/05-*.md`, `11-*.md`, `12-*.md`.
- `__src/css/app.css` (`--color-control`, `--color-highlight`, comentários).
- Memória do projeto: "Figma → Tailwind translation".
