import { placeholderUrl } from "../engine.mjs";

// Product factory. Shapes follow what the templates and the custom JS read:
// `product.variants_object` is the JSON `product-variants.js` /
// `item-card-quickbuy.js` parse (see docs/architecture-map.md D1).

const SIZES = ["P", "M", "G", "GG"];
const COLORS = [
  { name: "Preto", hex: "#111111" },
  { name: "Off-white", hex: "#F3EFE6" },
];

export function makeProduct(id, overrides = {}) {
  const price = overrides.price ?? 129.9;
  const compareAt = overrides.compare_at_price ?? null;
  const images = Array.from({ length: overrides.images_count ?? 4 }, (_, i) => ({
    id: id * 100 + i,
    src: placeholderUrl("large", `${overrides.name || "Produto"} ${i + 1}`),
    alt: `${overrides.name || "Produto"} foto ${i + 1}`,
    dimensions: { width: 480, height: 600 },
  }));

  const variations = [
    { id: id * 10 + 1, name: "Cor", options: COLORS.map((c, i) => ({ id: id * 1000 + i, name: c.name, custom_data: c.hex })) },
    { id: id * 10 + 2, name: "Tamanho", options: SIZES.map((s, i) => ({ id: id * 1000 + 10 + i, name: s })) },
  ];

  const variants_object = [];
  let v = 0;
  for (const color of variations[0].options) {
    for (const size of variations[1].options) {
      v += 1;
      const stock = overrides.stock ?? (v % 5 === 0 ? 0 : 12);
      variants_object.push({
        id: id * 10000 + v,
        price,
        price_short: price.toFixed(2).replace(".", ","),
        price_number: price,
        compare_at_price: compareAt,
        compare_at_price_short: compareAt ? compareAt.toFixed(2).replace(".", ",") : null,
        available: stock > 0,
        stock,
        stock_unlimited: false,
        image: 1 + ((v - 1) % images.length),
        option0: color.name,
        option1: size.name,
        option2: null,
        options: [color.id, size.id],
        values: [color.name, size.name],
      });
    }
  }

  return {
    id,
    name: overrides.name || `Camiseta ${id}`,
    url: `/produtos/camiseta-${id}/`,
    price,
    display_price: true,
    compare_at_price: compareAt,
    available: true,
    has_stock: true,
    quantity: 1,
    is_non_shippable: false,
    free_shipping: false,
    description: "<p>Camiseta 100% algodão, modelagem regular.</p>",
    featured_image: images[0],
    images,
    images_count: images.length,
    video_url: null,
    labels: overrides.labels || [],
    variations,
    variants_object,
    default_options: { [variations[0].id]: variations[0].options[0].id, [variations[1].id]: variations[1].options[1].id },
    selected_or_first_available_variant: variants_object[0],
    show_installments: true,
    showMaxPaymentDiscount: true,
    maxPaymentDiscount: { value: 10 },
    installments_info_from_any_variant: true,
    // `product.get_max_installments(false)` on the platform — shimmed to a
    // value by the engine pre-pass (see engine.mjs)
    max_installments: { installment: 6, installment_value: price / 6 },
    social_url: `https://example.test/produtos/camiseta-${id}/`,
    metafields: {},
    ...overrides,
  };
}

export const products = [
  makeProduct(1, { name: "Camiseta Roma Básica", compare_at_price: 159.9, labels: ["Novo"] }),
  makeProduct(2, { name: "Camiseta Oversized Preta", price: 149.9 }),
  makeProduct(3, { name: "Camiseta Estampada Verão", price: 139.9, labels: ["Mais vendida"] }),
  makeProduct(4, { name: "Camiseta Manga Longa", price: 169.9, compare_at_price: 199.9 }),
  makeProduct(5, { name: "Regata Roma", price: 99.9 }),
  makeProduct(6, { name: "Camiseta Polo", price: 189.9 }),
];

export const sections = {
  primary: { products: products.slice(0, 4) },
  carousel_tab_1: { products },
  carousel_tab_2: { products: [...products].reverse() },
  carousel_tab_3: { products: products.slice(2) },
};

export const menus = {
  navigation: [
    { name: "Camisetas", url: "/camisetas/", subitems: [
      { name: "Básicas", url: "/camisetas/basicas/", subitems: [] },
      { name: "Oversized", url: "/camisetas/oversized/", subitems: [] },
      { name: "Estampadas", url: "/camisetas/estampadas/", subitems: [] },
    ] },
    { name: "Regatas", url: "/regatas/", subitems: [] },
    { name: "Promoções", url: "/promocoes/", subitems: [] },
    { name: "Sobre", url: "/sobre/", subitems: [] },
  ],
};

export const category = {
  name: "Camisetas",
  url: "/camisetas/",
  images: [],
  sort_method: "user",
};

export const product_filters = [
  { key: "Tamanho", name: "Tamanho", type: "size", has_products: true, values_with_products: 4,
    values: SIZES.map((s) => ({ name: s, pill_label: s, product_count: 3, selected: false })) },
  { key: "Cor", name: "Cor", type: "color", has_products: true, values_with_products: 2,
    values: COLORS.map((c) => ({ name: c.name, pill_label: c.name, product_count: 3, selected: false, color_type: "insta_color", color_hexa: c.hex })) },
];

export const sort_methods = [
  { value: "user", text: "Destacado" },
  { value: "price-ascending", text: "Precio: Menor a Mayor" },
  { value: "price-descending", text: "Precio: Mayor a Menor" },
  { value: "alpha-ascending", text: "A - Z" },
];
