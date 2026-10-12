// Dev server for the local preview.
//
//   node tools/preview/serve.mjs            # http://localhost:4321
//   PREVIEW_PORT=5000 node tools/preview/serve.mjs
//
// Routes:
//   /                      index listing the fixture pages
//   /<page>.html           re-rendered on every request (templates are read fresh)
//   /static/*              files from static/ (css/*.tpl rendered through twig first)
//   /__preview/placeholder/<w>x<h>.svg?label=…
//   /cart, /search, …     platform endpoints the custom JS posts to → 200 JSON stub

import http from "node:http";
import fs from "node:fs";
import path from "node:path";
import { ROOT, renderTemplate } from "./engine.mjs";
import { buildPage } from "./build.mjs";
import { pages } from "./fixtures/pages.mjs";

const PORT = Number(process.env.PREVIEW_PORT || 4321);
const MIME = { ".html": "text/html; charset=utf-8", ".css": "text/css", ".js": "text/javascript", ".svg": "image/svg+xml",
  ".png": "image/png", ".jpg": "image/jpeg", ".gif": "image/gif", ".woff2": "font/woff2", ".woff": "font/woff", ".json": "application/json" };

const send = (res, status, body, type = "text/plain") => { res.writeHead(status, { "Content-Type": type, "Cache-Control": "no-store" }); res.end(body); };

const placeholderSvg = (w, h, label) => `<svg xmlns="http://www.w3.org/2000/svg" width="${w}" height="${h}" viewBox="0 0 ${w} ${h}">
<rect width="100%" height="100%" fill="#d9d4c7"/><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" font-family="sans-serif" font-size="${Math.min(40, Math.round(w / 12))}" fill="#6b655a">${label || `${w}×${h}`}</text></svg>`;

export function createServer() {
  return http.createServer((req, res) => {
    const url = new URL(req.url, `http://localhost:${PORT}`);
    const p = decodeURIComponent(url.pathname);

    try {
      if (p === "/" ) {
        const links = Object.keys(pages).map((n) => `<li><a href="/${n}.html">${n}</a></li>`).join("");
        return send(res, 200, `<!doctype html><meta charset="utf-8"><title>Roma preview</title><h1>Roma Theme V2 — preview local</h1><ul>${links}</ul>`, MIME[".html"]);
      }

      const page = p.match(/^\/([a-z0-9-]+)\.html$/)?.[1];
      if (page && pages[page]) {
        return send(res, 200, fs.readFileSync(buildPage(page)), MIME[".html"]);
      }

      const ph = p.match(/^\/__preview\/placeholder\/(\d+)x(\d+)\.svg$/);
      if (ph) return send(res, 200, placeholderSvg(ph[1], ph[2], url.searchParams.get("label")), MIME[".svg"]);

      if (p.startsWith("/static/")) {
        const file = path.join(ROOT, p);
        if (!file.startsWith(path.join(ROOT, "static"))) return send(res, 403, "forbidden");
        if (!fs.existsSync(file)) return send(res, 404, "not found");
        if (file.endsWith(".tpl")) {
          // platform renders these through twig (settings vars) before serving
          const css = renderTemplate(p.slice(1), pages.home);
          return send(res, 200, css, file.includes("/css/") ? MIME[".css"] : MIME[".js"]);
        }
        return send(res, 200, fs.readFileSync(file), MIME[path.extname(file)] || "application/octet-stream");
      }

      // Platform endpoints the custom layer talks to (cart add, search…) — the
      // preview acknowledges them so UI flows can be exercised end to end.
      if (req.method === "POST" || p.startsWith("/cart") || p.startsWith("/search")) {
        return send(res, 200, JSON.stringify({ ok: true, preview: true }), MIME[".json"]);
      }

      return send(res, 404, `no preview route for ${p}`);
    } catch (err) {
      console.error(err);
      return send(res, 500, String(err?.stack || err));
    }
  });
}

if (process.argv[1] && path.resolve(process.argv[1]) === new URL(import.meta.url).pathname) {
  createServer().listen(PORT, () => console.log(`preview: http://localhost:${PORT}`));
}
