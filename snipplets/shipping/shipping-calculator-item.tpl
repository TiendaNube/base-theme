<li class="js-shipping-list-item radio-button-item" data-store="shipping-calculator-item-{{ option.code }}">
    <label class="js-shipping-radio radio-button list-item" data-loop="shipping-radio-{{loop.index}}">
        <input 
        id="{% if featured_option %}featured-{% endif %}shipping-{{loop.index}}" 
        class="js-shipping-method {% if not featured_option %}js-shipping-method-hidden{% endif %} shipping-method" 
        data-price="{{option.cost.value}}" 
        data-code="{{option.code}}" 
        data-name="{{option.name}}" 
        data-cost="{% if option.show_price %} {% if option.cost.value == 0  %}{{ 'Gratis' | translate }}{% else %}{{option.cost}}{% endif %}{% else %} {{ 'A convenir' | translate }} {% endif %}" 
        type="radio" 
        value="{{option.code}}" 
        {% if featured_option and loop.first %}checked="checked"{% endif %} name="option" 
        style="display:none" />
        <span class="radio-button-content">
            <span class="radio-button-icons">
                <span class="radio-button-icon unchecked"></span>
                <span class="radio-button-icon checked"></span>
            </span>
            <span class="radio-button-label">

                {# Improved shipping option with no carrier img and ordered shipping info #}
                
                <div class="radio-button-text"> 
                    {% if option.show_price %} 
                        <div class="mb-1 d-inline-block">
                            <span class="text-primary h6">
                                {% if option.cost.value == 0  %}
                                    {{ 'Gratis' | translate }}
                                {% else %}
                                    {{option.cost}}
                                {% endif %}
                            </span>
                            {% if option.cost.value == 0 and option.old_cost.value %}
                                <span class="price-compare text-foreground font-small ml-1">{{option.old_cost}}</span>
                            {% endif %}
                        </div>
                    {% endif %}
                    {% if option.time %}
                        <div>
                            <strong>
                            {% if store.has_smart_dates %}
                                {{option.dates}}
                            {% else %}
                                {{option.time}}
                            {% endif %}
                            </strong>
                        </div>
                    {% endif %}
                </div>
                <div class="radio-button-text">
                    {{option.short_name}} {{ option.method == 'branch'  ? option.extra.extra  :  '' }}
                </div>
                {% if option.payment_rules %}
                    <div>
                        {% include "snipplets/svg/info-circle.tpl" with {svg_custom_class: "icon-inline svg-icon-text"} %}
                        <i>{{option.payment_rules}}</i>
                    </div>
                {% endif %}

                {% if option.suboptions is not empty %}
                    {% include "snipplets/shipping_suboptions/#{option.suboptions.type}.tpl" with {'suboptions': option.suboptions} %}
                {% endif %}

                {% if option.warning['enable'] %}
                    <div class="alert alert-warning">
                      <p>{{ option.warning['message'] }}</p>
                    </div>
                {% endif %}
            </span>
        </span>
    </label>
</li>