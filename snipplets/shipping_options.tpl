{% if options %}
    <div class="{% if cart.items_count > 0 %}js-product-shipping-label{% endif %} font-small mb-4 pb-1" style="display: none;">
        {{ 'Opciones para tu compra <strong>si sumás este producto</strong>.' | translate }}
    </div>
    <ul class="list-unstyled">

        {# Smart shipping hides similar shipping options on a toggle div and also shows an improved shipping item #}

        {# Check if smart shipping is needed #}

        {% set has_options_to_hide = false %}

        {% for option in options_to_hide %}
            {% if options_to_hide|length >= 1 %}
                {% set has_options_to_hide = true %}
            {% endif %}
        {% endfor %}

        {% for option in options_to_show if option.method != "branch" %}
            {% include "snipplets/shipping/shipping-calculator-item.tpl" with {'featured_option': true} %}
        {% endfor %}

        {% if has_options_to_hide %}
            <div class="js-show-more-shipping-options d-inline-block w-100 mt-3 text-center">
                <a href="#" class="btn-link">
                    <span class="js-shipping-see-more">
                        {{ 'Ver más opciones' | translate }}
                        {% include "snipplets/svg/chevron-down.tpl" with {svg_custom_class: "icon-inline ml-1"} %}
                    </span>
                    <span class="js-shipping-see-less" style="display: none;">{{ 'Ver menos opciones' | translate }}
                        {% include "snipplets/svg/chevron-up.tpl" with {svg_custom_class: "icon-inline ml-1"} %}
                    </span>
                </a>
            </div>
            <div class="js-other-shipping-option w-100 mt-3" style="display: none;">
                {% for option in options_to_hide if option.method != "branch" %}
                    {% include "snipplets/shipping/shipping-calculator-item.tpl" %}
                {% endfor %}
                </div>
        {% endif %}
    </ul>

    {% if store.has_smart_dates and show_time %}
        <div class="font-small float-left w-100 my-3">{{"El tiempo de entrega <strong>no considera feriados</strong>." | translate}}</div>
    {% endif %}
{% else %}
<span>{{"No hay costos de envío para el código postal dado." | translate}}</span>
{% endif %}

{# Don't remove this #}
<input type="hidden" name="after_calculation" value="1"/>
<input type="hidden" name="zipcode" value="{{zipcode}}"/>
