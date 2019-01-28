{% embed "snipplets/page-header.tpl" %}
	{% block page_header_text %}{{ 'Iniciar sesión' | translate }}{% endblock page_header_text %}
{% endembed %}

{# Login Form #}

<section class="account-page">
	<div class="container">
		<div class="row justify-content-md-center">
			<div class="col-md-8">
				{% if not result.facebook and result.invalid %}
				    <div class="alert alert-danger">{{ 'El email o la contraseña no coinciden. Chequeá que estén bien escritos.' | translate }}</div>
				{% endif %}
				{% embed "snipplets/forms/form.tpl" with{form_id: 'login-form', submit_text: 'Iniciar sesión' | translate } %}
					{% block form_body %}

						{# Facebook login #}

						{% include 'snipplets/facebook-login.tpl' %}

						{# Name input #}

						{% embed "snipplets/forms/form-input.tpl" with{input_for: 'email', type_email: true, input_value: result.email, input_name: 'email', input_label_text: 'Email' | translate } %}
						{% endembed %}

						{# Password input #}

						{% embed "snipplets/forms/form-input.tpl" with{input_for: 'password', type_password: true, input_name: 'password', input_help: true, input_help_link: store.customer_reset_password_url, input_label_text: 'Contraseña' | translate } %}
							{% block input_help_text %}{{ '¿Olvidaste tu contraseña?' | translate }}{% endblock input_help_text %}
						{% endembed %}
					{% endblock %}
				{% endembed %}
			</div>
		</div>
	</div>
</section>