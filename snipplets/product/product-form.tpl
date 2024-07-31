{# Product name and breadcrumbs #}

{% embed "snipplets/page-header.tpl" %}
	{% block page_header_text %}{{ product.name }}{% endblock page_header_text %}
{% endembed %}

{# Product price #}

<div class="price-container text-center text-md-left" data-store="product-price-{{ product.id }}">
    <span class="d-inline-block mb-2">
	   <h4 id="compare_price_display" class="js-compare-price-display price-compare mb-0" {% if not product.compare_at_price or not product.display_price %}style="display:none;"{% else %} style="display:block;"{% endif %}>{% if product.compare_at_price and product.display_price %}{{ product.compare_at_price | money }}{% endif %}</h4>
    </span>
    <span class="d-inline-block">
    	<h4 class="js-price-display mb-0" id="price_display" {% if not product.display_price %}style="display:none;"{% endif %}>{% if product.display_price %}{{ product.price | money }}{% endif %}</h4>
    </span>
    {{ component('payment-discount-price', {
            visibility_condition: settings.payment_discount_price,
            location: 'product',
            container_classes: "h6 text-accent mb-3",
        }) 
    }}
</div>

{# Promotional text #}

{% if product.promotional_offer and not product.promotional_offer.script.is_percentage_off and product.display_price %}
    <div class="js-product-promo-container text-center text-md-left" data-store="product-promotion-info">
        {% if product.promotional_offer.script.is_discount_for_quantity %}
            {% for threshold in product.promotional_offer.parameters %}
                <h4 class="mb-2 text-accent"><strong>{{ "¡{1}% OFF comprando {2} o más!" | translate(threshold.discount_decimal_percentage * 100, threshold.quantity) }}</strong></h4>
            {% endfor %}
        {% else %}
            <h4 class="mb-2 text-accent"><strong>{{ "¡Llevá {1} y pagá {2}!" | translate(product.promotional_offer.script.quantity_to_take, product.promotional_offer.script.quantity_to_pay) }}</strong></h4> 
        {% endif %}
        {% if product.promotional_offer.scope_type == 'categories' %}
            <p>{{ "Válido para" | translate }} {{ "este producto y todos los de la categoría" | translate }}:  
            {% for scope_value in product.promotional_offer.scope_value_info %}
               {{ scope_value.name }}{% if not loop.last %}, {% else %}.{% endif %}
            {% endfor %}</br>{{ "Podés combinar esta promoción con otros productos de la misma categoría." | translate }}</p>
        {% elseif product.promotional_offer.scope_type == 'all'  %}
            <p>{{ "Vas a poder aprovechar esta promoción en cualquier producto de la tienda." | translate }}</p>
        {% endif %}  
    </div> 
{% endif %}

{# Product installments #}

{% set installments_info = product.installments_info_from_any_variant %}
{% set hasDiscount = product.maxPaymentDiscount.value > 0 %}
{% set show_payments_info = product.show_installments and product.display_price and installments_info %}

{% if show_payments_info or hasDiscount %}

    <div data-toggle="#installments-modal" data-modal-url="modal-fullscreen-payments" class="js-modal-open js-fullscreen-modal-open js-product-payments-container mb-2" {% if not (product.get_max_installments and product.get_max_installments(false)) %}style="display: none;"{% endif %}>

        {# Max Payment Discount #}

        {% set hideDiscountContainer = not (hasDiscount and product.showMaxPaymentDiscount) %}
        {% set hideDiscountDisclaimer = not product.showMaxPaymentDiscountNotCombinableDisclaimer %}

        <div class="js-product-discount-container text-center text-md-left mb-2" {% if hideDiscountContainer %}style="display: none;"{% endif %}>
            <span><strong class="text-accent">{{ product.maxPaymentDiscount.value }}% {{'de descuento' | translate }}</strong> {{'pagando con' | translate }} {{ product.maxPaymentDiscount.paymentProviderName }}</span>
            <div class="js-product-discount-disclaimer font-small mt-1" {% if hideDiscountDisclaimer %}style="display: none;"{% endif %}>
                {{ "No acumulable con otras promociones" | translate }}
            </div>
        </div>

        {# Installments #}

        {% if show_payments_info %}
            {% set max_installments_without_interests = product.get_max_installments(false) %}
            {% set installments_without_interests = max_installments_without_interests and max_installments_without_interests.installment > 1 %}
            {% set installment_text_weigth = installments_without_interests ? 'font-weight-bold' : '' %}
            {{ component('installments', {'location' : 'product_detail', container_classes: { installment: "product-detail-installments text-center text-md-left mb-2 " ~ installment_text_weigth}}) }}
        {% endif %}

        <div class="form-row align-items-center align-items-start-md mb-4">
            {% set has_payment_logos = settings.payments %}
            {% if has_payment_logos %}
              <ul class="list-inline col col-md-auto text-center text-md-left">
                {% for payment in settings.payments %}
                    {# Payment methods flags #}
                    {% if store.country == 'BR' %}
                      {% if payment in ['visa', 'mastercard'] %}
                        <li>     
                          {{ payment | payment_new_logo | img_tag('',{class: 'card-img card-img-small lazyload'}) }}
                        </li>
                      {% endif %}
                    {% else %}
                        {% if payment in ['visa', 'amex', 'mastercard'] %}
                          <li>
                            {{ payment | payment_new_logo | img_tag('',{class: 'card-img card-img-small lazyload'}) }}
                          </li>
                        {% endif %}
                    {% endif %}
                {% endfor %}
                  <li>
                    {% include "snipplets/svg/credit-card-blank.tpl" with {svg_custom_class: "icon-inline icon-w-18 icon-2x " ~ card_icon_color ~ ""} %}
                  </li>
              </ul>
            {% endif %}
            <div class="col-12 col-md-auto text-center">
                <a id="btn-installments" class="btn-link" {% if not (product.get_max_installments and product.get_max_installments(false)) %}style="display: none;"{% endif %}>
                    {{ "Ver medios de pago" | translate }}
                </a>
            </div>
        </div>
    </div>

{% endif %}

{# Product form, includes: Variants, CTA and Shipping calculator #}

 <form id="product_form" class="js-product-form" method="post" action="{{ store.cart_url }}" data-store="product-form-{{ product.id }}">
	<input type="hidden" name="add_to_cart" value="{{product.id}}" />
 	{% if product.variations %}
        {% include "snipplets/product/product-variants.tpl" with {show_size_guide: true} %}
    {% endif %}

    {% if product.available and product.display_price %}
        {% include "snipplets/product/product-quantity.tpl" %}
    {% endif %}
    {% set state = store.is_catalog ? 'catalog' : (product.available ? product.display_price ? 'cart' : 'contact' : 'nostock') %}
    {% set texts = {'cart': "Agregar al carrito", 'contact': "Consultar precio", 'nostock': "Sin stock", 'catalog': "Consultar"} %}

    {# Add to cart CTA #}

    <div class="mb-4">

        <input type="submit" class="js-addtocart js-prod-submit-form btn btn-primary btn-block mb-4 {{ state }}" value="{{ texts[state] | translate }}" {% if state == 'nostock' %}disabled{% endif %} data-store="product-buy-button" data-component="product.add-to-cart"/>

        {# Fake add to cart CTA visible during add to cart event #}

        {% include 'snipplets/placeholders/button-placeholder.tpl' with {custom_class: "btn-block mb-4"} %}

        <div class="js-added-to-cart-product-message float-leftt w-100 mb-3 text-center text-md-left" style="display: none;">
            {{'Ya agregaste este producto.' | translate }}<a href="#" class="js-modal-open js-fullscreen-modal-open btn btn-link ml-1" data-toggle="#modal-cart" data-modal-url="modal-fullscreen-cart">{{ 'Ver carrito' | translate }}</a>
        </div>

    </div>

    {# Define contitions to show shipping calculator and store branches on product page #}

    {% set show_product_fulfillment = settings.shipping_calculator_product_page and (store.has_shipping or store.branches) and not product.free_shipping and not product.is_non_shippable %}

    {% if show_product_fulfillment %}

        <div class="divider"></div>

        {# Shipping calculator and branch link #}

        <div id="product-shipping-container" class="product-shipping-calculator list" {% if not product.display_price or not product.has_stock %}style="display:none;"{% endif %} data-shipping-url="{{ store.shipping_calculator_url }}">

            {# Shipping Calculator #}
            
            {% if store.has_shipping %}
                {% include "snipplets/shipping/shipping-calculator.tpl" with {'shipping_calculator_variant' : product.selected_or_first_available_variant, 'product_detail': true} %}
            {% endif %}

            {% if store.branches %}
                
                {# Link for branches #}
                {% include "snipplets/shipping/branches.tpl" with {'product_detail': true} %}
            {% endif %}
        </div>
        <div class="divider"></div>
    {% endif %} 
 </form>

{# Product payments details #}

{% include 'snipplets/product/product-payment-details.tpl' %}

{# Product share #}

{% include 'snipplets/social/social-share.tpl' %}

{# Product description #}

{% if product.description is not empty %}
    <div class="product-description user-content" data-store="product-description-{{ product.id }}">
        <h5 class="my-3">{{ "Descripción" | translate }}</h5>
        {{ product.description }}
    </div>
{% endif %}

