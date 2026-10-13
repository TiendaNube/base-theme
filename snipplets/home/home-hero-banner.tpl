{# Hero Banner - First section of homepage #}

{% set has_hero_desktop_image = 'hero_banner_desktop.jpg' | has_custom_image %}
{% set has_hero_mobile_image = 'hero_banner_mobile.jpg' | has_custom_image %}
{% set section_first = settings.home_order_position_0 == 'hero_banner' %}
{% set hero_link = settings.hero_banner_button_url | setting_url %}

{% if has_hero_desktop_image %}

    {# Define text color class based on setting #}
    {% if settings.hero_banner_text_color == 'primary' %}
        {% set text_color_class = 'text-fg' %}
    {% elseif settings.hero_banner_text_color == 'background' %}
        {% set text_color_class = 'text-bg' %}
    {% else %}
        {% set text_color_class = 'text-white' %} {# lint-styles: allow admin-white #}
    {% endif %}

    {# Lazy loading logic - don't lazy load if first section #}
    {% set apply_lazy_load = not section_first %}

    {# Mobile image fallback to desktop #}
    {% set mobile_image = has_hero_mobile_image ? 'hero_banner_mobile.jpg' : 'hero_banner_desktop.jpg' %}

    {# Keeps the <h1> of the home; hero 2 only takes it when this hero renders no title #}
    <section class="relative w-full" data-store="home-hero-banner">

        {# Wrapper - clickable if has link #}
        {% if hero_link %}
            <a href="{{ hero_link }}" class="block relative focus-visible:outline-2 focus-visible:-outline-offset-4">
        {% else %}
            <div class="relative">
        {% endif %}

            {# Desktop Container #}
            <div class="hidden md:block relative h-[819.2px]">
                {% if apply_lazy_load %}
                    {% set desktop_src = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==' %}
                {% else %}
                    {% set desktop_src = 'hero_banner_desktop.jpg' | static_url | settings_image_url('original') %}
                {% endif %}

                <img
                    {% if not apply_lazy_load %}fetchpriority="high"{% endif %}
                    {% if apply_lazy_load %}data-{% endif %}src="{{ desktop_src }}"
                    {% if apply_lazy_load %}data-{% endif %}srcset="{{ 'hero_banner_desktop.jpg' | static_url | settings_image_url('large') }} 1024w, {{ 'hero_banner_desktop.jpg' | static_url | settings_image_url('huge') }} 1440w, {{ 'hero_banner_desktop.jpg' | static_url | settings_image_url('original') }} 1920w"
                    {% if apply_lazy_load %}
                    data-sizes="100vw"
                    data-expand="-10"
                    {% else %}
                    sizes="100vw"
                    {% endif %}
                    class="absolute inset-0 w-full h-full object-cover {% if apply_lazy_load %}lazyautosizes lazyload fade-in{% endif %}"
                    alt="{{ settings.hero_banner_alt ?: settings.hero_banner_title ?: store.name }}"
                />
            </div>

            {# Mobile Container #}
            <div class="md:hidden relative h-[596.4px]">
                {% if apply_lazy_load %}
                    {% set mobile_src = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==' %}
                {% else %}
                    {% set mobile_src = mobile_image | static_url | settings_image_url('large') %}
                {% endif %}

                <img
                    {% if not apply_lazy_load %}fetchpriority="high"{% endif %}
                    {% if apply_lazy_load %}data-{% endif %}src="{{ mobile_src }}"
                    {% if apply_lazy_load %}data-{% endif %}srcset="{{ mobile_image | static_url | settings_image_url('medium') }} 480w, {{ mobile_image | static_url | settings_image_url('large') }} 768w"
                    {% if apply_lazy_load %}
                    data-sizes="100vw"
                    data-expand="-10"
                    {% else %}
                    sizes="100vw"
                    {% endif %}
                    class="absolute inset-0 w-full h-full object-cover {% if apply_lazy_load %}lazyautosizes lazyload fade-in{% endif %}"
                    alt="{{ settings.hero_banner_alt ?: settings.hero_banner_title ?: store.name }}"
                />
            </div>

            {# Overlay - shared between desktop and mobile #}
            <div class="absolute inset-0 bg-black/35"></div>

            {# Content - positioned at bottom center #}
            <div class="absolute inset-x-0 bottom-0 flex flex-col items-center px-6 pb-6 {{ text_color_class }}">
                {% if settings.hero_banner_subtitle %}
                    <span class="text-base font-normal font-sans mb-2">{{ settings.hero_banner_subtitle }}</span>
                {% endif %}
                {% if settings.hero_banner_title %}
                    <h1 class="text-4xl md:text-5xl lg:text-6xl font-heading font-bold mb-2">{{ settings.hero_banner_title }}</h1>
                {% endif %}
                {% if settings.hero_banner_button_text %}
                    <span class="inline-flex items-center gap-2 text-base font-semibold">
                        {{ settings.hero_banner_button_text }}
                        <i data-lucide="arrow-right" class="w-5 h-5 mt-0.5" aria-hidden="true"></i>
                    </span>
                {% endif %}
            </div>

        {% if hero_link %}
            </a>
        {% else %}
            </div>
        {% endif %}

    </section>

{% endif %}
