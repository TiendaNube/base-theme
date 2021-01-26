{% embed "snipplets/page-header.tpl" %}
    {% block page_header_text %}{{ 'Orden {1}' | translate(order.number) }}{% endblock page_header_text %}
{% endembed %}

<section class="account-page">
    <div class="container" data-store="account-order-detail-{{ order.id }}">
    	<div class="row pt-3">
            <div class="col-md-4 text-center">
                {% if log_entry %}
                    <h4 class="h5 mb-3">{{ 'Estado actual del envío' | translate }}:</h4>{{ log_entry }}
                {% endif %}
                <h4 class="h5 mb-3">{{ 'Detalles' | translate }}</h4>
                <hr class="divider my-3">
                <p class="mb-5">
                    <span class="d-block">
                        <strong>{{'Fecha' | translate}}:</strong> {{ order.date | i18n_date('%d/%m/%Y') }}
                    </span>
                    <span class="d-block">
                        <strong>{{'Estado' | translate}}:</strong> {{ (order.status == 'open'? 'Abierta' : (order.status == 'closed'? 'Cerrada' : 'Cancelada')) | translate }}
                    </span>
                    <span class="d-block">
                        <strong>{{'Pago' | translate}}:</strong> {{ (order.payment_status == 'pending'? 'Pendiente' : (order.payment_status == 'authorized'? 'Autorizado' : (order.payment_status == 'paid'? 'Pagado' : (order.payment_status == 'voided'? 'Cancelado' : (order.payment_status == 'refunded'? 'Reintegrado' : 'Abandonado'))))) | translate }}
                    </span>
                    <span class="d-block">
                        <strong>{{'Medio de pago' | translate}}:</strong> {{ order.payment_name }}
                    </span>
                    {% if order.address %}
                        <span class="d-block">
                            <strong>{{'Envío' | translate}}:</strong> {{ (order.shipping_status == 'fulfilled'? 'Enviado' : 'No enviado') | translate }}
                        </span>
                        <span class="d-block">
                            <strong>{{ 'Dirección de envío' | translate }}:</strong>
                            <span class="d-block">
                                {{ order.address | format_address }}
                            </span>
                        </span>
                    {% endif %}
                </p>
            </div>
            <div class="col-md-8">
                <h4 class="h5 mb-3 text-center">{{ 'Productos' | translate }}</h4>
                <hr class="divider my-3 d-none d-md-block">
                <div class="order-detail">
                    {% embed "snipplets/card.tpl" %}
                        {% block card_head %}
                            <div class="d-none d-md-block">
                                <div class="row">
                                    <div class="col-md-7">
                                        {{ 'Producto' | translate }}
                                    </div>
                                    <div class="col-md-5">
                                        <div class="row">
                                            <div class="col-4 text-center">
                                                {{ 'Precio' | translate }}
                                            </div>
                                            <div class="col-4 text-center">
                                                {{ 'Cantidad' | translate }}
                                            </div>
                                            <div class="col-4 text-center">
                                                {{ 'Total' | translate }}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        {% endblock %}
                        {% block card_body %}
                            {% for item in order.items %}
                                <div class="row align-items-center{% if not loop.last %} pb-3{% endif %}">
                                    <div class="col-5 col-md-2">
                                        <div class="card-img-square-container">
                                            {{ item.featured_image | product_image_url("small") | img_tag(item.featured_image.alt, {class: 'card-img-square'}) }}
                                        </div>
                                    </div>
                                    <div class="col-7 col-md-10">
                                        <div class="row align-items-center">
                                            <div class="col-12 col-md-6">
                                                <p>
                                                    <strong>{{ item.name }}</strong> <span class="d-inline-block d-md-none">x{{ item.quantity }}</span>
                                                </p>
                                            </div>
                                            <div class="col-md-2 d-none d-md-block text-md-center">
                                                <p>
                                                    {{ item.unit_price | money }}
                                                </p>
                                            </div>
                                            <div class="col-md-2 d-none d-md-block text-md-center">
                                                <p>
                                                    {{ item.quantity }}
                                                </p>
                                            </div>
                                            <div class="col-12 col-md-2 text-md-center">
                                                <p>
                                                    {{ item.subtotal | money }}
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                            
                                </div>
                            {% endfor %}
                        {% endblock %}
                    {% endembed %}
                    <div class="row justify-content-md-end">
                        <div class="col-12 col-md-auto">
                            {% if order.shipping or order.discount %}
                                <div class="row no-gutters justify-content-end justify-content-md-center h5 mt-2">
                                    <span class="col col-md-auto mr-1">{{ 'Subtotal' | translate }}:</span> 
                                    <span class="col col-md-auto text-right">{{ order.subtotal | money }}</span>
                                </div>
                            {% endif %}
                            {% if order.show_shipping_price %}
                                <div class="row no-gutters justify-content-end justify-content-md-center mt-2">
                                    <span class="col col-md-auto mr-1">
                                        {{ 'Costo de envío ({1})' | translate(order.shipping_name) }}:
                                    </span>
                                    <span class="col col-md-auto text-right">
                                        {% if order.shipping == 0  %}
                                            {{ 'Gratis' | translate }}
                                        {% else %}
                                            {{ order.shipping | money }}
                                        {% endif %}
                                    </span>
                                </div>
                            {% else %}
                                <div class="row no-gutters justify-content-end justify-content-md-center mt-2">
                                    <span class="col col-md-auto mr-1">{{ 'Costo de envío ({1})' | translate(order.shipping_name) }}:</span>
                                    <span class="col col-md-auto text-right">{{ 'A convenir' | translate }}</span>
                                </div>
                            {% endif %}
                            {% if order.discount %}
                                <div class="row no-gutters justify-content-end justify-content-md-center mt-2">
                                    <span class="col col-md-auto mr-1">{{ 'Descuento ({1})' | translate(order.coupon) }}:</span>
                                    <span class="col col-md-auto text-right">- {{ order.discount | money }}</span>
                                </div>
                            {% endif %}
                            <div class="row no-gutters justify-content-end justify-content-md-center h3 mt-2">
                                <span class="col col-md-auto mr-1">{{ 'Total' | translate }}:</span>
                                <span class="col col-md-auto text-right">{{ order.total | money }}</span>
                            </div>
                            {% if order.pending %}
                                <a class="btn btn-primary btn-block mt-3 px-md-5" href="{{ order.checkout_url | add_param('ref', 'orders_details') }}" target="_blank">{{ 'Realizar pago' | translate }}</a>
                            {% endif %}
                        </div>
                    </div>
                </div>
            </div>
    	</div>
    </div>
</section>