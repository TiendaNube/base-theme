{# /*============================================================================
  #Item grid
==============================================================================*/

#Properties

#Slide Item

#}

{% set slide_item = slide_item | default(false) %}
{% set columns = settings.grid_columns %}

{# Item image slider #}

{% set show_image_slider = 
    (template == 'category' or template == 'search')
    and settings.product_item_slider 
    and not reduced_item
    and not slide_item
    and not has_filters
    and product.other_images
%}

{% if show_image_slider %}
    {% set slider_controls_container_class = 'item-slider-controls-container d-none d-md-block' %}
    {% set slider_control_class = 'icon-inline icon-w-8 icon-2x svg-icon-text' %}
    {% set control_prev = include ('snipplets/svg/chevron-left.tpl', {svg_custom_class: slider_control_class}) %}
    {% set control_next = include ('snipplets/svg/chevron-right.tpl', {svg_custom_class: slider_control_class}) %}
{% endif %}

{# Secondary images #}

{% set show_secondary_image = settings.product_hover %}

<div class="js-item-product {% if slide_item %}js-item-slide swiper-slide{% else %}col{% if columns == 2 %}-6 col-md-3{% else %}-12 col-md-4{% endif %}{% endif %} item item-product{% if not product.display_price %} no-price{% endif %} {% if reduced_item %}item-product-reduced{% endif %}" data-product-type="list" data-product-id="{{ product.id }}" data-store="product-item-{{ product.id }}" data-component="product-list-item" data-component-value="{{ product.id }}">

    {% if (settings.quick_shop or settings.product_color_variants) and not reduced_item %}
        <div class="js-product-container js-quickshop-container {% if product.variations %}js-quickshop-has-variants{% endif %}" data-variants="{{ product.variants_object | json_encode }}" data-quickshop-id="quick{{ product.id }}{% if slide_item and section_name %}-{{ section_name }}{% endif %}">
    {% endif %}

        {% set product_url_with_selected_variant = has_filters ?  ( product.url | add_param('variant', product.selected_or_first_available_variant.id)) : product.url  %}

        {% set image_classes = 'js-item-image lazyload img-absolute img-absolute-centered fade-in' %}
        {% set data_expand = show_image_slider ? '50' : '-10' %}

        {% set floating_elements %}
            {% if not reduced_item %}
                {% if settings.product_color_variants %}
                    {% include 'snipplets/labels.tpl' with {color: true} %}
                    {% include 'snipplets/grid/item-colors.tpl' %}
                {% else %}
                    {% include 'snipplets/labels.tpl' %}
                {% endif %}
            {% endif %}
        {% endset %}

        {{ component(
            'product-item-image', {
                image_lazy: true,
                image_lazy_js: true,
                image_thumbs: ['small', 'medium', 'large', 'huge', 'original'],
                image_data_expand: data_expand,
                image_secondary_data_sizes: 'auto',
                secondary_image: show_secondary_image,
                slider: show_image_slider,
                placeholder: true,
                svg_sprites: false,
                custom_content: floating_elements,
                product_item_image_classes: {
                    image_container: 'item-image mb-2',
                    image_padding_container: 'p-relative',
                    image: image_classes,
                    image_featured: 'item-image-featured',
                    image_secondary: 'item-image-secondary',
                    slider_container: 'swiper-container position-absolute h-100 w-100',
                    slider_wrapper: 'swiper-wrapper',
                    slider_slide: 'swiper-slide item-image-slide',
                    slider_control_pagination: 'swiper-pagination item-slider-pagination font-small d-md-none',
                    slider_control: 'fa-lg svg-icon-primary',
                    slider_control_prev_container: 'swiper-button-prev ' ~ slider_controls_container_class,
                    slider_control_next_container: 'swiper-button-next ' ~ slider_controls_container_class,
                    more_images_message: 'item-more-images-message font-small',
                    placeholder: 'placeholder-fade',
                },
                custom_control_prev: control_prev,
                custom_control_next: control_next,
            })
        }}

        {% if 
            ((settings.quick_shop and not product.isSubscribable()) or settings.product_color_variants)
            and product.available 
            and product.display_price 
            and product.variations and not reduced_item 
        %}

            {# Hidden product form to update item image and variants: Also this is used for quickshop popup #}
            
            <div class="js-item-variants hidden">
                <form class="js-product-form" method="post" action="{{ store.cart_url }}">
                    <input type="hidden" name="add_to_cart" value="{{product.id}}" />
                    {% if product.variations %}
                        {% include "snipplets/product/product-variants.tpl" with {quickshop: true} %}
                    {% endif %}
                    {% if product.available and product.display_price and settings.quick_shop %}
                        {% include "snipplets/product/product-quantity.tpl" with {quickshop: true} %}
                    {% endif %}
                    {% set state = store.is_catalog ? 'catalog' : (product.available ? product.display_price ? 'cart' : 'contact' : 'nostock') %}
                    {% set texts = {'cart': "Agregar al carrito", 'contact': "Consultar precio", 'nostock': "Sin stock", 'catalog': "Consultar"} %}

                    {# Add to cart CTA #}

                    <input type="submit" class="js-addtocart js-prod-submit-form btn btn-primary btn-block mx-auto {{ state }}" value="{{ texts[state] | translate }}" {% if state == 'nostock' %}disabled{% endif %} />

                    {# Fake add to cart CTA visible during add to cart event #}

                    {% include 'snipplets/placeholders/button-placeholder.tpl' with {custom_class: "btn-block mx-auto"} %}

                </form>
            </div>

        {% endif %}
        <div class="item-description" data-store="product-item-info-{{ product.id }}">
            <a href="{{ product_url_with_selected_variant }}" title="{{ product.name }}" class="item-link">
                <div class="js-item-name item-name mb-1" data-store="product-item-name-{{ product.id }}">{{ product.name }}</div>
                {% if product.display_price %}
                    <div class="item-price-container mb-1" data-store="product-item-price-{{ product.id }}">
                        {% if not reduced_item %}
                            <span class="js-compare-price-display price-compare" {% if not product.compare_at_price or not product.display_price %}style="display:none;"{% else %}style="display:inline-block;"{% endif %}>
                                {{ product.compare_at_price | money }}
                            </span>
                        {% endif %}
                        <span class="js-price-display item-price">
                            {{ product.price | money }}
                        </span>

                    </div>
                {% endif %}
            </a>
        </div>

        {{ component('payment-discount-price', {
                visibility_condition: settings.payment_discount_price and not reduced_item,
                location: 'product',
                container_classes: "text-accent mb-2",
            }) 
        }}

        {% if not reduced_item %}
            {{ component('installments', {'location' : 'product_item', container_classes: { installment: "item-installments"}}) }}
        {% endif %}

        {{ component('subscriptions/subscription-message', {
            subscription_classes: {
                container: 'text-accent mt-2',
            },
        }) }}

        {% if settings.quick_shop and product.available and product.display_price and not reduced_item %}

            {# Trigger quickshop actions #}

            {% set quickshop_button_classes = 'btn btn-primary btn-small px-4 mb-1 mx-auto' %}

            {% set state = store.is_catalog ? 'catalog' : (product.available ? product.display_price ? 'cart' : 'contact' : 'nostock') %}
            {% set texts = {'cart': "Agregar al carrito", 'contact': "Consultar precio", 'nostock': "Sin stock", 'catalog': "Consultar"} %}
            
            <div class="item-actions mt-2">

                {% if product.isSubscribable() %}

                    {# Product with subscription will link to the product page #}

                    <a href="{{ product_url_with_selected_variant }}" class="{{ quickshop_button_classes }}" title="{{ 'Compra rápida de' | translate }} {{ product.name }}" aria-label="{{ 'Compra rápida de' | translate }} {{ product.name }}">{{ texts[state] | translate }}</a>
                {% else %}

                    {% if product.variations %}

                        {# Open quickshop popup if has variants #}

                        <a data-toggle="#quickshop-modal" data-modal-url="modal-fullscreen-quickshop" class="js-quickshop-modal-open {% if slide_item %}js-quickshop-slide{% endif %} js-modal-open js-fullscreen-modal-open {{ quickshop_button_classes }}" title="{{ 'Compra rápida de' | translate }} {{ product.name }}" aria-label="{{ 'Compra rápida de' | translate }} {{ product.name }}" data-component="product-list-item.add-to-cart" data-component-value="{{product.id}}">{{ 'Agregar al carrito' | translate }}</a>
                    {% else %}

                        {# If not variants add directly to cart #}
                        <form class="js-product-form" method="post" action="{{ store.cart_url }}">
                            <input type="hidden" name="add_to_cart" value="{{product.id}}" />
                            

                            <input type="number" name="quantity" value="1" class="js-quantity-input hidden" aria-label="{{ 'Cambiar cantidad' | translate }}" >

                            <input type="submit" class="js-addtocart js-prod-submit-form {{ quickshop_button_classes }} {{ state }}" value="{{ texts[state] | translate }}" {% if state == 'nostock' %}disabled{% endif %} data-component="product-list-item.add-to-cart" data-component-value="{{ product.id }}"/>

                            {# Fake add to cart CTA visible during add to cart event #}

                            {% include 'snipplets/placeholders/button-placeholder.tpl' with {custom_class: "js-addtocart-placeholder-inline btn-small mb-1 mx-auto"} %}

                        </form>
                    {% endif %}
                {% endif %}
            </div>
        {% endif %}

        {# Structured data to provide information for Google about the product content #}
        {{ component('structured-data', {'item': true}) }}
    {% if (settings.quick_shop or settings.product_color_variants) and not reduced_item %}
        </div>
    {% endif %}
</div>