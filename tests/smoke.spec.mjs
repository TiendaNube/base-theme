import { test, expect } from "@playwright/test";
import { gotoStore } from "./helpers.mjs";

// Cada página renderiza, o bundle custom sobe sem lançar e os módulos globais
// registram sua API (ADR-0006). Busca e 404 ainda são legados, mas usam o mesmo
// layout: também não podem quebrar o bundle.
for (const name of ["home", "category", "product", "search", "notFound"]) {
  test(`${name}: renderiza e o bundle sobe limpo`, async ({ page }) => {
    const { errors, response } = await gotoStore(page, name);
    expect(response.status()).toBe(name === "notFound" ? 404 : 200);

    await expect(page.locator(".js-new-header")).toHaveCount(1);
    await expect(page.locator(".js-cart-drawer")).toHaveCount(1);
    await expect(page.locator(".js-toast-container")).toHaveCount(1);
    await expect(page.locator("footer.js-footer")).toBeAttached();

    const globals = await page.evaluate(() => ({
      openModal: typeof window.openModal,
      showToast: typeof window.showToast,
      showProductToast: typeof window.showProductToast,
      openCartDrawer: typeof window.openCartDrawer,
      onCartUpdate: typeof window.onCartUpdate,
      setHeaderMenuActive: typeof window.setHeaderMenuActive,
      lucide: typeof window.lucide,
      swiper: typeof window.Swiper,
    }));
    expect(globals).toEqual({
      openModal: "function",
      showToast: "function",
      showProductToast: "function",
      openCartDrawer: "function",
      onCartUpdate: "function",
      setHeaderMenuActive: "function",
      lucide: "object",
      swiper: "function",
    });

    expect(errors).toEqual([]);
  });
}

test("páginas prontas têm <title> e um único <h1>", async ({ page }) => {
  for (const name of ["home", "category", "product"]) {
    await gotoStore(page, name);
    expect((await page.title()).trim(), `${name}: title`).not.toBe("");
    if (name !== "home") await expect(page.locator("h1"), `${name}: h1`).toHaveCount(1);
  }
});
