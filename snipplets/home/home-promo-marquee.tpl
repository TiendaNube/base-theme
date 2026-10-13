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

    {# Cores via data-attributes mapeados em app.css (.promo-marquee-section) - ADR-0004 #}
    {% set bg_key = settings.promo_marquee_bg_color in ['primary', 'secondary', 'background', 'accent'] ? settings.promo_marquee_bg_color : 'primary' %}
    {% set text_key = settings.promo_marquee_text_color in ['white', 'primary', 'secondary', 'background'] ? settings.promo_marquee_text_color : 'white' %}

    <section class="promo-marquee-section overflow-hidden" data-bg="{{ bg_key }}" data-text="{{ text_key }}" data-store="home-promo-marquee">
        <div class="flex h-12 items-center p-2.5">
            <div class="promo-marquee-track flex items-center gap-12">
                {# First set of texts #}
                {% for text in promo_texts %}
                    <span class="promo-marquee-item whitespace-nowrap text-sm font-medium uppercase tracking-wider">{{ text }}</span>
                {% endfor %}
                {# Duplicate for seamless loop - repeat 3 more times for full coverage #}
                {% for text in promo_texts %}
                    <span class="promo-marquee-item whitespace-nowrap text-sm font-medium uppercase tracking-wider">{{ text }}</span>
                {% endfor %}
                {% for text in promo_texts %}
                    <span class="promo-marquee-item whitespace-nowrap text-sm font-medium uppercase tracking-wider">{{ text }}</span>
                {% endfor %}
                {% for text in promo_texts %}
                    <span class="promo-marquee-item whitespace-nowrap text-sm font-medium uppercase tracking-wider">{{ text }}</span>
                {% endfor %}
            </div>
        </div>
    </section>

{% endif %}
