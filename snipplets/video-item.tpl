<div class="js-video embed-responsive embed-responsive-16by9 visible-when-content-ready">
	<a href="#" class="js-play-button video-player">
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
