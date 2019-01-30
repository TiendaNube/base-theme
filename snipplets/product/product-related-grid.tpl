{# /*============================================================================
  #Product Related Grid
==============================================================================*/

#Properties

#Related Slider

#}

{% set related_slider = related_slider | default(false) %}
{% set related_products_ids = product.metafields.related_products.related_products_ids %}
{% if related_products_ids %}
    {% set related_products = related_products_ids | get_products %}
    {% set show = (related_products | length > 0) %}
{% endif %}
{% if not show %}
    {% set related_products = category.products | shuffle | take(8) %}
    {% set show = (related_products | length > 1) %}
{% endif %}

<div class="row">
    {% if settings.products_related_title %}
        <div class="col-12 text-center">
            <h3>{{ settings.products_related_title }}</h3>
        </div>
    {% endif %}
    {% if related_slider %}
        <div class="col-12">
            <div class="js-swiper-related swiper-container">
                <div class="swiper-wrapper">
    {% endif %}

    {% for related in related_products %}
        {% if product.id != related.id %}
            {% if related_slider %}
                {% include 'snipplets/grid/item.tpl' with {'product': related, 'slide_item': true} %}
            {% else %}
                {% include 'snipplets/grid/item.tpl' with {'product': related} %}
            {% endif %}
        {% endif %}
    {% endfor %}

    {% if related_slider %}
                </div>
                <div class="js-swiper-related-pagination swiper-pagination"></div>
                <div class="js-swiper-related-prev swiper-button-prev">{% include "snipplets/svg/chevron-left.tpl" with {'big': true} %}</div>
                <div class="js-swiper-related-next swiper-button-next">{% include "snipplets/svg/chevron-right.tpl" with {'big': true} %}</div>
            </div>
        </div>
    {% endif %}

    {% if show_help %}
        {% for i in 1..4 %}
            {% if loop.index % 4 == 1 %}
                <div class="grid-row">
            {% endif %}

            <div class="span3">
                <div class="item">
                    <div class="item-image-container">
                        <a href="/admin/products/new" target="_top">{{'placeholder-product.png' | static_url | img_tag}}</a>
                    </div>
                    <div class="item-info-container">
                        <div class="title"><a href="/admin/products/new" target="_top">{{"Producto" | translate}}</a></div>
                        <div class="price">{{"$0.00" | translate}}</div>
                    </div>
                </div>
            </div>

            {% if loop.index % 4 == 0 or loop.last %}
                </div>
            {% endif %}
        {% endfor %}
    {% endif %}
</div>