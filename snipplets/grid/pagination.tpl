{% if infinite_scroll %}
    {% if pages.current == 1 and not pages.is_last %}
        <div class="text-center mt-5 mb-5">
            <a class="js-load-more btn btn-primary">
                <span class="js-load-more-spinner" style="display:none;">{% include "snipplets/svg/sync-alt.tpl" with {svg_custom_class: "icon-inline icon-spin"} %}</span>
                {{ 'Mostrar más productos' | t }}
            </a>
        </div>
        <div id="js-infinite-scroll-spinner" class="mt-5 mb-5 text-center w-100" style="display:none">
            {% include "snipplets/svg/sync-alt.tpl" with {svg_custom_class: "icon-inline icon-3x svg-icon-text icon-spin"} %}
        </div>
    {% endif %}
{% else %}
    <div class="d-flex flex-row justify-content-center align-items-center">
        {% if pages.numbers %}
            <a {% if pages.previous %}href="{{ pages.previous }}"{% endif %}>
                {% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: "icon-inline icon-w-8 icon-lg"} %}
            </a>
            <div class="mx-2 font-big px-1">
                {% for page in pages.numbers %}
                    {% if page.selected %}
                        <span>{{ page.number }}</span>
                    {% endif %}
                {% endfor %}
                <span>/</span>
                <span>{{ pages.amount }}</span>
            </div>
            <a {% if pages.next %}href="{{ pages.next }}"{% endif %}>
                {% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline icon-w-8 icon-lg"} %}
            </a>
        {% endif %}
    </div>
{% endif %}