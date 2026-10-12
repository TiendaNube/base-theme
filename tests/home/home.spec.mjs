import { test, expect } from "@playwright/test";
import { gotoStore } from "../helpers.mjs";

// snipplets/home/* roteados por home-section-switch.tpl (ADR-0009) e os módulos
// __src/js/modules/home/*. Só as seções no padrão novo são testadas (B do inventário).

const swiperOf = (page, selector) => page.evaluate((s) => document.querySelector(s)?.swiper?.realIndex ?? null, selector);
// O Swiper descarta cliques nas setas enquanto a transição (300 ms) roda; espera como um usuário esperaria.
const settled = (page, selector) => page.waitForFunction((s) => document.querySelector(s)?.swiper?.animating === false, selector);

test.describe("carrossel de produtos", () => {
  test("renderiza cards com link, nome e preço", async ({ page }) => {
    await gotoStore(page, "home");
    const section = page.locator(".js-product-carousel");
    await expect(section).toBeVisible();
    const cards = section.locator(".js-carousel-tab:not(.hidden) .swiper-slide[data-product-id]");
    expect(await cards.count()).toBeGreaterThan(0);
    const card = cards.first();
    await expect(card.locator('a[href*="/produtos/"]').first()).toBeAttached();
    expect((await card.getAttribute("data-product-name"))?.trim()).not.toBe("");
    await expect(card.locator("a").last()).toHaveText(/\S/);
    await expect(card).toContainText(/R\$/);
  });

  test("setas mudam o slide ativo e a seed acompanha", async ({ page }) => {
    await gotoStore(page, "home");
    const container = ".js-carousel-tab:not(.hidden) [class*='js-swiper-product-carousel']";
    await page.waitForFunction((s) => !!document.querySelector(s)?.swiper, container);
    const before = await swiperOf(page, container);

    await page.locator(".js-carousel-next").filter({ visible: true }).first().click();
    await expect.poll(() => swiperOf(page, container)).not.toBe(before);

    const seeds = page.locator(".js-carousel-pagination .js-carousel-seed");
    expect(await seeds.count()).toBeGreaterThan(1);
    const realIndex = await swiperOf(page, container);
    const seedCount = await seeds.count();
    // o fill opaco (ativo) é o da seed do slide atual
    const fills = await seeds.locator("path").evaluateAll((els) => els.map((e) => e.getAttribute("fill")));
    expect(fills.filter((f) => !/color-mix/.test(f))).toHaveLength(1);
    expect(fills.findIndex((f) => !/color-mix/.test(f))).toBe(realIndex % seedCount);

    await settled(page, container);
    await page.locator(".js-carousel-prev").filter({ visible: true }).first().click();
    await expect.poll(() => swiperOf(page, container)).toBe(before);
  });

  test("clicar numa seed vai para o slide dela", async ({ page }) => {
    await gotoStore(page, "home");
    const container = ".js-carousel-tab:not(.hidden) [class*='js-swiper-product-carousel']";
    await page.waitForFunction((s) => !!document.querySelector(s)?.swiper, container);
    const seeds = page.locator(".js-carousel-pagination .js-carousel-seed");
    test.skip((await seeds.count()) < 3, "poucos produtos no carrossel");
    await settled(page, container);
    await seeds.nth(2).click();
    await expect.poll(() => swiperOf(page, container)).toBe(2);
  });

  test("o dropdown de abas troca o carrossel visível", async ({ page }) => {
    await gotoStore(page, "home");
    const options = page.locator(".js-carousel-dropdown-option");
    test.skip((await options.count()) < 2, "carrossel com uma aba só");

    const trigger = page.locator(".js-carousel-dropdown-trigger");
    await trigger.click();
    await expect(page.locator(".js-carousel-dropdown-list")).toBeVisible();
    await expect(trigger).toHaveAttribute("aria-expanded", "true");

    const second = options.nth(1);
    const value = await second.getAttribute("data-value");
    const label = (await second.textContent()).trim();
    await second.click();

    await expect(page.locator(".js-carousel-dropdown-list")).toBeHidden();
    await expect(page.locator(".js-carousel-dropdown-label")).toHaveText(label);
    await expect(page.locator(`.js-carousel-tab[data-tab="${value}"]`)).toBeVisible();
    await expect(page.locator(".js-carousel-tab").first()).toBeHidden();
    await expect(second).toHaveAttribute("data-selected", "true");
  });

  test("clique fora fecha o dropdown de abas", async ({ page }) => {
    await gotoStore(page, "home");
    const trigger = page.locator(".js-carousel-dropdown-trigger");
    test.skip((await trigger.count()) === 0, "sem dropdown");
    await trigger.click();
    await expect(page.locator(".js-carousel-dropdown-list")).toBeVisible();
    await page.locator('[data-store="home-product-carousel"]').click({ position: { x: 4, y: 4 } });
    await expect(page.locator(".js-carousel-dropdown-list")).toBeHidden();
  });
});

