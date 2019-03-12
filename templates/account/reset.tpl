{% embed "snipplets/page-header.tpl" %}
    {% block page_header_text %}{{ "Cambiar Contraseña" | translate }}{% endblock page_header_text %}
{% endembed %}

<section class="account-page">
    <div class="container">
        <div class="row justify-content-md-center">
            <div class="col-md-8">
                <p>{{ 'Vamos a enviarte un email para que puedas cambiar tu contraseña.' | translate }}</p>

                {% if success %}
                    <div class="alert alert-success">{{ '¡Listo! Te enviamos un email a {1}' | translate(email) }}</div>
                {% endif %}

                {% embed "snipplets/forms/form.tpl" with{form_id: 'resetpass-form', submit_text: 'Enviar email' | translate } %}
                    {% block form_body %}

                        {# Email input #}

                        {% embed "snipplets/forms/form-input.tpl" with{type_email: true, input_for: 'email', input_value: email, input_name: 'email', input_id: 'email', input_label_text: 'Email' | translate } %}
                            {% block input_label_text %}{{ 'Email' | translate }}{% endblock input_label_text %}
                            {% block input_form_alert %}
                                {% if failure %}
                                    <div class="alert alert-danger">{{ 'No encontramos ninguna cuenta registrada con este email. Intentalo nuevamente chequeando que esté bien escrito.' | translate }}</div>
                                {% endif %}
                            {% endblock input_form_alert %}
                        {% endembed %}
                        
                    {% endblock %}
                {% endembed %}
            </div>
        </div>
    </div>
</section>