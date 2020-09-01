{% embed "snipplets/page-header.tpl" with {'breadcrumbs': true} %}
    {% block page_header_text %}{{ "Carrito de Compras" | translate }}{% endblock page_header_text %}
{% endembed %}

<div id="shoppingCartPage" class="container" data-minimum="{{ settings.cart_minimum_value }}">
    <form action="{{ store.cart_url }}" method="post" class="cart-body" data-store="cart-form">
        <div class="cart-body">

            {# Cart alerts #}

            {% if error.add %}
                <div class="alert alert-warning">
                    {{ "¡Uy! No tenemos más stock de este producto para agregarlo al carrito. Si querés podés" | translate }}<a href="{{ store.products_url }}" class="btn-link ml-1">{{ "ver otros acá" | translate }}</a>
                </div>
            {% endif %}
            {% for error in error.update %}
                <div class="alert alert-warning">{{ "No podemos ofrecerte {1} unidades de {2}. Solamente tenemos {3} unidades." | translate(error.requested, error.item.name, error.stock) }}</div>
            {% endfor %}
            {% if cart.items %}
                <div class="js-ajax-cart-list cart-row">

                    {# Cart page items #}

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
                    {{ ("Ver más productos" | translate ~ " »") | a_tag(store.products_url) }}
                </div>
            {% endif %}
            <div id="error-ajax-stock" style="display: none;">
                <div class="alert alert-warning">
                    {{ "¡Uy! No tenemos más stock de este producto para agregarlo al carrito. Si querés podés" | translate }}<a href="{{ store.products_url }}" class="btn-link ml-1">{{ "ver otros acá" | translate }}</a>
                </div>
            </div>
            <div class="cart-row">
                {% include "snipplets/cart-totals.tpl" with {'cart_page': true} %}
            </div>
        </div>
    </form>
    <div id="store-curr" class="hidden">{{ cart.currency }}</div>
</div>

