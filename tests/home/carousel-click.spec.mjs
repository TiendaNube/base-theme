import { test, expect } from "@playwright/test";
import { gotoStore } from "../helpers.mjs";

// Regression (Fibery #219): a click that wobbles a couple of pixels must open the
// product, not be read as a swipe. Swiper's default threshold (0) turned any
// 1-3 px movement into a drag that advanced a slide and cancelled the click.
test("home carousel: a slightly wobbly click opens the product", async ({ page, isMobile }) => {
  test.skip(isMobile, "mouse gesture; touch covered by the same threshold");
  await gotoStore(page, "home");

  const swiperEl = page.locator(".js-swiper-product-carousel-1");
  await expect(swiperEl).toBeVisible();
  await page.waitForFunction(() => document.querySelector(".js-swiper-product-carousel-1")?.swiper);

  const link = swiperEl.locator(".swiper-slide-active a[href]").first();
  await link.scrollIntoViewIfNeeded();
  const href = await link.getAttribute("href");
  const before = await page.evaluate(() => document.querySelector(".js-swiper-product-carousel-1").swiper.activeIndex);

  const box = await link.boundingBox();
  const x = box.x + box.width / 2;
  const y = box.y + box.height / 2;
  await page.mouse.move(x, y);
  await page.mouse.down();
  await page.mouse.move(x + 2, y, { steps: 2 });
  await page.mouse.up();

  await page.waitForURL((url) => url.href.startsWith(new URL(href, page.url()).href.split("#")[0]), { timeout: 10_000 })
    .catch(async () => {
      const after = await page.evaluate(() => document.querySelector(".js-swiper-product-carousel-1")?.swiper.activeIndex);
      throw new Error(`click did not navigate to ${href} (slide ${before} → ${after})`);
    });
});
