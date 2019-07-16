{% for item in navigation %}
	{% if item.subitems %}
    	<li class="item-with-subitems">
    		<div class="js-nav-list-toggle-accordion">
	            <a class="nav-list-link" href="{{ item.url }}">{{ item.name }}</a>
	            <span class="js-toggle-page-accordion nav-list-arrow transition-soft">
	            	{% include "snipplets/svg/chevron-down.tpl" with {svg_custom_class: "icon-inline svg-icon-text"} %}
	            </span>
	        </div>
			<ul class="js-pages-accordion list-subitems nav-list-accordion" style="display:none;">
				{% snipplet "navigation/navigation-nav-list.tpl" with navigation = item.subitems %}
			</ul>
		</li>
	{% else %}
		<li>
        	<a class="nav-list-link" href="{{ item.url }}">{{ item.name }}</a>
        </li>
	{% endif %}
{% endfor %}