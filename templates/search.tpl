{% paginate by 12 %}

{% embed "snipplets/page-header.tpl" with { breadcrumbs: false } %}
	{% block page_header_text %}{{ "Resultados de búsqueda" | translate }}{% endblock page_header_text %}
{% endembed %}

<section class="category-body">
	<div class="container">
		{% if products %}
	        <div class="js-product-table row">
	        	{% include 'snipplets/product_grid.tpl' %}
	        </div>
			{% include 'snipplets/grid/pagination.tpl' with { infinite_scroll: true } %}
	    {% else %}
	        <p class="text-center">
	            {{ "No hubo resultados para tu búsqueda" | translate }}
	        </p>
	    {% endif %}
	</div>
</section>