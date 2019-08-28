{# Mobile product detail placeholder: to be hidden after content loaded #}

{# Define sizes of mobile img placeholder based on the tallest element #}

{% set max_product_height = product.featured_image.dimensions['height'] %}
{% set max_product_width = product.featured_image.dimensions['width'] %}

{% if product.images_count > 1 %}
    {% for image in product.images %}
        {% set max_product_height = max(image.dimensions['height'], max_product_height) %}
        {% if image.dimensions['height'] == max_product_height %}
            {% set max_product_width = max(image.dimensions['width'], max_product_width) %}
        {% endif %}
    {% endfor %}
{% endif %}

{% set has_image_sizes = max_product_width > 0 %}

<div class="js-product-slider-placeholder d-md-none product-placeholder-container placeholder-container {% if product.images_count == 1 %}hidden-when-content-ready{% endif %}">
    <div class="p-relative overflow-none" {% if has_image_sizes %}style="padding-bottom: {{ max_product_height / max_product_width * 100}}%;"{% endif %}>
        <div class="product-placeholder img-absolute">
        </div>
    </div>
    <div class="placeholder-icon">
        {% include "snipplets/svg/shopping-bag.tpl" with {svg_custom_class: "icon-inline icon-w-14 icon-8x svg-icon-text"} %}
    </div>
    <div class="placeholder-shine">
    </div>
</div>