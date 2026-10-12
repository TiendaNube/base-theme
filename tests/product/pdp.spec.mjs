import { test, expect } from "@playwright/test";
import {
  gotoStore,
  isMobile,
  visible,
  money,
  readVariants,
  readVariantOptions,
  lastToast,
  cartCount,
  expectCartCount,
  addToCartFromPdp,
  openCartDrawer,
  expectScrollUnlocked,
  PRODUCTS,
} from "../helpers.mjs";

// templates/product.tpl + snipplets/product/* + __src/js/modules/product/*
// Critérios de aceite das specs docs/specs/pagina-de-produto/01..12 (09 fica fora).

const priceOf = (page) => page.locator("#price_display").textContent().then(money);
const selectedOption = (page) => page.locator('.js-product-variant-option[data-selected="true"]').first();

test.describe("cabeçalho e preço (spec 01, 12)", () => {
  test("h1, breadcrumb e preço visíveis; sem grid Bootstrap", async ({ page }) => {
    await gotoStore(page, "product");
    await expect(page.locator("h1.js-product-name")).toBeVisible();
    await expect(page.locator("#single-product nav, #single-product [class*=breadcrumb], .breadcrumbs").first()).toBeAttached();
    await expect(page.locator("#price_display")).toBeVisible();
    await expect(page.locator("#single-product .container, #single-product .row, #single-product [class^='col-']")).toHaveCount(0);
  });

  test("preço 'de' aparece só quando a variante tem compare_at_price", async ({ page }) => {
    await gotoStore(page, "product");
    const variants = await readVariants(page);
    const selected = await selectedOption(page).getAttribute("data-option-name").catch(() => null);
    const variant = selected ? variants.find((v) => v.option0 === selected) : variants[0];
    const compare = page.locator("#compare_price_display");
    if (variant?.compare_at_price_short) {
      await expect(compare).toBeVisible();
      expect(money(await compare.textContent())).toBeCloseTo(money(variant.compare_at_price_short), 2);
    } else {
      await expect(compare).toBeHidden();
    }
  });

  test("a página inteira usa a cor de fundo do tema (sem faixa branca)", async ({ page }) => {
    await gotoStore(page, "product");
    const { wrapper, theme } = await page.evaluate(() => {
      const probe = document.createElement("div");
      probe.style.backgroundColor = "var(--background-color)";
      document.body.appendChild(probe);
      const theme = getComputedStyle(probe).backgroundColor;
      probe.remove();
      const wrapper = getComputedStyle(document.querySelector("#single-product").closest(".bg-bg") || document.body).backgroundColor;
      return { wrapper, theme };
    });
    expect(wrapper).toBe(theme);
  });
});

test.describe("variantes (spec 04)", () => {
  test("opções esgotadas desabilitadas e a primeira disponível selecionada", async ({ page }) => {
    await gotoStore(page, PRODUCTS.withSoldOutOption);
    const variants = await readVariants(page);
    const options = await readVariantOptions(page);
    test.skip(options.length === 0, "produto sem variações");

    for (const o of options) {
      const available = variants.some((v) => v.option0 === o.name && v.available);
      expect(o.disabled, `${o.name} desabilitada`).toBe(!available);
    }
    const firstAvailable = options.find((o) => !o.disabled);
    expect(options.filter((o) => o.selected).map((o) => o.name)).toEqual([firstAvailable.name]);
    // sem <select> legado: LS.changeVariant nunca roda
    await expect(page.locator("#product_form select, .js-variation-option, .js-insta-variant")).toHaveCount(0);
  });

  test("trocar a opção atualiza preço, preço 'de' e o preço da barra", async ({ page }, testInfo) => {
    await gotoStore(page, "product");
    const variants = await readVariants(page);
    const options = await readVariantOptions(page);
    const target = options.find((o) => !o.disabled && !o.selected);
    test.skip(!target, "só uma opção disponível");
    const variant = variants.find((v) => v.option0 === target.name && v.available);

    const option = page.locator(`.js-product-variant-option[data-option-name="${target.name}"]`).first();
    await option.click();
    await expect(option).toHaveAttribute("data-selected", "true");
    await expect(option).toHaveClass(/bg-control/);
    await expect(page.locator("#price_display")).toHaveText(variant.price_short);

    const compare = page.locator("#compare_price_display");
    if (variant.compare_at_price_short) await expect(compare).toContainText(variant.compare_at_price_short);
    else await expect(compare).toBeHidden();

    if (isMobile(testInfo)) {
      await expect(page.locator(".js-sticky-price-display")).toHaveText(variant.price_short);
    }
  });

  test("produto todo esgotado: botão 'sem estoque' desabilitado e todas as opções riscadas", async ({ page }) => {
    await gotoStore(page, PRODUCTS.allSoldOut);
    const variants = await readVariants(page);
    test.skip(variants.some((v) => v.available), "o produto voltou a ter estoque; troque PRODUCTS.allSoldOut");

    const btn = page.locator(".js-product-sticky-buy-btn");
    await expect(btn).toHaveAttribute("data-state", "nostock");
    await expect(btn).toBeDisabled();
    const options = await readVariantOptions(page);
    expect(options.every((o) => o.disabled)).toBe(true);
    // clicar não navega nem adiciona
    await btn.click({ force: true });
    await page.waitForTimeout(1500);
    expect(page.url()).toContain(PRODUCTS.allSoldOut);
    expect(await cartCount(page)).toBe(0);
  });
});

