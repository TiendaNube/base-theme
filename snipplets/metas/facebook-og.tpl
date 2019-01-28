 {{ store.name | og('site_name') }}
{% if template == 'home' and store.logo %}
    {{ ('http:' ~ store.logo) | og('image') }}
    {{ ('https:' ~ store.logo) | og('image:secure_url') }}
{% endif %}