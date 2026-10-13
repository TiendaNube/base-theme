{# Home: no preload. The slider/categories/modules LCP preloads went with those legacy sections (Fibery task 293). #}
{% if template == 'product' %}

    {# Preload product LCP image #}

    {% for image in product.images %}
        {% if loop.first %}
            <link rel="preload" as="image" href="{{ image | product_image_url('large') }}" imagesrcset="{{ image | product_image_url('large') }} 480w, {{ image | product_image_url('huge') }} 640w, {{ image | product_image_url('original') }} 1024w">
        {% endif %}
    {% endfor %}
{% elseif template == 'category' %}

    {# Preload category LCP image #}

    {% set category_banner = (category.images is not empty) or ("banner-products.jpg" | has_custom_image) %}
    
    {% if category_banner %}

        {% set image_sizes = ['large', 'huge', 'original', '1080p'] %}
        {% set category_images = [] %}
        {% set has_category_images = category.images is not empty %}

        {% for size in image_sizes %}
            {% if has_category_images %}
                {# Define images for admin categories #}
                {% set category_images = category_images|merge({(size):(category.images | first | category_image_url(size))}) %}
            {% else %}
                {# Define images for general banner #}
                {% set category_images = category_images|merge({(size):('banner-products.jpg' | static_url | settings_image_url(size))}) %}
            {% endif %}
        {% endfor %}

        <link rel="preload" as="image" href="{{ category_images['large'] }}" imagesrcset="{{ category_images['large'] }} 480w, {{ category_images['huge'] }} 640w, {{ category_images['original'] }} 1024w, {{ category_images['1080p'] }} 1920w">

    {% endif %}

{% endif %}