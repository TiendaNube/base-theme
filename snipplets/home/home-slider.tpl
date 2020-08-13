<section class="js-home-slider-container section-slider {% if not settings.slider or settings.slider is empty %} hidden {% endif %}">
	<div class="js-home-slider nube-slider-home swiper-container" style="visibility:hidden; height:0;">
	    <div class="swiper-wrapper">
	        {% for slide in settings.slider %}
                <div class="swiper-slide slide-container">
                	{% if slide.link %}
                		<a href="{{ slide.link }}" aria-label="{{ 'Carrusel' | translate }} {{ loop.index }}">
                	{% endif %}
                		<div class="slider-slide">
	                		<img {% if loop.first %}src="{{ slide.image | static_url | settings_image_url('original') }}" srcset="{{ slide.image | static_url | settings_image_url('original') }} 1024w, {{ slide.image | static_url | settings_image_url('1080p') }} 1920w" class="slider-image"{% else %}data-src="{{ slide.image | static_url | settings_image_url('original') }}" data-srcset="{{ slide.image | static_url | settings_image_url('original') }} 1024w, {{ slide.image | static_url | settings_image_url('1080p') }} 1920w"class="slider-image swiper-lazy"{% endif %}>
				            {% if not params.preview and not loop.first %}
	                		<div style="background-image: url({{ slide.image | static_url | settings_image_url('tiny') }});" class="js-slider-preloader slider-slide preloader-bg-img"></div>
	                		{% endif %}
                		</div>
		            {% if slide.link %}
		            	</a>
		            {% endif %}
            	</div>
	        {% endfor %}
	    </div>
	    <div class="js-swiper-home-pagination swiper-pagination swiper-pagination-white"></div>
	    <div class="js-swiper-home-prev swiper-button-prev d-none d-md-block">{% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: "icon-inline icon-w-8 icon-lg svg-icon-invert"} %}</div>
	    <div class="js-swiper-home-next swiper-button-next d-none d-md-block">{% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline icon-w-8 icon-lg svg-icon-invert"} %}</div>
	</div>
	{% snipplet 'placeholders/home-slider-placeholder.tpl' %}
</section>