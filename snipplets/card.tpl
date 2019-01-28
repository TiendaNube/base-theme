{# /*============================================================================
  #Card
==============================================================================*/

#Head
    // Block - card_head
#Body
    // Block - card_body
#Footer
    // Block - card_footer

#}

<div class="card">
    <div class="card-header">
        {% block card_head %}{% endblock %}
    </div>
    <div class="card-body">
        {% block card_body %}{% endblock %}
    </div>
    {% if card_footer %}
        <div class="card-footer">
            {% block card_foot %}{% endblock %}
        </div>
    {% endif %}
</div>