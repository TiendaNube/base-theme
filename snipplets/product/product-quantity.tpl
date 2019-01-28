{# Product quantity #}
        
<div class="row">
    <div class="col col-sm-4">
        {% embed "snipplets/forms/form-input.tpl" with{type_number: true, input_value: '1', input_name: 'quantity' ~ item.id, input_custom_class: 'js-quantity-input text-center', input_label: false, input_append_content: true, input_group_custom_class: 'js-quantity form-row align-items-center', form_control_container_custom_class: 'col-6', input_min: '1'} %}
            {% block input_prepend_content %}
                <span class="js-quantity-down col-3 text-center">
                    {% include "snipplets/svg/minus.tpl" %}
                </span>
            {% endblock input_prepend_content %}
            {% block input_append_content %}
                <span class="js-quantity-up col-3 text-center">
                    {% include "snipplets/svg/plus.tpl" %}
                </span>
            {% endblock input_append_content %}
        {% endembed %}
    </div>
</div>