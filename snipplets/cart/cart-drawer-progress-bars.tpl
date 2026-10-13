{# Barras de progresso promocionais (frete grátis + desconto progressivo).

   Ordem (Figma): desconto primeiro, frete depois. Barra de 6px, rótulo centralizado
   ABAIXO da barra em cor highlight, sem ícone, com trecho em negrito.

   Snipplet COMPARTILHADO: é renderizado dentro do rodapé do cart drawer
   (`cart-drawer.tpl`) e também dentro da sticky buy bar da PDP
   (`product-sticky-buy-bar.tpl`). Os dois blocos saem do mesmo estado de
   carrinho no servidor, então o HTML das duas cópias é sempre idêntico.

   `.js-cart-progress-bars` é a âncora de sincronização usada por
   `cart-drawer.js` (`syncProgressBars`) para atualizar TODAS as instâncias da
   página depois de adicionar/remover item ou mudar quantidade, sem reload.
   A classe `contents` (display: contents) tira o wrapper do fluxo de layout,
   para que os dois contextos (rodapé em bloco e coluna flex da PDP) continuem
   renderizando exatamente como antes de existir o wrapper. #}
<div class="js-cart-progress-bars contents">

{# Progress bar: Progressive Discounts #}
{% if settings.cart_discount_bar and settings.cart_discount_tier_1_qty %}
  {% set total_items = cart.items_count %}
  {% set t1_qty = settings.cart_discount_tier_1_qty * 1 %}
  {% set t1_pct = settings.cart_discount_tier_1_pct * 1 %}
  {% set t2_qty = settings.cart_discount_tier_2_qty ? settings.cart_discount_tier_2_qty * 1 : 0 %}
  {% set t2_pct = settings.cart_discount_tier_2_pct ? settings.cart_discount_tier_2_pct * 1 : 0 %}
  {% set t3_qty = settings.cart_discount_tier_3_qty ? settings.cart_discount_tier_3_qty * 1 : 0 %}
  {% set t3_pct = settings.cart_discount_tier_3_pct ? settings.cart_discount_tier_3_pct * 1 : 0 %}

  {# Find the next target tier and current progress #}
  {% set discount_completed = false %}
  {% set target_qty = t1_qty %}
  {% set target_pct = t1_pct %}

  {% if total_items >= t1_qty %}
    {% if t2_qty > 0 %}
      {% set target_qty = t2_qty %}
      {% set target_pct = t2_pct %}
      {% if total_items >= t2_qty %}
        {% if t3_qty > 0 %}
          {% set target_qty = t3_qty %}
          {% set target_pct = t3_pct %}
          {% if total_items >= t3_qty %}
            {% set discount_completed = true %}
            {% set achieved_pct = t3_pct %}
          {% endif %}
        {% else %}
          {% set discount_completed = true %}
          {% set achieved_pct = t2_pct %}
        {% endif %}
      {% endif %}
    {% elseif t3_qty > 0 %}
      {% set target_qty = t3_qty %}
      {% set target_pct = t3_pct %}
      {% if total_items >= t3_qty %}
        {% set discount_completed = true %}
        {% set achieved_pct = t3_pct %}
      {% endif %}
    {% else %}
      {% set discount_completed = true %}
      {% set achieved_pct = t1_pct %}
    {% endif %}
  {% endif %}

  {% if discount_completed %}
    {% set discount_progress = 100 %}
  {% else %}
    {% set discount_progress = (total_items * 100) / target_qty %}
    {% if discount_progress > 100 %}
      {% set discount_progress = 100 %}
    {% endif %}
    {% set remaining_items = target_qty - total_items %}
  {% endif %}

  <div class="js-cart-progress-bar flex flex-col gap-2 mb-3" data-progress-bar="discount">
    <div class="h-1.5 rounded-full bg-secondary/10 overflow-hidden">
      <div class="js-cart-progress-fill h-full rounded-full bg-highlight transition-all duration-300 {% if discount_completed %}js-cart-progress-complete{% endif %}" style="width: {{ discount_progress }}%"></div>
    </div>
    <div class="text-center text-xs text-highlight">
      <span class="js-cart-progress-label{% if discount_completed %} font-bold{% endif %}">{% if discount_completed %}{{ "¡Conseguiste {1}% OFF!" | translate(achieved_pct) }}{% else %}{% if remaining_items == 1 %}{{ "Falta" | translate }} <strong>{{ "{1} item" | translate(remaining_items) }}</strong>{% else %}{{ "Faltam" | translate }} <strong>{{ "{1} itens" | translate(remaining_items) }}</strong>{% endif %} {{ "para" | translate }} <strong>{{ "{1}% OFF" | translate(target_pct) }}</strong>{% endif %}</span>
    </div>
  </div>
{% endif %}

{# Progress bar: Free Shipping #}
{% if settings.cart_free_shipping_bar and cart.free_shipping.min_price_free_shipping.min_price_raw %}
  {% set fs_min = cart.free_shipping.min_price_free_shipping.min_price_raw %}
  {% set fs_subtotal = cart.subtotal %}

  {% if cart.free_shipping.cart_has_free_shipping or fs_subtotal >= fs_min %}
    {% set fs_progress = 100 %}
    {% set fs_completed = true %}
  {% else %}
    {% set fs_progress = (fs_subtotal * 100) / fs_min %}
    {% set fs_completed = false %}
    {% if fs_progress > 100 %}
      {% set fs_progress = 100 %}
    {% endif %}
    {% set fs_remaining = fs_min - fs_subtotal %}
  {% endif %}

  <div class="js-cart-progress-bar flex flex-col gap-2 mb-3" data-progress-bar="free-shipping">
    <div class="h-1.5 rounded-full bg-secondary/10 overflow-hidden">
      <div class="js-cart-progress-fill h-full rounded-full bg-highlight transition-all duration-300 {% if fs_completed %}js-cart-progress-complete{% endif %}" style="width: {{ fs_progress }}%"></div>
    </div>
    <div class="text-center text-xs text-highlight">
      <span class="js-cart-progress-label{% if fs_completed %} font-bold{% endif %}">{% if fs_completed %}{{ "¡Tenés envío gratis!" | translate }}{% else %}{{ "Faltam" | translate }} <strong>{{ fs_remaining | money }}</strong> {{ "para obter o" | translate }} <strong>{{ "FRETE GRÁTIS" | translate }}</strong>{% endif %}</span>
    </div>
  </div>
{% endif %}

</div>
