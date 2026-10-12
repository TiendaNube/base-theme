import { test, expect } from "@playwright/test";

// Páginas lógicas da loja de dev. Os slugs podem ser trocados por variável de
// ambiente quando o catálogo mudar (ver .env.example).
export const PATHS = {
  home: "/",
  category: process.env.ROMA_CATEGORY_PATH || "/camisetas/",
  product: process.env.ROMA_PRODUCT_PATH || "/produtos/camiseta-estonada-brita/",
  search: "/search/?q=camiseta",
  notFound: "/esta-pagina-nao-existe/",
};

// Produtos do catálogo da loja de dev com formas de estoque específicas
// (levantadas em 2026-10-12). Os testes leem o JSON de variantes da própria
// página e pulam quando a forma esperada deixou de existir — quando o estoque
// mudar, basta apontar para outro slug aqui.
export const PRODUCTS = {
  withSoldOutOption: "/produtos/camiseta-estonada-brita/", // P esgotado, M com 3 em estoque, preço "de"
  lowStock: "/produtos/moletom-canguru-brownie/", // M=8, XG=1, resto esgotado
  allSoldOut: "/produtos/comemorativa-camiseta-outubro-rosa-2024/",
  inStock: "/produtos/camiseta-leve-branca/",
};

export const isMobile = (testInfo = test.info()) => testInfo.project.name === "mobile";

/** Só elementos visíveis — vários componentes são renderizados duas vezes (desktop + mobile). */
export const visible = (locator) => locator.filter({ visible: true });

// Erros de console/página. Ruído de terceiros (recursos que não carregam,
// scripts de apps da Nuvemshop) fica de fora: o que interessa é o bundle custom.
const IGNORED = [/Failed to load resource/, /net::ERR_/, /googletagmanager|facebook|hotjar|clarity|nubesdk|tiendanube|mitiendanube/i];

export function collectErrors(page) {
  const errors = [];
  page.on("pageerror", (err) => errors.push(`pageerror: ${err.message}`));
  page.on("console", (msg) => {
    if (msg.type() !== "error") return;
    const text = msg.text();
    if (IGNORED.some((re) => re.test(text))) return;
    errors.push(`console: ${text}`);
  });
  return errors;
}

/** Abre uma página lógica (chave de PATHS) ou um caminho literal e espera o bundle subir. */
export async function gotoStore(page, pathOrKey) {
  const path = PATHS[pathOrKey] ?? pathOrKey;
  const errors = collectErrors(page);
  const response = await page.goto(path, { waitUntil: "load" });
  if (/just a moment|um momento/i.test(await page.title())) {
    throw new Error("Cloudflare challenge — rode da estação de trabalho, headed (sem PW_HEADLESS)");
  }
  await page.waitForFunction(() => typeof window.openCartDrawer === "function");
  return { errors, response };
}

export const scrollTo = (page, y) => page.evaluate((y) => window.scrollTo(0, y), y);
export const scrollY = (page) => page.evaluate(() => window.scrollY);

export async function expectScrollLocked(page) {
  await expect
    .poll(() => page.evaluate(() => document.body.style.position === "fixed" || document.body.style.overflow === "hidden"))
    .toBe(true);
}

export async function expectScrollUnlocked(page) {
  await expect
    .poll(() => page.evaluate(() => document.body.style.position === "" && document.body.style.overflow === ""))
    .toBe(true);
}

/** "R$1.234,56" → 1234.56 */
export const money = (text) => parseFloat(String(text).replace(/[^\d,]/g, "").replace(",", "."));

export const cartCount = (page) =>
  page.evaluate(() => parseInt((document.querySelector(".js-cart-widget-amount")?.textContent || "").replace(/\D/g, ""), 10) || 0);

export async function expectCartCount(page, n, timeout = 15_000) {
  await expect.poll(() => cartCount(page), { timeout }).toBe(n);
}

/** Variantes serializadas pela própria PDP (#single-product[data-variants]). */
export const readVariants = (page) =>
  page.evaluate(() => {
    const raw =
      document.querySelector("#single-product")?.getAttribute("data-variants") ||
      document.querySelector(".js-product-variants-data")?.textContent;
    if (!raw) return [];
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : Object.values(parsed);
  });

/** Opções do primeiro grupo de variantes como o DOM as mostra. */
export const readVariantOptions = (page) =>
  page
    .locator(".js-product-variant-group")
    .first()
    .locator(".js-product-variant-option")
    .evaluateAll((els) =>
      els.map((el) => ({
        name: el.dataset.optionName,
        selected: el.dataset.selected === "true",
        disabled: el.classList.contains("pointer-events-none"),
      })),
    );

export const lastToast = (page) => page.locator(".js-toast-container > [data-state]").last();

/** Adiciona o produto da PDP atual pelo botão de compra e espera toast + badge. */
export async function addToCartFromPdp(page, { expectedCount = 1 } = {}) {
  const btn = page.locator(".js-product-sticky-buy-btn");
  await expect(btn).toHaveAttribute("data-state", "cart");
  const name = (await page.locator("h1.js-product-name").textContent()).trim();
  await btn.click();
  const toast = lastToast(page);
  await expect(toast).toContainText(name.slice(0, 20), { timeout: 15_000 });
  await expectCartCount(page, expectedCount);
  return { toast, name };
}

export async function openCartDrawer(page) {
  await visible(page.locator(".js-cart-drawer-toggle")).first().click();
  await expect(page.locator(".js-cart-drawer")).toHaveAttribute("data-state", "open");
}
