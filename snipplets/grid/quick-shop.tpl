{% if settings.quick_shop %}
    {% embed "snipplets/modal.tpl" with{modal_id: 'quickshop-modal', modal_class: 'quickshop text-center', modal_position: 'bottom modal-bottom-sheet', modal_transition: 'slide', modal_header: true, modal_footer: true, modal_width: 'centered modal-docked-md modal-docked-md-centered', modal_mobile_full_screen: 'true' } %}
        {% block modal_body %}
        <div class="js-item-product" data-product-id="">
            <div class="js-product-container js-quickshop-container js-quickshop-modal js-quickshop-modal-shell" data-variants="" data-quickshop-id="">
                <div class="js-item-variants">
                    <div class="js-item-name h1 mb-1" data-store="product-item-name-{{ product.id }}"></div>
                    <div class="item-price-container mb-4" data-store="product-item-price-{{ product.id }}">
                        <span class="js-compare-price-display h4 price-compare"></span>
                        <span class="js-price-display h4"></span>
                    </div>
                    {# Image is hidden but present so it can be used on cart notifiaction #}
                    <img srcset="" class="js-quickshop-img hidden"/>
                    <div id="quickshop-form"></div>
                </div>
            </div>
        </div>
        {% endblock %}
    {% endembed %}
{% endif %}