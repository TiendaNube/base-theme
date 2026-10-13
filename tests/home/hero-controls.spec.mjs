import { test, expect } from "@playwright/test";
import { PATHS } from "../helpers.mjs";

// #290 — controles do hero: um único h1 na home, hero 2 com autoplay vindo do admin.
test.describe("home hero controls", () => {
  test("a home tem exatamente um h1", async ({ page }) => {
    await page.goto(PATHS.home);
    await expect(page.locator("h1")).toHaveCount(1);
  });

  test("hero 2 expõe autoplay e intervalo por data-*", async ({ page }) => {
    await page.goto(PATHS.home);
    const hero2 = page.locator(".js-hero-banner-2");
    test.skip((await hero2.count()) === 0, "hero 2 inativo na loja");
    await expect(hero2).toHaveAttribute("data-autoplay", /^(true|false)$/);
    await expect(hero2).toHaveAttribute("data-autoplay-interval", /^\d+(\.\d+)?$/);
  });

  test("slide inativo do hero 2 fica fora da navegação por teclado", async ({ page }) => {
    await page.goto(PATHS.home);
    const slides = page.locator(".js-hero2-slide");
    test.skip((await slides.count()) < 2, "hero 2 com um slide só");
    await expect(slides.nth(1)).toHaveAttribute("aria-hidden", "true");
    await expect(slides.nth(0)).not.toHaveAttribute("aria-hidden", "true");
  });
});
