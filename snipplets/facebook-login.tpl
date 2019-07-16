{% if store_fb_app_id %}

    <a class="btn btn-primary btn-facebook d-block mb-4" onclick="loginFacebook();" >
        {% include "snipplets/svg/facebook.tpl" with {svg_custom_class: "icon-inline icon-2x mr-1 svg-fb-icon align-middle"} %}
        <span class="align-middle">{{ 'Facebook login' | translate }}</span>
    </a>
    {% if result.facebook and result.invalid %}
        <div class="alert alert-danger">{{ 'Hubo un problema con el login de Facebook.' | translate }}</div>
    {% endif %}

{% endif %}
