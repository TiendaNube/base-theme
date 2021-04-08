{% if settings.show_instafeed and store.instagram %}
    <section class="section-instafeed-home" data-store="instagram-feed">
        <div class="container">
            <div class="row">
                {% set instuser = store.instagram|split('/')|last %}
                <div class="col-12 text-center">
                    <a target="_blank" href="{{ store.instagram }}" class="instafeed-title" aria-label="{{ 'Instagram de' | translate }} {{ store.name }}">
                        {% include "snipplets/svg/instagram.tpl" with {svg_custom_class: "icon-inline icon-3x align-top svg-icon-text"} %}
                        <h2 class="h2 h1-md mt-2 instafeed-user">{{ instuser }}</h2>
                        <div class="js-ig-fallback text-center mt-3">
                            <div class="mb-3">{{ 'Seguinos en Instagram' | translate }}</div>
                            <span class="btn btn-link">{{ 'Ver perfil' | translate }}</span>
                        </div>
                    </a>
                </div>
            </div>
        </div>
        <div id="instafeed" class="js-ig-success row no-gutters" style="display: none;">  
        </div>
    </section>
{% endif %}