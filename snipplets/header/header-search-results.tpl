<ul class="search-suggest-list">
    {% set search_suggestions = products | take(6) %}
    {% for product in search_suggestions %}
        <li class="search-suggest-item container-fluid">
            <a href="{{ product.url }}" class="search-suggest-link row justify-content-md-center">
                <div class="search-suggest-image-container col-xs-auto">
                    {{ product.featured_image | product_image_url("tiny") | img_tag(product.featured_image.alt, {class: 'search-suggest-image'}) }}
                </div>
                <div class="search-suggest-text col">
                	<p class="search-suggest-name">
                		{{ product.name | highlight(query) }}
                	</p>
                    {% if product.display_price %}
                    	<p>
                    		{{ product.price | money }}

                            {% set product_can_show_installments = product.show_installments and product.display_price and product.get_max_installments.installment > 1 %}
                            {% if product_can_show_installments %}
                                {% set max_installments_without_interests = product.get_max_installments(false) %}
                                {% if store.country == 'AR' %}
                                    {% set max_installments_with_interests = product.get_max_installments %}
                                    {% if max_installments_with_interests %}
                                        <span>| {{ "Hasta <strong class='installment-amount'>{1}</strong> cuotas" | t(max_installments_with_interests.installment, max_installments_with_interests.installment_data.installment_value_cents | money) }}</span>
                                    {% endif %}
                                {% else %}
                                    {% if max_installments_without_interests and max_installments_without_interests.installment > 1 %}
                                        <span>| {{ "<strong class='installment-amount'>{1}</strong> cuotas sin interés de <strong class='installment-price'>{2}</strong>" | t(max_installments_without_interests.installment, max_installments_without_interests.installment_data.installment_value_cents | money) }}</span>
                                    {% else %}
                                        {% set max_installments_with_interests = product.get_max_installments %}
                                        {% if max_installments_with_interests %}
                                            <span>| {{ "<strong class='installment-amount'>{1}</strong> cuotas de <strong class='installment-price'>{2}</strong>" | t(max_installments_with_interests.installment, max_installments_with_interests.installment_data.installment_value_cents | money) }}</span>
                                        {% endif %}
                                    {% endif %}
                                {% endif %}
                            {% endif %}
                    	</p>
                    {% endif %}
                </div>
                <div class="col-xs-auto">
                    {% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline search-suggest-icon"} %}
                </div>
            </a>
        </li>
    {% endfor %}
    <a href="#" class="js-search-suggest-all-link btn btn-primary d-block">{{ 'Ver todos los resultados' | translate }}</a>
</ul>
