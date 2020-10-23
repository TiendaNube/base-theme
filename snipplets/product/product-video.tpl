{% if product.video_url %}
	{% if product.images_count > 1 %}
		{% set video_index = product.images_count %}
	{% else %}
		{% set video_index = 1 %}
	{% endif %}
	<div class="js-product-slide js-product-video-slide swiper-slide slider-slide" data-image-position="{{ video_index }}">

		{# Hidden video element to show inside gallery popup (only desktop) #}

		<a class="hidden" data-fancybox="product-gallery" href="#product-video-modal">
		</a>
		<div id="product-video-modal" style="display: none;">
			{% include 'snipplets/video-item.tpl' %}
		</div>

		{# Visible video inside slider #}

		<div class="product-video-container">
			<div class="product-video">
				{% include 'snipplets/video-item.tpl' %}
			</div>
		</div>
	</div>
{% endif %}