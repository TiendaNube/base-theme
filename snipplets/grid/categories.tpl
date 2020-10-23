{% if filter_categories %}
    <div class="filters-container mb-5">
        <h6 class="mb-3">{{ "Categorías" | translate }}</h6>
        <ul class="list-unstyled"> 
            {% for category in filter_categories %}
                <li data-item="{{ loop.index }}" class="mb-3">
                    <a href="{{ category.url }}" title="{{ category.name }}" class="text-primary">
                        {{ category.name }}
                    </a>
                </li>

                {% if loop.index == 8 and filter_categories | length > 8 %}
                    <div class="js-accordion-container" style="display: none;">
                {% endif %}
                {% if loop.last and filter_categories | length > 8 %}
                    </div>
                    <a href="#" class="js-accordion-toggle btn-link d-inline-block mt-1 pl-0">
                        <span class="js-accordion-toggle-inactive">
                            {{ 'Ver más' | translate }}
                        </span>
                        <span class="js-accordion-toggle-active" style="display: none;">
                            {{ 'Ver menos' | translate }}
                        </span>
                    </a>
                {% endif %}
            {% endfor %}
        </ul>
    </div>
{% endif %}