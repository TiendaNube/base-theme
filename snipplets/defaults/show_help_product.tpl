<div id="single-product">
    <div class="container">
        <div class="row section-single-product">
            <div class="col-12 col-md-7 px-0 px-md-3">
                <div class="js-swiper-product-demo swiper-container">
                    <div class="labels">
                        <div class="label label-primary">{{ "35% OFF" | translate }}</div>
                    </div>
                    <div class="swiper-wrapper">
                         <div class="swiper-slide js-product-slide slider-slide">
                            <div class="d-block p-relative">
                                {{ component('placeholders/product-placeholder',{
                                        type: 'dress',
                                    })
                                }}
                            </div>
                         </div>
                         <div class="swiper-slide js-product-slide slider-slide">
                            <div class="d-block p-relative">
                                {{ component('placeholders/product-placeholder',{
                                        type: 'dress',
                                        color: 'green',
                                    })
                                }}
                            </div>
                         </div>
                         <div class="swiper-slide js-product-slide slider-slide">
                            <div class="d-block p-relative">
                                {{ component('placeholders/product-placeholder',{
                                        type: 'dress',
                                        color: 'red',
                                    })
                                }}
                            </div>
                         </div>
                    </div>
                    <div class="js-swiper-product-demo-pagination swiper-pagination"></div>
                </div>
            </div>
            <div class="col">
                {# Product name and breadcrumbs #}

                <section class="page-header mt-3">
                    <div class="breadcrumbs">
                        <a class="crumb" href="{{ store.url }}" title="{{ store.name }}">{{ "Inicio" | translate }}</a>
                        <span class="divider mr-1">></span>
                        <a class="crumb" href="{{ store.products_url }}" title="{{ "Productos" | translate }}">{{ "Productos" | translate }}</a>
                        <span class="divider mr-1">></span>
                        <span class="crumb active">{{ "Producto de ejemplo" | translate }}</span>
                    </div>
                    <h1>{{ "Producto de ejemplo" | translate }}</h1>
                </section>

                {# Product price #}

                {% if store.country == 'BR' %}
                    <div class="price-container">
                        <span class="d-inline-block">
                           <h4 id="compare_price_display" class="price-compare">{{"28000" | money }}</h4>
                        </span>
                        <span class="d-inline-block mr-3">
                            <h4 class="js-price-display text-primary" id="price_display">{{"18200" | money }}</h4>
                        </span>
                    </div>
                {% else %}
                    <div class="price-container">
                        <span class="d-inline-block">
                           <h4 id="compare_price_display" class="price-compare">{{"280000" | money }}</h4>
                        </span>
                        <span class="d-inline-block mr-3">
                            <h4 class="js-price-display text-primary" id="price_display">{{"182000" | money }}</h4>
                        </span>
                    </div>
                {% endif %}

                {# Product installments #}

                <div class="row mb-4">
                    <span class="col">
                        <span class="d-inline-block">
                            {% include "snipplets/svg/credit-card-blank.tpl" with {svg_custom_class : "icon-inline icon-w-18 icon-lg svg-icon-text mr-2"} %}
                        </span>
                        <span class="d-inline-block">
                            <span>{{ "Hasta 12 cuotas" | translate }}</span>
                        </span>
                    </span>
                </div>

                {# Product form, includes: Variants, CTA and Shipping calculator #}

                <form id="product_form" class="js-product-form" method="post" action="">
                    <input type="hidden" name="add_to_cart" value="2243561" />

                    <div class="js-product-variants row">
                        <div class="col col-md-6">
                            <div class="form-group ">
                                <label class="form-label " for="variation_1">{{ "Color" | translate }}</label>
                                <select id="variation_1" class="form-select js-variation-option js-refresh-installment-data  " name="variation[0]">
                                    <option value="{{ "Verde" | translate }}">{{ "Verde" | translate }}</option>
                                    <option value="{{ "Rojo" | translate }}">{{ "Rojo" | translate }}</option>
                                </select>
                                <div class="form-select-icon">
                                    {% include "snipplets/svg/chevron-down.tpl" with {svg_custom_class: "icon-inline icon-w-14 icon-lg svg-icon-text"} %}
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col col-md-4">
                            {% embed "snipplets/forms/form-input.tpl" with{
                            type_number: true, input_value: '1', 
                            input_name: 'quantity' ~ item.id, 
                            input_custom_class: 'js-quantity-input text-center h5', 
                            input_label: false, 
                            input_append_content: true, 
                            input_group_custom_class: 'js-quantity form-quantity', 
                            form_control_container_custom_class: 'col', 
                            input_min: '1'} %}
                                {% block input_prepend_content %}
                                <div class="row m-0 align-items-center">
                                    <span class="js-quantity-down form-quantity-icon btn">
                                        {% include "snipplets/svg/minus.tpl" with {svg_custom_class: "icon-inline icon-w-12 icon-lg svg-icon-text"} %}
                                    </span>
                                {% endblock input_prepend_content %}
                                {% block input_append_content %}
                                    <span class="js-quantity-up form-quantity-icon btn">
                                        {% include "snipplets/svg/plus.tpl" with {svg_custom_class: "icon-inline icon-w-12 icon-lg svg-icon-text"} %}
                                    </span>
                                </div>
                                {% endblock input_append_content %}
                            {% endembed %}
                        </div>
                    </div>

                    <input type="submit" class="js-addtocart js-prod-submit-form btn btn-primary btn-block mb-4" value="{{ 'Agregar al carrito' | translate }}" />

                 </form>

                {# Product description #}

                <div class="product-description user-content">
                    <p>{{ "¡Este es un producto de ejemplo! Para poder probar el proceso de compra, debes" | translate }}
                        <a href="/admin/products" target="_top">{{ "agregar tus propios productos." | translate }}</a>
                    </p>
                </div>

                {# Product share #}

                {% include 'snipplets/social/social-share.tpl' %}

            </div>
        </div>
    </div>  
</div>
<section id="related-products" class="section-products-related">
    <div class="container">
        <h2 class="products-section-title h3 text-center">{{ "Productos relacionados" | translate }}</h2>
        <div class="js-swiper-related-demo swiper-container">
            <div class="swiper-wrapper">
                {% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_1': true} %}
                {% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_2': true} %}
                {% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_4': true} %}
                {% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_6': true} %}
                {% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_7': true} %}
                {% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_8': true} %}
            </div>
            <div class="js-swiper-related-demo-pagination swiper-pagination"></div>
            <div class="js-swiper-related-demo-prev swiper-button-prev d-none d-md-block">{% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: 'icon-inline icon-w-8 icon-2x svg-icon-text'} %}</div>
            <div class="js-swiper-related-demo-next swiper-button-next d-none d-md-block">{% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: 'icon-inline icon-w-8 icon-2x svg-icon-text'} %}</div>
        </div>
    </div>
</section>