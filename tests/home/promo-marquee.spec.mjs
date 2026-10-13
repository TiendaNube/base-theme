import { test, expect } from "@playwright/test";
import { gotoStore } from "../helpers.mjs";

// Fibery #291 — snipplets/home/home-promo-marquee.tpl: velocidade, pausa no hover e link
// por mensagem (settings.promo_marquee_*). Os padrões preservam o comportamento antigo
// (30s, sem pausa, sem links); o que depende de opção do admin pula quando não está ligada.

const SECTION = "section.promo-marquee-section";
const TRACK = `${SECTION} .promo-marquee-track`;

test.describe("faixa promocional", () => {
  test("anima o trilho e expõe velocidade e pausa como data-*", async ({ page }) => {
    await gotoStore(page, "home");
    const section = page.locator(SECTION).first();
    await expect(section).toBeAttached();

    const speed = await section.getAttribute("data-speed");
    expect(["slow", "normal", "fast"]).toContain(speed);
    expect(["0", "1"]).toContain(await section.getAttribute("data-pause-hover"));

    const duration = await page.locator(TRACK).first().evaluate((el) => getComputedStyle(el).animationDuration);
    const expected = { slow: "50s", normal: "30s", fast: "18s" }[speed];
    // prefers-reduced-motion desliga a animação; fora disso a duração segue o data-speed
    expect([expected, "0s"]).toContain(duration);
  });

  test("pausa ao passar o mouse só quando a opção está ligada", async ({ page, isMobile }) => {
    test.skip(isMobile, "hover não existe no mobile");
    await gotoStore(page, "home");
    const section = page.locator(SECTION).first();
    const track = page.locator(TRACK).first();
    const enabled = (await section.getAttribute("data-pause-hover")) === "1";

    await section.scrollIntoViewIfNeeded();
    await section.hover();
    const state = await track.evaluate((el) => getComputedStyle(el).animationPlayState);
    expect(state).toBe(enabled ? "paused" : "running");
  });

  test("mensagens com link são âncoras na 1ª cópia; as cópias do loop ficam ocultas aos leitores", async ({ page }) => {
    await gotoStore(page, "home");
    const links = page.locator(`${SECTION} a.promo-marquee-item`);
    test.skip((await links.count()) === 0, "nenhum link configurado na loja");

    const first = links.first();
    expect(await first.getAttribute("href")).toMatch(/\S/);
    expect(await first.getAttribute("aria-hidden")).toBeNull();
    const copies = page.locator(`${SECTION} a.promo-marquee-item[aria-hidden="true"]`);
    expect(await copies.count()).toBeGreaterThan(0);
    await expect(copies.first()).toHaveAttribute("tabindex", "-1");
  });
});
