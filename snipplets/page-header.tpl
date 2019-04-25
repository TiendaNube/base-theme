{# /*============================================================================
  #Page header
==============================================================================*/

#Properties

#Title

#Breadcrumbs 

#}

<section class="page-header">
	{% if template != 'product' %}
	<div class="container">
		<div class="row">
	{% endif %}
			<div class="{% if template != 'product' %}col text-center{% endif %} {% if template == 'product' %}text-center text-sm-left{% endif %}">
				{% include 'snipplets/breadcrumbs.tpl' %}
			    <h1>{% block page_header_text %}{% endblock %}</h1>
			</div>
	{% if template != 'product' %}
		</div>
	</div>
	{% endif %}
</section>


