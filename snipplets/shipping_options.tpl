{% if options %}

    {% if store.show_shipping_emergency_message %}
        <div class="alert alert-warning">{{ store.shipping_emergency_message }}</div> 
    {% endif %}

    <div class="{% if cart.items_count > 0 %}js-product-shipping-label{% endif %} font-small mb-4 pb-1" style="display: none;">
        {{ 'Opciones para tu compra <strong>si sumás este producto</strong>.' | translate }}
    </div>

    {# Check for only shipping featured options #}

    {% set has_featured_shipping = false %}

    {% for option in options_to_show if option.shipping_type == 'ship' or option.shipping_type == 'delivery' or (option.method == 'table' and option.shipping_type == 'custom') %}
        {% if option |length >= 1 %}
            {% set has_featured_shipping = true %}
        {% endif %}
    {% endfor %}

    {# Check for only non featured shipping options #}

    {% set has_non_featured_shipping = false %}

    {% for option in options_to_hide if option.shipping_type == 'ship' or option.shipping_type == 'delivery' or (option.method == 'table' and option.shipping_type == 'custom') %}
        {% if option |length >= 1 %}
            {% set has_non_featured_shipping = true %}
        {% endif %}
    {% endfor %}

    {# Pickup featured options #}

    {% set has_non_featured_pickup = false %}
    {% set has_featured_pickup = false %}

    {# Check for only pickup featured options #}

    {% for option in options_to_show if option.shipping_type == 'pickup' and option.method != 'branch' %}
        {% if option |length >= 1 %}
            {% set has_featured_pickup = true %}
        {% endif %}
    {% endfor %}

    {# Check for only non featured pickup options #}

    {% for option in options_to_hide if option.shipping_type == 'pickup' and option.method != 'branch' %}
        {% if option |length >= 1 %}
            {% set has_non_featured_pickup = true %}
        {% endif %}
    {% endfor %}

    {# Shipping options #}

    {% if has_featured_shipping %}

        <div class="full-width-container {% if has_featured_pickup %}mb-4{% endif %}">

            <div class="box-title mb-2">
                {{ "Envío a domicilio" | translate }}
            </div>

            <ul class="box radio-button-container p-0 mb-0 list-unstyled">

                {# Smart shipping hides similar shipping options on a toggle div and also shows an improved shipping item #}

                {# Check if smart shipping is needed #}

                {# Include branch options inside calculador #}

                {% for option in options_to_show if option.shipping_type == 'ship' or option.shipping_type == 'delivery' or (option.method == 'table' and option.shipping_type == 'custom') %}
                    {% include "snipplets/shipping/shipping-calculator-item.tpl" with {'featured_option': true} %}
                {% endfor %}

                {% if has_non_featured_shipping %}

                    <div class="js-other-shipping-options w-100 float-left shipping-extra-options" style="display: none;">

                        {# Smart shipping hides similar shipping options on a toggle div and also shows an improved shipping item #}

                        {# Check if smart shipping is needed #}

                        {# Include branch options inside calculador #}

                        {% for option in options_to_hide if option.shipping_type == 'ship' or option.shipping_type == 'delivery' or (option.method == 'table' and option.shipping_type == 'custom') %}
                            {% include "snipplets/shipping/shipping-calculator-item.tpl" %}
                        {% endfor %}
                    </div>
                    
                {% endif %}

            </ul>

            {% if has_non_featured_shipping %}
                <div class="js-toggle-more-shipping-options js-show-more-shipping-options w-100 float-left text-center mt-2">
                    <a href="#" class="btn-link">
                        <span class="js-shipping-see-more">
                            {{ 'Ver más opciones de envío' | translate }}
                        </span>
                        <span class="js-shipping-see-less" style="display: none;">
                            {{ 'Ver menos opciones de envío' | translate }}
                        </span>
                    </a>
                </div>
            {% endif %}

        </div>

    {% endif %}

    {# Pickup featured options #}

    {% if has_featured_pickup %}

        <div class="full-width-container mb-2">

            <div class="box-title mb-2">
                {{ "Retirar por" | translate }}
            </div>

            <ul class="list-unstyled box radio-button-container p-0 mb-0">

                {# Smart shipping hides similar shipping options on a toggle div and also shows an improved shipping item #}

                {# List only pickup featured options #}

                {# List only pickup featured options #}

                {% for option in options_to_show if option.shipping_type == 'pickup' and option.method != 'branch' %}
                    {% include "snipplets/shipping/shipping-calculator-item.tpl" with {'featured_option': true, 'pickup' : true} %}
                {% endfor %}

                {% if has_non_featured_pickup %}

                    <div class="js-other-pickup-options w-100 float-left shipping-extra-options" style="display: none;">

                        {# Smart shipping hides similar shipping options on a toggle div and also shows an improved shipping item #}

                        {# List only pickup featured options: same logic as for featured pickups but for non featured #}

                        {% for option in options_to_hide if option.shipping_type == 'pickup' and option.method != 'branch' %}
                            {% include "snipplets/shipping/shipping-calculator-item.tpl" with {'pickup' : true}  %}
                        {% endfor %}
                    </div>

                {% endif %}
            </ul>

            {% if has_non_featured_pickup %}
                <div class="js-toggle-more-shipping-options js-show-other-pickup-options w-100 float-left text-center mt-2">
                    <a href="#" class="btn-link">
                        <span class="js-shipping-see-more">
                            {{ 'Ver más opciones de retiro' | translate }}
                        </span>
                        <span class="js-shipping-see-less" style="display: none;">
                            {{ 'Ver menos opciones de retiro' | translate }}
                        </span>
                    </a>
                </div>
            {% endif %}
        </div>

    {% endif %}
    {% if store.has_smart_dates and show_time %}
        <div class="font-small float-left w-100 mb-3">{{"El tiempo de entrega <strong>no considera feriados</strong>." | translate}}</div>
    {% endif %}

{% else %}
<span>{{"No hay costos de envío para el código postal dado." | translate}}</span>
{% endif %}

{# Don't remove this #}
<input type="hidden" name="after_calculation" value="1"/>
<input type="hidden" name="zipcode" value="{{zipcode}}"/>
