import { test, expect } from "@playwright/test";
import { gotoStore, isMobile } from "../helpers.mjs";

// snipplets/home/home-vip-group.tpl — Fibery #288 (lista de benefícios) + visual do #233
// (Figma 52:191 mobile / 82:3301 desktop): título serifado, mobile alinhado à esquerda,
// desktop centralizado, botão 136x40. Os benefícios vêm de 4 pares destaque+texto; o HTML
// legado (vip_group_custom_html) só aparece quando todos os pares estão vazios.

const SECTION = '[data-store="home-vip-group"]';

async function openVip(page) {
  await gotoStore(page, "home");
  const section = page.locator(SECTION).first();
  test.skip((await section.count()) === 0, "seção Grupo VIP desligada na loja de dev");
  await section.scrollIntoViewIfNeeded();
  return section;
}

test("benefícios: 1–4 itens não vazios, destaque em negrito, sem HTML legado junto", async ({ page }) => {
  const section = await openVip(page);
  const list = section.locator("[data-vip-benefits]");
  test.skip((await list.count()) === 0, "pares de benefícios vazios na loja (fallback legado ativo)");

  const items = list.locator("li");
  const count = await items.count();
  expect(count).toBeGreaterThan(0);
  expect(count).toBeLessThanOrEqual(4);
  for (let i = 0; i < count; i++) {
    const item = items.nth(i);
    await expect(item).toHaveText(/\S/);
    // bullet de semente pinta com a cor do texto (sem cor literal)
    await expect(item.locator("svg path")).toHaveAttribute("fill", "currentColor");
  }
  const strong = list.locator("li strong").first();
  if (await strong.count()) {
    const weight = await strong.evaluate((el) => Number(getComputedStyle(el).fontWeight));
    expect(weight).toBeGreaterThanOrEqual(600);
  }
  // lista nova e HTML legado nunca aparecem juntos
  await expect(section.locator(".vip-group-custom-content")).toHaveCount(0);
});

test("título serifado; mobile à esquerda, desktop centralizado", async ({ page }) => {
  const section = await openVip(page);
  const title = section.locator("h2");
  test.skip((await title.count()) === 0, "sem título configurado");

  const { titleFont, bodyFont, align } = await title.evaluate((el) => ({
    titleFont: getComputedStyle(el).fontFamily,
    bodyFont: getComputedStyle(document.body).fontFamily,
    align: getComputedStyle(el.parentElement).textAlign,
  }));
  expect(titleFont).not.toBe(bodyFont);

  const box = await title.boundingBox();
  const sectionBox = await section.boundingBox();
  if (isMobile()) {
    expect(align).toBe("left");
    // encostado no gutter de 24px, não centralizado
    expect(box.x - sectionBox.x).toBeLessThan(40);
  } else {
    expect(align).toBe("center");
    const titleCenter = box.x + box.width / 2;
    const sectionCenter = sectionBox.x + sectionBox.width / 2;
    expect(Math.abs(titleCenter - sectionCenter)).toBeLessThan(4);
  }
});

test("botão de 40px de altura e ao menos 136px, centralizado", async ({ page }) => {
  const section = await openVip(page);
  const button = section.locator("a").first();
  test.skip((await button.count()) === 0, "sem botão configurado");

  const box = await button.boundingBox();
  expect(Math.round(box.height)).toBe(40);
  expect(box.width).toBeGreaterThanOrEqual(135);
  const sectionBox = await section.boundingBox();
  expect(Math.abs(box.x + box.width / 2 - (sectionBox.x + sectionBox.width / 2))).toBeLessThan(4);
});
