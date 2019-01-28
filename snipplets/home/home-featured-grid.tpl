{# /*============================================================================
  #Home featured grid
==============================================================================*/

#Properties

#Featured Slider

#}

{% set featured_slider = featured_slider | default(false) %}

<div class="row">
    {% if settings.featured_products_title %}
        <div class="col-12 text-center">
            <h3>{{ settings.featured_products_title }}</h3>
        </div>
    {% endif %}
    {% if featured_slider %}
        <div class="col-12">
            <div class="js-swiper-featured swiper-container">
                <div class="swiper-wrapper">
    {% endif %}

    {% for product in sections.primary.products %}
        {% if featured_slider %}
            {% include 'snipplets/grid/item.tpl' with {'slide_item': true} %}
        {% else %}
            {% include 'snipplets/grid/item.tpl' %}
        {% endif %}
    {% endfor %}

    {% if featured_slider %}
                </div>
                <div class="js-swiper-featured-pagination swiper-pagination"></div>
                <div class="js-swiper-featured-prev swiper-button-prev d-none d-sm-block">{% include "snipplets/svg/chevron-left.tpl" with {'big': true} %}</div>
                <div class="js-swiper-featured-next swiper-button-next d-none d-sm-block">{% include "snipplets/svg/chevron-right.tpl" with {'big': true} %}</div>
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