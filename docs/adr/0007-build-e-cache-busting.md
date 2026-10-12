# ADR-0007 — esbuild IIFE + bundle `gaius-v{epoch}.js` com `static/` commitado

- **Status:** Aceito
- **Data:** 2026-01-25 (`50081b6`) / 2026-03-01 (`1bd67f5`, `21ccfbe`); formalizado em 2026-10-12
- **Decisores:** Caio Marques

## Contexto

O bundle é carregado por `{{ 'js/x.js' | static_url | script_tag }}` — uma tag
`<script>` comum servida pelo CDN da Nuvemshop, que **cacheia agressivamente
por nome de arquivo** e não serve `.map`. Na época do `gaius-v72.js` /
`gaius-v95.js`, mudanças de JS não apareciam no site por horas. Além disso o
deploy (ADR-0012) não roda build: o que está em `static/` no git é o que vai
para o ar.

## Decisão

1. **esbuild**, entrada única `__src/js/index.js`, saída IIFE, `es2018`,
   minificado, sem sourcemap, `platform: browser`. Nunca ESM.
2. **Nome com epoch**: `pre-build.js` gera `gaius-v{Date.now()}.js`, apaga o
   bundle anterior e reescreve a referência em `esbuild.config.mjs` e
   `layouts/layout.tpl` (regex `/gaius-v\d+\.js/g`; cada arquivo tem
   exatamente uma ocorrência).
3. **`npm run build` é o único comando de produção.** `node
   esbuild.config.mjs` sozinho é proibido fora do watch — deixa o nome velho
   e o CDN continua servindo o antigo.
4. **`static/` é commitado** (`app.tpl`, `gaius-v*.js`) no mesmo commit da
   mudança em `__src/`, com o `.js` antigo removido.
5. Tailwind compila `__src/css/app.css` → `static/css/app.tpl` com
   `--optimize`.

## Consequências

- Todo PR com mudança em `__src/` carrega 4 arquivos de build (css, js novo,
  js antigo removido, config + layout). Ruído aceito em troca de deploy sem
  build.
- `watch:js` pula o pre-build — ok em dev, nunca para entregar.
- Risco conhecido: a regex quebra se alguém reformatar a linha do `outfile`
  ou escrever "gaius-v" num comentário desses dois arquivos.

## Referências

- `docs/architecture-map.md` A4, A7, L2, R6, R7, F1, RISK 4.
- `pre-build.js`, `esbuild.config.mjs`, `package.json`.
