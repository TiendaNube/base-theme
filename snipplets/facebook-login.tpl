{% if store_fb_app_id %}

    <a class="btn btn-primary btn-facebook d-block mb-4" onclick="loginFacebook();" >
        {% include "snipplets/svg/facebook.tpl" %}
        {{ 'Facebook login' | translate }}
    </a>
    {% if result.facebook and result.invalid %}
        <div class="alert alert-danger">{{ 'Hubo un problema con el login de Facebook.' | translate }}</div>
    {% endif %}

{% endif %}
