# ARCHITECTURE CONTRACT (MANDATORY)

## 1. System Overview

Roma Theme V2 is a custom Nuvemshop e-commerce storefront theme. It operates as a **dual-layer hybrid system**: a legacy jQuery-based layer (`store.js.tpl`, `external.js.tpl`) managed by the Nuvemshop platform, and a modern vanilla JS layer (`__src/js/`) custom-built and bundled via esbuild. Styling combines Tailwind CSS v4 (compiled to `static/css/app.tpl`) with platform-managed SCSS templates (`style-colors.scss.tpl`, `style-async.scss.tpl`, `style-critical.tpl`). Templates use Nuvemshop's Twig-like `.tpl` engine with platform-specific filters and components. The theme runs entirely client-side with no custom backend — all server logic is provided by the Nuvemshop platform via template variables, `LS.*` APIs, and jQuery-dependent legacy code.

---

## 2. Layer Responsibilities

### Source Layer (`__src/`)
- **`__src/js/index.js`**: Single entry point. Imports and invokes all custom JS modules. ONLY file that orchestrates module loading.
- **`__src/js/modules/system/`**: Global modules loaded on every page (header, menu, search, toast, modal, item-card-quickbuy). Each module MUST guard execution with DOM element existence checks.
- **`__src/js/modules/home/`**: Homepage-specific modules (hero carousel, product carousel). Each module MUST guard execution with DOM element existence checks internally — they are loaded globally but execute conditionally.
- **`__src/js/modules/category/`**: Category page modules (dropdown, infinite scroll, filters, sorting). Each module MUST guard execution with DOM element existence checks internally — they are loaded globally but execute conditionally.
- **`__src/js/modules/product/`**: Product detail page modules (gallery, gallery zoom, variants, add-to-cart, accordion). Each module MUST guard execution with DOM element existence checks internally — they are loaded globally but execute conditionally.
- **`__src/css/app.css`**: Tailwind v4 entry point with `@theme` design tokens and custom CSS for behaviors Tailwind cannot express (animations, scrollbar hacks, state-driven styling via `data-*` attributes).

### Build Layer
- **`esbuild.config.mjs`**: Bundles `__src/js/index.js` → `static/js/gaius-v{timestamp}.js` (IIFE, ES2018, minified).
- **`pre-build.js`**: Runs BEFORE production builds. Generates epoch-based filename, updates references in `esbuild.config.mjs` and `layouts/layout.tpl`. Cache-busting mechanism.
- **Tailwind CLI**: Compiles `__src/css/app.css` → `static/css/app.tpl` via `@tailwindcss/cli` with `--optimize`.

### Output Layer (`static/`)
- **`static/js/gaius-v{version}.js`**: Compiled custom JS bundle. NEVER edit directly.
- **`static/css/app.tpl`**: Compiled Tailwind output. NEVER edit directly.
- **`static/js/store.js.tpl`**: Legacy Nuvemshop jQuery code. Reference only. Rewrite needed features in `__src/js/modules/`.
- **`static/js/external.js.tpl`** / **`external-no-dependencies.js.tpl`**: Third-party libraries (jQuery-dependent and independent).
- **`static/js/lucide.min.js`**: Icon library. Loaded synchronously before custom bundle.
- **`static/css/style-colors.scss.tpl`**: Platform-generated dynamic colors from admin settings.
- **`static/css/style-critical.tpl`**: Critical CSS inlined in `<head>`.
- **`static/css/style-async.scss.tpl`**: Non-critical CSS loaded async via `media="print"` swap.

### Template Layer
- **`layouts/layout.tpl`**: Master layout. Controls `<head>`, script loading order, global snipplets (header, footer, quickshop, whatsapp). Contains the gaius bundle `<script>` reference.
- **`templates/*.tpl`**: Page-level templates injected via `{% template_content %}`.
- **`snipplets/`**: Reusable components organized by domain (header, home, navigation, grid, product, cart, shipping, forms, svg, social, etc.). `snipplets/cart/cart-drawer-progress-bars.tpl` (free shipping + progressive discount bars) is included by `cart-drawer.tpl:123` via `{% snipplet %}`.

### Configuration Layer (`config/`)
- **`settings.txt`**: Theme customization options exposed in Nuvemshop admin. Drives template conditionals and design tokens.
- **`sections.txt`**: Product section definitions (primary, carousel tabs).
- **`defaults.txt`**: Default values for settings.
- **`translations.txt`**: Multi-language string translations.
- **`data.json`**: Asset metadata.

---

## 3. Core Architectural Invariants

**A1** — Custom JavaScript MUST be written in `__src/js/modules/` organized by context subdirectory. The permitted context directories are: `system/` (global modules loaded on every page), `home/` (homepage-specific modules), `category/` (category page modules), `product/` (product detail page modules). NEVER write custom JS directly in `static/`. New contexts (e.g., `cart/`) MUST be created as new subdirectories under `modules/` and follow the same pattern: named exports, DOM guards, invocation from `index.js`.

**A2** — Every JS module MUST check for the existence of its root DOM element as the FIRST executable statement, using the exact pattern `if (!element) return;`. Verified guard selectors by module:
- `header.js/headerAnimations`: `.js-new-header`
- `header.js/advertisingCarousel`: `.js-ad-carousel`
- `menu.js`: `.js-menu-mobile` (via early returns in each sub-function)
- `search.js`: `.js-search-overlay` and `.js-search-input`
- `modal.js`: `.js-gaius-modal-container`
- `toast.js`: `.js-toast-container`
- `item-card-quickbuy.js`: `.js-quickbuy-container`
- `cart-drawer.js`: `.js-cart-drawer`
- `hero-banner-2-carousel.js`: `.js-hero-banner-2`
- `product-carousel.js`: `.js-product-carousel`
- `category-dropdown.js`: `.js-category-dropdown`
- `category-infinite-scroll.js`: `.js-category-grid`
- `category-filters.js`: `.js-category-filter-trigger`
- `category-sorting.js`: `.js-category-sorting`
- `product-gallery.js`: `.js-product-gallery`
- `product-gallery-zoom.js`: `.js-product-gallery-zoom`
- `product-variants.js`: `.js-product-variants` (plus a second guard on `.js-product-variants-data`, the `<script type="application/json">` payload the module cannot run without)
- `product-add-to-cart.js`: `#product_form` — the ONLY module guarding on an ID instead of a `js-*` class, because the form id is rendered by the platform's `product-form.tpl` and is also what the legacy `store.js.tpl` binds to. Not a precedent for new modules.
- `product-accordion.js`: `.js-accordion-item` — NodeList guard (`if (!items.length) return;`), the permitted variation of the pattern when a module owns N sibling components instead of a single root element

A module with multiple independent features (like `header.js` exporting `headerAnimations` and `advertisingCarousel`) MUST guard EACH exported function independently.

