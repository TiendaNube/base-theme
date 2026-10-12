{% if product.images_count > 0 %}
    <div class="js-product-gallery-zoom fixed inset-0 z-100" data-state="closed">
        <div class="js-product-gallery-zoom-backdrop absolute inset-0"></div>

        <div class="js-product-gallery-zoom-content absolute inset-0">
            <button type="button" class="js-product-gallery-zoom-close absolute top-4 right-4 z-10 flex items-center justify-center w-10 h-10 cursor-pointer bg-transparent border-0 text-white" aria-label="{{ 'Fechar' | translate }}"> {# lint-styles: allow overlay #}
                <i data-lucide="x" class="w-6 h-6"></i>
            </button>

            <div class="js-product-gallery-zoom-swiper swiper-container absolute inset-0 overflow-hidden">
                <div class="swiper-wrapper items-center">
                    {% for image in product.images %}
                        <div class="swiper-slide relative flex items-center justify-center" data-image-position="{{ loop.index0 }}">
                            <img
                                src="{{ image | product_image_url('huge') }}"
                                srcset="{{ image | product_image_url('huge') }} 640w, {{ image | product_image_url('original') }} 1024w"
                                class="max-w-full max-h-full object-contain"
                                {% if image.dimensions.width and image.dimensions.height %}width="{{ image.dimensions.width }}" height="{{ image.dimensions.height }}"{% endif %}
                                {% if image.alt %}alt="{{ image.alt }}"{% endif %} />
                        </div>
                    {% endfor %}
                </div>
            </div>

            {% if product.images_count > 1 %}
                <div class="js-product-gallery-zoom-pagination absolute bottom-6 left-0 right-0 flex items-center justify-center gap-0"></div>
            {% endif %}
        </div>
    </div>
{% endif %}
