<section class="section-banners-home" data-store="banner-home-categories">
    <div class="container{% if settings.banners_full %}-fluid p-0{% endif %}">
        <div class="row {% if settings.banners_full %}no-gutters{% endif %} align-items-center">
            {% set num_banners = 0 %}
            {% for banner in ['banner_01', 'banner_02', 'banner_03'] %}
                {% set banner_show = attribute(settings,"#{banner}_show") %}
                {% set banner_title = attribute(settings,"#{banner}_title") %}
                {% set banner_button_text = attribute(settings,"#{banner}_button") %}
                {% set has_banner =  banner_show and (banner_title or banner_description or "#{banner}.jpg" | has_custom_image) %}
                {% if has_banner %}
                    {% set num_banners = num_banners + 1 %}
                {% endif %}
            {% endfor %}

            {% for banner in ['banner_01', 'banner_02', 'banner_03'] %}
                {% set banner_show = attribute(settings,"#{banner}_show") %}
                {% set banner_title = attribute(settings,"#{banner}_title") %}
                {% set banner_description = attribute(settings,"#{banner}_description") %}
                {% set banner_button_text = attribute(settings,"#{banner}_button") %}
                {% set banner_url = attribute(settings,"#{banner}_url") %}
                {% set has_banner =  banner_show and (banner_title or banner_description or "#{banner}.jpg" | has_custom_image) %}
                {% set has_banner_text =  banner_title or banner_description or banner_button_text %}
                {% if has_banner %}
                    <div class="col-md">
                        <div class="textbanner">
                            {% if banner_url %}
                                <a class="textbanner-link" href="{{ banner_url }}"{% if banner_title %} title="{{ banner_title }}" aria-label="{{ banner_title }}"{% else %} title="{{ 'Banner de' | translate }} {{ store.name }}" aria-label="{{ 'Banner de' | translate }} {{ store.name }}"{% endif %}>
                            {% endif %}
                            <div class="textbanner-image{% if has_banner_text and textoverimage %} overlay{% endif %}">
                                <img class="textbanner-image-background lazyautosizes lazyload blur-up-big" src="{{ "#{banner}.jpg" | static_url | settings_image_url('tiny') }}" data-srcset="{{ "#{banner}.jpg" | static_url | settings_image_url('large') }} 480w, {{ "#{banner}.jpg" | static_url | settings_image_url('huge') }} 640w" data-sizes="auto" data-expand="-10" {% if banner_title %}alt="{{ banner_title }}"{% else %}alt="{{ 'Banner de' | translate }} {{ store.name }}"{% endif %} />
                            </div>
                            <div class="textbanner-text{% if textoverimage %} over-image{% endif %}">
                                {% if banner_title %}
                                    <div class="h1 textbanner-title">{{ banner_title }}</div>
                                {% endif %}
                                {% if banner_description %}
                                    <div class="textbanner-paragraph">{{ banner_description }}</div>
                                {% endif %}
                                {% if banner_url and banner_button_text %}
                                    <button class="btn btn-line btn-small">{{ banner_button_text }}</button>
                                {% endif %}
                            </div>
                            {% if banner_url %}
                                </a>
                            {% endif %}
                        </div>
                    </div>
                {% endif %}
            {% endfor %}
        </div>
    </div>
</section>
