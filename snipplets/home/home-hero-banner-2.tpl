{# Hero Banner 2 - Secondary hero banner for homepage with carousel support #}

{% set has_hero2_slide1_desktop = 'hero_banner_2_desktop.jpg' | has_custom_image %}
{% set has_hero2_slide2_desktop = 'hero_banner_2_slide2_desktop.jpg' | has_custom_image %}
{% set has_hero2_slide1_mobile = 'hero_banner_2_mobile.jpg' | has_custom_image %}
{% set has_hero2_slide2_mobile = 'hero_banner_2_slide2_mobile.jpg' | has_custom_image %}
{% set section_first = settings.home_order_position_0 == 'hero_banner_2' %}

{# Count how many slides we have #}
{% set slide_count = 0 %}
{% if has_hero2_slide1_desktop %}{% set slide_count = slide_count + 1 %}{% endif %}
{% if has_hero2_slide2_desktop %}{% set slide_count = slide_count + 1 %}{% endif %}

{% if has_hero2_slide1_desktop %}

    {# Lazy loading logic - don't lazy load if first section #}
    {% set apply_lazy_load = not section_first %}

    {# Define color values for JS to use #}
    {% set slide1_color = settings.hero_banner_2_text_color | default('white') %}
    {% set slide2_color = settings.hero_banner_2_slide2_text_color | default('white') %}

    <section
        class="js-hero-banner-2 relative w-full"
        data-store="home-hero-banner-2"
        data-slide-colors='["{{ slide1_color }}"{% if has_hero2_slide2_desktop %},"{{ slide2_color }}"{% endif %}]'
    >

        {# Slides Container - needs fixed height since slides are absolute #}
        <div class="relative h-[596.4px] md:h-170">
            {# Slide 1 #}
            {% include 'snipplets/home/hero-banner-2-slide.tpl' with {
                'slide_index': 0,
                'desktop_image': 'hero_banner_2_desktop.jpg',
                'mobile_image': has_hero2_slide1_mobile ? 'hero_banner_2_mobile.jpg' : 'hero_banner_2_desktop.jpg',
                'subtitle': settings.hero_banner_2_subtitle,
                'title': settings.hero_banner_2_title,
                'button_text': settings.hero_banner_2_button_text,
                'button_url': settings.hero_banner_2_button_url,
                'text_color': settings.hero_banner_2_text_color,
                'apply_lazy_load': apply_lazy_load,
                'is_active': true
            } %}

            {# Slide 2 #}
            {% if has_hero2_slide2_desktop %}
                {% include 'snipplets/home/hero-banner-2-slide.tpl' with {
                    'slide_index': 1,
                    'desktop_image': 'hero_banner_2_slide2_desktop.jpg',
                    'mobile_image': has_hero2_slide2_mobile ? 'hero_banner_2_slide2_mobile.jpg' : 'hero_banner_2_slide2_desktop.jpg',
                    'subtitle': settings.hero_banner_2_slide2_subtitle,
                    'title': settings.hero_banner_2_slide2_title,
                    'button_text': settings.hero_banner_2_slide2_button_text,
                    'button_url': settings.hero_banner_2_slide2_button_url,
                    'text_color': settings.hero_banner_2_slide2_text_color,
                    'apply_lazy_load': true,
                    'is_active': false
                } %}
            {% endif %}
        </div>

        {# Controls: Seeds (pagination) left + Arrows right - only show if more than 1 slide #}
        {% if slide_count > 1 %}
            <div class="js-hero2-controls absolute bottom-6 left-0 right-0 flex items-center justify-between px-4 md:px-16 z-20 transition-colors duration-500">
                {# Seed pagination indicators #}
                <div class="js-hero2-pagination flex items-center gap-0">
                    {# Seeds will be rendered here by JS #}
                </div>

                {# Navigation arrows - color will be updated by JS #}
                <div class="flex items-center gap-2">
                    <button class="js-hero2-prev flex w-8 h-8 justify-center items-center cursor-pointer" aria-label="{{ 'Anterior' | translate }}">
                        <i data-lucide="arrow-left" class="js-hero2-arrow w-5 h-5"></i>
                    </button>
                    <button class="js-hero2-next flex w-8 h-8 justify-center items-center cursor-pointer" aria-label="{{ 'Siguiente' | translate }}">
                        <i data-lucide="arrow-right" class="js-hero2-arrow w-5 h-5"></i>
                    </button>
                </div>
            </div>
        {% endif %}

    </section>

{% endif %}
