{% if settings.slider or settings.slider is not empty %}
    {% for slide in settings.slider %}
        {% if loop.first %}
            <link rel="preload" as="image" href="{{ slide.image | static_url | settings_image_url('1080p') }}">
        {% endif %}
    {% endfor %}
{% endif %}