{% set installments_info_base_variant = product.installments_info %}
{% set installments_info = product.installments_info_from_any_variant %}
{% if installments_info %}
{% set gateways = installments_info | length %}
{% set store_set_for_new_installments_view = store.is_set_for_new_installments_view %}
{# Get the array that contains the display settings for each payment method #}
{% set payment_methods_config = product.payment_methods_config %}

    {% embed "snipplets/modal.tpl" with{modal_id: 'installments-modal', modal_position: 'bottom', modal_transition: 'slide', modal_header: true, modal_footer: true, modal_width: 'centered', modal_mobile_full_screen: 'true'} %}
        {% block modal_head %}
            {{'Medios de pago' | translate }}
        {% endblock %}
        {% block modal_body %}

            {# Modal header and gateways tab links #}

            <div class="js-tab-container">
                <ul class="js-tab-group tab-group">
                    {% for method, installments in installments_info %}
                        {% set method_clean = method | replace(" ", "_") | lower %}

                        <li id="method_{{ method_clean }}" class="js-refresh-installment-data js-installments-gw-tab js-tab tab {% if loop.first %} active {% endif %}" data-code="{{ method }}">
                            <a href="#installment_{{ method_clean }}_{{ installment }}" class="js-tab-link tab-link">{{ method == 'paypal_multiple' ? 'PAYPAL' : (method == 'itaushopline'? 'ITAU SHOPLINE' : method == 'boleto_paghiper'? 'BOLETO PAGHIPER' : method | upper) }}</a>
                        </li>

                        {# Custom payment method #}

                        {% if loop.last and custom_payment is not null %}
                            <li id="method_{{ custom_payment.code }}" class="js-refresh-installment-data js-installments-gw-tab js-tab tab" data-code="{{ custom_payment.code }}">
                                <a href="#installment_{{ custom_payment.code }}" class="js-tab-link tab-link">
                                    {{ custom_payment.name | upper }}
                                    {% if custom_payment.discount > 0 %}
                                        <span class="label label-accent ml-1"><strong>{{ custom_payment.discount }}% {{'OFF' | translate }}</strong></span>
                                    {% endif %}
                                </a>
                            </li>
                        {% endif %}
                    {% endfor %}
                </ul>

                {# Gateways tab content #}

                <div class="js-tabs-content tab-content">
                    {% for method, installments in installments_info %}
                        {% set method_clean = method | replace(" ", "_") | lower %}
                        {% set discount = product.get_gateway_discount(method) %}
                        <div id="installment_{{ method_clean }}_" class="js-tab-panel tab-panel {% if loop.first %} active {% endif %} js-gw-tab-pane">
                            <div>

                                {% if store_set_for_new_installments_view %}

                                    {# Payments info with readonly #}

                                    {# Evaluate whether the payment method should show complete installments data #}
                                    
                                    {% if payment_methods_config[method].show_full_installments %}

                                        {# Payments Gateways with banks: at the moment only MP AR #}

                                        {% include 'snipplets/payments/payments-info-banks.tpl' %}
                                    {% else %}

                                        {# Payments Gateways with cards only #}

                                        {% include 'snipplets/payments/payments-info.tpl' %}
                                    {% endif %}    

                                {% else %}

                                    {# Installments list for ROLA stores #}

                                    {% for installment, data_installment in installments %}
                                        <div id="installment_{{ method }}_{{ installment }}">
                                            {% set rounded_installment_value = data_installment.installment_value | round(2) %}
                                            {% set total_value = (data_installment.without_interests ? data_installment.total_value : installment * data_installment.installment_value) %}
                                            {% set total_value_in_cents = total_value  | round(2) * 100 %}
                                            <strong class="js-installment-amount">{{ installment }}</strong> {% if store.country != 'BR' %}cuota{% if installment > 1 %}s{% endif %} de{% else %}x{% endif %} <strong class="js-installment-price">{{ (rounded_installment_value * 100) | money }}</strong>
                                            {% if data_installment.without_interests %} {{ 'sin interés' | t }}{% endif %}
                                        </div>
                                    {% endfor %}

                                {% endif %}
                            </div>
                        </div>

                        {# Custom payment method #}

                        {% if loop.last and custom_payment is not null %}
                            <div class="js-tab-panel tab-panel js-gw-tab-pane" id="installment_{{ custom_payment.code }}">
                                <div class="box">

                                    {# Custom method instructions #}

                                    <h6 class="mb-2">{{ 'Cuando termines la compra vas a ver la información de pago en relación a esta opción.' | translate }}</h6>

                                    {% if custom_payment.discount > 0 %}
                                        <div class="mb-1">
                                            <span><strong>{{ custom_payment.discount }}% {{'de descuento' | translate }}</strong> {{'pagando con' | translate }} {{ custom_payment.name }}</span>
                                        </div>
                                    {% endif %}

                                    {# Price total #}

                                    <h4 class="mb-1 font-weight-normal">
                                        <span>{{ 'Total:' | translate }}</span>
                                        {% if custom_payment.discount > 0 %}
                                            {% set price_with_discount = product.price - ((product.price * custom_payment.discount) / 100) %}
                                            <span class="price-compare">{{ product.price | money }}</span>
                                            <strong class="js-installments-one-payment h3 text-brand">{{ price_with_discount | money }}</strong> 
                                        {% else %} 
                                            <strong class="js-installments-one-payment ml-3">{{ product.price | money }}</strong>
                                        {% endif %}
                                    </h4>

                                    {% if custom_payment.discount > 0 %}
                                        <div class="mt-3">{{'El descuento será aplicado sobre el costo total de la compra (sin envío) al finalizar la misma.' | translate }}</div>
                                    {% endif %}
                                
                                </div>
                            </div>
                        {% endif %}
                    {% endfor %}
                </div>
            </div>
            
        {% endblock %}
        {% block modal_foot %}
            <div class="text-right">
                <span class="js-modal-close js-fullscreen-modal-close btn-link pull-right">{{ 'Volver al producto' | translate }}</span>
            </div>
        {% endblock %}
    {% endembed %}

{% endif %}


