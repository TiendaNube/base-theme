import { test, expect } from "@playwright/test";
import { gotoStore } from "../helpers.mjs";

// Fibery #289: grid and carousel have independent sources (sections product_grid /
// carousel_tab_*); grid count comes from settings; "Ver todos" only with label + URL.
// The grid falls back to "primary" while its own section is empty, so these assertions
// hold both before and after the owner fills the new section.

test.describe("home: fontes de produtos", () => {
  test("grid renderiza produtos únicos, dentro do limite configurado", async ({ page }) => {
    await gotoStore(page, "home");
    const grid = page.locator("[data-store='home-product-grid']");
    await expect(grid).toBeVisible();
    const ids = await grid.locator("[data-product-id]").evaluateAll((els) => els.map((e) => e.getAttribute("data-product-id")));
    expect(ids.length).toBeGreaterThan(0);
    expect(ids.length).toBeLessThanOrEqual(12);
    expect(new Set(ids).size).toBe(ids.length);
  });

  test("carrossel existe independente do grid", async ({ page }) => {
    await gotoStore(page, "home");
    await expect(page.locator("[data-store='home-product-carousel']")).toBeVisible();
  });

  test('"Ver todos" só aparece com texto e link preenchidos', async ({ page }) => {
    await gotoStore(page, "home");
    for (const sel of [".js-grid-viewall", ".js-carousel-viewall"]) {
      const link = page.locator(sel);
      if ((await link.count()) === 0) continue; // não configurado na loja: ausência é o comportamento correto
      await expect(link.first()).toHaveAttribute("href", /\S/);
      await expect(link.first()).toHaveText(/\S/);
    }
  });
});
