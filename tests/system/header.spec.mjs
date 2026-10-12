import { test, expect } from "@playwright/test";
import { gotoStore, isMobile, expectScrollLocked, expectScrollUnlocked, scrollTo, scrollY } from "../helpers.mjs";

// __src/js/modules/system/header.js + menu.js (snipplets/header/header-new.tpl)

test.describe("header", () => {
  test("na home nasce transparente e fica ativo depois de 50px de rolagem", async ({ page }) => {
    await gotoStore(page, "home");
    const header = page.locator(".js-new-header");
    await expect(header).toHaveAttribute("data-initial-state", "transparent");
    await expect(header).toHaveAttribute("data-state", "transparent");

    await scrollTo(page, 300);
    await expect(header).toHaveAttribute("data-state", "active");

    await scrollTo(page, 0);
    await expect(header).toHaveAttribute("data-state", "transparent");
  });

  test("fora da home já nasce ativo", async ({ page }) => {
    await gotoStore(page, "category");
    await expect(page.locator(".js-new-header")).toHaveAttribute("data-state", "active");
  });

  test("o logo leva para a home", async ({ page }) => {
    await gotoStore(page, "category");
    await page.locator('.js-new-header a[href="/"]').filter({ visible: true }).first().click();
    await page.waitForURL((url) => url.pathname === "/");
  });
});

test.describe("menu mobile", () => {
  test.beforeEach(({}, testInfo) => test.skip(!isMobile(testInfo), "só no projeto mobile"));

  test("abre pelo botão, trava a rolagem, fecha pelo X e devolve a posição", async ({ page }) => {
    await gotoStore(page, "home");
    await scrollTo(page, 400);

    await page.locator(".js-menu-mobile-toggle").click();
    const menu = page.locator(".js-menu-mobile");
    await expect(menu).toBeVisible();
    await expectScrollLocked(page);
    await expect(page.locator(".js-new-header")).toHaveAttribute("data-state", "active");

    await page.locator(".js-menu-mobile-close").click();
    await expect(menu).toBeHidden();
    await expectScrollUnlocked(page);
    expect(await scrollY(page)).toBeGreaterThanOrEqual(350);
  });

  test("Esc fecha o menu", async ({ page }) => {
    await gotoStore(page, "home");
    await page.locator(".js-menu-mobile-toggle").click();
    await expect(page.locator(".js-menu-mobile")).toBeVisible();
    await page.keyboard.press("Escape");
    await expect(page.locator(".js-menu-mobile")).toBeHidden();
    await expectScrollUnlocked(page);
  });

  test("abas trocam o painel", async ({ page }) => {
    await gotoStore(page, "home");
    await page.locator(".js-menu-mobile-toggle").click();
    const tabs = page.locator(".js-menu-mobile-tab");
    test.skip((await tabs.count()) < 2, "a loja tem uma aba só no menu");
    await tabs.nth(1).click();
    await expect(page.locator(".js-menu-mobile-panel").nth(1)).toBeVisible();
    await expect(page.locator(".js-menu-mobile-panel").nth(0)).toBeHidden();
  });

  test("acordeão abre um nível e fecha os irmãos", async ({ page }) => {
    await gotoStore(page, "home");
    await page.locator(".js-menu-mobile-toggle").click();
    const toggles = page.locator(".js-menu-mobile .js-menu-accordion-toggle").filter({ visible: true });
    test.skip((await toggles.count()) < 1, "menu sem subníveis");

    const first = toggles.nth(0);
    await first.click();
    await expect(first).toHaveAttribute("aria-expanded", "true");
    const firstContent = first.locator("xpath=ancestor::li[1]").locator(".js-menu-accordion-content").first();
    await expect(firstContent).toBeVisible();

    const siblings = first.locator("xpath=ancestor::li[1]/following-sibling::li").locator(".js-menu-accordion-toggle").filter({ visible: true });
    if ((await siblings.count()) > 0) {
      await siblings.first().click();
      await expect(siblings.first()).toHaveAttribute("aria-expanded", "true");
      await expect(first).toHaveAttribute("aria-expanded", "false");
      await expect(firstContent).toBeHidden();
    }

    // segundo clique no mesmo toggle fecha
    await first.click();
    await expect(first).toHaveAttribute("aria-expanded", "true");
    await first.click();
    await expect(first).toHaveAttribute("aria-expanded", "false");
  });

  test("um link do menu abre uma página da loja", async ({ page }) => {
    await gotoStore(page, "home");
    await page.locator(".js-menu-mobile-toggle").click();
    const link = page.locator('.js-menu-mobile a[href^="https://"], .js-menu-mobile a[href^="/"]').filter({ visible: true }).first();
    const href = await link.getAttribute("href");
    await link.click();
    await page.waitForURL((url) => url.href.startsWith(new URL(href, page.url()).href));
    await expect(page.locator("h1")).toBeVisible();
  });
});

test.describe("menu desktop", () => {
  test.beforeEach(({}, testInfo) => test.skip(isMobile(testInfo), "só no projeto desktop"));

  test("abre o dropdown no clique, ativa o header e fecha com Esc", async ({ page }) => {
    await gotoStore(page, "home");
    const toggle = page.locator("[data-menu-desktop] .js-menu-desktop-toggle").first();
    const dropdown = page.locator(".js-menu-dropdown").first();

    await toggle.click();
    await expect(toggle).toHaveAttribute("aria-expanded", "true");
    await expect(dropdown).toBeVisible();
    await expect(page.locator(".js-new-header")).toHaveAttribute("data-state", "active");

    await page.keyboard.press("Escape");
    await expect(toggle).toHaveAttribute("aria-expanded", "false");
    await expect(dropdown).toBeHidden();
    await expect(page.locator(".js-new-header")).toHaveAttribute("data-state", "transparent");
  });

  test("segundo clique e clique fora fecham", async ({ page }) => {
    await gotoStore(page, "category");
    const toggle = page.locator("[data-menu-desktop] .js-menu-desktop-toggle").first();
    const dropdown = page.locator(".js-menu-dropdown").first();

    await toggle.click();
    await expect(dropdown).toBeVisible();
    await toggle.click();
    await expect(dropdown).toBeHidden();

    await toggle.click();
    await expect(dropdown).toBeVisible();
    const box = await dropdown.boundingBox();
    await page.mouse.click(12, Math.min(box.y + box.height + 24, page.viewportSize().height - 8));
    await expect(dropdown).toBeHidden();
  });

  test("o dropdown tem links para categorias", async ({ page }) => {
    await gotoStore(page, "home");
    await page.locator("[data-menu-desktop] .js-menu-desktop-toggle").first().click();
    const links = page.locator(".js-menu-dropdown").first().locator("a[href]").filter({ visible: true });
    expect(await links.count()).toBeGreaterThan(0);
    const href = await links.first().getAttribute("href");
    await links.first().click();
    await page.waitForURL((url) => url.href.startsWith(new URL(href, page.url()).href));
  });
});
