import { test, expect } from "@playwright/test";
import { gotoStore } from "./helpers.mjs";

// Regressão das correções de cor hardcoded de 2026-10-12 (ADR-0003). Em vez de
// literais, cada teste lê a paleta que a plataforma injetou (var(--*-color)) e
// confere que o elemento renderizado a segue — assim o teste sobrevive a uma
// troca de paleta no admin.

const palette = (page) =>
  page.evaluate(() => {
    const resolve = (value) => {
      const el = document.createElement("div");
      el.style.color = value;
      document.body.appendChild(el);
      const c = getComputedStyle(el).color;
      el.remove();
      return c;
    };
    const root = getComputedStyle(document.documentElement);
    return {
      text: resolve("var(--text-color)"),
      // seed inativa do carrossel (Fibery #231): texto diluído ~15% no fundo do tema
      text15OnBg: resolve("color-mix(in srgb, var(--text-color) 15%, var(--background-color))"),
      bg: resolve("var(--background-color)"),
      bg70: resolve("color-mix(in oklab, var(--background-color) 70%, transparent)"),
      primary: resolve("var(--primary-color)"),
      tokenBg: root.getPropertyValue("--color-bg").trim(),
      tokenFg: root.getPropertyValue("--color-fg").trim(),
      danger: root.getPropertyValue("--color-danger").trim(),
    };
  });

test("tokens do @theme resolvem para a paleta do admin e --color-danger existe", async ({ page }) => {
  await gotoStore(page, "home");
  const p = await palette(page);
  expect(p.tokenBg).toMatch(/^(#|var\(|rgb|oklab)/);
  expect(p.tokenFg).toMatch(/^(#|var\(|rgb|oklab)/);
  expect(p.danger.toLowerCase()).toBe("#dc2626");
  expect(p.text).not.toBe(p.bg);
});

test("seeds do carrossel de produtos usam a cor de texto do tema, sem hex", async ({ page }) => {
  await gotoStore(page, "home");
  const paths = page.locator(".js-carousel-pagination svg path");
  await expect(paths.first()).toBeAttached();
  const fills = await paths.evaluateAll((els) => els.map((e) => e.getAttribute("fill")));
  for (const fill of fills) expect(fill).not.toMatch(/#[0-9a-f]{3,8}/i);

  const p = await palette(page);
  const computed = await paths.evaluateAll((els) => els.map((e) => getComputedStyle(e).fill));
  const active = computed.filter((c) => c === p.text);
  const inactive = computed.filter((c) => c === p.text15OnBg);
  expect(active).toHaveLength(1);
  expect(inactive).toHaveLength(computed.length - 1);
  // opaca e bem mais perto do fundo que do texto (antes era o texto a 40% sobre transparente)
  expect(p.text15OnBg).not.toBe(p.text);
  expect(p.text15OnBg).not.toMatch(/rgba|\/ ?0?\.\d/);
});

test("listas dos dropdowns do carrossel e da categoria pintam o fundo do tema a 70%", async ({ page }) => {
  await gotoStore(page, "home");
  let p = await palette(page);
  const carouselList = page.locator(".js-carousel-dropdown-list").first();
  if (await carouselList.count()) {
    expect(await carouselList.evaluate((e) => getComputedStyle(e).backgroundColor)).toBe(p.bg70);
  }

  await gotoStore(page, "category");
  p = await palette(page);
  const categoryList = page.locator(".js-category-dropdown-list").first();
  if (await categoryList.count()) {
    expect(await categoryList.evaluate((e) => getComputedStyle(e).backgroundColor)).toBe(p.bg70);
  }
});

test("o logo do grupo VIP herda a cor de fundo do tema (currentColor)", async ({ page }) => {
  await gotoStore(page, "home");
  const path = page.locator('[data-store="home-vip-group"] svg path').first();
  test.skip((await path.count()) === 0, "seção VIP não configurada");
  expect(await path.getAttribute("fill")).toBe("currentColor");
  const p = await palette(page);
  expect(await path.evaluate((e) => getComputedStyle(e).fill)).toBe(p.bg);
});

test("item destacado do menu mobile usa a cor primária", async ({ page }, testInfo) => {
  test.skip(testInfo.project.name !== "mobile", "o destaque só existe no menu mobile (dívida ADR-0004)");
  await gotoStore(page, "home");
  await page.locator(".js-menu-mobile-toggle").click();
  const highlighted = page.locator(".js-menu-mobile .text-fg").filter({ visible: true }).first();
  test.skip((await highlighted.count()) === 0, "nenhum item destacado configurado no admin");
  const p = await palette(page);
  expect(await highlighted.evaluate((e) => getComputedStyle(e).color)).toBe(p.primary);
});

test("nenhum estilo inline com cor literal fora dos overlays preto/branco", async ({ page }) => {
  for (const name of ["home", "category", "product"]) {
    await gotoStore(page, name);
    const offenders = await page.evaluate(() =>
      [...document.querySelectorAll("[style*='#']")]
        .filter((el) => !el.closest(".js-cart-drawer, [data-store='footer'], script, .js-nubesdk-slot"))
        .map((el) => el.getAttribute("style"))
        .filter((s) => /#[0-9a-f]{3,8}/i.test(s) && !/#fff(fff)?\b|#000(000)?\b/i.test(s)),
    );
    expect(offenders, `${name}: style="" com hex`).toEqual([]);
  }
});
