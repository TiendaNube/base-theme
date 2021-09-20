{# /*============================================================================
  #Product Related Grid
==============================================================================*/

#Properties

#Related Slider

#}

{% set related_products = [] %}
{% set related_products_ids_from_app = product.metafields.related_products.related_products_ids %}
{% set has_related_products_from_app = related_products_ids_from_app | get_products | length > 0 %}
{% if has_related_products_from_app %}
    {% set related_products = related_products_ids_from_app | get_products %}
{% endif %}
{% if related_products is empty %}
    {% set max_related_products_length = 8 %}
    {% set max_related_products_achieved = false %}
    {% set related_products_without_stock = [] %}
    {% set max_related_products_without_achieved = false %}
    
    {% set products_from_category = category.products | shuffle %}
    {% for product_from_category in products_from_category if not max_related_products_achieved and product_from_category.id != product.id %}
        {%  if product_from_category.stock is null or product_from_category.stock > 0 %}
            {% set related_products = related_products | merge([product_from_category]) %}
        {% elseif (related_products_without_stock | length < max_related_products_length) %}
            {% set related_products_without_stock = related_products_without_stock | merge([product_from_category]) %}
        {% endif %}
        {%  if (related_products | length == max_related_products_length) %}
            {% set max_related_products_achieved = true %}
        {% endif %}
    {% endfor %}
    {% if (related_products | length < max_related_products_length) %}
        {% set number_of_related_products_for_refill = max_related_products_length - (related_products | length) %}
        {% set related_products_for_refill = related_products_without_stock | take(number_of_related_products_for_refill) %}
        
        {% set related_products = related_products | merge(related_products_for_refill)  %}
    {% endif %}
{% endif %}

<section id="related-products" class="section-products-related">
    {% if related_products | length > 0 %}
        <div class="container">
            <div class="row">
                {% if settings.products_related_title %}
                    <div class="col-12 text-center">
                        <h3>{{ settings.products_related_title }}</h3>
                    </div>
                {% endif %}
                <div class="col-12">
                    <div class="js-swiper-related swiper-container">
                        <div class="swiper-wrapper">
                            {% for related in related_products %}
                                {% include 'snipplets/grid/item.tpl' with {'product': related, 'slide_item': true} %}
                            {% endfor %}
                        </div>
                        {% if related_products | length < 4 %}
                        <div class="d-md-none">
                        {% endif %}
                            <div class="js-swiper-related-pagination swiper-pagination"></div>
                            <div class="js-swiper-related-prev swiper-button-prev">{% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: "icon-inline icon-w-8 icon-2x svg-icon-text"} %}</div>
                            <div class="js-swiper-related-next swiper-button-next">{% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline icon-w-8 icon-2x svg-icon-text"} %}</div>
                        {% if related_products | length < 4 %}
                        </div>
                        {% endif %}
                    </div>
                </div>
            </div>
        </div>
    {% endif %}
</section>