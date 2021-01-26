{% embed "snipplets/page-header.tpl" %}
	{% block page_header_text %}{{ 'Crear cuenta' | translate }}{% endblock page_header_text %}
{% endembed %}

<p class="text-center mb-4 px-5">{{ 'Comprá más rápido y llevá el control de tus pedidos, ¡en un solo lugar!'| translate }}</p>

{# Register Form #}

<section class="account-page">
	<div class="container">
		<div class="row justify-content-md-center">
			<div class="col-md-8">
				{% embed "snipplets/forms/form.tpl" with{form_id: 'login-form', submit_custom_class: 'js-recaptcha-button btn-block', submit_prop: 'disabled', submit_text: 'Crear cuenta' | translate, data_store: 'account-register' } %}
					{% block form_body %}

						{# Facebook login #}

						{% include 'snipplets/facebook-login.tpl' %}

						{# Name input #}
						
						{% embed "snipplets/forms/form-input.tpl" with{type_text: true, input_for: 'name', input_value: result.name, input_name: 'name', input_id: 'name', input_label_text: 'Nombre' | translate, input_placeholder: 'ej.: María Perez' | translate} %}
							{% block input_form_alert %}
								{% if result.errors.name %}
					                <div class="alert alert-danger">{{ 'Usamos tu nombre para identificar tus pedidos.' | translate }}</div>
					            {% endif %}
							{% endblock input_form_alert %}
						{% endembed %}

						{# Email input #}

						{% embed "snipplets/forms/form-input.tpl" with{type_email: true, input_for: 'email', input_value: result.email, input_name: 'email', input_id: 'email', input_label_text: 'Email' | translate, input_placeholder: 'ej.: tunombre@email.com' | translate} %}
							{% block input_form_alert %}
								{% if result.errors.email == 'exists' %}
					                <div class="alert alert-danger">{{ 'Encontramos otra cuenta que ya usa este email. Intentá usando otro o iniciá sesión.' | translate }}</div>
					            {% elseif result.errors.email %}
					                <div class="alert alert-danger">{{ 'Necesitamos un email válido para crear tu cuenta.' | translate }}</div>
					            {% endif %}
							{% endblock input_form_alert %}
						{% endembed %}

						{# Phone input #}

						{% embed "snipplets/forms/form-input.tpl" with{type_tel: true, input_for: 'phone', input_value: result.phone, input_name: 'phone', input_id: 'phone', input_label_text: 'Teléfono (opcional)' | translate, input_placeholder: 'ej.: 1123445567' | translate} %}
						{% endembed %}

						{# Password input #}

						{% embed "snipplets/forms/form-input.tpl" with{type_password: true, input_for: 'password', input_name: 'password', input_id: 'password', input_label_text: 'Contraseña' | translate} %}
							{% block input_form_alert %}
								{% if result.errors.password == 'required' %}
					                <div class="alert alert-danger">{{ 'Necesitamos una contraseña para registrarte.' | translate }}</div>
					            {% endif %}
							{% endblock input_form_alert %}
						{% endembed %}

						{# Password confirm input #}

						{% embed "snipplets/forms/form-input.tpl" with{type_password: true, input_for: 'password_confirmation', input_name: 'password_confirmation', input_id: 'password_confirmation', input_label_text: 'Confirmar Contraseña' | translate} %}
							{% block input_form_alert %}
								{% if result.errors.password == 'confirmation' %}
					                <div class="alert alert-danger">{{ 'Las contraseñas no coinciden.' | translate }}</div>
					            {% endif %}
							{% endblock input_form_alert %}
						{% endembed %}

						{# Google reCAPTCHA #}

						<div class="g-recaptcha mb-4" data-sitekey="{{recaptchaSiteKey}}" data-callback="recaptchaCallback"></div>
						
					{% endblock %}
				{% endembed %}
			</div>
		</div>
		<p class="mt-3 text-center">{{ '¿Ya tenés una cuenta?' | translate }} <strong>{{ "Iniciá sesión" | translate | a_tag(store.customer_login_url, '', 'btn-link-primary') }}</strong></p>
	</div>
</section>