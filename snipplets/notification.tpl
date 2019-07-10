{# Order notification #}

{% if order_notification and status_page_url %}
    <div data-url="{{ status_page_url }}" class="js-notification notification notification-secondary" style="display:none;">
        <div class="container">
            <div class="row">
                <div class="col">
                    <span>{{ "Seguí acá" | translate | a_tag(status_page_url) }}</span> <span class="btn btn-link">{{ "tu última compra" | translate }}</span>
                    <a class="js-notification-close ml-2" href="#"><i class="far fa-times"></i></a>
                </div>
            </div>
        </div>
    </div>
{% endif %}

{# Add to cart notification #}

{% if add_to_cart %}
    <div class="js-alert-added-to-cart notification-floating notification-hidden" style="display: none;">
        <div class="js-toggle-cart notification notification-primary"> 
            <i class="far fa-shopping-cart"></i>
            <span>{{ '¡Excelente! Ya agregamos tu producto al carrito.' | translate }}</span>
        </div>
    </div>
{% endif %}