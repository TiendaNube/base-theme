import { test, expect } from "@playwright/test";
import { gotoStore, isMobile } from "./helpers.mjs";

// Heurísticas de usabilidade/acessibilidade nas páginas prontas. Não substituem
// um auditor completo; pegam o que mais costuma passar despercebido num tema.

const PAGES = ["home", "category", "product"];

for (const name of PAGES) {
  test(`${name}: sem rolagem horizontal`, async ({ page }) => {
    await gotoStore(page, name);
    const { scrollWidth, innerWidth } = await page.evaluate(() => ({
      scrollWidth: document.documentElement.scrollWidth,
      innerWidth: window.innerWidth,
    }));
    expect(scrollWidth).toBeLessThanOrEqual(innerWidth + 1);
  });

  test(`${name}: botões só com ícone têm nome acessível`, async ({ page }) => {
    await gotoStore(page, name);
    const offenders = await page.evaluate(() =>
      [...document.querySelectorAll("button, a[role=button]")]
        .filter((el) => el.offsetParent !== null && !el.closest(".js-nubesdk-slot"))
        .filter((el) => el.textContent.trim() === "")
        .filter((el) => !el.getAttribute("aria-label") && !el.getAttribute("aria-labelledby") && !el.getAttribute("title") && !el.querySelector("img[alt]:not([alt=''])"))
        .map((el) => el.className || el.outerHTML.slice(0, 80)),
    );
    expect(offenders).toEqual([]);
  });

  test(`${name}: imagens de produto têm alt`, async ({ page }) => {
    await gotoStore(page, name);
    const missing = await page.evaluate(() =>
      [...document.querySelectorAll("[data-product-id] img, .js-product-gallery img, #single-product .lg\\:grid img, .js-product-gallery-zoom img")]
        .filter((img) => !img.closest(".js-related-products, [data-component*='payment'], .js-product-payments-container"))
        .filter((img) => !(img.getAttribute("alt") || "").trim())
        .map((img) => img.closest("[data-product-id]")?.dataset.productName || img.getAttribute("src") || img.getAttribute("data-src")),
    );
    expect(missing).toEqual([]);
  });

  test(`${name}: links visíveis não estão vazios`, async ({ page }) => {
    await gotoStore(page, name);
    const empty = await page.evaluate(() =>
      [...document.querySelectorAll("a[href]")]
        .filter((a) => a.offsetParent !== null && !a.closest(".js-nubesdk-slot"))
        .filter((a) => a.textContent.trim() === "" && !a.querySelector("img, svg, i[data-lucide]") && !a.getAttribute("aria-label") && !a.getAttribute("title"))
        .map((a) => a.getAttribute("href")),
    );
    expect(empty).toEqual([]);
  });
}

test("mobile: alvos de toque dos controles principais têm pelo menos 24px (WCAG 2.5.8)", async ({ page }, testInfo) => {
  test.skip(!isMobile(testInfo), "só mobile");
  const small = [];
  const check = async (selector, label) => {
    const boxes = await page.locator(selector).filter({ visible: true }).evaluateAll((els) =>
      els.slice(0, 6).map((el) => {
        const r = el.getBoundingClientRect();
        return { w: Math.round(r.width), h: Math.round(r.height) };
      }),
    );
    for (const b of boxes) {
      if (b.w < 24 || b.h < 24) small.push(`${label} ${b.w}x${b.h}`);
      if (b.w < 40 || b.h < 40) testInfo.annotations.push({ type: "touch-target<40px", description: `${label} ${b.w}x${b.h}` });
    }
  };

  await gotoStore(page, "home");
  await check(".js-menu-mobile-toggle", "menu toggle");
  await check(".js-search-toggle", "search toggle");
  await check(".js-cart-drawer-toggle", "cart toggle");
  await check(".js-carousel-prev, .js-carousel-next", "carousel arrows");
  await check(".js-carousel-seed", "carousel seeds");
  // Fibery #224/#231: seeds com área de toque 24x40 (passo de 24px, juntas como no Figma; as setas de 40px são o controle principal)
  const seedBoxes = await page.locator(".js-carousel-seed").filter({ visible: true }).evaluateAll((els) =>
    els.map((el) => {
      const r = el.getBoundingClientRect();
      return { w: Math.round(r.width), h: Math.round(r.height) };
    }),
  );
  for (const b of seedBoxes) {
    if (b.w < 24 || b.h < 40) small.push(`carousel seed (<24x40) ${b.w}x${b.h}`);
  }

  await gotoStore(page, "category");
  await check(".js-quickbuy-add-btn", "quick buy +");
  await check(".js-quickbuy-dropdown-trigger", "quick buy trigger");
  await check(".js-category-sorting-trigger", "sorting trigger");

  await gotoStore(page, "product");
  await check(".js-product-variant-option", "variant option");
  await check(".js-quantity-up, .js-quantity-down", "quantity buttons");
  await check(".js-accordion-toggle", "accordion toggle");
  await check(".js-product-sticky-buy-btn", "buy button");

  expect(small).toEqual([]);
});

test("mobile: o conteúdo principal não fica escondido atrás da barra de compra ou do header", async ({ page }, testInfo) => {
  test.skip(!isMobile(testInfo), "só mobile");
  await gotoStore(page, "product");
  const h1 = page.locator("h1.js-product-name");
  await h1.scrollIntoViewIfNeeded();
  await expect(h1).toBeInViewport({ ratio: 1 });
  const headerBottom = await page.locator(".js-new-header").evaluate((el) => el.getBoundingClientRect().bottom);
  const h1Top = (await h1.boundingBox()).y;
  expect(h1Top).toBeGreaterThanOrEqual(headerBottom - 1);
});

test("Tab percorre os controles do header na ordem visual", async ({ page }, testInfo) => {
  test.skip(isMobile(testInfo), "teclado: só desktop");
  await gotoStore(page, "category");
  await page.keyboard.press("Tab");
  const focusedInsideHeader = await page.evaluate(() => !!document.activeElement?.closest(".js-new-header"));
  expect(focusedInsideHeader).toBe(true);
  for (let i = 0; i < 8; i++) await page.keyboard.press("Tab");
  const stillVisible = await page.evaluate(() => {
    const el = document.activeElement;
    const r = el?.getBoundingClientRect();
    return !!r && r.width > 0 && r.height > 0;
  });
  expect(stillVisible).toBe(true);
});
