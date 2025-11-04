{% set has_filters_available = products and has_filters_enabled and (filter_categories is not empty or product_filters is not empty) %}

{# Only remove this if you want to take away the theme onboarding advices #}
{% set show_help = not has_products %}
{% paginate by 12 %}

{% if not show_help %}

	<section class="category-header mt-4 section-margin">
		<div class="container">
			<div class="row">
				<div class="col text-center">
					{% embed "snipplets/page-header.tpl" with { breadcrumbs: false } %}
						{% block page_header_text %}{{ category.name }}{% endblock page_header_text %}
					{% endembed %}
					{% if (category.images is not empty) or ("banner-products.jpg" | has_custom_image) %}
						{% include 'snipplets/category-banner.tpl' %}
					{% endif %}
				</div>
			</div>
		</div>
	</section>

	<section class="category-body">
		<div class="container">
			<div class="js-category-controls-prev category-controls-sticky-detector"></div>
			<div class="js-category-controls row align-items-center mb-md-3 category-controls">
				{% if products %}
					{% set columns = settings.grid_columns %}
					<div class="col-6{% if columns == 2 %} col-md-9{% else %} col-md-9{% endif %}">
					{% if has_filters_available %}
						<a href="#" class="js-modal-open filter-link" data-toggle="#nav-filters">
							{{ 'Filtrar' | t }} {% include "snipplets/svg/filter.tpl" with {svg_custom_class: "icon-inline icon-w-16"} %}
						</a>
						{% embed "snipplets/modal.tpl" with{modal_id: 'nav-filters', modal_class: 'filters modal-docked-small', modal_position: 'left', modal_transition: 'slide', modal_width: 'full'} %}
							{% block modal_head %}
								{{'Filtros' | translate }}
							{% endblock %}
							{% block modal_body %}
								{% if filter_categories is not empty %}
									{% snipplet "grid/categories.tpl" %}
								{% endif %}
								{% if product_filters is not empty %}
									{% snipplet "grid/filters.tpl" %}
								{% endif %}
								<div class="js-filters-overlay filters-overlay" style="display: none;">
									<div class="filters-updating-message">
										<h3 class="js-applying-filter" style="display: none;">{{ 'Aplicando filtro...' | translate }}</h3>
										<h3 class="js-removing-filter" style="display: none;">{{ 'Borrando filtro...' | translate }}</h3>
									</div>
								</div>
							{% endblock %}
						{% endembed %}
					{% endif %}
					</div>
					<div class="col-6{% if columns == 2 %} col-md-3{% else %} col-md-3{% endif %} text-right">
						{{ component(
							'sort-by',{
								label: false,
								sort_by_classes: {
									select_group: "form-group mb-0",
									select_svg: "icon-inline icon-w-14 icon-lg svg-icon-text",
									},
								select_custom_icon: include("snipplets/svg/chevron-down.tpl", {svg_custom_class: "icon-inline icon-w-14 icon-lg svg-icon-text"}),
							}) 
						}}
					</div>
				{% endif %}
			</div>
			<div class="row">
				{% include "snipplets/grid/filters.tpl" with {applied_filters: true} %}
			</div>
			{% if products %}
				<div class="js-product-table row" data-store="category-grid-{{ category.id }}">
					{% include 'snipplets/product_grid.tpl' %}
				</div>
				{% include 'snipplets/grid/pagination.tpl' with { infinite_scroll: true } %}
			{% else %}
				<p class="text-center">
					{{(has_filters_enabled ? "No tenemos resultados para tu búsqueda. Por favor, intentá con otros filtros." : "Próximamente") | translate}}
				</p>
			{% endif %}
		</div>
	</section>
{% elseif show_help %}
	{# Category Placeholder #}
	{% include 'snipplets/defaults/show_help_category.tpl' %}
{% endif %}