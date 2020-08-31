{# /*============================================================================
  #Page header
==============================================================================*/

#Properties

#Title

#Breadcrumbs 

#}

<section class="page-header {% if template == 'product' %}mt-md-3{% else %}mt-3{% endif %}" {% if template != 'product' %}data-store="page-title"{% endif %}>
    {% if template != 'product' %}
    <div class="container">
        <div class="row">
    {% endif %}
            <div class="{% if template != 'product' %}col text-center{% endif %} {% if template == 'product' %}text-center text-md-left{% endif %}">
                {% include 'snipplets/breadcrumbs.tpl' %}
                <h1 {% if template == 'product' %}class="js-product-name" data-store="product-name-{{ product.id }}"{% endif %} >{% block page_header_text %}{% endblock %}</h1>
            </div>
    {% if template != 'product' %}
        </div>
    </div>
    {% endif %}
</section>
