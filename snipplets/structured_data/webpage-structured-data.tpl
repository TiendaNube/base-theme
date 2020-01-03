<script type="application/ld+json">
{
    "@context": "https://schema.org/",
    "@type": "WebPage",
    "name": "{{ page_title | replace('"', '\"') }}",
    {% if page_description %}
        "description": "{{ page_description | replace('"', '\"') }}",
    {% endif %}
    "breadcrumb": {
        "@type": "BreadcrumbList",
        "itemListElement": [
        {
            "@type": "ListItem",
            "position": 1,
            "name": "{{ 'Inicio' | translate }}",
            "item": "{{ store.url }}"
        }{% if template != 'home' %},{% endif %}
        {% if template == 'page' %}
            {
                "@type": "ListItem",
                "position": 2,
                "name": "{{ page.name | replace('"', '\"') }}",
                "item": "{{ page.url }}"
            }
        {% elseif template == 'cart' %}
            {
                "@type": "ListItem",
                "position": 2,
                "name": "{{ 'Carrito de compras' | translate }}",
                "item": "{{ store.url }}{{ store.cart_url }}"
            }
        {% elseif template == 'search' %}
            {
                "@type": "ListItem",
                "position": 2,
                "name": "{{ 'Resultados de búsqueda' | translate }}",
                "item": "{{ store.url }}{{ store.search_url }}"
            }
        {% elseif template == 'account.order' %}
            {
                "@type": "ListItem",
                "position": 2,
                "name": "{{ 'Orden {1}' | translate(order.number) }}",
                "item": "{{ store.url }}{{ store.customer_order_url(order) }}"
            }
        {% else %}
            {% for crumb in breadcrumbs %}
                {
                    "@type": "ListItem",
                    "position": {{ loop.index + 1 }},
                    "name": "{{ crumb.name | replace('"', '\"') }}",
                    "item": "{{ store.url }}{{ crumb.url }}"
                }{% if not crumb.last %},{% endif %}
            {% endfor %}
        {% endif %}
        ]
    }{% if template == 'product' %},
    "mainEntity": {
        "@type": "Product",
        "@id": "{{ product.canonical_url }}",
        "name": "{{ product.name | replace('"', '\"') }}",
        "image": "{{ 'https:' ~ product.featured_image | product_image_url('large') }}",
        "description": "{{ page_description | replace('"', '\"') }}",
        {% if product.sku %}
            "sku": "{{ product.sku }}",
        {% endif %}
        {% if product.brand %}
            "brand": {
                "@type": "Thing",
                "name": "{{ product.brand | replace('"', '\"') }}"
            },
        {% endif %}
        {% if product.weight %}
            "weight": {
                "@type": "QuantitativeValue",
                "unitCode": "{{ product.weight_unit | iso_to_uncefact }}",
                "value": "{{ product.weight }}"
            },
        {% endif %}
        "offers": {
            "@type": "Offer",
            "url": "{{ product.url }}",
            "priceCurrency": "{{ product.currency }}",
            "price": "{{ product.price / 100 }}",
            {% if product.stock_control %}
                "availability": "http://schema.org/{{ product.stock ? 'InStock' : 'OutOfStock' }}",
                "inventoryLevel": {
                    "@type": "QuantitativeValue",
                    "value": "{{ product.stock }}"
                },
            {% endif %}
            "seller": {
                "@type": "Organization",
                "name": "{{ store.name | replace('"', '\"') }}"
            }
        }
    }
    {% endif %}
}
</script>