test.describe("hero banner 2", () => {
  test("renderiza pelo menos um slide com conteúdo", async ({ page }) => {
    await gotoStore(page, "home");
    const section = page.locator(".js-hero-banner-2");
    test.skip((await section.count()) === 0, "seção não configurada");
    await expect(section).toBeVisible();
    expect(await section.locator(".js-hero2-slide").count()).toBeGreaterThan(0);
  });

  test("com 2 slides, setas e seeds trocam o slide", async ({ page }) => {
    await gotoStore(page, "home");
    const slides = page.locator(".js-hero-banner-2 .js-hero2-slide");
    test.skip((await slides.count()) < 2, "um slide só: sem navegação");
    await page.locator(".js-hero2-next").click();
    await expect(slides.nth(1)).toBeVisible();
    await expect(page.locator(".js-hero2-pagination .js-hero2-seed").nth(1).locator("path")).not.toHaveAttribute("fill", /0\.4\)/);
  });
});

test.describe("FAQ", () => {
  test("pergunta abre e fecha a resposta", async ({ page }) => {
    await gotoStore(page, "home");
    const toggles = page.locator(".js-faq-accordion-toggle");
    test.skip((await toggles.count()) === 0, "FAQ não configurado");

    const first = toggles.first();
    const content = first.locator("xpath=following-sibling::*[contains(@class,'js-faq-accordion-content')][1]");
    await first.scrollIntoViewIfNeeded();
    const wasHidden = await content.isHidden();
    await first.click();
    wasHidden ? await expect(content).toBeVisible() : await expect(content).toBeHidden();
    await first.click();
    wasHidden ? await expect(content).toBeHidden() : await expect(content).toBeVisible();
  });
});

test.describe("grid de produtos e grupo VIP", () => {
  test("o grid tem cards que levam à PDP", async ({ page }) => {
    await gotoStore(page, "home");
    const grid = page.locator('[data-store="home-product-grid"]');
    test.skip((await grid.count()) === 0, "seção não configurada");
    const cards = grid.locator("[data-product-id]");
    expect(await cards.count()).toBeGreaterThan(0);
    const link = cards.first().locator('a[href*="/produtos/"]').first();
    const href = await link.getAttribute("href");
    await link.click();
    await page.waitForURL((url) => url.href.startsWith(new URL(href, page.url()).href));
    await expect(page.locator("h1.js-product-name")).toBeVisible();
  });

  test("o grupo VIP tem botão com link", async ({ page }) => {
    await gotoStore(page, "home");
    const vip = page.locator('[data-store="home-vip-group"]');
    test.skip((await vip.count()) === 0, "seção não configurada");
    await vip.scrollIntoViewIfNeeded();
    const cta = vip.locator("a[href]").filter({ visible: true }).first();
    await expect(cta).toBeVisible();
    expect(await cta.getAttribute("href")).toMatch(/\S/);
  });

  test("o marquee promocional está visível", async ({ page }) => {
    await gotoStore(page, "home");
    const marquee = page.locator('[data-store="home-promo-marquee"]');
    test.skip((await marquee.count()) === 0, "seção não configurada");
    await expect(marquee).toBeVisible();
    await expect(marquee).toContainText(/\S/);
  });
});
