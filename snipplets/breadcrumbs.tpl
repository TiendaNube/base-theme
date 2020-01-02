{# /*============================================================================
  #Page breadcrumbs
==============================================================================*/
#Properties

#Breadcrumb
    //breadcrumbs_custom_class for custom CSS classes
#}

{% if breadcrumbs %}
    <div class="breadcrumbs {{ breadcrumbs_custom_class }}">
        <a class="crumb" href="{{ store.url }}" title="{{ store.name }}">{{ "Inicio" | translate }}</a>
        <span class="divider">></span>
        {% if template == 'page' %}
            <span class="crumb active">{{ page.name }}</span>
        {% elseif template == 'cart' %}
            <span class="crumb active">{{ "Carrito de compras" | translate }}</span>
        {% elseif template == 'search' %}
            <span class="crumb active">{{ "Resultados de búsqueda" | translate }}</span>
        {% elseif template == 'account.order' %}
             <span class="crumb active">{{ 'Orden {1}' | translate(order.number) }}</span>
        {% else %}
            {% for crumb in breadcrumbs %}
                {% if crumb.last %}
                    <span class="crumb active">{{ crumb.name }}</span>
                {% else %}
                    <a class="crumb" href="{{ crumb.url }}" title="{{ crumb.name }}">{{ crumb.name }}</a>
    	            <span class="divider">></span>
                {% endif %}
            {% endfor %}
        {% endif %}
    </div>
{% endif %}