test.describe("quantidade (spec 05)", () => {
  test("− não desce de 1 e + sobe", async ({ page }) => {
    await gotoStore(page, "product");
    const input = page.locator(".js-quantity-input");
    await expect(input).toHaveValue("1");
    await page.locator(".js-quantity-down").click();
    await expect(input).toHaveValue("1");
    await page.locator(".js-quantity-up").click();
    await expect(input).toHaveValue("2");
    await page.locator(".js-quantity-down").click();
    await expect(input).toHaveValue("1");
  });

  test("+ para no estoque da variante, desabilita e avisa com toast", async ({ page }) => {
    await gotoStore(page, PRODUCTS.lowStock);
    const variants = await readVariants(page);
    const options = await readVariantOptions(page);
    const candidate = variants
      .filter((v) => v.available && v.stock !== null && v.stock >= 1 && v.stock <= 4)
      .sort((a, b) => a.stock - b.stock)[0];
    test.skip(!candidate, "nenhuma variante com estoque entre 1 e 4; troque PRODUCTS.lowStock");

    const option = page.locator(`.js-product-variant-option[data-option-name="${candidate.option0}"]`).first();
    if (options.length) await option.click();

    const input = page.locator(".js-quantity-input");
    const up = page.locator(".js-quantity-up");
    await expect(input).toHaveAttribute("max", String(candidate.stock));
    for (let i = 1; i < candidate.stock; i++) await up.click();
    await expect(input).toHaveValue(String(candidate.stock));
    await expect(up).toHaveAttribute("aria-disabled", "true");

    // aria-disabled faz o Playwright recusar o clique; o usuário real clica mesmo assim e deve ver o aviso
    await up.click({ force: true });
    await expect(input).toHaveValue(String(candidate.stock));
    await expect(lastToast(page)).toContainText(String(candidate.stock));
  });

  test("valor digitado acima do estoque é limitado", async ({ page }) => {
    await gotoStore(page, "product");
    const variants = await readVariants(page);
    const selected = await selectedOption(page).getAttribute("data-option-name").catch(() => null);
    const variant = selected ? variants.find((v) => v.option0 === selected) : variants[0];
    test.skip(variant?.stock == null, "variante com estoque ilimitado");
    const input = page.locator(".js-quantity-input");
    await input.fill(String(variant.stock + 50));
    await input.blur();
    await expect(input).toHaveValue(String(variant.stock));
  });
});

