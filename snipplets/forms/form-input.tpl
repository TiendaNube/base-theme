{# /*============================================================================
  #Form input
==============================================================================*/

#Properties

#Group
    //input_group_custom_class for custom CSS classes
#Label 
    // input_label_id for ID
    // input_for for label for
    // input_label_custom_class for custom CSS classes
    // input_label_text for label text
#Prepend
    // input_prepend_content to add content before input
#Container (Only if has prepend or append)
    // form_control_container_custom_class for container custom class. E.g: col
#Input 
    // Can be text_area or input
    // input_type to define type (text, tel, number or passowrd)
    // input_id for id
    // input_name for name
    // input_value for val
    // input_placeholder for placeholder
    // input_custom_class for custom CSS classes 
    // input_rows for textarea rows
    // input_data_attr for data attributes
    // input_data_val for input_data_attr value
    // input_aria_label for aria-label attribute
#Append
    // input_append_content to add content after input
#Alerts 
    // input_form_alert to insert alerts

#}

<div class="form-group {{ input_group_custom_class }}">
    {% if input_label_text %}
        <label {% if input_label_id %}id="{{ input_label_id }}"{% endif %} class="form-label {{ input_label_custom_class }}" {% if input_for %}for="{{ input_name }}"{% endif %}>{{ input_label_text }}</label>
    {% endif %}
    {% block input_prepend_content %}
    {% endblock input_prepend_content %}
    {% if input_append_content or input_prepend_content %}
    <div class="form-control-container {{ form_control_container_custom_class }}">
    {% endif %}
    {% if text_area %}
        <textarea
            {% if input_id %}id="{{ input_id }}"{% endif %}
            class="form-control form-control-area {{ input_custom_class }} {% if input_append_content %}form-control-inline{% endif %}" 
            autocorrect="off" 
            autocapitalize="off" 
            {% if input_name %}name="{{ input_name }}"{% endif %}
            {% if input_value %}value="{{ input_value }}"{% endif %}
            {% if input_rows %}rows="{{ input_rows }}"{% endif %}
            {% if input_placeholder %}placeholder="{{ input_placeholder }}"{% endif %}
            {% if input_data_attr %}data-{{ input_data_attr }}="{{ input_data_val }}"{% endif %}></textarea>
    {% else %}
        <input 
            type="{% if type_text %}text{% elseif type_number %}number{% elseif type_tel %}tel{% elseif type_password %}password{% elseif type_hidden %}hidden{% endif %}"
            {% if input_id %}id="{{ input_id }}"{% endif %}
            class="form-control {{ input_custom_class }} {% if input_append_content %}form-control-inline{% endif %}" 
            autocorrect="off" 
            autocapitalize="off" 
            {% if type_password %}autocomplete="off"{% endif %}
            {% if input_name %}name="{{ input_name }}"{% endif %}
            {% if input_value %}value="{{ input_value }}"{% endif %}
            {% if input_min %}min="{{ input_min }}"{% endif %}
            {% if input_placeholder %}placeholder="{{ input_placeholder }}"{% endif %}
            {% if input_data_attr %}data-{{ input_data_attr }}="{{ input_data_val }}"{% endif %}
            {% if input_aria_label %}aria-label="{{ input_aria_label }}"{% endif %}/>
    {% endif %}
    {% if input_append_content or input_prepend_content %}
    </div>
    {% endif %}
    {% block input_append_content %}
    {% endblock input_append_content %}
    {% if input_help %}
    <div class="mt-4 text-center">
        <a href="{{ input_help_link }}" class="btn-link {{ input_link_class }}">{% block input_help_text %}{% endblock input_help_text %}</a>
    </div>
    {% endif %}
    {% block input_form_alert %}
    {% endblock input_form_alert %}
</div>


