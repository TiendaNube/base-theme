{% set has_multiple_slides = product.images_count > 1 or product.video_url %}

{% if product.images_count > 0 %}
		<div class="product-image-container col-12 {% if show_thumbs %}col-md-10{% endif %} p-0">
			<div class="js-swiper-product{% if settings.scroll_product_images %} product-detail-slider{% endif %} swiper-container" data-product-images-amount="{{ product.images_count }}">
				{% include 'snipplets/labels.tpl' with {'product_detail': true} %}
			    <div class="swiper-wrapper">
			    	{% for image in product.images %}
			         <div class="swiper-slide js-product-slide slider-slide" data-image="{{image.id}}" data-image-position="{{loop.index0}}">
			         	<a href="{{ image | product_image_url('original') }}" data-fancybox="product-gallery" class="js-product-slide-link d-block position-relative" style="padding-bottom: {{ image.dimensions['height'] / image.dimensions['width'] * 100}}%;">
		         			
							{% set apply_lazy_load = not loop.first %}

							{% if apply_lazy_load %}
								{% set product_image_src = 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==' %}
							{% else %}
								{% set product_image_src = image | product_image_url('large') %}
							{% endif %}
							
							<img 
								{% if not apply_lazy_load %}fetchpriority="high"{% endif %}
								{% if apply_lazy_load %}data-{% endif %}src="{{ product_image_src }}"
								{% if apply_lazy_load %}data-{% endif %}srcset='{{  image | product_image_url('large') }} 480w, {{  image | product_image_url('huge') }} 640w, {{  image | product_image_url('original') }} 1024w' 
								class="js-product-slide-img product-slider-image img-absolute img-absolute-centered {% if apply_lazy_load %}lazyautosizes lazyload{% endif %}" 
								{% if apply_lazy_load %}data-sizes="auto"{% endif %}
								{% if image.dimensions.width and image.dimensions.height %}width="{{ image.dimensions.width }}" height="{{ image.dimensions.height }}"{% endif %}
								{% if image.alt %}alt="{{image.alt}}"{% endif %} />
			        	</a>
 					</div>
					{% endfor %}
					{% include 'snipplets/product/product-video.tpl' %}
				</div>
				<div class="js-swiper-product-pagination swiper-pagination"></div>
			</div>
		</div>
	{% endif %}