test.describe("galeria e zoom (specs 02, 03)", () => {
  test("mobile: carrossel visível; desktop: grade com todas as fotos e sem carrossel", async ({ page }, testInfo) => {
    await gotoStore(page, "product");
    const gallery = page.locator(".js-product-gallery");
    const slides = gallery.locator(".swiper-slide");
    const count = await slides.count();
    expect(count).toBeGreaterThan(0);
    if (isMobile(testInfo)) {
      await expect(gallery).toBeVisible();
      await expect(gallery.locator("img").first()).toBeVisible();
    } else {
      await expect(gallery).toBeHidden();
      const grid = page.locator("#single-product .lg\\:grid");
      await expect(grid.first()).toBeVisible();
      expect(await grid.first().locator("[data-open-gallery-zoom]").count()).toBe(count);
    }
  });

  test("mobile: setas e seeds navegam entre fotos", async ({ page }, testInfo) => {
    test.skip(!isMobile(testInfo), "só mobile");
    await gotoStore(page, "product");
    const gallery = page.locator(".js-product-gallery");
    test.skip((await gallery.locator(".swiper-slide").count()) < 2, "produto com uma foto só");
    await page.locator(".js-product-gallery-next").click();
    await expect(gallery).toHaveAttribute("data-active-position", /^[1-9]/);
    await page.locator(".js-product-gallery-prev").click();
    await expect(gallery).toHaveAttribute("data-active-position", "0");
  });

  test("clicar na foto abre o zoom na foto certa; Esc, X e backdrop fecham devolvendo a rolagem", async ({ page }) => {
    await gotoStore(page, "product");
    const zoom = page.locator(".js-product-gallery-zoom");
    const trigger = visible(page.locator("[data-open-gallery-zoom]")).first();
    const position = await trigger.evaluate((el) => el.closest("[data-image-position]")?.dataset.imagePosition ?? "0");

    await trigger.click();
    await expect(zoom).toHaveAttribute("data-state", "open");
    await expect.poll(() => page.evaluate(() => document.body.style.overflow)).toBe("hidden");
    await expect(zoom.locator(".swiper-slide-active")).toHaveAttribute("data-image-position", position);

    await page.keyboard.press("Escape");
    await expect(zoom).toHaveAttribute("data-state", "closed");
    await expectScrollUnlocked(page);

    await trigger.click();
    await expect(zoom).toHaveAttribute("data-state", "open");
    await zoom.locator(".js-product-gallery-zoom-close").click();
    await expect(zoom).toHaveAttribute("data-state", "closed");

    expect(page.url()).not.toMatch(/\.(jpg|png|webp)/);
  });

  test("clicar fora da foto (no fundo escuro) fecha o zoom", async ({ page }) => {
    await gotoStore(page, "product");
    const zoom = page.locator(".js-product-gallery-zoom");
    await visible(page.locator("[data-open-gallery-zoom]")).first().click();
    await expect(zoom).toHaveAttribute("data-state", "open");
    // espera o scale(.95→1) terminar: durante a transição o content não cobre as bordas e o clique cai no backdrop
    await expect
      .poll(() => zoom.locator(".js-product-gallery-zoom-content").evaluate((el) => getComputedStyle(el).transform))
      .toMatch(/^(none|matrix\(1, 0, 0, 1, 0, 0\))$/);
    // canto inferior esquerdo: fora da foto, longe do X e das seeds
    await page.mouse.click(8, page.viewportSize().height - 80);
    await expect(zoom).toHaveAttribute("data-state", "closed");
  });
});

test.describe("accordions (spec 08)", () => {
  test("descrição abre por padrão e fecha no toggle, trocando o ícone", async ({ page }) => {
    await gotoStore(page, "product");
    const item = page.locator(".js-accordion-item").first();
    test.skip((await item.count()) === 0, "produto sem descrição");
    const toggle = item.locator(".js-accordion-toggle");
    const content = item.locator(".js-accordion-content");

    await expect(item).toHaveAttribute("data-state", "open");
    await expect(toggle).toHaveAttribute("aria-expanded", "true");
    await expect(content).toBeVisible();
    await expect(item.locator(".lucide-minus, [data-lucide=minus]")).toHaveCount(1);

    await toggle.click();
    await expect(item).toHaveAttribute("data-state", "closed");
    await expect(content).toBeHidden();
    await expect(item.locator(".lucide-plus, [data-lucide=plus]")).toHaveCount(1);

    await toggle.click();
    await expect(item).toHaveAttribute("data-state", "open");
  });

  test("tabela de medidas fechada por padrão; o link ao lado dos tamanhos abre e rola até ela", async ({ page }) => {
    await gotoStore(page, "product");
    const guide = page.locator("#tabela-de-medidas");
    test.skip((await guide.count()) === 0, "loja sem size_guide_url configurado");
    await expect(guide).toHaveAttribute("data-state", "closed");
    await page.locator('a[href="#tabela-de-medidas"]').click();
    await expect(guide).toHaveAttribute("data-state", "open");
    await expect(guide).toBeInViewport();
  });
});

