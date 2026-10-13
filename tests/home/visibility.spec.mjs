import { test, expect } from "@playwright/test";
import { gotoStore } from "../helpers.mjs";

// Fibery #287: cada seção nova da home tem um checkbox "<seção>_show" no admin (templates/home.tpl).
// O teste não consegue mexer no admin, então:
//  - com a configuração padrão, todas as seções configuradas aparecem e nenhum wrapper fica vazio;
//  - ROMA_HOME_HIDDEN=faq,vip_group (seções desmarcadas no admin antes de rodar) confere que elas
//    somem do HTML por completo. Sem a variável o cenário é pulado.

const SECTIONS = {
  promo_marquee: "home-promo-marquee",
  hero_banner: "home-hero-banner",
  hero_banner_2: "home-hero-banner-2",
  product_carousel: "home-product-carousel",
  product_grid: "home-product-grid",
  vip_group: "home-vip-group",
  faq: "home-faq",
};

const hidden = (process.env.ROMA_HOME_HIDDEN || "").split(",").map((s) => s.trim()).filter(Boolean);

/** Filhos diretos do container da home: data-store, altura e se têm conteúdo. */
const homeChildren = (page) =>
  page.locator(".js-home-sections-container").evaluate((root) =>
    [...root.children].map((el) => ({
      store: el.getAttribute("data-store") || "",
      height: el.getBoundingClientRect().height,
      empty: el.children.length === 0 && !el.textContent.trim() && !el.matches("[data-store^='home-divider']"),
    })),
  );

test.describe("visibilidade das seções da home (#287)", () => {
  test("nenhum wrapper de seção vazio no container", async ({ page }) => {
    await gotoStore(page, "home");
    const children = await homeChildren(page);
    expect(children.length).toBeGreaterThan(0);
    expect(children.filter((c) => c.empty)).toEqual([]);
  });

  test("seções desmarcadas no admin somem do HTML", async ({ page }) => {
    test.skip(!hidden.length, "defina ROMA_HOME_HIDDEN=<seção>,... depois de desmarcar no admin");
    await gotoStore(page, "home");
    for (const key of hidden) {
      const store = SECTIONS[key];
      expect(store, `seção desconhecida: ${key}`).toBeTruthy();
      await expect(page.locator(`[data-store="${store}"], [data-store="${store}-wrapper"]`)).toHaveCount(0);
    }
    // as demais continuam lá
    for (const [key, store] of Object.entries(SECTIONS)) {
      if (hidden.includes(key)) continue;
      expect(await page.locator(`[data-store="${store}"]`).count(), key).toBeGreaterThan(0);
    }
  });
});

// Fibery #292: divisores só entre duas seções visíveis (nunca no começo, no fim nem em dupla),
// seed depois do carrossel e branco de 64px no resto (#234). ROMA_HOME_DIVIDERS=off depois de
// desmarcar "Mostrar divisores" no admin confere que todos somem.
const dividersOff = process.env.ROMA_HOME_DIVIDERS === "off";

test.describe("divisores entre seções da home (#292)", () => {
  test("nenhum divisor sobrando ou duplicado", async ({ page }) => {
    await gotoStore(page, "home");
    const stores = (await homeChildren(page)).map((c) => c.store);
    const isDivider = (s) => s.startsWith("home-divider");
    expect(stores.length).toBeGreaterThan(0);
    expect(isDivider(stores[0]), "divisor no começo").toBe(false);
    expect(isDivider(stores[stores.length - 1]), "divisor no fim").toBe(false);
    stores.forEach((s, i) => {
      if (isDivider(s)) expect(isDivider(stores[i + 1]), `divisores em sequência em ${i}`).toBe(false);
    });
  });

  test("seed depois do carrossel, branco com 64px", async ({ page }) => {
    test.skip(dividersOff, "divisores desligados no admin");
    await gotoStore(page, "home");
    const children = await homeChildren(page);
    const stores = children.map((c) => c.store);
    const carousel = stores.indexOf("home-product-carousel");
    test.skip(carousel < 0 || carousel === stores.length - 1, "carrossel ausente ou última seção");
    expect(stores[carousel + 1]).toBe("home-divider-seed");
    for (const c of children.filter((c) => c.store.startsWith("home-divider"))) {
      expect(Math.round(c.height)).toBe(64);
    }
    const white = page.locator('[data-store="home-divider-white"]').first();
    if (await white.count()) {
      const [divider, token] = await Promise.all([
        white.evaluate((el) => getComputedStyle(el).backgroundColor),
        page.evaluate(() => {
          const probe = document.body.appendChild(Object.assign(document.createElement("div"), { className: "bg-bg" }));
          const color = getComputedStyle(probe).backgroundColor;
          probe.remove();
          return color;
        }),
      ]);
      expect(divider).toBe(token); // token bg-bg (some no fundo), nunca cor literal
    }
  });

  test("checkbox global desliga todos os divisores", async ({ page }) => {
    test.skip(!dividersOff, "defina ROMA_HOME_DIVIDERS=off depois de desmarcar no admin");
    await gotoStore(page, "home");
    await expect(page.locator('[data-store^="home-divider"]')).toHaveCount(0);
  });
});
