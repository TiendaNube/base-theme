import { test, expect } from "@playwright/test";
import { gotoPreview, previewOnly } from "./preview.helpers.mjs";

// Regression tests for the hardcoded-color fixes of 2026-10-12 (ADR-0003).
// Each one asserts that the rendered color *follows the admin palette*
// (fixture: bg #FFFFF6, text #410911, primary #CB2C30) instead of a literal.
// Palette values come from the preview fixtures, so these are preview-only.
test.beforeEach(({}, testInfo) => previewOnly(testInfo, "asserts the fixture palette"));

const rgb = (hex, alpha) => {
  const [r, g, b] = [1, 3, 5].map((i) => parseInt(hex.slice(i, i + 2), 16));
  return alpha === undefined ? `rgb(${r}, ${g}, ${b})` : `rgba(${r}, ${g}, ${b}, ${alpha})`;
};

test("product carousel seeds use the theme text color, no hex", async ({ page }) => {
  await gotoPreview(page, "home");
  const paths = page.locator(".js-carousel-pagination svg path");
  await expect(paths.first()).toBeVisible();
  const fills = await paths.evaluateAll((els) => els.map((e) => e.getAttribute("fill")));
  for (const fill of fills) expect(fill).not.toMatch(/#[0-9a-f]{3,8}/i);
  const [active, inactive] = await paths.evaluateAll((els) => els.slice(0, 2).map((e) => getComputedStyle(e).fill));
  expect(active).toBe(rgb("#410911"));
  // color-mix(--text-color 40%, transparent) → same hue at 40% alpha
  expect(inactive.replace(/\s/g, "")).toMatch(/^(rgba\(65,9,17,0\.4\)|color\(srgb.*\))$/);
});

// Tailwind v4 compiles `bg-bg/70` to color-mix(in oklab …), so Chromium reports
// the computed value in oklab. Check alpha 0.7 and that the hue is the theme
// background (lightness ≈ 1, not a literal off-white rgba).
const expectThemeBg70 = (value) => {
  expect(value).toMatch(/\/ 0\.7\)$|, 0\.7\)$/);
  expect(value).toMatch(/^oklab\(0\.99|^rgba\(255, 255, 246/);
};

test("carousel and category dropdowns paint the theme background at 70%", async ({ page }) => {
  await gotoPreview(page, "home");
  const carouselList = page.locator(".js-carousel-dropdown-list").first();
  expectThemeBg70(await carouselList.evaluate((e) => getComputedStyle(e).backgroundColor));

  await gotoPreview(page, "category");
  const categoryList = page.locator(".js-category-dropdown-list").first();
  expectThemeBg70(await categoryList.evaluate((e) => getComputedStyle(e).backgroundColor));
});

test("VIP group seeds logo inherits the theme background color", async ({ page }) => {
  await gotoPreview(page, "home");
  const path = page.locator('[data-store="home-vip-group"] svg path').first();
  expect(await path.getAttribute("fill")).toBe("currentColor");
  expect(await path.evaluate((e) => getComputedStyle(e).fill)).toBe(rgb("#FFFFF6"));
});

test("highlighted menu item uses the primary color; --color-danger exists", async ({ page }) => {
  await gotoPreview(page, "home");
  const danger = await page.evaluate(() => getComputedStyle(document.documentElement).getPropertyValue("--color-danger").trim());
  expect(danger.toLowerCase()).toBe("#dc2626");
  // Mobile accordion: the highlight class is the only color rule there. (On the
  // desktop nav the header's data-state rule in app.css outranks any utility,
  // so the highlight never shows — pre-existing, see the 2026-10-12 audit.)
  const highlighted = page.locator(".js-menu-mobile").getByText("Promoções").first();
  expect(await highlighted.evaluate((e) => getComputedStyle(e).color)).toBe(rgb("#CB2C30"));
});
