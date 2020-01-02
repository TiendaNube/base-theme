<script type="application/ld+json">
{
    "@context": "https://schema.org/",
    "@type": "Product",
    "mainEntityOfPage": {
        "@type": "WebPage",
        "@id": "{{ product.canonical_url }}"
    },
    "name": "{{ product.name | replace('"', '\"') }}",
    "image": "{{ 'https:' ~ product.featured_image | product_image_url('large') }}",
    "description": "{{ product.seo_description | replace('"', '\"') }}",
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
</script>
