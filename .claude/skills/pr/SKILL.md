---
name: pr
description: Commita as mudanças do contexto atual da conversa, garante que o build (`npm run build`) está em dia se `__src/` mudou, faz push e abre um PR contra `master` (título e corpo em português, formato deste repo) — e para aí. Não mergeia sozinha: merge na `master` dispara deploy imediato via FTP em produção (workflow `ftp-deploy.yml`), e este repo não tem CI/testes automatizados como gate. Use quando o usuário pede pra finalizar/entregar o trabalho ("commita e abre PR", "finaliza isso", "abre o PR").
---

# /pr

Fecha o ciclo de uma mudança já feita: **commit → (garantir build em dia) →
push → PR → parar**. Não é uma skill de implementação — assume que o código
já foi escrito e validado no preview da Nuvemshop durante a conversa.

**Merge é sempre manual.** `master` tem um workflow (`ftp-deploy.yml`) que
publica `config/`, `layouts/`, `snipplets/`, `static/` e `templates/` direto
no FTP da loja Nuvemshop a cada push (hoje a loja de dev; produção ainda não
existe — ADR-0012) — sem gate automatizado além de lint + testes locais. Essa skill
nunca chama `gh pr merge`, mesmo que o usuário peça pra "finalizar rápido";
se pedirem merge automático, avise que essa skill não faz isso e pergunte se
é pra mergear na mão agora.

## Fase 0 — Pré-voo

- `git status` pra ver branch atual, staged/unstaged/untracked. Nunca rode
  comando destrutivo (`reset --hard`, `checkout .`, `clean -f`) sem checar
  primeiro o que existe.
- Se estiver no meio de um merge/rebase, pare e reporte — não tente resolver
  sozinho sem confirmar com o usuário.
- Se a branch atual for `master`: crie uma branch nova
  (`git checkout -b <tipo>/<slug-curto>`) **antes** de commitar — isso
  preserva as mudanças não commitadas no working tree, só troca o ponteiro de
  branch. Prefixo do nome de branch no padrão de commit deste repo
  (`feat/`, `fix/`, `refactor/`, `docs/`, `chore/`, `build/`, `ci/`, `test/`).

## Fase 1 — Build em dia (se `__src/` mudou)

Este repo não tem passo de build no deploy — o FTP publica exatamente o que
está commitado em `static/`. Se algum arquivo em `__src/` mudou nesta
conversa e o build correspondente não rodou depois da última mudança:

- Rode **`npm run build`** (nunca `node esbuild.config.mjs` sozinho — pula o
  passo de cache-busting).
- `npm run build` faz três coisas que têm que ir *juntas* no mesmo commit:
  1. Recompila `static/css/app.tpl` (se `__src/css/` mudou).
  2. Apaga o `static/js/gaius-v<epoch-antigo>.js` velho e gera um
     `static/js/gaius-v<epoch-novo>.js` novo.
  3. Reescreve a referência a esse arquivo em `esbuild.config.mjs` e em
     `layouts/layout.tpl`.
- Depois de rodar, `git status` vai mostrar: o `.js` antigo como deletado, o
  novo como untracked, e `esbuild.config.mjs` + `layouts/layout.tpl`
  modificados (além do `app.tpl` se CSS mudou). Todos esses arquivos entram
  no mesmo commit da mudança de `__src/` que os gerou — nunca separado, senão
  a `master` fica com layout apontando pra um bundle que não existe (ou o CDN
  serve a versão velha).
- Se `__src/` não mudou nesta conversa (ex.: só mudou `templates/`,
  `snipplets/`, `config/`), pule esta fase — não há nada pra rebuildar.

## Fase 1b — Lint e testes

Antes de commitar, rode `npm run lint:styles` e `npm test`. Se qualquer um
falhar, pare e reporte — não abra PR com lint ou teste vermelho, e não use
`lint-styles: allow` só para passar. Os dois rodam contra o preview local
(ADR-0014); não substituem a validação no preview real, mas são o gate mínimo.

## Fase 2 — Escopo do commit

- **Só as mudanças do contexto atual da conversa** (incluindo o build da
  Fase 1, se rodou). Se `git status` mostrar arquivos sujos que você não
  tocou nesta sessão (trabalho em progresso pré-existente do usuário),
  **não** varra pra dentro do commit — pergunte ou deixe de fora.
- Nunca `git add -A` / `git add .` às cegas — mas para os artefatos da Fase 1
  (delete + novo `.js` + `esbuild.config.mjs` + `layout.tpl`), stage todos
  explicitamente, já que fazem parte do mesmo commit por construção.
- Não commite arquivos que pareçam segredo (`.env`, credenciais de FTP,
  chaves) — avise o usuário se aparecerem no diff.
- Rode `git status`, `git diff` (staged + unstaged) e `git log` recente em
  paralelo pra entender o que vai no commit e imitar o estilo já usado no
  repo.
- Mensagem de commit no padrão conventional-commits já usado aqui
  (`feat:`/`fix:`/`refactor:`/`docs:`/`chore:`/`build:`/`ci:`/`test:`), em
  inglês (é o padrão observado em todo `git log` deste repo, mesmo a
  comunicação com o usuário sendo em pt-BR), foco no *porquê* mais do que no
  *o quê*. Trailer `Co-Authored-By` conforme as instruções gerais de commit.
