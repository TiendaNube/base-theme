{# /*============================================================================
  #Form select
==============================================================================*/

#Properties

#Group
    //select_group_custom_class for custom CSS classes
#Label 
    // select_label_name for name
    // select_label_id for ID
    // select_for for label for
    // select_label_custom_class for custom CSS classes
#Select 
    // select_id for id
    // select_name for name
    // select_custom_class for custom CSS classes 
    // input_rows for textarea rows
    // select_options to insert select options
    // select_aria_label for aria-label attribute

#}

<div class="form-group {{ select_group_custom_class }}">
    {% if select_label %}
        <label {% if select_label_id%}id="{{ select_label_id }}"{% endif %} class="form-label {{ select_label_custom_class }}" {% if select_for %}for="{{ select_for }}"{% endif %}>{{ select_label_name }}</label>
    {% endif %}
    <select 
        {% if select_id %}id="{{ select_id }}"{% endif %}
        class="form-select {{ select_custom_class }} {% if select_inline %}form-control-inline{% endif %}"
        {% if select_data %}data-{{select_data}}="{{select_data_value}}"{% endif %}
        {% if select_name %}name="{{ select_name }}"{% endif %}
        {% if select_aria_label %}aria-label="{{ select_aria_label }}"{% endif %}>
        {% block select_options %}
        {% endblock select_options %}
    </select>
    <div class="form-select-icon">
        {% include "snipplets/svg/chevron-down.tpl" with {svg_custom_class: "icon-inline icon-w-14 icon-lg svg-icon-text"} %}
    </div>
</div>


