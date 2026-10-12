import { test, expect } from "@playwright/test";
import {
  gotoStore,
  isMobile,
  expectScrollLocked,
  expectScrollUnlocked,
  scrollTo,
  scrollY,
  money,
  expectCartCount,
  addToCartFromPdp,
  openCartDrawer,
  lastToast,
} from "../helpers.mjs";

// __src/js/modules/system/cart-drawer.js (snipplets/cart/cart-drawer.tpl)
// Implementação de referência do padrão data-state (ADR-0006 / A9). Os testes
// que adicionam ao carrinho fazem POST real na loja de dev e precisam rodar
// headed (Cloudflare devolve 403 em headless). Cada teste tem contexto novo,
// então começa com carrinho vazio.

const drawer = (page) => page.locator(".js-cart-drawer");
const items = (page) => page.locator(".js-cart-drawer .js-cart-item").filter({ visible: true });

test.describe("abrir e fechar", () => {
  test("abre pelo ícone do header, trava a rolagem, fecha pelo X e devolve a posição", async ({ page }) => {
    await gotoStore(page, "home");
    await scrollTo(page, 300);

    await openCartDrawer(page);
    await expectScrollLocked(page);
    await expect(page.locator(".js-new-header")).toHaveAttribute("data-state", "active");

    await page.locator(".js-cart-drawer-close").click();
    await expect(drawer(page)).toHaveAttribute("data-state", "closed");
    await expectScrollUnlocked(page);
    expect(await scrollY(page)).toBeGreaterThanOrEqual(250);
  });

  test("Esc fecha", async ({ page }) => {
    await gotoStore(page, "home");
    await page.evaluate(() => window.openCartDrawer());
    await expect(drawer(page)).toHaveAttribute("data-state", "open");
    await page.keyboard.press("Escape");
    await expect(drawer(page)).toHaveAttribute("data-state", "closed");
  });

  test("clique no backdrop fecha (desktop)", async ({ page }, testInfo) => {
    test.skip(isMobile(testInfo), "no mobile o painel cobre o backdrop");
    await gotoStore(page, "home");
    await page.evaluate(() => window.openCartDrawer());
    await expect(drawer(page)).toHaveAttribute("data-state", "open");
    await page.locator(".js-cart-drawer-backdrop").click({ position: { x: 20, y: 400 } });
    await expect(drawer(page)).toHaveAttribute("data-state", "closed");
  });

  test("no desktop o painel começa abaixo do header", async ({ page }, testInfo) => {
    test.skip(isMobile(testInfo), "só desktop");
    await gotoStore(page, "home");
    await page.evaluate(() => window.openCartDrawer());
    const headerHeight = await page.locator(".js-new-header").evaluate((el) => el.offsetHeight);
    const panelTop = await page.locator(".js-cart-drawer-panel").evaluate((el) => el.getBoundingClientRect().top);
    expect(Math.abs(panelTop - headerHeight)).toBeLessThanOrEqual(2);
  });
});

test.describe("vazio", () => {
  test("mostra o estado vazio com link para produtos e esconde o rodapé", async ({ page }) => {
    await gotoStore(page, "home");
    await page.evaluate(() => window.openCartDrawer());
    await expect(page.locator(".js-empty-ajax-cart")).toBeVisible();
    await expect(page.locator(".js-empty-ajax-cart a[href]")).toBeVisible();
    await expect(page.locator(".js-cart-drawer-footer")).toBeHidden();
    await expect(items(page)).toHaveCount(0);
  });
});

