# ADR-0016 — Tasks do Fibery em ondas

- **Status:** Aceito
- **Data:** 2026-10-13
- **Decisores:** Caio Marques (owner)
- **Substitui:** ADR-0013 (workflow spec-driven)

## Contexto

O ADR-0013 organizou o trabalho em `docs/specs/<slug>/plan.md` + specs
numeradas, implementadas por `/implement-spec`. Na prática isso inflou o
contexto da IA: cada sessão carregava plano, specs irmãs, README e a skill
antes de escrever uma linha, e o status vivia em arquivos que ninguém mais
consultava. O trabalho real já é rastreado no Fibery (workspace
`camisetas-roma-dev`, space "Project Tracking", database Task, projeto
"Roma Theme V2"), com os nós do Figma anexados. Os ADRs e o
`docs/architecture-map.md` já carregam as regras; a spec só duplicava contexto.

Além disso, várias frentes passaram a rodar em paralelo (um agente por
frente). Sem regra de posse, dois agentes editam o mesmo template; e como o
`pre-build.js` reescreve `static/`, `esbuild.config.mjs` e a linha
`gaius-v{epoch}` do `layouts/layout.tpl` a cada build (ADR-0007), builds
paralelos geram conflito garantido. Há uma única loja de dev (ADR-0015).

## Decisão

1. **A Task do Fibery é a unidade de trabalho.** A descrição carrega
   contexto, nós do Figma e critérios de aceite. Não há `plan.md` nem specs
   no repo, e `/implement-spec` deixa de existir. As regras são os ADRs e o
   `docs/architecture-map.md`. Correção de uma linha continua exigindo
   `lint:styles` + teste.
2. **Tasks são agrupadas em ondas.** Uma onda é um conjunto de tasks que
   podem andar em paralelo sem editar o mesmo template. Tasks de Design vêm
   antes; Features (complexas) vêm depois delas.
3. **Cada onda tem linhas.** Uma linha = um git worktree + a branch
   `wave-N/<linha>`, criada a partir de `wave/N`.
   - A linha é dona exclusiva dos seus templates.
   - Arquivos compartilhados (`__src/css/app.css`, `config/translations.txt`,
     testes) só são tocados na região da própria linha.
   - Precisou de algo fora do escopo: parar e reportar, não improvisar.
4. **Linhas nunca rodam** `npm run build`, o pre-build, deploy FTP nem
   `npm test`, e nunca commitam `static/`, `esbuild.config.mjs` ou a linha
   `gaius-v` do `layouts/layout.tpl`. Podem rodar `npm run lint:styles` e
   compilar Tailwind/esbuild para um caminho temporário só para conferir.
5. **A integração é da sessão principal**, por onda:
   1. merge das linhas em `wave/N`;
   2. um único `npm run build`;
   3. deploy na loja de dev;
   4. bateria: `npm test` completo + screenshots 393/1440 de cada task
      contra o nó do Figma;
   5. falhas voltam ao mesmo agente da linha que as originou;
   6. um PR por onda; merge manual; pull;
   7. tasks passam a Done no Fibery; a próxima onda nasce da `master`
      atualizada.
6. **Deploy na integração.** O owner autoriza, de uma vez, o upload para a
   loja de dev em toda integração de onda. Isso fecha o ponto 5 do ADR-0015
   (que deixava em aberto se o upload dentro do fluxo precisava de
   confirmação por vez): na integração de onda não precisa; fora dela,
   `/ftp-deploy` segue a pedido explícito.
7. **Modelo e esforço por linha** são escolhidos pela sessão orquestradora
   conforme a complexidade da task.

## Consequências

- Contexto menor por sessão: o agente lê a Task, os ADRs aplicáveis e o
  contrato, nada mais.
- Perde-se o arquivo de status por spec; o status vive no Fibery. O histórico
  de `docs/specs/` permanece no git.
- Builds e deploys passam a acontecer uma vez por onda, não por task — o
  feedback visual de uma linha só chega na integração.
- Falha na bateria custa uma volta de ida e volta com o agente da linha.
- Exige disciplina de particionar templates por linha; tasks que colidem vão
  para ondas diferentes.

## Referências

- ADR-0007 (cache-busting reescreve arquivos a cada build), ADR-0012,
  ADR-0015 (loja de dev, loop máquina → loja).
- Fibery: workspace `camisetas-roma-dev`, space "Project Tracking", Task.