- Mudanças logicamente distintas viram commits separados — não force tudo
  num commit só só porque foi tocado na mesma conversa.

## Fase 3 — Push + PR

- Verifique se a branch tem upstream; se não, `git push -u origin <branch>`.
- Verifique se já existe PR pra essa branch (`gh pr view --json url`). Se já
  existe, **não crie duplicado** — o push já atualizou o PR existente; só
  reporte a URL.
- Se não existe, monte o PR a partir de `git log master...HEAD` e
  `git diff master...HEAD` (todos os commits da branch, não só o último):

  - **Título e corpo em português** — é o padrão real deste repo (confira o
    PR #1 mergeado: `gh pr view 1 --json body`), diferente da convenção de
    commit em inglês.
  - Corpo com `## Summary` (bullets do que mudou) e `## Test plan`. O test
    plan começa com o resultado de lint + testes locais e segue com o
    checklist de validação manual no admin da Nuvemshop (o que o preview
    local não cobre) — no formato:

    ```bash
    gh pr create --base master --title "título curto em português (<70 chars)" --body "$(cat <<'EOF'
    ## Summary
    - ...

    ## Test plan
    - [x] `npm run lint:styles` e `npm test` verdes (N testes, mobile + desktop)
    - [ ] Revisar o preview do tema no admin da Nuvemshop (build já commitado em `static/`)
    - [ ] ...(passos específicos da mudança: página/fluxo a navegar, estado a conferir)
    - [ ] Conferir responsividade mobile/desktop

    🤖 Generated with [Claude Code](https://claude.com/claude-code)
    EOF
    )"
    ```
  - Adapte os itens do Test plan ao que de fato mudou (não copie os do PR #1
    genericamente) — se a mudança não toca `__src/`, não mencione build.
- Reporte a URL do PR (nova ou já existente) ao usuário.
- **Não segue pra Fase 4 se o push ou a criação do PR falharem.** Pare e
  reporte o erro — nunca remova a worktree com trabalho não confirmado no
  remoto.

## Fase 4 — Limpeza de worktree (só se a sessão estiver numa worktree)

Detecte antes de qualquer coisa:

```bash
git rev-parse --git-dir --git-common-dir
```

Se as duas saídas resolverem pro **mesmo** `.git`, a sessão **não** está numa
worktree — pare aqui, não há nada pra limpar.

Se forem diferentes (git-dir aponta pra algo dentro de
`.../.git/worktrees/...`), a sessão está numa worktree linked. Só prossiga
depois que a Fase 3 confirmou push + PR com sucesso:

1. Tente `ExitWorktree` com `action: "remove"` e `discard_changes: true`.
   - Seguro aqui especificamente porque os commits já estão no remoto e o PR
     já está aberto — remover a worktree só apaga a cópia local e o ponteiro
     de branch local, não afeta o branch remoto nem o PR.
   - Se a ferramenta confirmar a remoção, terminou.
2. Se `ExitWorktree` reportar no-op (worktree não foi criada por
   `EnterWorktree` nesta sessão — sessão retomada, ou worktree criada
   manualmente com `git worktree add`), remova manualmente:

   ```bash
   MAIN_REPO=$(dirname "$(git rev-parse --git-common-dir)")
   WORKTREE_PATH=$(git rev-parse --show-toplevel)
   cd "$MAIN_REPO" && git worktree remove "$WORKTREE_PATH" --force
   ```

   O `--force` é necessário porque a branch ainda não foi mergeada na base
   (PR só foi aberto, não mergeado) — isso é esperado, não sinal de
   problema. O `cd` pro repo principal evita deixar o shell da sessão
   apontando pra um diretório que acabou de ser removido.

## Regras

- **Ordem é lei**: build (se aplicável) → commit → push → PR confirmado →
  worktree. Nunca inverta.
- **Nunca `gh pr merge`** nesta skill, sob nenhuma circunstância — merge na
  `master` = deploy imediato em produção via FTP, sem CI de por meio. Merge é
  sempre uma decisão e ação manual do usuário, depois de revisar o preview.
  Se o usuário pedir pra mergear como parte do mesmo pedido, faça só depois
  de confirmação explícita dele — nunca como continuação automática desta
  skill.
- Nunca `git push --force`, nunca pule hooks (`--no-verify`), nunca commite
  direto na `master` sem branch nova.
- Nunca varra mudanças não relacionadas ao contexto da conversa pro commit.
- Nunca esqueça os artefatos de build (Fase 1) no mesmo commit da mudança de
  `__src/` que os gerou.
- Commit sempre em inglês; título/corpo do PR sempre em português; toda
  comunicação com o usuário continua em pt-BR.
- Se não há nada pra commitar **e** nenhum commit novo à frente de `master`,
  diga isso e pare — não abra PR vazio.

## Saída esperada

No fim, reporte:
- Commit(s) criado(s) (hash curto + primeira linha da mensagem), indicando
  se algum incluiu artefatos de build regenerados.
- Se houve push e pra qual branch.
- URL do PR (novo ou já existente).
- Lembrete de que o merge fica pendente de ação manual (dispara deploy em
  produção) e não é feito por esta skill.
- Resultado da limpeza de worktree: removida / mantida (não aplicável) /
  falha (com o motivo).
