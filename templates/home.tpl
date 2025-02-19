{# Detect presence of features that remove empty placeholders #}

{% set has_main_slider = settings.slider and settings.slider is not empty %}
{% set has_mobile_slider = settings.toggle_slider_mobile and settings.slider_mobile and settings.slider_mobile is not empty %}
{% set has_informative_banners = settings.banner_services and (settings.banner_services_01_title or settings.banner_services_02_title or settings.banner_services_03_title or settings.banner_services_04_title) %}
{% set has_category_banners =  settings.banner_01_show or settings.banner_02_show or settings.banner_03_show %}
{% set has_welcome_message = settings.welcome_message %}
{% set has_image_text_modules = settings.module_01_show or settings.module_02_show or settings.module_03_show %}
{% set has_video = settings.video_embed %}
{% set has_instafeed = store.instagram and settings.show_instafeed and store.hasInstagramToken() %}

{% set show_help = not (has_main_slider or has_mobile_slider or has_category_banners or has_image_text_modules or has_video or has_instafeed or has_informative_banners) and not has_products %}

{% set show_component_help = params.preview %}

{% if not params.preview %}
	{% set admin_link = is_theme_draft ? '/admin/themes/settings/draft/' : '/admin/themes/settings/active/' %}
{% endif %}

{#  **** Features Order ****  #}
{% set newArray = [] %}

<div class="js-home-sections-container">
	{% for i in 0..8 %}
		{% set section = 'home_order_position_' ~ i %}
		{% set section_select = attribute(settings, section) %}

		{% if section_select not in newArray %}
			{% include 'snipplets/home/home-section-switch.tpl' %}
			{% set newArray = newArray|merge([section_select]) %}
		{% endif %}

	{% endfor %}

	{#  **** Hidden Sections ****  #}
	{% if show_component_help %}
		<div style="display:none">
			{% for section_select in ['slider', 'products', 'informatives', 'categories', 'welcome', 'video', 'instafeed', 'modules'] %}
				{% if section_select not in newArray %}
					{% include 'snipplets/home/home-section-switch.tpl' %}
				{% endif %}
			{% endfor %}
		</div>
	{% endif %}
</div>

{% if settings.home_promotional_popup %}
    {% include 'snipplets/home/home-popup.tpl' %}
{% endif %}
