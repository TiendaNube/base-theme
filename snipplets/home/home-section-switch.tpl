{% if section_select == 'hero_banner' %}

	{#  **** Hero Banner ****  #}
	<section data-store="home-hero-banner">
		{% if show_help or (show_component_help and not has_hero_banner) %}
			{# Help placeholder when not configured #}
			<div class="section-help bg-bg-subtle p-8 text-center text-muted">
				<p>Configura tu Hero Banner desde el panel de administración.</p>
			</div>
		{% else %}
			{% include 'snipplets/home/home-hero-banner.tpl' %}
		{% endif %}
	</section>

{% elseif section_select == 'hero_banner_2' %}

	{#  **** Hero Banner 2 ****  #}
	<section data-store="home-hero-banner-2">
		{% if show_help or (show_component_help and not has_hero_banner_2) %}
			<div class="section-help bg-bg-subtle p-8 text-center text-muted">
				<p>Configura tu Hero Banner 2 desde el panel de administración.</p>
			</div>
		{% else %}
			{% include 'snipplets/home/home-hero-banner-2.tpl' %}
		{% endif %}
	</section>

{% elseif section_select == 'slider' %}

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

{% elseif section_select == 'promo_marquee' %}

	{#  **** Promo Marquee Bar ****  #}
	<section data-store="home-promo-marquee-wrapper">
		{% set has_promo_marquee = settings.promo_marquee_text_1 %}
		{% if show_help or (show_component_help and not has_promo_marquee) %}
			<div class="section-help bg-bg-subtle p-8 text-center text-muted">
				<p>Configura tu Barra Promocional desde el panel de administración.</p>
			</div>
		{% else %}
			{% include 'snipplets/home/home-promo-marquee.tpl' %}
		{% endif %}
	</section>

{% elseif section_select == 'product_carousel' %}

	{#  **** Product Carousel ****  #}
	{% if show_help or (show_component_help and not has_product_carousel) %}
		<div class="section-help bg-bg-subtle p-8 text-center text-muted">
			<p>Configura tu Carrossel de Productos desde el panel de administración.</p>
		</div>
	{% else %}
		{% include 'snipplets/home/home-product-carousel.tpl' %}
		{% include 'snipplets/home/home-divider.tpl' with {type: 'seed'} %}
	{% endif %}

{% elseif section_select == 'product_grid' %}

	{#  **** Product Grid ****  #}
	{% if show_help or (show_component_help and not has_product_grid) %}
		<div class="section-help bg-bg-subtle p-8 text-center text-muted">
			<p>Configura tu Grid de Productos desde el panel de administración.</p>
		</div>
	{% else %}
		{% include 'snipplets/home/home-product-grid.tpl' %}
		{% include 'snipplets/home/home-divider.tpl' with {type: 'white'} %}
	{% endif %}

{% elseif section_select == 'vip_group' %}

	{#  **** VIP Group Banner ****  #}
	{% set has_vip_group = settings.vip_group_title or settings.vip_group_subtitle %}
	<section data-store="home-vip-group-wrapper">
		{% if show_help or (show_component_help and not has_vip_group) %}
			<div class="section-help bg-bg-subtle p-8 text-center text-muted">
				<p>Configura tu Banner Grupo VIP desde el panel de administración.</p>
			</div>
		{% else %}
			{% include 'snipplets/home/home-vip-group.tpl' %}
		{% endif %}
	</section>

{% elseif section_select == 'faq' %}

	{#  **** FAQ - Perguntas Frequentes ****  #}
	{% set has_faq = settings.faq_question_1 and settings.faq_answer_1 %}
	<section data-store="home-faq-wrapper">
		{% if show_help or (show_component_help and not has_faq) %}
			<div class="section-help bg-bg-subtle p-8 text-center text-muted">
				<p>Configura tu FAQ desde el panel de administración.</p>
			</div>
		{% else %}
			{% include 'snipplets/home/home-faq.tpl' %}
		{% endif %}
	</section>
	{% if not (show_help or (show_component_help and not has_faq)) %}
		{% include 'snipplets/home/home-divider.tpl' with {type: 'white'} %}
	{% endif %}

{% endif %}