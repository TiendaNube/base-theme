<div class="container container-narrow">

    {% embed "snipplets/page-header.tpl" with { breadcrumbs: true} %}
        {% block page_header_text %}{{ post.title | translate }}{% endblock page_header_text %}
    {% endembed %}

    <div class="blog-post-page">
        {{ component(
            'blog/blog-post-content', {
                image_lazy: true,
                image_lazy_js: true,
                post_content_classes: {
                    date: 'mb-4 font-smallest',
                    image: 'img-fluid fade-in mb-4 pb-2',
                    content: 'mb-2',
                },
            })
        }}
    </div>
</div>
