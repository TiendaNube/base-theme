import { test, expect } from "@playwright/test";
import { gotoStore, isMobile, visible, lastToast, expectCartCount, PATHS } from "../helpers.mjs";

// templates/category.tpl + __src/js/modules/category/* + system/item-card-quickbuy.js

const cards = (page) => page.locator(".js-category-grid [data-product-id]");

test.describe("grid", () => {
  test("primeira página tem até 12 cards, cada um com link, nome e preço", async ({ page }) => {
    await gotoStore(page, "category");
    const all = cards(page);
    const n = await all.count();
    expect(n).toBeGreaterThan(0);
    expect(n).toBeLessThanOrEqual(12);
    for (let i = 0; i < Math.min(n, 4); i++) {
      const card = all.nth(i);
      await expect(card.locator('a[href*="/produtos/"]').first()).toBeAttached();
      expect((await card.getAttribute("data-product-name"))?.trim()).not.toBe("");
      await expect(card).toContainText(/R\$/);
    }
  });

  test("o card leva para a PDP do produto", async ({ page }) => {
    await gotoStore(page, "category");
    const card = cards(page).first();
    const name = await card.getAttribute("data-product-name");
    await card.locator('a[href*="/produtos/"]').first().click();
    await page.waitForURL(/\/produtos\//);
    await expect(page.locator("h1.js-product-name")).toContainText(name.slice(0, 15));
  });

  test("o desconto aparece só quando há preço 'de'", async ({ page }) => {
    await gotoStore(page, "category");
    const result = await cards(page).evaluateAll((els) =>
      els.map((el) => {
        const badge = [...el.querySelectorAll("span")].find((s) => /^-\d+%$/.test(s.textContent.trim()));
        const compare = !!el.querySelector(".text-fg-muted");
        return { badge: !!badge, compare };
      }),
    );
    for (const r of result) expect(r.badge).toBe(r.compare);
  });
});

// Card de produto (Fibery #236, snipplets/grid/item-card.tpl): mesma geometria na
// categoria, no carrossel e no grid da home. Lê a geometria de cada card visível:
// caixa da imagem (filho logo após o <script> de variantes), título (1º <a> do bloco
// de info, que é o último filho) e linha de preço (último filho do bloco de info).
const cardGeometry = (page, selector) =>
  page.locator(selector).evaluateAll((els) =>
    els
      .filter((el) => el.offsetParent !== null)
      .slice(0, 12)
      .map((el) => {
        const card = el.getBoundingClientRect();
        const image = el.querySelector(":scope > script + div").getBoundingClientRect();
        const info = el.lastElementChild;
        const title = info.querySelector("a").getBoundingClientRect();
        const price = info.lastElementChild.getBoundingClientRect();
        return {
          cardLeft: card.left,
          cardRight: card.right,
          cardTop: Math.round(card.top),
          imageRatio: image.width / image.height,
          titleInset: title.left - card.left,
          titleHeight: title.height,
          priceInset: price.left - card.left,
          priceTop: Math.round(price.top),
        };
      }),
  );

test.describe("card de produto (#236)", () => {
  test("imagem 4:5, título e preço com inset de 8px", async ({ page }) => {
    await gotoStore(page, "category");
    const geo = await cardGeometry(page, ".js-category-grid [data-product-id]");
    expect(geo.length).toBeGreaterThan(0);
    for (const c of geo) {
      expect(c.imageRatio).toBeCloseTo(0.8, 1);
      expect(Math.round(c.titleInset)).toBe(8);
      expect(Math.round(c.priceInset)).toBe(8);
    }
  });

  test("título reserva 2 linhas e cards da mesma linha alinham o preço", async ({ page }) => {
    await gotoStore(page, "category");
    const geo = await cardGeometry(page, ".js-category-grid [data-product-id]");
    const rows = new Map();
    for (const c of geo) rows.set(c.cardTop, [...(rows.get(c.cardTop) || []), c]);
    for (const row of rows.values()) {
      expect(new Set(row.map((c) => c.priceTop)).size, "preços da mesma linha em alturas diferentes").toBe(1);
    }
    // 2 linhas de 13px × 1.2 ≈ 31px, mesmo para nomes curtos
    for (const c of geo) expect(c.titleHeight).toBeGreaterThanOrEqual(30);
  });
});

// Grade da categoria (Fibery #238): mobile 2 colunas, md+ 3 (nunca 4), dentro da margem
// da página (24px mobile, alinhada ao header) e com espaço entre os cards (decisão 2026-10-13).
test.describe("grade da categoria (#238)", () => {
  test("colunas e gaps seguem o Figma", async ({ page, isMobile }) => {
    await gotoStore(page, "category");
    const info = await page.locator(".js-category-grid").evaluate((el) => {
      const cs = getComputedStyle(el);
      const first = el.querySelector("[data-product-id]").getBoundingClientRect();
      return {
        columns: cs.gridTemplateColumns.split(" ").length,
        columnGap: cs.columnGap,
        rowGap: cs.rowGap,
        firstLeft: first.left,
        vw: document.documentElement.clientWidth,
      };
    });
    expect(info.columns).toBe(isMobile ? 2 : 3);
    expect(parseFloat(info.columnGap)).toBeGreaterThan(0);
    expect(parseFloat(info.rowGap)).toBeGreaterThan(0);
    if (isMobile) expect(Math.round(info.firstLeft)).toBe(24);
  });

  test("cards carregados pela rolagem infinita entram na mesma grade de 2/3 colunas", async ({ page, isMobile }) => {
    await gotoStore(page, "category");
    const btn = page.locator(".js-category-load-more-btn");
    test.skip((await btn.count()) === 0, "categoria com uma página só");
    const before = await cards(page).count();
    await btn.click();
    await expect.poll(() => cards(page).count()).toBeGreaterThan(before);
    const lefts = await cards(page).evaluateAll((els) => els.slice(-6).map((el) => Math.round(el.getBoundingClientRect().left)));
    expect(new Set(lefts).size).toBe(isMobile ? 2 : 3);
  });
});

// Painel de filtros (gaius modal/drawer) aberto pelo gatilho visível; devolve o corpo do modal.
const openFilterPanel = async (page) => {
  await visible(page.locator(".js-category-filter-trigger")).first().click();
  const container = page.locator(".js-gaius-modal-container");
  await expect(container).toHaveAttribute("data-state", "open");
  return container.locator(".js-gaius-modal-body");
};

const centerY = async (locator) => {
  const b = await locator.boundingBox();
  return b.y + b.height / 2;
};

// Barra da categoria no mobile (Fibery #237, Figma 14:1568): uma linha só com título +
// subcategoria à esquerda e o link "Filtros" à direita; breadcrumb logo abaixo; sem ordenação.
test.describe("barra da categoria (#237)", () => {
  test("mobile: título, subcategoria e 'Filtros' numa linha, breadcrumb logo abaixo", async ({ page }, testInfo) => {
    test.skip(!isMobile(testInfo), "só mobile: o desktop mantém dropdown de ordenação + Filtrar");
    await gotoStore(page, "category");
    await expect(visible(page.locator(".js-category-sorting"))).toHaveCount(0);

    const h1 = page.locator("h1").first();
    const trigger = visible(page.locator(".js-category-filter-trigger")).first();
    await expect(trigger).toHaveText(/\S/);
    const titleY = await centerY(h1);
    expect(Math.abs((await centerY(trigger)) - titleY)).toBeLessThanOrEqual(4);
    const dropdown = visible(page.locator(".js-category-dropdown-trigger")).first();
    if (await dropdown.count()) expect(Math.abs((await centerY(dropdown)) - titleY)).toBeLessThanOrEqual(4);
    // área de toque do link "Filtros"
    expect((await trigger.boundingBox()).height).toBeGreaterThanOrEqual(40);

    // breadcrumb abaixo do título e a grade logo depois dele (sem a antiga 3ª linha de controles)
    const h1Box = await h1.boundingBox();
    const crumb = await visible(page.locator('nav[aria-label="Breadcrumb"]')).first().boundingBox();
    expect(crumb.y).toBeGreaterThanOrEqual(h1Box.y + h1Box.height - 1);
    const gridTop = (await page.locator(".js-category-grid").boundingBox()).y;
    expect(gridTop - (crumb.y + crumb.height)).toBeLessThan(40);
  });
});

test.describe("ordenação", () => {
  test("mobile: chip de 'Ordenar:' no painel recarrega com sort_by e marca o chip", async ({ page }, testInfo) => {
    test.skip(!isMobile(testInfo), "no desktop a ordenação é o dropdown da barra (teste abaixo)");
    await gotoStore(page, "category");
    const body = await openFilterPanel(page);
    const chips = visible(body.locator(".js-category-sorting-option"));
    expect(await chips.count()).toBeGreaterThan(1);
    await expect(chips.first()).toHaveAttribute("data-sort-value", "best-selling");
    for (const h of await chips.evaluateAll((els) => els.map((el) => el.getBoundingClientRect().height))) {
      expect(h, "área de toque do chip").toBeGreaterThanOrEqual(40);
    }

    const chip = visible(body.locator('.js-category-sorting-option:not([aria-current="true"])')).first();
    const value = await chip.getAttribute("data-sort-value");
    await chip.click();
    await page.waitForURL((url) => url.searchParams.get("sort_by") === value);

    const reopened = await openFilterPanel(page);
    await expect(reopened.locator('.js-category-sorting-option[aria-current="true"]')).toHaveCount(1);
    await expect(reopened.locator(`.js-category-sorting-option[data-sort-value="${value}"]`)).toHaveAttribute("aria-current", "true");
    expect(await cards(page).count()).toBeGreaterThan(0);
  });

  test("escolher uma opção recarrega com sort_by e marca a opção", async ({ page }, testInfo) => {
    test.skip(isMobile(testInfo), "mobile: a ordenação vive nos chips do painel (teste acima)");
    await gotoStore(page, "category");
    const sorting = visible(page.locator(".js-category-sorting")).first();
    const trigger = sorting.locator(".js-category-sorting-trigger");
    await trigger.click();
    await expect(sorting.locator(".js-category-sorting-list")).toBeVisible();
    await expect(trigger).toHaveAttribute("aria-expanded", "true");

    const option = sorting.locator(".js-category-sorting-option:not(.font-bold)").first();
    const value = await option.getAttribute("data-sort-value");
    await option.click();
    await page.waitForURL((url) => url.searchParams.get("sort_by") === value);

    const current = visible(page.locator(".js-category-sorting")).first().locator(`.js-category-sorting-option[data-sort-value="${value}"]`);
    await expect(current).toHaveClass(/font-bold/);
    expect(await cards(page).count()).toBeGreaterThan(0);
  });

  test("clique fora fecha a lista", async ({ page }, testInfo) => {
    test.skip(isMobile(testInfo), "mobile: sem dropdown de ordenação na barra");
    await gotoStore(page, "category");
    const sorting = visible(page.locator(".js-category-sorting")).first();
    await sorting.locator(".js-category-sorting-trigger").click();
    await expect(sorting.locator(".js-category-sorting-list")).toBeVisible();
    await page.locator("h1").click();
    await expect(sorting.locator(".js-category-sorting-list")).toBeHidden();
  });

  test("ordenar por preço realmente ordena os cards", async ({ page }) => {
    await gotoStore(page, "category");
    // o select oculto lista os mesmos métodos do dropdown (desktop) e dos chips (mobile)
    const values = await page.locator(".js-sort-by option").evaluateAll((els) => els.map((e) => e.value));
    const asc = values.find((v) => /price.*asc|asc.*price|menor/i.test(v));
    test.skip(!asc, "sem opção de preço crescente");
    await page.goto(`${PATHS.category}?sort_by=${asc}`);
    const prices = await cards(page).evaluateAll((els) =>
      els.map((el) => parseFloat((el.dataset.productPrice || "").replace(/[^\d,]/g, "").replace(",", "."))).filter((n) => !isNaN(n)),
    );
    expect(prices.length).toBeGreaterThan(1);
    expect(prices).toEqual([...prices].sort((a, b) => a - b));
  });
});

test.describe("filtros", () => {
  test("abrem no modal (drawer no mobile) e fecham com Esc devolvendo o conteúdo", async ({ page }, testInfo) => {
    await gotoStore(page, "category");
    const trigger = visible(page.locator(".js-category-filter-trigger")).first();
    test.skip((await trigger.count()) === 0, "categoria sem filtros");
    await trigger.click();

    const container = page.locator(".js-gaius-modal-container");
    await expect(container).toHaveAttribute("data-state", "open");
    const content = container.locator(".js-gaius-modal-content");
    if (isMobile(testInfo)) await expect(content).toHaveClass(/js-gaius-modal-drawer/);
    else await expect(content).not.toHaveClass(/js-gaius-modal-drawer/);
    const body = container.locator(".js-gaius-modal-body");
    expect((await body.innerText()).trim()).not.toBe("");
    // "Ordenar:" só no painel mobile; no desktop a ordenação segue no dropdown da barra
    if (isMobile(testInfo)) expect(await visible(body.locator(".js-category-sorting-option")).count()).toBeGreaterThan(0);
    else await expect(visible(body.locator(".js-category-sorting-option"))).toHaveCount(0);

    await page.keyboard.press("Escape");
    await expect(container).toHaveAttribute("data-state", "closed");
    await expect.poll(() => page.locator(".js-category-filter-content").evaluate((el) => el.innerHTML.trim().length)).toBeGreaterThan(0);
  });

  test("aplicar um filtro de categoria/variação muda a URL", async ({ page }) => {
    await gotoStore(page, "category");
    const trigger = visible(page.locator(".js-category-filter-trigger")).first();
    test.skip((await trigger.count()) === 0, "categoria sem filtros");
    await trigger.click();
    const body = page.locator(".js-gaius-modal-container .js-gaius-modal-body");
    const filter = body.locator(".js-apply-filter").filter({ visible: true }).first();
    test.skip((await filter.count()) === 0, "sem filtros aplicáveis nesta categoria");
    // chips de variação (#237): área de toque de 40px em volta do chip de 32px
    const box = await filter.boundingBox();
    expect(box.height).toBeGreaterThanOrEqual(40);
    expect(box.width).toBeGreaterThanOrEqual(40);
    await filter.click();
    await page.waitForURL((url) => url.search.length > 0 || url.pathname !== PATHS.category, { timeout: 20_000 });
  });
});

test.describe("subcategorias", () => {
  test("o dropdown ao lado do título navega para a categoria escolhida", async ({ page }) => {
    await gotoStore(page, "category");
    const dropdown = visible(page.locator(".js-category-dropdown")).first();
    test.skip((await dropdown.count()) === 0, "categoria sem subcategorias");
    await dropdown.locator(".js-category-dropdown-trigger").click();
    const list = dropdown.locator(".js-category-dropdown-list");
    await expect(list).toBeVisible();
    const link = list.locator("a[href]").first();
    const href = await link.getAttribute("href");
    await link.click();
    await page.waitForURL((url) => url.href.startsWith(new URL(href, page.url()).href));
    await expect(page.locator("h1")).toBeVisible();
  });
});

test.describe("rolagem infinita", () => {
  test("carrega a próxima página sem duplicar produtos e esconde o botão no fim", async ({ page }) => {
    await gotoStore(page, "category");
    const grid = page.locator(".js-category-grid");
    test.skip((await grid.getAttribute("data-is-last")) === "true", "categoria com uma página só");

    const firstCount = await cards(page).count();
    await page.locator(".js-category-load-more").scrollIntoViewIfNeeded();
    await expect.poll(() => cards(page).count(), { timeout: 20_000 }).toBeGreaterThan(firstCount);

    const ids = await cards(page).evaluateAll((els) => els.map((e) => e.dataset.productId));
    expect(new Set(ids).size).toBe(ids.length);
    await expect(page.locator(".js-category-scroll-spinner")).toBeHidden();

    // os cards novos também têm quick buy inicializado
    const lastCard = cards(page).last();
    await expect(visible(lastCard.locator(".js-quickbuy-add-btn"))).toHaveCount(1);
  });
});

test.describe("quick buy", () => {
  // Devolve o primeiro card cujo JSON de variantes tem pelo menos uma opção esgotada
  const findCardWithSoldOut = async (page) => {
    const n = await cards(page).count();
    for (let i = 0; i < n; i++) {
      const card = cards(page).nth(i);
      const variants = await card.locator(".js-quickbuy-variants-data").evaluate((s) => JSON.parse(s.textContent));
      if (variants.some((v) => !v.available) && variants.some((v) => v.available)) return { card, variants };
    }
    return null;
  };

  test("opções esgotadas ficam desabilitadas e a primeira disponível vem selecionada", async ({ page }, testInfo) => {
    await gotoStore(page, "category");
    const found = await findCardWithSoldOut(page);
    test.skip(!found, "nenhum card com opção esgotada nesta categoria");
    const { card, variants } = found;

    const qb = visible(card.locator(".js-quickbuy-container")).first();
    await qb.locator(".js-quickbuy-dropdown-trigger").first().click();
    const list = qb.locator(".js-quickbuy-dropdown-list").first();
    await expect(list).toBeVisible();

    const optionSel = isMobile(testInfo) ? ".js-quickbuy-pill" : ".js-quickbuy-dropdown-option";
    const options = await list.locator(optionSel).evaluateAll((els) =>
      els.map((el) => ({ name: el.dataset.optionName, selected: el.dataset.selected === "true", disabled: el.classList.contains("pointer-events-none") })),
    );
    for (const o of options) {
      const available = variants.some((v) => v.option0 === o.name && v.available);
      expect(o.disabled, `${o.name} disabled`).toBe(!available);
    }
    const firstAvailable = options.find((o) => !o.disabled);
    expect(options.filter((o) => o.selected).map((o) => o.name)).toEqual([firstAvailable.name]);
    await expect(qb.locator(".js-quickbuy-dropdown-label").first()).toHaveText(firstAvailable.name);
  });

  test("escolher uma opção atualiza o rótulo e fecha a lista", async ({ page }, testInfo) => {
    await gotoStore(page, "category");
    const card = cards(page).first();
    const qb = visible(card.locator(".js-quickbuy-container")).first();
    test.skip((await qb.locator(".js-quickbuy-dropdown").count()) === 0, "produto sem variações");

    await qb.locator(".js-quickbuy-dropdown-trigger").first().click();
    const list = qb.locator(".js-quickbuy-dropdown-list").first();
    const optionSel = isMobile(testInfo) ? ".js-quickbuy-pill" : ".js-quickbuy-dropdown-option";
    const candidate = list.locator(`${optionSel}:not(.pointer-events-none):not([data-selected])`).first();
    test.skip((await candidate.count()) === 0, "só uma opção disponível");
    const name = await candidate.getAttribute("data-option-name");
    // locator fixo pelo nome: o seletor acima é preguiçoso e deixaria de casar depois do clique
    const option = list.locator(`${optionSel}[data-option-name="${name}"]`).first();
    await option.click();
    await expect(list).toBeHidden();
    await expect(qb.locator(".js-quickbuy-dropdown-label").first()).toHaveText(name);
    await expect(option).toHaveAttribute("data-selected", "true");
  });

  test("+ adiciona ao carrinho com toast e badge, sem navegar", async ({ page }) => {
    await gotoStore(page, "category");
    const card = cards(page).first();
    const name = await card.getAttribute("data-product-name");
    const qb = visible(card.locator(".js-quickbuy-container")).first();
    const add = qb.locator(".js-quickbuy-add-btn");
    await expect(add).toBeVisible();
    await expect(add).toHaveAttribute("aria-label", /.+/);

    const url = page.url();
    await add.click();
    await expect(lastToast(page)).toContainText(name.slice(0, 15), { timeout: 15_000 });
    await expectCartCount(page, 1);
    expect(page.url()).toBe(url);
    await expect(page.locator(".js-cart-drawer")).toHaveAttribute("data-state", "closed");
  });

  test("abrir um segundo dropdown fecha o primeiro", async ({ page }) => {
    await gotoStore(page, "category");
    const first = visible(cards(page).nth(0).locator(".js-quickbuy-container")).first().locator(".js-quickbuy-dropdown").first();
    const second = visible(cards(page).nth(1).locator(".js-quickbuy-container")).first().locator(".js-quickbuy-dropdown").first();
    test.skip((await first.count()) === 0 || (await second.count()) === 0, "cards sem variações");
    await first.locator(".js-quickbuy-dropdown-trigger").click();
    await expect(first.locator(".js-quickbuy-dropdown-list")).toBeVisible();
    await second.locator(".js-quickbuy-dropdown-trigger").click();
    await expect(second.locator(".js-quickbuy-dropdown-list")).toBeVisible();
    await expect(first.locator(".js-quickbuy-dropdown-list")).toBeHidden();
  });
});
