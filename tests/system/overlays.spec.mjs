import { test, expect } from "@playwright/test";
import { gotoStore, expectScrollUnlocked, lastToast } from "../helpers.mjs";

// __src/js/modules/system/toast.js e modal.js — API pública window.* (ADR-0006 E).

test.describe("toast", () => {
  test("texto aparece, fecha pelo X", async ({ page }) => {
    await gotoStore(page, "home");
    await page.evaluate(() => window.showToast({ message: "Olá do teste", icon: "alert-circle" }));
    const toast = lastToast(page);
    await expect(toast).toHaveAttribute("data-state", "visible");
    await expect(toast).toContainText("Olá do teste");
    await expect(toast.locator(".js-toast-close")).toHaveAttribute("aria-label", /.+/);
    await toast.locator(".js-toast-close").click();
    await expect(page.locator(".js-toast-container > [data-state]")).toHaveCount(0, { timeout: 3_000 });
  });

  test("some sozinho em ~4s", async ({ page }) => {
    await gotoStore(page, "home");
    await page.evaluate(() => window.showToast({ message: "Efêmero" }));
    await expect(lastToast(page)).toHaveAttribute("data-state", "visible");
    await expect(page.locator(".js-toast-container > [data-state]")).toHaveCount(0, { timeout: 6_000 });
  });

  test("toast de produto mostra imagem, nome, variação, preço e quantidade", async ({ page }) => {
    await gotoStore(page, "home");
    await page.evaluate(() =>
      window.showProductToast({ image: "/favicon.ico", name: "Produto X", price: "R$10,00", quantity: 2, variation: "M" }),
    );
    const toast = lastToast(page);
    await expect(toast).toContainText("Produto X");
    await expect(toast).toContainText("R$10,00");
    await expect(toast).toContainText("Qtd: 2");
    await expect(toast).toContainText("M");
    await expect(toast.locator("img")).toHaveAttribute("alt", "Produto X");
  });

  test("o toast fica abaixo do header, não por cima dele", async ({ page }) => {
    await gotoStore(page, "home");
    await page.evaluate(() => window.showToast({ message: "Posição" }));
    const toast = lastToast(page);
    await expect(toast).toHaveAttribute("data-state", "visible");
    const headerBottom = await page.locator(".js-new-header").evaluate((el) => el.getBoundingClientRect().bottom);
    const toastTop = (await toast.boundingBox()).y;
    expect(toastTop).toBeGreaterThanOrEqual(headerBottom - 1);
  });
});

test.describe("modal genérico", () => {
  test("abre por window.openModal com título e conteúdo; Esc fecha e devolve a rolagem", async ({ page }) => {
    await gotoStore(page, "home");
    await page.evaluate(() => window.openModal({ title: "Título de teste", content: "<p>corpo</p>" }));
    const container = page.locator(".js-gaius-modal-container");
    await expect(container).toHaveAttribute("data-state", "open");
    await expect(container.locator("h2")).toHaveText("Título de teste");
    await expect(container.locator(".js-gaius-modal-body")).toContainText("corpo");
    await expect.poll(() => page.evaluate(() => document.body.style.overflow)).toBe("hidden");

    await page.keyboard.press("Escape");
    await expect(container).toHaveAttribute("data-state", "closed");
    await expectScrollUnlocked(page);
  });

  test("clique no overlay e no X fecham", async ({ page }) => {
    await gotoStore(page, "home");
    const container = page.locator(".js-gaius-modal-container");

    await page.evaluate(() => window.openModal({ title: "A", content: "x" }));
    await expect(container).toHaveAttribute("data-state", "open");
    await container.locator(".js-gaius-modal-close").click();
    await expect(container).toHaveAttribute("data-state", "closed");

    await page.evaluate(() => window.openModal({ title: "B", content: "y" }));
    await expect(container).toHaveAttribute("data-state", "open");
    await container.locator(".js-gaius-modal-overlay").click({ position: { x: 5, y: 5 } });
    await expect(container).toHaveAttribute("data-state", "closed");
  });

  test("modo drawer vem de baixo", async ({ page }) => {
    await gotoStore(page, "home");
    await page.evaluate(() => window.openModal({ title: "Drawer", content: "z", mode: "drawer" }));
    const content = page.locator(".js-gaius-modal-content");
    await expect(content).toHaveClass(/js-gaius-modal-drawer/);
    const box = await content.boundingBox();
    const viewport = page.viewportSize();
    expect(Math.abs(box.y + box.height - viewport.height)).toBeLessThanOrEqual(2);
  });
});
