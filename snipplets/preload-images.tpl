{% set has_main_slider = settings.slider and settings.slider is not empty %}
{% set has_mobile_slider = settings.toggle_slider_mobile and settings.slider_mobile and settings.slider_mobile is not empty %}

{% if has_mobile_slider %}
    {% set slider = settings.slider_mobile %}
{% else %}
    {% set slider = settings.slider %}
{% endif %}

{% if has_main_slider or has_mobile_slider %}
    {% for slide in slider %}
        {% if loop.first %}
            <link rel="preload" as="image" href="{{ slide.image | static_url | settings_image_url('xlarge') }}" imagesrcset="{{ slide.image | static_url | settings_image_url('xlarge') }} 1400w, {{ slide.image | static_url | settings_image_url('1080p') }} 1920w">
        {% endif %}
    {% endfor %}
{% endif %}