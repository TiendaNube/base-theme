{% if applied_filters %}
    
    {# Applied filters chips #}

    {% if has_applied_filters %}
        <div class="col-12 mb-3">
            <div class="d-md-inline-block mr-md-2 mb-3">{{ 'Filtrado por:' | translate }}</div>
            {% for product_filter in product_filters %}
                {% for value in product_filter.values %}

                    {# List applied filters as tags #}
                    
                    {% if value.selected %}
                        <button class="js-remove-filter chip" data-filter-name="{{ product_filter.name|replace("'","%27") }}" data-filter-value="{{ value.name|replace("'","%27") }}">
                            {{ value.name }}
                            {% include "snipplets/svg/times.tpl" with {svg_custom_class: "icon-inline chip-remove-icon"} %}
                        </button>
                    {% endif %}
                {% endfor %}
            {% endfor %}
            <a href="#" class="js-remove-all-filters d-inline-block px-0">{{ 'Borrar filtros' | translate }}</a> 
        </div>
    {% endif %}
{% else %}
    <div id="filters" data-store="filters-nav">
        {% for product_filter in product_filters %}
            {% if product_filter.has_products %}
                <div class="filters-container mb-5" data-store="filters-group">
                    <h6 class="mb-3">{{product_filter.name}}</h6>
                    {% set index = 0 %}
                    {% for value in product_filter.values %}
                        {% if value.product_count > 0 %}
                            {% set index = index + 1 %}
                            <label class="js-filter-checkbox {% if not value.selected %}js-apply-filter{% else %}js-remove-filter{% endif %} checkbox-container font-weight-bold {% if mobile %}mb-3{% else %}mb-2{% endif %}" data-filter-name="{{ product_filter.name|replace("'","%27") }}" data-filter-value="{{ value.name|replace("'","%27") }}">
                                <span class="checkbox">
                                    <input type="checkbox" autocomplete='off' {% if value.selected %}checked{% endif %}>
                                    <span class="checkbox-icon"></span>
                                    <span class="checkbox-text">{{ value.name }} ({{ value.product_count }})</span>
                                    {% if product_filter.type == 'color' and value.color_type == 'insta_color' %}
                                        <span class="checkbox-color" style="background-color: {{ value.color_hexa }};"></span>
                                    {% endif %}
                                </span>
                            </label>
                            {% if index == 8 and product_filter.values_with_products > 8 %}
                                <div class="js-accordion-container" style="display: none;">
                            {% endif %}
                        {% endif %}
                        {% if loop.last and product_filter.values_with_products > 8 %}
                            </div>
                            <a href="#" class="js-accordion-toggle btn-link d-inline-block mt-1 pl-0">
                                <span class="js-accordion-toggle-inactive">
                                    {{ 'Ver todos' | translate }}
                                </span>
                                <span class="js-accordion-toggle-active" style="display: none;">
                                    {{ 'Ver menos' | translate }}
                                </span>
                            </a>
                        {% endif %}
                    {% endfor %}
                </div>
            {% endif %}
        {% endfor %}
    </div>
{% endif %}