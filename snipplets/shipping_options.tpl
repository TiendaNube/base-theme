{% if options %}
    {% if store.has_smart_dates and show_time %}
        <div class="radio-group-label mb-2">{{"El tiempo de entrega no considera feriados." | translate}}</div>
    {% endif %}
    <ul class="list-unstyled">

        {# Smart shipping hides similar shipping options on a toggle div and also shows an improved shipping item #}

        {# Check if smart shipping is needed #}

        {% set has_options_to_hide = false %}

        {% for option in options_to_hide %}
            {% if options_to_hide|length >= 1 %}
                {% set has_options_to_hide = true %}
            {% endif %}
        {% endfor %}

        {% for option in options_to_show if store.country == 'BR' or not store.has_new_shipping or option.img_code != "branch" %}
            {% include "snipplets/shipping/shipping-calculator-item.tpl" with {'featured_option': true} %}
        {% endfor %}

        {% if has_options_to_hide %}
            <div class="js-show-more-shipping-options d-inline-block w-100 mt-3 text-center">
                <a href="#" class=" btn-link">
                    <span class="js-shipping-see-more">{{ 'Ver más opciones' | translate }}<i class="far fa-chevron-down ml-1" aria-hidden="true"></i></span>
                    <span class="js-shipping-see-less" style="display: none;">{{ 'Ver menos opciones' | translate }}<i class="far fa-chevron-up ml-1" aria-hidden="true"></i></span>
                </a>
            </div>
            <div class="js-other-shipping-option w-100 mt-3" style="display: none;">
                {% for option in options_to_hide if store.country == 'BR' or not store.has_new_shipping or option.img_code != "branch" %}
                    {% include "snipplets/shipping/shipping-calculator-item.tpl" %}
                {% endfor %}
                </div>
        {% endif %}
    </ul>

    <div class="js-product-shipping-label font-small mt-3 pull-left" style="display: none;">
        <span class="js-shipping-filled-cart js-visible-on-cart-filled" {% if cart.items_count == 0 %}style="display:none;"{% endif%}>
            <i class="far fa-info-circle mr-1"></i><span>{{ 'El precio de envío incluye este producto y todos los que agregaste al carrito.' | translate }}</span>
        </span>
    </div>
{% else %}
<span>{{"No hay costos de envío para el código postal dado." | translate}}</span>
{% endif %}

{# Don't remove this #}
<input type="hidden" name="after_calculation" value="1"/>
<input type="hidden" name="zipcode" value="{{zipcode}}"/>
