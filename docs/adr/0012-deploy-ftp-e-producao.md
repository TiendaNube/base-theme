# ADR-0012 — Merge em `master` = deploy via FTPS na loja Nuvemshop; `/ftp-deploy` manual

- **Status:** Aceito
- **Data:** 2026-08-01 (`55b838d`) e 2026-08-17 (`2f9dc33`); formalizado em 2026-10-12
- **Decisores:** Caio Marques

## Contexto

**Estado real em 2026-10-12:** a loja de produção ainda não existe. O único
ambiente é a loja de dev `democamisetasromadev.lojavirtualnuvem.com.br`, e é
ela que lê o FTP para onde `master` publica. Os docs anteriores (skills,
contrato) chamavam esse FTP de "produção, visível a clientes" — era o rigor
certo para o fluxo, mas não descrevia a realidade. Este ADR vale para o fluxo
de hoje e marca o que muda quando a produção subir.

A Nuvemshop lê o tema direto do FTP; não há rascunho/publish nem staging.
O único "ambiente" é a loja ao vivo. Antes do workflow, subir mudança era
manual e sem histórico. Para validar algo no site real sem mergear, foi
criado um deploy manual.

## Decisão

1. **Push em `master` dispara `ftp-deploy.yml`**: cinco uploads FTPS
   (`config/`, `layouts/`, `snipplets/`, `static/`, `templates/`), sem build
   (ADR-0007 — `static/` commitado), com `concurrency` serializada.
   `static/` sobe pelo `scripts/ftp-deploy.mjs static` (só adiciona/sobrescreve)
   e não pela `FTP-Deploy-Action`: a sincronização da action apagava o
   `gaius-v{epoch}.js` anterior e o FTP recusa o `DELE`, derrubando o job
   (falha nos merges dos PRs #9 e #10, 2026-10-12). Bundles antigos ficam
   órfãos no FTP; limpar à mão quando incomodar.
2. **Não há gate automático antes do merge.** O gate é humano: PR revisado +
   validação. Com ADR-0014, a validação ganha testes locais, mas o merge
   continua sendo decisão de pessoa — a skill `/pr` abre o PR e para.
3. **`/ftp-deploy` (`scripts/ftp-deploy.mjs`)** sobe o disco atual, só
   adiciona/atualiza (nunca apaga), pede confirmação listando o diff, e **só
   roda a pedido explícito do usuário**. É publicação imediata na loja que lê
   esse FTP (hoje a de dev; amanhã, produção).
4. Credenciais em `.env` (local) e GitHub Secrets (CI), mesmos nomes.

## Consequências

- **Pendente para o lançamento da produção** (decisão nova, ADR próprio):
  manter um FTP por ambiente (`FTP_*_DEV` / `FTP_*_PROD`), com `master` →
  dev e uma tag ou branch `release` → produção, ou promover a loja de dev a
  produção e criar outra de dev. Até lá, o rigor de "merge é publicar"
  continua — é o hábito que protege o lançamento.

- Mergear é publicar. Branches de feature vivem até a validação terminar.
- O preview local (ADR-0014) existe para reduzir o número de vezes que
  `/ftp-deploy` precisa ser usado para "ver se ficou certo".
- Rollback = reverter commit e mergear de novo.

## Referências

- `.github/workflows/ftp-deploy.yml`, `scripts/ftp-deploy.mjs`.
- `.claude/skills/ftp-deploy/SKILL.md`, `.claude/skills/pr/SKILL.md`, `.claude/skills/main/SKILL.md`.
