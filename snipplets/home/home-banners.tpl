<section class="section-banners-home">
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
                    <div class="col-sm">
                        <div class="textbanner">
                            {% if banner_url %}
                                <a class="textbanner-link" href="{{ banner_url }}"{% if banner_title %} alt="{{ banner_title }}" title="{{ banner_title }}"{% endif %}>
                            {% endif %}
                            {% if store.thumbnails_enabled %}
                                <div class="textbanner-image{% if has_banner_text and textoverimage %} overlay{% endif %} lazyautosizes lazyload blur-up"{% if "#{banner}.jpg" | has_custom_image %} data-bgset='{{ "#{banner}.jpg" | static_url | settings_image_url('large') }} 480w, {{ "#{banner}.jpg" | static_url | settings_image_url('huge') }} 640w' data-sizes="auto" style="background-image: url({{ "#{banner}.jpg" | static_url | settings_image_url('tiny') }});"{% endif %}>
                            {% else %}
                                <div class="textbanner-image{% if has_banner_text and textoverimage %} overlay{% endif %} lazyload blur-up"{% if "#{banner}.jpg" | has_custom_image %} data-bg='{{ "#{banner}.jpg" | static_url }}' style="background-image: url({{ "#{banner}.jpg" | static_url | settings_image_url('tiny') }});" {% endif %}>
                            {% endif %}
                            </div>
                            <div class="textbanner-text{% if textoverimage %} over-image{% endif %}">
                                {% if banner_title %}
                                    <div class="h1 textbanner-title">{{ banner_title }}</div>
                                {% endif %}
                                {% if banner_description %}
                                    <div class="textbanner-paragraph">{{ banner_description }}</div>
                                {% endif %}
                                {% if banner_url and banner_button_text %}
                                    <div class="btn btn-line btn-small">{{ banner_button_text }}</div>
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