**A3** — All modules MUST be imported and invoked in `__src/js/index.js`. No module may self-execute on import. The pattern is strictly `import { fn } from "./modules/context/file"` followed by `fn();`. NEVER use default exports. NEVER use side-effectful imports (`import "./module"`). Imports MUST be grouped by context with a comment header (`//System`, `//Category`, `//Home`, `//Product`). Current import count: 20 named exports across 4 contexts (system: 8 — `headerAnimations`, `advertisingCarousel`, `menuSystem`, `searchSystem`, `toastSystem`, `modalSystem`, `itemCardQuickbuy`, `cartDrawerSystem`; category: 4 — `categoryDropdown`, `categoryInfiniteScroll`, `categoryFilters`, `categorySorting`; home: 2 — `productCarousel`, `heroBanner2Carousel`; product: 5 — `productGallery`, `productGalleryZoom`, `productVariants`, `productAddToCart`, `productAccordion`). When adding a new module, this count MUST be updated.

**A4** — The `static/` directory contains ONLY build outputs and platform-managed files. Files in `static/js/gaius-v*.js` and `static/css/app.tpl` MUST NOT be manually edited. Platform-managed files (`store.js.tpl`, `external.js.tpl`, `external-no-dependencies.js.tpl`, `lucide.min.js`, `instatheme.js`, all `static/css/*.tpl` except `app.tpl`) are NOT build outputs — they are vendored or platform files that MAY be edited when upgrading dependencies.

**A5** — Cross-module communication MUST use `window.*` function assignments. The complete registry of `window.*` globals (12 total):
- `window.setHeaderMenuActive(boolean)` — defined in `header.js`, consumed by `menu.js` and `cart-drawer.js` via optional chaining
- `window.openModal({title?, content?, contentSelector?, size?, mode?})` — defined in `modal.js`, consumed by `category-filters.js`
- `window.closeModal()` — defined in `modal.js`
- `window.showToast({message, icon?, duration?, product?})` — defined in `toast.js`, consumed by `cart-drawer.js`
- `window.showProductToast({image, name, price, quantity, variation, duration?})` — defined in `toast.js`, consumed by `item-card-quickbuy.js`
- `window.closeToast(toastElement)` — defined in `toast.js`
- `window.closeAllToasts()` — defined in `toast.js`
- `window.openCartDrawer()` — defined in `cart-drawer.js`, consumed by `toast.js` (toast click-through to cart)
- `window.closeCartDrawer()` — defined in `cart-drawer.js`
- `window.onCartUpdate()` — defined in `cart-drawer.js`, consumed by `item-card-quickbuy.js` and `product-add-to-cart.js` (marks the cart dirty and refreshes the drawer after an add-to-cart made outside it; any module that mutates the cart outside the drawer MUST call it, otherwise opening the drawer skips the refetch)
- `window.initQuickbuyDropdowns()` — defined in `item-card-quickbuy.js`, consumed by `category-infinite-scroll.js` (reinitializes quickbuy stock status after new product cards are injected via infinite scroll)
- `window.setProductGalleryImage(imagePosition)` — defined in `product-gallery.js`, consumed by `product-variants.js` (slides the PDP gallery to the photo of the newly selected variant; `imagePosition` is the 1-based `variant.image` index coming from `variants_object`)

Modules MUST NOT import from sibling modules. Any new `window.*` global MUST be documented in this registry. Consumers MUST use optional chaining: `window.functionName?.(args)`. Modules communicate with the DOM layer via `js-*` class selectors (read) and `data-*` attribute manipulation (read/write). These are NOT "cross-layer communication" — they are the standard DOM interface.

**A6** — After dynamically inserting HTML containing `<i data-lucide="...">` markup, the module MUST call `lucide.createIcons()` to render icons. The call MUST be guarded with `typeof lucide !== "undefined"`. Modules that currently call `lucide.createIcons()`: `menu.js` (via `reinitIcons` helper with 50ms delay and in `initMenuCarousel`), `hero-banner-2-carousel.js`, `product-carousel.js` (two call sites), `modal.js`, `toast.js`, `category-infinite-scroll.js`, `product-accordion.js` (after swapping the `plus`/`minus` icon on toggle), `product-gallery-zoom.js` (after rendering the pagination seeds). All use the `typeof` guard pattern.

**A7** — The bundle filename MUST follow the pattern `gaius-v{epoch}.js` where `{epoch}` is `Date.now()` at build time. The `pre-build.js` script updates this in exactly two files: `esbuild.config.mjs` (line containing `outfile:`) and `layouts/layout.tpl` (the `script_tag` reference), using the regex `/gaius-v\d+\.js/g`. Both files MUST contain exactly one match for this regex at all times.

**A8** — Theme-dependent colors MUST NEVER be hardcoded. Platform color CSS custom properties (`--background-color`, `--primary-color`, `--text-color`, `--accent-color`) are injected via `style-colors.scss.tpl` (`--accent-color` from `settings.accent_color`, line 20/33). The Tailwind `@theme` block in `app.css` MUST map `--background-color`/`--primary-color`/`--text-color` to semantic tokens: `--color-bg`, `--color-fg`, `--color-secondary`, `--color-bg-subtle`, `--color-fg-muted`. `--accent-color` is NOT mapped into `@theme` — it is consumed directly as `var(--accent-color)` in templates (e.g. `home-product-grid.tpl`, `home-promo-marquee.tpl`, `home-product-carousel.tpl`, `home-faq.tpl`, `cart-drawer-progress-bars.tpl`, `checkout.scss.tpl`). All CSS and JS MUST use either the `@theme` tokens (via Tailwind classes like `bg-bg`, `text-fg`) or the platform CSS variables directly.

**Permitted exceptions**: `rgba(0, 0, 0, *)` and `rgba(255, 255, 255, *)` are permitted ONLY as semi-transparent overlays for universal contrast effects (subtle surfaces, backdrop filters, scrollbar tracks). These use absolute black/white intentionally because they MUST provide consistent contrast regardless of theme colors.

