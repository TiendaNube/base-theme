{# VIP Group Banner - Full width banner with background image and a benefits list #}

{# Benefits: 4 pairs (bold highlight + text). A pair with both fields empty is hidden. #}
{% set vip_benefits = [] %}
{% if settings.vip_group_benefit_1_highlight or settings.vip_group_benefit_1_text %}
    {% set vip_benefits = vip_benefits | merge([{highlight: settings.vip_group_benefit_1_highlight, text: settings.vip_group_benefit_1_text}]) %}
{% endif %}
{% if settings.vip_group_benefit_2_highlight or settings.vip_group_benefit_2_text %}
    {% set vip_benefits = vip_benefits | merge([{highlight: settings.vip_group_benefit_2_highlight, text: settings.vip_group_benefit_2_text}]) %}
{% endif %}
{% if settings.vip_group_benefit_3_highlight or settings.vip_group_benefit_3_text %}
    {% set vip_benefits = vip_benefits | merge([{highlight: settings.vip_group_benefit_3_highlight, text: settings.vip_group_benefit_3_text}]) %}
{% endif %}
{% if settings.vip_group_benefit_4_highlight or settings.vip_group_benefit_4_text %}
    {% set vip_benefits = vip_benefits | merge([{highlight: settings.vip_group_benefit_4_highlight, text: settings.vip_group_benefit_4_text}]) %}
{% endif %}
{% set has_vip_benefits = vip_benefits | length > 0 %}

{# Legacy HTML (vip_group_custom_html): fallback for one release, used only when every pair is empty. #}
{% set use_vip_legacy_html = not has_vip_benefits and settings.vip_group_custom_html %}

{% set has_vip_button = settings.vip_group_button_text and settings.vip_group_button_url %}
{% set has_vip_group = settings.vip_group_title or settings.vip_group_subtitle or has_vip_benefits or use_vip_legacy_html or has_vip_button %}

{% set has_bg_image = 'vip_group_bg.jpg' | has_custom_image %}
{% set has_bg_mobile_image = 'vip_group_bg_mobile.jpg' | has_custom_image %}
{# Mobile uses its own upload when present, otherwise the desktop image #}
{% set vip_bg_mobile = has_bg_mobile_image ? 'vip_group_bg_mobile.jpg' : 'vip_group_bg.jpg' %}

{# Overlay over the image (contrast for the white text). Literal classes so Tailwind picks them up. #}
{% set vip_overlay_map = {
    'none': 'bg-transparent',
    'light': 'bg-black/15',
    'medium': 'bg-black/30',
    'strong': 'bg-black/50'
} %}
{% set vip_overlay_class = vip_overlay_map[settings.vip_group_overlay] | default('bg-black/30') %}

{# Lazy load - VIP group is typically not first section #}
{% set apply_lazy_load = true %}
{% set lazy_placeholder = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==' %}

{% if has_vip_group %}
<section class="section-vip-group relative w-full overflow-hidden" data-store="home-vip-group">

    {# Background Image with lazy loading and responsive srcset #}
    {% if has_bg_image or has_bg_mobile_image %}
        <div class="absolute inset-0 z-0 bg-fg">
            {# Desktop Image #}
            {% if has_bg_image %}
                {% if apply_lazy_load %}
                    {% set desktop_src = lazy_placeholder %}
                {% else %}
                    {% set desktop_src = 'vip_group_bg.jpg' | static_url | settings_image_url('original') %}
                {% endif %}
                <div class="hidden md:block absolute inset-0">
                    <img
                        {% if apply_lazy_load %}data-{% endif %}src="{{ desktop_src }}"
                        {% if apply_lazy_load %}data-{% endif %}srcset="{{ 'vip_group_bg.jpg' | static_url | settings_image_url('large') }} 1024w, {{ 'vip_group_bg.jpg' | static_url | settings_image_url('huge') }} 1440w, {{ 'vip_group_bg.jpg' | static_url | settings_image_url('original') }} 1920w"
                        {% if apply_lazy_load %}
                        data-sizes="100vw"
                        data-expand="-10"
                        {% else %}
                        sizes="100vw"
                        {% endif %}
                        class="w-full h-full object-cover {% if apply_lazy_load %}lazyautosizes lazyload fade-in{% endif %}"
                        alt="{{ settings.vip_group_title }}"
                    />
                </div>
            {% endif %}

            {# Mobile Image #}
            {% if apply_lazy_load %}
                {% set mobile_src = lazy_placeholder %}
            {% else %}
                {% set mobile_src = vip_bg_mobile | static_url | settings_image_url('large') %}
            {% endif %}
            <div class="md:hidden absolute inset-0">
                <img
                    {% if apply_lazy_load %}data-{% endif %}src="{{ mobile_src }}"
                    {% if apply_lazy_load %}data-{% endif %}srcset="{{ vip_bg_mobile | static_url | settings_image_url('medium') }} 480w, {{ vip_bg_mobile | static_url | settings_image_url('large') }} 768w"
                    {% if apply_lazy_load %}
                    data-sizes="100vw"
                    data-expand="-10"
                    {% else %}
                    sizes="100vw"
                    {% endif %}
                    class="w-full h-full object-cover {% if apply_lazy_load %}lazyautosizes lazyload fade-in{% endif %}"
                    alt="{{ settings.vip_group_title }}"
                />
            </div>

            {# Dark overlay for text readability (intensity chosen in the admin) #}
            <div class="absolute inset-0 {{ vip_overlay_class }}"></div>
        </div>
    {% else %}
        {# Fallback background if no image: theme primary #}
        <div class="absolute inset-0 z-0 bg-fg"></div>
    {% endif %}

    {# Content: left-aligned on mobile, centered on desktop #}
    <div class="relative z-10 flex flex-col items-start text-left md:items-center md:text-center px-6 py-10 md:py-16 text-white"> {# lint-styles: allow overlay #}

        {# Title #}
        {% if settings.vip_group_title %}
            <h2 class="font-heading text-4xl md:text-5xl font-extrabold leading-none mb-3">
                {{ settings.vip_group_title }}
            </h2>
        {% endif %}

        {# Subtitle #}
        {% if settings.vip_group_subtitle %}
            <p class="font-heading text-base md:text-lg font-semibold">
                {{ settings.vip_group_subtitle }}
            </p>
        {% endif %}

        {# Benefits list #}
        {% if has_vip_benefits %}
            <ul class="flex flex-col gap-4 mt-8 font-sans text-base leading-6 text-left md:self-center" data-vip-benefits>
                {% for benefit in vip_benefits %}
                    <li class="flex items-start gap-2">
                        <svg class="shrink-0 size-2.5 mt-[7px]" viewBox="0 0 6.4 6.2" fill="none" aria-hidden="true" xmlns="http://www.w3.org/2000/svg">
                            <path d="M2.36204 5.32905C0.573932 4.88216 -0.316928 3.57786 0.102425 1.8844C0.436631 0.537335 1.56165 -0.035703 2.7601 0.00171553C4.05861 0.0423414 5.02823 0.895484 5.50293 2.18054C5.76157 2.88081 6.06065 4.17121 6.36931 5.39213C6.48426 5.84542 6.06384 6.25703 5.60936 6.1437C4.85687 5.95875 3.04109 5.49904 2.36204 5.32905Z" fill="currentColor"/>
                        </svg>
                        <span>{% if benefit.highlight %}<strong class="font-bold">{{ benefit.highlight }}</strong>{% endif %}{% if benefit.highlight and benefit.text %} {% endif %}{% if benefit.text %}{{ benefit.text }}{% endif %}</span>
                    </li>
                {% endfor %}
            </ul>
        {% elseif use_vip_legacy_html %}
            {# Legacy custom HTML - fallback for one release, only when all benefit pairs are empty #}
            <div class="vip-group-custom-content mt-6 max-w-2xl">
                {{ settings.vip_group_custom_html | raw }}
            </div>
        {% endif %}

        {# CTA Button #}
        {% if has_vip_button %}
            <a
                href="{{ settings.vip_group_button_url }}"
                {% if settings.vip_group_button_new_tab != '0' %}target="_blank" rel="noopener noreferrer"{% endif %}
                class="self-center inline-flex items-center justify-center h-10 min-w-34 px-2 mt-8 rounded-lg bg-white/30 font-sans text-base font-medium transition-colors duration-200 hover:bg-white/40"
            >
                {{ settings.vip_group_button_text }}
            </a>
        {% endif %}

        {# Support Logo - 4 Seeds SVG #}
        <div class="self-center mt-6 text-bg">
            <svg width="23" height="16" viewBox="0 0 23 16" fill="none" aria-hidden="true" xmlns="http://www.w3.org/2000/svg">
                <path d="M2.36204 5.32905C0.573932 4.88216 -0.316928 3.57786 0.102425 1.8844C0.436631 0.537335 1.56165 -0.035703 2.7601 0.00171553C4.05861 0.0423414 5.02823 0.895484 5.50293 2.18054C5.76157 2.88081 6.06065 4.17121 6.36931 5.39213C6.48426 5.84542 6.06384 6.25703 5.60936 6.1437C4.85687 5.95875 3.04109 5.49904 2.36204 5.32905Z" fill="currentColor"/>
                <path d="M8.26385 13.6274C7.81895 15.4235 6.52045 16.3183 4.83558 15.8971C3.49344 15.5614 2.92401 14.4314 2.9602 13.2276C3.00065 11.9233 3.85 10.9493 5.12934 10.4725C5.82649 10.2127 7.11116 9.91229 8.32665 9.60225C8.77793 9.48678 9.1877 9.90908 9.07488 10.3656C8.89075 11.1214 8.43308 12.9453 8.26385 13.6274Z" fill="currentColor"/>
                <path d="M20.638 5.32905C22.4261 4.88216 23.3169 3.57786 22.8976 1.88547C22.5634 0.537335 21.4384 -0.035703 20.2399 0.00171553C18.9414 0.0423414 17.9718 0.895484 17.4971 2.18054C17.2384 2.88081 16.9394 4.17121 16.6307 5.39213C16.5157 5.84542 16.9362 6.25703 17.3906 6.1437C18.1431 5.95875 19.9589 5.49904 20.638 5.32905Z" fill="currentColor"/>
                <path d="M14.7362 13.6274C15.1811 15.4235 16.4796 16.3183 18.1644 15.8971C19.5066 15.5614 20.076 14.4314 20.0398 13.2276C19.9994 11.9233 19.15 10.9493 17.8707 10.4725C17.1735 10.2127 15.8888 9.91229 14.6734 9.60225C14.2221 9.48678 13.8123 9.90908 13.9251 10.3656C14.1093 11.1214 14.5669 12.9453 14.7362 13.6274Z" fill="currentColor"/>
            </svg>
        </div>

    </div>

</section>
{% endif %}
