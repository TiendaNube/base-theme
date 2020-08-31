{% if product.variations %}
    {% set own_color_variants = 0 %}
    {% set custom_color_variants = 0 %}

    {% for variation in product.variations %}
        <div class="js-color-variant-available-{{ loop.index }} {% if variation.name in ['Color', 'Cor'] %}js-color-variant-active{% endif %}" data-value="variation_{{ loop.index }}" data-option="{{ loop.index0 }}" >
            {% if variation.name in ['Color', 'Cor'] %}
                {% if variation.options | length > 1 %}
                    <div class="item-colors">
                        <a href="{{ product_url_with_selected_variant }}" class="item-colors-bullet item-colors-bullet-text d-md-none w-auto px-2">{{ variation.options | length }} {{ 'colores' | translate }}</a>
                        <div class="d-none d-md-block">
                            {% for option in variation.options | take(5) if option.custom_data %}
                                <span title="{{ option.name }}" data-option="{{ option.id }}" class="js-color-variant item-colors-bullet {% if product.default_options[variation.id] == option.id %}selected{% endif %}" style="background: {{ option.custom_data }}"></span>
                            {% endfor %}

                            {% for option in variation.options %}
                                {% if option.custom_data %}
                                    {# Quantity of our colors #}
                                    {% set own_color_variants = own_color_variants + 1 %}
                                {% else %}
                                    {# Quantity of custom colors #}
                                    {% set custom_color_variants = custom_color_variants + 1 %}
                                {% endif %}
                            {% endfor %}

                            {% set more_color_variants = (own_color_variants - 5) + custom_color_variants %}

                            {% if own_color_variants and custom_color_variants %}
                                <a href="{{ product_url_with_selected_variant }}" class="item-colors-bullet w-auto" title="{{ 'Ver más colores' | translate }}">
                                    {% if own_color_variants > 5 %}
                                        +{{ more_color_variants }}
                                    {% else %}
                                        +{{ custom_color_variants }}
                                    {% endif %}
                                </a>
                            {% elseif own_color_variants > 5 %}
                                <a href="{{ product_url_with_selected_variant }}" class="item-colors-bullet w-auto" title="{{ 'Ver más colores' | translate }}">+{{ own_color_variants - 5 }}</a>
                            {% elseif custom_color_variants %}
                                <a href="{{ product_url_with_selected_variant }}" class="item-colors-bullet item-colors-bullet-text w-auto px-2" title="{{ 'Ver más colores' | translate }}">{{ custom_color_variants }} {{ 'colores' | translate }}</a>
                            {% endif %}
                        </div>
                    </div>
                {% endif %}
            {% endif %}
        </div>
    {% endfor %}
{% endif %} 