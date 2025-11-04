{# Cookie validation #}

{% if show_cookie_banner and not params.preview %}
    <div class="js-notification js-notification-cookie-banner notification notification-fixed-bottom notification-above notification-secondary" style="display: none;">
        <div class="container text-center text-md-left">
            <div class="row align-items-md-center">
                <div class="col-12 col-md-7 offset-md-2 mb-3 mb-md-0 text-foreground">
                    {{ 'Al navegar por este sitio <strong>aceptás el uso de cookies</strong> para agilizar tu experiencia de compra.' | translate }}
                </div>
                <div class="col-md-auto">
                    <a href="#" class="js-notification-close js-acknowledge-cookies btn btn-primary btn-medium px-4 py-2 d-inline-block">{{ "Entendido" | translate }}</a>
                </div>
            </div>
        </div>
    </div>
{% endif %}

{# Order notification #}

{% if order_notification and status_page_url_notification %}
    <div class="js-notification js-notification-status-page notification notification-secondary" data-url="{{ status_page_url_notification }}" style="display:none;">
        <div class="container">
            <div class="row">
                <div class="col">
                    <a class="btn" href="{{ status_page_url_notification }}"><strong>{{ "Seguí acá" | translate }}</strong> {{ "tu última compra" | translate }}</a>
                    <a class="js-notification-close js-notification-status-page-close ml-3" href="#">
                        {% include "snipplets/svg/times.tpl" with {svg_custom_class: "icon-inline svg-icon-primary icon-lg"} %}
                    </a>
                </div>
            </div>
        </div>
    </div>
{% endif %}

{# Add to cart notification #}

{% if add_to_cart %}
    {% include "snipplets/notification-cart.tpl" %}
{% endif %}