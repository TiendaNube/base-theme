<li class="js-shipping-list-item radio-button-item">
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
                        <h6 class="text-primary mb-1 d-inline-block">
                            {% if option.cost.value == 0  %}
                                {{ 'Gratis' | translate }}
                            {% else %}
                                {{option.cost}}
                            {% endif %}
                        </h6>
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
                {% if option.img_code != "branch" %}
                    <div class="radio-button-text">{{option.short_name}}</div>
                    {% if option.payment_rules %}
                        <div>
                            <i class="far fa-info-circle" aria-hidden="true"></i>
                            <i>{{option.payment_rules}}</i>
                        </div>
                    {% endif %}
                {% else %}
                    <div>{{option.name}}</div>
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