import { test, expect } from "@playwright/test";
import { gotoPreview, previewOnly } from "./preview.helpers.mjs";

// One test per fixture page: the page renders, the custom bundle boots without
// throwing, and the global modules registered their window.* API (ADR-0006).
for (const name of ["home", "product", "category"]) {
  test(`${name}: renders and the custom bundle boots clean`, async ({ page }) => {
    const errors = await gotoPreview(page, name);

    await expect(page.locator("body")).toBeVisible();
    await expect(page.locator(".js-new-header")).toHaveCount(1);
    await expect(page.locator(".js-cart-drawer")).toHaveCount(1);

    const globals = await page.evaluate(() => ({
      openModal: typeof window.openModal,
      showToast: typeof window.showToast,
      openCartDrawer: typeof window.openCartDrawer,
      lucide: typeof window.lucide,
      swiper: typeof window.Swiper,
    }));
    expect(globals).toEqual({ openModal: "function", showToast: "function", openCartDrawer: "function", lucide: "object", swiper: "function" });

    expect(errors).toEqual([]);
  });
}

test("theme tokens resolve to the admin colors (ADR-0003)", async ({ page }, testInfo) => {
  previewOnly(testInfo, "asserts the fixture palette");
  await gotoPreview(page, "home");
  const colors = await page.evaluate(() => {
    const s = getComputedStyle(document.documentElement);
    return { bg: s.getPropertyValue("--color-bg").trim(), fg: s.getPropertyValue("--color-fg").trim(), accent: s.getPropertyValue("--accent-color").trim() };
  });
  // the @theme tokens must resolve to the admin palette injected by the platform
  expect(colors.bg.toLowerCase()).toBe("#fffff6");
  expect(colors.fg.toLowerCase()).toBe("#cb2c30");
  expect(colors.accent.toLowerCase()).toBe("#2dcc57");
});
