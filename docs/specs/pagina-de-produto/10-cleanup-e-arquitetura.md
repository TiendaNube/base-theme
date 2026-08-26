---
feature: pagina-de-produto
spec: 10-cleanup-e-arquitetura
status: done
depends_on:
  [
    "02-galeria-de-fotos",
    "03-modal-zoom-fotos",
    "04-selecao-de-variantes",
    "05-quantidade",
    "06-calculadora-de-frete",
    "07-barra-fixa-de-compra",
    "08-accordions",
    "11-barra-de-compra-mobile",
    "12-fundo-da-pagina",
  ]
---

<!-- Implementada em 2026-08-26. Duas ressalvas registradas aqui em vez de
silenciadas:

1. O primeiro critério de aceite (comparação visual do desktop com o Figma
   `131:1503`) é uma checagem de regressão da feature inteira e só existe no
   preview real da Nuvemshop — segue com a caixa desmarcada, mesma convenção
   das specs 03/04/07/11/12 desta feature. Esta spec não alterou nenhum
   layout de desktop: as únicas mudanças de template foram código morto no
   calculador de frete do carrinho e um botão dentro de um modal que só
   renderiza em loja multi-idioma.
2. `snipplets/product/product-payment-details.tpl` ainda tem
   `btn-link pull-right text-right`. Ele não foi tocado por nenhuma spec
   01-08 (o plan.md o declara intocado, e a spec 07 o listou como proibido),
   e é um modal de plataforma inteiramente legado — essas classes são o
   único estilo que aqueles elementos têm, então não são resíduo órfão:
   removê-las seria uma mudança visual nova, proibida nesta spec. Fica como
   dívida declarada para uma futura migração desse modal. -->

**Nota**: `09-carrossel-relacionados` foi adiada (`status: blocked`, ver o
próprio arquivo) e não é uma dependência desta spec. `product-related.tpl`
fica **fora do escopo** desta auditoria — não remover suas classes
Bootstrap, não incluí-lo na varredura de resíduos legados abaixo.

## Objetivo

Auditoria final da PDP redesenhada: remover resíduos Bootstrap/legado não
mais usados, confirmar que nada foi deixado pela metade entre specs, e
atualizar `docs/architecture-map.md` para refletir o estado real do código
(novo contexto `product/`, novas classes `js-*`, novos `window.*` se
houver).

## Escopo

- `docs/architecture-map.md` — atualizações pontuais (não uma reescrita).
- Revisão (não reescrita) de todos os arquivos tocados pelas specs 01-08,
  só para remover classes/atributos Bootstrap órfãos que tenham sobrado.
- Proibido: `snipplets/product/product-related.tpl` — fora de escopo (ver
  nota no topo deste arquivo).
- `snipplets/shipping/shipping-calculator.tpl` — **só** remover o parâmetro
  `product_detail` e os ramos condicionais que dependiam dele, já que depois
  da spec 06 nada mais passa `product_detail: true` (o carrinho sempre
  passa `false`) — confirmar isso antes de mexer, e não alterar mais nada
  nesse arquivo além disso.
- Proibido nesta spec: qualquer mudança visual/funcional nova (isto é
  cleanup, não uma spec de feature).

## Critérios de aceite

- [ ] Comparar visualmente o resultado final em `lg:`+ com o Figma node
      `131:1503` ("Desktop - 3") lado a lado: proporção das colunas
      (876px/564px, sem gap, sem padding lateral), grade de fotos 2x2 sem
      swiper, tamanho ao lado da quantidade, CTA/progress bar em fluxo
      normal (não fixos). **"Leve junto" fica de fora dessa comparação** —
      como a spec 09 foi adiada, ele continua no visual Bootstrap/legado de
      largura cheia por enquanto; isso é esperado, não é regressão.
- [ ] Nenhuma classe Bootstrap de grid/componente (`container`, `row`,
      `col-*`, `btn`, `btn-*`, `form-row`, `form-select`, `d-none`,
      `text-md-left`, etc.) remanescente em `templates/product.tpl` ou em
      `snipplets/product/*.tpl` — **exceto `product-related.tpl`**, que
      fica fora de escopo (spec 09 adiada).
- [ ] `docs/architecture-map.md` atualizado:
      - A1: `product/` adicionado à lista de contextos permitidos.
      - A2: guard selectors dos novos módulos (`product-gallery.js`,
        `product-gallery-zoom.js`, `product-variants.js`,
        `product-add-to-cart.js`, `product-accordion.js`, e qualquer outro
        criado) documentados.
      - A3: contagem de exports atualizada (contexto `product` somado).
      - A5/S2: qualquer `window.*` novo criado ao longo das specs 02-09
        documentado (nome, módulo que define, módulo(s) que consome).
      - R3: novas classes `js-*` do contexto `product` documentadas.
      - Se alguma decisão desta feature virou um invariante novo (ex.: "a
        PDP não usa `LS.changeVariant`"), registrar como nota — sem
        inventar um código de invariante novo (A15 etc.) a menos que já
        exista um padrão equivalente no documento.
- [ ] Confirmar (grep no projeto) que nenhum template fora de
      `snipplets/product/`/`templates/product.tpl` depende de qualquer
      classe/arquivo removido nesta spec.
- [ ] `npm run build` limpo, sem warnings novos.

## Invariantes aplicáveis

- Esta spec É a atualização do contrato — não há invariante que ela viole
  por definição, mas deve manter consistência interna do documento
  (formato das seções A/D/S/T/L/F já existentes).

## Referências de padrão

- Estrutura atual de `docs/architecture-map.md` (seções 3 "Core
  Architectural Invariants" e 8 "Dependency Rules") — seguir o mesmo nível
  de detalhe e formato ao adicionar entradas.
