{% if product %}

  {# Product installments #}

  {% if product.show_installments and product.display_price %}

    {% set installments_info_base_variant = product.installments_info %}
    {% set installments_info = product.installments_info_from_any_variant %}

    {# If product detail installments, include container with "see installments" link #}

    {% if product_detail and installments_info %}
      <div data-toggle="#installments-modal" class="js-modal-open js-product-payments-container mb-2" {% if (not product.get_max_installments) and (not product.get_max_installments(false)) %}style="display: none;"{% endif %}>
    {% endif %}

    {% set product_can_show_installments = product.show_installments and product.display_price and product.get_max_installments.installment > 1 %}

    {% if product_can_show_installments %}

      {# If NOT product detail, just include installments alone without link or container #}
      <div class="{% if product_detail %}js-max-installments-container js-max-installments text-center text-sm-left{% else %}item-installments{% endif %}">
        {% set max_installments_without_interests = product.get_max_installments(false) %}
        {% set max_installments_with_interests = product.get_max_installments %}
        {% if store.country == 'AR' %}
          {% if max_installments_with_interests %}
            <div>{{ "Hasta <strong class='installment-amount'>{1}</strong> cuotas" | t(max_installments_with_interests.installment, max_installments_with_interests.installment_data.installment_value_cents | money) }}</div>
          {% else %}
            <div style="display: none;">
            {% if product.max_installments_without_interests %}
              {{ "Hasta <strong class='js-installment-amount installment-amount'>{1}</strong> cuotas sin interés" | t(null, null) }}
            {% else %}
              {{ "Hasta <strong class='js-installment-amount installment-amount'>{1}</strong> cuotas sin interés" | t(null, null) }}
            {% endif %}
            </div>
          {% endif %}
        {% else %}
            {% if max_installments_without_interests and max_installments_without_interests.installment > 1 %}
              <div class="js-max-installments">{{ "<strong class='js-installment-amount installment-amount'>{1}</strong> cuotas sin interés de <strong class='js-installment-price installment-price'>{2}</strong>" | t(max_installments_without_interests.installment, max_installments_without_interests.installment_data.installment_value_cents | money) }}</div>
            {% else %}
              {% set max_installments_with_interests = product.get_max_installments %}
              {% if max_installments_with_interests %}
                <div class="js-max-installments">{{ "<strong class='js-installment-amount installment-amount'>{1}</strong> cuotas de <strong class='js-installment-price installment-price'>{2}</strong>" | t(max_installments_with_interests.installment, max_installments_with_interests.installment_data.installment_value_cents | money) }}</div>
              {% else %}
                <div class="js-max-installments" style="display: none;">
                  {% if product.max_installments_without_interests %}
                    {{ "<strong class='js-installment-amount installment-amount'>{1}</strong> cuotas sin interés de <strong class='js-installment-price installment-price'>{2}</strong>" | t(null, null) }}
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
      <div class="form-row align-items-center align-items-start-sm">
        {% set has_payment_logos = settings.payments %}
        {% if has_payment_logos %}
          <ul class="list-inline col col-sm-auto text-right text-sm-left">
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
                {% include "snipplets/svg/credit-card-blank.tpl" %}
              </li>
          </ul>
        {% endif %}
        <div class="col text-left">
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
  
  {% if store.country == 'BR' %}
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
  <div {% if installment < 2 %} style="display: none;" {% endif %} data-interest="{{ interest_value }}" data-cart-installment="{{ installment }}" class="js-installments-cart-total text-right"> 
    {{ 'O hasta' | translate }}
    <span class="js-cart-installments-amount">{{ installment }}</span> 
    {{ 'cuotas de' | translate }} 
    <span class="js-cart-installments">{{ (total_installment / installment) | money }}</span> 
    <span {% if interest == true %} style="display: none;" {% endif %}class="js-installments-type-interest">{{ 'sin interés' | translate}}</span>
  </div>
  {% endif %}
{% endif %}
