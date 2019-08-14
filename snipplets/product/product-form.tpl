{# Product name and breadcrumbs #}

<div itemprop="name">
    {% embed "snipplets/page-header.tpl" %}
    	{% block page_header_text %}{{ product.name }}{% endblock page_header_text %}
    {% endembed %}
</div>

{# Product price #}

<div class="price-container text-center text-sm-left" itemprop="offers" itemscope itemtype="http://schema.org/Offer">
    <span class="d-inline-block">
	   <h4 id="compare_price_display" class="js-compare-price-display price-compare {% if product_can_show_installments or (product.promotional_offer and not product.promotional_offer.script.is_percentage_off) %}mb-2{% endif %}" {% if not product.compare_at_price or not product.display_price %}style="display:none;"{% else %} style="display:block;"{% endif %}>{% if product.compare_at_price and product.display_price %}{{ product.compare_at_price | money }}{% endif %}</h4>
    </span>
    <spa class="d-inline-block">
    	<h4 class="js-price-display {% if product_can_show_installments or (product.promotional_offer and not product.promotional_offer.script.is_percentage_off) %}mb-2{% endif %}" id="price_display" itemprop="price"{% if product.display_price %} content="{{ product.price / 100 }}"{% endif %} {% if not product.display_price %}style="display:none;"{% endif %}>{% if product.display_price %}{{ product.price | money }}{% endif %}</h4>
    </span>
	<meta itemprop="priceCurrency" content="{{ product.currency }}" />
	{% if product.stock_control %}
        <meta itemprop="inventoryLevel" content="{{ product.stock }}" />
        <meta itemprop="availability" href="http://schema.org/{{ product.stock ? 'InStock' : 'OutOfStock' }}" content="http://schema.org/{{ product.stock ? 'InStock' : 'OutOfStock' }}" />
    {% endif %}
</div>

{# Promotional text #}

{% if product.promotional_offer and not product.promotional_offer.script.is_percentage_off and product.display_price %}
    <div class="js-product-promo-container text-center text-sm-left">
        {% if product.promotional_offer.script.is_discount_for_quantity %}
            {% for threshold in product.promotional_offer.parameters %}
                <h4 class="mb-2"><strong>{{ "¡{1}% OFF comprando {2} o más!" | translate(threshold.discount_decimal_percentage * 100, threshold.quantity) }}</strong></h4>
            {% endfor %}
        {% else %}
            <h4 class="mb-2"><strong>{{ "¡Llevá {1} y pagá {2}!" | translate(product.promotional_offer.script.quantity_to_take, product.promotional_offer.script.quantity_to_pay) }}</strong></h4> 
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

{% include "snipplets/payments/installments.tpl" with {'product_detail' : true} %}

{# Product form, includes: Variants, CTA and Shipping calculator #}

 <form id="product_form" class="js-product-form" method="post" action="{{ store.cart_url }}">
	<input type="hidden" name="add_to_cart" value="{{product.id}}" />
 	{% if product.variations %}
        {% include "snipplets/product/product-variants.tpl" %}
    {% endif %}

    {% if product.available and product.display_price %}
        {% include "snipplets/product/product-quantity.tpl" %}
    {% endif %}
    {% set state = store.is_catalog ? 'catalog' : (product.available ? product.display_price ? 'cart' : 'contact' : 'nostock') %}
    {% set texts = {'cart': "Agregar al carrito", 'contact': "Consultar precio", 'nostock': "Sin stock", 'catalog': "Consultar"} %}
    <input type="submit" class="js-addtocart js-prod-submit-form btn btn-primary btn-block mb-4 {{ state }}" value="{{ texts[state] | translate }}" {% if state == 'nostock' %}disabled{% endif %} />

    {% if settings.shipping_calculator_product_page and not product.free_shipping %}

        <div class="divider"></div>

        {# Shipping calculator and branch link #}

        <div id="product-shipping-container" class="product-shipping-calculator list" {% if not product.display_price or not product.has_stock %}style="display:none;"{% endif %}>

            {# Shipping Calculator #}
            
            {% if store.has_shipping %}
                {% include "snipplets/shipping/shipping-calculator.tpl" with {'shipping_calculator_show': settings.shipping_calculator_cart_page and not product.free_shipping, 'shipping_calculator_variant' : product.selected_or_first_available_variant} %}
            {% endif %}

            {% if store.branches and store.country != 'BR' %}
                
                {# Link for branches #}
                {% include "snipplets/shipping/branches.tpl" with {'product_detail': true} %}
            {% endif %}
        </div>
        <div class="divider"></div>
    {% endif %} 
 </form>

{# Product payments details #}

{% include 'snipplets/payments/payments.tpl' %}

{# Product share #}

{% include 'snipplets/social/social-share.tpl' %}

{# Product description #}

{% if product.description is not empty %}
    <div class="product-description user-content">
        <h5 class="my-3">{{ "Descripción" | translate }}</h5>
        {{ product.description }}
    </div>
{% endif %}

