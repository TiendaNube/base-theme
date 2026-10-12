// Render every fixture page to .preview/<page>.html
//
//   node tools/preview/build.mjs            # all pages
//   node tools/preview/build.mjs product    # one page

import fs from "node:fs";
import path from "node:path";
import { ROOT, renderPage } from "./engine.mjs";
import { pages } from "./fixtures/pages.mjs";
import { platformHead } from "./platform-head.mjs";

export const OUT_DIR = path.join(ROOT, ".preview");

export function buildPage(name) {
  const ctx = pages[name];
  if (!ctx) throw new Error(`Unknown preview page "${name}". Known: ${Object.keys(pages).join(", ")}`);
  const html = renderPage(name, { ...ctx, __platform_head: platformHead(ctx.settings) });
  fs.mkdirSync(OUT_DIR, { recursive: true });
  const out = path.join(OUT_DIR, `${name}.html`);
  fs.writeFileSync(out, html);
  return out;
}

export function buildAll(names = Object.keys(pages)) {
  return names.map(buildPage);
}

if (process.argv[1] && path.resolve(process.argv[1]) === new URL(import.meta.url).pathname) {
  const names = process.argv.slice(2);
  for (const out of buildAll(names.length ? names : undefined)) {
    console.log("preview:", path.relative(ROOT, out));
  }
}
