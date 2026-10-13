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
