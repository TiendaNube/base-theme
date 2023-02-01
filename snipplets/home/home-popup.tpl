{% embed "snipplets/modal.tpl" with{modal_id: 'home-modal', modal_position: 'bottom', modal_transition: 'slide', modal_header: false, modal_footer: false, modal_width: 'centered', modal_class: 'centered-small', modal_close_class: 'invert mt-2 mr-3'  } %}

    {% block modal_body %}
        {% if "home_popup_image.jpg" | has_custom_image %}
            {% if settings.home_popup_url %}
            <a href="{{ settings.home_popup_url }}">
            {% endif %}
                <div class="text-center">
                    <img src="{{ 'images/empty-placeholder.png' | static_url }}" data-srcset='{{ "home_popup_image.jpg" | static_url | settings_image_url('huge') }} 640w, {{ "home_popup_image.jpg" | static_url | settings_image_url('original') }} 1024w' class="lazyload fade-in modal-img-full"/>
                </div>
            {% if settings.home_popup_url %}
            </a>
            {% endif %}
        {% endif %}

        {% if settings.home_popup_txt or settings.home_news_box %}
        <div class="align-items-center {% if not 'home_popup_image.jpg' | has_custom_image %}mt-3{% endif %}">
            {% if settings.home_popup_txt %}
                <div class="col-12">
                    {% if settings.home_popup_url %}
                    <a href="{{ settings.home_popup_url }}">
                    {% endif %}
                    <h3 class="text-center mt-3 {% if not settings.home_news_box %}mb-0{% endif %}">{{ settings.home_popup_txt }}</h3>
                    {% if settings.home_popup_url %}
                    </a>
                    {% endif %}
                </div>
            {% endif %}
           
            {% if settings.home_news_box %}
                <div class="col-12 newsletter">
                    <div id="news-popup-form-container">
                        <form id="news-popup-form" method="post" action="/winnie-pooh" class="js-news-form">
                            <div class="input-append">
      
                                {% embed "snipplets/forms/form-input.tpl" with{input_for: 'email', type_email: true, input_name: 'email', input_id: 'email', input_placeholder: 'Email' | translate, input_aria_label: 'Email' | translate } %}
                                {% endembed %}

                                <div class="winnie-pooh" style="display: none;">
                                    <label for="winnie-pooh-newsletter">{{ "No completar este campo" | translate }}</label>
                                    <input id="winnie-pooh-newsletter" type="text" name="winnie-pooh"/>
                                </div>
                                <input type="hidden" name="name" value="{{ "Sin nombre" | translate }}" />
                                <input type="hidden" name="message" value="{{ "Pedido de inscripción a newsletter" | translate }}" />
                                <input type="hidden" name="type" value="newsletter" />
                                <div class="js-news-spinner text-center" style="display: none;">
                                    {% include "snipplets/svg/sync-alt.tpl" with {svg_custom_class: "icon-inline svg-icon-text icon-spin icon-2x mb-3"} %}
                                </div>
                                <div style='display: none;' class="js-news-popup-success alert alert-success">{{ "¡Gracias por suscribirte! A partir de ahora vas a recibir nuestras novedades en tu email" | translate }}</div>
                                <div style='display: none;'class="js-news-popup-failed alert alert-danger">{{ "Necesitamos tu email para enviarte nuestras novedades." | translate }}</div>
                                <input type="submit" name="contact" class="btn newsletter-btn js-news-send" value='{{ "Enviar" | translate }}'>    
                            </div>
                        </form>
                    </div>
                </div>
            {% endif %}
        </div>
        {% endif %}
    {% endblock %}
{% endembed %}