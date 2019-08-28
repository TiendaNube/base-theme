<div class="service-item-container col-md swiper-slide p-0 px-md-3">
    <div class="service-item row justify-content-md-center text-md-left">
        
        <div class="col-md-auto">
            {% if banner_services_icon == 'shipping' %}
                {% include "snipplets/svg/truck.tpl" with {svg_custom_class: "icon-inline icon-w-20 icon-2x service-icon"} %}
            {% elseif banner_services_icon == 'card' %}
                {% include "snipplets/svg/credit-card-blank.tpl" with {svg_custom_class: "icon-inline icon-w-18 icon-2x service-icon"} %}
            {% elseif banner_services_icon == 'security' %}
                {% include "snipplets/svg/lock.tpl" with {svg_custom_class: "icon-inline icon-w-14 icon-2x service-icon"} %}
            {% elseif banner_services_icon == 'returns' %}
                {% include "snipplets/svg/sync-alt.tpl" with {svg_custom_class: "icon-inline icon-w-16 icon-2x service-icon"} %}
            {% elseif banner_services_icon == 'whatsapp' %}
                {% include "snipplets/svg/whatsapp.tpl" with {svg_custom_class: "icon-inline icon-w-16 icon-2x service-icon service-icon-big"} %}
            {% elseif banner_services_icon == 'promotions' %}
                {% include "snipplets/svg/tag.tpl" with {svg_custom_class: "icon-inline icon-w-16 icon-2x service-icon"} %}
            {% elseif banner_services_icon == 'cash' %}
                {% include "snipplets/svg/dollar-sign.tpl" with {svg_custom_class: "icon-inline icon-w-9 icon-2x service-icon"} %}
            {% endif %}
        </div>
        <div class="col">
            {% if banner_services_url %}
                <a href="{{ banner_services_url }}">
            {% endif %}
            <h3 class="service-title">{{ banner_services_title }}</h3>
            <p>{{ banner_services_description }}</p>
            {% if banner_services_url %}
                </a>
            {% endif %}
        </div>
    </div>
</div>
