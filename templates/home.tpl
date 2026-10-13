{# Detect presence of features that remove empty placeholders #}

{% set has_main_slider = settings.slider and settings.slider is not empty %}
{% set has_mobile_slider = settings.toggle_slider_mobile and settings.slider_mobile and settings.slider_mobile is not empty %}
{% set has_informative_banners = settings.banner_services and (settings.banner_services_01_title or settings.banner_services_02_title or settings.banner_services_03_title or settings.banner_services_04_title) %}
{% set has_category_banners =  settings.banner_01_show or settings.banner_02_show or settings.banner_03_show %}
{% set has_welcome_message = settings.welcome_message %}
{% set has_image_text_modules = settings.module_01_show or settings.module_02_show or settings.module_03_show %}
{% set has_video = settings.video_embed %}
{% set has_instafeed = store.instagram and settings.show_instafeed and store.hasInstagramToken() %}
{% set has_hero_banner = 'hero_banner_desktop.jpg' | has_custom_image %}
{% set has_hero_banner_2 = 'hero_banner_2_desktop.jpg' | has_custom_image %}
{% set has_promo_marquee = settings.promo_marquee_text_1 %}
{% set has_product_carousel = sections.carousel_tab_1.products is not empty or sections.carousel_tab_2.products is not empty or sections.carousel_tab_3.products is not empty %}
{% set has_product_grid = sections.product_grid.products is not empty or sections.primary.products is not empty %}

{% set show_help = not (has_hero_banner or has_hero_banner_2 or has_main_slider or has_mobile_slider or has_category_banners or has_image_text_modules or has_video or has_instafeed or has_informative_banners or has_promo_marquee or has_product_grid) and not has_products %}

{% set show_component_help = params.preview %}

{% if not params.preview %}
	{% set admin_link = is_theme_draft ? '/admin/themes/settings/draft/' : '/admin/themes/settings/active/' %}
{% endif %}

{#  **** Features Order ****  #}
{# Every key of the section_order in config/settings.txt: the loop below covers one slot per section #}
{% set home_sections = ['promo_marquee', 'hero_banner', 'hero_banner_2', 'slider', 'welcome', 'products', 'informatives', 'categories', 'modules', 'video', 'product_carousel', 'product_grid', 'vip_group', 'faq', 'instafeed'] %}
{% set newArray = [] %}

{#  **** Section visibility (Fibery task 287) ****
   Each section below has a "<section>_show" checkbox in config/settings.txt (default 1 in defaults.txt).
   Only an explicit "0" (unchecked and saved) hides it: a key never saved on a store that already had
   settings (null) counts as ON, so deploying new checkboxes never hides a live section.
   PHP loose == : 0, "0" and false equal "0"; null, "" and "1" do not. #}
{% set home_section_toggles = ['promo_marquee', 'hero_banner', 'hero_banner_2', 'product_carousel', 'product_grid', 'vip_group', 'faq'] %}

{#  **** Dividers (Fibery task 292, design task 234) ****
   A divider goes AFTER a section, by type: seed after the product carousel, white (the whole 64px gap)
   after the product grid and the FAQ. Full-bleed sections (heroes, marquee, VIP) get none. Sections are
   rendered first and kept only when their HTML is not empty, so a divider is printed only between two
   visible sections: never first, never last, never doubled. The global checkbox home_show_dividers
   follows the same rule as the section toggles (only an explicit "0" turns them off). #}
{% set home_section_dividers = {'product_carousel': 'seed', 'product_grid': 'white', 'faq': 'white'} %}
{% set home_dividers_on = settings.home_show_dividers != '0' %}
{% set home_rendered = [] %}

{% for i in 0..(home_sections|length - 1) %}
	{% set section = 'home_order_position_' ~ i %}
	{% set section_select = attribute(settings, section) %}

	{% if section_select not in newArray %}
		{% set newArray = newArray|merge([section_select]) %}
		{% set section_hidden = section_select in home_section_toggles and attribute(settings, section_select ~ '_show') == '0' %}
		{% if section_select and not section_hidden %}
			{% set section_html %}{% include 'snipplets/home/home-section-switch.tpl' %}{% endset %}
			{% if section_html|trim is not empty %}
				{% set home_rendered = home_rendered|merge([{'html': section_html, 'divider': section_select in home_section_dividers|keys ? home_section_dividers[section_select] : ''}]) %}
			{% endif %}
		{% endif %}
	{% endif %}
{% endfor %}

<div class="js-home-sections-container">
	{% for item in home_rendered %}
		{{ item.html|raw }}
		{% if home_dividers_on and item.divider and not loop.last %}
			{% include 'snipplets/home/home-divider.tpl' with {type: item.divider} %}
		{% endif %}
	{% endfor %}

	{#  **** Hidden Sections ****  #}
	{% if show_component_help %}
		<div style="display:none">
			{% for section_select in home_sections %}
				{% if section_select not in newArray %}
					{% include 'snipplets/home/home-section-switch.tpl' %}
				{% endif %}
			{% endfor %}
		</div>
	{% endif %}
</div>
