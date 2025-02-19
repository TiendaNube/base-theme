{# Informative banners that work as examples #}

<section class="section-informative-banners position-relative" data-store="banner-services">
	<div class="container">
		<div class="row">
			<div class="js-informative-banners-demo banner-services swiper-container">
				<div class="swiper-wrapper">
					{% include 'snipplets/defaults/help_banner_services_item.tpl' with {'help_item_1': true} %}
					{% include 'snipplets/defaults/help_banner_services_item.tpl' with {'help_item_2': true} %}
					{% include 'snipplets/defaults/help_banner_services_item.tpl' with {'help_item_3': true} %}
				</div>
				<div class="js-informative-banners-demo-pagination service-pagination swiper-pagination swiper-pagination-black"></div>
			</div>
		</div>
	</div>
	{% if not params.preview %}
		<div class="placeholder-overlay transition-soft">
			<div class="placeholder-info p-3">
				{% include "snipplets/svg/edit.tpl" with {svg_custom_class: "icon-inline icon-2x"} %}
				<div class="placeholder-description font-small-xs my-2">
					{{ "Podés mostrar tu información para la compra desde" | translate }} <strong>"{{ "Información de envíos, pagos y compra" | translate }}"</strong>
				</div>
				<a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-primary btn btn-small">{{ "Editar" | translate }}</a>
			</div>
		</div>
	{% endif %}
</section>