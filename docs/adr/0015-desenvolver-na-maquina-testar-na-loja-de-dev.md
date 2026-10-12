# ADR-0015 — Desenvolver na máquina, testar na loja de dev

- **Status:** Aceito
- **Data:** 2026-10-12
- **Decisores:** Caio Marques (owner)
- **Substitui em parte:** ADR-0014 (o renderer local deixa de ser o alvo primário; o lint e a suíte Playwright continuam)

## Contexto

O ADR-0014 criou um renderer Twig local porque a IA estava rodando na nuvem,
sem acesso a nenhuma loja Nuvemshop, e a "produção" descrita nos docs era na
verdade a loja de dev (ADR-0012). No mesmo dia ficou claro que:

1. Existe uma loja de dev — `https://democamisetasromadev.lojavirtualnuvem.com.br/`
   — sem clientes, que lê o FTP para onde `master` publica. É o ambiente real,
   com `component()`, `money`, `translate`, `LS.*` e a camada jQuery de verdade.
2. A Nuvemshop fica atrás de um challenge do Cloudflare que bloqueia IPs de
   datacenter. Da nuvem, nem `curl` nem Chromium headless passam; da estação
   de trabalho do owner, a suíte Playwright passou.
3. Um preview que não tem "as coisas da Nuvemshop" não convence o owner como
   validação — e com razão: tudo que o preview não reproduz (ADR-0014 §5) é
   justamente o que diferencia um template renderizado da loja de verdade.

A escolha é entre fidelidade (loja de dev) e velocidade/offline (preview). Com
o desenvolvimento acontecendo na máquina do owner, fidelidade ganha.

## Decisão

1. **O desenvolvimento acontece na máquina do owner**, numa sessão local do
   Claude Code. Sessões na nuvem fazem só trabalho que não precisa validar no
   browser (docs, planejamento, refatoração coberta por lint).
2. **A loja de dev é o alvo de teste.** O loop de uma mudança passa a ser:
   editar → `npm run build` (se `__src/` mudou) → subir para o FTP da loja de
   dev → `npm test` (Playwright contra a loja, headed por causa do Cloudflare)
   → screenshots → ajustar. Não há etapa de preview local nesse loop.
3. **O renderer local (`tools/preview/`) é descontinuado.** Fixtures de
   `product`/`cart`/`store` "chutadas" não valem a manutenção quando a loja
   real está a um upload de distância. Remoção é uma tarefa própria (abaixo),
   não parte deste ADR; até lá o código fica, mas nenhum fluxo depende dele.
4. **O que fica do ADR-0014:** `npm run lint:styles` (não depende de loja) e a
   suíte Playwright, que já é escrita por página lógica — passa a rodar só nos
   projetos `real-*`, com `ROMA_STORE_URL` apontando para a loja de dev por
   padrão e os slugs de produto/categoria reais em `.env`.
5. **Subir para a loja de dev dentro do `/implement-spec` faz parte da
   validação**, não exige pedido separado a cada upload — a loja não tem
   clientes. A skill mostra o que vai subir e segue. Fora de uma spec, o
   `/ftp-deploy` continua a pedido. *(Ponto a confirmar pelo owner ao listar
   as tarefas; se preferir confirmação por upload, basta manter o texto atual
   da skill.)*
6. **Quando a produção subir**, este fluxo continua valendo para a loja de dev
   e um ADR novo decide o FTP/branch de produção (já apontado no ADR-0012).

## Consequências

- Validação deixa de ter a categoria "pendente — requer preview real": o
  teste já é no real. Critérios de aceite que a spec não consegue verificar
  na loja de dev são critérios mal escritos.
- Cada iteração custa um upload FTP (segundos) e o CDN da Nuvemshop pode
  segurar o `gaius-v*.js` anterior — o cache-busting por epoch (ADR-0007)
  continua obrigatório; `app.tpl` é inlinado no HTML e não sofre disso.
- A suíte não roda em CI (o runner do GitHub é IP de datacenter). O gate
  automatizado antes do merge é só `lint:styles`; os testes rodam na máquina.
- Sessões na nuvem perdem a capacidade de "ver" a mudança — aceito, porque
  a premissa é desenvolver na máquina.
- O relatório do `/implement-spec` passa a anexar screenshots da loja de dev,
  não do preview.

## Pendências para fechar este ADR (viram tarefas)

- [x] `.env` nesta máquina com `FTP_*` e `ROMA_STORE_URL`, `ROMA_PRODUCT_PATH`,
      `ROMA_CATEGORY_PATH` (2026-10-12; a config usa a loja de dev como padrão
      mesmo sem `.env`).
- [x] Confirmar que o Playwright passa o Cloudflare a partir de uma sessão do
      agente nesta máquina: headless passa nos GETs e recebe 403 no
      `POST /comprar/`; headed passa em tudo (2026-10-12). A suíte roda headed
      por padrão (`PW_HEADLESS=1` só para leitura).
- [x] `playwright.config.mjs`: projetos `desktop` e `mobile` contra a loja de
      dev; `preview-*` e o `webServer` removidos (2026-10-12).
- [x] `tests/preview.helpers.mjs` → `tests/helpers.mjs` sem o modo offline;
      suíte reorganizada por contexto (`tests/README.md`), 2026-10-12.
- [ ] `/implement-spec`, `/pr` e `/ftp-deploy`: texto alinhado ao loop deste ADR.
- [ ] Remover `tools/preview/`, os scripts `preview*` do `package.json` e o
      `twig` das devDependencies (nada mais depende deles).

## Referências

- ADR-0012 (a loja de dev é o único ambiente), ADR-0014 (o que fica e o que sai).
- `playwright.config.mjs`, `tests/`, `scripts/ftp-deploy.mjs`.
