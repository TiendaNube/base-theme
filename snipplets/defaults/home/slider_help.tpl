{# Slider that work as example #}

<div class="section-slider">
	<div class="js-home-empty-slider nube-slider-home swiper-container">
		<div class="swiper-wrapper">
			{% for i in 1..3 %}
				<div class="swiper-slide slide-container">
					{{ component('placeholders/banner-placeholder',{
						placeholder_classes: {
							svg_class: 'slider-image',
						}})
					}}
				</div>
			{% endfor %}
		</div>
		<div class="js-swiper-empty-home-prev swiper-button-prev d-none d-md-block">{% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: "icon-inline icon-w-8 icon-lg"} %}</div>
		<div class="js-swiper-empty-home-next swiper-button-next d-none d-md-block">{% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline icon-w-8 icon-lg"} %}</div>
		{% if not params.preview %}
			<div class="placeholder-overlay placeholder-slider transition-soft">
				<div class="placeholder-info">
					{% include "snipplets/svg/edit.tpl" with {svg_custom_class: "icon-inline icon-3x"} %}
					<div class="placeholder-description font-small-xs">
						{{ "Podés subir imágenes principales desde" | translate }} <strong>"{{ "Carrusel de imágenes" | translate }}"</strong>
					</div>
					<a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-primary btn btn-small">{{ "Editar" | translate }}</a>
				</div>
			</div>
		{% endif %}
	</div>
</div>