{% set has_multiple_slides = product.images_count > 1 or product.video_url %}

{% if product.images_count > 0 %}
    <div class="w-full" data-store="product-image-{{ product.id }}">

        {# Mobile/Tablet — horizontal carousel, 1 photo per slide #}
        <div class="js-product-gallery swiper-container relative lg:hidden">
            <div class="swiper-wrapper">
                {% for image in product.images %}
                    <div class="swiper-slide relative" data-image="{{ image.id }}" data-image-position="{{ loop.index0 }}">
                        {% if loop.first %}
                            <div class="flex items-start content-start gap-1.25 flex-wrap absolute top-0 left-0 px-4 py-2 z-10">
                                {% for label in product.labels %}
                                    <span class="flex items-center justify-center bg-control px-2 py-0.5 rounded text-secondary font-sans text-[10px] font-semibold">
                                        {{ label }}
                                    </span>
                                {% endfor %}
                            </div>
                        {% endif %}
                        <a href="{{ image | product_image_url('original') }}" data-open-gallery-zoom class="block relative aspect-[438/548] overflow-hidden">

                            {% set apply_lazy_load = not loop.first %}

                            {% if apply_lazy_load %}
                                {% set product_image_src = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==' %}
                            {% else %}
                                {% set product_image_src = image | product_image_url('large') %}
                            {% endif %}

                            <img
                                {% if not apply_lazy_load %}fetchpriority="high"{% endif %}
                                {% if apply_lazy_load %}data-{% endif %}src="{{ product_image_src }}"
                                {% if apply_lazy_load %}data-{% endif %}srcset='{{ image | product_image_url('large') }} 480w, {{ image | product_image_url('huge') }} 640w, {{ image | product_image_url('original') }} 1024w'
                                class="absolute inset-0 w-full h-full object-cover {% if apply_lazy_load %}lazyautosizes lazyload{% endif %}"
                                {% if apply_lazy_load %}data-sizes="auto"{% endif %}
                                {% if image.dimensions.width and image.dimensions.height %}width="{{ image.dimensions.width }}" height="{{ image.dimensions.height }}"{% endif %}
                                {% if image.alt %}alt="{{ image.alt }}"{% endif %} />
                        </a>
                    </div>
                {% endfor %}
                {% include 'snipplets/product/product-video.tpl' %}
            </div>
        </div>

        {% if has_multiple_slides %}
            <div class="js-product-gallery-controls flex items-center justify-between mt-4 px-4 lg:hidden">
                <div class="js-product-gallery-pagination flex items-center gap-0"></div>
                <div class="flex items-center gap-2">
                    <button type="button" class="js-product-gallery-prev flex w-8 h-8 justify-center items-center cursor-pointer" aria-label="{{ 'Anterior' | translate }}">
                        <i data-lucide="arrow-left" class="w-5 h-5 text-secondary"></i>
                    </button>
                    <button type="button" class="js-product-gallery-next flex w-8 h-8 justify-center items-center cursor-pointer" aria-label="{{ 'Siguiente' | translate }}">
                        <i data-lucide="arrow-right" class="w-5 h-5 text-secondary"></i>
                    </button>
                </div>
            </div>
        {% endif %}

        {# Desktop — static 2-column grid with every photo, no slider #}
        <div class="hidden lg:grid lg:grid-cols-2 lg:gap-0">
            {% for image in product.images %}
                <div class="relative" data-image-position="{{ loop.index0 }}">
                    {% if loop.first %}
                        <div class="flex items-start content-start gap-1.25 flex-wrap absolute top-0 left-0 px-4 py-2 z-10">
                            {% for label in product.labels %}
                                <span class="flex items-center justify-center bg-control px-2 py-0.5 rounded text-secondary font-sans text-[10px] font-semibold">
                                    {{ label }}
                                </span>
                            {% endfor %}
                        </div>
                    {% endif %}
                    <a href="{{ image | product_image_url('original') }}" data-open-gallery-zoom class="block relative aspect-[438/548] overflow-hidden">

                        {% set apply_lazy_load = not loop.first %}

                        {% if apply_lazy_load %}
                            {% set product_image_src = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==' %}
                        {% else %}
                            {% set product_image_src = image | product_image_url('large') %}
                        {% endif %}

                        <img
                            {% if not apply_lazy_load %}fetchpriority="high"{% endif %}
                            {% if apply_lazy_load %}data-{% endif %}src="{{ product_image_src }}"
                            {% if apply_lazy_load %}data-{% endif %}srcset='{{ image | product_image_url('large') }} 480w, {{ image | product_image_url('huge') }} 640w, {{ image | product_image_url('original') }} 1024w'
                            class="absolute inset-0 w-full h-full object-cover {% if apply_lazy_load %}lazyautosizes lazyload{% endif %}"
                            {% if apply_lazy_load %}data-sizes="auto"{% endif %}
                            {% if image.dimensions.width and image.dimensions.height %}width="{{ image.dimensions.width }}" height="{{ image.dimensions.height }}"{% endif %}
                            {% if image.alt %}alt="{{ image.alt }}"{% endif %} />
                    </a>
                </div>
            {% endfor %}
        </div>

    </div>

    {# Hidden compatibility shim: legacy store.js.tpl unconditionally runs
       createSwiper('.js-swiper-product', ...) and keeps calling .slideTo()
       on the result (Fancybox's shouldClose sync, LS.registerOnChangeVariant)
       regardless of whether the real gallery uses that class. Since spec 02
       renamed the real gallery to .js-product-gallery to avoid a second
       competing Swiper on the same element, this class has no match in the
       DOM anymore and the legacy Swiper instance ends up with uninitialized
       internals, crashing on .slideTo(). This isolated, invisible container
       gives it a valid (but inert) target instead, without touching
       store.js.tpl (F1/A4) or overlapping the real gallery element. #}
    <div class="js-swiper-product swiper-container" style="display:none" aria-hidden="true">
        <div class="swiper-wrapper">
            <div class="swiper-slide"></div>
        </div>
    </div>

    {% include 'snipplets/product/product-gallery-modal.tpl' %}
{% endif %}
