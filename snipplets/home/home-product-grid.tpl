{# Product Grid - 2x2 Grid using primary section #}

{% set has_grid_products = sections.primary.products is not empty %}

{% set grid_bg_map = {
    'none': 'transparent',
    'primary': 'var(--primary-color)',
    'secondary': 'var(--text-color)',
    'background': 'var(--background-color)',
    'accent': 'var(--accent-color)'
} %}
{% set grid_bg_value = grid_bg_map[settings.product_grid_bg] | default('transparent') %}
{# "none" and "background" paint no visible block: the divider supplies the spacing, so drop the padding. #}
{% set grid_flat = settings.product_grid_bg == 'none' or settings.product_grid_bg == 'background' or not settings.product_grid_bg %}

{% if has_grid_products %}
{# Layout per Figma bestProducts (mobile 52:188, desktop 82:3191). Same grid language as the
   category grid: page gutter (24px mobile, 64px from md, aligned with the header) and a gap
   between cards; wide column gap on desktop (128px at xl = Figma's 592px cells at 1440).
   Desktop stays 2x2 here (4 products). #}
<section class="section-product-grid px-6 md:px-16 pt-8 {{ grid_flat ? 'pb-0' : 'pb-8' }}" data-store="home-product-grid" style="background-color: {{ grid_bg_value }}">

    {# Title #}
    {% if settings.product_grid_title %}
        <div class="mb-6 md:text-center">
            <h2 class="text-secondary font-heading text-[32px] font-extrabold leading-[80%]">
                {{ settings.product_grid_title }}
            </h2>
        </div>
    {% endif %}

    {# Product Grid 2x2 #}
    <div class="grid grid-cols-2 gap-x-3 gap-y-6 md:gap-x-16 md:gap-y-10 xl:gap-x-32">
        {% for product in sections.primary.products | slice(0, 4) %}
            {% include 'snipplets/grid/item-card.tpl' %}
        {% endfor %}
    </div>

</section>
{% endif %}
