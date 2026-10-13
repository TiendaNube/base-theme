<div class="js-advertising-bar advertising-bar w-full h-6 px-6 flex items-center justify-center text-center transition-all duration-300 overflow-hidden">
    {# Check if we have multiple ad texts #}
    {% set has_ad_1 = settings.ad_text %}
    {% set has_ad_2 = settings.ad_text_2 %}
    {% set has_ad_3 = settings.ad_text_3 %}
    {% set ad_count = 0 %}
    {% if has_ad_1 %}{% set ad_count = ad_count + 1 %}{% endif %}
    {% if has_ad_2 %}{% set ad_count = ad_count + 1 %}{% endif %}
    {% if has_ad_3 %}{% set ad_count = ad_count + 1 %}{% endif %}

    {% if ad_count > 1 %}
        {# Multiple ads - rotating carousel #}
        <div class="js-ad-carousel relative w-full h-6">
            {% if has_ad_1 %}
                <div class="js-ad-slide absolute inset-0 px-6 flex items-center justify-center transition-opacity duration-500 opacity-100" data-slide="0">
                    {% if settings.ad_url %}
                        <a href="{{ settings.ad_url | setting_url }}" class="block max-w-full truncate text-xs font-semibold leading-none transition-colors duration-300">
                            {{ settings.ad_text }}
                        </a>
                    {% else %}
                        <span class="block max-w-full truncate text-xs font-semibold leading-none">
                            {{ settings.ad_text }}
                        </span>
                    {% endif %}
                </div>
            {% endif %}
            {% if has_ad_2 %}
                <div class="js-ad-slide absolute inset-0 px-6 flex items-center justify-center transition-opacity duration-500 opacity-0" data-slide="1">
                    {% if settings.ad_url_2 %}
                        <a href="{{ settings.ad_url_2 | setting_url }}" class="block max-w-full truncate text-xs font-semibold leading-none transition-colors duration-300">
                            {{ settings.ad_text_2 }}
                        </a>
                    {% else %}
                        <span class="block max-w-full truncate text-xs font-semibold leading-none">
                            {{ settings.ad_text_2 }}
                        </span>
                    {% endif %}
                </div>
            {% endif %}
            {% if has_ad_3 %}
                <div class="js-ad-slide absolute inset-0 px-6 flex items-center justify-center transition-opacity duration-500 opacity-0" data-slide="2">
                    {% if settings.ad_url_3 %}
                        <a href="{{ settings.ad_url_3 | setting_url }}" class="block max-w-full truncate text-xs font-semibold leading-none transition-colors duration-300">
                            {{ settings.ad_text_3 }}
                        </a>
                    {% else %}
                        <span class="block max-w-full truncate text-xs font-semibold leading-none">
                            {{ settings.ad_text_3 }}
                        </span>
                    {% endif %}
                </div>
            {% endif %}
        </div>
    {% else %}
        {# Single ad - original behavior #}
        {% if settings.ad_url %}
            <a href="{{ settings.ad_url | setting_url }}" class="block max-w-full truncate text-xs font-semibold leading-none transition-colors duration-300">
                {{ settings.ad_text }}
            </a>
        {% else %}
            <span class="block max-w-full truncate text-xs font-semibold leading-none">
                {{ settings.ad_text }}
            </span>
        {% endif %}
    {% endif %}
</div>
