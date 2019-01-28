{{ category.url | og('url') }}
{{ category.name | og('title') }}
{{ category.description | og('description') }}
{{ ('http:' ~ category.featured_image | product_image_url('huge')) | og('image') }}
{{ ('https:' ~ category.featured_image | product_image_url('huge')) | og('image:secure_url') }}