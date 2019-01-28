{% if settings.show_instafeed  %}
    <section class="section-instafeed-home">
        <div class="container">
            <div class="row">
                {% set instuser = store.instagram|split('/')|last %}
                <div class="col-12 text-center">
                    {% if store.instagram %}<a target="_blank" href="{{ store.instagram }}" class="instafeed-title"><i class="fab fa-2x fa-instagram"></i> <h3 class="instafeed-user">{{ instuser }}</h3></a>{% else %}<div class="instafeed-title"><i class="fab fa-2x fa-instagram"></i> <h3 class="instafeed-user">Instagram</h3></div>{% endif %}
                </div>
            </div>
        </div>
        <div id="instafeed" class="row no-gutters">  
        </div>
    </section>
{% endif %}