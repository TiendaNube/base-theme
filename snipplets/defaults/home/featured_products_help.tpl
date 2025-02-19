{# Products featured that work as examples #}

<section class="section-featured-home" data-store="home-products-featured">
	<div class="container position-relative">
		<div class="row">
			<div class="col-12 text-center">
				<h3>{{ 'Productos destacados' | translate }}</h3>
			</div>
			<div class="col-12">
				<div class="js-swiper-featured-demo swiper-container">
					<div class="swiper-wrapper">
						{% include 'snipplets/defaults/help_item.tpl' with {'help_item_1': true, 'slide_item': true} %}
						{% include 'snipplets/defaults/help_item.tpl' with {'help_item_2': true, 'slide_item': true} %}
						{% include 'snipplets/defaults/help_item.tpl' with {'help_item_3': true, 'slide_item': true} %}
						{% include 'snipplets/defaults/help_item.tpl' with {'help_item_4': true, 'slide_item': true} %}
						{% include 'snipplets/defaults/help_item.tpl' with {'help_item_5': true, 'slide_item': true} %}
						{% include 'snipplets/defaults/help_item.tpl' with {'help_item_6': true, 'slide_item': true} %}
					</div>
					<div class="js-swiper-featured-demo-pagination swiper-pagination"></div>
					<div class="js-swiper-featured-demo-prev swiper-button-prev d-none d-md-block">{% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: "icon-inline icon-w-8 icon-2x svg-icon-text"} %}</div>
					<div class="js-swiper-featured-demo-next swiper-button-next d-none d-md-block">{% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline icon-w-8 icon-2x svg-icon-text"} %}</div>
				</div>
			</div>
		</div>
	</div>
</section>