---
name: ftp-deploy
description: Sobe config/, layouts/, snipplets/, static/ e templates/ direto pro FTP da loja Nuvemshop (hoje a loja de dev democamisetasromadev — não há produção ainda, ver ADR-0012) via scripts/ftp-deploy.mjs, fora do fluxo git (sem commit, sem PR, sem passar pela master) — pra testar mudanças no preview real da Nuvemshop sem esperar merge. Publica imediatamente pro site ao vivo, incluindo qualquer mudança não commitada que estiver no disco. Roda build antes se __src/ mudou. Use quando o usuário pede pra "subir pro FTP pra testar", "publicar pra ver no site", "mandar pro FTP direto", "testar isso no preview real" — nunca por iniciativa própria, sempre a pedido explícito.
---

# /ftp-deploy

Publica o estado atual do disco (commitado ou não) direto no FTP de
produção — o mesmo host que `ftp-deploy.yml` usa em push pra `master`, só
que disparado manualmente, sem passar por git. Existe porque este repo não
tem servidor de dev local nem staging: a única forma de ver uma mudança
"de verdade" é no preview da loja Nuvemshop, e a loja lê os arquivos direto
do FTP, sem uma etapa de rascunho/publish separada.

**Isso é publicação imediata na loja que lê esse FTP.** Hoje (2026-10) é a
loja de dev `democamisetasromadev.lojavirtualnuvem.com.br`, sem clientes; o
rigor desta skill existe para quando o mesmo FTP (ou um `FTP_*_PROD`) for a
producao — ver ADR-0012. Não
é a mesma coisa que a skill `/pr` (que só commita/abre PR e nunca mexe em
produção) nem que `/main` (que só sincroniza local). Não confunda as três.

## Fase 0 — Credenciais

Confira se existe `.env` na raiz do repo com `FTP_HOST`, `FTP_USERNAME`,
`FTP_PASSWORD` preenchidos (`.env.example` tem o template, mesmos nomes dos
GitHub Secrets usados em `ftp-deploy.yml`).

- Se `.env` não existir ou estiver com algum valor vazio, **pare** e peça
  pro usuário preencher (`cp .env.example .env` e editar) — nunca peça pra
  colar a senha na conversa, e nunca crie o `.env` você mesmo com valores
  inventados ou reaproveitados de outro lugar sem confirmação explícita.

## Fase 1 — Build em dia (se `__src/` mudou)

O FTP publica exatamente o que está em `static/` no disco — não builda nada
no servidor. Se algum arquivo em `__src/` mudou nesta conversa (ou
`git status` mostra `static/js/gaius-v*.js`/`static/css/app.tpl`
desatualizados em relação a `__src/`), rode **`npm run build`** (nunca
`node esbuild.config.mjs` isolado — pula o cache-busting que sincroniza
`esbuild.config.mjs` e `layouts/layout.tpl` com o novo bundle).

Se `__src/` não mudou, pule esta fase.

## Fase 2 — Mostrar o que vai subir e confirmar

Antes de tocar no FTP:

- Rode `git status` (e `git diff` se fizer sentido) nos diretórios que o
  script sobe (`config/`, `layouts/`, `snipplets/`, `static/`, `templates/`)
  pra listar pro usuário exatamente o que está diferente do que já está em
  produção hoje (commitado ou não — o script sobe o disco como está,
  independente de commit).
- Resuma isso pro usuário e **peça confirmação explícita antes de rodar o
  upload**, mesmo que ele já tenha invocado a skill — é publicação real,
  sem PR/review no meio, e o pedido inicial pode não ter tido essa lista em
  mãos. Se ele já confirmou no mesmo pedido ("sobe e testa", "manda"), pode
  seguir sem perguntar de novo.

## Fase 3 — Upload

```bash
npm run ftp:deploy
```

Isso roda `scripts/ftp-deploy.mjs` (usa `basic-ftp`, protocolo FTPS,
mesmo padrão do workflow), subindo os 5 diretórios um a um. O script
**sobrescreve arquivos existentes e reaproveita diretórios**, mas nunca
apaga arquivos remotos que não têm correspondente local (sem
`clearWorkingDir`/mirror destrutivo) — diferente de um `rsync --delete`.
Isso significa que arquivos removidos localmente **não** somem do FTP só
com este comando; se a mudança envolveu deletar um arquivo, avise o usuário
que a remoção remota precisa ser feita à parte (isso é esperado do script
tal como está, não um bug a corrigir por conta própria).

Se o comando falhar (credencial errada, host inacessível, timeout), reporte
o erro tal como veio — não tente adivinhar a causa nem mude credenciais
sozinho.

## Fase 4 — Depois do upload

Lembre o usuário:
- O FTP e o git agora podem estar dessincronizados (o que subiu pode
  incluir mudanças não commitadas, ou a `master` remota pode ter algo que
  esse upload não incluiu). Isso é esperado pra um ciclo de teste, mas não
  vira o estado "oficial" do projeto.
- Depois de validar no preview, o fluxo normal continua sendo `/pr` (commit
  + PR) e só então merge manual — este comando não substitui isso, só
  antecipa a visualização.

## Regras

- Nunca rode isso por iniciativa própria — só a pedido explícito do
  usuário, em cada ocasião (não é algo pra encadear automaticamente depois
  de terminar uma spec, por exemplo).
- Nunca invente ou reaproveite credenciais sem confirmação; nunca imprima o
  conteúdo do `.env` na conversa.
- Nunca edite `scripts/ftp-deploy.mjs` pra adicionar exclusão/mirror
  destrutivo sem o usuário pedir isso explicitamente — o comportamento
  "nunca apaga remoto" é intencional (mais seguro que um mirror completo).
- Não é um substituto de `/pr` — não commita nada. Se o usuário quiser
  registrar a mudança depois, isso é outro pedido (`/pr`).

## Saída esperada

Reporte, em poucas linhas:
- Se rodou build (Fase 1) e o que ele gerou.
- O que foi mostrado como diff antes do upload e se o usuário confirmou.
- Resultado do upload por diretório (sucesso/erro), incluindo a mensagem de
  erro completa se algo falhou.
- O lembrete da Fase 4.
