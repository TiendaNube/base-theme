{% set selected_option = loop.first or cart.shipping_option == option.name %}
<div class="js-shipping-suboption {{suboptions.name}}">
    {% if suboptions.options %}

        <p class="js-shipping-suboption-product mb-1" style="display: none;">{{ 'Vas a poder elegir alguna de las siguientes opciones antes de finalizar la compra:' | translate }}</p>

        {# Read only suboptions #}
        <ul class="js-shipping-suboption-list" name="{{suboptions.name}}" style="display: none;">
            {% for option in suboptions.options %}
                <li class="text-capitalize">{{ option.name | lower }}</li>
            {% endfor %}
        </ul>

        {# Select suboptions for cart page #}

        <div class="js-shipping-suboption-select" style="display:none;">
        {% embed "snipplets/forms/form-select.tpl" with{ select_name: suboptions.name, select_group_custom_class: 'm-0'} %}
            {% block select_options %}
               <option {% if not suboptions.selected %}selected{% endif %} disabled>{{ suboptions.default_option | translate }}</option>
                {% for option in suboptions.options %}
                    <option value="{{option.value}}">{{ option.name | lower }}</option>
                {% endfor %}
            {% endblock select_options%}
        {% endembed %}
        </div>

    {% else %}
        <input type="hidden" name="{{suboptions.name}}"/>
        <div>{{ suboptions.no_options_message | translate }}</div>
    {% endif %}
</div>