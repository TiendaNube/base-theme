{% if applied_filters %}

    {# Applied filters chips #}

    {% if has_applied_filters %}
        <div class="mb-4">
            <div class="text-secondary font-sans text-sm mb-2">{{ 'Filtrado por:' | translate }}</div>
            <div class="flex flex-wrap gap-2">
                {% for product_filter in product_filters %}
                    {% set is_size = product_filter.type == 'size' or product_filter.key == 'Talle' or product_filter.key == 'Tamanho' or product_filter.key == 'Size' %}
                    {% for value in product_filter.values %}
                        {% if value.selected %}
                            <button class="js-remove-filter flex items-center gap-1 [background:rgba(0,0,0,0.05)] px-2.5 py-1 rounded-lg text-secondary font-sans text-xs font-medium cursor-pointer hover:bg-black/10 transition-colors {% if is_size %}uppercase{% endif %}" data-filter-name="{{ product_filter.key }}" data-filter-value="{{ value.name }}">
                                {{ value.pill_label }}
                                <i data-lucide="x" class="w-3 h-3 text-secondary"></i>
                            </button>
                        {% endif %}
                    {% endfor %}
                {% endfor %}
                <a href="#" class="js-remove-all-filters text-secondary font-sans text-xs font-medium underline self-center">{{ 'Borrar filtros' | translate }}</a>
            </div>
        </div>
    {% endif %}
{% else %}
    {# Filter sections of the panel (Figma 52:3056, Fibery 237): light "Name:" labels, text chips with
       a 40px hit area (p-1 around a 32px chip), selected value filled (bg-control). Chips apply on
       click (legacy .js-apply-filter / .js-remove-filter handler in store.js.tpl, page reload).
       Colors get a dot with the platform swatch; price is one row: de [ ] até [ ] Aplicar. #}
    {% if product_filters is not empty %}
        <div id="filters" class="flex flex-col gap-4" data-store="filters-nav">
            {% for product_filter in product_filters %}
                {% if product_filter.type == 'price' %}

                    <div class="js-price-filter-wrapper">
                        <p class="text-secondary/60 font-sans text-xs mb-2">{{ 'Precio:' | translate }}</p>
                        {{ component(
                            'price-filter',
                            {'group_class': '', 'title_class': 'hidden', 'button_class': 'js-price-filter-btn' }
                        ) }}
                    </div>

                {% else %}
                    {% if product_filter.has_products %}
                        {% set is_size = product_filter.type == 'size' or product_filter.key == 'Talle' or product_filter.key == 'Tamanho' or product_filter.key == 'Size' %}
                        {% set is_color = product_filter.type == 'color' %}
                        <div data-store="filters-group">
                            <p class="text-secondary/60 font-sans text-xs mb-2">{{ is_color ? ('Colores:' | translate) : (product_filter.name ~ ':') }}</p>
                            <div class="-m-1 flex flex-wrap">
                                {% set index = 0 %}
                                {% for value in product_filter.values %}
                                    {% if value.product_count > 0 %}
                                        {% set index = index + 1 %}
                                        {% if index == 9 and product_filter.values_with_products > 8 %}
                                            <div class="js-accordion-container flex flex-wrap" style="display: none;">
                                        {% endif %}
                                        <button type="button" class="{{ value.selected ? 'js-remove-filter' : 'js-apply-filter' }} group inline-flex p-1 cursor-pointer" data-filter-name="{{ product_filter.key }}" data-filter-value="{{ value.name }}" aria-pressed="{{ value.selected ? 'true' : 'false' }}">
                                            <span class="flex h-8 min-w-8 items-center justify-center gap-2 whitespace-nowrap rounded-lg px-2 text-secondary font-sans text-sm font-medium transition-colors group-hover:bg-control {% if value.selected %}bg-control{% endif %} {% if is_size %}uppercase{% endif %}">
                                                {{ value.name }}
                                                {% if is_color and value.color_type == 'insta_color' %}
                                                    <span class="size-2 shrink-0 rounded-full border border-secondary/20" style="background-color: {{ value.color_hexa }}" aria-hidden="true"></span>
                                                {% endif %}
                                            </span>
                                        </button>
                                    {% endif %}
                                    {% if loop.last and product_filter.values_with_products > 8 %}
                                        </div>
                                        <div class="w-full p-1">
                                            <a href="#" class="js-accordion-toggle text-secondary font-sans text-xs font-medium underline mt-1 inline-block">
                                                <span class="js-accordion-toggle-inactive">{{ 'Ver todos' | translate }}</span>
                                                <span class="js-accordion-toggle-active" style="display: none;">{{ 'Ver menos' | translate }}</span>
                                            </a>
                                        </div>
                                    {% endif %}
                                {% endfor %}
                            </div>
                        </div>
                    {% endif %}
                {% endif %}
            {% endfor %}
        </div>
    {% endif %}
{% endif %}
