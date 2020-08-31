{# Site Overlay #}
<div class="js-overlay site-overlay" style="display: none;"></div>


{# Header #}

{% set show_transparent_head = template == 'home' and settings.head_transparent and settings.slider and not settings.slider is empty %}

<header class="js-head-main head-main {% if show_transparent_head %}head-transparent {% if settings.head_fix %}head-transparent-fixed{% else %}head-transparent-absolute{% endif %}{% endif %} head-{{ settings.head_background }} {% if settings.head_fix %}head-fix{% endif %} {% if not settings.head_fix and show_transparent_head %}head-absolute{% endif %}" data-store="head">

    {# Advertising #}
    
    {% if settings.ad_bar and settings.ad_text %}
        {% snipplet "header/header-advertising.tpl" %}
    {% endif %}

	<div class="container">
		<div class="row no-gutters align-items-center">
			<div class="col">{% snipplet "navigation/navigation.tpl" %}</div>
			<div class="col text-center">{% snipplet "header/header-logo.tpl" %}</div>
			<div class="col text-right">{% snipplet "header/header-utilities.tpl" %}</div>
		</div>
	</div>    
    {% include "snipplets/notification.tpl" with {order_notification: true} %}
    {% if settings.head_fix and settings.ajax_cart %}
        {% include "snipplets/notification.tpl" with {add_to_cart: true} %}
    {% endif %}
</header>

{% if not settings.head_fix %}
    {% include "snipplets/notification.tpl" with {add_to_cart: true, add_to_cart_fixed: true} %}
{% endif %}

{# Hamburger panel #}

{% embed "snipplets/modal.tpl" with{modal_id: 'nav-hamburger',modal_class: 'nav-hamburger modal-docked-small', modal_position: 'left', modal_transition: 'fade', modal_width: 'full'  } %}
    {% block modal_body %}
        {% snipplet "navigation/navigation-panel.tpl" %}
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

    {% embed "snipplets/modal.tpl" with{modal_id: 'modal-cart', modal_position: 'right', modal_transition: 'slide', modal_width: 'docked-md', modal_form_action: store.cart_url, modal_form_class: 'js-ajax-cart-panel', modal_mobile_full_screen: true, modal_form_hook: 'cart-form' } %}
        {% block modal_head %}
            {% block page_header_text %}{{ "Carrito de Compras" | translate }}{% endblock page_header_text %}
        {% endblock %}
        {% block modal_body %}
            {% snipplet "cart-panel.tpl" %}
        {% endblock %}
    {% endembed %}

{% endif %}