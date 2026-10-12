# ADR-0012 — Merge em `master` = deploy em produção via FTPS; `/ftp-deploy` manual

- **Status:** Aceito
- **Data:** 2026-08-01 (`55b838d`) e 2026-08-17 (`2f9dc33`); formalizado em 2026-10-12
- **Decisores:** Caio Marques

## Contexto

A Nuvemshop lê o tema direto do FTP; não há rascunho/publish nem staging.
O único "ambiente" é a loja ao vivo. Antes do workflow, subir mudança era
manual e sem histórico. Para validar algo no site real sem mergear, foi
criado um deploy manual.

## Decisão

1. **Push em `master` dispara `ftp-deploy.yml`**: cinco uploads FTPS
   (`config/`, `layouts/`, `snipplets/`, `static/`, `templates/`), sem build
   (ADR-0007 — `static/` commitado), com `concurrency` serializada.
2. **Não há gate automático antes do merge.** O gate é humano: PR revisado +
   validação. Com ADR-0014, a validação ganha testes locais, mas o merge
   continua sendo decisão de pessoa — a skill `/pr` abre o PR e para.
3. **`/ftp-deploy` (`scripts/ftp-deploy.mjs`)** sobe o disco atual, só
   adiciona/atualiza (nunca apaga), pede confirmação listando o diff, e **só
   roda a pedido explícito do usuário**. É publicação imediata em produção.
4. Credenciais em `.env` (local) e GitHub Secrets (CI), mesmos nomes.

## Consequências

- Mergear é publicar. Branches de feature vivem até a validação terminar.
- O preview local (ADR-0014) existe para reduzir o número de vezes que
  `/ftp-deploy` precisa ser usado para "ver se ficou certo".
- Rollback = reverter commit e mergear de novo.

## Referências

- `.github/workflows/ftp-deploy.yml`, `scripts/ftp-deploy.mjs`.
- `.claude/skills/ftp-deploy/SKILL.md`, `.claude/skills/pr/SKILL.md`, `.claude/skills/main/SKILL.md`.
