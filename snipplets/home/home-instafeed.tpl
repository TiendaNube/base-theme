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
        {% if store.hasInstagramToken() %}
            <div id="instagram-feed" class="js-ig-success row no-gutters" 
                data-ig-feed
                data-ig-items-count="9"
                data-ig-item-class="col-4"
                data-ig-link-class="instafeed-link"
                data-ig-image-class="instafeed-img w-100 fade-in"
                data-ig-aria-label="{{ 'Publicación de Instagram de' | translate }} {{ store.name }}"
                style="display: none;">  
            </div>
        {% endif %}
    </section>
{% endif %}