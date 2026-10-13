{# Promo Marquee Bar - Promotional texts with infinite scroll effect #}

{% if settings.promo_marquee_text_1 %}

    {# Lista de mensagens: [texto, link opcional]. Link vazio/ausente = texto puro (comportamento antigo) #}
    {% set promo_texts = [] %}

    {% if settings.promo_marquee_text_1 %}
        {% set promo_texts = promo_texts|merge([[settings.promo_marquee_text_1, settings.promo_marquee_link_1]]) %}
    {% endif %}
    {% if settings.promo_marquee_text_2 %}
        {% set promo_texts = promo_texts|merge([[settings.promo_marquee_text_2, settings.promo_marquee_link_2]]) %}
    {% endif %}
    {% if settings.promo_marquee_text_3 %}
        {% set promo_texts = promo_texts|merge([[settings.promo_marquee_text_3, settings.promo_marquee_link_3]]) %}
    {% endif %}
    {% if settings.promo_marquee_text_4 %}
        {% set promo_texts = promo_texts|merge([[settings.promo_marquee_text_4, settings.promo_marquee_link_4]]) %}
    {% endif %}

    {# Cores via data-attributes mapeados em app.css (.promo-marquee-section) - ADR-0004 #}
    {% set bg_key = settings.promo_marquee_bg_color in ['primary', 'secondary', 'background', 'accent'] ? settings.promo_marquee_bg_color : 'primary' %}
    {% set text_key = settings.promo_marquee_text_color in ['white', 'primary', 'secondary', 'background'] ? settings.promo_marquee_text_color : 'white' %}

    {# Velocidade e pausa no hover: nunca salvos = normal/sem pausa = comportamento anterior (30s) #}
    {% set speed_key = settings.promo_marquee_speed in ['slow', 'normal', 'fast'] ? settings.promo_marquee_speed : 'normal' %}
    {% set pause_hover = settings.promo_marquee_pause_hover ? '1' : '0' %}

    <section class="promo-marquee-section overflow-hidden" data-bg="{{ bg_key }}" data-text="{{ text_key }}" data-speed="{{ speed_key }}" data-pause-hover="{{ pause_hover }}" data-store="home-promo-marquee">
        <div class="flex h-12 items-center p-2.5">
            <div class="promo-marquee-track flex items-center gap-12">
                {# 4 copias para o loop continuo (-25%); so a 1a e focavel/lida por leitor de tela #}
                {% for copy in [1, 2, 3, 4] %}
                    {% for item in promo_texts %}
                        {% if item[1] %}
                            <a href="{{ item[1] }}" class="promo-marquee-item whitespace-nowrap text-sm font-medium uppercase tracking-wider"{% if copy > 1 %} aria-hidden="true" tabindex="-1"{% endif %}>{{ item[0] }}</a>
                        {% else %}
                            <span class="promo-marquee-item whitespace-nowrap text-sm font-medium uppercase tracking-wider"{% if copy > 1 %} aria-hidden="true"{% endif %}>{{ item[0] }}</span>
                        {% endif %}
                    {% endfor %}
                {% endfor %}
            </div>
        </div>
    </section>

{% endif %}
