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
	        {% if pages.current == 1 and not pages.is_last %}
	            <div class="text-center mt-5 mb-5">
	                <a class="js-load-more btn btn-primary">
	                	<span class="js-load-more-spinner" style="display:none;">{% include "snipplets/svg/sync-alt.tpl" with {svg_custom_class: "icon-inline icon-spin"} %}</span>
	                	{{ 'Mostrar más productos' | t }}
	                </a>
	            </div>
             	<div id="js-infinite-scroll-spinner" class="mt-5 mb-5 text-center w-100" style="display:none">
                 	{% include "snipplets/svg/sync-alt.tpl" with {svg_custom_class: "icon-inline icon-3x svg-icon-text icon-spin"} %} 
                </div>
	        {% endif %}
	    {% else %}
	        <p class="text-center">
	            {{ "No hubo resultados para tu búsqueda" | translate }}
	        </p>
	    {% endif %}
	</div>
</section>