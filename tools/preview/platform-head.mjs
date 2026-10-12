// What `{% head_content %}` would inject, reduced to what the theme needs to
// boot in a browser without the platform:
//
//  1. the CSS custom properties style-colors.scss.tpl derives from settings
//     (the Tailwind @theme tokens in app.css map to these);
//  2. a `window.LS` stub — `LS.ready` is a promise that never resolves, so the
//     legacy jQuery block in layout.tpl (external.js + store.js) never runs.
//     The preview exercises the custom layer only (see ADR-0014);
//  3. a chainable no-op `jQueryNuvem`/`$` so the few inline `<script>` blocks
//     that still reference it don't throw at parse time.

export function platformHead(settings) {
  const fontHeadings = settings.font_headings || '"Muli", sans-serif';
  const fontRest = settings.font_rest || '"Muli", sans-serif';

  return `
<style id="preview-style-colors">
:root {
  --primary-color: ${settings.primary_color};
  --text-color: ${settings.text_color};
  --text-muted: ${settings.text_muted_color || "#80807B"};
  --background-color: ${settings.background_color};
  --accent-color: ${settings.accent_color};
  --font-headings: ${fontHeadings};
  --font-body: ${fontRest};
}
</style>
<script id="preview-platform-stub">
(function () {
  var calls = [];
  function record(name) { return function () { calls.push({ name: name, args: [].slice.call(arguments) }); }; }
  window.LS = {
    ready: new Promise(function () {}),
    search: record("search"),
    addItem: record("addItem"),
    removeItem: record("removeItem"),
    changeQuantity: record("changeQuantity"),
    plusQuantity: record("plusQuantity"),
    minusQuantity: record("minusQuantity"),
    changeVariant: record("changeVariant"),
    registerOnChangeVariant: record("registerOnChangeVariant"),
    __calls: calls
  };
  var chain = new Proxy(function () {}, {
    get: function (_, key) { return key === "length" ? 0 : function () { return chain; }; },
    apply: function () { return chain; }
  });
  window.jQueryNuvem = window.$ = chain;
  window.__PREVIEW__ = true;

  // lazysizes ships in the jQuery block that never runs here; resolve
  // data-src/data-srcset eagerly so product images show up in screenshots.
  function hydrateLazy(root) {
    (root || document).querySelectorAll("img.lazyload[data-src], img.lazyload[data-srcset]").forEach(function (img) {
      if (img.dataset.src) img.src = img.dataset.src;
      if (img.dataset.srcset) img.srcset = img.dataset.srcset;
      img.classList.add("lazyloaded");
    });
  }
  document.addEventListener("DOMContentLoaded", function () {
    hydrateLazy();
    new MutationObserver(function () { hydrateLazy(); }).observe(document.body, { childList: true, subtree: true });
  });
})();
</script>`;
}
