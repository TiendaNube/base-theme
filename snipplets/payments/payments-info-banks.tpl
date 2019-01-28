{% set gateways = installmentsv2['methods'][method] %}

{# Gateways with banks #}

{# Credit cards #}
{% if gateways.cc is not null %}
  <h6 class="mb-1">{{'Tarjetas de crédito' | translate }}</h6>
  <div class="box">
    {# Installments without interest modules by groups, E.g: 3, 6, 9, 12 #}

    {% if gateways.cc is null or gateways.cc is empty is not null %}
      {% for installment, banks in gateways.cc.no_interest %}
        <div>

          {# Installment amount, cost, CFT, 1 payment info and total cost #}

          <h4 class="font-weight-normal mb-1">
            {{ installment }}
            {{ 'cuotas' | translate }}
            <span>{{ 'sin interés' | t }}</span>
            {{'de' | t}}
            <strong class="js-modal-installment-price" data-installment="{{installment}}"> {{ (product.price / installment) | money }}</strong>
          </h4>
          <h6 class="font-weight-normal mb-2">
            <span class="mr-1">
              <span>{{ 'CFT: ' | translate }}</span><strong>0,00%</strong>
            </span>
            <span class="mr-1">
              <span>{{ 'Total: ' | translate }}</span><strong class="js-installments-one-payment">{{ product.price | money }}</strong>
            </span>
            <span>
              <span>{{ 'En 1 pago: ' | translate }}</span><strong class="js-installments-one-payment">{{ product.price | money }}</strong>
            </span>
          </h6>

          {# Banks with installments without interest flags #}

          <div class="mb-3">
            {% for bank in banks %}
              <span>
                <img src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ bank | bank_code_by_name | payment_new_logo }}" class="card-img card-img-big lazyload" alt="{{ bank }}">
              </span>
            {% endfor %}
          </div>
          <div class="divider"></div>
        </div>
      {% endfor %}
    {% endif %}

    {# Installments with interest in one module #}

    {% if gateways.cc.interest is not null %}
      <div>

        {# Installment amount #}

        <h4 class="font-weight-normal mb-1">
          {{ gateways.max_with_interests ~ ' cuotas con otras tarjetas' | translate }}
        </h4>
        <h6 class="font-weight-normal mb-2">
          <span>{{ 'O en 1 pago de: ' | translate }}</span>
          <strong class="js-installments-one-payment">{{ product.price | money }}</strong>
        </h6>

        {# Banks with installments with interest flags #}

        {% for bank in gateways.cc.interest %}
          <span class="js-installments-flag-tab js-installments-cash-tab">
            <img src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ bank | bank_code_by_name | payment_new_logo }}" class="lazyload card-img card-img-big" alt="{{ bank }}">
          </span>
        {% endfor %}
        <div class="divider"></div>
      </div>
    {% endif %}
  </div>
{% endif %}

{# Cash methods #}

{% if gateways.debit is not null or gateways.cash is not null or gateways.transfer is not null %}
  <h6 class="mb-1">{{'Tarjeta de débito y efectivo' | translate }}</h6>
  <div class="box">

    {# Debit card #}

    {% if gateways.debit is not null %}

      {# Debit price #}

      <h4 class="font-weight-normal mb-1">{{ 'Débito' | translate }}</h4>
      <h6 class="font-weight-normal mb-2">
        <span>{{ 'Precio:' | translate }} </span><strong class="js-installments-one-payment"> {{ product.price | money }}</strong>
      </h6>

      {# Debit flags #}

      {% for logo in gateways.debit %}
        <span data-type="dd" data-code="{{ card }}">
          <img src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ logo | payment_new_logo }}" class="lazyload card-img card-img-big">
        </span>
      {% endfor %}

      <div class="divider"></div>

    {% endif %}

    {# Cash #}

    {% if gateways.cash is not null %}

      {# Cash price #}

      <h4 class="font-weight-normal mb-1">{{'Efectivo' | translate }}</h4>
      <h6 class="font-weight-normal mb-2">
        <span>{{ 'Precio:' | translate }} </span><strong class="js-installments-one-payment"> {{ product.price | money }}</strong>
      </h6>

      {# Cash flags #}

      {% for logo in gateways.cash %}
        <span data-type="dd" data-code="{{ card }}">
          <img src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ logo | payment_new_logo }}" class="lazyload card-img card-img-big">
        </span>
      {% endfor %}

      <div class="divider"></div>

    {% endif %}

    {# Wire transfer #}

    {% if gateways.transfer is not null %}

      {# Transfer price #}

      <h4 class="font-weight-normal mb-1 ">{{ 'Transferencia o déposito' | translate }}</h4>
      <h6 class="font-weight-normal mb-2">
        <span>{{ 'Precio:' | translate }} </span><span class="js-installments-one-payment"> {{ product.price | money }}</span>
      </h6>

      {# Transfer logos #}

      {% for logo in gateways.transfer %}
        <span class="js-installments-flag-tab js-installments-cash-tab" data-type="dd" data-code="{{ card }}">
          <img src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ logo | payment_new_logo }}" class="lazyload card-img card-img-big">
        </span>
      {% endfor %}

      <div class="divider"></div>

    {% endif %}
  </div>
{% endif %}
