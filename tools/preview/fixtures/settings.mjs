import fs from "node:fs";
import path from "node:path";
import { ROOT } from "../engine.mjs";

/** Parse config/defaults.txt (`key = value` per line) into an object. */
function loadDefaults() {
  const out = {};
  const file = path.join(ROOT, "config/defaults.txt");
  for (const line of fs.readFileSync(file, "utf8").split(/\r?\n/)) {
    const m = line.match(/^([a-zA-Z0-9_]+)\s*=\s*(.*)$/);
    if (!m) continue;
    const [, key, raw] = m;
    const v = raw.trim();
    out[key] = v === "1" ? true : v === "0" ? false : v;
  }
  return out;
}

// Roma's real palette (the admin values this theme ships with) and the
// sections the custom layer renders. Anything not listed falls back to the
// platform defaults above.
export const settings = {
  ...loadDefaults(),

  // `palette_custom` preset in config/settings.txt — the palette the store runs
  primary_color: "#CB2C30",
  text_color: "#410911",
  text_muted_color: "#80807B",
  background_color: "#FFFFF6",
  accent_color: "#2DCC57",
  font_headings: '"Larken", serif',
  font_rest: '"Mulish", sans-serif',

  head_transparent: true,
  head_fix: true,
  menu_principal: "navigation",
  footer_menu: "navigation",
  menu_highlighted_items: "Promoções",
  grid_columns: 2,

  // homepage router — only the sections the custom layer owns
  home_order_position_0: "hero_banner_2",
  home_order_position_1: "promo_marquee",
  home_order_position_2: "product_carousel",
  home_order_position_3: "product_grid",
  home_order_position_4: "vip_group",
  home_order_position_5: "faq",
  home_order_position_6: "",
  home_order_position_7: "",
  home_order_position_8: "",
  home_order_position_9: "",
  home_order_position_10: "",
  home_order_position_11: "",
  home_order_position_12: "",

  hero_banner_2_title: "Coleção Verão",
  hero_banner_2_subtitle: "Camisetas feitas pra durar",
  hero_banner_2_button_text: "Ver coleção",
  hero_banner_2_button_url: "/camisetas",
  hero_banner_2_text_color: "white",
  hero_banner_2_slide2_title: "Básicas",
  hero_banner_2_slide2_subtitle: "O essencial do guarda-roupa",
  hero_banner_2_slide2_button_text: "Comprar",
  hero_banner_2_slide2_button_url: "/basicas",
  hero_banner_2_slide2_text_color: "white",

  promo_marquee_text_1: "Frete grátis acima de R$ 299",
  promo_marquee_text_2: "10% OFF no Pix",
  promo_marquee_text_3: "Troca fácil em 30 dias",
  promo_marquee_text_4: "",
  promo_marquee_bg_color: "primary",
  promo_marquee_text_color: "background",

  product_carousel_title: "Novidades",
  product_carousel_tab_1_label: "Lançamentos",
  product_carousel_tab_2_label: "Mais vendidos",
  product_carousel_tab_3_label: "Promoções",
  product_carousel_bg: "background",

  product_grid_title: "Destaques",
  product_grid_bg: "background",

  vip_group_title: "Grupo VIP",
  vip_group_subtitle: "Ofertas antes de todo mundo",
  vip_group_button_text: "Entrar no grupo",
  vip_group_button_url: "https://wa.me/",
  vip_group_custom_html: "",

  faq_title: "Dúvidas frequentes",
  faq_bg: "background",
  faq_question_1: "Qual o prazo de entrega?",
  faq_answer_1: "De 3 a 10 dias úteis, dependendo da região.",
  faq_question_2: "Como funciona a troca?",
  faq_answer_2: "Até 30 dias após o recebimento.",
  faq_question_3: "",
  faq_question_4: "",
  faq_question_5: "",
  faq_question_6: "",

  cart_free_shipping_bar: true,
  cart_discount_bar: true,
  size_guide_url: "/tabela-de-medidas",
  payment_discount_price: true,
  show_product_fb_comment_box: false,

  footer_about_link_1_text: "Sobre nós",
  footer_about_link_1_url: "/sobre",
  footer_support_link_1_text: "Trocas e devoluções",
  footer_support_link_1_url: "/trocas",
  footer_social_instagram_url: "https://instagram.com/camisetasroma",

  // images the admin "uploaded" — consumed by `has_custom_image`
  __custom_images: ["logo_active.png", "logo_footer.png", "hero_banner_2_desktop.jpg", "hero_banner_2_mobile.jpg", "hero_banner_2_slide2_desktop.jpg", "hero_banner_2_slide2_mobile.jpg", "vip_group_bg.jpg"],
};
