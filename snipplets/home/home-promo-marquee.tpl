{# Promo Marquee Bar - Promotional texts with infinite scroll effect #}

{% if settings.promo_marquee_text_1 %}

    {# Build array of texts #}
    {% set promo_texts = [] %}

    {% if settings.promo_marquee_text_1 %}
        {% set promo_texts = promo_texts|merge([settings.promo_marquee_text_1]) %}
    {% endif %}
    {% if settings.promo_marquee_text_2 %}
        {% set promo_texts = promo_texts|merge([settings.promo_marquee_text_2]) %}
    {% endif %}
    {% if settings.promo_marquee_text_3 %}
        {% set promo_texts = promo_texts|merge([settings.promo_marquee_text_3]) %}
    {% endif %}
    {% if settings.promo_marquee_text_4 %}
        {% set promo_texts = promo_texts|merge([settings.promo_marquee_text_4]) %}
    {% endif %}

    {# Map dropdown values to theme CSS variables #}
    {% set bg_color_map = {
        'primary': 'var(--primary-color)',
        'secondary': 'var(--text-color)',
        'background': 'var(--background-color)',
        'accent': 'var(--accent-color)'
    } %}

    {# "white" is an explicit admin choice, not a theme color (ADR-0003 §4) #}
    {% set admin_white = '#FFFFFF' %} {# lint-styles: allow admin-white #}
    {% set text_color_map = {
        'white': admin_white,
        'primary': 'var(--primary-color)',
        'secondary': 'var(--text-color)',
        'background': 'var(--background-color)'
    } %}

    {% set bg_color = bg_color_map[settings.promo_marquee_bg_color] | default('var(--primary-color)') %}
    {% set text_color = text_color_map[settings.promo_marquee_text_color] | default(admin_white) %}

    <section class="promo-marquee-section overflow-hidden" data-store="home-promo-marquee">
        <div class="flex h-12 items-center p-2.5" style="background-color: {{ bg_color }};">
            <div class="promo-marquee-track flex items-center gap-12">
                {# First set of texts #}
                {% for text in promo_texts %}
                    <span class="promo-marquee-item whitespace-nowrap text-sm font-medium uppercase tracking-wider" style="color: {{ text_color }};">{{ text }}</span>
                {% endfor %}
                {# Duplicate for seamless loop - repeat 3 more times for full coverage #}
                {% for text in promo_texts %}
                    <span class="promo-marquee-item whitespace-nowrap text-sm font-medium uppercase tracking-wider" style="color: {{ text_color }};">{{ text }}</span>
                {% endfor %}
                {% for text in promo_texts %}
                    <span class="promo-marquee-item whitespace-nowrap text-sm font-medium uppercase tracking-wider" style="color: {{ text_color }};">{{ text }}</span>
                {% endfor %}
                {% for text in promo_texts %}
                    <span class="promo-marquee-item whitespace-nowrap text-sm font-medium uppercase tracking-wider" style="color: {{ text_color }};">{{ text }}</span>
                {% endfor %}
            </div>
        </div>
    </section>

{% endif %}
