
{# Payments details #}

<div id="single-product" class="js-has-new-shipping js-product-detail js-product-container js-shipping-calculator-container" data-variants="{{product.variants_object | json_encode }}" itemscope itemtype="http://schema.org/Product">
	<meta itemprop="image" content="{{ 'http:' ~ product.featured_image | product_image_url('large') }}" />
    <meta itemprop="url" content="{{ product.social_url }}" />
    {% if page_description %}
        <meta itemprop="description" content="{{ page_description }}" />
    {% endif %}
    {% if product.sku %}
        <meta itemprop="sku" content="{{ product.sku }}" />
    {% endif %}
    {% if product.weight %}
        <div itemprop="weight" itemscope itemtype="http://schema.org/QuantitativeValue" style="display:none;">
            <meta itemprop="unitCode" content="{{ product.weight_unit | iso_to_uncefact}}" />
            <meta itemprop="value" content="{{ product.weight}}" />
        </div>
    {% endif %}

    <div class="container">
        <div class="row section-single-product">
            <div class="col-12 col-md-7 px-0 px-md-3">
            	{% include 'snipplets/product/product-image.tpl' %}
            </div>
            <div class="col">
            	{% include 'snipplets/product/product-form.tpl' %}
            </div>
        </div>
        {% if settings.show_product_fb_comment_box %}
            <div class="fb-comments section-fb-comments" data-href="{{ product.social_url }}" data-num-posts="5" data-width="100%"></div>
        {% endif %}
        <div id="reviewsapp"></div>
    </div>  
</div>
{% include 'snipplets/product/product-related.tpl' %}

