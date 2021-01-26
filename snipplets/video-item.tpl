{% if product_modal %}

	{# Product video modal wrapper #}

	<div id="product-video-modal" class="js-product-video-modal product-video" style="display: none;">
{% endif %}
		<div class="js-video {% if product_video %}js-video-product{% endif %} embed-responsive embed-responsive-16by9 visible-when-content-ready">

			{% if product_modal_trigger %}

				{# Open modal in mobile with product video inside #}

				<a href="#product-video-modal" data-fancybox="product-gallery" class="js-play-button video-player d-block d-md-none">
					<div class="video-player-icon">{% include "snipplets/svg/play-circle.tpl" with {svg_custom_class: "icon-inline svg-icon-invert"} %}</div>
				</a>
			{% endif %}
			<a href="#" class="js-play-button video-player {% if product_modal_trigger %}d-none d-md-block{% endif %}">
				<div class="video-player-icon">
					{% include "snipplets/svg/play-circle.tpl" with {svg_custom_class: "icon-inline svg-icon-invert"} %}
				</div>
			</a>
			<div class="js-video-image">
				<img src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="" class="lazyload video-image fade-in" alt="{{ 'Video de' | translate }} {% if template != 'product' %}{{ product.name }}{% else %}{{ store.name }}{% endif %}" style="display: none;">
				<div class="placeholder-fade">
				</div>
			</div>
		</div>
			
		{# Empty iframe component: will be filled with JS on play button click #}

		<div class="js-video-iframe embed-responsive embed-responsive-16by9" style="display: none;" data-video-color="{{ settings.primary_color | trim('#') }}">
		</div>
{% if product_modal %}
	</div>
{% endif %}