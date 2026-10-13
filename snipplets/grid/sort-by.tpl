{# "Ordenar:" section of the filter panel (Figma 52:3056, Fibery 237) — mobile only: desktop sorts
   from the dropdown in the title row. Expects `sort_text` from templates/category.tpl. Chips reuse
   .js-category-sorting-option, so category-sorting.js applies them the same way as the dropdown
   (sort_by in the URL, page reload). Best-selling first; 'user' only when it is the category's
   own sort method. Hit area is 40px (p-1 around a 32px chip). #}
{% set sort_chip_class = 'js-category-sorting-option group inline-flex p-1 cursor-pointer' %}
{% set sort_pill_class = 'flex h-8 min-w-8 items-center justify-center whitespace-nowrap rounded-lg px-2 text-secondary font-sans text-sm font-medium transition-colors group-hover:bg-control' %}
<div class="md:hidden">
    <p class="text-secondary/60 font-sans text-xs mb-2">{{ 'Ordenar:' | translate }}</p>
    <div class="-m-1 flex flex-wrap">
        {% for sort_method in sort_methods %}
            {% if sort_method == 'best-selling' %}
                <button type="button" class="{{ sort_chip_class }}" data-sort-value="{{ sort_method }}" {% if sort_by == sort_method %}aria-current="true"{% endif %}>
                    <span class="{{ sort_pill_class }} {% if sort_by == sort_method %}bg-control{% endif %}">{{ sort_text[sort_method] | t }}</span>
                </button>
            {% endif %}
        {% endfor %}
        {% for sort_method in sort_methods %}
            {% if sort_method != 'best-selling' %}
                {% if sort_method != 'user' or category.sort_method == 'user' %}
                    <button type="button" class="{{ sort_chip_class }}" data-sort-value="{{ sort_method }}" {% if sort_by == sort_method %}aria-current="true"{% endif %}>
                        <span class="{{ sort_pill_class }} {% if sort_by == sort_method %}bg-control{% endif %}">{{ sort_text[sort_method] | t }}</span>
                    </button>
                {% endif %}
            {% endif %}
        {% endfor %}
    </div>
</div>
