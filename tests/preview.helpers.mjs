// Shared helpers. Tests are written against logical pages ("home", "product",
// "category") and run unchanged against the local preview or a real store.

import { test } from "@playwright/test";

export const isReal = (testInfo) => testInfo.project.name.startsWith("real-");

// Real-store paths: the dev store's own URLs, overridable per environment.
const REAL_PATHS = {
  home: "/",
  product: process.env.ROMA_PRODUCT_PATH || "/produtos/",
  category: process.env.ROMA_CATEGORY_PATH || "/produtos/",
};

export const pagePath = (name, testInfo) => (isReal(testInfo) ? REAL_PATHS[name] : `/${name}.html`);

/** Block requests to the outside world: the preview is offline by design. */
export async function offline(page) {
  await page.route(/^https?:\/\/(?!localhost)/, (route) => route.abort());
}

/**
 * Collect console errors and page crashes. Network errors for blocked external
 * hosts are expected in the preview and filtered out.
 */
export function collectErrors(page) {
  const errors = [];
  page.on("pageerror", (err) => errors.push(`pageerror: ${err.message}`));
  page.on("console", (msg) => {
    if (msg.type() !== "error") return;
    const text = msg.text();
    if (/net::ERR_FAILED|Failed to load resource/.test(text)) return;
    errors.push(`console: ${text}`);
  });
  return errors;
}

/**
 * Open a logical page on the current target. In the preview, external hosts
 * are blocked; on a real store nothing is blocked (the platform's own CDN
 * serves the theme). Returns the collected errors array.
 */
export async function gotoPreview(page, name, testInfo = test.info()) {
  if (!isReal(testInfo)) await offline(page);
  const errors = collectErrors(page);
  await page.goto(pagePath(name, testInfo));
  await page.waitForLoadState("load");
  if (isReal(testInfo) && (await page.title()).match(/just a moment|um momento/i)) {
    throw new Error("Cloudflare challenge page — run from a workstation with --headed, not from a datacenter IP");
  }
  return errors;
}

/** Skip a test on the real store (fixture-dependent assertions). */
export const previewOnly = (testInfo, reason = "depends on preview fixtures") => {
  test.skip(isReal(testInfo), reason);
};
