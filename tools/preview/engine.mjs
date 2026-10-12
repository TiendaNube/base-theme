// Local renderer for the Nuvemshop templates.
//
// The platform renders `.tpl` files with a Twig dialect that adds a few tags
// ({% snipplet %}, {% template_content %}, {% head_content %}, {% paginate %})
// and ~25 filters/functions (translate, static_url, money, product_image_url,
// component()…). twig.js covers the standard Twig part; this module fills in
// the Nuvemshop part with stubs that are good enough to exercise layout,
// Tailwind output and the custom JS bundle in a real browser.
//
// This is a *preview*, not the platform: `component()` output, real price
// formatting and the legacy jQuery layer (store.js.tpl) are not reproduced.
// See docs/adr/0014-stack-de-teste-local.md for the boundaries.

import Twig from "twig";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { loadTranslations } from "./translations.mjs";

export const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..", "..");

let currentPage = "home";
let currentContext = {};
const translations = loadTranslations(path.join(ROOT, "config/translations.txt"));

// ---------------------------------------------------------------------------
// Pre-pass: rewrite platform-only syntax into plain Twig before twig.js sees it
// ---------------------------------------------------------------------------
// twig.js cannot parse a nested object literal inside function arguments
// (`component('x', { a: { b: 1 } })`). `component()` is a stub in the
// preview anyway, so collapse every call to `component('name')`, scanning
// with balanced parentheses because the args span several lines.
const collapseComponentCalls = (src) => {
  let out = "";
  let i = 0;
  for (;;) {
    const start = src.indexOf("component(", i);
    if (start === -1) return out + src.slice(i);
    out += src.slice(i, start);
    let depth = 0;
    let j = start + "component".length;
    let quote = null;
    for (; j < src.length; j++) {
      const c = src[j];
      if (quote) { if (c === quote && src[j - 1] !== "\\") quote = null; continue; }
      if (c === "'" || c === '"') quote = c;
      else if (c === "(") depth += 1;
      else if (c === ")") { depth -= 1; if (depth === 0) { j += 1; break; } }
    }
    const call = src.slice(start, j);
    const name = call.match(/^component\(\s*(['"])([^'"]+)\1/);
    out += name ? `component(${name[1]}${name[2]}${name[1]})` : call;
    i = j;
  }
};

const prePass = (src) =>
  collapseComponentCalls(src)
    // {% snipplet "a/b.tpl" %} → {% include "snipplets/a/b.tpl" %}
    .replace(/\{%-?\s*snipplet\s+(['"])([^'"]+)\1\s*(.*?)-?%\}/g, (_, q, p, rest) => `{% include "snipplets/${p}" ${rest}%}`)
    // {% template_content %} → the page template chosen at render time
    .replace(/\{%-?\s*template_content\s*-?%\}/g, () => `{% include "templates/${currentPage}.tpl" %}`)
    // {% head_content %} → platform head stub (LS, CSS vars, jQuery shim)
    .replace(/\{%-?\s*head_content\s*-?%\}/g, `{{ __platform_head | raw }}`)
    // {% paginate by 12 %} — the platform slices `products`; fixtures are already sliced
    .replace(/\{%-?\s*paginate\s+by\s+\d+\s*-?%\}/g, "")
    // `with{` without a space breaks the twig.js tokenizer
    .replace(/\bwith\{/g, "with {")
    // `{'location' : 'x'}` (quoted key + space before the colon) inside
    // function arguments crashes twig.js's parameter parser; unquote the key
    .replace(/([{,]\s*)['"]([a-zA-Z_]\w*)['"]\s*:/g, "$1$2:")
    // twig.js has no arrow functions; the only shape in the codebase is this one
    .replace(/\|\s*map\(item => item \| trim \| lower\)/g, "| map_trim_lower")
    // twig.js evaluates an unparenthesised nested ternary wrongly (returns the
    // boolean). Only shape in the codebase: `a ? b ? 'x' : 'y' : 'z'`.
    .replace(/(\w[\w.]*)\s*\?\s*(\w[\w.]*)\s*\?\s*('[^']*')\s*:\s*('[^']*')\s*:\s*('[^']*')/g, "$1 ? ($2 ? $3 : $4) : $5")
    // Platform method shims. twig.js auto-invokes a function reached through
    // property access, so `product.get_max_installments and
    // product.get_max_installments(false)` cannot be modelled as a method on
    // the fixture. Expose it as a plain value instead (fixtures/catalog.mjs).
    .replace(/product\.get_max_installments\(false\)/g, "product.max_installments")
    .replace(/product\.get_max_installments\b/g, "product.max_installments");

Twig.cache(false);

// Every include goes through the default "fs" loader; override it so the
// pre-pass runs on each file and paths always resolve from the repo root.
Twig.extend((T) => {
  T.Templates.registerLoader("fs", function (location, params) {
    const rel = location.replace(/^.*?(?=(snipplets|templates|layouts|static)\/)/, "");
    const file = path.join(ROOT, rel);
    if (!fs.existsSync(file)) throw new T.Error(`Unable to find template file ${rel}`);
    params.data = prePass(fs.readFileSync(file, "utf8"));
    params.base = ROOT + "/";
    params.path = file;
    params.id = rel;
    return new T.Template(params);
  });
});

// ---------------------------------------------------------------------------
// Filters
// ---------------------------------------------------------------------------
const PLACEHOLDER_SIZES = { small: [120, 150], medium: [240, 300], large: [480, 600], huge: [640, 800], original: [1024, 1280], banner: [1440, 720] };

export const placeholderUrl = (size = "medium", label = "") => {
  // templates chain filters (`'x.jpg' | static_url | settings_image_url`):
  // don't wrap a placeholder in another placeholder
  if (String(label).startsWith("/__preview/")) return String(label);
  const [w, h] = PLACEHOLDER_SIZES[size] || PLACEHOLDER_SIZES.medium;
  return `/__preview/placeholder/${w}x${h}.svg${label ? `?label=${encodeURIComponent(label)}` : ""}`;
};

const staticUrl = (file) => {
  const f = String(file || "").replace(/^\/+/, "");
  if (/^(css|js|images|fonts)\//.test(f)) return `/static/${f}`;
  if (fs.existsSync(path.join(ROOT, "static", f))) return `/static/${f}`;
  if (fs.existsSync(path.join(ROOT, "static/images", f))) return `/static/images/${f}`;
  // admin-uploaded assets referenced by name (hero_banner_2_desktop.jpg, logo…)
  return placeholderUrl(/banner|slider|bg/.test(f) ? "banner" : "medium", f);
};

const money = (value) => {
  const n = Number(value);
  if (Number.isNaN(n)) return String(value ?? "");
  return "R$ " + n.toFixed(2).replace(".", ",").replace(/\B(?=(\d{3})+(?!\d))/g, ".");
};

const imageUrl = (image, size) => {
  if (!image) return placeholderUrl(size);
  if (typeof image === "string") return image.startsWith("/") || image.startsWith("http") ? image : placeholderUrl(size, image);
  if (image.src) return image.src;
  return placeholderUrl(size, image.alt || image.id);
};

// `'Faltam {1} itens' | translate(n)` — the platform substitutes {i} with the
// i-th argument
const translate = (s, args) =>
  (translations.get(String(s)) ?? String(s)).replace(/\{(\d+)\}/g, (m, i) => (args && args[i - 1] !== undefined ? String(args[i - 1]) : m));

const filters = {
  translate,
  t: translate,
  static_url: staticUrl,
  // style-colors.scss.tpl is SCSS the platform compiles; the preview emits the
  // resulting CSS variables itself (see platform-head.mjs), so inline nothing.
  static_inline: () => "",
  script_tag: (src, args) => `<script src="${args && args[0] ? src : src}"></script>`,
  // admin-uploaded images (banners, logo) — wide placeholder so the label
  // doesn't scale up to a billboard inside full-width sections
  settings_image_url: (file) => placeholderUrl("banner", file),
  has_custom_image: (file) => Boolean(currentContext.settings?.__custom_images?.includes(file)),
  setting_url: (v) => (v ? String(v) : "#"),
  money,
  product_image_url: (image, args) => imageUrl(image, args?.[0]),
  category_image_url: (image, args) => imageUrl(image, args?.[0]),
  img_tag: (src, args) => `<img src="${imageUrl(src, "medium")}" ${args?.[0] ? `alt="${args[0]}"` : ""} ${args?.[1] ? Object.entries(args[1]).map(([k, v]) => `${k}="${v}"`).join(" ") : ""}>`,
  a_tag: (text, args) => `<a href="${args?.[0] ?? "#"}"${args?.[1] ? ` class="${args[1]}"` : ""}>${text}</a>`,
  is_external: (url) => /^https?:\/\//.test(String(url)),
  add_param: (url, args) => `${url}${String(url).includes("?") ? "&" : "?"}${args?.[0]}=${args?.[1]}`,
  payment_new_logo: () => placeholderUrl("small", "payment"),
  shipping_logo: () => placeholderUrl("small", "shipping"),
  flag_url: () => placeholderUrl("small", "flag"),
  highlight: (text) => text,
  google_fonts_url: () => "",
  get_products: () => [],
  format_address: (a) => (typeof a === "string" ? a : JSON.stringify(a)),
  format_address_short: (a) => (typeof a === "string" ? a : JSON.stringify(a)),
  format_id_number: (v) => String(v),
  sanitize: (v) => String(v),
  pin_it: () => "",
  take: (arr, args) => (Array.isArray(arr) ? arr.slice(0, args?.[0] ?? arr.length) : arr),
  shuffle: (arr) => (Array.isArray(arr) ? [...arr].sort(() => Math.random() - 0.5) : arr),
  i: (v) => v,
  map_trim_lower: (arr) => (Array.isArray(arr) ? arr.map((x) => String(x).trim().toLowerCase()) : []),
};
for (const [name, fn] of Object.entries(filters)) Twig.extendFilter(name, fn);

// ---------------------------------------------------------------------------
// Functions
// ---------------------------------------------------------------------------
Twig.extendFunction("component", (name) => `<!-- component:${name} -->`);
Twig.extendFunction("product_image_url", (image, size) => imageUrl(image, size));
Twig.extendFunction("settings_image_url", (file) => placeholderUrl("banner", file));
Twig.extendFunction("include", (file, ctx) =>
  Twig.twig({ path: file, async: false }).render({ ...currentContext, ...(ctx || {}) }),
);

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------
/**
 * Render a full page (layout + page template) with the given context.
 * @param {string} page   name of templates/<page>.tpl
 * @param {object} context template variables (settings, store, product, …)
 */
export function renderPage(page, context) {
  currentPage = page;
  currentContext = context;
  const tpl = Twig.twig({ path: "layouts/layout.tpl", async: false });
  return tpl.render(context);
}

/** Render a loose template (used by the dev server for static/css/*.tpl). */
export function renderTemplate(relPath, context) {
  currentContext = context;
  return Twig.twig({ path: relPath, async: false }).render(context);
}
