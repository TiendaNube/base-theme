// Shared helpers for preview tests.

/** Block requests to the outside world: the preview is offline by design. */
export async function offline(page) {
  await page.route(/^https?:\/\/(?!localhost)/, (route) => route.abort());
}

/**
 * Collect console errors and page crashes. Network errors for blocked external
 * hosts are expected and filtered out.
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

export async function gotoPreview(page, name) {
  await offline(page);
  const errors = collectErrors(page);
  await page.goto(`/${name}.html`);
  await page.waitForLoadState("load");
  return errors;
}
