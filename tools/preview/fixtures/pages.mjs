import { settings } from "./settings.mjs";
import { products, sections, menus, category, product_filters, sort_methods } from "./catalog.mjs";

export const store = {
  name: "Camisetas Roma",
  url: "/",
  cart_url: "/cart",
  products_url: "/produtos/",
  search_url: "/search/",
  customer_login_url: "/account/login/",
  shipping_calculator_url: "/shipping/calculate",
  country: "BR",
  branches: [],
  whatsapp: "",
  phone: "",
  email: "contato@example.test",
  instagram: "camisetasroma",
  is_catalog: false,
  has_shipping: true,
  business_name: "Camisetas Roma LTDA",
  business_id: "00.000.000/0001-00",
  afip: null,
  js: "",
  hasInstagramToken: () => false,
  hasContactFormsRecaptcha: () => false,
  customer_order_url: (order) => `/account/orders/${order?.id ?? ""}`,
  customer_address_url: () => "/account/addresses/",
};

const cartItems = [
  { id: 9001, product: products[0], short_name: products[0].name, short_variant_name: "Preto / M", url: products[0].url,
    featured_image: products[0].featured_image, quantity: 2, subtotal: products[0].price * 2, remove: "/cart/remove/9001" },
  { id: 9002, product: products[2], short_name: products[2].name, short_variant_name: "Off-white / G", url: products[2].url,
    featured_image: products[2].featured_image, quantity: 1, subtotal: products[2].price, remove: "/cart/remove/9002" },
];

export const cart = {
  items: cartItems,
  items_count: cartItems.reduce((n, i) => n + i.quantity, 0),
  subtotal: cartItems.reduce((n, i) => n + i.subtotal, 0),
  total: cartItems.reduce((n, i) => n + i.subtotal, 0),
  line: "",
  promotional_discount_amount: 0,
  promotional_discount: { promotions_applied: [] },
  shipping_data: null,
  free_shipping: {
    cart_has_free_shipping: false,
    min_price_free_shipping: { min_price_raw: 299, min_price: "R$ 299,00" },
  },
};

const base = {
  settings,
  store,
  cart,
  menus,
  languages: [],
  customer: null,
  params: { preview: false },
  template: "home",
  page_title: "Camisetas Roma",
  page_description: "Preview local",
  store_resource_hints: "",
  back_to_admin: "",
  load_jquery: false,
  is_theme_draft: false,
  fb_js: "",
  pin_js: "",
  // `{% set columns %}` the platform computes for product grids; store.js.tpl
  // interpolates it into JS (`productsAmount > {{ columns }}`) and an empty
  // value is a syntax error that kills the whole vendored script block
  columns: 2,
  __platform_head: "", // filled by build.mjs
};

export const pages = {
  home: {
    ...base,
    template: "home",
    sections,
    has_products: true,
  },
  product: {
    ...base,
    template: "product",
    product: products[0],
    related_products: products.slice(1, 5),
    breadcrumbs: [
      { name: "Camisetas", url: "/camisetas/", last: false },
      { name: products[0].name, url: products[0].url, last: true },
    ],
  },
  category: {
    ...base,
    template: "category",
    category,
    products,
    has_products: true,
    has_filters_enabled: true,
    product_filters,
    filter_categories: menus.navigation[0].subitems,
    sort_methods,
    sort_by: "user",
    breadcrumbs: [{ name: "Camisetas", url: "/camisetas/", last: true }],
    pagination: { current_page: 1, total_pages: 1, next_page: null, is_last: true },
    applied_filters: false,
    has_applied_filters: false,
  },
};
