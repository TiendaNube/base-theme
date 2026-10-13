{# Product Grid - own section "product_grid"; falls back to "primary" (Destacados) while it is empty,
   so the grid does not vanish before the owner assigns products to the new section. #}

{% set grid_products = sections.product_grid.products is not empty ? sections.product_grid.products : sections.primary.products %}
{% set has_grid_products = grid_products is not empty %}
{% set grid_count = (settings.product_grid_count | default(4)) + 0 %}
{% set grid_viewall_label = settings.product_grid_viewall_label | trim %}
{% set grid_viewall_url = settings.product_grid_viewall_url | trim %}

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
   Desktop stays 2 columns here. #}
<section class="section-product-grid px-6 md:px-16 pt-8 {{ grid_flat ? 'pb-0' : 'pb-8' }}" data-store="home-product-grid" style="background-color: {{ grid_bg_value }}">

    {# Title + optional "Ver todos" (only when label and URL are both filled) #}
    {% if settings.product_grid_title or (grid_viewall_label and grid_viewall_url) %}
        <div class="relative mb-6 flex items-end justify-between gap-3 md:justify-center md:text-center">
            {% if settings.product_grid_title %}
                <h2 class="text-secondary font-heading text-[32px] font-extrabold leading-[80%]">
                    {{ settings.product_grid_title }}
                </h2>
            {% endif %}
            {% if grid_viewall_label and grid_viewall_url %}
                <a href="{{ grid_viewall_url }}" class="js-grid-viewall shrink-0 font-sans text-sm font-medium text-secondary underline md:absolute md:right-0 md:bottom-0">{{ grid_viewall_label }}</a>
            {% endif %}
        </div>
    {% endif %}

    {# Product Grid 2x2 #}
    <div class="grid grid-cols-2 gap-x-3 gap-y-6 md:gap-x-16 md:gap-y-10 xl:gap-x-32">
        {% for product in grid_products | slice(0, grid_count) %}
            {% include 'snipplets/grid/item-card.tpl' %}
        {% endfor %}
    </div>

</section>
{% endif %}
