import { test, expect } from "@playwright/test";
import { gotoPreview } from "./preview.helpers.mjs";

// The cart drawer is the reference implementation of the data-state pattern
// (ADR-0006 / architecture-map A9). Exercise open → close through the public
// window.* API and the template binding.
test("cart drawer opens and closes via data-state", async ({ page }, testInfo) => {
  const errors = await gotoPreview(page, "home");
  const drawer = page.locator(".js-cart-drawer");

  await expect(drawer).toHaveAttribute("data-state", "closed");
  await page.evaluate(() => window.openCartDrawer());
  await expect(drawer).toHaveAttribute("data-state", "open");
  if (!testInfo.project.name.startsWith("real-")) await expect(page.locator(".js-cart-item")).toHaveCount(2);

  await page.locator(".js-cart-drawer-close").first().click();
  await expect(drawer).toHaveAttribute("data-state", "closed");
  expect(errors).toEqual([]);
});
