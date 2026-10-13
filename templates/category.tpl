{% set has_filters_available = products and has_filters_enabled and (filter_categories is not empty or product_filters is not empty) %}

{# Sort method labels #}
{% set sort_text = {
    'best-selling': 'Más Vendidos',
    'user': 'Destacado',
    'price-ascending': 'Precio: Menor a Mayor',
    'price-descending': 'Precio: Mayor a Menor',
    'alpha-ascending': 'A - Z',
    'alpha-descending': 'Z - A',
    'created-ascending': 'Más Viejo al más Nuevo',
    'created-descending': 'Más Nuevo al más Viejo',
} %}
{% set current_sort_label = sort_text[sort_by] ? (sort_text[sort_by] | t) : ('Ordenar' | translate) %}
{% set show_help = not has_products %}
{% paginate by 12 %}

{# Determine if we are in a child category (breadcrumbs has parent + current) #}
{% set is_child_category = breadcrumbs | length > 1 %}

{# Build sibling categories from main menu when on a child category #}
{# Strategy: find the current category URL among menu subitems, then collect its siblings #}
{% set sibling_categories = [] %}
{% if is_child_category and settings.menu_principal %}
    {% set current_url = category.url %}
    {% set parent_name = breadcrumbs[breadcrumbs | length - 2].name %}
    {% set main_menu = menus[settings.menu_principal] %}
    {% for item in main_menu %}
        {# Check if this top-level item is the parent (match by name) #}
        {% if item.name == parent_name and item.subitems is not empty %}
            {% for sub in item.subitems %}
                {% set sibling_categories = sibling_categories | merge([sub]) %}
            {% endfor %}
        {% elseif item.subitems is not empty %}
            {# Check second level - subitems might be the parent #}
            {% for sub in item.subitems %}
                {% if sub.name == parent_name and sub.subitems is not empty %}
                    {% for subsub in sub.subitems %}
                        {% set sibling_categories = sibling_categories | merge([subsub]) %}
                    {% endfor %}
                {% endif %}
            {% endfor %}
        {% endif %}
    {% endfor %}
{% endif %}

{# Determine which categories to show in dropdown #}
{% set dropdown_categories = sibling_categories is not empty ? sibling_categories : filter_categories %}
{% set has_dropdown = dropdown_categories is not empty or is_child_category %}

{# Parent URL for "Todos" link #}
{% set parent_url = is_child_category ? breadcrumbs[breadcrumbs | length - 2].url : category.url %}

{% if not show_help %}

    {# Sentinels for store.js.tpl IntersectionObserver & sticky controls #}
    <div class="js-category-controls-prev" aria-hidden="true"></div>
    <div class="js-category-controls" aria-hidden="true"></div>

    {# Category Header Bar - Figma mobile 14:1568 (Fibery 237): one row on mobile (title +
       subcategory chip on the left, "Filtros" text link on the right) with the breadcrumb right
       below; sorting lives in the filter panel on mobile. Desktop keeps the sort dropdown and the
       "Filtrar" button in the title row. Mobile gutter is 24px, aligned with the header and grid. #}
    {% set has_filter_panel = has_filters_available or sort_methods is not empty %}
    <section class="px-6 md:px-16 py-4" style="background-color: var(--background-color)">
        <div class="flex items-center gap-3 mb-2">
            {# Left group wraps on narrow screens (long titles/subcategories) so the mobile "Filtros" link stays on the right #}
            <div class="flex min-w-0 flex-wrap items-center gap-3">
                {# Title: if child category, show parent name; otherwise show current category name #}
                {% if is_child_category %}
                    <h1 class="text-secondary font-heading text-[32px] font-extrabold leading-[80%] m-0">
                        {{ breadcrumbs[breadcrumbs | length - 2].name }}
                    </h1>
                {% else %}
                    <h1 class="text-secondary font-heading text-[32px] font-extrabold leading-[80%] m-0">
                        {{ category.name }}
                    </h1>
                {% endif %}

                {# Category Dropdown - matches home-product-carousel.tpl style #}
                {% if has_dropdown %}
                    <div class="js-category-dropdown relative shrink-0">
                        <button
                            class="js-category-dropdown-trigger flex h-8 items-center gap-1 [background:rgba(0,0,0,0.05)] px-3 py-1 rounded-lg text-secondary font-sans text-sm font-medium cursor-pointer"
                            type="button"
                            aria-expanded="false"
                        >
                            <span class="js-category-dropdown-label">
                                {% if is_child_category %}
                                    {{ category.name }}
                                {% else %}
                                    {{ "Todos" | translate }}
                                {% endif %}
                            </span>
                            <i data-lucide="chevron-down" class="js-category-dropdown-icon w-4 h-4 text-secondary transition-transform duration-200"></i>
                        </button>
                        <ul class="js-category-dropdown-list absolute top-full left-0 mt-1 min-w-max bg-bg/70 backdrop-blur-sm rounded-lg shadow-md overflow-hidden z-20" hidden>
                            <li>
                                <a href="{{ parent_url }}" class="block whitespace-nowrap px-3 py-2 text-secondary font-sans text-base cursor-pointer hover:bg-black/5 no-underline">
                                    {{ "Todos" | translate }}
                                </a>
                            </li>
                            {% for cat in dropdown_categories %}
                                <li>
                                    <a href="{{ cat.url }}" class="block whitespace-nowrap px-3 py-2 text-secondary font-sans text-base cursor-pointer hover:bg-black/5 no-underline">
                                        {{ cat.name }}
                                    </a>
                                </li>
                            {% endfor %}
                        </ul>
                    </div>
                {% endif %}

                {# Sorting Dropdown — Desktop only (mobile sorts from the "Ordenar:" chips in the filter panel) #}
                {% if sort_methods is not empty %}
                    <div class="js-category-sorting relative hidden md:block">
                        <button
                            class="js-category-sorting-trigger flex h-8 items-center gap-1 [background:rgba(0,0,0,0.05)] px-3 py-1 rounded-lg text-secondary font-sans text-sm font-medium cursor-pointer"
                            type="button"
                            aria-expanded="false"
                        >
                            <span class="js-category-sorting-label">{{ current_sort_label }}</span>
                            <i data-lucide="chevron-down" class="js-category-sorting-icon w-4 h-4 text-secondary transition-transform duration-200"></i>
                        </button>
                        <ul class="js-category-sorting-list absolute top-full left-0 mt-1 min-w-max bg-bg/70 backdrop-blur-sm rounded-lg shadow-md overflow-hidden z-20" hidden>
                            {# Best-selling first #}
                            {% for sort_method in sort_methods %}
                                {% if sort_method == 'best-selling' %}
                                    <li>
                                        <button
                                            type="button"
                                            class="js-category-sorting-option block w-full text-left whitespace-nowrap px-3 py-2 text-secondary font-sans text-base cursor-pointer hover:bg-black/5 {% if sort_by == sort_method %}font-bold{% endif %}"
                                            data-sort-value="{{ sort_method }}"
                                        >
                                            {{ sort_text[sort_method] | t }}
                                        </button>
                                    </li>
                                {% endif %}
                            {% endfor %}
                            {# Rest of sort methods #}
                            {% for sort_method in sort_methods %}
                                {% if sort_method != 'best-selling' %}
                                    {% if sort_method != 'user' or category.sort_method == 'user' %}
                                        <li>
                                            <button
                                                type="button"
                                                class="js-category-sorting-option block w-full text-left whitespace-nowrap px-3 py-2 text-secondary font-sans text-base cursor-pointer hover:bg-black/5 {% if sort_by == sort_method %}font-bold{% endif %}"
                                                data-sort-value="{{ sort_method }}"
                                            >
                                                {{ sort_text[sort_method] | t }}
                                            </button>
                                        </li>
                                    {% endif %}
                                {% endif %}
                            {% endfor %}
                        </ul>
                    </div>
                {% endif %}

                {% if has_filters_available %}
                    <button type="button" class="js-category-filter-trigger hidden md:flex h-8 items-center gap-1.5 [background:rgba(0,0,0,0.05)] px-3 py-1 rounded-lg text-secondary font-sans text-sm font-medium cursor-pointer hover:bg-black/10 transition-colors" data-filter-title="{{ 'Filtros' | translate }}">
                        <i data-lucide="list-filter" class="w-4 h-4 text-secondary"></i>
                        {{ 'Filtrar' | translate }}
                    </button>
                {% endif %}
            </div>

            {# Mobile: "Filtros" text link on the right; 40px tall hit area, text aligned to the gutter #}
            {% if has_filter_panel %}
                <button type="button" class="js-category-filter-trigger md:hidden ml-auto -mr-2 flex h-10 shrink-0 items-center px-2 text-secondary font-sans text-sm font-medium cursor-pointer" data-filter-title="{{ 'Filtros' | translate }}">
                    {{ 'Filtros' | translate }}
                </button>
            {% endif %}
        </div>

        {# Breadcrumb #}
        {% include 'snipplets/breadcrumbs.tpl' %}

        {# Hidden native select for platform compatibility #}
        {% if sort_methods is not empty %}
            <select class="js-sort-by" hidden aria-label="{{ 'Ordenar por:' | translate }}">
                {% for sort_method in sort_methods %}
                    {% if sort_method != 'user' or category.sort_method == 'user' %}
                        <option value="{{ sort_method }}" {% if sort_by == sort_method %}selected{% endif %}>{{ sort_text[sort_method] | t }}</option>
                    {% endif %}
                {% endfor %}
            </select>
        {% endif %}

        {# Applied filters chips #}
        {% if has_filters_available and has_applied_filters %}
            <div class="flex flex-wrap items-center gap-2 mt-3">
                <span class="text-secondary font-sans text-sm">{{ 'Filtrado por:' | translate }}</span>
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
                <a href="#" class="js-remove-all-filters text-secondary font-sans text-xs font-medium underline">{{ 'Borrar filtros' | translate }}</a>
            </div>
        {% endif %}

        {% if has_filter_panel %}
            {# Hidden filter content — source for gaius modal/drawer (Figma 52:3056). The modal copies
               this innerHTML, so every handler in here must be delegated. Breadcrumb and "Ordenar:"
               are mobile-only: desktop keeps them in the title row. #}
            <div class="js-category-filter-content" hidden>
                <div class="flex flex-col gap-4">
                    {% include 'snipplets/breadcrumbs.tpl' with { breadcrumbs_custom_class: 'md:hidden' } %}
                    {% if sort_methods is not empty %}
                        {% include 'snipplets/grid/sort-by.tpl' %}
                    {% endif %}
                    {% if has_filters_available and filter_categories is not empty %}
                        {% snipplet "grid/categories.tpl" %}
                    {% endif %}
                    {% if has_filters_available and product_filters is not empty %}
                        {% snipplet "grid/filters.tpl" %}
                    {% endif %}
                </div>
                <div class="js-filters-overlay" style="display:none;position:absolute;inset:0;background:color-mix(in srgb, var(--background-color) 80%, transparent);z-index:10;align-items:center;justify-content:center">
                    <div>
                        <h3 class="js-applying-filter text-secondary font-sans text-sm" style="display:none;">{{ 'Aplicando filtro...' | translate }}</h3>
                        <h3 class="js-removing-filter text-secondary font-sans text-sm" style="display:none;">{{ 'Borrando filtro...' | translate }}</h3>
                    </div>
                </div>
            </div>
        {% endif %}
    </section>

    {# Product Grid + Pagination - Figma mobile 14:1778 / desktop 131:4362: 2 columns on mobile,
       3 from md, inside the page gutter (24px mobile, 64px from md, aligned with the header) with a
       gap between cards. Same grid language as the home "Mais Vendidos" grid. #}
    <section class="px-6 md:px-16 pb-8" style="background-color: var(--background-color)">
        {% if products %}
            <div class="js-category-grid grid grid-cols-2 md:grid-cols-3 gap-x-3 gap-y-6 md:gap-x-6 md:gap-y-10"
                 data-next-url="{{ pages.next }}"
                 data-is-last="{{ pages.is_last ? 'true' : 'false' }}">
                {% for product in products %}
                    {% include 'snipplets/grid/item-card.tpl' %}
                {% endfor %}
            </div>
            {# Custom load more / infinite scroll #}
            {% if not pages.is_last %}
                <div class="js-category-load-more flex justify-center mt-6 mb-6">
                    <button type="button" class="js-category-load-more-btn text-secondary font-sans text-sm font-medium cursor-pointer [background:rgba(0,0,0,0.05)] px-6 py-2 rounded-lg hover:bg-black/10 transition-colors">
                        {{ 'Mostrar más productos' | translate }}
                    </button>
                </div>
                <div class="js-category-scroll-spinner flex justify-center py-4" hidden>
                    <i data-lucide="loader-2" class="w-6 h-6 text-secondary animate-spin"></i>
                </div>
            {% endif %}
        {% else %}
            <p class="text-center text-fg-muted py-8">
                {{(has_filters_enabled ? "No tenemos resultados para tu búsqueda. Por favor, intentá con otros filtros." : "Próximamente") | translate}}
            </p>
        {% endif %}
    </section>

{% elseif show_help %}
    {% include 'snipplets/defaults/show_help_category.tpl' %}
{% endif %}
