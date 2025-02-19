{% set notification_without_recommendations_classes = 'js-alert-added-to-cart notification-floating notification-hidden' %}
{% set notification_wrapper_classes = 
    related_products ? 'row' 
    : not related_products and add_to_cart_fixed ? notification_without_recommendations_classes ~ ' notification-fixed-bottom-right mb-md-2 mr-md-2' 
    : notification_without_recommendations_classes 
%}

<div class="{{ notification_wrapper_classes }}" {% if not related_products %}style="display: none;"{% endif %}>
    <div class="{% if related_products %}col-md-6{% else %}notification notification-primary position-relative {% if not add_to_cart_mobile %}col-12 float-right{% endif %}{% endif %}">
        {% if not related_products %}
            <div class="h6 text-center mb-3 mr-3">
                <strong>{{ '¡Ya agregamos tu producto al carrito!' | translate }}</strong>
            </div>
            <div class="js-cart-notification-close notification-close">
                {% include "snipplets/svg/times.tpl" with {svg_custom_class: "icon-inline svg-icon-primary"} %}
            </div>
        {% endif %}
        <div class="js-cart-notification-item row{% if related_products %} align-items-center{% endif %}" data-store="cart-notification-item">
            <div class="{% if related_products %}col-md-3 col-2{% else %}col-3{% endif %} pr-0 notification-img">
                <img src="" class="js-cart-notification-item-img img-fluid" />
            </div>
            <div class="{% if related_products %}col-md-9 col-10{% else %}col-9{% endif %} text-left">
                <div class="mb-1">
                    <span class="js-cart-notification-item-name"></span>
                    <span class="js-cart-notification-item-variant-container" style="display: none;">
                        (<span class="js-cart-notification-item-variant"></span>)
                    </span>
                </div>
                <div class="mb-1">
                    <span class="js-cart-notification-item-quantity"></span>
                    <span> x </span>
                    <span class="js-cart-notification-item-price"></span>
                </div>
            </div>
        </div>
    {% if related_products %}
        </div>
        <div class="col-md-6">
    {% endif %}
        <div class="row text-primary h5 font-weight-normal mt-2 mb-3{% if related_products %} mt-md-0{% endif %}">
            <span class="col-auto text-left">
                <strong>{{ "Total" | translate }}</strong> 
                (<span class="js-cart-widget-amount">
                    {{ "{1}" | translate(cart.items_count ) }} 
                </span>
                <span class="js-cart-counts-plural" style="display: none;">
                    {{ 'productos' | translate }}):
                </span>
                <span class="js-cart-counts-singular" style="display: none;">
                    {{ 'producto' | translate }}):
                </span>
            </span>
            <strong class="js-cart-total col text-right">{{ cart.total | money }}</strong>
        </div>
        <a href="#" class="{% if related_products %}js-modal-close{% else %}js-cart-notification-close{% endif %} js-modal-open js-fullscreen-modal-open btn btn-primary btn-medium w-100 d-inline-block" data-toggle="#modal-cart" data-modal-url="modal-fullscreen-cart">
            {{ 'Ver carrito' | translate }}
        </a>
    </div>
</div>