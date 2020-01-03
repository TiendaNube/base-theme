{# /*============================================================================
  #Form
==============================================================================*/

#Properties
 
    // id
    // action
    // custom_class for custom CSS classes
    // Cancel if cancel button is needed
#}

<form id="{{ form_id }}" action="{{ form_action }}" method="post" class="form {{ form_custom_class }}">
    {% block form_body %}
    {% endblock%}
    {% if cancel %}
        <a href="#" class="{{ cancel_custom_class }} btn btn-default">{{ cancel_text }}</a>
    {% endif %}
    <input class="btn btn-primary {{ submit_custom_class }}" type="submit" value="{{ submit_text }}" name="{{ submit_name }}" {{ submit_prop }}/>
</form>
