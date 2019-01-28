{# /*============================================================================
  #Item grid
==============================================================================*/

#Properties

#Slide Item

#}

{% set slide_item = slide_item | default(false) %}
{% set columns = settings.grid_columns %}

<div class="{% if slide_item %}swiper-slide{% else %}col{% if columns == 2 %}-6 col-sm-3{% else %}-12 col-sm-4{% endif %}{% endif %} item item-product{% if not product.display_price %} no-price{% endif %}">
    {% set product_url_with_selected_variant = has_filters ?  ( product.url | add_param('variant', product.selected_or_first_available_variant.id)) : product.url  %}
    <div class="item-image mb-2">
        <div style="padding-bottom: {{ product.featured_image.dimensions['height'] / product.featured_image.dimensions['width'] * 100}}%;" class="p-relative">
            <a href="{{ product_url_with_selected_variant }}" title="{{ product.name }}">
                <img alt="{{ product.featured_image.alt }}" data-sizes="auto" src="{{ product.featured_image | product_image_url('tiny')}}" data-srcset="{{ product.featured_image | product_image_url('small')}} 240w, {{ product.featured_image | product_image_url('medium')}} 320w, {{ product.featured_image | product_image_url('large')}} 480w" class="lazyautosizes lazyload img-absolute img-absolute-centered blur-up" /> 
            </a>
            {% include 'snipplets/labels.tpl' %}
        </div>
    </div>
    <div class="item-description">
        <a href="{{ product_url_with_selected_variant }}" title="{{ product.name }}" class="item-link">
            <div itemprop="name" class="item-name mb-1">{{ product.name }}</div>
            <meta itemprop="url" content="{{ product.url }}" />
            {% if product.display_price %}
                <div class="item-price-container mb-1" itemprop="offers" itemscope itemtype="http://schema.org/Offer">
                    <meta itemprop="priceCurrency" content="{{ product.currency }}" />
                    {% if product.compare_at_price %}
                        <span class="price-compare">
                            {{ product.compare_at_price | money }}
                        </span>
                    {% endif %}
                    <span class="item-price" itemprop="price" content="{{ product.price / 100 }}">
                        {{ product.price | money }}
                    </span>
                </div>
            {% endif %}
        </a>
    </div>
    {% include 'snipplets/payments/installments.tpl' %}
</div>