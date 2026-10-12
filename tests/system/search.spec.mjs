import { test, expect } from "@playwright/test";
import { gotoStore, expectScrollUnlocked } from "../helpers.mjs";

// __src/js/modules/system/search.js (snipplets/header/header-search-new.tpl)
// A consulta em si é LS.search() legado, que preenche .js-search-suggest.

const openSearch = async (page) => {
  await page.locator(".js-search-toggle").filter({ visible: true }).first().click();
  await expect(page.locator(".js-search-overlay")).toHaveAttribute("data-state", "open");
};

test("abre pelo botão, foca o campo e trava a rolagem", async ({ page }) => {
  await gotoStore(page, "home");
  await openSearch(page);
  await expect(page.locator(".js-search-input")).toBeFocused();
  await expect.poll(() => page.evaluate(() => document.body.style.overflow)).toBe("hidden");
});

test("Esc fecha, limpa o campo e devolve a rolagem", async ({ page }) => {
  await gotoStore(page, "home");
  await openSearch(page);
  await page.locator(".js-search-input").fill("camiseta");
  await page.keyboard.press("Escape");
  await expect(page.locator(".js-search-overlay")).toHaveAttribute("data-state", "closed");
  await expect(page.locator(".js-search-input")).toHaveValue("");
  await expectScrollUnlocked(page);
});

test("o X e o clique no fundo fecham", async ({ page }) => {
  await gotoStore(page, "home");
  await openSearch(page);
  await page.locator(".js-search-close").click();
  await expect(page.locator(".js-search-overlay")).toHaveAttribute("data-state", "closed");

  await openSearch(page);
  await page.locator(".js-search-overlay").click({ position: { x: 8, y: 8 } });
  await expect(page.locator(".js-search-overlay")).toHaveAttribute("data-state", "closed");
});

test("digitar sugere até 3 produtos e o link 'ver todos'", async ({ page }) => {
  await gotoStore(page, "home");
  await openSearch(page);
  await page.locator(".js-search-input").pressSequentially("camiseta", { delay: 50 });

  const suggest = page.locator(".js-search-suggest");
  await expect(suggest).toBeVisible({ timeout: 15_000 });
  const options = suggest.locator("a[role=option]");
  await expect.poll(() => options.count(), { timeout: 15_000 }).toBeGreaterThan(0);
  expect(await options.count()).toBeLessThanOrEqual(3);
  await expect(suggest.locator(".js-search-suggest-all-link")).toContainText(/\(\d+\)/);

  // cada sugestão leva a um produto
  const href = await options.first().getAttribute("href");
  expect(href).toMatch(/\/produtos\//);
});

test("termo sem produto mostra 'Nenhum resultado'", async ({ page }) => {
  await gotoStore(page, "home");
  await openSearch(page);
  await page.locator(".js-search-input").pressSequentially("zzqqxxww", { delay: 50 });
  const suggest = page.locator(".js-search-suggest");
  await expect(suggest).toBeVisible({ timeout: 15_000 });
  await expect(suggest).toContainText(/nenhum resultado/i, { timeout: 15_000 });
  await expect(suggest.locator("a[role=option]")).toHaveCount(0);
});

test("Enter leva para a página de resultados com o termo", async ({ page }) => {
  test.fail(true, "Fibery #221 — closeSearch() limpa o campo no submit e o GET sai com q vazio");
  await gotoStore(page, "home");
  await openSearch(page);
  await page.locator(".js-search-input").fill("camiseta");
  await page.keyboard.press("Enter");
  await page.waitForURL(/\/search\//, { timeout: 20_000 });
  expect(new URL(page.url()).searchParams.get("q")).toBe("camiseta");
  await expect(page.locator("h1")).toContainText(/resultados/i);
  expect(await page.locator('[data-store^="product-item-"]').count()).toBeGreaterThan(0);
});

test("'ver todos os resultados' leva para a página de busca", async ({ page }) => {
  await gotoStore(page, "home");
  await openSearch(page);
  await page.locator(".js-search-input").pressSequentially("camiseta", { delay: 50 });
  const all = page.locator(".js-search-suggest-all-link");
  await expect(all).toBeVisible({ timeout: 15_000 });
  await all.click();
  await page.waitForURL(/\/search\/?\?q=camiseta/);
});
