{% set installments_data = installmentsv2['methods'][method] %}

{# Gateways without banks: cards only #}

{% if installments_data['cards'] %}

    {# Credit cards #}

    <h6 class="mb-1">{{'Tarjetas de crédito' | translate }}</h6>
    <div id="installment-credit-card-option-{{ method }}" class="box">

        {# Credit cards max installments only for AR stores #}

        {% if store.country == 'AR' %}

            {% if installments_data['max_without_interests'] != '0' %}
                <h4 class="font-weight-normal mb-1">
                    {{ installments_data['max_without_interests'] }}
                    {{ 'cuotas' | translate }}
                    <span>{{ 'sin interés' | t }}</span>
                    {{'de' | t}}
                    <strong class="js-modal-installment-price" data-installment="{{ installments_data['max_without_interests'] }}"> {{ (product.price / installments_data['max_without_interests']) | money }}</strong>
                </h4>
                <h6 class="font-weight-normal mb-2">
                    <span class="mr-1">
                        <span>{{ 'CFT: ' | translate }}</span><strong>0,00%</strong>
                    </span>
                    <span class="mr-1">
                        <span>{{ 'Total: ' | translate }}</span><strong class="js-installments-one-payment">{{ product.price | money }}</strong>
                    </span>
                    <span class="mr-1">
                        <span>{{ 'En 1 pago: ' | translate }}</span><strong class="js-installments-one-payment">{{ product.price | money }}</strong>
                    </span>
                </h6>
            {% elseif installments_data['max_with_interests'] > 0 %}
                <h4 class="font-weight-normal mb-1">
                    {{ 'Hasta' | translate }}
                    {{ installments_data['max_with_interests'] }}
                    {{ 'cuotas' | translate }}
                </h4>
                <h6 class="font-weight-normal mb-2">
                    <span>
                        <span>{{ 'O en 1 pago de: ' | translate }}</span><strong class="js-installments-one-payment">{{ product.price | money }}</strong>
                    </span>
                </h6>
            {% else %}
                <h4 class="font-weight-normal mb-1">
                    <span>{{ 'En 1 pago: ' | translate }}</span><strong class="js-installments-one-payment">{{ product.price | money }}</strong>
                </h4>
            {% endif %}

        {% endif %}

        {# Credit cards flags #}

        {% for logo in installments_data['cards'] %}
            <span class="mb-3">
                <img src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ logo | payment_new_logo }}" class="lazyload card-img card-img-medium">
            </span>
        {% endfor %}

        {% if store.country != 'AR' %}

            {# Installments list for non AR stores #}

            <table class="table">
                <thead>
                    <tr>
                        <th colspan="2">{{ 'Cuotas ' | translate }}</th>
                        <th class="text-right">{{ 'Total' | translate }}</th>
                    </tr>
                </thead>
                <tbody>
                    {% for installment, data_installment in installments %}
                        {% set rounded_installment_value = data_installment.installment_value | round(2) %}
                        {% set total_value = (data_installment.without_interests ? data_installment.total_value : installment * data_installment.installment_value) %}
                        {% set total_value_in_cents = total_value  | round(2) * 100 %}
                        <tr id="installment_{{ method }}_{{ installment }}">

                            {# Installment amount #}

                            <td>
                                <strong><span class="js-installment-amount">{{ installment }}</span></strong>
                                </span>{% if installment > 1 %}{{ 'cuotas' | translate }}{% else %}{{ 'cuota' | translate }}{% endif %}</span>
                            </td>

                            {# Installment price #}

                            <td>
                                <span>{{ 'de ' | translate }}</span>
                                <strong><span class="js-installment-price">{{ (rounded_installment_value * 100) | money }}</span> </strong>

                                {% if data_installment.without_interests or installments_data['max_with_interests'] == 0 %}
                                    {{ 'sin interés' | t }}
                                {% endif %}
                            </td>

                            {# Total price #}

                            <td class="js-installment-total-price text-right">
                                {{ total_value_in_cents | money }}
                            </td>
                        </tr>
                    {% endfor %}
                </tbody>
            </table>
        {% endif %}
    </div>
{% endif %}

{# Cash methods #}

{% if installments_data['direct'] %}

    {# Cash module title #}

    <h6 class="mb-1">
        {% if store.country == 'BR' %}
            {% if wording_method_only_cash %}
                {{'Efectivo' | translate }}
            {% elseif wording_method_only_debit %}
                {{'Débito online' | translate }}
            {% else %}
                {{'Efectivo / Débito online' | translate }}
            {% endif %}
        {% else %}
            {{'Tarjeta de débito y efectivo' | translate }}
        {% endif %}
    </h6>

    {# If has debit card or cash #}

    <div id="installment-cash-option-{{ method }}" class="box">

        {# Cash flags #}

        <div class="">
            {% for logo in installments_data['direct'] %}
                <span>
                    <img src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ logo | payment_new_logo }}" class="lazyload card-img card-img-medium">
                </span>
            {% endfor %}

        </div>

        {# Boleto message #}

        {% if method in ['boleto_paghiper'] and discount > 0.0 %}
            {% set price_with_boleto_discount = product.price - ((product.price * discount) / 100) %}
            <div class="my-1"> {{'Boleto Paghiper tiene un' | translate }} <strong>{{discount}}% {{'de descuento' | translate }}</strong></div>

            <h4 class="font-weight-normal mb-3">
                <span>{{ 'Total:' | translate }}</span>
                <span class="price-compare">{{ product.price | money }}</span><strong class="js-installments-one-payment">{{ price_with_boleto_discount | money }}</strong> 
            </h4>

            <div class="font-small">{{'El descuento será aplicado sobre el costo total de la compra (sin envío) al finalizar la misma.' | translate }}</div>

        {% else %}

            {# Cash total #}

            <h4 class="font-weight-normal mb-0">
                <span>{{ 'Total:' | translate }}</span><strong class="js-installments-one-payment">{{ product.price | money }}</strong>
            </h4>

        {% endif %}

    </div>
{% endif %}
