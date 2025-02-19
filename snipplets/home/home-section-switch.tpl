{% if section_select == 'slider' %}
	
	{#  **** Home slider ****  #}
	<section data-store="home-slider">
		{% if show_help or (show_component_help and not (has_main_slider or has_mobile_slider)) %}
			{% snipplet 'defaults/home/slider_help.tpl' %}
		{% else %}
			{% include 'snipplets/home/home-slider.tpl' %}
			{% if has_mobile_slider %}
				{% include 'snipplets/home/home-slider.tpl' with {mobile: true} %}
			{% endif %}
		{% endif %}
	</section>

{% elseif section_select == 'products' %}

    {#  **** Featured products ****  #}
    {% if show_help or (show_component_help and not has_products) %}
		{% include 'snipplets/defaults/home/featured_products_help.tpl' %}
	{% else %}
		{% include 'snipplets/home/home-featured-products.tpl' %}
	{% endif %}

{% elseif section_select == 'informatives' %}

	{#  **** Informative banners ****  #}
	{% if show_help or (show_component_help and not has_informative_banners) %}
		{% snipplet 'defaults/home/informative_banners_help.tpl' %}
	{% else %}
		{% include 'snipplets/banner-services/banner-services.tpl' %}
	{% endif %}

{% elseif section_select == 'categories' %}

	{#  **** Categories banners ****  #}
	{% if show_help or (show_component_help and not has_category_banners) %}
		{% include 'snipplets/defaults/home/banners_help.tpl' with {
			banner_title: 'Categoría' | translate,
			banner_help_text: 'Podés destacar categorías de tu tienda desde' | translate,
			banner_help_section: 'Banners de categorías' | translate,
			data_store: 'home-banner-categories',
			banners_amount: 3} 
		%}
	{% else %}
		{% include 'snipplets/home/home-banners.tpl' with {'textoverimage': true} %}
	{% endif %}

{% elseif section_select == 'welcome' %}

	{#  **** Welcome message ****  #}
	{% if show_help or (show_component_help and not has_welcome_message) %}
		{% include 'snipplets/defaults/home/welcome_message_help.tpl' %}
	{% else %}
		{% include 'snipplets/home/home-welcome-message.tpl' %}
	{% endif %}

{% elseif section_select == 'video' %}

	{#  **** Video embed ****  #}
	{% if show_help or (show_component_help and not has_video) %}
		{% include 'snipplets/defaults/home/video_help.tpl' %}
	{% else %}
		{% include 'snipplets/home/home-video.tpl' %}
	{% endif %}

{% elseif section_select == 'instafeed' %}

	{#  **** Instafeed ****  #}
	{% if show_help or (show_component_help and not has_instafeed) %}
		{% include 'snipplets/defaults/home/instafeed_help.tpl' %}
	{% else %}
		{% include 'snipplets/home/home-instafeed.tpl' %}
	{% endif %}

{% elseif section_select == 'modules' %}

	{#  **** Modules banners ****  #}
	{% if show_help or (show_component_help and not has_image_text_modules) %}
		{% include 'snipplets/defaults/home/banners_help.tpl' with {
			banner_title: 'Módulo de imagen y texto' | translate,
			banner_help_text: 'Podés mostrar tus últimas novedades desde' | translate,
			banner_help_section: 'Módulo de imagen y texto' | translate,
			data_store: 'home-image-text-module',
			banner_module: true,
			banners_amount: 1} 
		%}
	{% else %}
		{% include 'snipplets/home/home-modules.tpl' with {'textoverimage': false} %}
	{% endif %}

{% endif %}