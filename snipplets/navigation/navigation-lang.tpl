<ul class="list-unstyled font-small">
    {% for language in languages %}
        <li class="{% if not loop.last %}mb-2{% endif %}{% if language.active %} font-weight-bold{% endif %}">
            <a href="{{ language.url }}" class="d-flex align-items-center">
                <img class="lazyload mr-2" src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ language.country | flag_url }}" alt="{{ language.name }}" />
                {{ language.country_name }}
            </a>
        </li>
    {% endfor %}
</ul>
