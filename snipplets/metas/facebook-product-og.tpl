{{ product.social_url | og('url') }}
{{ product.name | og('title') }}
{{ page_description | og('description') }}
{{ "#{fb_app.namespace}:product" | og('type') }}
{{ ('http:' ~ product.featured_image | product_image_url('huge')) | og('image') }}
{{ ('https:' ~ product.featured_image | product_image_url('huge')) | og('image:secure_url') }}
{% if product.display_price %}
    {{ (product.price / 100) | og_fb_app('price') }}
{% endif %}
{% if product.stock_control %}
    {{ product.stock | og_fb_app('stock') }}
{% endif %}