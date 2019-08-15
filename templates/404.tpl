{% embed "snipplets/page-header.tpl" %}
	{% block page_header_text %}{{ "Error" | translate }} - {{ "404" | translate }}{% endblock page_header_text %}
{% endembed %}

<section>
	<div class="container">
		<div class="row">
			<div class="col-12 text-center">
				<p class="mb-1">{{ "La página que estás buscando no existe." | translate }}</p></br>
			</div>
		</div>
		{% set related_products = sections.primary.products | take(4) | shuffle %}
		{% if related_products | length > 1 %}
			<div class="row">
				<div class="col-12 text-center">
					{{ "Quizás te interesen los siguientes productos." | translate }}
				</div>
			</div>
			<div class="row mt-3">
				{% for related in related_products %}
					{% include 'snipplets/grid/item.tpl' with {product : related} %}
				{% endfor %}
			</div>
		{% endif %}
	</div>
</section>

