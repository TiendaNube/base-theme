/*! tailwindcss v4.1.18 | MIT License | https://tailwindcss.com */
@layer properties {
  @supports (((-webkit-hyphens: none)) and (not (margin-trim: inline))) or ((-moz-orient: inline) and (not (color: rgb(from red r g b)))) {
    *, :before, :after, ::backdrop {
      --tw-translate-x: 0;
      --tw-translate-y: 0;
      --tw-translate-z: 0;
      --tw-rotate-x: initial;
      --tw-rotate-y: initial;
      --tw-rotate-z: initial;
      --tw-skew-x: initial;
      --tw-skew-y: initial;
      --tw-scroll-snap-strictness: proximity;
      --tw-border-style: solid;
      --tw-gradient-position: initial;
      --tw-gradient-from: #0000;
      --tw-gradient-via: #0000;
      --tw-gradient-to: #0000;
      --tw-gradient-stops: initial;
      --tw-gradient-via-stops: initial;
      --tw-gradient-from-position: 0%;
      --tw-gradient-via-position: 50%;
      --tw-gradient-to-position: 100%;
      --tw-leading: initial;
      --tw-font-weight: initial;
      --tw-tracking: initial;
      --tw-shadow: 0 0 #0000;
      --tw-shadow-color: initial;
      --tw-shadow-alpha: 100%;
      --tw-inset-shadow: 0 0 #0000;
      --tw-inset-shadow-color: initial;
      --tw-inset-shadow-alpha: 100%;
      --tw-ring-color: initial;
      --tw-ring-shadow: 0 0 #0000;
      --tw-inset-ring-color: initial;
      --tw-inset-ring-shadow: 0 0 #0000;
      --tw-ring-inset: initial;
      --tw-ring-offset-width: 0px;
      --tw-ring-offset-color: #fff;
      --tw-ring-offset-shadow: 0 0 #0000;
      --tw-outline-style: solid;
      --tw-blur: initial;
      --tw-brightness: initial;
      --tw-contrast: initial;
      --tw-grayscale: initial;
      --tw-hue-rotate: initial;
      --tw-invert: initial;
      --tw-opacity: initial;
      --tw-saturate: initial;
      --tw-sepia: initial;
      --tw-drop-shadow: initial;
      --tw-drop-shadow-color: initial;
      --tw-drop-shadow-alpha: 100%;
      --tw-drop-shadow-size: initial;
      --tw-backdrop-blur: initial;
      --tw-backdrop-brightness: initial;
      --tw-backdrop-contrast: initial;
      --tw-backdrop-grayscale: initial;
      --tw-backdrop-hue-rotate: initial;
      --tw-backdrop-invert: initial;
      --tw-backdrop-opacity: initial;
      --tw-backdrop-saturate: initial;
      --tw-backdrop-sepia: initial;
      --tw-duration: initial;
      --tw-ease: initial;
      --tw-scale-x: 1;
      --tw-scale-y: 1;
      --tw-scale-z: 1;
      --tw-space-x-reverse: 0;
    }
  }
}

@layer theme {
  :root, :host {
    --font-sans: var(--font-body);
    --font-mono: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
    --color-red-600: oklch(57.7% .245 27.325);
    --color-red-950: oklch(25.8% .092 26.042);
    --color-orange-100: oklch(95.4% .038 75.164);
    --color-amber-300: oklch(87.9% .169 91.605);
    --color-green-600: oklch(62.7% .194 149.214);
    --color-green-700: oklch(52.7% .154 150.069);
    --color-gray-100: oklch(96.7% .003 264.542);
    --color-zinc-500: oklch(55.2% .016 285.938);
    --color-neutral-500: oklch(55.6% 0 0);
    --color-black: #000;
    --color-white: #fff;
    --spacing: .25rem;
    --container-2xl: 42rem;
    --container-3xl: 48rem;
    --text-xs: .75rem;
    --text-xs--line-height: calc(1 / .75);
    --text-sm: .875rem;
    --text-sm--line-height: calc(1.25 / .875);
    --text-base: 1rem;
    --text-base--line-height: calc(1.5 / 1);
    --text-lg: 1.125rem;
    --text-lg--line-height: calc(1.75 / 1.125);
    --text-xl: 1.25rem;
    --text-xl--line-height: calc(1.75 / 1.25);
    --text-2xl: 1.5rem;
    --text-2xl--line-height: calc(2 / 1.5);
    --text-3xl: 1.875rem;
    --text-3xl--line-height: calc(2.25 / 1.875);
    --text-4xl: 2.25rem;
    --text-4xl--line-height: calc(2.5 / 2.25);
    --text-5xl: 3rem;
    --text-5xl--line-height: 1;
    --text-6xl: 3.75rem;
    --text-6xl--line-height: 1;
    --font-weight-normal: 400;
    --font-weight-medium: 500;
    --font-weight-semibold: 600;
    --font-weight-bold: 700;
    --font-weight-extrabold: 800;
    --tracking-wide: .025em;
    --tracking-wider: .05em;
    --tracking-widest: .1em;
    --leading-tight: 1.25;
    --leading-snug: 1.375;
    --leading-relaxed: 1.625;
    --radius-sm: .25rem;
    --radius-md: .375rem;
    --radius-lg: .5rem;
    --radius-xl: .75rem;
    --shadow-xl: 0 20px 25px -5px #0000001a, 0 8px 10px -6px #0000001a;
    --ease-in: cubic-bezier(.4, 0, 1, 1);
    --ease-out: cubic-bezier(0, 0, .2, 1);
    --ease-in-out: cubic-bezier(.4, 0, .2, 1);
    --animate-spin: spin 1s linear infinite;
    --blur-sm: 8px;
    --default-transition-duration: .15s;
    --default-transition-timing-function: cubic-bezier(.4, 0, .2, 1);
    --default-font-family: var(--font-sans);
    --default-mono-font-family: var(--font-mono);
    --color-bg: var(--background-color);
    --color-fg: var(--primary-color);
    --color-secondary: var(--text-color);
    --color-bg-subtle: var(--background-color);
  }

  @supports (color: color-mix(in lab, red, red)) {
    :root, :host {
      --color-bg-subtle: color-mix(in srgb, var(--background-color) 95%, var(--primary-color) 5%);
    }
  }

  :root, :host {
    --color-fg-muted: var(--primary-color);
  }

  @supports (color: color-mix(in lab, red, red)) {
    :root, :host {
      --color-fg-muted: color-mix(in srgb, var(--primary-color) 60%, var(--background-color) 40%);
    }
  }

  :root, :host {
    --color-control: var(--text-color);
  }

  @supports (color: color-mix(in lab, red, red)) {
    :root, :host {
      --color-control: color-mix(in srgb, var(--text-color) 5%, transparent);
    }
  }

  :root, :host {
    --color-highlight: #2dcc57;
    --color-danger: #dc2626;
    --font-heading: var(--font-headings);
    --z-40: 40;
    --z-50: 50;
    --z-cart-drawer: 90;
    --z-toast: 80;
    --z-modal: 100;
    --transition-duration-150: .15s;
    --transition-duration-200: .2s;
    --transition-duration-300: .3s;
    --transition-duration-500: .5s;
    --transition-duration-700: .7s;
  }
}

