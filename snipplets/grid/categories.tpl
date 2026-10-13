{# "Categorias:" section of the filter panel (Figma 52:3056, Fibery 237): light label, text chips
   with a 40px hit area (p-1 around a 32px chip). #}
{% if filter_categories %}
    <div>
        <p class="text-secondary/60 font-sans text-xs mb-2">{{ "Categorías:" | translate }}</p>
        <div class="-m-1 flex flex-wrap">
            {% set index = 0 %}
            {% for category in filter_categories %}
                {% set index = index + 1 %}
                {% if index == 9 and filter_categories | length > 8 %}
                    <div class="js-accordion-container flex flex-wrap" style="display: none;">
                {% endif %}
                <a href="{{ category.url }}" title="{{ category.name }}" class="group inline-flex p-1 no-underline cursor-pointer">
                    <span class="flex h-8 items-center whitespace-nowrap rounded-lg px-2 text-secondary font-sans text-sm font-medium transition-colors group-hover:bg-control">{{ category.name }}</span>
                </a>
                {% if loop.last and filter_categories | length > 8 %}
                    </div>
                    <div class="w-full p-1">
                        <a href="#" class="js-accordion-toggle text-secondary font-sans text-xs font-medium underline mt-1 inline-block">
                            <span class="js-accordion-toggle-inactive">{{ 'Ver más' | translate }}</span>
                            <span class="js-accordion-toggle-active" style="display: none;">{{ 'Ver menos' | translate }}</span>
                        </a>
                    </div>
                {% endif %}
            {% endfor %}
        </div>
    </div>
{% endif %}
