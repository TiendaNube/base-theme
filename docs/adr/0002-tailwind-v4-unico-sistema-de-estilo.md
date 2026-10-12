# ADR-0002 — Tailwind v4 (CSS-first) como único sistema de estilo

- **Status:** Aceito
- **Data:** 2026-01-24 (decisão original, commit `4dc3f70`); formalizado em 2026-10-12
- **Decisores:** Caio Marques

## Contexto

O tema base da Nuvemshop vinha com Bootstrap 4 + SCSS próprio + helpers
(`d-none`, `row`, `col-md-*`, `btn-primary`…). Em janeiro de 2026 o projeto
adotou Tailwind v4 (`4dc3f70`) e, no dia seguinte, **removeu a camada
Bootstrap e os helpers** de `style-critical.tpl` (`c0bea4c`, "remove bootstrap
and helpers layers"). Desde então classes como `row`, `col-*`, `no-gutters`,
`d-*`, `btn-primary`, `alert-*`, `form-control` **não existem em nenhum CSS do
repositório** — a auditoria de 2026-10-12 contou ~167 tokens de classe sem
definição. Templates que ainda as usam estão, na prática, sem estilo.

Tailwind v4 é configurado em CSS (`@theme`), sem `tailwind.config.js`. A
compilação gera `static/css/app.tpl`, inlinado no `<head>` pelo layout.

## Decisão

1. **Tailwind v4 é o único sistema de estilo vivo.** Utilitários nos
   templates; tokens de design exclusivamente no bloco `@theme` de
   `__src/css/app.css`. Nunca criar `tailwind.config.{js,ts}`.
2. **Bootstrap está morto, não "legado".** Classes Bootstrap/helpers não
   voltam. Um template que ainda as carrega é tratado como *não migrado*: ao
   tocar nele por qualquer motivo, migra-se o trecho para Tailwind.
3. `static/css/style-critical.tpl` e `style-async.scss.tpl` são resíduo da
   plataforma (botões, alerts, swiper, lazysizes). Não recebem CSS novo; só
   encolhem.
4. Valores arbitrários (`text-[13px]`, `leading-[120%]`) são permitidos para
   casos únicos. Um valor que se repete em 3+ arquivos vira token em `@theme`
   (ver dívida abaixo).

## Consequências

- Decisões sobre cor (ADR-0003) e sobre CSS custom (ADR-0004) derivam desta.
- Não existe mais "estilizar com classe do tema base" como atalho — quem
  encontra um snipplet Bootstrap tem duas opções: migrar ou não tocar.
- Dívida registrada (auditoria 2026-10-12): `leading-[80%|100%|120%]`,
  `text-[10px|13px|32px]` repetidos em 10+ arquivos sem token; `h-[596.4px]`
  e `h-[819.2px]` nos hero banners. Candidatos a tokens `--leading-*` /
  `--font-size-*` numa spec própria.
- Dívida registrada: ~40 templates ainda majoritariamente Bootstrap (conta,
  blog, página, contato, shipping, defaults/placeholders, header antigo).
  Não há plano de migração em massa; migração é oportunista por spec.

## Referências

- Commits `4dc3f70` (Tailwind v4), `c0bea4c` (remoção do Bootstrap).
- `docs/architecture-map.md` L1, F3.
- `docs/architecture-drift-reports/20261012-styling-audit.md` §"Fato estrutural".
