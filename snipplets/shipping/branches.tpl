<div class="js-toggle-branches w-100">
    <span class="form-row">
        <div class="col-auto">
            <i class="far fa-store fa-lg link-module-icon"></i>
        </div>
        <div class="col-6">
            <div class="mb-1"> 
                {% if store.branches|length > 1 %}
                    {{ 'Retirá gratis en nuestros locales' | translate }}
                {% else %}
                    {{ 'Retirá gratis en nuestro local' | translate }}
                {% endif %}
            </div>
            <div class="btn-link float-left">
                {% if product_detail %}
                    <span class="js-see-branches">
                        {% if store.branches|length > 1 %}
                            {{ 'Ver locales' | translate }}
                        {% else %}
                            {{ 'Ver local' | translate }}
                        {% endif %}
                    </span>
                {% else %}
                    <span>
                        {{ 'Elegir local' | translate }}
                    </span>
                {% endif %}
                <i class="js-see-branches far fa-chevron-down"></i>

                <span class="js-hide-branches" style="display: none;">
                    {% if product_detail %}
                        {% if store.branches|length > 1 %}
                            {{ 'Ocultar locales' | translate }}
                        {% else %}
                            {{ 'Ocultar local' | translate }}
                        {% endif %}
                    {% endif %}
                    <i class="far fa-chevron-up"></i>
                </span>
            </div>
        </div>
    </span>
</div>

{# Store branches #}

{% if not product_detail %}
    
    <ul class="js-store-branches-container list-unstyled radio-button-container mt-3" style="display: none;">

        {# Selectable branches #}

        {% for branch in store.branches %}
            <li class="radio-button-item">
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
    <ul class="js-store-branches-container list-unstyled list mt-3" style="display: none;">
        {% for branch in store.branches %}
            <li class="list-item">
                <span class="list-item-content">
                    <h6 class="text-primary mb-1">{{ 'Gratis' | translate }}</h6>
                    <div>{{ branch.name }} - {{ branch.extra }}</div>
                </span>
            </li>
        {% endfor %}
    </ul>
{% endif %}