test.describe("com item", () => {
  test("item adicionado na PDP aparece com nome, variante, subtotal, badge e botão de checkout", async ({ page }) => {
    await gotoStore(page, "product");
    const price = money(await page.locator("#price_display").textContent());
    const variant = await page.locator('.js-product-variant-option[data-selected="true"]').first().getAttribute("data-option-name");
    const { name } = await addToCartFromPdp(page);

    await openCartDrawer(page);
    await expect(items(page)).toHaveCount(1, { timeout: 15_000 });
    const item = items(page).first();
    await expect(item.locator('[data-component="name.short-name"]')).toContainText(name.slice(0, 15));
    if (variant) await expect(item.locator('[data-component="name.short-variant-name"]')).toContainText(variant);
    expect(money(await item.locator(".js-cart-item-subtotal").textContent())).toBeCloseTo(price, 2);
    await expect(item.locator(".js-cart-quantity-input")).toHaveValue("1");

    await expect(page.locator(".js-cart-drawer-footer")).toBeVisible();
    expect(money(await page.locator(".js-cart-drawer-footer .js-cart-subtotal").textContent())).toBeCloseTo(price, 2);
    await expect(page.locator(".js-cart-drawer-checkout")).toBeVisible();
    await expect(page.locator(".js-cart-drawer-checkout")).toBeEnabled();
    await expect(page.locator(".js-empty-ajax-cart")).toBeHidden();
  });

  test("+ e − atualizam quantidade, subtotal e badge", async ({ page }) => {
    await gotoStore(page, "product");
    const price = money(await page.locator("#price_display").textContent());
    await addToCartFromPdp(page);
    await openCartDrawer(page);
    const item = items(page).first();
    await expect(item).toBeVisible({ timeout: 15_000 });

    await item.locator('.js-cart-quantity-btn[data-component="quantity.plus"]').click();
    await expect(item.locator(".js-cart-quantity-input")).toHaveValue("2", { timeout: 15_000 });
    await expectCartCount(page, 2);
    await expect
      .poll(() => page.locator(".js-cart-drawer-footer .js-cart-subtotal").textContent().then(money), { timeout: 15_000 })
      .toBeCloseTo(price * 2, 2);

    await items(page).first().locator('.js-cart-quantity-btn[data-component="quantity.minus"]').click();
    await expect(items(page).first().locator(".js-cart-quantity-input")).toHaveValue("1", { timeout: 15_000 });
    await expectCartCount(page, 1);
  });

  test("remover o único item volta ao estado vazio", async ({ page }) => {
    await gotoStore(page, "product");
    await addToCartFromPdp(page);
    await openCartDrawer(page);
    const item = items(page).first();
    await expect(item).toBeVisible({ timeout: 15_000 });

    await item.locator(".js-cart-remove-btn").click();
    await expect(items(page)).toHaveCount(0, { timeout: 10_000 });
    await expect(page.locator(".js-empty-ajax-cart")).toBeVisible();
    await expect(page.locator(".js-cart-drawer-footer")).toBeHidden();
    await expectCartCount(page, 0);
  });

  test("barras de progresso avançam depois de adicionar", async ({ page }) => {
    await gotoStore(page, "product");
    const bars = page.locator(".js-cart-drawer .js-cart-progress-bar");
    test.skip((await bars.count()) === 0, "loja sem barras de progresso configuradas");

    const widthOf = () => page.locator(".js-cart-drawer .js-cart-progress-fill").first().evaluate((el) => parseFloat(el.style.width) || 0);
    const before = await widthOf();
    await addToCartFromPdp(page);
    await expect.poll(widthOf, { timeout: 15_000 }).toBeGreaterThan(before);

    // a cópia da sticky bar da PDP acompanha
    const pdpFill = page.locator(".js-product-sticky-buy-bar .js-cart-progress-fill").first();
    if (await pdpFill.count()) {
      await expect.poll(() => pdpFill.evaluate((el) => parseFloat(el.style.width) || 0), { timeout: 15_000 }).toBeGreaterThan(before);
    }
  });

  test("barras de progresso acompanham o + sem esperar um timer fixo (Fibery #220)", async ({ page }) => {
    await gotoStore(page, "product");
    const fill = page.locator(".js-cart-drawer .js-cart-progress-fill").first();
    test.skip((await fill.count()) === 0, "loja sem barras de progresso configuradas");

    const widthOf = () => fill.evaluate((el) => parseFloat(el.style.width) || 0);
    await addToCartFromPdp(page);
    await openCartDrawer(page);
    const item = items(page).first();
    await expect(item).toBeVisible({ timeout: 15_000 });
    // espera o refresh do add-to-cart assentar antes de medir
    await expect.poll(widthOf, { timeout: 15_000 }).toBeGreaterThan(0);
    const before = await widthOf();
    test.skip(before >= 100, "uma unidade já completa a barra; o + não a move");

    // Antes do #220 o drawer esperava 2 s fixos depois do + e só então buscava
    // a página (~2,8 s no total). Agora a busca sai quando o POST da plataforma
    // termina: ~0,7 s de request + 0,2 s de debounce + o GET da página.
    await item.locator('.js-cart-quantity-btn[data-component="quantity.plus"]').click();
    await expect.poll(widthOf, { timeout: 2_200, intervals: [100] }).toBeGreaterThan(before);
  });

  test("o toast de produto abre o drawer ao ser clicado", async ({ page }) => {
    await gotoStore(page, "product");
    const { toast } = await addToCartFromPdp(page);
    await toast.click();
    await expect(drawer(page)).toHaveAttribute("data-state", "open");
    await expect(lastToast(page)).toHaveCount(0, { timeout: 5_000 });
  });

  test("badge mobile e contador desktop refletem o mesmo total", async ({ page }) => {
    await gotoStore(page, "product");
    await addToCartFromPdp(page);
    const badge = page.locator(".js-cart-widget-badge");
    await expect.poll(() => badge.evaluate((el) => (el.hidden ? "" : el.textContent.trim())), { timeout: 15_000 }).toBe("1");
  });
});
