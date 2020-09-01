<div class="js-toggle-branches w-100" data-store="branches">
    <span class="form-row">
        <div class="col-auto">
            {% include "snipplets/svg/store.tpl" with {svg_custom_class: "icon-inline icon-lg link-module-icon svg-icon-text"} %}
        </div>
        <div class="col-6">
            <div {% if store.branches|length > 1 %}class="mb-1"{% endif %}> 
                {% if store.branches|length > 1 %}
                    {{ 'Nuestros locales' | translate }}
                {% else %}
                    {{ 'Nuestro local' | translate }}
                {% endif %}
            </div>
            {% if store.branches|length > 1 %}
                <div class="btn-link float-left">
                    <span class="js-see-branches">
                        {{ 'Ver opciones' | translate }}
                    </span>
                    {% include "snipplets/svg/chevron-down.tpl" with {svg_custom_class: "js-see-branches icon-inline ml-1"} %}

                    <span class="js-hide-branches" style="display: none;">
                        {{ 'Ocultar opciones' | translate }}
                        {% include "snipplets/svg/chevron-up.tpl" with {svg_custom_class: "icon-inline ml-1"} %}
                    </span>
                </div>
            {% endif %}
        </div>
    </span>
</div>

{# Store branches #}

{% if not product_detail %}
    
    <ul class="js-store-branches-container list-unstyled radio-button-container mt-4 mb-4" {% if store.branches|length > 1 %}style="display: none;"{% endif %}>

        {# Selectable branches #}

        {% for branch in store.branches %}
            <li class="radio-button-item" data-store="branch-item-{{ branch.code }}">
                <label class="js-shipping-radio js-branch-radio radio-button" data-loop="branch-radio-{{loop.index}}">
                <input 
                    class="js-branch-method {% if cart.shipping_data.code == branch.code %} js-selected-shipping-method {% endif %} shipping-method" 
                    data-price="0" 
                    {% if cart.shipping_data.code == branch.code %}checked{% endif %} type="radio" 
                    value="{{branch.code}}" 
                    data-name="{{ branch.name }} - {{ branch.extra }}"
                    data-code="{{branch.code}}" 
                    data-cost="{{ 'Gratis' | translate }}"
                    name="option" 
                    style="display:none">
                    <span class="shipping-option row-fluid radio-button-content">
                       <span class="radio-button-icons">
                            <span class="radio-button-icon unchecked"></span>
                            <span class="radio-button-icon checked"></span>
                            <span class="radio-button-icon checked checked-invert"></span>
                        </span>
                        <span class="radio-button-label">
                            <h6 class="text-primary mb-1 d-inline-block">{{ 'Gratis' | translate }}</h6>
                            <span class="radio-button-text">
                                {{ branch.name }} - {{ branch.extra }}
                            </span>
                        </span>
                    </span>
                </label>
            </li>
        {% endfor %}
    </ul>
{% else %}
    <ul class="js-store-branches-container list-unstyled list mt-4 mb-4" {% if store.branches|length > 1 %}style="display: none;"{% endif %}>
        {% for branch in store.branches %}
            <li class="list-item" data-store="branch-item-{{ branch.code }}">
                <span class="list-item-content">
                    <h6 class="text-primary mb-1">{{ 'Gratis' | translate }}</h6>
                    <div>{{ branch.name }} - {{ branch.extra }}</div>
                </span>
            </li>
        {% endfor %}
    </ul>
{% endif %}