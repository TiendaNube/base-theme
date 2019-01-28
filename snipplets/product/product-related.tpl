{% if sections.primary.products %}
    <section id="related-products" class="section-products-related">
        <div class="container">
            {% include 'snipplets/product/product-related-grid.tpl' with {'related_slider': true} %}
        </div>
    </section>
{% endif %}