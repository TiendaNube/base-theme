{% if sections.primary.products %}
    <section class="section-featured-home">
        <div class="container">
            {% include 'snipplets/home/home-featured-grid.tpl' with {'featured_slider': true} %}
        </div>
    </section>
{% endif %}