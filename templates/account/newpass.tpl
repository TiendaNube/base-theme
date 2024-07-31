{% set is_account_activation = action == 'account_activation' %}
{% embed "snipplets/page-header.tpl" %}
    {% block page_header_text %}{{ (is_account_activation ? 'Activar cuenta' : 'Cambiar contraseña') | translate }}{% endblock page_header_text %}
{% endembed %}

<section class="account-page">
    <div class="container">
        <div class="row justify-content-md-center">
            <div class="col-md-8">
                {% if link_expired %}

                    {% set contact_links = store.whatsapp or store.phone or store.email %}
                    
                    <div class="mb-4 text-center">
                        {% if is_account_activation %}
                            <div class="mb-1 font-weight-bold">{{ 'El link para activar tu cuenta expiró' | translate }}</div>
                            <div>{{ 'Contactanos para que te enviemos uno nuevo.' | translate }}</div>
                        {% else %}
                            <div class="mb-1 font-weight-bold">{{ 'El link para cambiar tu contraseña expiró' | translate }}</div>
                            <div class="mb-3">{{ 'Ingresá tu email para recibir uno nuevo.' | translate }}</div>
                            <a href="{{ store.customer_reset_password_url }}" class="btn-link btn-link-primary">{{ 'Ingresar email' | translate }}</a>
                        {% endif %}
                    </div>

                    {% if contact_links and is_account_activation %}
                        {% include "snipplets/contact-links.tpl" with {phone_and_mail_only: true} %}
                    {% endif %}

                {% else %}
                    {% if failure %}
                        <div class="alert alert-danger">{{ 'Las contraseñas no coinciden.' | translate }}</div>
                    {% endif %}

                    {% embed "snipplets/forms/form.tpl" with{form_id: 'newpass-form', submit_text: (customer.password ? 'Cambiar contraseña' : 'Activar cuenta')  | translate } %}
                        {% block form_body %}

                            {# Password input #}

                            {% embed "snipplets/forms/form-input.tpl" with{type_password: true, input_for: 'password', input_name: 'password', input_id: 'password', input_label_text: 'Contraseña' | translate } %}
                            {% endembed %}

                            {# Password confirm input #}

                            {% embed "snipplets/forms/form-input.tpl" with{type_password: true, input_for: 'password_confirm', input_name: 'password_confirm', input_id: 'password_confirm', input_label_text: 'Confirmar Contraseña' | translate } %}
                            {% endembed %}
                            
                        {% endblock %}
                    {% endembed %}
                {% endif %}
            </div>
        </div>
    </div>
</section>