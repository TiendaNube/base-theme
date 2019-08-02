{# /*============================================================================
  #Home featured grid
==============================================================================*/

#Properties

#Featured Slider

#}


{% if sections.primary.products %}
    <section class="section-featured-home">
        <div class="container">
            <div class="row">
                {% if settings.featured_products_title %}
                    <div class="col-12 text-center">
                        <h3>{{ settings.featured_products_title }}</h3>
                    </div>
                {% endif %}
                <div class="col-12">
                    <div class="js-swiper-featured swiper-container">
                        <div class="swiper-wrapper">
                            {% for product in sections.primary.products %}
                                {% include 'snipplets/grid/item.tpl' with {'slide_item': true} %}
                            {% endfor %}

                        </div>
                        <div class="js-swiper-featured-pagination swiper-pagination"></div>
                        <div class="js-swiper-featured-prev swiper-button-prev d-none d-sm-block">{% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: "icon-inline icon-w-8 icon-2x svg-icon-text"} %}</div>
                        <div class="js-swiper-featured-next swiper-button-next d-none d-sm-block">{% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline icon-w-8 icon-2x svg-icon-text"} %}</div>
                    </div>
                </div>
            </div>
        </div>
    </section>
{% endif %}