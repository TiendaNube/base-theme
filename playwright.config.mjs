import { defineConfig, devices } from "@playwright/test";

// Two targets, same tests (see tests/preview.helpers.mjs):
//   preview-*  → local Twig renderer (tools/preview), offline. Default.
//   real-*     → a Nuvemshop store (the dev store), only when ROMA_STORE_URL is set:
//                ROMA_STORE_URL=https://democamisetasromadev.lojavirtualnuvem.com.br \
//                npx playwright test --project=real-desktop --headed
//                Nuvemshop sits behind a Cloudflare challenge that blocks datacenter
//                IPs and sometimes headless browsers — run it from a workstation, headed.

const PORT = Number(process.env.PREVIEW_PORT || 4321);
export const STORE_URL = process.env.ROMA_STORE_URL?.replace(/\/$/, "");

const mobile = { ...devices["Pixel 7"] };
const desktop = { ...devices["Desktop Chrome"], viewport: { width: 1440, height: 900 } };

export default defineConfig({
  testDir: "tests",
  outputDir: ".preview/test-results",
  fullyParallel: true,
  reporter: [["list"]],
  use: { screenshot: "only-on-failure" },
  projects: [
    { name: "preview-mobile", use: { ...mobile, baseURL: `http://localhost:${PORT}` } },
    { name: "preview-desktop", use: { ...desktop, baseURL: `http://localhost:${PORT}` } },
    ...(STORE_URL
      ? [
          { name: "real-mobile", use: { ...mobile, baseURL: STORE_URL } },
          { name: "real-desktop", use: { ...desktop, baseURL: STORE_URL } },
        ]
      : []),
  ],
  webServer: {
    command: "node tools/preview/serve.mjs",
    port: PORT,
    reuseExistingServer: !process.env.CI,
  },
});
