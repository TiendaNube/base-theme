{# Hero Banner 2 - Single Slide Component #}

{# Define text color class based on setting #}
{% if text_color == 'primary' %}
    {% set text_color_class = 'text-fg' %}
{% elseif text_color == 'background' %}
    {% set text_color_class = 'text-bg' %}
{% else %}
    {% set text_color_class = 'text-white' %} {# lint-styles: allow admin-white #}
{% endif %}

{% set slide_link = button_url | setting_url %}

<div class="js-hero2-slide absolute inset-0 transition-opacity duration-700 {% if is_active %}opacity-100 z-10{% else %}opacity-0 z-0{% endif %}" data-slide="{{ slide_index }}">
    {# Wrapper - clickable if has link #}
    {% if slide_link %}
        <a href="{{ slide_link }}" class="block relative h-full">
    {% else %}
        <div class="relative h-full">
    {% endif %}

        {# Desktop Container #}
        <div class="hidden md:block relative h-170">
            {% if apply_lazy_load %}
                {% set desktop_src = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==' %}
            {% else %}
                {% set desktop_src = desktop_image | static_url | settings_image_url('original') %}
            {% endif %}

            <img
                {% if not apply_lazy_load %}fetchpriority="high"{% endif %}
                {% if apply_lazy_load %}data-{% endif %}src="{{ desktop_src }}"
                {% if apply_lazy_load %}data-{% endif %}srcset="{{ desktop_image | static_url | settings_image_url('large') }} 1024w, {{ desktop_image | static_url | settings_image_url('huge') }} 1440w, {{ desktop_image | static_url | settings_image_url('original') }} 1920w"
                {% if apply_lazy_load %}
                data-sizes="100vw"
                data-expand="-10"
                {% else %}
                sizes="100vw"
                {% endif %}
                class="absolute inset-0 w-full h-full object-cover {% if apply_lazy_load %}lazyautosizes lazyload fade-in{% endif %}"
                alt="{{ title ?: store.name }}"
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
                alt="{{ title ?: store.name }}"
            />
        </div>

        {# Overlay - shared between desktop and mobile #}
        <div class="absolute inset-0 bg-black/35"></div>

        {# Content - positioned at bottom center #}
        <div class="absolute inset-x-0 bottom-16 md:bottom-6 flex flex-col items-center px-6 {{ text_color_class }}">
            {% if subtitle %}
                <span class="text-base font-normal font-sans mb-2">{{ subtitle }}</span>
            {% endif %}
            {% if title %}
                <h2 class="text-4xl md:text-5xl lg:text-6xl font-heading font-bold mb-2">{{ title }}</h2>
            {% endif %}
            {% if button_text %}
                <span class="inline-flex items-center gap-2 text-base font-semibold">
                    {{ button_text }}
                    <i data-lucide="arrow-right" class="w-5 h-5 mt-0.5"></i>
                </span>
            {% endif %}
        </div>

    {% if slide_link %}
        </a>
    {% else %}
        </div>
    {% endif %}
</div>
