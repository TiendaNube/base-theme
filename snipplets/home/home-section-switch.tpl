{# Renders one home section (section_select). Wrappers are printed only around non-empty content,
   so an unconfigured section leaves nothing behind. Dividers between sections are placed by
   templates/home.tpl, never here. #}
{% if section_select == 'hero_banner' %}

	{#  **** Hero Banner ****  #}
	{% set section_inner %}
		{% if show_help or (show_component_help and not has_hero_banner) %}
			{# Help placeholder when not configured #}
			<div class="section-help bg-bg-subtle p-8 text-center text-muted">
				<p>Configura tu Hero Banner desde el panel de administración.</p>
			</div>
		{% else %}
			{% include 'snipplets/home/home-hero-banner.tpl' %}
		{% endif %}
	{% endset %}
	{% if section_inner|trim is not empty %}
	<section data-store="home-hero-banner">
		{{ section_inner|raw }}
	</section>
	{% endif %}

{% elseif section_select == 'hero_banner_2' %}

	{#  **** Hero Banner 2 ****  #}
	{% set section_inner %}
		{% if show_help or (show_component_help and not has_hero_banner_2) %}
			<div class="section-help bg-bg-subtle p-8 text-center text-muted">
				<p>Configura tu Hero Banner 2 desde el panel de administración.</p>
			</div>
		{% else %}
			{% include 'snipplets/home/home-hero-banner-2.tpl' %}
		{% endif %}
	{% endset %}
	{% if section_inner|trim is not empty %}
	<section data-store="home-hero-banner-2">
		{{ section_inner|raw }}
	</section>
	{% endif %}

{% elseif section_select == 'instafeed' %}

	{#  **** Instafeed ****  #}
	{% if show_help or (show_component_help and not has_instafeed) %}
		{% include 'snipplets/defaults/home/instafeed_help.tpl' %}
	{% else %}
		{% include 'snipplets/home/home-instafeed.tpl' %}
	{% endif %}

{% elseif section_select == 'promo_marquee' %}

	{#  **** Promo Marquee Bar ****  #}
	{% set has_promo_marquee = settings.promo_marquee_text_1 %}
	{% set section_inner %}
		{% if show_help or (show_component_help and not has_promo_marquee) %}
			<div class="section-help bg-bg-subtle p-8 text-center text-muted">
				<p>Configura tu Barra Promocional desde el panel de administración.</p>
			</div>
		{% else %}
			{% include 'snipplets/home/home-promo-marquee.tpl' %}
		{% endif %}
	{% endset %}
	{% if section_inner|trim is not empty %}
	<section data-store="home-promo-marquee-wrapper">
		{{ section_inner|raw }}
	</section>
	{% endif %}

{% elseif section_select == 'product_carousel' %}

	{#  **** Product Carousel ****  #}
	{% if show_help or (show_component_help and not has_product_carousel) %}
		<div class="section-help bg-bg-subtle p-8 text-center text-muted">
			<p>Configura tu Carrossel de Productos desde el panel de administración.</p>
		</div>
	{% else %}
		{% include 'snipplets/home/home-product-carousel.tpl' %}
	{% endif %}

{% elseif section_select == 'product_grid' %}

	{#  **** Product Grid ****  #}
	{% if show_help or (show_component_help and not has_product_grid) %}
		<div class="section-help bg-bg-subtle p-8 text-center text-muted">
			<p>Configura tu Grid de Productos desde el panel de administración.</p>
		</div>
	{% else %}
		{% include 'snipplets/home/home-product-grid.tpl' %}
	{% endif %}

{% elseif section_select == 'vip_group' %}

	{#  **** VIP Group Banner ****  #}
	{% set has_vip_group = settings.vip_group_title or settings.vip_group_subtitle %}
	{% set section_inner %}
		{% if show_help or (show_component_help and not has_vip_group) %}
			<div class="section-help bg-bg-subtle p-8 text-center text-muted">
				<p>Configura tu Banner Grupo VIP desde el panel de administración.</p>
			</div>
		{% else %}
			{% include 'snipplets/home/home-vip-group.tpl' %}
		{% endif %}
	{% endset %}
	{% if section_inner|trim is not empty %}
	<section data-store="home-vip-group-wrapper">
		{{ section_inner|raw }}
	</section>
	{% endif %}

{% elseif section_select == 'faq' %}

	{#  **** FAQ - Perguntas Frequentes ****  #}
	{% set has_faq = settings.faq_question_1 and settings.faq_answer_1 %}
	{% set section_inner %}
		{% if show_help or (show_component_help and not has_faq) %}
			<div class="section-help bg-bg-subtle p-8 text-center text-muted">
				<p>Configura tu FAQ desde el panel de administración.</p>
			</div>
		{% else %}
			{% include 'snipplets/home/home-faq.tpl' %}
		{% endif %}
	{% endset %}
	{% if section_inner|trim is not empty %}
	<section data-store="home-faq-wrapper">
		{{ section_inner|raw }}
	</section>
	{% endif %}

{% endif %}
