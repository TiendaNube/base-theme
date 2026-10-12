{#
  Menu Accordion Component
  Params: menu_items, highlighted_items, level (1-4), max_level (default 4)
#}

{% set level = level | default(1) %}
{% set max_level = max_level | default(4) %}
{% set highlighted_list = highlighted_items | default('') | split(',') | map(item => item | trim | lower) %}

<ul class="list-none m-0 {% if level == 1 %}pb-22 md:pb-0{% endif %}" data-menu-level="{{ level }}">
  {% for item in menu_items %}
    {% set has_subitems = item.subitems is not empty and level < max_level %}
    {% set is_highlighted = item.name | lower | trim in highlighted_list %}

    <li data-menu-item>
      {% if has_subitems %}
        <button
          type="button"
          class="js-menu-accordion-toggle flex w-full justify-between items-center px-6 py-3 bg-transparent border-0 cursor-pointer text-left text-secondary transition-colors duration-200 hover:opacity-70"
          aria-expanded="false"
        >
          <span class="{% if level == 1 %}font-heading text-2xl font-extrabold leading-[80%]{% else %}font-heading text-lg font-bold leading-[80%]{% endif %} {% if is_highlighted %}text-secondary{% endif %}">
            {{ item.name }}
          </span>
          <i data-lucide="plus" class="js-icon-closed w-4 h-4 shrink-0"></i>
          <i data-lucide="minus" class="js-icon-open w-4 h-4 shrink-0 hidden"></i>
        </button>

        <div class="js-menu-accordion-content pl-4" hidden>
          <a
            href="{{ item.url }}"
            class="flex w-full justify-between items-center px-6 py-3 no-underline text-secondary transition-colors duration-200 hover:opacity-70"
          >
            <span class="font-heading text-lg font-bold leading-[80%]">
              {{ 'Ver todos' | translate }}
            </span>
            <i data-lucide="arrow-right" class="w-4 h-4 shrink-0"></i>
          </a>
          {% include 'snipplets/navigation/menu-accordion.tpl' with {
            menu_items: item.subitems,
            highlighted_items: highlighted_items,
            level: level + 1,
            max_level: max_level
          } %}
        </div>
      {% else %}
        <a
          href="{{ item.url }}"
          class="flex w-full justify-between items-center px-6 py-3 no-underline text-secondary transition-colors duration-200 hover:opacity-70"
          {% if item.url | is_external %}target="_blank" rel="noopener"{% endif %}
        >
          <span class="{% if level == 1 %}font-heading text-2xl font-extrabold leading-[80%]{% else %}font-heading text-lg font-bold leading-[80%]{% endif %} {% if is_highlighted %}text-fg{% endif %}">
            {{ item.name }}
          </span>
          <i data-lucide="arrow-right" class="w-4 h-4 shrink-0"></i>
        </a>
      {% endif %}
    </li>
  {% endfor %}
</ul>
