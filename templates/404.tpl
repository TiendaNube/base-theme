{% embed "snipplets/page-header.tpl" %}
	{% block page_header_text %}{{ "Error" | translate }} - {{ "404" | translate }}{% endblock page_header_text %}
{% endembed %}

<section>
	<div class="container">
		<div class="row">
			<div class="col-12 text-center">
				<p class="mb-4">{{ "La página que estás buscando no existe." | translate }}</br>
				{{ "Quizás te interesen los siguientes productos." | translate }}</p>
			</div>
		</div>
		{% set related_products = sections.primary.products | take(4) | shuffle %}
		{% if related_products | length > 1 %}
			<div class="row">
				<div class="col-12 text-center">
					<h2>{{ "Quizás te interesen los siguientes productos." | translate }}</h2>
				</div>
			</div>
			<div class="row">
				{% for related in related_products %}
					{% include 'snipplets/grid/item.tpl' with {product : related} %}
				{% endfor %}
			</div>
		{% endif %}
	</div>
</section>

