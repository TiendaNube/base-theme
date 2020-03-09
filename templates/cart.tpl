{% embed "snipplets/page-header.tpl" with {'breadcrumbs': true} %}
    {% block page_header_text %}{{ "Carrito de Compras" | translate }}{% endblock page_header_text %}
{% endembed %}

<div id="shoppingCartPage" class="container" data-minimum="{{ settings.cart_minimum_value }}">
    <form action="{{ store.cart_url }}" method="post" id="ajax-cart-details" class="js-ajax-cart-panel cart-body">
        <div class="cart-body">
            {% if cart.items %}
                <div class="js-ajax-cart-list cart-row">
                    {# Cart panel items #}
                    {% if cart.items %}
                      {% for item in cart.items %}
                        {% include "snipplets/cart-item-ajax.tpl" with {'cart_page': true} %}
                      {% endfor %}
                    {% endif %}
                </div>
            {% else %}
                {#  Empty cart  #}
                <div class="alert alert-info">
                    {% if error %}
                        {{ "¡Uy! No tenemos más stock de este producto para agregarlo al carrito. Si querés podés" | translate }}
                        <a href="{{ store.products_url }}" class="btn btn-link p-none">{{ "ver otros acá" | translate }}</a>
                    {% else %}
                        {{ "El carrito de compras está vacío." | translate }}
                    {% endif %}
                    {{ ("Seguir comprando" | translate ~ " »") | a_tag(store.products_url) }}
                </div>
            {% endif %}
            <div id="error-ajax-stock" style="display: none;">
                <div class="alert alert-warning">
                    {{ "¡Uy! No tenemos más stock de este producto para agregar este producto al carrito. Si querés podés" | translate }}<a href="{{ store.products_url }}" class="btn-link">{{ "ver otros acá" | translate }}</a>
                </div>
            </div>
            <div class="cart-row">
                {% include "snipplets/cart-totals.tpl" with {'cart_page': true} %}
            </div>
        </div>
    </form>
    <div id="store-curr" class="hidden">{{ cart.currency }}</div>
</div>

