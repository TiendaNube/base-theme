
{% embed "snipplets/page-header.tpl" %}
    {% block page_header_text %}{{ "Mi cuenta" | translate }}{% endblock page_header_text %}
{% endembed %}

{# User addresses listed #}

<section class="account-page">
    <div class="container">
        <div class="row justify-content-md-center">
            <div class="col-md-8">
                {% for address in customer.addresses %}
                    {% if loop.index % 2 == 1 %}
                        <div class="row">
                    {% endif %}
                    <div class="col-6">
                        <p>{{ address | format_address }}</p>
                        <p>
                            {{ 'Editar' | translate | a_tag(store.customer_address_url(address), {class: 'btn-link'}) }} -
                            {% if address.main %}
                                <strong>{{ 'Principal' | translate }}</strong>
                            {% else %}
                                {{ 'Principal' | translate | a_tag(store.customer_set_main_address_url(address), {class: 'btn-link'}) }}
                            {% endif %}
                        </p>
                    </div>
                     {% if loop.index % 2 == 0 or loop.last %}
                        </div>
                    {% endif %}
                {% endfor %}
                <a class="btn btn-primary d-inline-block" href="{{ store.customer_new_address_url }}"> {{ 'Agregar una nueva dirección' | translate }}</a>
            </div>
        </div>
    </div>
</section>
