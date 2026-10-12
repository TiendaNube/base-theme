#!/usr/bin/env node
// Styling guard — enforces ADR-0003 (theme colors only via tokens/CSS vars).
//
//   node scripts/lint-styles.mjs            # exit 1 on violations
//   node scripts/lint-styles.mjs --list     # print every match, including allowed
//
// Scans templates/, snipplets/, layouts/ and __src/ (not static/, not
// snipplets/svg/) for hardcoded theme-dependent colors:
//   - hex literals (#fff, #410911…)
//   - rgb()/rgba() that are not pure black/white (universal-contrast overlays
//     are the one permitted exception, see ADR-0003)
//   - Tailwind palette classes (bg-white, text-red-600, border-gray-200…)
//
// Allowed on purpose (not reported):
//   - `__src/css/app.css` @theme block — the ONE place a brand constant may live
//   - lines carrying `lint-styles: allow <reason>`
//   - merchant data rendered from Twig (`{{ value.color_hexa }}`)

import fs from "node:fs";
import path from "node:path";

const ROOT = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
const LIST = process.argv.includes("--list");

const SCAN_DIRS = ["templates", "snipplets", "layouts", "__src"];
const SKIP = [/^snipplets\/svg\//, /\.DS_Store$/];
const EXT = new Set([".tpl", ".js", ".css"]);

const PALETTE = "(white|black|slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)";
const PATTERNS = [
  { name: "hex", re: /(?<![\w&])#(?:[0-9a-fA-F]{8}|[0-9a-fA-F]{6}|[0-9a-fA-F]{3,4})\b(?![\w-]*[({])/g },
  { name: "rgb", re: /\brgba?\([^)]*\)/g },
  { name: "palette-class", re: new RegExp(`(?<![\\w-])(?:[a-z-]+:)*(?:bg|text|border|fill|stroke|from|to|via|ring|outline|decoration|divide|accent|caret|shadow)-${PALETTE}(?:-\\d{2,3})?(?:\\/\\d{1,3})?(?![\\w-])`, "g") },
];

const isUniversalOverlay = (m) => {
  // rgba(0,0,0,x) / rgba(255,255,255,x) / rgb(0 0 0 / x) — allowed by ADR-0003
  const nums = m.match(/\d+(\.\d+)?/g) || [];
  const rgb = nums.slice(0, 3).map(Number);
  return rgb.length === 3 && (rgb.every((n) => n === 0) || rgb.every((n) => n === 255)) && nums.length === 4;
};
const isOverlayClass = (m) => /(?:black|white)\/\d{1,3}$/.test(m);
const isTwigValue = (line, idx) => line.slice(0, idx).lastIndexOf("{{") > line.slice(0, idx).lastIndexOf("}}");
const isHref = (line, idx) => /href=["']$/.test(line.slice(0, idx)) || /^#[a-z]/.test(line.slice(idx));

function* walk(dir) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    const rel = path.relative(ROOT, full);
    if (SKIP.some((re) => re.test(rel))) continue;
    if (entry.isDirectory()) yield* walk(full);
    else if (EXT.has(path.extname(entry.name))) yield rel;
  }
}

const violations = [];
const allowed = [];

for (const dir of SCAN_DIRS) {
  for (const rel of walk(path.join(ROOT, dir))) {
    const lines = fs.readFileSync(path.join(ROOT, rel), "utf8").split("\n");
    const isAppCss = rel === "__src/css/app.css";
    let inTheme = false;
    lines.forEach((line, i) => {
      if (isAppCss) {
        if (/^\s*@theme\s*\{/.test(line)) inTheme = true;
        else if (inTheme && /^\}/.test(line)) inTheme = false;
      }
      const explicitAllow = /lint-styles:\s*allow/.test(line);
      for (const { name, re } of PATTERNS) {
        re.lastIndex = 0;
        let m;
        while ((m = re.exec(line))) {
          const hit = { file: rel, line: i + 1, kind: name, match: m[0], text: line.trim() };
          const ok =
            explicitAllow ||
            (isAppCss && inTheme) ||
            (name === "hex" && (isTwigValue(line, m.index) || isHref(line, m.index) || /data:image/.test(line))) ||
            (name === "rgb" && isUniversalOverlay(m[0])) ||
            (name === "palette-class" && isOverlayClass(m[0]));
          (ok ? allowed : violations).push(hit);
        }
      }
    });
  }
}

const fmt = (h) => `${h.file}:${h.line}  [${h.kind}] ${h.match}\n    ${h.text.slice(0, 140)}`;

if (LIST) {
  console.log("# allowed\n" + allowed.map(fmt).join("\n"));
  console.log("\n# violations");
}
if (violations.length) {
  console.log(violations.map(fmt).join("\n"));
  console.log(`\n${violations.length} hardcoded color(s) — see docs/adr/0003-cores-do-tema-e-tokens.md`);
  process.exit(1);
}
console.log(`lint-styles: ok (${allowed.length} permitted matches)`);
