{% if product.compare_at_price > product.price %}
{% set price_discount_percentage = ((product.compare_at_price) - (product.price)) * 100 / (product.compare_at_price) %}
{% endif %}

{% if color %}
  {% set show_labels = settings.product_color_variants %}
{% else %}
  {% set show_labels = not product.has_stock or product.free_shipping or product.compare_at_price or product.promotional_offer %}
{% endif %}

{% if show_labels %}
  <div class="{% if product.video_url and product %}js-labels-group{% endif %} labels">
    {% if not product.has_stock %}
      <div class="{% if product_detail %}js-stock-label {% endif %}label label-default">{{ "Sin stock" | translate }}</div>
    {% else %}
      {% if product_detail or color %}
        <div class="js-stock-label label label-default" {% if product.has_stock %}style="display:none;"{% endif %}>{{ "Sin stock" | translate }}</div>
      {% endif %}
      {% if product.compare_at_price or product.promotional_offer %}
        <div class="{% if not product.promotional_offer and product %}js-offer-label{% endif %} label label-accent" {% if (not product.compare_at_price and not product.promotional_offer) or not product.display_price %}style="display:none;"{% endif %}>
          {% if product.promotional_offer.script.is_percentage_off %}
            {{ product.promotional_offer.parameters.percent * 100 }}% OFF
          {% elseif product.promotional_offer.script.is_discount_for_quantity %}
            <div>{{ product.promotional_offer.selected_threshold.discount_decimal_percentage * 100 }}% OFF</div>
            <div class="label-small p-right-quarter p-left-quarter">{{ "Comprando {1} o más" | translate(product.promotional_offer.selected_threshold.quantity) }}</div>
          {% elseif product.promotional_offer %}
            {% if store.country == 'BR' %}
              {{ "Leve {1} Pague {2}" | translate(product.promotional_offer.script.quantity_to_take, product.promotional_offer.script.quantity_to_pay) }}
            {% else %}
              {{ "Promo" | translate }} {{ product.promotional_offer.script.type }} 
            {% endif %}
          {% else %}
            <span {% if product_detail or color %}class="js-offer-percentage"{% endif %}>{{ price_discount_percentage |round }}</span>% OFF
          {% endif %}
        </div>
      {% endif %}
      {% if product.free_shipping %}
        <div class="label label-secondary">{{ "Envío gratis" | translate }}</div>
      {% endif %}
    {% endif %}
  </div>
{% endif %}