{# Product Carousel with Category Tabs #}

{% set has_tab_1 = sections.carousel_tab_1.products is not empty %}
{% set has_tab_2 = sections.carousel_tab_2.products is not empty %}
{% set has_tab_3 = sections.carousel_tab_3.products is not empty %}
{% set has_any_tab = has_tab_1 or has_tab_2 or has_tab_3 %}
{% set carousel_viewall_label = settings.product_carousel_viewall_label | trim %}
{% set carousel_viewall_url = settings.product_carousel_viewall_url | trim %}

{# Section background as a token class (ADR-0003/0004), never an inline style; literal class names so Tailwind sees them. #}
{% set carousel_bg_map = {
    'none': 'bg-transparent',
    'primary': 'bg-fg',
    'secondary': 'bg-secondary',
    'background': 'bg-bg',
    'accent': 'bg-accent'
} %}
{% set carousel_bg_class = carousel_bg_map[settings.product_carousel_bg] | default('bg-transparent') %}
{# "none" and "background" paint no visible block: the divider supplies the spacing, so drop the padding. #}
{% set carousel_flat = settings.product_carousel_bg == 'none' or settings.product_carousel_bg == 'background' or not settings.product_carousel_bg %}

{% if has_any_tab %}
{# Layout per Figma productSlider (mobile 52:194, desktop 82:3006): on mobile the track is edge to
   edge (first card at x=0, no gutter) and the cards are a fixed 234px with a peek of the next one;
   title sits 24px in, controls 16px in. From md the section gets the 64px gutter and the cards go
   fluid (3.25 / 4.25 per view, as before the Figma pass): fixed 234px cards left huge gaps on wide
   screens. Title and controls align with the first card. #}
<section class="js-product-carousel section-product-carousel md:px-16 pt-8 {{ carousel_flat ? 'pb-0' : 'pb-8' }} {{ carousel_bg_class }}" data-store="home-product-carousel">

    {# Header: Title + Dropdown #}
    <div class="flex items-center gap-3 mb-6 px-6 md:px-0">
        {% if settings.product_carousel_title %}
            <h2 class="text-secondary font-heading text-[32px] font-extrabold leading-[80%]">
                {{ settings.product_carousel_title }}
            </h2>
        {% endif %}

        {# Category Dropdown Select #}
        {% set tab_count = 0 %}
        {% if has_tab_1 %}{% set tab_count = tab_count + 1 %}{% endif %}
        {% if has_tab_2 %}{% set tab_count = tab_count + 1 %}{% endif %}
        {% if has_tab_3 %}{% set tab_count = tab_count + 1 %}{% endif %}

        {% if tab_count > 1 %}
            <div class="js-carousel-dropdown relative">
                {# Trigger button #}
                <button class="js-carousel-dropdown-trigger flex h-8 items-center gap-1 [background:rgba(0,0,0,0.05)] px-3 py-1 rounded-lg text-secondary font-sans text-sm font-medium cursor-pointer" type="button" aria-expanded="false">
                    <span class="js-carousel-dropdown-label">
                        {% if has_tab_1 %}
                            {{ settings.product_carousel_tab_1_label }}
                        {% elseif has_tab_2 %}
                            {{ settings.product_carousel_tab_2_label }}
                        {% else %}
                            {{ settings.product_carousel_tab_3_label }}
                        {% endif %}
                    </span>
                    <i data-lucide="chevron-down" class="js-carousel-dropdown-icon w-4 h-4 text-secondary transition-transform duration-200"></i>
                </button>
                {# Options list #}
                <ul class="js-carousel-dropdown-list hidden absolute top-full left-0 mt-1 min-w-full bg-bg/70 backdrop-blur-sm rounded-lg shadow-md overflow-hidden z-20">
                    {% if has_tab_1 %}
                        <li class="js-carousel-dropdown-option px-3 py-2 text-secondary font-sans text-base cursor-pointer hover:bg-black/5" data-value="tab-1" data-selected="true">
                            {{ settings.product_carousel_tab_1_label }}
                        </li>
                    {% endif %}
                    {% if has_tab_2 %}
                        <li class="js-carousel-dropdown-option px-3 py-2 text-secondary font-sans text-base cursor-pointer hover:bg-black/5" data-value="tab-2">
                            {{ settings.product_carousel_tab_2_label }}
                        </li>
                    {% endif %}
                    {% if has_tab_3 %}
                        <li class="js-carousel-dropdown-option px-3 py-2 text-secondary font-sans text-base cursor-pointer hover:bg-black/5" data-value="tab-3">
                            {{ settings.product_carousel_tab_3_label }}
                        </li>
                    {% endif %}
                </ul>
            </div>
        {% endif %}

        {# Optional "Ver todos" (only when label and URL are both filled) #}
        {% if carousel_viewall_label and carousel_viewall_url %}
            <a href="{{ carousel_viewall_url }}" class="js-carousel-viewall ml-auto shrink-0 font-sans text-sm font-medium text-secondary underline">{{ carousel_viewall_label }}</a>
        {% endif %}
    </div>

    {# Carousel Containers - one per tab. On mobile slides are a fixed 234px (Swiper slidesPerView: 'auto');
       the "!" is needed because the vendored Swiper CSS (style-critical, unlayered) sets .swiper-slide width: 100%. #}
    {% if has_tab_1 %}
    <div class="js-carousel-tab js-carousel-tab-1" data-tab="tab-1">
        <div class="js-swiper-product-carousel-1 swiper-container">
            <div class="swiper-wrapper">
                {% for product in sections.carousel_tab_1.products %}
                    {% include 'snipplets/grid/item-card.tpl' with { 'item_class': 'swiper-slide max-md:w-[234px]!' } %}
                {% endfor %}
            </div>
        </div>
    </div>
    {% endif %}

    {% if has_tab_2 %}
    <div class="js-carousel-tab js-carousel-tab-2 hidden" data-tab="tab-2">
        <div class="js-swiper-product-carousel-2 swiper-container">
            <div class="swiper-wrapper">
                {% for product in sections.carousel_tab_2.products %}
                    {% include 'snipplets/grid/item-card.tpl' with { 'item_class': 'swiper-slide max-md:w-[234px]!' } %}
                {% endfor %}
            </div>
        </div>
    </div>
    {% endif %}

    {% if has_tab_3 %}
    <div class="js-carousel-tab js-carousel-tab-3 hidden" data-tab="tab-3">
        <div class="js-swiper-product-carousel-3 swiper-container">
            <div class="swiper-wrapper">
                {% for product in sections.carousel_tab_3.products %}
                    {% include 'snipplets/grid/item-card.tpl' with { 'item_class': 'swiper-slide max-md:w-[234px]!' } %}
                {% endfor %}
            </div>
        </div>
    </div>
    {% endif %}

    {# Controls: Seeds (pagination) left + Arrows right #}
    <div class="js-carousel-controls flex items-center justify-between gap-2 mt-4 px-4 md:px-0">
        {# Seed pagination indicators - each seed is a 24x40 hit area around an 11x8 glyph (24px pitch, close like Figma);
           -ml-1.5 puts the first glyph back on the 16px gutter. Wraps instead of overflowing with many products. #}
        <div class="js-carousel-pagination flex flex-wrap items-center gap-0 min-w-0 -ml-1.5">
            {# Seeds are dynamically generated by JS based on active swiper #}
        </div>

        {# Navigation arrows #}
        <div class="flex items-center gap-2">
            <button class="js-carousel-prev flex w-8 h-8 justify-center items-center cursor-pointer" aria-label="{{ 'Anterior' | translate }}">
                <i data-lucide="arrow-left" class="w-5 h-5 text-secondary"></i>
            </button>
            <button class="js-carousel-next flex w-8 h-8 justify-center items-center cursor-pointer" aria-label="{{ 'Siguiente' | translate }}">
                <i data-lucide="arrow-right" class="w-5 h-5 text-secondary"></i>
            </button>
        </div>
    </div>

</section>
{% endif %}
