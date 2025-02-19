{# Video that work as examples #}

<section class="section-video-home" data-store="home-video">
	<div class="container{% if settings.video_full %}-fluid p-0{% endif %} position-relative">
		<div class="row no-gutters">
			<div class="col">
				<div class="embed-responsive embed-responsive-16by9">
					{{ component('placeholders/video-placeholder') }}
				</div>
			</div>
		</div>
		{% if not params.preview %}
			<div class="placeholder-overlay transition-soft">
				<div class="placeholder-info">
					{% include "snipplets/svg/edit.tpl" with {svg_custom_class: "icon-inline icon-3x"} %}
					<div class="placeholder-description font-small-xs">
						{{ "Podés subir tu video de YouTube o Vimeo desde" | translate }} <strong>"{{ "Video" | translate }}"</strong>
					</div>
					<a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-primary btn btn-small">{{ "Editar" | translate }}</a>
				</div>
			</div>
		{% endif %}
	</div>
</section>