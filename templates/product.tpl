{# The page paints its own background: `body` sets no background-color anywhere
   in the theme (style-critical.tpl only sets margin/font-size), so without this
   wrapper the PDP falls back to the browser white instead of the theme's
   --background-color. Wraps the related-products section too, so no white strip
   is left below #single-product. #}
<div class="bg-bg">

{# Payments details #}
<div id="single-product" class="js-has-new-shipping js-product-detail js-product-container js-shipping-calculator-container" data-variants="{{product.variants_object | json_encode }}" data-store="product-detail">
    <div class="px-4 md:px-16 lg:px-0 lg:max-w-[1440px] lg:mx-auto">
        <div class="flex flex-col lg:flex-row lg:items-start">
            <div class="w-full lg:w-[876px]" data-store="product-image-{{ product.id }}">
            	{% include 'snipplets/product/product-image.tpl' %}
            </div>
            <div class="w-full lg:w-[564px]" data-store="product-info-{{ product.id }}">
            	{% include 'snipplets/product/product-form.tpl' %}
            </div>
        </div>
        {% if settings.show_product_fb_comment_box %}
            <div class="fb-comments section-fb-comments" data-href="{{ product.social_url }}" data-num-posts="5" data-width="100%"></div>
        {% endif %}
        <div id="reviewsapp"></div>
    </div>
</div>

{# Related products #}
{% include 'snipplets/product/product-related.tpl' %}

{# End of page: white + seed + white before the footer. The related block already has a 70px bottom margin, which acts as the first white. #}
{% include 'snipplets/home/home-divider.tpl' with {type: 'seed'} %}
{% include 'snipplets/home/home-divider.tpl' with {type: 'white'} %}

</div>
