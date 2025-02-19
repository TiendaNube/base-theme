<div class="container">
    {% embed "snipplets/page-header.tpl" with { breadcrumbs: true } %}
        {% block page_header_text %}{{ "Blog" | translate }}{% endblock page_header_text %}
    {% endembed %}

    <section class="blog-page">
        {% for post in blog.posts %}
            {% if loop.index % 3 == 1 %}
                <div class="row">
            {% endif %}
            {{ component(
                'blog/blog-post-item', {
                    image_lazy: true,
                    image_lazy_js: true,
                    post_item_classes: {
                        item: 'col-md-4 item',
                        image_container: 'mb-2',
                        image: 'img-absolute img-absolute-centered fade-in',
                        title: 'font-big mb-2',
                        summary: 'mb-3',
                        read_more: 'btn-link d-inline-block',
                    },
                })
            }}
            {% if loop.index % 3 == 0 or loop.last %}
                </div>
            {% endif %}
        {% endfor %}
    </section>
    {% include 'snipplets/grid/pagination.tpl' with {'pages': blog.pages} %}
</div>
