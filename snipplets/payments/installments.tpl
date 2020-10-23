{% if product %}

  {# Product installments #}

  {% if product.show_installments and product.display_price %}

    {% set installments_info_base_variant = product.installments_info %}
    {% set installments_info = product.installments_info_from_any_variant %}

    {# If product detail installments, include container with "see installments" link #}

    {% if product_detail and ( installments_info or custom_payment.discount > 0 ) %}
      <div data-toggle="#installments-modal" data-modal-url="modal-fullscreen-payments" class="js-modal-open js-fullscreen-modal-open js-product-payments-container mb-2" {% if (not product.get_max_installments) and (not product.get_max_installments(false)) %}style="display: none;"{% endif %}>
    {% endif %}

    {# Cash discount #}

    {% if product_detail and custom_payment.discount > 0 %}
      <div class="text-center text-md-left mb-2">
        <span><strong class="text-accent">{{ custom_payment.discount }}% {{'de descuento' | translate }}</strong> {{'pagando con' | translate }} {{ custom_payment.name }}</span>
      </div>
    {% endif %}

    {% set product_can_show_installments = product.show_installments and product.display_price and product.get_max_installments.installment > 1 %}

    {% if product_can_show_installments %}

      {% set max_installments_without_interests = product.get_max_installments(false) %}
      {% set max_installments_with_interests = product.get_max_installments %}

      {% set has_no_interest_payments = max_installments_without_interests and max_installments_without_interests.installment > 1 %}

      {% if has_no_interest_payments %}
        {% set card_icon_color = 'svg-icon-accent' %}
      {% else %}
        {% set card_icon_color = 'svg-icon-text' %}
      {% endif %}

      {# If NOT product detail, just include installments alone without link or container #}
      <div class="js-max-installments-container js-max-installments {% if product_detail %}text-center text-md-left mb-2{% else %}item-installments{% endif %}">

        {% if has_no_interest_payments %}

          <div class="js-max-installments">
            {% if product_detail %}

              {# Accent color used on product detail #}

              {{ "<span class='text-accent font-weight-bold'><span class='js-installment-amount installment-amount'>{1}</span> cuotas sin interés</span> de <span class='js-installment-price installment-price'>{2}</span>" | t(max_installments_without_interests.installment, max_installments_without_interests.installment_data.installment_value_cents | money) }}
            {% else %}
              {{ "<strong class='js-installment-amount installment-amount'>{1}</strong> cuotas sin interés de <strong class='js-installment-price installment-price'>{2}</strong>" | t(max_installments_without_interests.installment, max_installments_without_interests.installment_data.installment_value_cents | money) }}
            {% endif %}
          </div>
        {% else %}
          {% if store.country != 'AR' or product_detail %}
            {% set max_installments_with_interests = product.get_max_installments %}
            {% if max_installments_with_interests %}
              <div class="js-max-installments">{{ "<strong class='js-installment-amount installment-amount'>{1}</strong> cuotas de <strong class='js-installment-price installment-price'>{2}</strong>" | t(max_installments_with_interests.installment, max_installments_with_interests.installment_data.installment_value_cents | money) }}</div>
            {% else %}
              <div class="js-max-installments" style="display: none;">
                {% if product.max_installments_without_interests %}
                  {% if product_detail %}

                    {# Accent color used on product detail #}

                    {{ "<span class='text-accent font-weight-bold'><span class='js-installment-amount installment-amount'>{1}</span> cuotas sin interés</span> de <span class='js-installment-price installment-price'>{2}</span>" | t(null, null) }}
                    
                  {% else %}
                    {{ "<strong class='js-installment-amount installment-amount'>{1}</strong> cuotas sin interés de <strong class='js-installment-price installment-price'>{2}</strong>" | t(null, null) }}
                  {% endif %}
                {% else %}
                  {{ "<strong class='js-installment-amount installment-amount'>{1}</strong> cuotas de <strong class='js-installment-price installment-price'>{2}</strong>" | t(null, null) }}
                {% endif %}
              </div>
            {% endif %}
          {% endif %}
        {% endif %}
      </div>
    {% endif %}

    {% if product_detail and installments_info %}
      <div class="form-row align-items-center align-items-start-md mb-4">
        {% set has_payment_logos = settings.payments %}
        {% if has_payment_logos %}
          <ul class="list-inline col col-md-auto text-center text-md-left mb-1">
            {% for payment in settings.payments %}
                {# Payment methods flags #}
                {% if store.country == 'BR' %}
                  {% if payment in ['visa', 'mastercard'] %}
                    <li>     
                      {{ payment | payment_new_logo | img_tag('',{class: 'card-img card-img-small lazyload'}) }}
                    </li>
                  {% endif %}
                {% else %}
                    {% if payment in ['visa', 'amex', 'mastercard'] %}
                      <li>
                        {{ payment | payment_new_logo | img_tag('',{class: 'card-img card-img-small lazyload'}) }}
                      </li>
                    {% endif %}
                {% endif %}
            {% endfor %}
              <li>
                {% include "snipplets/svg/credit-card-blank.tpl" with {svg_custom_class: "icon-inline icon-w-18 icon-2x " ~ card_icon_color ~ ""} %}
              </li>
          </ul>
        {% endif %}
        <div class="col-12 col-md-auto text-center">
          <a id="btn-installments" class="btn-link" {% if (not product.get_max_installments) and (not product.get_max_installments(false)) %}style="display: none;"{% endif %}>
            {% set store_set_for_new_installments_view = store.is_set_for_new_installments_view %}
            {% if store_set_for_new_installments_view %}
                {{ "Ver medios de pago" | translate }}
            {% else %}
                {{ "Ver el detalle de las cuotas" | translate }}
            {% endif %}
          </a>
        </div>
      </div>
    </div>
    {% endif %}  
  {% endif %}
{% else %}

  {# Cart installments #}
  
  {% if cart.installments.max_installments_without_interest > 1 %}
    {% set installment =  cart.installments.max_installments_without_interest  %}
    {% set total_installment = cart.total %}
    {% set interest = false %}
    {% set interest_value = 0 %}
  {% else %}
    {% set installment = cart.installments.max_installments_with_interest  %}
    {% set total_installment = (cart.total * (1 + cart.installments.interest)) %}
    {% set interest = true %}
    {% set interest_value = cart.installments.interest %}
  {% endif %}
  <div {% if installment < 2 or ( store.country == 'AR' and interest == true ) %} style="display: none;" {% endif %} data-interest="{{ interest_value }}" data-cart-installment="{{ installment }}" class="js-installments-cart-total {% if template == 'cart' %}text-md-center{% endif %} text-right {% if interest == false %}text-accent font-weight-bold{% endif %}">    
    {{ 'O hasta' | translate }}
    {% if interest == true %}
      {{ "<strong class='js-cart-installments-amount'>{1}</strong> cuotas de <strong class='js-cart-installments installment-price'>{2}</strong>" | t(installment, (total_installment / installment) | money) }}
    {% else %}
      {{ "<span class='js-cart-installments-amount'>{1}</span> cuotas sin interés de <span class='js-cart-installments installment-price'>{2}</span>" | t(installment, (total_installment / installment) | money) }}
    {% endif %}
  </div>
{% endif %}
