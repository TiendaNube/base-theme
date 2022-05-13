{% if settings.slider or settings.slider is not empty %}
    {% for slide in settings.slider %}
        {% if loop.first %}
            <link rel="preload" as="image" href="{{ slide.image | static_url | settings_image_url('xlarge') }}" imagesrcset="{{ slide.image | static_url | settings_image_url('xlarge') }} 1400w, {{ slide.image | static_url | settings_image_url('1080p') }} 1920w">
        {% endif %}
    {% endfor %}
{% endif %}