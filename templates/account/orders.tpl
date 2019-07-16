{% embed "snipplets/page-header.tpl" %}
    {% block page_header_text %}{{ "Mi cuenta" | translate }}{% endblock page_header_text %}
{% endembed %}

<section class="account-page">
    <div class="container">
        <div class="row">
            <div class="col-md-4">
                <h4>{{ 'Datos Personales' | translate }}</h4>
                <p>
                    <img src="https://www.gravatar.com/avatar/{{ customer.email | lower | md5 }}?s=80&d=mm" height="80" width="80">
                </p>
                <p>
                    <strong>
                        {{customer.name}}
                    </strong>
                    <span class="d-block">
                        {{customer.email}}
                    </span>
                    {% if customer.cpf_cnpj %}
                    <span class="d-block">
                        {{ 'CPF / CNPJ' | translate }}: {{ customer.cpf_cnpj | format_cpf_cnpj }}
                    </span>
                    {% endif %}
                    {% if customer.phone %}
                    <span class="d-block">
                        {{ 'Teléfono' | translate }}: {{ customer.phone }}
                    </span>
                    {% endif %}
                    <span class="d-block">
                        {{ 'Editar mis datos' | translate | a_tag(store.customer_info_url, '', 'btn-link') }}
                    </span>
                </p>
                {% if customer.default_address %}
                    <p>
                        <span class="d-block">
                            {{ customer.default_address | format_address_short }}
                        </span>
                        {{ 'Editar mis direcciones' | translate | a_tag(store.customer_addresses_url, '', 'btn-link') }}
                    </p>
                {% endif %}
            </div>
            <div class="col-md-8">
                <h4>{{ 'Mis Órdenes' | translate }}</h4>
                <div class="row">
                    {% for order in customer.orders %}
                        {% set add_checkout_link = order.pending %}
                        <div class="col-md-6">
                            {% embed "snipplets/card.tpl" with{card_footer: true} %}
                                {% block card_head %}
                                    <div class="row">
                                        <div class="col">
                                            <h4 class="m-0">
                                                <strong>{{'Orden' | translate}}:  <a class="btn-link" href="{{ store.customer_order_url(order) }}">#{{order.number}} </a></strong>
                                            </h4>
                                        </div>
                                        <div class="col text-right">
                                            <p class="m-0"><small>{{ order.date | i18n_date('%d/%m/%Y') }}</small></p>
                                        </div>
                                    </div>
                                {% endblock %}
                                {% block card_body %}
                                    <p>
                                        {% include "snipplets/svg/info-circle.tpl" with {svg_custom_class: "icon-inline svg-icon-text mr-1"} %}
                                        <strong>{{'Estado' | translate}}:</strong> {{ (order.status == 'open'? 'Abierta' : (order.status == 'closed'? 'Cerrada' : 'Cancelada')) | translate }}
                                    </p>
                                    <p>
                                        {% include "snipplets/svg/credit-card-blank.tpl" with {svg_custom_class: "icon-inline svg-icon-text mr-1"} %}
                                        <strong>{{'Pago' | translate}}: </strong><span class="{{ order.payment_status }}">{{ (order.payment_status == 'pending'? 'Pendiente' : (order.payment_status == 'authorized'? 'Autorizado' : (order.payment_status == 'paid'? 'Pagado' : (order.payment_status == 'voided'? 'Cancelado' : (order.payment_status == 'refunded'? 'Reintegrado' : 'Abandonado'))))) | translate }}</span>
                                    </p>
                                    <p>
                                        {% include "snipplets/svg/truck.tpl" with {svg_custom_class: "icon-inline svg-icon-text mr-1"} %}
                                        <strong>{{'Envío' | translate}}:</strong> {{ (order.shipping_status == 'fulfilled'? 'Enviado' : 'No enviado') | translate }}
                                    </p>
                                    <h4 class="m-0 mt-4">
                                        <strong>{{'Total' | translate}}</strong> {{ order.total | money }}
                                    </h4>
                                {% endblock %}
                                {% block card_foot %}
                                    {% if add_checkout_link %}
                                        <a class="btn btn-primary d-block" href="{{ order.checkout_url | add_param('ref', 'orders_list') }}" target="_blank">{{'Realizar el pago >' | translate}}</a>
                                    {% elseif order.order_status_url != null %}
                                        <a class="btn btn-primary d-block" href="{{ order.order_status_url | add_param('ref', 'orders_list') }}" target="_blank">{% if 'Correios' in order.shipping_name %}{{'Seguí la entrega' | translate}}{% else %}{{'Seguí tu orden' | translate}}{% endif %}</a>
                                    {% endif %}
                                {% endblock %}
                            {% endembed %}
                        </div>
                    {% endfor %}
                </div>
                <table class="table hidden">
                    <thead>
                        <tr>
                            <th>{{'Orden' | translate}}</th>
                            <th>{{'Fecha' | translate}}</th>
                            <th>{{'Estado' | translate}}</th>
                            <th>{{'Pago' | translate}}</th>
                            <th>{{'Envío' | translate}}</th>
                            <th>{{'Total' | translate}}</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        {% for order in customer.orders %}
    	                    {% set add_checkout_link = order.pending %}
    	                    <tr class="{% if order.status == 'open' %}warning{% elseif order.status == 'closed' %}success{% elseif order.status == 'cancelled' %}danger{% endif %}">
    	                        <td data-label="{{'Orden' | translate}}"><a href="{{ store.customer_order_url(order) }}">#{{order.number}}</a></td>
    	                        <td data-label="{{'Fecha' | translate}}">{{ order.date | i18n_date('%d/%m/%Y') }}</td>
    	                        <td data-label="{{'Estado' | translate}}">{{ (order.status == 'open'? 'Abierta' : (order.status == 'closed'? 'Cerrada' : 'Cancelada')) | translate }}</td>
    	                        <td data-label="{{'Pago' | translate}}">{{ (order.payment_status == 'pending'? 'Pendiente' : (order.payment_status == 'authorized'? 'Autorizado' : (order.payment_status == 'paid'? 'Pagado' : (order.payment_status == 'voided'? 'Cancelado' : (order.payment_status == 'refunded'? 'Reintegrado' : 'Abandonado'))))) | translate }}</td>
    	                        <td data-label="{{'Envío' | translate}}">{{ (order.shipping_status == 'fulfilled'? 'Enviado' : 'No enviado') | translate }}</td>
    	                        <td data-label="{{'Total' | translate}}">{{ order.total | money }}</td>
    	                        {% if add_checkout_link %}
    	                            <td><a href="{{ order.checkout_url | add_param('ref', 'orders_list') }}" class="btn-link" target="_blank">{{'Realizar el pago >' | translate}}</a></td>
    	                        {% elseif order.order_status_url != null %}
    	                            <td><a href="{{ order.order_status_url | add_param('ref', 'orders_list') }}" target="_blank">{% if 'Correios' in order.shipping_name %}{{'Seguí la entrega' | translate}}{% else %}{{'Seguí tu orden' | translate}}{% endif %}</a></td>
    	                        {% endif %}
    	                    </tr>
                        {% endfor %}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>