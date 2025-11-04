{# Site Overlay #}
<div class="js-overlay site-overlay" style="display: none;"></div>


{# Header #}

{% set show_transparent_head = template == 'home' and settings.head_transparent and settings.slider and not settings.slider is empty %}

<header class="js-head-main head-main {% if show_transparent_head %}head-transparent {% if settings.head_fix %}head-transparent-fixed{% else %}head-transparent-absolute{% endif %}{% endif %} head-{{ settings.head_background }} {% if settings.head_fix %}head-fix{% endif %} {% if not settings.head_fix and show_transparent_head %}head-absolute{% endif %}" data-store="head">

    {# Advertising #}
    
    {% if settings.ad_bar and settings.ad_text %}
        {% snipplet "header/header-advertising.tpl" %}
    {% endif %}

    <div class="container position-relative">
        <div class="row no-gutters align-items-center">
            <div class="col">{% snipplet "navigation/navigation.tpl" %}</div>
            <div class="col text-center">
                {{ component('logos/logo', {logo_size: 'large', logo_img_classes: 'transition-soft-slow', logo_text_classes: 'h1 m-0'}) }}
            </div>
            <div class="col text-right">{% snipplet "header/header-utilities.tpl" %}</div>
            {% if settings.head_fix and settings.ajax_cart %}
                {% include "snipplets/notification.tpl" with {add_to_cart: true} %}
            {% endif %}
        </div>
    </div>    
    {% include "snipplets/notification.tpl" with {order_notification: true} %}
</header>

{% if not settings.head_fix %}
    {% include "snipplets/notification.tpl" with {add_to_cart: true, add_to_cart_fixed: true} %}
{% endif %}

{# Show cookie validation message #}
{% include "snipplets/notification.tpl" with {show_cookie_banner: true} %}

{# Hamburger panel #}

{% embed "snipplets/modal.tpl" with{modal_id: 'nav-hamburger',modal_class: 'nav-hamburger modal-docked-small', modal_position: 'left', modal_transition: 'fade', modal_width: 'full', modal_fixed_footer: true, modal_footer: true, modal_footer_class: 'p-0' } %}
    {% block modal_body %}
        {% include "snipplets/navigation/navigation-panel.tpl" with {primary_links: true} %}
    {% endblock %}
    {% block modal_foot %}
        {% include "snipplets/navigation/navigation-panel.tpl" %}
    {% endblock %}
{% endembed %}
{# Notifications #}

{# Modal Search #}

{% embed "snipplets/modal.tpl" with{modal_id: 'nav-search', modal_position: 'right', modal_transition: 'slide', modal_width: 'docked-md' } %}
    {% block modal_body %}
        {% snipplet "header/header-search.tpl" %}
    {% endblock %}
{% endembed %}

{% if not store.is_catalog and settings.ajax_cart and template != 'cart' %}           

    {# Cart Ajax #}

    {% embed "snipplets/modal.tpl" with{
        modal_id: 'modal-cart',
        modal_position: 'right',
        modal_transition: 'slide',
        modal_width: 'docked-md',
        modal_form_action: store.cart_url,
        modal_form_class: 'js-ajax-cart-panel',
        modal_mobile_full_screen: true,
        modal_url: 'modal-fullscreen-cart',
        modal_form_hook: 'cart-form',
        custom_data_attribute: 'cart-open-type',
		custom_data_attribute_value: settings.cart_open_type
    } %}
        {% block modal_head %}
            {% block page_header_text %}{{ "Carrito de Compras" | translate }}{% endblock page_header_text %}
        {% endblock %}
        {% block modal_body %}
            {% snipplet "cart-panel.tpl" %}
        {% endblock %}
    {% endembed %}

    {% if settings.add_to_cart_recommendations %}

        {# Recommended products on add to cart #}

        {% embed "snipplets/modal.tpl" with{modal_id: 'related-products-notification', modal_class: 'bottom modal-overflow-none modal-bottom-sheet h-auto', modal_header_class: 'px-0 pt-0 mb-2 m-0 w-100', modal_position: 'bottom', modal_transition: 'slide', modal_width: 'centered modal-centered-md-600px p-3'} %}
            {% block modal_head %}
                {% block page_header_text %}{{ '¡Agregado al carrito!' | translate }}{% endblock page_header_text %}
            {% endblock %}
            {% block modal_body %}

                {# Product added info #}

                {% include "snipplets/notification-cart.tpl" with {related_products: true} %}

                {# Product added recommendations #}

                <div class="js-related-products-notification-container" style="display: none"></div>

            {% endblock %}
        {% endembed %}
    {% endif %}
{% endif %}

{# Cross selling promotion notification on add to cart #}

{% embed "snipplets/modal.tpl" with {
    modal_id: 'js-cross-selling-modal',
    modal_class: 'bottom modal-bottom-sheet h-auto overflow-none modal-body-scrollable-auto',
    modal_header: true,
    modal_header_class: 'm-0 w-100',
    modal_position: 'bottom',
    modal_transition: 'slide',
    modal_footer: true,
    modal_width: 'centered-md m-0 p-0 modal-full-width modal-md-width-400px'
} %}
    {% block modal_head %}
        {{ '¡Descuento exclusivo!' | translate }}
    {% endblock %}

    {% block modal_body %}
        {# Promotion info and actions #}

        <div class="js-cross-selling-modal-body" style="display: none"></div>
    {% endblock %}
{% endembed %}