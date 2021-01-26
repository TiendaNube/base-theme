{% embed "snipplets/page-header.tpl" %}
	{% block page_header_text %}{{ 'Iniciar sesión' | translate }}{% endblock page_header_text %}
{% endembed %}

{# Login Form #}

<section class="account-page">
	<div class="container">
		<div class="row justify-content-md-center">
			<div class="col-md-8">
				{% embed "snipplets/forms/form.tpl" with{form_id: 'login-form', submit_text: 'Iniciar sesión' | translate, data_store: 'account-login' } %}
					{% block form_body %}

						{# Facebook login #}

						{% include 'snipplets/facebook-login.tpl' %}

						{# Name input #}

						{% embed "snipplets/forms/form-input.tpl" with{input_for: 'email', type_email: true, input_value: result.email, input_name: 'email', input_custom_class: 'js-account-input', input_label_text: 'Email' | translate } %}
						{% endembed %}

						{# Password input #}

						{% embed "snipplets/forms/form-input.tpl" with{input_for: 'password', type_password: true, input_name: 'password', input_custom_class: 'js-account-input', input_help: true, input_help_link: store.customer_reset_password_url, input_link_class: 'btn-link-primary font-small mb-4 mt-3n', input_label_text: 'Contraseña' | translate } %}
							{% block input_help_text %}{{ '¿Olvidaste tu contraseña?' | translate }}{% endblock input_help_text %}
						{% endembed %}

						{% if not result.facebook and result.invalid %}
						    <div class="alert alert-danger">{{ 'Estos datos no son correctos. ¿Chequeaste que estén bien escritos?' | translate }}</div>
						{% endif %}

					{% endblock %}
				{% endembed %}
			</div>
		</div>
		{% if 'mandatory' not in store.customer_accounts %}
			<p class="mt-3 text-center">{{ "¿No tenés cuenta aún?" | translate }} <strong>{{ "Crear cuenta" | translate | a_tag(store.customer_register_url, '', 'btn-link-primary') }}</strong></p>
		{% endif %}
	</div>
</section>
