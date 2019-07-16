{% if settings.show_instafeed  %}
    <section class="section-instafeed-home">
        <div class="container">
            <div class="row">
                {% set instuser = store.instagram|split('/')|last %}
                <div class="col-12 text-center">
                    {% if store.instagram %}
                        <a target="_blank" href="{{ store.instagram }}" class="instafeed-title">
                            {% include "snipplets/svg/instagram.tpl" with {svg_custom_class: "icon-inline icon-2x svg-icon-text"} %}
                            <h3 class="instafeed-user">{{ instuser }}</h3>
                        </a>
                    {% else %}
                        <div class="instafeed-title">
                            {% include "snipplets/svg/instagram.tpl" with {svg_custom_class: "icon-inline icon-2x svg-icon-text"} %}
                            <h3 class="instafeed-user">{{ "Instagram" | translate }}</h3>
                        </div>
                    {% endif %}
                </div>
            </div>
        </div>
        <div id="instafeed" class="row no-gutters">  
        </div>
    </section>
{% endif %}