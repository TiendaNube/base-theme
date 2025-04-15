{% if product.compare_at_price > product.price %}
{% set price_discount_percentage = ((product.compare_at_price) - (product.price)) * 100 / (product.compare_at_price) %}
{% endif %}

{% set has_product_available = product.available and product.display_price %}

{% set store_has_free_shipping = not product.is_non_shippable and (product.free_shipping or (has_product_available and (cart.free_shipping.cart_has_free_shipping or cart.free_shipping.min_price_free_shipping.min_price))) %}

{% set product_price_above_free_shipping_minimum = cart.free_shipping.min_price_free_shipping and (product.price >= cart.free_shipping.min_price_free_shipping.min_price_raw) %}

{% if color %}
  {% set show_labels = settings.product_color_variants %}
{% else %}
  {% set show_labels = not product.has_stock or store_has_free_shipping or product.compare_at_price or product.promotional_offer %}
{% endif %}

<div class="{% if product.video_url and product %}js-labels-group{% endif %} labels" data-store="product-item-labels">
  {% if show_labels %}
    {% if not product.has_stock %}
      <div class="{% if product_detail %}js-stock-label {% endif %}label label-default">{{ "Sin stock" | translate }}</div>
    {% else %}
      {% if product_detail or color %}
        <div class="js-stock-label label label-default" {% if product.has_stock %}style="display:none;"{% endif %}>{{ "Sin stock" | translate }}</div>
      {% endif %}
      {% if product.compare_at_price or product.promotional_offer %}
        <div class="{% if not product.promotional_offer and product %}js-offer-label{% endif %} label label-accent" {% if (not product.compare_at_price and not product.promotional_offer) or not product.display_price %}style="display:none;"{% endif %} data-store="product-item-{% if product.compare_at_price %}offer{% else %}promotion{% endif %}-label">
          {% if product.promotional_offer %}
            {{ component('promotion-label-text', {
              promotion_label_text_classes: {
                primary_text: 'd-block',
              },
              quantity_long_wording: true,
            }) }}
          {% else %}
            <span {% if product_detail or color %}class="js-offer-percentage"{% endif %}>{{ price_discount_percentage |round }}</span>% OFF
          {% endif %}
        </div>
      {% endif %}
      {% if store_has_free_shipping %}
        <div class="{% if not product.free_shipping %}js-free-shipping-minimum-label {% endif %}label label-secondary" {% if not (product.free_shipping or product_price_above_free_shipping_minimum) %}style="display: none;"{% endif %}>{{ "Envío gratis" | translate }}</div>
      {% endif %}
    {% endif %}
  {% endif %}
</div>
<span class="hidden" data-store="stock-product-{{ product.id }}-{% if product.has_stock %}{% if product.stock %}{{ product.stock }}{% else %}infinite{% endif %}{% else %}0{% endif %}"></span>
