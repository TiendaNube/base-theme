<section class="section-advertising">
	<div class="container">
	    <div class="row-fluid">
	        <div class="col text-center">
	           	{% if settings.ad_bar and settings.ad_text %}
	           	    {% if settings.ad_url %}
				        <a class="link-contrast" href="{{ settings.ad_url }}">
					{% endif %}  
			        	{% if settings.ad_text %}
			        		{{ settings.ad_text }}
			        	{% endif %} 
					{% if settings.ad_url %}
				        </a>
			        {% endif %}  
			    {% endif %}       	
	        </div>
	    </div>
	</div>
</section>