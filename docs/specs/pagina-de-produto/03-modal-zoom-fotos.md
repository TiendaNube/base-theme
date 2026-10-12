---
feature: pagina-de-produto
spec: 03-modal-zoom-fotos
status: done
depends_on: ["02-galeria-de-fotos"]
---

<!-- Validado parcialmente no preview real: a validação visual do overlay
ficou inconclusiva, mas por decisão do usuário (2026-08-18) a spec foi
aceita como "done" para não travar o avanço da feature. Se aparecer
problema no zoom em produção, tratar como bug novo, não reabrindo esta
spec. -->

## Objetivo

Implementar o modal fullscreen de zoom das fotos (frame Figma "Product
Image Details", node `52:2434`): ao tocar/clicar na foto ativa da galeria,
abre um overlay fullscreen com Swiper próprio (mostrando parcialmente as
fotos vizinhas), sincronizado com a posição da galeria principal, botão de
fechar, dots de posição e fundo desfocado — substituindo o Fancybox usado
hoje só para esse fim.

## Escopo

- Novo: `__src/js/modules/product/product-gallery-zoom.js`.
- Novo: `snipplets/product/product-gallery-modal.tpl` (markup do overlay,
  incluído uma vez em `templates/product.tpl` ou `product-image.tpl`).
- `snipplets/product/product-image.tpl` — só a adição do trigger de clique
  (ex. `data-open-gallery-zoom` no link/imagem) e a **remoção do atributo
  `data-fancybox="product-gallery"`** dos links de cada foto (não do slide
  de vídeo). O trigger deve funcionar tanto no carrossel mobile/tablet
  quanto na grade estática de 2 colunas do desktop (spec 02) — mesma
  imagem, dois lugares diferentes no DOM por breakpoint.
- `__src/js/index.js` — novo import + atualização da contagem A3.
- `__src/css/app.css` — estilos do overlay não expressáveis em utilitário
  puro (blur de fundo, scroll-snap horizontal do preview lateral).
- Proibido nesta spec: `snipplets/video-item.tpl`,
  `snipplets/product/product-video.tpl` (o trigger de vídeo continua usando
  Fancybox normalmente — ver nota abaixo) e `__src/js/modules/system/
  modal.js` (não deve ser modificado nem usado como base — este overlay é
  um componente próprio, ver justificativa no `plan.md`).

**Nota sobre o Fancybox**: `data-fancybox="product-gallery"` também é usado
por `snipplets/video-item.tpl` (incluído por `product-video.tpl` na galeria
da PDP E por `snipplets/home/home-video.tpl` na home). O bind global do
Fancybox (`Fancybox.bind('[data-fancybox="product-gallery"]', ...)` em
`store.js.tpl:1646`, dentro do bloco `{% if template == 'product' %}`)
continua ativo — só o atributo nos links de foto desta spec é removido. Não
remover o bind, não editar `store.js.tpl`.

## Critérios de aceite

- [ ] **PENDENTE — requer preview real.** Clicar/tocar na foto principal
      abre o overlay fullscreen (`data-state="open"`, padrão A9) mostrando a
      foto atual em destaque com a foto anterior/seguinte parcialmente
      visível nas laterais (Swiper com `slidesPerView: 1.15` +
      `centeredSlides: true`), replicando o layout do frame Figma `52:2434`
      — implementado, mas o encaixe pixel-a-pixel com o Figma só pode ser
      confirmado visualmente.
- [x] O índice inicial do overlay corresponde exatamente ao slide ativo no
      momento do clique na galeria principal: o trigger lê
      `data-image-position` do próprio slide/célula clicado (mobile
      carrossel ou grade desktop) e cai para
      `.js-product-gallery`'s `data-active-position` (exposto pela spec 02)
      caso não encontre — sem importar `product-gallery.js` (F9).
      Verificado por leitura de código
      (`__src/js/modules/product/product-gallery-zoom.js`).
- [x] Botão "X" fecha o overlay; tecla `Escape` fecha; clicar fora da foto
      (no fundo escuro) fecha o zoom, sem fechar ao arrastar o Swiper; scroll do `body` é
      travado/restaurado via `lockScroll`/`unlockScroll` reimplementados
      localmente (mesmo padrão de `modal.js`, sem importá-lo). Verificado
      por leitura de código.
- [x] Dots/paginação refletem a posição atual: `renderPagination` é chamado
      no listener `slideChange` do Swiper do overlay, mesmo padrão de
      `product-gallery.js`. Verificado por leitura de código.
- [x] Fundo aparece com blur: `.js-product-gallery-zoom-backdrop` usa
      `background: rgba(0, 0, 0, 0.85)` + `backdrop-filter: blur(12px)`
      (permitido por A8, sem cor de tema hardcoded). Verificado em
      `__src/css/app.css`.
- [x] `lucide.createIcons()` chamado no fim de `productGalleryZoom()`,
      guardado por `typeof lucide !== "undefined"`.
- [ ] **PENDENTE — requer preview real.** Depois de remover `data-fancybox`
      das fotos, confirmar no preview que o vídeo (se o produto tiver
      `product.video_url`) ainda abre corretamente no modal do Fancybox de
      `product-video.tpl` — `video-item.tpl`/`product-video.tpl` não foram
      tocados nesta spec, mas a confirmação empírica exige o preview real.
- [x] `npm run build` executado sem erros (rodado nesta implementação).

## Invariantes aplicáveis

- A1/A2/A3/F6 — módulo novo no contexto `product/`.
- A9 — padrão `data-state="open|closed"` para o overlay.
- A6/L4 — `lucide.createIcons()` após innerHTML dinâmico.
- F9/R1 — sem import de `product-gallery.js` nem de `modal.js`; comunicação
  via DOM/`window.*`.
- F1/A4 — `static/js/store.js.tpl` não é editado.

## Referências de padrão

- `__src/js/modules/system/modal.js` — padrão de `data-state`, lock/unlock
  de scroll, fechar por Esc/overlay-click (referência de *padrão*, não para
  importar ou reutilizar diretamente — ver `plan.md` para a justificativa
  de por que este overlay é um módulo próprio).
- `__src/js/modules/system/cart-drawer.js` — outro exemplo de componente
  que replica o padrão `data-state` com módulo e markup próprios em vez de
  usar `modal.js`.
- Figma node `52:2434` ("Product Image Details") — layout de referência.