test.describe("calculadora de frete (spec 06)", () => {
  test("CEP inválido mostra erro; CEP válido mostra opções", async ({ page }) => {
    await gotoStore(page, "product");
    const input = page.locator(".js-shipping-input");
    test.skip((await input.count()) === 0, "calculadora desligada na loja");
    const button = page.locator(".js-calculate-shipping");

    await input.fill("00000000");
    await button.click();
    await expect(page.locator(".js-ship-calculator-error, .js-ship-calculator-common-error, .js-ship-calculator-external-error").filter({ visible: true }).first()).toBeVisible({ timeout: 20_000 });

    await input.fill("01310100");
    await button.click();
    await expect(page.locator(".js-shipping-calculator-response")).toBeVisible({ timeout: 25_000 });
    await expect(page.locator(".js-shipping-calculator-response")).toContainText(/R\$|grátis|gratis/i);
  });

  test("Enter no campo de CEP não adiciona ao carrinho", async ({ page }) => {
    await gotoStore(page, "product");
    const input = page.locator(".js-shipping-input");
    test.skip((await input.count()) === 0, "calculadora desligada na loja");
    await input.fill("01310100");
    await input.press("Enter");
    await page.waitForTimeout(2500);
    expect(await cartCount(page)).toBe(0);
    expect(page.url()).toMatch(/\/produtos\//);
  });
});

test.describe("barra de compra (specs 07, 11)", () => {
  test("mobile: fixa no rodapé da tela com preço e botão; desktop: no fluxo da coluna", async ({ page }, testInfo) => {
    await gotoStore(page, "product");
    const bar = page.locator(".js-product-sticky-buy-bar");
    await expect(bar).toBeVisible();
    const position = await bar.evaluate((el) => getComputedStyle(el).position);
    if (isMobile(testInfo)) {
      expect(position).toBe("fixed");
      const box = await bar.boundingBox();
      expect(Math.abs(box.y + box.height - page.viewportSize().height)).toBeLessThanOrEqual(2);
      await expect(page.locator(".js-sticky-price-display")).toBeVisible();
      // no fim da página, o último conteúdo do rodapé fica inteiro acima da barra
      await page.evaluate(() => window.scrollTo(0, document.documentElement.scrollHeight));
      const lastContentBottom = await page.locator("footer.js-footer").evaluate((footer) => {
        const els = [...footer.querySelectorAll("a, p, img, svg, span")].filter((el) => el.getClientRects().length);
        return Math.max(...els.map((el) => el.getBoundingClientRect().bottom));
      });
      const barTop = (await bar.boundingBox()).y;
      expect(lastContentBottom).toBeLessThanOrEqual(barTop + 1);
    } else {
      expect(position).not.toBe("fixed");
      await expect(page.locator(".js-sticky-price-display")).toBeHidden();
    }
    await expect(page.locator(".js-product-sticky-buy-btn")).toHaveText(/\S/);
  });

  test("comprar adiciona sem recarregar: toast com nome, variação e quantidade; drawer recebe o item", async ({ page }) => {
    await gotoStore(page, "product");
    const url = page.url();
    const variant = await selectedOption(page).getAttribute("data-option-name").catch(() => null);
    await page.locator(".js-quantity-up").click();
    const { toast, name } = await addToCartFromPdp(page, { expectedCount: 2 });

    expect(page.url()).toBe(url);
    await expect(toast).toContainText("Qtd: 2");
    if (variant) await expect(toast).toContainText(variant);
    await expect(page.locator(".js-cart-drawer")).toHaveAttribute("data-state", "closed");

    await openCartDrawer(page);
    const item = page.locator(".js-cart-drawer .js-cart-item").filter({ visible: true }).first();
    await expect(item).toBeVisible({ timeout: 15_000 });
    await expect(item).toContainText(name.slice(0, 15));
    await expect(item.locator(".js-cart-quantity-input")).toHaveValue("2");
  });

  test("o botão volta a ficar clicável depois de adicionar e um segundo clique soma", async ({ page }) => {
    await gotoStore(page, "product");
    await addToCartFromPdp(page, { expectedCount: 1 });
    const btn = page.locator(".js-product-sticky-buy-btn");
    await expect(btn).toBeEnabled();
    await expect.poll(() => btn.evaluate((el) => el.style.pointerEvents)).toBe("");
    await btn.click();
    await expectCartCount(page, 2);
  });
});