@layer base {
  *, :after, :before, ::backdrop {
    box-sizing: border-box;
    border: 0 solid;
    margin: 0;
    padding: 0;
  }

  ::file-selector-button {
    box-sizing: border-box;
    border: 0 solid;
    margin: 0;
    padding: 0;
  }

  html, :host {
    -webkit-text-size-adjust: 100%;
    tab-size: 4;
    line-height: 1.5;
    font-family: var(--default-font-family, ui-sans-serif, system-ui, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji");
    font-feature-settings: var(--default-font-feature-settings, normal);
    font-variation-settings: var(--default-font-variation-settings, normal);
    -webkit-tap-highlight-color: transparent;
  }

  hr {
    height: 0;
    color: inherit;
    border-top-width: 1px;
  }

  abbr:where([title]) {
    -webkit-text-decoration: underline dotted;
    text-decoration: underline dotted;
  }

  h1, h2, h3, h4, h5, h6 {
    font-size: inherit;
    font-weight: inherit;
  }

  a {
    color: inherit;
    -webkit-text-decoration: inherit;
    -webkit-text-decoration: inherit;
    -webkit-text-decoration: inherit;
    text-decoration: inherit;
  }

  b, strong {
    font-weight: bolder;
  }

  code, kbd, samp, pre {
    font-family: var(--default-mono-font-family, ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace);
    font-feature-settings: var(--default-mono-font-feature-settings, normal);
    font-variation-settings: var(--default-mono-font-variation-settings, normal);
    font-size: 1em;
  }

  small {
    font-size: 80%;
  }

  sub, sup {
    vertical-align: baseline;
    font-size: 75%;
    line-height: 0;
    position: relative;
  }

  sub {
    bottom: -.25em;
  }

  sup {
    top: -.5em;
  }

  table {
    text-indent: 0;
    border-color: inherit;
    border-collapse: collapse;
  }

  :-moz-focusring {
    outline: auto;
  }

  progress {
    vertical-align: baseline;
  }

  summary {
    display: list-item;
  }

  ol, ul, menu {
    list-style: none;
  }

  img, svg, video, canvas, audio, iframe, embed, object {
    vertical-align: middle;
    display: block;
  }

  img, video {
    max-width: 100%;
    height: auto;
  }

  button, input, select, optgroup, textarea {
    font: inherit;
    font-feature-settings: inherit;
    font-variation-settings: inherit;
    letter-spacing: inherit;
    color: inherit;
    opacity: 1;
    background-color: #0000;
    border-radius: 0;
  }

  ::file-selector-button {
    font: inherit;
    font-feature-settings: inherit;
    font-variation-settings: inherit;
    letter-spacing: inherit;
    color: inherit;
    opacity: 1;
    background-color: #0000;
    border-radius: 0;
  }

  :where(select:is([multiple], [size])) optgroup {
    font-weight: bolder;
  }

  :where(select:is([multiple], [size])) optgroup option {
    padding-inline-start: 20px;
  }

  ::file-selector-button {
    margin-inline-end: 4px;
  }

  ::placeholder {
    opacity: 1;
  }

  @supports (not ((-webkit-appearance: -apple-pay-button))) or (contain-intrinsic-size: 1px) {
    ::placeholder {
      color: currentColor;
    }

    @supports (color: color-mix(in lab, red, red)) {
      ::placeholder {
        color: color-mix(in oklab, currentcolor 50%, transparent);
      }
    }
  }

  textarea {
    resize: vertical;
  }

  ::-webkit-search-decoration {
    -webkit-appearance: none;
  }

  ::-webkit-date-and-time-value {
    min-height: 1lh;
    text-align: inherit;
  }

  ::-webkit-datetime-edit {
    display: inline-flex;
  }

  ::-webkit-datetime-edit-fields-wrapper {
    padding: 0;
  }

  ::-webkit-datetime-edit {
    padding-block: 0;
  }

  ::-webkit-datetime-edit-year-field {
    padding-block: 0;
  }

  ::-webkit-datetime-edit-month-field {
    padding-block: 0;
  }

  ::-webkit-datetime-edit-day-field {
    padding-block: 0;
  }

  ::-webkit-datetime-edit-hour-field {
    padding-block: 0;
  }

  ::-webkit-datetime-edit-minute-field {
    padding-block: 0;
  }

  ::-webkit-datetime-edit-second-field {
    padding-block: 0;
  }

  ::-webkit-datetime-edit-millisecond-field {
    padding-block: 0;
  }

  ::-webkit-datetime-edit-meridiem-field {
    padding-block: 0;
  }

  ::-webkit-calendar-picker-indicator {
    line-height: 1;
  }

  :-moz-ui-invalid {
    box-shadow: none;
  }

  button, input:where([type="button"], [type="reset"], [type="submit"]) {
    appearance: button;
  }

  ::file-selector-button {
    appearance: button;
  }

  ::-webkit-inner-spin-button {
    height: auto;
  }

  ::-webkit-outer-spin-button {
    height: auto;
  }

  [hidden]:where(:not([hidden="until-found"])) {
    display: none !important;
  }
}

@layer components;

@layer utilities {
  .pointer-events-none {
    pointer-events: none;
  }

  .collapse {
    visibility: collapse;
  }

  .invisible {
    visibility: hidden;
  }

  .visible {
    visibility: visible;
  }

  .sr-only {
    clip-path: inset(50%);
    white-space: nowrap;
    border-width: 0;
    width: 1px;
    height: 1px;
    margin: -1px;
    padding: 0;
    position: absolute;
    overflow: hidden;
  }

  .absolute {
    position: absolute;
  }

  .fixed {
    position: fixed;
  }

  .relative {
    position: relative;
  }

  .static {
    position: static;
  }

  .sticky {
    position: sticky;
  }

  .inset-0 {
    inset: calc(var(--spacing) * 0);
  }

  .inset-x-0 {
    inset-inline: calc(var(--spacing) * 0);
  }

  .-top-1 {
    top: calc(var(--spacing) * -1);
  }

  .-top-1\.5 {
    top: calc(var(--spacing) * -1.5);
  }

  .top-0 {
    top: calc(var(--spacing) * 0);
  }

  .top-1 {
    top: calc(var(--spacing) * 1);
  }

  .top-1\/2 {
    top: 50%;
  }

  .top-4 {
    top: calc(var(--spacing) * 4);
  }

  .top-20 {
    top: calc(var(--spacing) * 20);
  }

  .top-full {
    top: 100%;
  }

  .-right-2 {
    right: calc(var(--spacing) * -2);
  }

  .right-0 {
    right: calc(var(--spacing) * 0);
  }

  .right-1 {
    right: calc(var(--spacing) * 1);
  }

  .right-2 {
    right: calc(var(--spacing) * 2);
  }

  .right-4 {
    right: calc(var(--spacing) * 4);
  }

  .bottom-0 {
    bottom: calc(var(--spacing) * 0);
  }

  .bottom-2 {
    bottom: calc(var(--spacing) * 2);
  }

  .bottom-4 {
    bottom: calc(var(--spacing) * 4);
  }

  .bottom-6 {
    bottom: calc(var(--spacing) * 6);
  }

  .bottom-16 {
    bottom: calc(var(--spacing) * 16);
  }

  .bottom-full {
    bottom: 100%;
  }

  .left-0 {
    left: calc(var(--spacing) * 0);
  }

  .left-1 {
    left: calc(var(--spacing) * 1);
  }

  .left-1\/2 {
    left: 50%;
  }

  .z-\(--z-modal\) {
    z-index: var(--z-modal);
  }

  .z-0 {
    z-index: 0;
  }

  .z-10 {
    z-index: 10;
  }

  .z-20 {
    z-index: 20;
  }

  .z-40 {
    z-index: 40;
  }

  .z-50 {
    z-index: 50;
  }

  .z-80 {
    z-index: 80;
  }

  .z-90 {
    z-index: 90;
  }

  .z-100 {
    z-index: 100;
  }

  .z-9999 {
    z-index: 9999;
  }

  .order-0 {
    order: 0;
  }

  .order-1 {
    order: 1;
  }

  .order-2 {
    order: 2;
  }

  .order-3 {
    order: 3;
  }

  .order-4 {
    order: 4;
  }

  .order-5 {
    order: 5;
  }

  .order-6 {
    order: 6;
  }

  .order-7 {
    order: 7;
  }

  .order-8 {
    order: 8;
  }

  .order-9 {
    order: 9;
  }

  .order-10 {
    order: 10;
  }

  .order-11 {
    order: 11;
  }

  .order-12 {
    order: 12;
  }

  .order-first {
    order: -9999;
  }

  .order-last {
    order: 9999;
  }

  .col-1 {
    grid-column: 1;
  }

  .col-2 {
    grid-column: 2;
  }

  .col-3 {
    grid-column: 3;
  }

  .col-4 {
    grid-column: 4;
  }

  .col-5 {
    grid-column: 5;
  }

  .col-6 {
    grid-column: 6;
  }

  .col-7 {
    grid-column: 7;
  }

  .col-8 {
    grid-column: 8;
  }

  .col-9 {
    grid-column: 9;
  }

  .col-10 {
    grid-column: 10;
  }

  .col-11 {
    grid-column: 11;
  }

  .col-12 {
    grid-column: 12;
  }

  .col-auto {
    grid-column: auto;
  }

  .float-left {
    float: left;
  }

  .float-none {
    float: none;
  }

  .float-right {
    float: right;
  }

  .clear-both {
    clear: both;
  }

  .container {
    width: 100%;
  }

  @media (min-width: 40rem) {
    .container {
      max-width: 40rem;
    }
  }

  @media (min-width: 48rem) {
    .container {
      max-width: 48rem;
    }
  }

  @media (min-width: 64rem) {
    .container {
      max-width: 64rem;
    }
  }

  @media (min-width: 80rem) {
    .container {
      max-width: 80rem;
    }
  }

  @media (min-width: 96rem) {
    .container {
      max-width: 96rem;
    }
  }

  .\!m-0 {
    margin: calc(var(--spacing) * 0) !important;
  }

  .m-0 {
    margin: calc(var(--spacing) * 0);
  }

  .m-1 {
    margin: calc(var(--spacing) * 1);
  }

  .m-2 {
    margin: calc(var(--spacing) * 2);
  }

  .m-3 {
    margin: calc(var(--spacing) * 3);
  }

  .m-4 {
    margin: calc(var(--spacing) * 4);
  }

  .m-5 {
    margin: calc(var(--spacing) * 5);
  }

  .m-auto {
    margin: auto;
  }

  .mx-0 {
    margin-inline: calc(var(--spacing) * 0);
  }

  .mx-1 {
    margin-inline: calc(var(--spacing) * 1);
  }

  .mx-2 {
    margin-inline: calc(var(--spacing) * 2);
  }

  .mx-3 {
    margin-inline: calc(var(--spacing) * 3);
  }

  .mx-4 {
    margin-inline: calc(var(--spacing) * 4);
  }

  .mx-5 {
    margin-inline: calc(var(--spacing) * 5);
  }

  .mx-10 {
    margin-inline: calc(var(--spacing) * 10);
  }

  .mx-auto {
    margin-inline: auto;
  }

  .my-0 {
    margin-block: calc(var(--spacing) * 0);
  }

  .my-1 {
    margin-block: calc(var(--spacing) * 1);
  }

  .my-2 {
    margin-block: calc(var(--spacing) * 2);
  }

  .my-3 {
    margin-block: calc(var(--spacing) * 3);
  }

  .my-4 {
    margin-block: calc(var(--spacing) * 4);
  }

  .my-5 {
    margin-block: calc(var(--spacing) * 5);
  }

  .my-auto {
    margin-block: auto;
  }

  .-mt-2 {
    margin-top: calc(var(--spacing) * -2);
  }

  .mt-0 {
    margin-top: calc(var(--spacing) * 0);
  }

  .mt-0\.5 {
    margin-top: calc(var(--spacing) * .5);
  }

  .mt-1 {
    margin-top: calc(var(--spacing) * 1);
  }

  .mt-2 {
    margin-top: calc(var(--spacing) * 2);
  }

  .mt-3 {
    margin-top: calc(var(--spacing) * 3);
  }

  .mt-4 {
    margin-top: calc(var(--spacing) * 4);
  }

  .mt-5 {
    margin-top: calc(var(--spacing) * 5);
  }

  .mt-6 {
    margin-top: calc(var(--spacing) * 6);
  }

  .mt-auto {
    margin-top: auto;
  }

  .mt-px {
    margin-top: 1px;
  }

  .-mr-2 {
    margin-right: calc(var(--spacing) * -2);
  }

  .mr-0 {
    margin-right: calc(var(--spacing) * 0);
  }

  .mr-1 {
    margin-right: calc(var(--spacing) * 1);
  }

  .mr-2 {
    margin-right: calc(var(--spacing) * 2);
  }

  .mr-3 {
    margin-right: calc(var(--spacing) * 3);
  }

  .mb-0 {
    margin-bottom: calc(var(--spacing) * 0);
  }

  .mb-1 {
    margin-bottom: calc(var(--spacing) * 1);
  }

  .mb-2 {
    margin-bottom: calc(var(--spacing) * 2);
  }

  .mb-3 {
    margin-bottom: calc(var(--spacing) * 3);
  }

  .mb-4 {
    margin-bottom: calc(var(--spacing) * 4);
  }

  .mb-5 {
    margin-bottom: calc(var(--spacing) * 5);
  }

  .mb-6 {
    margin-bottom: calc(var(--spacing) * 6);
  }

  .-ml-2 {
    margin-left: calc(var(--spacing) * -2);
  }

  .-ml-2\.5 {
    margin-left: calc(var(--spacing) * -2.5);
  }

  .-ml-3\.5 {
    margin-left: calc(var(--spacing) * -3.5);
  }

  .-ml-\[3px\] {
    margin-left: -3px;
  }

  .ml-1 {
    margin-left: calc(var(--spacing) * 1);
  }

  .ml-2 {
    margin-left: calc(var(--spacing) * 2);
  }

  .ml-3 {
    margin-left: calc(var(--spacing) * 3);
  }

  .ml-4 {
    margin-left: calc(var(--spacing) * 4);
  }

  .line-clamp-2 {
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    display: -webkit-box;
    overflow: hidden;
  }

  .block {
    display: block;
  }

  .contents {
    display: contents;
  }

  .flex {
    display: flex;
  }

  .grid {
    display: grid;
  }

  .hidden {
    display: none;
  }

  .inline {
    display: inline;
  }

  .inline-block {
    display: inline-block;
  }

  .inline-flex {
    display: inline-flex;
  }

  .list-item {
    display: list-item;
  }

  .table {
    display: table;
  }

  .aspect-4\/5, .aspect-\[4\/5\] {
    aspect-ratio: 4 / 5;
  }

  .aspect-\[438\/548\] {
    aspect-ratio: 438 / 548;
  }

  .size-1 {
    width: calc(var(--spacing) * 1);
    height: calc(var(--spacing) * 1);
  }

  .size-8 {
    width: calc(var(--spacing) * 8);
    height: calc(var(--spacing) * 8);
  }

  .h-1 {
    height: calc(var(--spacing) * 1);
  }

  .h-1\.5 {
    height: calc(var(--spacing) * 1.5);
  }

  .h-3 {
    height: calc(var(--spacing) * 3);
  }

  .h-3\.5 {
    height: calc(var(--spacing) * 3.5);
  }

  .h-4 {
    height: calc(var(--spacing) * 4);
  }

  .h-4\.5 {
    height: calc(var(--spacing) * 4.5);
  }

  .h-5 {
    height: calc(var(--spacing) * 5);
  }

  .h-6 {
    height: calc(var(--spacing) * 6);
  }

  .h-7 {
    height: calc(var(--spacing) * 7);
  }

  .h-8 {
    height: calc(var(--spacing) * 8);
  }

  .h-10 {
    height: calc(var(--spacing) * 10);
  }

  .h-11 {
    height: calc(var(--spacing) * 11);
  }

  .h-12 {
    height: calc(var(--spacing) * 12);
  }

  .h-16 {
    height: calc(var(--spacing) * 16);
  }

  .h-22 {
    height: calc(var(--spacing) * 22);
  }

  .h-25 {
    height: calc(var(--spacing) * 25);
  }

  .h-100 {
    height: calc(var(--spacing) * 100);
  }

  .h-150 {
    height: calc(var(--spacing) * 150);
  }

  .h-170 {
    height: calc(var(--spacing) * 170);
  }

  .h-\[76px\] {
    height: 76px;
  }

  .h-\[77px\] {
    height: 77px;
  }

  .h-\[596\.4px\] {
    height: 596.4px;
  }

  .h-\[819\.2px\] {
    height: 819.2px;
  }

  .h-auto {
    height: auto;
  }

  .h-dvh {
    height: 100dvh;
  }

  .h-full {
    height: 100%;
  }

  .h-px {
    height: 1px;
  }

  .max-h-12 {
    max-height: calc(var(--spacing) * 12);
  }

  .max-h-16 {
    max-height: calc(var(--spacing) * 16);
  }

  .max-h-32 {
    max-height: calc(var(--spacing) * 32);
  }

  .max-h-dvh {
    max-height: 100dvh;
  }

  .max-h-full {
    max-height: 100%;
  }

  .min-h-0 {
    min-height: calc(var(--spacing) * 0);
  }

  .min-h-3\.5 {
    min-height: calc(var(--spacing) * 3.5);
  }

  .min-h-10 {
    min-height: calc(var(--spacing) * 10);
  }

  .min-h-108 {
    min-height: calc(var(--spacing) * 108);
  }

  .min-h-145 {
    min-height: calc(var(--spacing) * 145);
  }

  .min-h-\[calc\(2\*13px\*1\.2\)\] {
    min-height: 31.2px;
  }

  .w-1 {
    width: calc(var(--spacing) * 1);
  }

  .w-1\/2 {
    width: 50%;
  }

  .w-3 {
    width: calc(var(--spacing) * 3);
  }

  .w-3\.5 {
    width: calc(var(--spacing) * 3.5);
  }

  .w-4 {
    width: calc(var(--spacing) * 4);
  }

  .w-5 {
    width: calc(var(--spacing) * 5);
  }

  .w-6 {
    width: calc(var(--spacing) * 6);
  }

  .w-7 {
    width: calc(var(--spacing) * 7);
  }

  .w-8 {
    width: calc(var(--spacing) * 8);
  }

  .w-10 {
    width: calc(var(--spacing) * 10);
  }

  .w-12 {
    width: calc(var(--spacing) * 12);
  }

  .w-16 {
    width: calc(var(--spacing) * 16);
  }

  .w-40 {
    width: calc(var(--spacing) * 40);
  }

  .w-70 {
    width: calc(var(--spacing) * 70);
  }

  .w-78 {
    width: calc(var(--spacing) * 78);
  }

  .w-100 {
    width: calc(var(--spacing) * 100);
  }

  .w-\[40\%\] {
    width: 40%;
  }

  .w-\[90vw\] {
    width: 90vw;
  }

  .w-\[95px\] {
    width: 95px;
  }

  .w-\[196\.5px\] {
    width: 196.5px;
  }

  .w-\[234px\]\! {
    width: 234px !important;
  }

  .w-\[241px\] {
    width: 241px;
  }

  .w-\[393px\] {
    width: 393px;
  }

  .w-auto {
    width: auto;
  }

  .w-fit {
    width: fit-content;
  }

  .w-full {
    width: 100%;
  }

  .max-w-2xl {
    max-width: var(--container-2xl);
  }

  .max-w-3xl {
    max-width: var(--container-3xl);
  }

  .max-w-16 {
    max-width: calc(var(--spacing) * 16);
  }

  .max-w-100 {
    max-width: calc(var(--spacing) * 100);
  }

  .max-w-105 {
    max-width: calc(var(--spacing) * 105);
  }

  .max-w-125 {
    max-width: calc(var(--spacing) * 125);
  }

  .max-w-350 {
    max-width: calc(var(--spacing) * 350);
  }

  .max-w-\[383px\] {
    max-width: 383px;
  }

  .max-w-full {
    max-width: 100%;
  }

  .min-w-0 {
    min-width: calc(var(--spacing) * 0);
  }

  .min-w-4 {
    min-width: calc(var(--spacing) * 4);
  }

  .min-w-8 {
    min-width: calc(var(--spacing) * 8);
  }

  .min-w-10 {
    min-width: calc(var(--spacing) * 10);
  }

  .min-w-12 {
    min-width: calc(var(--spacing) * 12);
  }

  .min-w-16 {
    min-width: calc(var(--spacing) * 16);
  }

  .min-w-48 {
    min-width: calc(var(--spacing) * 48);
  }

  .min-w-60 {
    min-width: calc(var(--spacing) * 60);
  }

  .min-w-145 {
    min-width: calc(var(--spacing) * 145);
  }

  .min-w-full {
    min-width: 100%;
  }

  .min-w-max {
    min-width: max-content;
  }

  .flex-1 {
    flex: 1;
  }

  .flex-none {
    flex: none;
  }

  .flex-shrink {
    flex-shrink: 1;
  }

  .flex-shrink-0 {
    flex-shrink: 0;
  }

  .flex-shrink-1, .shrink {
    flex-shrink: 1;
  }

  .shrink-0 {
    flex-shrink: 0;
  }

  .flex-grow {
    flex-grow: 1;
  }

  .flex-grow-0 {
    flex-grow: 0;
  }

  .grow {
    flex-grow: 1;
  }

  .border-collapse {
    border-collapse: collapse;
  }

  .-translate-x-1 {
    --tw-translate-x: calc(var(--spacing) * -1);
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }

  .-translate-x-1\/2 {
    --tw-translate-x: calc(calc(1 / 2 * 100%) * -1);
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }

  .-translate-y-1 {
    --tw-translate-y: calc(var(--spacing) * -1);
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }

  .transform {
    transform: var(--tw-rotate-x, ) var(--tw-rotate-y, ) var(--tw-rotate-z, ) var(--tw-skew-x, ) var(--tw-skew-y, );
  }

  .animate-spin {
    animation: var(--animate-spin);
  }

  .cursor-pointer {
    cursor: pointer;
  }

  .resize {
    resize: both;
  }

  .snap-x {
    scroll-snap-type: x var(--tw-scroll-snap-strictness);
  }

  .snap-mandatory {
    --tw-scroll-snap-strictness: mandatory;
  }

  .snap-start {
    scroll-snap-align: start;
  }

  .list-none {
    list-style-type: none;
  }

  .\[appearance\:textfield\] {
    appearance: textfield;
  }

  .appearance-none {
    appearance: none;
  }

  .grid-cols-1 {
    grid-template-columns: repeat(1, minmax(0, 1fr));
  }

  .grid-cols-2 {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .flex-col {
    flex-direction: column;
  }

  .flex-row {
    flex-direction: row;
  }

  .flex-row-reverse {
    flex-direction: row-reverse;
  }

  .flex-nowrap {
    flex-wrap: nowrap;
  }

  .flex-wrap {
    flex-wrap: wrap;
  }

  .flex-wrap-reverse {
    flex-wrap: wrap-reverse;
  }

  .content-start {
    align-content: flex-start;
  }

  .items-baseline {
    align-items: baseline;
  }

  .items-center {
    align-items: center;
  }

  .items-end {
    align-items: flex-end;
  }

  .items-start {
    align-items: flex-start;
  }

  .items-stretch {
    align-items: stretch;
  }

  .justify-between {
    justify-content: space-between;
  }

  .justify-center {
    justify-content: center;
  }

  .justify-end {
    justify-content: flex-end;
  }

  .justify-start {
    justify-content: flex-start;
  }

  .gap-0 {
    gap: calc(var(--spacing) * 0);
  }

  .gap-1 {
    gap: calc(var(--spacing) * 1);
  }

  .gap-1\.5 {
    gap: calc(var(--spacing) * 1.5);
  }

  .gap-1\.25 {
    gap: calc(var(--spacing) * 1.25);
  }

  .gap-1\.75 {
    gap: calc(var(--spacing) * 1.75);
  }

  .gap-2 {
    gap: calc(var(--spacing) * 2);
  }

  .gap-2\.5 {
    gap: calc(var(--spacing) * 2.5);
  }

  .gap-3 {
    gap: calc(var(--spacing) * 3);
  }

  .gap-4 {
    gap: calc(var(--spacing) * 4);
  }

  .gap-6 {
    gap: calc(var(--spacing) * 6);
  }

  .gap-8 {
    gap: calc(var(--spacing) * 8);
  }

  .gap-12 {
    gap: calc(var(--spacing) * 12);
  }

  .gap-\[13px\] {
    gap: 13px;
  }

  .gap-x-0\.5 {
    column-gap: calc(var(--spacing) * .5);
  }

  .gap-x-4 {
    column-gap: calc(var(--spacing) * 4);
  }

  .gap-x-5 {
    column-gap: calc(var(--spacing) * 5);
  }

  .gap-x-6 {
    column-gap: calc(var(--spacing) * 6);
  }

  .gap-y-0\.5 {
    row-gap: calc(var(--spacing) * .5);
  }

  .gap-y-3 {
    row-gap: calc(var(--spacing) * 3);
  }

  .gap-y-4 {
    row-gap: calc(var(--spacing) * 4);
  }

  .self-center {
    align-self: center;
  }

  .self-start {
    align-self: flex-start;
  }

  .self-stretch {
    align-self: stretch;
  }

  .truncate {
    text-overflow: ellipsis;
    white-space: nowrap;
    overflow: hidden;
  }

  .overflow-hidden {
    overflow: hidden;
  }

  .overflow-x-auto {
    overflow-x: auto;
  }

  .overflow-y-auto {
    overflow-y: auto;
  }

  .overflow-y-clip {
    overflow-y: clip;
  }

  .rounded {
    border-radius: .25rem;
  }

  .rounded-full {
    border-radius: 3.40282e38px;
  }

  .rounded-lg {
    border-radius: var(--radius-lg);
  }

  .rounded-md {
    border-radius: var(--radius-md);
  }

  .rounded-sm {
    border-radius: var(--radius-sm);
  }

  .rounded-xl {
    border-radius: var(--radius-xl);
  }

  .border {
    border-style: var(--tw-border-style);
    border-width: 1px;
  }

  .border-0 {
    border-style: var(--tw-border-style);
    border-width: 0;
  }

  .border-t {
    border-top-style: var(--tw-border-style);
    border-top-width: 1px;
  }

  .border-r-2 {
    border-right-style: var(--tw-border-style);
    border-right-width: 2px;
  }

  .border-b {
    border-bottom-style: var(--tw-border-style);
    border-bottom-width: 1px;
  }

  .border-b-2 {
    border-bottom-style: var(--tw-border-style);
    border-bottom-width: 2px;
  }

  .border-none {
    --tw-border-style: none;
    border-style: none;
  }

  .border-solid {
    --tw-border-style: solid;
    border-style: solid;
  }

  .border-bg {
    border-color: var(--color-bg);
  }

  .border-bg-subtle {
    border-color: var(--color-bg-subtle);
  }

  .border-black {
    border-color: var(--color-black);
  }

  .border-black\/8 {
    border-color: #00000014;
  }

  @supports (color: color-mix(in lab, red, red)) {
    .border-black\/8 {
      border-color: color-mix(in oklab, var(--color-black) 8%, transparent);
    }
  }

  .border-black\/10 {
    border-color: #0000001a;
  }

  @supports (color: color-mix(in lab, red, red)) {
    .border-black\/10 {
      border-color: color-mix(in oklab, var(--color-black) 10%, transparent);
    }
  }

  .border-fg {
    border-color: var(--color-fg);
  }

  .border-secondary, .border-secondary\/12 {
    border-color: var(--color-secondary);
  }

  @supports (color: color-mix(in lab, red, red)) {
    .border-secondary\/12 {
      border-color: color-mix(in oklab, var(--color-secondary) 12%, transparent);
    }
  }

  .border-secondary\/20 {
    border-color: var(--color-secondary);
  }

  @supports (color: color-mix(in lab, red, red)) {
    .border-secondary\/20 {
      border-color: color-mix(in oklab, var(--color-secondary) 20%, transparent);
    }
  }

  .border-transparent {
    border-color: #0000;
  }

  .border-white {
    border-color: var(--color-white);
  }

  .border-white\/10 {
    border-color: #ffffff1a;
  }

  @supports (color: color-mix(in lab, red, red)) {
    .border-white\/10 {
      border-color: color-mix(in oklab, var(--color-white) 10%, transparent);
    }
  }

  .bg-bg {
    background-color: var(--color-bg);
  }

  .bg-bg-subtle {
    background-color: var(--color-bg-subtle);
  }

  .bg-bg\/70 {
    background-color: var(--color-bg);
  }

  @supports (color: color-mix(in lab, red, red)) {
    .bg-bg\/70 {
      background-color: color-mix(in oklab, var(--color-bg) 70%, transparent);
    }
  }

  .bg-bg\/80 {
    background-color: var(--color-bg);
  }

  @supports (color: color-mix(in lab, red, red)) {
    .bg-bg\/80 {
      background-color: color-mix(in oklab, var(--color-bg) 80%, transparent);
    }
  }

  .bg-black {
    background-color: var(--color-black);
  }

  .bg-black\/5 {
    background-color: #0000000d;
  }

  @supports (color: color-mix(in lab, red, red)) {
    .bg-black\/5 {
      background-color: color-mix(in oklab, var(--color-black) 5%, transparent);
    }
  }

  .bg-black\/5\! {
    background-color: #0000000d !important;
  }

  @supports (color: color-mix(in lab, red, red)) {
    .bg-black\/5\! {
      background-color: color-mix(in oklab, var(--color-black) 5%, transparent) !important;
    }
  }

  .bg-black\/10 {
    background-color: #0000001a;
  }

  @supports (color: color-mix(in lab, red, red)) {
    .bg-black\/10 {
      background-color: color-mix(in oklab, var(--color-black) 10%, transparent);
    }
  }

  .bg-black\/30 {
    background-color: #0000004d;
  }

  @supports (color: color-mix(in lab, red, red)) {
    .bg-black\/30 {
      background-color: color-mix(in oklab, var(--color-black) 30%, transparent);
    }
  }

  .bg-black\/35 {
    background-color: #00000059;
  }

  @supports (color: color-mix(in lab, red, red)) {
    .bg-black\/35 {
      background-color: color-mix(in oklab, var(--color-black) 35%, transparent);
    }
  }

  .bg-control {
    background-color: var(--color-control);
  }

  .bg-fg {
    background-color: var(--color-fg);
  }

  .bg-fg-muted {
    background-color: var(--color-fg-muted);
  }

  .bg-gray-100 {
    background-color: var(--color-gray-100);
  }

  .bg-green-700 {
    background-color: var(--color-green-700);
  }

  .bg-highlight {
    background-color: var(--color-highlight);
  }

  .bg-orange-100 {
    background-color: var(--color-orange-100);
  }

  .bg-secondary, .bg-secondary\/10 {
    background-color: var(--color-secondary);
  }

  @supports (color: color-mix(in lab, red, red)) {
    .bg-secondary\/10 {
      background-color: color-mix(in oklab, var(--color-secondary) 10%, transparent);
    }
  }

  .bg-transparent {
    background-color: #0000;
  }

  .bg-white {
    background-color: var(--color-white);
  }

  .bg-white\/5 {
    background-color: #ffffff0d;
  }

  @supports (color: color-mix(in lab, red, red)) {
    .bg-white\/5 {
      background-color: color-mix(in oklab, var(--color-white) 5%, transparent);
    }
  }

  .bg-white\/70 {
    background-color: #ffffffb3;
  }

  @supports (color: color-mix(in lab, red, red)) {
    .bg-white\/70 {
      background-color: color-mix(in oklab, var(--color-white) 70%, transparent);
    }
  }

  .bg-zinc-500 {
    background-color: var(--color-zinc-500);
  }

  .bg-linear-to-t {
    --tw-gradient-position: to top;
  }

  @supports (background-image: linear-gradient(in lab, red, red)) {
    .bg-linear-to-t {
      --tw-gradient-position: to top in oklab;
    }
  }

  .bg-linear-to-t {
    background-image: linear-gradient(var(--tw-gradient-stops));
  }

  .bg-gradient-to-t {
    --tw-gradient-position: to top in oklab;
    background-image: linear-gradient(var(--tw-gradient-stops));
  }

  .from-black {
    --tw-gradient-from: var(--color-black);
    --tw-gradient-stops: var(--tw-gradient-via-stops, var(--tw-gradient-position), var(--tw-gradient-from) var(--tw-gradient-from-position), var(--tw-gradient-to) var(--tw-gradient-to-position));
  }

  .from-black\/70 {
    --tw-gradient-from: #000000b3;
  }

  @supports (color: color-mix(in lab, red, red)) {
    .from-black\/70 {
      --tw-gradient-from: color-mix(in oklab, var(--color-black) 70%, transparent);
    }
  }

  .from-black\/70 {
    --tw-gradient-stops: var(--tw-gradient-via-stops, var(--tw-gradient-position), var(--tw-gradient-from) var(--tw-gradient-from-position), var(--tw-gradient-to) var(--tw-gradient-to-position));
  }

  .via-black {
    --tw-gradient-via: var(--color-black);
    --tw-gradient-via-stops: var(--tw-gradient-position), var(--tw-gradient-from) var(--tw-gradient-from-position), var(--tw-gradient-via) var(--tw-gradient-via-position), var(--tw-gradient-to) var(--tw-gradient-to-position);
    --tw-gradient-stops: var(--tw-gradient-via-stops);
  }

  .to-transparent {
    --tw-gradient-to: transparent;
    --tw-gradient-stops: var(--tw-gradient-via-stops, var(--tw-gradient-position), var(--tw-gradient-from) var(--tw-gradient-from-position), var(--tw-gradient-to) var(--tw-gradient-to-position));
  }

  .fill-amber-300 {
    fill: var(--color-amber-300);
  }

  .fill-bg {
    fill: var(--color-bg);
  }

  .fill-fg {
    fill: var(--color-fg);
  }

  .object-contain {
    object-fit: contain;
  }

  .object-cover {
    object-fit: cover;
  }

  .object-center {
    object-position: center;
  }

  .p-0 {
    padding: calc(var(--spacing) * 0);
  }

  .p-1 {
    padding: calc(var(--spacing) * 1);
  }

  .p-2 {
    padding: calc(var(--spacing) * 2);
  }

  .p-2\.5 {
    padding: calc(var(--spacing) * 2.5);
  }

  .p-3 {
    padding: calc(var(--spacing) * 3);
  }

  .p-4 {
    padding: calc(var(--spacing) * 4);
  }

  .p-5 {
    padding: calc(var(--spacing) * 5);
  }

  .p-6 {
    padding: calc(var(--spacing) * 6);
  }

  .p-8 {
    padding: calc(var(--spacing) * 8);
  }

  .px-0 {
    padding-inline: calc(var(--spacing) * 0);
  }

  .px-1 {
    padding-inline: calc(var(--spacing) * 1);
  }

  .px-2 {
    padding-inline: calc(var(--spacing) * 2);
  }

  .px-2\.5 {
    padding-inline: calc(var(--spacing) * 2.5);
  }

  .px-3 {
    padding-inline: calc(var(--spacing) * 3);
  }

  .px-4 {
    padding-inline: calc(var(--spacing) * 4);
  }

  .px-5 {
    padding-inline: calc(var(--spacing) * 5);
  }

  .px-6 {
    padding-inline: calc(var(--spacing) * 6);
  }

  .px-8 {
    padding-inline: calc(var(--spacing) * 8);
  }

  .px-16 {
    padding-inline: calc(var(--spacing) * 16);
  }

  .px-416 {
    padding-inline: calc(var(--spacing) * 416);
  }

  .py-0 {
    padding-block: calc(var(--spacing) * 0);
  }

  .py-0\.5 {
    padding-block: calc(var(--spacing) * .5);
  }

  .py-1 {
    padding-block: calc(var(--spacing) * 1);
  }

  .py-2 {
    padding-block: calc(var(--spacing) * 2);
  }

  .py-2\.5 {
    padding-block: calc(var(--spacing) * 2.5);
  }

  .py-3 {
    padding-block: calc(var(--spacing) * 3);
  }

  .py-4 {
    padding-block: calc(var(--spacing) * 4);
  }

  .py-5 {
    padding-block: calc(var(--spacing) * 5);
  }

  .py-8 {
    padding-block: calc(var(--spacing) * 8);
  }

  .py-12 {
    padding-block: calc(var(--spacing) * 12);
  }

  .py-16 {
    padding-block: calc(var(--spacing) * 16);
  }

  .py-\[5px\] {
    padding-block: 5px;
  }

  .pt-0 {
    padding-top: calc(var(--spacing) * 0);
  }

  .pt-1 {
    padding-top: calc(var(--spacing) * 1);
  }

  .pt-2 {
    padding-top: calc(var(--spacing) * 2);
  }

  .pt-3 {
    padding-top: calc(var(--spacing) * 3);
  }

  .pt-4 {
    padding-top: calc(var(--spacing) * 4);
  }

  .pr-0 {
    padding-right: calc(var(--spacing) * 0);
  }

  .pr-4 {
    padding-right: calc(var(--spacing) * 4);
  }

  .pr-6 {
    padding-right: calc(var(--spacing) * 6);
  }

  .pr-8 {
    padding-right: calc(var(--spacing) * 8);
  }

  .pr-16 {
    padding-right: calc(var(--spacing) * 16);
  }

  .pb-0 {
    padding-bottom: calc(var(--spacing) * 0);
  }

  .pb-1 {
    padding-bottom: calc(var(--spacing) * 1);
  }

  .pb-2 {
    padding-bottom: calc(var(--spacing) * 2);
  }

  .pb-3 {
    padding-bottom: calc(var(--spacing) * 3);
  }

  .pb-4 {
    padding-bottom: calc(var(--spacing) * 4);
  }

  .pb-6 {
    padding-bottom: calc(var(--spacing) * 6);
  }

  .pb-8 {
    padding-bottom: calc(var(--spacing) * 8);
  }

  .pb-10 {
    padding-bottom: calc(var(--spacing) * 10);
  }

  .pb-12 {
    padding-bottom: calc(var(--spacing) * 12);
  }

  .pb-22 {
    padding-bottom: calc(var(--spacing) * 22);
  }

  .pl-0 {
    padding-left: calc(var(--spacing) * 0);
  }

  .pl-2 {
    padding-left: calc(var(--spacing) * 2);
  }

  .pl-4 {
    padding-left: calc(var(--spacing) * 4);
  }

  .pl-16 {
    padding-left: calc(var(--spacing) * 16);
  }

  .pl-32 {
    padding-left: calc(var(--spacing) * 32);
  }

  .text-center {
    text-align: center;
  }

  .text-left {
    text-align: left;
  }

  .text-right {
    text-align: right;
  }

  .align-baseline {
    vertical-align: baseline;
  }

  .align-bottom {
    vertical-align: bottom;
  }

  .align-middle {
    vertical-align: middle;
  }

  .align-sub {
    vertical-align: sub;
  }

  .align-text-bottom {
    vertical-align: text-bottom;
  }

  .align-text-top {
    vertical-align: text-top;
  }

  .align-top {
    vertical-align: top;
  }

  .font-heading {
    font-family: var(--font-heading);
  }

  .font-sans {
    font-family: var(--font-sans);
  }

  .text-2xl {
    font-size: var(--text-2xl);
    line-height: var(--tw-leading, var(--text-2xl--line-height));
  }

  .text-3xl {
    font-size: var(--text-3xl);
    line-height: var(--tw-leading, var(--text-3xl--line-height));
  }

  .text-4xl {
    font-size: var(--text-4xl);
    line-height: var(--tw-leading, var(--text-4xl--line-height));
  }

  .text-5xl {
    font-size: var(--text-5xl);
    line-height: var(--tw-leading, var(--text-5xl--line-height));
  }

  .text-base {
    font-size: var(--text-base);
    line-height: var(--tw-leading, var(--text-base--line-height));
  }

  .text-lg {
    font-size: var(--text-lg);
    line-height: var(--tw-leading, var(--text-lg--line-height));
  }

  .text-sm {
    font-size: var(--text-sm);
    line-height: var(--tw-leading, var(--text-sm--line-height));
  }

  .text-xl {
    font-size: var(--text-xl);
    line-height: var(--tw-leading, var(--text-xl--line-height));
  }

  .text-xs {
    font-size: var(--text-xs);
    line-height: var(--tw-leading, var(--text-xs--line-height));
  }

  .text-\[0\.625rem\] {
    font-size: .625rem;
  }

  .text-\[10px\] {
    font-size: 10px;
  }

  .text-\[13px\] {
    font-size: 13px;
  }

  .text-\[32px\] {
    font-size: 32px;
  }

  .leading-3 {
    --tw-leading: calc(var(--spacing) * 3);
    line-height: calc(var(--spacing) * 3);
  }

  .leading-4 {
    --tw-leading: calc(var(--spacing) * 4);
    line-height: calc(var(--spacing) * 4);
  }

  .leading-\[80\%\] {
    --tw-leading: 80%;
    line-height: 80%;
  }

  .leading-\[80\%\|100\%\|120\%\] {
    --tw-leading: 80%| 100%| 120%;
    line-height: 80%| 100%| 120%;
  }

  .leading-\[100\%\] {
    --tw-leading: 100%;
    line-height: 100%;
  }

  .leading-\[120\%\] {
    --tw-leading: 120%;
    line-height: 120%;
  }

  .leading-\[150\%\] {
    --tw-leading: 150%;
    line-height: 150%;
  }

  .leading-none {
    --tw-leading: 1;
    line-height: 1;
  }

  .leading-relaxed {
    --tw-leading: var(--leading-relaxed);
    line-height: var(--leading-relaxed);
  }

  .leading-snug {
    --tw-leading: var(--leading-snug);
    line-height: var(--leading-snug);
  }

  .leading-tight {
    --tw-leading: var(--leading-tight);
    line-height: var(--leading-tight);
  }

  .font-bold {
    --tw-font-weight: var(--font-weight-bold);
    font-weight: var(--font-weight-bold);
  }

  .font-extrabold {
    --tw-font-weight: var(--font-weight-extrabold);
    font-weight: var(--font-weight-extrabold);
  }

  .font-medium {
    --tw-font-weight: var(--font-weight-medium);
    font-weight: var(--font-weight-medium);
  }

  .font-normal {
    --tw-font-weight: var(--font-weight-normal);
    font-weight: var(--font-weight-normal);
  }

  .font-semibold {
    --tw-font-weight: var(--font-weight-semibold);
    font-weight: var(--font-weight-semibold);
  }

  .font-semibold\! {
    --tw-font-weight: var(--font-weight-semibold) !important;
    font-weight: var(--font-weight-semibold) !important;
  }

  .tracking-\[0\.08px\] {
    --tw-tracking: .08px;
    letter-spacing: .08px;
  }

  .tracking-wide {
    --tw-tracking: var(--tracking-wide);
    letter-spacing: var(--tracking-wide);
  }

  .tracking-wider {
    --tw-tracking: var(--tracking-wider);
    letter-spacing: var(--tracking-wider);
  }

  .tracking-widest {
    --tw-tracking: var(--tracking-widest);
    letter-spacing: var(--tracking-widest);
  }

  .whitespace-nowrap {
    white-space: nowrap;
  }

  .text-\[10px\|13px\|32px\] {
    color: 10px| 13px| 32px;
  }

  .text-bg {
    color: var(--color-bg);
  }

  .text-danger {
    color: var(--color-danger);
  }

  .text-fg {
    color: var(--color-fg);
  }

  .text-fg-muted {
    color: var(--color-fg-muted);
  }

  .text-green-600 {
    color: var(--color-green-600);
  }

  .text-highlight {
    color: var(--color-highlight);
  }

  .text-neutral-500 {
    color: var(--color-neutral-500);
  }

  .text-red-600 {
    color: var(--color-red-600);
  }

  .text-red-950 {
    color: var(--color-red-950);
  }

  .text-secondary, .text-secondary\/60 {
    color: var(--color-secondary);
  }

  @supports (color: color-mix(in lab, red, red)) {
    .text-secondary\/60 {
      color: color-mix(in oklab, var(--color-secondary) 60%, transparent);
    }
  }

  .text-secondary\/80 {
    color: var(--color-secondary);
  }

  @supports (color: color-mix(in lab, red, red)) {
    .text-secondary\/80 {
      color: color-mix(in oklab, var(--color-secondary) 80%, transparent);
    }
  }

  .text-white {
    color: var(--color-white);
  }

  .lowercase {
    text-transform: lowercase;
  }

  .uppercase {
    text-transform: uppercase;
  }

  .line-through {
    text-decoration-line: line-through;
  }

  .no-underline {
    text-decoration-line: none;
  }

  .underline {
    text-decoration-line: underline;
  }

  .opacity-0 {
    opacity: 0;
  }

  .opacity-25 {
    opacity: .25;
  }

  .opacity-30 {
    opacity: .3;
  }

  .opacity-40 {
    opacity: .4;
  }

  .opacity-50 {
    opacity: .5;
  }

  .opacity-60 {
    opacity: .6;
  }

  .opacity-75 {
    opacity: .75;
  }

  .opacity-80 {
    opacity: .8;
  }

  .opacity-90 {
    opacity: .9;
  }

  .opacity-100 {
    opacity: 1;
  }

  .shadow {
    --tw-shadow: 0 1px 3px 0 var(--tw-shadow-color, #0000001a), 0 1px 2px -1px var(--tw-shadow-color, #0000001a);
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }

  .shadow-lg {
    --tw-shadow: 0 10px 15px -3px var(--tw-shadow-color, #0000001a), 0 4px 6px -4px var(--tw-shadow-color, #0000001a);
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }

  .shadow-md {
    --tw-shadow: 0 4px 6px -1px var(--tw-shadow-color, #0000001a), 0 2px 4px -2px var(--tw-shadow-color, #0000001a);
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }

  .shadow-sm {
    --tw-shadow: 0 1px 2px 0 var(--tw-shadow-color, #0000000d);
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }

  .outline {
    outline-style: var(--tw-outline-style);
    outline-width: 1px;
  }

  .blur {
    --tw-blur: blur(8px);
    filter: var(--tw-blur, ) var(--tw-brightness, ) var(--tw-contrast, ) var(--tw-grayscale, ) var(--tw-hue-rotate, ) var(--tw-invert, ) var(--tw-saturate, ) var(--tw-sepia, ) var(--tw-drop-shadow, );
  }

  .invert {
    --tw-invert: invert(100%);
    filter: var(--tw-blur, ) var(--tw-brightness, ) var(--tw-contrast, ) var(--tw-grayscale, ) var(--tw-hue-rotate, ) var(--tw-invert, ) var(--tw-saturate, ) var(--tw-sepia, ) var(--tw-drop-shadow, );
  }

  .filter {
    filter: var(--tw-blur, ) var(--tw-brightness, ) var(--tw-contrast, ) var(--tw-grayscale, ) var(--tw-hue-rotate, ) var(--tw-invert, ) var(--tw-saturate, ) var(--tw-sepia, ) var(--tw-drop-shadow, );
  }

  .backdrop-blur {
    --tw-backdrop-blur: blur(8px);
    -webkit-backdrop-filter: var(--tw-backdrop-blur, ) var(--tw-backdrop-brightness, ) var(--tw-backdrop-contrast, ) var(--tw-backdrop-grayscale, ) var(--tw-backdrop-hue-rotate, ) var(--tw-backdrop-invert, ) var(--tw-backdrop-opacity, ) var(--tw-backdrop-saturate, ) var(--tw-backdrop-sepia, );
    backdrop-filter: var(--tw-backdrop-blur, ) var(--tw-backdrop-brightness, ) var(--tw-backdrop-contrast, ) var(--tw-backdrop-grayscale, ) var(--tw-backdrop-hue-rotate, ) var(--tw-backdrop-invert, ) var(--tw-backdrop-opacity, ) var(--tw-backdrop-saturate, ) var(--tw-backdrop-sepia, );
  }

  .backdrop-blur-sm {
    --tw-backdrop-blur: blur(var(--blur-sm));
    -webkit-backdrop-filter: var(--tw-backdrop-blur, ) var(--tw-backdrop-brightness, ) var(--tw-backdrop-contrast, ) var(--tw-backdrop-grayscale, ) var(--tw-backdrop-hue-rotate, ) var(--tw-backdrop-invert, ) var(--tw-backdrop-opacity, ) var(--tw-backdrop-saturate, ) var(--tw-backdrop-sepia, );
    backdrop-filter: var(--tw-backdrop-blur, ) var(--tw-backdrop-brightness, ) var(--tw-backdrop-contrast, ) var(--tw-backdrop-grayscale, ) var(--tw-backdrop-hue-rotate, ) var(--tw-backdrop-invert, ) var(--tw-backdrop-opacity, ) var(--tw-backdrop-saturate, ) var(--tw-backdrop-sepia, );
  }

  .backdrop-filter {
    -webkit-backdrop-filter: var(--tw-backdrop-blur, ) var(--tw-backdrop-brightness, ) var(--tw-backdrop-contrast, ) var(--tw-backdrop-grayscale, ) var(--tw-backdrop-hue-rotate, ) var(--tw-backdrop-invert, ) var(--tw-backdrop-opacity, ) var(--tw-backdrop-saturate, ) var(--tw-backdrop-sepia, );
    backdrop-filter: var(--tw-backdrop-blur, ) var(--tw-backdrop-brightness, ) var(--tw-backdrop-contrast, ) var(--tw-backdrop-grayscale, ) var(--tw-backdrop-hue-rotate, ) var(--tw-backdrop-invert, ) var(--tw-backdrop-opacity, ) var(--tw-backdrop-saturate, ) var(--tw-backdrop-sepia, );
  }

  .transition {
    transition-property: color, background-color, border-color, outline-color, text-decoration-color, fill, stroke, --tw-gradient-from, --tw-gradient-via, --tw-gradient-to, opacity, box-shadow, transform, translate, scale, rotate, filter, -webkit-backdrop-filter, backdrop-filter, display, content-visibility, overlay, pointer-events;
    transition-timing-function: var(--tw-ease, var(--default-transition-timing-function));
    transition-duration: var(--tw-duration, var(--default-transition-duration));
  }

  .transition-\[background-color\,backdrop-filter\] {
    transition-property: background-color, -webkit-backdrop-filter, backdrop-filter;
    transition-timing-function: var(--tw-ease, var(--default-transition-timing-function));
    transition-duration: var(--tw-duration, var(--default-transition-duration));
  }

  .transition-all {
    transition-property: all;
    transition-timing-function: var(--tw-ease, var(--default-transition-timing-function));
    transition-duration: var(--tw-duration, var(--default-transition-duration));
  }

  .transition-colors {
    transition-property: color, background-color, border-color, outline-color, text-decoration-color, fill, stroke, --tw-gradient-from, --tw-gradient-via, --tw-gradient-to;
    transition-timing-function: var(--tw-ease, var(--default-transition-timing-function));
    transition-duration: var(--tw-duration, var(--default-transition-duration));
  }

  .transition-opacity {
    transition-property: opacity;
    transition-timing-function: var(--tw-ease, var(--default-transition-timing-function));
    transition-duration: var(--tw-duration, var(--default-transition-duration));
  }

  .transition-transform {
    transition-property: transform, translate, scale, rotate;
    transition-timing-function: var(--tw-ease, var(--default-transition-timing-function));
    transition-duration: var(--tw-duration, var(--default-transition-duration));
  }

  .duration-150 {
    --tw-duration: var(--transition-duration-150);
    transition-duration: var(--transition-duration-150);
  }

  .duration-200 {
    --tw-duration: var(--transition-duration-200);
    transition-duration: var(--transition-duration-200);
  }

  .duration-300 {
    --tw-duration: var(--transition-duration-300);
    transition-duration: var(--transition-duration-300);
  }

  .duration-500 {
    --tw-duration: var(--transition-duration-500);
    transition-duration: var(--transition-duration-500);
  }

  .duration-700 {
    --tw-duration: var(--transition-duration-700);
    transition-duration: var(--transition-duration-700);
  }

  .ease-in {
    --tw-ease: var(--ease-in);
    transition-timing-function: var(--ease-in);
  }

  .ease-in-out {
    --tw-ease: var(--ease-in-out);
    transition-timing-function: var(--ease-in-out);
  }

  .ease-out {
    --tw-ease: var(--ease-out);
    transition-timing-function: var(--ease-out);
  }

  .outline-none {
    --tw-outline-style: none;
    outline-style: none;
  }

  .\[background\:color-mix\(in_srgb\,var\(--background-color\)_70\%\,transparent\)\] {
    background: var(--background-color);
  }

  @supports (color: color-mix(in lab, red, red)) {
    .\[background\:color-mix\(in_srgb\,var\(--background-color\)_70\%\,transparent\)\] {
      background: color-mix(in srgb, var(--background-color) 70%, transparent);
    }
  }

  .\[background\:rgba\(0\,0\,0\,0\.05\)\] {
    background: #0000000d;
  }

  .\[background\:rgba\(0\,0\,0\,0\.12\)\] {
    background: #0000001f;
  }

  .\[background\:rgba\(0\,0\,0\,0\.15\)\] {
    background: #00000026;
  }

  .\[background\:rgba\(255\,255\,246\,0\.7\)\] {
    background: #fffff6b3;
  }

  .\[background\:rgba\(255\,255\,255\,0\.30\)\] {
    background: #ffffff4d;
  }

  @media (hover: hover) {
    .group-hover\:scale-110:is(:where(.group):hover *) {
      --tw-scale-x: 110%;
      --tw-scale-y: 110%;
      --tw-scale-z: 110%;
      scale: var(--tw-scale-x) var(--tw-scale-y);
    }
  }

  .placeholder\:text-bg\/60::placeholder {
    color: var(--color-bg);
  }

  @supports (color: color-mix(in lab, red, red)) {
    .placeholder\:text-bg\/60::placeholder {
      color: color-mix(in oklab, var(--color-bg) 60%, transparent);
    }
  }

  .placeholder\:text-fg-muted::placeholder {
    color: var(--color-fg-muted);
  }

  .empty\:hidden:empty {
    display: none;
  }

  @media (hover: hover) {
    .hover\:bg-black\/5:hover {
      background-color: #0000000d;
    }

    @supports (color: color-mix(in lab, red, red)) {
      .hover\:bg-black\/5:hover {
        background-color: color-mix(in oklab, var(--color-black) 5%, transparent);
      }
    }

    .hover\:bg-black\/10:hover {
      background-color: #0000001a;
    }

    @supports (color: color-mix(in lab, red, red)) {
      .hover\:bg-black\/10:hover {
        background-color: color-mix(in oklab, var(--color-black) 10%, transparent);
      }
    }

    .hover\:bg-black\/20:hover {
      background-color: #0003;
    }

    @supports (color: color-mix(in lab, red, red)) {
      .hover\:bg-black\/20:hover {
        background-color: color-mix(in oklab, var(--color-black) 20%, transparent);
      }
    }

    .hover\:bg-white\/10:hover {
      background-color: #ffffff1a;
    }

    @supports (color: color-mix(in lab, red, red)) {
      .hover\:bg-white\/10:hover {
        background-color: color-mix(in oklab, var(--color-white) 10%, transparent);
      }
    }

    .hover\:bg-white\/40:hover {
      background-color: #fff6;
    }

    @supports (color: color-mix(in lab, red, red)) {
      .hover\:bg-white\/40:hover {
        background-color: color-mix(in oklab, var(--color-white) 40%, transparent);
      }
    }

    .hover\:underline:hover {
      text-decoration-line: underline;
    }

    .hover\:opacity-70:hover {
      opacity: .7;
    }
  }

  .disabled\:cursor-not-allowed:disabled {
    cursor: not-allowed;
  }

  .disabled\:opacity-40:disabled {
    opacity: .4;
  }

  .aria-disabled\:cursor-not-allowed[aria-disabled="true"] {
    cursor: not-allowed;
  }

  .aria-disabled\:opacity-40[aria-disabled="true"] {
    opacity: .4;
  }

  @media not all and (min-width: 48rem) {
    .max-md\:-mr-2\.5 {
      margin-right: calc(var(--spacing) * -2.5);
    }

    :where(.max-md\:-space-x-1\.5 > :not(:last-child)) {
      --tw-space-x-reverse: 0;
      margin-inline-start: calc(calc(var(--spacing) * -1.5) * var(--tw-space-x-reverse));
      margin-inline-end: calc(calc(var(--spacing) * -1.5) * calc(1 - var(--tw-space-x-reverse)));
    }
  }

  @media (min-width: 48rem) {
    .md\:absolute {
      position: absolute;
    }

    .md\:top-\[30\%\] {
      top: 30%;
    }

    .md\:bottom-6 {
      bottom: calc(var(--spacing) * 6);
    }

    .md\:mt-0 {
      margin-top: calc(var(--spacing) * 0);
    }

    .md\:mb-8 {
      margin-bottom: calc(var(--spacing) * 8);
    }

    .md\:block {
      display: block;
    }

    .md\:flex {
      display: flex;
    }

    .md\:hidden {
      display: none;
    }

    .md\:inline {
      display: inline;
    }

    .md\:inline-block {
      display: inline-block;
    }

    .md\:h-22 {
      height: calc(var(--spacing) * 22);
    }

    .md\:h-28 {
      height: calc(var(--spacing) * 28);
    }

    .md\:h-30 {
      height: calc(var(--spacing) * 30);
    }

    .md\:h-170 {
      height: calc(var(--spacing) * 170);
    }

    .md\:min-h-0 {
      min-height: calc(var(--spacing) * 0);
    }

    .md\:min-w-0 {
      min-width: calc(var(--spacing) * 0);
    }

    .md\:grid-cols-3 {
      grid-template-columns: repeat(3, minmax(0, 1fr));
    }

    .md\:flex-row {
      flex-direction: row;
    }

    .md\:gap-4 {
      gap: calc(var(--spacing) * 4);
    }

    .md\:gap-x-16 {
      column-gap: calc(var(--spacing) * 16);
    }

    .md\:px-0 {
      padding-inline: calc(var(--spacing) * 0);
    }

    .md\:px-16 {
      padding-inline: calc(var(--spacing) * 16);
    }

    .md\:py-5 {
      padding-block: calc(var(--spacing) * 5);
    }

    .md\:py-12 {
      padding-block: calc(var(--spacing) * 12);
    }

    .md\:py-24 {
      padding-block: calc(var(--spacing) * 24);
    }

    .md\:pb-0 {
      padding-bottom: calc(var(--spacing) * 0);
    }

    .md\:pb-5 {
      padding-bottom: calc(var(--spacing) * 5);
    }

    .md\:text-center {
      text-align: center;
    }

    .md\:text-5xl {
      font-size: var(--text-5xl);
      line-height: var(--tw-leading, var(--text-5xl--line-height));
    }

    .md\:text-lg {
      font-size: var(--text-lg);
      line-height: var(--tw-leading, var(--text-lg--line-height));
    }

    .md\:text-xl {
      font-size: var(--text-xl);
      line-height: var(--tw-leading, var(--text-xl--line-height));
    }

    .md\:text-\[40px\] {
      font-size: 40px;
    }

    .md\:text-\[48px\] {
      font-size: 48px;
    }
  }

  @media (min-width: 64rem) {
    .lg\:mx-auto {
      margin-inline: auto;
    }

    .lg\:mb-4 {
      margin-bottom: calc(var(--spacing) * 4);
    }

    .lg\:grid {
      display: grid;
    }

    .lg\:hidden {
      display: none;
    }

    .lg\:w-\[564px\] {
      width: 564px;
    }

    .lg\:w-\[876px\] {
      width: 876px;
    }

    .lg\:w-full {
      width: 100%;
    }

    .lg\:max-w-\[1440px\] {
      max-width: 1440px;
    }

    .lg\:grid-cols-2 {
      grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .lg\:grid-cols-4 {
      grid-template-columns: repeat(4, minmax(0, 1fr));
    }

    .lg\:flex-row {
      flex-direction: row;
    }

    .lg\:items-start {
      align-items: flex-start;
    }

    .lg\:gap-0 {
      gap: calc(var(--spacing) * 0);
    }

    .lg\:border-t-0 {
      border-top-style: var(--tw-border-style);
      border-top-width: 0;
    }

    .lg\:px-0 {
      padding-inline: calc(var(--spacing) * 0);
    }

    .lg\:px-4 {
      padding-inline: calc(var(--spacing) * 4);
    }

    .lg\:px-6 {
      padding-inline: calc(var(--spacing) * 6);
    }

    .lg\:px-32 {
      padding-inline: calc(var(--spacing) * 32);
    }

    .lg\:py-0 {
      padding-block: calc(var(--spacing) * 0);
    }

    .lg\:pt-3 {
      padding-top: calc(var(--spacing) * 3);
    }

    .lg\:text-6xl {
      font-size: var(--text-6xl);
      line-height: var(--tw-leading, var(--text-6xl--line-height));
    }
  }

  @media (min-width: 80rem) {
    .xl\:gap-x-32 {
      column-gap: calc(var(--spacing) * 32);
    }
  }

  .\[\&\:\:-webkit-inner-spin-button\]\:appearance-none::-webkit-inner-spin-button {
    appearance: none;
  }

  .\[\&\:\:-webkit-outer-spin-button\]\:appearance-none::-webkit-outer-spin-button {
    appearance: none;
  }
}

.js-new-header[data-state="transparent"] {
  background-color: #0000;
}

.js-new-header[data-state="transparent"] .nav-link, .js-new-header[data-state="transparent"] .advertising-bar, .js-new-header[data-state="transparent"] .advertising-bar a, .js-new-header[data-state="transparent"] .advertising-bar span {
  color: var(--background-color);
}

.js-new-header[data-state="transparent"] .logo-text {
  color: var(--background-color) !important;
}

.js-new-header[data-state="transparent"] .logo-text svg path {
  fill: var(--background-color);
}

.js-new-header[data-state="active"] {
  background-color: var(--background-color);
}

@supports (color: color-mix(in lab, red, red)) {
  .js-new-header[data-state="active"] {
    background-color: color-mix(in srgb, var(--background-color) 70%, transparent);
  }
}

.js-new-header[data-state="active"] {
  -webkit-backdrop-filter: blur(.5rem);
  backdrop-filter: blur(.5rem);
}

.js-new-header[data-state="active"] .nav-link, .js-new-header[data-state="active"] .advertising-bar, .js-new-header[data-state="active"] .advertising-bar a, .js-new-header[data-state="active"] .advertising-bar span {
  color: var(--primary-color);
}

.js-new-header[data-state="active"] .logo-text {
  color: var(--primary-color) !important;
}

.js-search-overlay[data-state="open"] {
  pointer-events: auto;
}

.js-search-overlay[data-state="closed"] {
  pointer-events: none;
}

.js-search-panel {
  transition: transform .3s cubic-bezier(.4, 0, .2, 1);
}

.js-search-input {
  font-size: 16px !important;
}

@media (min-width: 768px) {
  .js-search-input {
    font-size: 16px !important;
  }
}

.js-search-input::-webkit-search-cancel-button {
  -webkit-appearance: none;
  display: none;
}

.search-result-name :is(strong, b, mark) {
  color: inherit;
  background: none;
  font-weight: 700;
}

.js-toast-container [data-state] {
  pointer-events: auto;
  transition: opacity .3s, transform .3s;
}

.js-toast-container [data-state="entering"] {
  opacity: 0;
  transform: translateX(100%);
}

.js-toast-container [data-state="visible"] {
  opacity: 1;
  transform: translateX(0);
}

.js-toast-container [data-state="exiting"] {
  opacity: 0;
  transform: translateX(100%);
}

.js-gaius-modal-container[data-state="closed"] {
  opacity: 0;
  pointer-events: none;
  visibility: hidden;
}

.js-gaius-modal-container[data-state="open"] {
  opacity: 1;
  pointer-events: auto;
  visibility: visible;
}

.js-gaius-modal-overlay {
  -webkit-backdrop-filter: blur(4px);
  background: #0000004d;
  transition: opacity .3s;
  position: absolute;
  inset: 0;
}

.js-gaius-modal-content {
  background: var(--background-color);
  color: var(--primary-color);
  box-shadow: var(--shadow-xl);
  border-radius: 12px;
  width: calc(100% - 32px);
  max-width: 480px;
  max-height: calc(100vh - 64px);
  transition: opacity .3s, transform .3s;
  position: relative;
  overflow-y: auto;
}

.js-gaius-modal-container[data-state="closed"] .js-gaius-modal-content {
  opacity: 0;
  transform: scale(.95);
}

.js-gaius-modal-container[data-state="open"] .js-gaius-modal-content {
  opacity: 1;
  transform: scale(1);
}

.js-gaius-modal-container[data-state="closed"] .js-gaius-modal-drawer {
  opacity: 0;
  transform: translateX(100%);
}

.js-gaius-modal-container[data-state="open"] .js-gaius-modal-drawer {
  opacity: 1;
  transform: translateX(0);
}

.js-gaius-modal-drawer {
  border-radius: 0;
  width: 100%;
  max-width: 100%;
  height: 100%;
  max-height: 100vh;
  transition: opacity .3s, transform .3s;
  position: fixed;
  top: 0;
  bottom: 0;
  right: 0;
}

.js-gaius-modal-drawer .js-gaius-modal-body {
  height: calc(100% - 57px);
}

@media (min-width: 768px) {
  .js-gaius-modal-drawer {
    max-width: 420px;
  }
}

.js-price-filter-wrapper .filter-input-price-container {
  flex-direction: column;
  width: auto;
  margin-bottom: 8px;
  margin-right: 0;
  display: flex;
}

.js-price-filter-wrapper .filter-input-price-container label {
  font-family: var(--font-body);
  color: var(--text-color);
  margin-bottom: 4px;
  font-size: .75rem;
  font-weight: 500;
}

.js-price-filter-wrapper .filter-input-price {
  width: 80px;
  font-family: var(--font-body);
  color: var(--text-color);
  background: #0000000d;
  border: none;
  border-radius: 8px;
  outline: none;
  padding: 4px 10px;
  font-size: .75rem;
  font-weight: 500;
}

.js-price-filter-wrapper .filter-input-price:focus {
  background: #0000001a;
}

.js-price-filter-wrapper .js-price-filter-btn {
  color: var(--text-color);
  font-family: var(--font-body);
  cursor: pointer;
  background: #0000000d;
  border: none;
  border-radius: 8px;
  align-items: center;
  gap: 4px;
  padding: 4px 10px;
  font-size: .75rem;
  font-weight: 500;
  transition: background .15s;
  display: inline-flex;
}

.js-price-filter-wrapper .js-price-filter-btn:hover {
  background: #0000001a;
}

.js-gaius-modal-body .filters-container, .js-gaius-modal-body [data-store="filters-group"] {
  position: relative;
}

.powered-by-wrapper svg {
  height: calc(var(--spacing) * 4.5);
  width: auto;
  fill: var(--primary-color);
}

.powered-by-wrapper svg path {
  fill: var(--primary-color);
}

.footer-logo-svg svg {
  max-height: inherit;
  width: auto;
  height: auto;
}

.footer-logo-svg svg path {
  fill: var(--primary-color);
}

.promo-marquee-section {
  width: 100%;
}

.promo-marquee-section[data-bg="primary"] {
  background-color: var(--primary-color);
}

.promo-marquee-section[data-bg="secondary"] {
  background-color: var(--text-color);
}

.promo-marquee-section[data-bg="background"] {
  background-color: var(--background-color);
}

.promo-marquee-section[data-bg="accent"] {
  background-color: var(--accent-color);
}

.promo-marquee-section[data-text="white"] {
  color: #fff;
}

.promo-marquee-section[data-text="primary"] {
  color: var(--primary-color);
}

.promo-marquee-section[data-text="secondary"] {
  color: var(--text-color);
}

.promo-marquee-section[data-text="background"] {
  color: var(--background-color);
}

.promo-marquee-track {
  will-change: transform;
  animation: 30s linear infinite marquee-scroll;
}

@keyframes marquee-scroll {
  0% {
    transform: translateX(0);
  }

  100% {
    transform: translateX(-25%);
  }
}

@media (prefers-reduced-motion: reduce) {
  .promo-marquee-track {
    animation: none;
  }
}

.js-menu-accordion-toggle[aria-expanded="true"] .js-icon-closed {
  display: none;
}

.js-menu-accordion-toggle[aria-expanded="true"] .js-icon-open {
  display: block;
}

.js-menu-carousel {
  position: relative;
  overflow: hidden;
}

.js-cart-drawer[data-state="closed"] {
  pointer-events: none;
}

.js-cart-drawer[data-state="open"] {
  pointer-events: auto;
}

.js-cart-drawer[data-state="open"] .js-cart-drawer-backdrop {
  -webkit-backdrop-filter: blur(4px);
}

.js-cart-drawer-backdrop {
  -webkit-backdrop-filter: blur();
  transition: -webkit-backdrop-filter .3s, backdrop-filter .3s;
}

.js-cart-drawer-panel {
  box-shadow: var(--shadow-xl);
  -webkit-backdrop-filter: blur(.5rem);
  backdrop-filter: blur(.5rem);
  overscroll-behavior: contain;
  transition: transform .3s cubic-bezier(.4, 0, .2, 1);
  transform: translateX(100%);
}

.js-ajax-cart-list {
  overscroll-behavior: contain;
  -webkit-overflow-scrolling: touch;
}

.js-cart-drawer[data-state="open"] .js-cart-drawer-panel {
  transform: translateX(0);
}

@media (min-width: 768px) {
  .js-cart-drawer-panel {
    background-color: var(--background-color);
  }

  @supports (color: color-mix(in lab, red, red)) {
    .js-cart-drawer-panel {
      background-color: color-mix(in srgb, var(--background-color) 70%, transparent);
    }
  }

  .js-cart-drawer-panel {
    -webkit-backdrop-filter: blur(.5rem);
    backdrop-filter: blur(.5rem);
  }
}

.js-cart-input-spinner {
  width: 0;
  position: absolute;
  overflow: hidden;
}

.js-cart-drawer-footer {
  -webkit-backdrop-filter: blur(.5rem);
}

@media (max-width: 767px) {
  .js-cart-drawer-panel {
    max-width: 100% !important;
  }
}

@keyframes progress-complete {
  0%, 100% {
    opacity: 1;
  }

  50% {
    opacity: .7;
  }
}

.js-cart-progress-complete {
  animation: 1.5s ease-in-out progress-complete;
}

.js-product-gallery-zoom[data-state="closed"] {
  opacity: 0;
  pointer-events: none;
  visibility: hidden;
}

.js-product-gallery-zoom[data-state="open"] {
  opacity: 1;
  pointer-events: auto;
  visibility: visible;
}

.js-product-gallery-zoom-backdrop {
  -webkit-backdrop-filter: blur(12px);
  background: #000000d9;
}

.js-product-gallery-zoom-content {
  transition: opacity .3s, transform .3s;
}

.js-product-gallery-zoom[data-state="closed"] .js-product-gallery-zoom-content {
  opacity: 0;
  transform: scale(.95);
}

.js-product-gallery-zoom[data-state="open"] .js-product-gallery-zoom-content {
  opacity: 1;
  transform: scale(1);
}

.js-product-gallery-zoom-swiper .swiper-slide {
  height: 100%;
}

.js-product-sticky-buy-bar {
  width: 100%;
  z-index: var(--z-40);
  background-color: var(--background-color);
  position: fixed;
  bottom: 0;
  left: 0;
}

@supports (color: color-mix(in lab, red, red)) {
  .js-product-sticky-buy-bar {
    background-color: color-mix(in srgb, var(--background-color) 85%, transparent);
  }
}

.js-product-sticky-buy-bar {
  -webkit-backdrop-filter: blur(.5rem);
}

@media (max-width: 1023px) {
  .js-product-sticky-buy-bar .js-cart-progress-bar {
    flex-direction: column-reverse;
    gap: .5rem;
  }

  .js-product-sticky-buy-bar .js-cart-progress-bar svg {
    display: none;
  }

  .js-product-sticky-buy-bar .js-cart-progress-label {
    color: var(--color-highlight);
  }

  .js-product-sticky-buy-bar .js-cart-progress-bar > div:first-child {
    justify-content: center;
  }

  body.template-product .js-footer {
    padding-bottom: 11rem;
  }
}

@media (min-width: 1024px) {
  .js-product-sticky-buy-bar {
    z-index: auto;
    -webkit-backdrop-filter: none;
    background-color: #0000;
    position: static;
  }
}

.js-product-variant-swatch[data-selected="true"] {
  outline: 2px solid var(--text-color);
  outline-offset: 2px;
}

@property --tw-translate-x {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}

@property --tw-translate-y {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}

@property --tw-translate-z {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}

@property --tw-rotate-x {
  syntax: "*";
  inherits: false
}

@property --tw-rotate-y {
  syntax: "*";
  inherits: false
}

@property --tw-rotate-z {
  syntax: "*";
  inherits: false
}

@property --tw-skew-x {
  syntax: "*";
  inherits: false
}

@property --tw-skew-y {
  syntax: "*";
  inherits: false
}

@property --tw-scroll-snap-strictness {
  syntax: "*";
  inherits: false;
  initial-value: proximity;
}

@property --tw-border-style {
  syntax: "*";
  inherits: false;
  initial-value: solid;
}

@property --tw-gradient-position {
  syntax: "*";
  inherits: false
}

@property --tw-gradient-from {
  syntax: "<color>";
  inherits: false;
  initial-value: #0000;
}

@property --tw-gradient-via {
  syntax: "<color>";
  inherits: false;
  initial-value: #0000;
}

@property --tw-gradient-to {
  syntax: "<color>";
  inherits: false;
  initial-value: #0000;
}

@property --tw-gradient-stops {
  syntax: "*";
  inherits: false
}

@property --tw-gradient-via-stops {
  syntax: "*";
  inherits: false
}

@property --tw-gradient-from-position {
  syntax: "<length-percentage>";
  inherits: false;
  initial-value: 0%;
}

@property --tw-gradient-via-position {
  syntax: "<length-percentage>";
  inherits: false;
  initial-value: 50%;
}

@property --tw-gradient-to-position {
  syntax: "<length-percentage>";
  inherits: false;
  initial-value: 100%;
}

@property --tw-leading {
  syntax: "*";
  inherits: false
}

@property --tw-font-weight {
  syntax: "*";
  inherits: false
}

@property --tw-tracking {
  syntax: "*";
  inherits: false
}

@property --tw-shadow {
  syntax: "*";
  inherits: false;
  initial-value: 0 0 #0000;
}

@property --tw-shadow-color {
  syntax: "*";
  inherits: false
}

@property --tw-shadow-alpha {
  syntax: "<percentage>";
  inherits: false;
  initial-value: 100%;
}

@property --tw-inset-shadow {
  syntax: "*";
  inherits: false;
  initial-value: 0 0 #0000;
}

@property --tw-inset-shadow-color {
  syntax: "*";
  inherits: false
}

@property --tw-inset-shadow-alpha {
  syntax: "<percentage>";
  inherits: false;
  initial-value: 100%;
}

@property --tw-ring-color {
  syntax: "*";
  inherits: false
}

@property --tw-ring-shadow {
  syntax: "*";
  inherits: false;
  initial-value: 0 0 #0000;
}

@property --tw-inset-ring-color {
  syntax: "*";
  inherits: false
}

@property --tw-inset-ring-shadow {
  syntax: "*";
  inherits: false;
  initial-value: 0 0 #0000;
}

@property --tw-ring-inset {
  syntax: "*";
  inherits: false
}

@property --tw-ring-offset-width {
  syntax: "<length>";
  inherits: false;
  initial-value: 0;
}

@property --tw-ring-offset-color {
  syntax: "*";
  inherits: false;
  initial-value: #fff;
}

@property --tw-ring-offset-shadow {
  syntax: "*";
  inherits: false;
  initial-value: 0 0 #0000;
}

@property --tw-outline-style {
  syntax: "*";
  inherits: false;
  initial-value: solid;
}

@property --tw-blur {
  syntax: "*";
  inherits: false
}

@property --tw-brightness {
  syntax: "*";
  inherits: false
}

@property --tw-contrast {
  syntax: "*";
  inherits: false
}

@property --tw-grayscale {
  syntax: "*";
  inherits: false
}

@property --tw-hue-rotate {
  syntax: "*";
  inherits: false
}

@property --tw-invert {
  syntax: "*";
  inherits: false
}

@property --tw-opacity {
  syntax: "*";
  inherits: false
}

@property --tw-saturate {
  syntax: "*";
  inherits: false
}

@property --tw-sepia {
  syntax: "*";
  inherits: false
}

@property --tw-drop-shadow {
  syntax: "*";
  inherits: false
}

@property --tw-drop-shadow-color {
  syntax: "*";
  inherits: false
}

@property --tw-drop-shadow-alpha {
  syntax: "<percentage>";
  inherits: false;
  initial-value: 100%;
}

@property --tw-drop-shadow-size {
  syntax: "*";
  inherits: false
}

@property --tw-backdrop-blur {
  syntax: "*";
  inherits: false
}

@property --tw-backdrop-brightness {
  syntax: "*";
  inherits: false
}

@property --tw-backdrop-contrast {
  syntax: "*";
  inherits: false
}

@property --tw-backdrop-grayscale {
  syntax: "*";
  inherits: false
}

@property --tw-backdrop-hue-rotate {
  syntax: "*";
  inherits: false
}

@property --tw-backdrop-invert {
  syntax: "*";
  inherits: false
}

@property --tw-backdrop-opacity {
  syntax: "*";
  inherits: false
}

@property --tw-backdrop-saturate {
  syntax: "*";
  inherits: false
}

@property --tw-backdrop-sepia {
  syntax: "*";
  inherits: false
}

@property --tw-duration {
  syntax: "*";
  inherits: false
}

@property --tw-ease {
  syntax: "*";
  inherits: false
}

@property --tw-scale-x {
  syntax: "*";
  inherits: false;
  initial-value: 1;
}

@property --tw-scale-y {
  syntax: "*";
  inherits: false;
  initial-value: 1;
}

@property --tw-scale-z {
  syntax: "*";
  inherits: false;
  initial-value: 1;
}

@property --tw-space-x-reverse {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
