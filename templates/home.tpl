{#  **** Home slider ****  #}
{% include 'snipplets/home/home-slider.tpl' %}


{#  **** Features Order ****  #}
{% set newArray = [] %}

{% for section in ['home_order_position_1', 'home_order_position_2', 'home_order_position_3', 'home_order_position_4', 'home_order_position_5', 'home_order_position_6', 'home_order_position_7'] %}
    {% set section_select = attribute(settings,"#{section}") %}

    {% if section_select not in newArray %}

	    {% if section_select == 'products' %}

	        {#  **** Featured products ****  #}
			{% include 'snipplets/home/home-featured-products.tpl' %}

	    {% elseif section_select == 'informatives' %}

	    	{#  **** Informative banners ****  #}
			{% include 'snipplets/banner-services/banner-services.tpl' %}

	    {% elseif section_select == 'categories' %}

	    	{#  **** Categories banners ****  #}
			{% include 'snipplets/home/home-banners.tpl' with {'textoverimage': true} %}

		{% elseif section_select == 'welcome' %}

			{#  **** Welcome message ****  #}
			{% include 'snipplets/home/home-welcome-message.tpl' %}

		{% elseif section_select == 'video' %}

			{#  **** Video embed ****  #}
			{% include 'snipplets/home/home-video.tpl' %}

		{% elseif section_select == 'instafeed' %}

			{#  **** Instafeed ****  #}
			{% include 'snipplets/home/home-instafeed.tpl' %}

		{% elseif section_select == 'modules' %}

			{#  **** Modules banners ****  #}
			{% include 'snipplets/home/home-modules.tpl' with {'textoverimage': false} %}

	    {% endif %}
   {% set newArray = newArray|merge([section_select]) %}
   
   {% endif %}

{% endfor %}
