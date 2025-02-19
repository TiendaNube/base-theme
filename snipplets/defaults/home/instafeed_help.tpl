{# Instagram feed that work as example #}

<section class="section-instafeed-home position-relative" data-store="home-instagram-feed">
	<div class="container">
		<div class="row">
			<div class="col-12 text-center">
				<h3 class="title-line">{{ 'Seguinos en Instagram' | translate }}</h3>
			</div>
		</div>
	</div>
	<div id="instafeed" class="row no-gutters">
		{% include 'snipplets/defaults/help_instagram.tpl' with {'help_item_1': true} %}
		{% include 'snipplets/defaults/help_instagram.tpl' with {'help_item_2': true} %}
		{% include 'snipplets/defaults/help_instagram.tpl' with {'help_item_1': true} %}
		{% include 'snipplets/defaults/help_instagram.tpl' with {'help_item_2': true} %}
		{% include 'snipplets/defaults/help_instagram.tpl' with {'help_item_1': true} %}
		{% include 'snipplets/defaults/help_instagram.tpl' with {'help_item_2': true} %}
	</div>
	{% if not params.preview %}
		<div class="placeholder-overlay transition-soft">
			<div class="placeholder-info">
				{% include "snipplets/svg/edit.tpl" with {svg_custom_class: "icon-inline icon-3x"} %}
				<div class="placeholder-description font-small-xs">
					{{ "Podés mostrar tus últimas novedades desde" | translate }} <strong>"{{ "Publicaciones de Instagram" | translate }}"</strong>
				</div>
				<a href="{{ admin_link }}#instatheme=redes-sociales" class="btn-primary btn btn-small">{{ "Editar" | translate }}</a>
			</div>
		</div>
	{% endif %}
</section>