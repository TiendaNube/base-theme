#!/usr/bin/env node
// Twig structure guard — there is no local renderer (ADR-0015), so a broken
// template only shows up on the store, as a 500 on every page that includes it.
//
//   node scripts/lint-twig.mjs              # exit 1 on unbalanced templates
//   node scripts/lint-twig.mjs <file>...    # check only these files
//
// Per .tpl file in templates/, snipplets/, layouts/ (not static/), checks:
//   - every {% if %} / {% for %} / {% block %} / {% macro %} / {% set x %} has its end tag,
//     in the right nesting order
//   - <div> opens and closes the same number of times
// It is a structural check, not a parser: comments ({# #}) are stripped first.

import fs from "node:fs";
import path from "node:path";

const ROOT = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
const SCAN_DIRS = ["templates", "snipplets", "layouts"];
const PAIRED = ["if", "for", "block", "macro", "filter", "spaceless", "embed", "set"];

function* walk(dir) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) yield* walk(full);
    else if (entry.name.endsWith(".tpl")) yield path.relative(ROOT, full);
  }
}

const lineOf = (src, idx) => src.slice(0, idx).split("\n").length;

function check(rel) {
  const raw = fs.readFileSync(path.join(ROOT, rel), "utf8");
  // keep offsets stable so line numbers stay right
  const src = raw.replace(/\{#[\s\S]*?#\}/g, (m) => m.replace(/[^\n]/g, " "));
  const errors = [];
  const stack = [];
  const tagRe = /\{%-?\s*(\w+)([\s\S]*?)-?%\}/g;
  let m;
  while ((m = tagRe.exec(src))) {
    const [, name, rest] = m;
    const line = lineOf(src, m.index);
    // `{% set x = ... %}` is inline; only `{% set x %}...{% endset %}` is paired
    if (name === "set" && rest.includes("=")) continue;
    if (PAIRED.includes(name)) stack.push({ name, line });
    else if (name.startsWith("end") && PAIRED.includes(name.slice(3))) {
      const open = stack.pop();
      if (!open) errors.push(`${rel}:${line} {% ${name} %} without an opening tag`);
      else if (open.name !== name.slice(3)) errors.push(`${rel}:${line} {% ${name} %} closes {% ${open.name} %} from line ${open.line}`);
    }
  }
  for (const open of stack) errors.push(`${rel}:${open.line} {% ${open.name} %} is never closed`);

  // legacy files can opt out with: {# lint-twig: allow div-balance <reason> #}
  const allowDivs = /lint-twig: allow div-balance/.test(raw);
  const opens = (src.match(/<div[\s>]/g) || []).length;
  const closes = (src.match(/<\/div>/g) || []).length;
  if (opens !== closes && !allowDivs) errors.push(`${rel}: <div> opened ${opens}× but closed ${closes}×`);
  return errors;
}

const files = process.argv.slice(2).filter((a) => a.endsWith(".tpl"));
const targets = files.length ? files : SCAN_DIRS.flatMap((d) => [...walk(path.join(ROOT, d))]);
const errors = targets.flatMap(check);

if (errors.length) {
  console.error(errors.join("\n"));
  console.error(`\nlint-twig: ${errors.length} problem(s) in ${targets.length} templates`);
  process.exit(1);
}
console.log(`lint-twig: ok (${targets.length} templates)`);
