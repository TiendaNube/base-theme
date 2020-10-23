{# IMPORTANT Do not remove this hidden subtotal, it is used by JS to calculate cart total #}
<div class="subtotal-price hidden" data-priceraw="{{ cart.total }}"></div>

{# Define contitions to show shipping calculator and store branches on cart #}

{% set show_calculator_on_cart = settings.shipping_calculator_cart_page and store.has_shipping %}
{% set show_cart_fulfillment = settings.shipping_calculator_cart_page and (store.has_shipping or store.branches) %}

{# Used to assign currency to total #}
<div id="store-curr" class="hidden">{{ cart.currency }}</div>

{% if not cart_page %}
  {# Cart popup subtotal #}
  <h5 class="js-visible-on-cart-filled {% if not cart_page %}row no-gutters{% else %}text-right{% endif %} mb-1 {% if cart_page %}text-center-xs{% endif %}" {% if cart.items_count == 0 %}style="display:none;"{% endif %}>
    <span {% if not cart_page %}class="col"{% endif %}>
      {{ "Subtotal" | translate }}
      <small class="js-subtotal-shipping-wording" {% if not (cart.has_shippable_products or show_calculator_on_cart) %}style="display: none"{% endif %}>{{ " (sin envío)" | translate }}</small>
      :
    </span>
    <strong class="js-ajax-cart-total js-cart-subtotal {% if not cart_page %}col{% endif %} text-right" data-priceraw="{{ cart.subtotal }}">{{ cart.subtotal | money }}</strong>
  </h5>

  {# Cart popup promos #}
  <div class="js-total-promotions text-accent font-weight-bold">
    <span class="js-promo-title" style="display:none;">{{ "Promo" | translate }}</span>
    <span class="js-promo-in" style="display:none;">{{ "en" | translate }}</span>
    <span class="js-promo-all" style="display:none;">{{ "todos los productos" | translate }}</span>
    <span class="js-promo-buying" style="display:none;"> {{ "comprando" | translate }}</span>
    <span class="js-promo-units-or-more" style="display:none;"> {{ "o más" | translate }}</span>
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
              <span>{{ "Comprando {1} o más" | translate(promotion.selected_threshold.quantity) }}</span>
            {% endif %}
            :
          </span>
          <span class="col text-right">-{{ promotion.total_discount_amount_short }}</span>
        </span>
    {% endfor %}
  </div>
{% endif %}
{% if cart_page %}
  <div class="divider {% if cart_page %}d-none d-md-block{% endif %}"></div>
  <div class="container p-0">
    <div class="row">
{% endif %}
    {% if cart_page %}
      <div class="col-12 col-md-5">
    {% endif %}
      {% if show_cart_fulfillment %}
        <div class="js-fulfillment-info js-allows-non-shippable" {% if not cart.has_shippable_products %}style="display: none"{% endif %}>
          <div class="js-visible-on-cart-filled divider {% if cart_page %}d-md-none{% endif %}" {% if cart.items_count == 0 %}style="display:none;"{% endif %}></div>

          <div class="js-visible-on-cart-filled js-has-new-shipping js-shipping-calculator-container container-fluid">

            {# Saved shipping not available #}

            <div class="js-shipping-method-unavailable alert alert-warning row" style="display: none;">
              <div>
                <strong>{{ 'El medio de envío que habías elegido ya no se encuentra disponible para este carrito. ' | translate }}</strong>
              </div>
              <div>
                {{ '¡No te preocupes! Podés elegir otro.' | translate}}
              </div>
            </div>

            {# Shipping calculator and branch link #}

            <div id="cart-shipping-container" class="row" {% if cart.items_count == 0 %} style="display: none;"{% endif %} data-shipping-url="{{ store.shipping_calculator_url }}">

              {# Used to save shipping #}

              <span id="cart-selected-shipping-method" data-code="{{ cart.shipping_data.code }}" class="hidden">{{ cart.shipping_data.name }}</span>

              {# Shipping Calculator #}

              {% if store.has_shipping %}
                {% include "snipplets/shipping/shipping-calculator.tpl" with {'product_detail': false} %}
              {% endif %}

              {# Store branches #}

              {% if store.branches %}

                {# Link for branches #}

                {% include "snipplets/shipping/branches.tpl" with {'product_detail': false} %}
              {% endif %}
            </div>
          </div>

          <div class="js-visible-on-cart-filled divider {% if cart_page %}d-md-none{% endif %} {% if not store.branches %} mt-0{% endif %}" {% if cart.items_count == 0 %}style="display:none;"{% endif %}></div>
        </div>
      {% endif %}
    {% if cart_page %}
      </div>
    {% endif %}
    {% if cart_page %}
      <div class="col-12 col-md-7" {% if cart.items_count == 0 %}style="display:none;"{% endif %}>
        <div id="cart-sticky-summary" class="position-sticky-md container-fluid">
          <div class="row justify-content-md-end mt-4 mt-md-0">
            <div class="col-12 col-md-auto">
              {# Cart page subtotal #}
              <h5 class="js-visible-on-cart-filled row no-gutters justify-content-end justify-content-md-center mb-1" {% if cart.items_count == 0 %}style="display:none;"{% endif %}>
                <span class="col col-md-auto">
                  {{ "Subtotal" | translate }}
                  {% if settings.shipping_calculator_cart_page %}
                    <small>{{ " (sin envío)" | translate }}</small>
                  {% endif %}
                  :
                </span>
                <strong class="js-cart-subtotal col col-md-auto text-right" data-priceraw="{{ cart.subtotal }}">{{ cart.subtotal | money }}</strong>
              </h5>

              {# Cart page promos #}
              <div class="js-total-promotions">
                <span class="js-promo-title" style="display:none;">{{ "Promo" | translate }}</span>
                <span class="js-promo-in" style="display:none;">{{ "en" | translate }}</span>
                <span class="js-promo-all" style="display:none;">{{ "todos los productos" | translate }}</span>
                <span class="js-promo-buying" style="display:none;"> {{ "comprando" | translate }}</span>
                <span class="js-promo-units-or-more" style="display:none;"> {{ "o más" | translate }}</span>
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
                          <span>{{ "Comprando {1} o más" | translate(promotion.selected_threshold.quantity) }}</span>
                        {% endif %}
                        :
                      </span>
                      <span class="col text-right">-{{ promotion.total_discount_amount_short }}</span>
                    </span>
                {% endfor %}
              </div>
    {% endif %}

              {# Cart total #}

              <div class="js-cart-total-container js-visible-on-cart-filled mb-3" {% if cart.items_count == 0 %}style="display:none;"{% endif %} data-store="cart-total">
                <h2 class="row no-gutters text-primary mb-0 {% if cart_page %}justify-content-end justify-content-md-center{% endif %}">
                  <span class="col {% if cart_page %}col-md-auto{% endif %} mr-1">{{ "Total" | translate }}:</span>
                  <span class="js-cart-total {% if cart.free_shipping.cart_has_free_shipping %}js-free-shipping-achieved{% endif %} {% if cart.shipping_data.selected %}js-cart-saved-shipping{% endif %} col {% if cart_page %}col-md-auto{% endif %} text-right">{{ cart.total | money }}</span>
                </h2>

                {# IMPORTANT Do not remove this hidden total, it is used by JS to calculate cart total #}
                <div class='total-price hidden'>
                  {{ "Total" | translate }}: {{ cart.total | money }}
                </div>
                {% include "snipplets/payments/installments.tpl" with {'product': false} %}
              </div>

              <div class="js-visible-on-cart-filled {% if not cart_page %}container-fluid{% endif %}" {% if cart.items_count == 0 %}style="display:none;"{% endif %}>

                {# No stock alert #}

                <div id="error-ajax-stock" class='alert alert-warning' role='alert' style="display:none;">
                   {{ "¡Uy! No tenemos más stock de este producto para agregarlo al carrito. Si querés podés" | translate }}<a href="{{ store.products_url }}" class="btn-link">{{ "ver otros acá" | translate }}</a>
                </div>

                {# Cart panel CTA #}
                
                {% set cart_total = (settings.cart_minimum_value * 100) %}

                {# Cart CTA Module for cart popup or cart page #}

                {% if cart_page %}
                  {% if cart.checkout_enabled %}
                    <input id="go-to-checkout" class="btn btn-primary btn-block mb-3" type="submit" name="go_to_checkout" value="{{ 'Iniciar Compra' | translate }}"/>
                  {% else %}

                    {# Cart minium alert #}

                    <div class="alert alert-warning mt-4">
                      {{ "El monto mínimo de compra es de {1} sin incluir el costo de envío" | t(cart_total | money) }}
                    </div>
                  {% endif %}
                {% else %}
                  <div class="js-ajax-cart-submit row mb-3" {{ not cart.checkout_enabled ? 'style="display:none"' }} id="ajax-cart-submit-div">
                    <input class="btn btn-primary btn-block" type="submit" name="go_to_checkout" value="{{ 'Iniciar Compra' | translate }}"/>
                  </div>

                  {# Cart minium alert #}

                  <div class="js-ajax-cart-minimum alert alert-warning mt-4" {{ cart.checkout_enabled ? 'style="display:none"' }} id="ajax-cart-minumum-div">
                    {{ "El monto mínimo de compra es de {1} sin incluir el costo de envío" | t(cart_total | money) }}
                  </div>
                  <input type="hidden" id="ajax-cart-minimum-value" value="{{ cart_total }}"/>
                {% endif %}

                {# Cart panel continue buying link #}

                {% if settings.continue_buying %}
                  <div class="row mb-2">
                    <div class="text-center w-100">
                      <a href="{% if cart_page %}{{ store.products_url }}{% else %}#{% endif %}" class="{% if not  cart_page %}js-modal-close js-fullscreen-modal-close{% endif %} btn btn-link">{{ 'Ver más productos' | translate }}</a>
                    </div>
                  </div>
                {% endif %}
              </div>
{% if cart_page %}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
{% endif %}