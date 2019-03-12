{# IMPORTANT Do not remove this hidden subtotal, it is used by JS to calculate cart total #}
<div class="subtotal-price hidden" data-priceraw="{{ cart.subtotal }}"></div>

{# Used to assign currency to total #}
<div id="store-curr" class="hidden">{{ cart.currency }}</div>
    
{# Cart panel subtotal #}
<h5 class="js-visible-on-cart-filled {% if not cart_page %}row{% else %}text-right{% endif %} mb-1 {% if cart_page %}text-center-xs{% endif %}" {% if cart.items_count == 0 %}style="display:none;"{% endif %}>
  <span {% if not cart_page %}class="col"{% endif %}>
    {{ "Subtotal" | translate }}
    {% if settings.shipping_calculator_cart_page %}
      <small>{{ " (sin envío)" | translate }}</small>
    {% endif %}
    :
  </span>
  <strong class="js-ajax-cart-total js-cart-subtotal {% if not cart_page %}col{% endif %} text-right" data-priceraw="{{ cart.subtotal }}">{{ cart.subtotal | money }}</strong>
</h5>

{# Cart panel promos #}
<div class="js-total-promotions">
  <span class="js-promo-title" style="display:none;">{{ "Promo" | translate }}</span>
  <span class="js-promo-in" style="display:none;">{{ "en" | translate }}</span>
  <span class="js-promo-all" style="display:none;">{{ "todos los productos" | translate }}</span>
  <span class="js-promo-buying" style="display:none;"> {{ "comprando" | translate }}</span>
  <span class="js-promo-units-or-more" style="display:none;"> {{ "o más un." | translate }}</span>
  {% for promotion in cart.promotional_discount.promotions_applied %}
    {% if(promotion.scope_value_id) %}
      {% set id = promotion.scope_value_id %}
    {% else %}
      {% set id = 'all' %}
    {% endif %}
      <span class="js-total-promotions-detail-row row" id="{{ id }}">
        <span class="col">
          {% if promotion.discount_script_type == "NAtX%off" %}
            {{ promotion.selected_threshold.discount_decimal_percentage * 100 }}% OFF
          {% else %}
            {{ "Promo" | translate }} {{ promotion.discount_script_type }} 
          {% endif %}

          {{ "en" | translate }} {% if id == 'all' %}{{ "todos los productos" | translate }}{% else %}{{ promotion.scope_value_name }}{% endif %}

          {% if promotion.discount_script_type == "NAtX%off" %}
            <span>{{ "Comprando {1} o más un." | translate(promotion.selected_threshold.quantity) }}</span>
          {% endif %}
          :
        </span>
        <span class="col text-right">-{{ promotion.total_discount_amount_short }}</span>
      </span>
  {% endfor %}
</div>

{% if settings.shipping_calculator_cart_page %}
  <div class="js-visible-on-cart-filled divider" {% if cart.items_count == 0 %}style="display:none;"{% endif %}></div>

  <div class="js-visible-on-cart-filled js-has-new-shipping js-shipping-calculator-container container-fluid">

    {# Saved shipping not available #}

    <div class="js-shipping-method-unavailable alert alert-warning row" style="display: none;">
      <div>
        <strong>{{ 'El medio de envío que habías elegido ya no se encuentra disponible ' | translate }}</strong>{{ 'porque el total de los items del carrito superan el peso máximo.' | translate }}
      </div>
      <div>
        {{ '¡No te preocupes! Podés elegir otro medio de envío.' | translate}}
      </div>
    </div>

    {# Shipping calculator and branch link #}

    <div id="cart-shipping-container" class="row" {% if cart.items_count == 0 %} style="display: none;"{% endif %} data-shipping-url="{{ store.shipping_calculator_url }}">

      {# Used to save shipping #}

      <span id="cart-selected-shipping-method" data-code="{{ cart.shipping_data.code }}" class="hidden">{{ cart.shipping_data.name }}</span>

      {# Shipping Calculator #}

      {% if store.has_shipping %}
        {% include "snipplets/shipping/shipping-calculator.tpl" with {'shipping_calculator_show': settings.shipping_calculator_cart_page, 'product_detail': false} %}
      {% endif %}

      {# Store branches #}

      {% if store.branches and store.country != 'BR' %}

        {# Link for branches #}

        {% include "snipplets/shipping/branches.tpl" with {'product_detail': false} %}
      {% endif %}
    </div>
  </div>

  <div class="js-visible-on-cart-filled divider {% if not store.branches or store.country == 'BR' %} mt-0{% endif %}" {% if cart.items_count == 0 %}style="display:none;"{% endif %}></div>

{% endif %}

{# Cart panel total #}

<div class="js-cart-total-container js-visible-on-cart-filled mb-3" {% if cart.items_count == 0 %}style="display:none;"{% endif %}>
  <h2 class="{% if not cart_page %}row{% else %}text-right{% endif %} text-primary mb-0">
    <span {% if not cart_page %}class="col"{% endif %}>{{ "Total" | translate }}:</span>
    <span class="js-cart-total {% if cart.shipping_data.selected %}js-cart-saved-shipping{% endif %} {% if not cart_page %}col{% endif %} text-right">{{ cart.total | money }}</span>
  </h2>

  {# IMPORTANT Do not remove this hidden total, it is used by JS to calculate cart total #}
  <div class='total-price hidden'>
    {{ "Total" | translate }}: {{ cart.total | money }}
  </div>
  {% include "snipplets/payments/installments.tpl" with {'product': false} %}
</div>

<div class="js-visible-on-cart-filled container-fluid" {% if cart.items_count == 0 %}style="display:none;"{% endif %}>

  {# No stock alert #}

  <div id="error-ajax-stock" class='alert alert-warning' role='alert' style="display:none;">
     {{ "¡Uy! No tenemos más stock de este producto para agregar este producto al carrito. Si querés podés" | translate }}<a href="{{ store.products_url }}" class="btn-link">{{ "ver otros acá" | translate }}</a>
  </div>
  <div>
    {% if cart_page %}
    <div class="row justify-content-end">
      <div class="col col-md-3">
    {% endif %}

    {# Cart panel CTA #}
    
    {% set cart_total = (settings.cart_minimum_value * 100) %}

    <div class="js-ajax-cart-submit row mb-3" {{ cart.total < cart_total ? 'style="display:none"' }} id="ajax-cart-submit-div">
      <input class="btn btn-primary btn-block" type="submit" name="go_to_checkout" value="{{ 'Iniciar Compra' | translate }}"/>
    </div>

    {# Cart panel continue buying link #}

    {% if settings.continue_buying %}
      <div class="row mb-2">
        <div class="text-center w-100">
          <a href="#" class="js-modal-close btn btn-link">{{ 'Seguir comprando' | translate }}</a>
        </div>
      </div>
    {% endif %}

    {# Cart minium alert #}

    <div class="js-ajax-cart-minimum alert alert-warning mt-4" {{ cart.total >= cart_total ? 'style="display:none"' }} id="ajax-cart-minumum-div">
      {{ "El monto mínimo de compra (subtotal) es de" | translate }} {{ cart_total | money }}
    </div>
    <input type="hidden" id="ajax-cart-minimum-value" value="{{ cart_total }}"/>
    {% if cart_page %}
    </div>
    </div>
    {% endif %}
  </div>
</div>