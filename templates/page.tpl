{% embed "snipplets/page-header.tpl" with {'breadcrumbs': true} %}
	{% block page_header_text %}{{ page.name }}{% endblock page_header_text %}
{% endembed %}

{# Institutional page  #}

<section class="user-content">
	<div class="container">
		<div class="row justify-content-md-center">
			<div class="col-md-8">
				{{ page.content }}
			</div>
		</div>
	</div>
</section>
