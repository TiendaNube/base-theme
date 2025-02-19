{# Main banners that work as examples #}

<section class="section-banners-home position-relative" data-store="{{ data_store }}">
	<div class="container">
		<div class="row align-items-center">
			{% for i in 1..banners_amount %}
				<div class="col-md">
					<div class="textbanner">
						<div class="textbanner-image overlay{% if not banner_module %} textbanner-image-empty{% endif %}">
							{{ component('placeholders/banner-placeholder',{
								placeholder_classes: {
									svg_class: 'textbanner-image-background',
								}})
							}}
						</div>
				{% if banner_module %}
						</div>
					</div>
					<div class="col-md">
				{% endif %}
						<div class="textbanner-text{% if not banner_module %} over-image{% endif %}">
							<div class="h1 textbanner-title">{{ banner_title }}</div>
						</div>
					</div>
				{% if not banner_module %}
					</div>
				{% endif %}
			{% endfor %}
		</div>
	</div>
	{% if not params.preview %}
		<div class="placeholder-overlay transition-soft">
			<div class="placeholder-info">
				{% include "snipplets/svg/edit.tpl" with {svg_custom_class: "icon-inline icon-3x"} %}
				<div class="placeholder-description">
					{{ banner_help_text }} <strong>"{{ banner_help_section }}"</strong>
				</div>
				<a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-primary btn btn-small">{{ "Editar" | translate }}</a>
			</div>
		</div>
	{% endif %}
</section>