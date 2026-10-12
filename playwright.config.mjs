import { defineConfig, devices } from "@playwright/test";

// Alvo único: a loja de dev da Nuvemshop (ADR-0015). O renderer local foi
// descontinuado, então não existem mais projetos "preview-*" nem webServer.
//
//   npm test                                     → desktop + mobile, headed
//   npx playwright test --project=desktop tests/product
//   PW_HEADLESS=1 npx playwright test tests/smoke.spec.mjs   (só leitura)
//
// A Nuvemshop fica atrás de um challenge do Cloudflare: a partir desta máquina
// os GETs passam em headless, mas o POST /comprar/ (adicionar ao carrinho)
// recebe 403 — por isso a suíte roda headed por padrão. Não roda em CI (IP de
// datacenter é bloqueado).

export const STORE_URL = (process.env.ROMA_STORE_URL || "https://democamisetasromadev.lojavirtualnuvem.com.br").replace(/\/$/, "");

const desktop = { ...devices["Desktop Chrome"], viewport: { width: 1440, height: 900 } };
const mobile = { ...devices["Pixel 7"] };

export default defineConfig({
  testDir: "tests",
  outputDir: "test-results",
  fullyParallel: true,
  workers: Number(process.env.PW_WORKERS || 3),
  retries: Number(process.env.PW_RETRIES ?? 1),
  timeout: 60_000,
  expect: { timeout: 10_000 },
  reporter: [["list"], ["html", { open: "never", outputFolder: "playwright-report" }]],
  use: {
    baseURL: STORE_URL,
    headless: process.env.PW_HEADLESS === "1",
    locale: "pt-BR",
    screenshot: "only-on-failure",
    trace: "retain-on-failure",
  },
  projects: [
    { name: "desktop", use: desktop },
    { name: "mobile", use: mobile },
  ],
});
