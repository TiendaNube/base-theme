{# Product quantity #}

{% if not quickshop %}
    <div class="row">
        <div class="col col-md-4">
{% endif %}
{% embed "snipplets/forms/form-input.tpl" with{type_number: true, input_value: '1', input_name: 'quantity' ~ item.id, input_custom_class: 'js-quantity-input text-center', input_label: false, input_append_content: true, input_group_custom_class: 'js-quantity form-row align-items-center', form_control_container_custom_class: 'col-6', input_min: '1', input_aria_label: 'Cambiar cantidad' | translate } %}
    {% block input_prepend_content %}
        <span class="js-quantity-down col-3 text-center">
            {% include "snipplets/svg/minus.tpl" with {svg_custom_class: "icon-inline icon-w-12 icon-lg svg-icon-text"} %}
        </span>
    {% endblock input_prepend_content %}
    {% block input_append_content %}
        <span class="js-quantity-up col-3 text-center">
            {% include "snipplets/svg/plus.tpl" with {svg_custom_class: "icon-inline icon-w-12 icon-lg svg-icon-text"} %}
        </span>
    {% endblock input_append_content %}
{% endembed %}
{% if not quickshop %}
        </div>
    </div>
{% endif %}