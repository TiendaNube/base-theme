<div class="service-item-container col-md swiper-slide p-0 px-md-3">
    <div class="service-item row justify-content-md-center text-md-left align-items-center">
        <div class="col-md-auto">
            {% if help_item_1 %}
                {% include "snipplets/svg/truck.tpl" with {svg_custom_class: "icon-inline icon-w-20 icon-2x service-icon"} %}
            {% elseif help_item_2 %}
                {% include "snipplets/svg/credit-card-blank.tpl" with {svg_custom_class: "icon-inline icon-w-18 icon-2x service-icon"} %}
            {% elseif help_item_3 %}
                {% include "snipplets/svg/lock.tpl" with {svg_custom_class: "icon-inline icon-w-14 icon-2x service-icon"} %}
            {% endif %}
        </div>
        <div class="col">
            {% if help_item_1 %}
                <h3 class="service-title mb-0">{{ "Medios de envío" | translate }}</h3>
            {% elseif help_item_2 %}
                <h3 class="service-title mb-0">{{ "Tarjetas de crédito" | translate }}</h3>
            {% elseif help_item_3 %}
                <h3 class="service-title mb-0">{{ "Sitio seguro" | translate }}</h3>
            {% endif %}
        </div>
    </div>
</div>