import { defineConfig, devices } from "@playwright/test";

const PORT = Number(process.env.PREVIEW_PORT || 4321);

export default defineConfig({
  testDir: "tests",
  outputDir: ".preview/test-results",
  fullyParallel: true,
  reporter: [["list"]],
  use: {
    baseURL: `http://localhost:${PORT}`,
    screenshot: "only-on-failure",
  },
  projects: [
    { name: "mobile", use: { ...devices["Pixel 7"] } },
    { name: "desktop", use: { ...devices["Desktop Chrome"], viewport: { width: 1440, height: 900 } } },
  ],
  webServer: {
    command: "node tools/preview/serve.mjs",
    port: PORT,
    reuseExistingServer: !process.env.CI,
  },
});