**Brand constants** (admin does not control them; the ONLY place they may be literal is the `@theme` block): `--color-highlight` (#2dcc57, installments/pix) and `--color-danger` (#dc2626, form errors). Highlighted menu items use `text-fg`, not a constant. Policy and rationale: `docs/adr/0003-cores-do-tema-e-tokens.md`.

**Enforcement**: `npm run lint:styles` (`scripts/lint-styles.mjs`) fails on hex, non-universal rgb/rgba and Tailwind palette classes outside the exceptions. A line may carry `lint-styles: allow <reason>` ONLY for the two documented exceptions: `admin-white` (an admin dropdown option that explicitly means white: `home-promo-marquee.tpl`, `hero-banner-2-carousel.js`, `hero-banner-2-slide.tpl`, `home-hero-banner.tpl`) and `overlay` (white text over the element's own black overlay: `home-vip-group.tpl`, `menu-carousel.tpl`, `product-gallery-modal.tpl`).

The four hardcoded-color bugs previously listed here (`product-carousel.js:18-19`, `home-product-carousel.tpl:50`, `category.tpl:91`) plus `home-vip-group.tpl:106-109` were fixed on 2026-10-12 (see `docs/architecture-drift-reports/20261012-styling-audit.md`).

**A9** — Interactive overlay state MUST be managed via `data-state` attributes with CSS selectors `[data-state="..."]`. Seven components currently use this pattern:
1. **Header**: `.js-new-header[data-state="transparent"|"active"]` — controlled by `header.js`, styled in `app.css:69-103`
2. **Search overlay**: `.js-search-overlay[data-state="open"|"closed"]` — controlled by `search.js`, styled in `app.css:107-113`
3. **Toast notifications**: `.js-toast-container [data-state="entering"|"visible"|"exiting"]` — controlled by `toast.js`, styled in `app.css:139-157`
4. **Modal container**: `.js-gaius-modal-container[data-state="open"|"closed"]` — controlled by `modal.js`, styled in `app.css:161-228`
5. **Cart drawer**: `.js-cart-drawer[data-state="open"|"closed"]` — controlled by `cart-drawer.js`, styled in `app.css:368-402`
6. **Product gallery zoom**: `.js-product-gallery-zoom[data-state="open"|"closed"]` — controlled by `product-gallery-zoom.js`, styled in the `PRODUCT GALLERY ZOOM STYLES` section of `app.css`
7. **Product accordion items**: `.js-accordion-item[data-state="open"|"closed"]` — controlled by `product-accordion.js`, one instance per accordion section

`.js-product-sticky-buy-btn[data-state="cart"|"contact"|"catalog"|"nostock"]` is NOT part of this pattern: it carries the platform's buy-button mode (rendered server-side in `product-sticky-buy-bar.tpl`, re-evaluated per variant by `product-add-to-cart.js`) and drives behaviour, not CSS. Reading a `data-state` value as data is permitted; only state that also drives styling MUST follow the numbered pattern above.

Any new full-page overlay or state-driven component MUST use this same `data-state` pattern. Atomic state changes (show/hide a single element) MUST use the `hidden` attribute instead.

**A10** — Template includes MUST use `{% snipplet "path.tpl" %}` or `{% include "snipplets/path.tpl" %}` syntax (both forms are used in the codebase — Nuvemshop supports both). Snipplets MUST be organized by domain folder within `snipplets/`. The existing domain folders are: `header/`, `home/`, `navigation/`, `grid/`, `product/`, `cart/`, `shipping/`, `shipping_suboptions/`, `forms/`, `svg/`, `social/`, `banner-services/`, `defaults/`, `placeholders/`, `notification/`, `footer/`. Legacy flat `.tpl` files exist directly in `snipplets/` (22 files including `card.tpl`, `breadcrumbs.tpl`, `cart-panel.tpl`, `whatsapp-chat.tpl`, etc.) — these are pre-existing and MUST NOT be used as precedent. New snipplets MUST NEVER be placed at `snipplets/` root level — they MUST be placed in an existing domain folder or a new domain folder created for the purpose.

**A11** — The homepage section system is driven by `settings.home_order_position_0..12` routed through `home-section-switch.tpl`. The router uses `{% if section_select == 'key' %}` chains. Currently registered keys: `hero_banner`, `hero_banner_2`, `slider`, `products`, `informatives`, `categories`, `welcome`, `video`, `instafeed`, `modules`, `promo_marquee`, `product_carousel`, `product_grid`, `vip_group`, `faq`. The `popup` section listed in documentation is NOT registered in the router — it is included directly in `home-section-switch.tpl`'s hidden sections block. New home sections MUST: (1) add an `{% elseif %}` branch to `home-section-switch.tpl`, (2) create the snipplet in `snipplets/home/`, (3) add the setting key to `settings.txt` under the home order dropdown options, (4) add a `has_*` variable in `home.tpl` if the section has conditional visibility.

**A12** — Script loading order in `layout.tpl` is: (1) inline critical CSS, (2) `external-no-dependencies.js.tpl` (no jQuery), (3) `LS.ready.then()` → `external.js.tpl` + `store.js.tpl` (jQuery-dependent), (4) `lucide.min.js` (sync), (5) `lucide.createIcons()` (inline), (6) `gaius-v*.js` (sync). The custom bundle executes AFTER Lucide is initialized and AFTER the legacy jQuery/Swiper stack is loaded. Custom modules MUST NOT call `LS.*` or `$`/`jQueryNuvem` directly. Custom modules MAY safely assume `Swiper` and `lucide` exist as globals at execution time (they are loaded synchronously before the bundle). Swiper is consumed by `product-carousel.js` and `menu.js`.

**A13** — New theme settings MUST follow the existing structure in `config/settings.txt`: category header → `meta` block → fields grouped by `title`/`subtitle`/`description`. Setting names MUST use `snake_case`. Field types observed in the codebase: `color`, `checkbox`, `text`, `textarea`, `dropdown`, `font`, `image`, `i18n_input`. New settings MUST be placed in the appropriate existing category or a new category following the same format.

**A14** — **Lucide is the canonical icon system.** All icons MUST use `<i data-lucide="icon-name">` markup. Legacy SVG snipplets (`snipplets/svg/`) exist only because migration FROM SVG snipplets TO Lucide is in progress (105 SVG usages across 48 older templates still to be converted). The ONLY acceptable reason to use an SVG snipplet is when the specific icon does NOT exist in the Lucide library. In that case, use the existing SVG snipplet — but NEVER create a new SVG snipplet file. When refactoring any template, ALL SVG snipplet includes in that template MUST be replaced with Lucide equivalents (if the icon exists in Lucide).

---

## 4. Data Flow Contract

### Template Data Flow
```
Nuvemshop Platform → Template Variables ({{ store.*, settings.*, cart.*, customer, etc. }})
    → layout.tpl (master) → {% template_content %} → page templates
    → {% snipplet %} → component templates
    → config/settings.txt → {{ settings.SETTING_NAME }} in templates
```

### CSS Data Flow
```
Nuvemshop Admin (colors/fonts) → style-colors.scss.tpl (CSS custom properties)
    → @theme block in app.css (maps to Tailwind tokens)
    → Tailwind classes in .tpl templates
```

### JS Data Flow
```
__src/js/index.js → imports modules → each module queries DOM (js-* class selectors)
    → module reads data-* attributes from template-rendered HTML
    → module reads CSS custom properties via getComputedStyle() (product-carousel.js, menu.js)
    → module manipulates DOM directly (classList, setAttribute, .style, .hidden, .innerHTML)
    → cross-module communication via window.* globals ONLY
```

### Legacy ↔ Custom JS Boundary
```
store.js.tpl (jQuery, LS.*) ←→ window.* globals ←→ __src/js/modules/
Templates render data-* attributes → Custom JS reads them
Custom JS manipulates DOM → Legacy JS (store.js.tpl) observes via jQuery selectors
search.js delegates search AJAX to LS.search() by NOT reimplementing it
product-variants.js OWNS variant selection outright — it does NOT call LS.changeVariant()
```

**Note (PDP variant selection)** — The product detail page is the one place where the custom layer replaces a legacy platform flow instead of delegating to it. `product-variants.js` reads `variants_object` from `#single-product[data-variants]` / `.js-product-variants-data` and updates price, gallery and buy button itself; `LS.changeVariant()` and `LS.registerOnChangeVariant()` are never called, and the legacy `<select>`-based variant markup is not rendered. The accepted trade-off: platform `component('installments')` / `component('promotions-details')` blocks stay rendered server-side for the default variant and are NOT recalculated on variant change. This is a deliberate decision from the `pagina-de-produto` feature, not drift — do not "fix" it by reintroducing `LS.changeVariant`.

**D1** — JS reads data from templates via THREE channels: (1) `data-*` attributes on template-rendered HTML, (2) DOM structure and content (e.g., counting `.swiper-slide` elements), (3) CSS custom properties via `getComputedStyle(document.documentElement).getPropertyValue()` (e.g., `--text-color` in `product-carousel.js` and `menu.js`). JS NEVER writes template variables. JS MUST NOT call `LS.*` platform APIs directly, with ONE exception: `LS.removeItem(itemId, silent)` and `LS.addItem()` MAY be called from cart-related modules (`cart-drawer.js`, `item-card-quickbuy.js`) because these are stateful platform APIs with no delegation alternative via legacy jQuery bindings.

JS MAY use `fetch()` in exactly two shapes:
1. **GET of a server-rendered page** for pagination/infinite-scroll purposes (as in `category-infinite-scroll.js`). This is permitted because it fetches the same template-rendered HTML from the server — it does NOT call a platform AJAX API. Fetched HTML MUST be parsed with `DOMParser` and data MUST be extracted from DOM structure, not from a JSON API.
2. **POST of a form's own `action`** to submit a platform form without a page reload (as in `product-add-to-cart.js`, which posts the `#product_form` `FormData` to `form.action` with `X-Requested-With: XMLHttpRequest`). This is permitted because the target URL and payload come from the template-rendered form itself — no platform endpoint or payload shape is hardcoded in JS. The response body MUST NOT be parsed as an API contract; success/failure is taken from `res.ok`, and cart state is refreshed through `window.onCartUpdate?.()`.

**D2** — The search system bridges legacy and custom code: `search.js` manages the overlay UI (open/close, focus trap, loading state icon swap), but the actual AJAX search is handled by `LS.search()` in `store.js.tpl` which independently binds to the `.js-search-input` element. The debounce in `search.js:82-92` tracks `lastValue` but does NOT actually prevent `LS.search()` from firing (it is effectively a no-op). Custom JS MUST NOT duplicate legacy AJAX functionality — it MUST delegate to legacy when the platform API is jQuery-dependent.

**D3** — Template-to-template data passing uses `{% snipplet "file.tpl" with { key: value } %}` or `{% include "..." with { key: value } %}`. There is no shared state store between templates. The `home.tpl` template sets `{% set %}` variables that are available only within its scope and included snipplets.

---

## 5. State Management Contract

**S1** — There is NO centralized state management. Each JS module manages its own local state via closure variables. Verified state variables:
- `header.js/headerAnimations`: `isMenuActive` (boolean)
- `header.js/advertisingCarousel`: `currentSlide` (number)
- `menu.js`: `isMobileMenuOpen` (boolean), `activeDesktopMenu` (number|null)
- `search.js`: `isOpen` (boolean), `debounceTimer`, `lastValue`
- `hero-banner-2-carousel.js`: `currentSlide` (number), `autoplayTimer`
- `product-carousel.js`: `swipers` (object map), `realSlideCounts` (object map), `activeTab` (string), `initCount` (number)
- `modal.js`: `currentModal` (HTMLElement|null), `savedOverflow` (string), `contentSourceEl` (HTMLElement|null)
- `toast.js`: `activeToasts` (Array)
- `category-dropdown.js`: stateless (state is in DOM via `hidden` and `aria-expanded`)
- `category-infinite-scroll.js`: `loading` (boolean), `isLast` (boolean), `nextUrl` (string), `fetchedUrls` (object)
- `category-filters.js`: stateless (delegates to `window.openModal`)
- `category-sorting.js`: stateless (state is in DOM via `hidden` and `aria-expanded`)
- `item-card-quickbuy.js`: `currentOpen` (HTMLElement|null)
- `cart-drawer.js`: `isOpen` (boolean), `isRefreshing` / `refreshQueued` (boolean — one refresh in flight, at most one replay), `cartVersion` / `syncedVersion` / `inflightVersion` (number — cart freshness: every known mutation bumps `cartVersion`; opening the drawer only refetches when it differs from the synced/in-flight version, Fibery #220), `pendingPlatformRequests` (number — `LS.*` cart requests armed by +/−, typed quantity or remove and not yet seen completing), `syncDebounceTimer` (timeout|null — 200 ms coalescing before `refreshCart()`), `syncFallbackTimer` (timeout|null — 2.5 s safety net if no completion signal arrives), `badgeObserver` (MutationObserver|null — mirrors `.js-cart-widget-amount` to the mobile badge and signals a platform cart change). The end of a platform cart request is detected with a `PerformanceObserver` on `resource` entries (same-origin fetch/XHR under `/cart/…`), never by calling or wrapping `LS.*`.
- `product-gallery.js`: `swiper` (Swiper|null)
- `product-gallery-zoom.js`: `swiper` (Swiper|null), `isOpen` (boolean), `savedOverflow` (string)
- `product-variants.js`: `variants` (Array — parsed once from `.js-product-variants-data`; selection state itself lives in the DOM via `[data-selected]`)
- `product-add-to-cart.js`: stateless at module scope — only `const` DOM references plus `initialBuyState` (string|null), a snapshot of the server-rendered `data-state` used to restore the button after an AJAX submit
- `product-accordion.js`: `controllers` (Map — accordion item → its `setState` function, so the "Tabela de Medidas" anchor can open a section from outside its own toggle)

No module persists state to `localStorage`, `sessionStorage`, or cookies.

**S2** — Cross-module state signaling MUST use `window.*` function assignments. Complete registry (12 globals):
- `window.setHeaderMenuActive(boolean)` — defined in `header.js`, consumed by `menu.js` and `cart-drawer.js`
- `window.openModal(options)` — defined in `modal.js`, consumed by `category-filters.js`
- `window.closeModal()` — defined in `modal.js`
- `window.showToast(options)` — defined in `toast.js`, consumed by `cart-drawer.js`
- `window.showProductToast(options)` — defined in `toast.js`, consumed by `item-card-quickbuy.js`
- `window.closeToast(element)` — defined in `toast.js`
- `window.closeAllToasts()` — defined in `toast.js`
- `window.openCartDrawer()` — defined in `cart-drawer.js`, consumed by `toast.js`
- `window.closeCartDrawer()` — defined in `cart-drawer.js`
- `window.onCartUpdate()` — defined in `cart-drawer.js`, consumed by `item-card-quickbuy.js` and `product-add-to-cart.js`
- `window.initQuickbuyDropdowns()` — defined in `item-card-quickbuy.js`, consumed by `category-infinite-scroll.js`
- `window.setProductGalleryImage(imagePosition)` — defined in `product-gallery.js`, consumed by `product-variants.js`

Any new cross-module signal MUST: (1) be defined as `window.functionName = function(args) {...}` in the providing module, (2) be consumed via optional chaining `window.functionName?.(args)` in the consuming module, (3) be documented in this contract in both A5 and S2.

**S3** — UI state is expressed through FIVE mechanisms (ordered by preference for new code): (1) `hidden` attribute — for binary show/hide (`menu.js:18,31,143,161,210,216`); (2) `data-state` attribute — for multi-state components with CSS styling (`header.js:13`, `search.js:26,47`, `cart-drawer.js:48,71`); (3) `aria-expanded` attribute — for accessible toggle controls (`menu.js:144,162,196,209,215`, `product-carousel.js:194,201`); (4) `classList.add/remove` — for Tailwind utility toggling (`opacity-0`, `opacity-100`, `hidden`, `block`, `pointer-events-none`); (5) `element.style.*` — for computed/dynamic values that cannot be expressed as class toggles (`transform`, `marginBottom`, `width`, `marginLeft`, `color`, `visibility`, `display`, `overflow`). New code MUST prefer mechanisms 1-3 over 4-5 where possible. `element.style.*` MUST ONLY be used for values that are computed at runtime (scroll offsets, percentages, dynamic colors).

**S4** — No persistent state mechanism (`localStorage`, `sessionStorage`, cookies) is currently used in the custom JS modules. If persistent state is needed in future modules (e.g., "shown once" flags), it MUST use `localStorage` with keys prefixed `roma_` to avoid collisions with platform storage. NEVER use cookies for JS state. NEVER use `sessionStorage` unless the data is explicitly session-scoped.

**S5** — The product carousel maintains parallel Swiper instances in a closure map keyed by tab ID (`swipers["tab-1"]`, `swipers["tab-2"]`, `swipers["tab-3"]`). A parallel `realSlideCounts` map tracks original slide counts before loop duplication. Tab switching via `switchTab()` MUST: (1) hide all tab containers except the active one, (2) call `swiper.update()`, (3) reset to slide 0 via `swiper.slideToLoop(0, 0)`, (4) re-render pagination at index 0, (5) update controls visibility based on real slide count.

---

## 6. Theme & Customization Boundaries

**T1** — All user-facing customization MUST be defined in `config/settings.txt` and accessed via `{{ settings.SETTING_NAME }}` in templates. NEVER hardcode values that the admin should be able to change (text, colors, toggle visibility, URLs, images).

**T2** — Color customization flows through a strict chain: `settings.txt` (defines color pickers, including `accent_color`) → admin panel (user picks colors) → `style-colors.scss.tpl` (generates `--background-color`, `--primary-color`, `--text-color`, `--accent-color`, etc.) → EITHER `app.css` `@theme` block (maps `--background-color`/`--primary-color`/`--text-color` to `--color-bg`, `--color-fg`, `--color-secondary`, `--color-bg-subtle`, `--color-fg-muted`, then to Tailwind utility classes like `bg-bg`, `text-fg`, `text-secondary`) OR direct `var(--accent-color)` usage in template inline styles (`--accent-color` has no `@theme` token equivalent — it is consumed as-is). Hardcoding theme-dependent hex/rgba values anywhere in the chain is FORBIDDEN. Semi-transparent overlays using `rgba(0,0,0,*)` or `rgba(255,255,255,*)` are permitted (see A8). **KNOWN BUGS** (4 hardcoded values pending fix — see A8 for full list). These are errors to be corrected, NOT acceptable patterns.

**T3** — Font customization: `settings.font_headings` and `settings.font_rest` are loaded via Google Fonts in `layout.tpl:14,37`. The `@theme` block maps `--font-headings` → `--font-heading` and `--font-body` → `--font-sans`. **INCONSISTENCY**: The settings use `font_rest` but the CSS variable consumed in `@theme` is `--font-body` (not `--font-rest`). The mapping from `settings.font_rest` → `--font-body` CSS variable happens inside `style-colors.scss.tpl` (platform-managed). This is correct behavior but the naming mismatch (`font_rest` in settings vs `--font-body` in CSS) is a source of confusion.

**T4** — Homepage section ordering is fully admin-configurable via `home_order_position_0..12`. The code MUST NOT assume any fixed section order. The `home.tpl` template iterates 0..12 and delegates to the router. A `newArray` deduplication set prevents the same section from rendering twice.

**T5** — Product sections (`config/sections.txt`) define admin-curated product lists: `primary` (featured products), `carousel_tab_1`, `carousel_tab_2`, `carousel_tab_3`. These are accessed via `{{ sections.SECTION_NAME.products }}` in templates. Custom JS MUST NOT fetch product data via AJAX independently — it MUST consume what the template renders into the DOM.

---

## 7. External Library Integration Rules

### Tailwind CSS v4
- **Source**: `@tailwindcss/cli` v4.1.18+ (devDependency)
- **Config**: NO `tailwind.config.js`. Configuration via `@theme` directive directly in `app.css`.
- **Usage**: Utility classes in `.tpl` templates. `@apply` used once (`app.css:141` — `.powered-by-wrapper svg`).

**L1** — Tailwind v4 MUST be configured exclusively via `@theme` in `app.css`. NEVER create a `tailwind.config.js` or `tailwind.config.ts`. The `@theme` block is the ONLY place to define design tokens.

### esbuild
- **Source**: `esbuild` 0.27.2 (devDependency)
- **Config**: `esbuild.config.mjs` — IIFE format, ES2018 target, minified, sourcemap: false, platform: browser.

**L2** — esbuild output MUST target `es2018` and use `iife` format with `platform: "browser"`. NEVER use ESM format — the bundle runs in a non-module `<script>` tag loaded via Nuvemshop's `static_url | script_tag` filter. NEVER enable sourcemaps in production (the Nuvemshop CDN does not serve `.map` files).

### Swiper.js
- **Source**: NOT an npm dependency. Loaded as a global via `external.js.tpl` or `external-no-dependencies.js.tpl` inside `LS.ready.then()`.
- **Usage**: `product-carousel.js` and `menu.js` instantiate `new Swiper(container, config)` assuming `Swiper` is on `window`.
- **Load guarantee**: Swiper loads inside `LS.ready.then()` which executes BEFORE the gaius bundle. The global WILL exist at bundle execution time under normal conditions.

**L3** — Swiper MUST be used ONLY via the global `Swiper` constructor. It MUST NOT be installed as an npm dependency or imported as an ES module. Swiper is currently instantiated in two modules: `product-carousel.js` (product tab carousels) and `menu.js` (menu image carousels). Swiper configuration MUST use the options pattern: `slidesPerView`, `spaceBetween`, `loop`, and `on.slideChange`/`on.init` callbacks.

### Lucide Icons
- **Source**: `static/js/lucide.min.js` (vendored file, not npm).
- **Usage**: `lucide.createIcons()` called after page load (`layout.tpl:205-207`) and after dynamic HTML insertion in modules.

**L4** — Lucide MUST remain a vendored static file. NEVER install via npm. When calling `lucide.createIcons()` from custom modules, use EITHER `typeof lucide !== "undefined"` guard (for modules that might run before Lucide loads in edge cases) OR call directly if A12 load order is guaranteed. Current codebase uses both patterns — `menu.js` uses `typeof` guard, `hero-banner-2-carousel.js` and `product-carousel.js` call directly.

### jQuery
- **Source**: Loaded conditionally by the Nuvemshop platform (`load_jquery` flag, `layout.tpl:80-84`).
- **Usage**: ONLY in `store.js.tpl` and `external.js.tpl`.

**L5** — Custom JS modules in `__src/js/` MUST NOT use `$`, `jQuery`, `jQueryNuvem`, or any jQuery API. All DOM operations MUST use vanilla JS: `querySelector`, `querySelectorAll`, `addEventListener`, `classList`, `setAttribute`, `dataset`, `hidden`, `.style`, `innerHTML`.

### Nuvemshop Platform (LS.*)
- **Source**: Platform-injected via `{% head_content %}`.
- **Usage**: `LS.ready.then()` in `layout.tpl:163` wraps legacy script loading. `LS.search()` handles search AJAX (bound in `store.js.tpl`). `LS.removeItem()` handles cart item removal.

**L6** — `LS.*` APIs MUST ONLY be invoked from `store.js.tpl`, template `<script>` blocks, or cart-related custom modules. Custom modules MUST NOT call `LS.*` directly except for cart state-mutation APIs (`LS.removeItem`, `LS.addItem`) which have no delegation alternative via legacy jQuery bindings. Currently `cart-drawer.js` calls `LS.removeItem(itemId, true)` at lines 490 and 500. If new platform API integration is needed beyond cart mutations, it MUST be added to `store.js.tpl` and exposed to custom modules via `window.*` globals.

---

## 8. Dependency Rules

**R1** — Dependency direction: `index.js` → `modules/system/*`, `modules/category/*`, and `modules/home/*`. Each import MUST be a named export. Modules MUST NOT import from each other (no horizontal dependencies). Verified: zero cross-module imports exist in the codebase. The ONLY permitted inter-module communication is via `window.*` globals (see S2).

**R2** — Templates depend on `config/settings.txt` for conditionals and values. Settings MUST NOT depend on template structure. The dependency is one-way: `settings.txt` defines the schema, templates consume it.

**R3** — Custom JS depends on DOM structure rendered by templates via `js-*` prefixed CSS classes. These classes are the **binding contract** between templates and JS. Current contracts by module:
- `header.js`: `.js-new-header`, `.js-advertising-bar`, `.js-ad-carousel`, `.js-ad-slide`
- `menu.js`: `.js-menu-mobile`, `.js-menu-mobile-toggle`, `.js-menu-mobile-close`, `.js-menu-mobile-tab`, `.js-menu-mobile-panel`, `.js-menu-desktop-toggle`, `.js-menu-dropdown`, `.js-menu-accordion-toggle`, `.js-menu-accordion-content`, `.js-menu-carousel`, `.js-menu-carousel-controls`, `.js-menu-carousel-pagination`, `.js-menu-carousel-prev`, `.js-menu-carousel-next`, `.js-menu-carousel-seed`, `.js-icon-closed`, `.js-icon-open`, `[data-menu-desktop]`
- `search.js`: `.js-search-overlay`, `.js-search-panel`, `.js-search-input`, `.js-search-form`, `.js-search-suggest`, `.js-search-toggle`, `.js-search-close`, `.js-search-icon`, `.js-search-loading`, `.js-search-suggest-all-link`
- `hero-banner-2-carousel.js`: `.js-hero-banner-2`, `.js-hero2-slide`, `.js-hero2-pagination`, `.js-hero2-prev`, `.js-hero2-next`, `.js-hero2-arrow`, `.js-hero2-seed`
- `product-carousel.js`: `.js-product-carousel`, `.js-carousel-dropdown`, `.js-carousel-dropdown-trigger`, `.js-carousel-dropdown-label`, `.js-carousel-dropdown-list`, `.js-carousel-dropdown-icon`, `.js-carousel-dropdown-option`, `.js-carousel-tab`, `.js-carousel-pagination`, `.js-carousel-prev`, `.js-carousel-next`, `.js-carousel-controls`, `.js-carousel-seed`, `.js-swiper-product-carousel-{1,2,3}`
- `modal.js`: `.js-gaius-modal-container`, `.js-gaius-modal-content`, `.js-gaius-modal-overlay`, `.js-gaius-modal-close`, `.js-gaius-modal-body`, `.js-gaius-modal-drawer`
- `toast.js`: `.js-toast-container`, `.js-toast-close`
- `cart-drawer.js`: `.js-cart-drawer`, `.js-cart-drawer-backdrop`, `.js-cart-drawer-close`, `.js-cart-drawer-panel`, `.js-cart-drawer-toggle`, `.js-cart-drawer-footer`, `.js-cart-drawer-checkout`, `.js-ajax-cart-panel`, `.js-ajax-cart-list`, `.js-cart-item`, `.js-cart-quantity-btn`, `.js-cart-quantity-input`, `.js-cart-input-spinner`, `.js-cart-item-subtotal`, `.js-cart-remove-btn`, `.js-empty-ajax-cart`, `.js-cart-widget-amount`, `.js-cart-widget-badge`, `.js-cart-progress-complete` (template-conditional, set by `cart-drawer-progress-bars.tpl` when a bar reaches 100% — NOT controlled by `cart-drawer.js`, only styled/animated in CSS; listed here for cart-context completeness), `.js-new-header` (cross-reference), `[data-item-id]`, `[data-remove-item-id]`, `[data-removing]`
- `category-dropdown.js`: `.js-category-dropdown`, `.js-category-dropdown-trigger`, `.js-category-dropdown-list`, `.js-category-dropdown-icon`
- `category-infinite-scroll.js`: `.js-category-grid`, `.js-category-load-more`, `.js-category-load-more-btn`, `.js-category-scroll-spinner`, `[data-product-id]`, `[data-is-last]`, `[data-next-url]`
- `category-filters.js`: `.js-category-filter-trigger`, `.js-category-filter-content`, `[data-filter-title]`
- `category-sorting.js`: `.js-category-sorting`, `.js-category-sorting-trigger`, `.js-category-sorting-list`, `.js-category-sorting-icon`, `.js-category-sorting-option`
- `product-gallery.js`: `.js-product-gallery`, `.js-product-gallery-pagination`, `.js-product-gallery-prev`, `.js-product-gallery-next`, `.js-product-gallery-seed`, `.swiper-slide`, `[data-image-position]`, `[data-index]`
- `product-gallery-zoom.js`: `.js-product-gallery-zoom`, `.js-product-gallery-zoom-close`, `.js-product-gallery-zoom-backdrop`, `.js-product-gallery-zoom-swiper`, `.js-product-gallery-zoom-pagination`, `.js-product-gallery-zoom-seed`, `.js-product-gallery` (cross-reference — reads the main gallery's active slide to open on the same photo), `[data-open-gallery-zoom]`, `[data-image-position]`, `[data-index]`
- `product-variants.js`: `.js-product-variants`, `.js-product-variants-data`, `.js-product-variant-group`, `.js-product-variant-option`, `.js-product-variant-swatch`, `.js-price-display`, `.js-compare-price-display`, `[data-selected]`
- `product-add-to-cart.js`: `#product_form` (id, see A2), `.js-product-form`, `.js-product-sticky-buy-btn`, `.js-product-variants`, `.js-product-variants-data`, `.js-product-variant-group`, `.js-product-variant-option`, `.js-quantity-input`, `.js-quantity-up`, `.js-quantity-down`, `.js-price-display`, `.js-compare-price-display`, `.js-sticky-price-display`, `.js-sticky-compare-price-display`, `.js-product-name`, `.js-product-gallery` (cross-reference — reads the active photo for the toast), `.js-shipping-input`, `.js-addtocart` (legacy cross-reference — the class this flow deliberately does NOT use, so `store.js.tpl:1724` never double-fires), `[data-variants]`, `[data-selected]`, `[data-max-stock]`, `[data-stock-limit-label]`, `[data-text-cart]`, `[data-text-nostock]`
- `product-accordion.js`: `.js-accordion-item`, `.js-accordion-toggle`, `.js-accordion-content`, `.js-accordion-icon`, `a[href="#tabela-de-medidas"]` (cross-reference — any link on the page may open the size-guide section)
- `item-card-quickbuy.js`: `.js-quickbuy-container`, `.js-quickbuy-dropdown`, `.js-quickbuy-dropdown-trigger`, `.js-quickbuy-dropdown-list`, `.js-quickbuy-dropdown-icon`, `.js-quickbuy-dropdown-label`, `.js-quickbuy-dropdown-option`, `.js-quickbuy-pill`, `.js-quickbuy-add-btn`, `.js-quickbuy-variants-data`, `[data-product-id]`, `[data-product-name]`, `[data-product-price]`, `[data-product-image]`, `[data-option-name]`, `[data-selected]`

Removing or renaming ANY `js-*` class from a template REQUIRES updating the corresponding JS module.

**R4** — CSS in `app.css` targets `js-*` prefixed classes for state-driven styling. These selectors are: `.js-new-header[data-state=...]`, `.js-search-overlay[data-state=...]`, `.js-search-panel`, `.js-search-input`, `.js-menu-accordion-toggle[aria-expanded=...]`, `.js-menu-carousel-track`, `.js-menu-carousel`, `.js-menu-carousel-scrollbar`, `.js-menu-carousel-scrollbar-thumb`, `.js-toast-container [data-state=...]`, `.js-gaius-modal-container[data-state=...]`, `.js-gaius-modal-overlay`, `.js-gaius-modal-content`, `.js-gaius-modal-drawer`, `.js-gaius-modal-body`, `.js-cart-drawer[data-state=...]`, `.js-cart-drawer-backdrop`, `.js-cart-drawer-panel`, `.js-cart-progress-complete` (triggers `@keyframes progress-complete` one-shot animation, `app.css:431-439`; class is applied by the template, not by JS), `.js-price-filter-wrapper *`, `.js-category-filter-content *`, `.js-product-gallery-zoom[data-state=...]`, `.js-product-gallery-zoom-backdrop`, `.js-product-gallery-zoom-content`, `.js-product-gallery-zoom-swiper`, `.js-product-sticky-buy-bar`, `.js-product-variant-swatch[data-selected=...]`. The mobile-only block under `.js-product-sticky-buy-bar` additionally restyles `.js-cart-progress-bar` / `.js-cart-progress-label` (owned by `snipplets/cart/cart-drawer-progress-bars.tpl`, shared with the cart drawer) and adds `body.template-product .js-footer` bottom padding so the fixed bar never covers the end of the page — those three selectors are styled from the PDP context but MUST NOT be renamed without checking the cart drawer and footer as well. Renaming ANY of these classes REQUIRES updating BOTH `app.css` AND the corresponding JS module AND the template that renders the element.

**R5** — The custom bundle (`gaius-v*.js`) loads AFTER `lucide.min.js` (both are sync `<script>` tags in `layout.tpl`). This is a hard dependency: `hero-banner-2-carousel.js`, `product-carousel.js`, `menu.js`, `modal.js`, `toast.js`, `cart-drawer.js`, `category-infinite-scroll.js`, `product-accordion.js`, and `product-gallery-zoom.js` all call `lucide.createIcons()`.

**R6** — Production build order: `pre-build.js` MUST run BEFORE `esbuild.config.mjs`. The `build:js` npm script enforces this: `"node pre-build.js && node esbuild.config.mjs"`. The `watch:js` script skips `pre-build.js` (acceptable because dev mode does not need cache-busting). NEVER run `node esbuild.config.mjs` alone for production — the filename will be stale.

**R7** — The Nuvemshop CDN aggressively caches JS bundles by filename. After ANY change to `__src/js/` or `__src/css/`, you MUST run `npm run build` (NOT `node esbuild.config.mjs` alone). This triggers `pre-build.js` which generates a new epoch-based filename, busting the CDN cache. Running `node esbuild.config.mjs` directly will overwrite the existing filename and the CDN will continue serving the stale cached version.

---

## 9. Forbidden Patterns

**F1** — NEVER edit `static/css/app.tpl` or `static/js/gaius-v*.js` directly. These are build outputs regenerated by Tailwind CLI and esbuild respectively.

**F2** — NEVER use jQuery (`$`, `jQuery`, `jQueryNuvem`, `$.ajax`, `$.fn`, `.on()`, `.off()`, `.trigger()`) in `__src/js/modules/`. Vanilla JS only.

**F3** — NEVER create a `tailwind.config.js` or `tailwind.config.ts`. Tailwind v4 uses `@theme` in `app.css`.

**F4** — NEVER hardcode theme-dependent color hex/rgba values in custom CSS (`app.css`), custom JS (`__src/js/`), or templates. Use CSS custom properties (`var(--primary-color)`) or Tailwind `@theme` tokens. Tailwind palette classes (`text-red-600`, `bg-gray-100`, `text-white`…) count as hardcoded. **Permitted exceptions**: `rgba(0,0,0,*)` / `rgba(255,255,255,*)` / `bg-black/N` / `bg-white/N` as semi-transparent overlays for universal contrast, hex values in the `@theme` block (shadows, brand constants), and lines marked `lint-styles: allow admin-white|overlay` (see A8). Values like `rgba(255,255,246,0.7)` are NOT permitted — they are hardcoded off-whites that break on non-white themes. `npm run lint:styles` enforces this.

**F5** — NEVER add new files to `snipplets/svg/`. All icons MUST use Lucide (`<i data-lucide="icon-name">`). The ONLY exception: if a specific icon does NOT exist in the Lucide library, use an existing SVG snipplet. When refactoring any template, replace all SVG snipplet includes with Lucide equivalents where the icon exists.

**F6** — NEVER create self-invoking modules or side-effectful imports. Every module MUST export a named function, imported and called explicitly in `index.js`. Pattern: `export const moduleName = () => { ... };` in module, `import { moduleName } from "..."; moduleName();` in `index.js`.

**F7** — NEVER use `document.write()`, inline event handlers (`onclick=`, `onload=` in custom JS-generated HTML), or `eval()` in custom JS modules. Template-level `onload=` attributes (e.g., for async CSS loading in `layout.tpl:58`) are platform patterns and are permitted in templates only.

**F8** — NEVER install Swiper or Lucide via npm. They are loaded as vendored globals through the platform's script loading chain. Adding them to `package.json` would create duplicate instances and bundle bloat.

**F9** — NEVER import between sibling modules (e.g., `header.js` importing from `menu.js`, or `hero-banner-2-carousel.js` importing from `product-carousel.js`). Cross-module communication MUST use `window.*` globals (see S2).

**F10** — NEVER assume homepage section order or hardcode section positions. The section router (`home-section-switch.tpl`) handles ordering via `settings.home_order_position_0..12`. NEVER add a section directly to `home.tpl` outside the router loop.

---

## 10. Architectural Risk Zones

### RISK 1: Documentation ↔ Implementation Drift (RESOLVED)
The toast and modal systems are active and functional:
- `__src/js/modules/system/modal.js` — exports `modalSystem`, registers `window.openModal` and `window.closeModal`
- `__src/js/modules/system/toast.js` — exports `toastSystem`, registers `window.showToast`, `window.showProductToast`, `window.closeToast`, `window.closeAllToasts`
- `__src/js/modules/system/cart-drawer.js` — exports `cartDrawerSystem`, registers `window.openCartDrawer`, `window.closeCartDrawer`, `window.onCartUpdate`
- `snipplets/notification/modal.tpl` and `snipplets/notification/toast.tpl` — exist and are included in `layout.tpl`
- `snipplets/cart/cart-drawer.tpl` — exists and is included in `layout.tpl`
- `snipplets/cart/cart-drawer-progress-bars.tpl` — free shipping + progressive discount progress bars, included by `cart-drawer.tpl:123`
- Z-index tokens `--z-toast: 90` and `--z-modal: 100` in `@theme` are consumed by the modal and toast CSS in `app.css`

### RISK 2: Hardcoded Colors (RESOLVED — now lint-enforced)
The hardcoded theme-dependent colors found in the 2026-10-12 audit were fixed and `npm run lint:styles` now guards A8/F4 (see ADR-0003). Remaining *consistency* debt, not violations: 18 `[background:rgba(0,0,0,0.05)]` control fills that should become `bg-control` (plus the mirror in `item-card-quickbuy.js`), and recurring arbitrary sizes (`leading-[120%]`, `text-[10px]`…) that should become `@theme` tokens (ADR-0002).

### RISK 3: No Existence Guard for Swiper Global (LOW)
`product-carousel.js`, `menu.js`, `product-gallery.js` and `product-gallery-zoom.js` all call `new Swiper()` without checking `typeof Swiper !== "undefined"`. However, based on the script loading order in `layout.tpl` (Swiper loads inside `LS.ready.then()` which is a sync `<script>` block before the gaius bundle), Swiper WILL be available under normal conditions. Risk is LOW but exists if a CDN or network failure prevents external.js.tpl from loading.

### RISK 4: Bundle Version Filename Sync (LOW — operational)
`pre-build.js` uses `/gaius-v\d+\.js/g` to update filenames in `esbuild.config.mjs` and `layout.tpl`. If either file is reformatted (e.g., line breaks inside the string, or comments containing `gaius-v`) the regex may match incorrectly. Currently `esbuild.config.mjs` references `gaius-v1773358273814.js`.

### RISK 5: Search Debounce is a No-Op (LOW — functional)
`search.js:82-92` implements a debounce that tracks `lastValue` but the tracked value is never used to prevent or trigger any action. The actual search AJAX is fired by `LS.search()` (in `store.js.tpl`) which has its own binding to the input element. The debounce code creates the illusion of rate-limiting but provides zero actual throttling.

### RISK 6: Tests cover the custom layer only (LOW–MEDIUM — operational)
Since 2026-10-12 (ADR-0015) `npm test` runs Playwright against the Nuvemshop dev store (`democamisetasromadev`), headed because of Cloudflare, in `desktop` and `mobile` projects. The suite lives in `tests/` and mirrors the module contexts (`system/`, `home/`, `category/`, `product/`) plus `smoke`, `theme-colors` and `usability` (see `tests/README.md`). Pages still on legacy markup (account, blog, contact, `/cart`, search results, PDP related carousel) are only smoke-tested or skipped on purpose. `npm run lint:styles` enforces A8/F4. Invariants about the module contract (A2, A3, A5, R3) are exercised indirectly by the smoke tests; there is still no automated check for the registries themselves.

### RISK 7: setInterval Leak in Advertising Carousel (LOW)
`header.js:67` creates a `setInterval` for slide rotation but never stores the interval ID. Since `advertisingCarousel()` is called once at page load and the page is never SPA-navigated, this is unlikely to cause issues in practice. However, if the function were ever called twice, two intervals would stack.

### RISK 8: innerHTML for Pagination Renders (LOW — security)
`hero-banner-2-carousel.js:88` and `product-carousel.js:70` use `innerHTML` to render SVG pagination dots. The SVG markup is generated from module-internal data (slide indices, computed colors) — no user input is interpolated. Risk is LOW but the pattern should not be extended to render user-supplied content.

---

# ARCHITECTURE INVARIANTS (COMPACT)

```
A1  — Custom JS ONLY in __src/js/modules/{system,home,category,product,...}/, NEVER in static/
A2  — Every exported module function MUST guard with root DOM element check as first statement
A3  — All modules: named exports, import+invoke in index.js, grouped by context comment. NEVER self-execute. 20 exports: system(8), category(4), home(2), product(5)
A4  — static/ = build outputs + vendored files. NEVER edit gaius-v*.js or app.tpl
A5  — Cross-module communication ONLY via window.* (12 globals: setHeaderMenuActive, openModal, closeModal, showToast, showProductToast, closeToast, closeAllToasts, openCartDrawer, closeCartDrawer, onCartUpdate, initQuickbuyDropdowns, setProductGalleryImage)
A6  — Call lucide.createIcons() after any innerHTML with <i data-lucide="..."> markup
A7  — Bundle filename: gaius-v{Date.now()}.js, synced by pre-build.js in esbuild.config.mjs + layout.tpl
A8  — Theme-dependent colors NEVER hardcoded. Platform vars: --background-color, --primary-color, --text-color, --accent-color. Brand constants only in @theme (--color-highlight, --color-danger). rgba(0,0,0,*) and rgba(255,255,255,*) overlays permitted. Enforced by `npm run lint:styles` (ADR-0003)
A9  — data-state pattern: header (transparent|active), search (open|closed), toast (entering|visible|exiting), modal (open|closed), cart-drawer (open|closed), product-gallery-zoom (open|closed), product accordion item (open|closed)
A10 — Template includes via {% snipplet %} or {% include %}, organized by domain folder. New snipplets MUST NEVER be placed at snipplets/ root
A11 — Home sections: router in home-section-switch.tpl, keyed by settings.home_order_position_0..12
A12 — Load order: external.js→store.js→lucide.min.js→gaius bundle. Bundle assumes Swiper+lucide exist
A13 — Settings in config/settings.txt: snake_case names, grouped by category with meta/title/field blocks
A14 — Icons: Lucide is canonical. Migrating SVG snipplets → Lucide. SVG only if icon missing in Lucide
D1  — JS reads from DOM via: data-* attrs, element queries, getComputedStyle(). fetch() permitted for pagination GET + POST of a form's own action (product-add-to-cart.js) ONLY. LS.removeItem/LS.addItem permitted in cart modules ONLY. PDP owns variant selection: no LS.changeVariant
D2  — Search UI in search.js, search AJAX delegated to legacy LS.search(). No AJAX duplication
S2  — Cross-module signals: window.fn = ... (provider), window.fn?.() (consumer). 12 globals registered
S3  — UI state: hidden attr > data-state attr > aria-expanded > classList toggle > element.style
L5  — Custom JS: vanilla JS ONLY. Zero jQuery ($, jQueryNuvem) in __src/js/
L6  — LS.* APIs: ONLY from store.js.tpl, template <script> blocks, or cart modules (LS.removeItem/LS.addItem only)
R1  — No horizontal imports between sibling modules. index.js is the ONLY importer
R3  — js-* classes = binding contract between templates and JS. Full registry in Section 8, R3. Includes .js-cart-progress-complete (template-conditional, not JS-controlled)
F4  — NEVER hardcode theme-dependent colors. rgba(0,0,0,*)/rgba(255,255,255,*) overlays permitted
F5  — NEVER add new snipplets/svg/. Lucide is canonical. SVG snipplet only if icon missing in Lucide
```
