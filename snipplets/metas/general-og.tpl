{{ store.name | og('site_name') }}
{% if template == 'home' %}
	{{ 'website' | og('type') }}
	{{ page_title | og('title') }}
	{{ page_description | og('description') }}
	{{ store.url_with_protocol | og('url') }}
	
	{% set og_image_src = store.og_image_src %}
	{% if og_image_src %}
		{{ ('http:' ~ og_image_src) | og('image') }}
		{{ ('https:' ~ og_image_src) | og('image:secure_url') }}
	{% endif %}
{% endif %}
