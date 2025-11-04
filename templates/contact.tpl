{% embed "snipplets/page-header.tpl" %}
	{% if is_order_cancellation %}
		{% set form_title = "Pedí la cancelación de tu última compra" | translate %}
	{% else %}
		{% set form_title = "Contacto" | translate %}
	{% endif %}
	{% block page_header_text %}{{ form_title }}{% endblock page_header_text %}
{% endembed %}

{% set has_contact_info = store.whatsapp or store.phone or store.email or store.address or store.blog %}
{% set is_order_cancellation_without_id = params.order_cancellation_without_id == 'true' %}
<section class="contact-page">
	<div class="container">
		<div class="row justify-content-md-center">
			<div class="col-md-8 text-center">
				{% if is_order_cancellation %}
					<p data-component="order-cancellation-disclaimer">{{ "Si te arrepentiste, podés pedir la cancelación enviando este formulario. Tenés como máximo hasta 10 días corridos desde que recibiste el producto." | translate }} </p>
					<a class="btn-link" href="{{ status_page_url_regret }}">{{'Ver detalle de la compra >' | translate}}</a>
					{% if has_contact_info %}
						<p class="mt-4 mb-3">{{ 'Si tenés problemas con otra compra, contactanos:' | translate }}</p>
					{% endif %}
				{% endif %}
				{% if store.contact_intro %}
					<p>{{ store.contact_intro }}</p>
				{% endif %}	
				{% if has_contact_info %}
					{% include "snipplets/contact-links.tpl" %}
				{% endif %}
			</div>
		</div>
		<div class="row justify-content-md-center">
			<div class="col-md-8">
				{% if product %}  
					<div> 
						<p>{{ "Usted está consultando por el siguiente producto:" | translate }} </br> {{ product.name | a_tag(product.url) }}</p>
						<img src="{{ product.featured_image | product_image_url('thumb') }}" title="{{ product.name }}" alt="{{ product.name }}" />
					</div>
				{% endif %}	
				{% if contact %}
					{% if contact.success %}
						{% if is_order_cancellation %}
							<div class="alert alert-success" data-component="order-cancellation-success-message">
								{{ "¡Tu pedido de cancelación fue enviado!" | translate }} 
								<br>
								{{ "Vamos a ponernos en contacto con vos apenas veamos tu mensaje." | translate }}
								<br> 
								<strong>{{ "Tu código de trámite es" | translate }} #{{ last_order_id }}</strong>
							</div>
						{% else %}
							<div class="alert alert-success" data-component="contact-success-message">{{ "¡Gracias por contactarnos! Vamos a responderte apenas veamos tu mensaje." | translate }}</div>
						{% endif %}
					{% else %}
						<div class="alert alert-danger">{{ "Necesitamos tu nombre y un email para poder responderte." | translate }}</div>
					{% endif %}
				{% endif %}	

				{% if is_order_cancellation_without_id %}
					<p class="mb-3" data-component="order-cancellation-disclaimer">{{ "Si te arrepentiste de una compra, podés pedir la cancelación enviando este formulario <strong>con tu número de orden.</strong> Tenés como máximo hasta 10 días corridos desde que recibiste el producto." | translate }}</p>
				{% endif %}
				
				{% embed "snipplets/forms/form.tpl" with{form_id: 'contact-form', form_custom_class: 'js-winnie-pooh-form', form_action: '/winnie-pooh', submit_name: 'contact', submit_text: 'Enviar' | translate, data_store: 'contact-form' } %}
					{% block form_body %}

						{# Hidden inputs used to send attributes #}

						<div class="winnie-pooh hidden">
							<label for="winnie-pooh">{{ "No completar este campo" | translate }}:</label>
							<input type="text" id="winnie-pooh" name="winnie-pooh">
						</div>
						<input type="hidden" value="{{ product.id }}" name="product"/>
						{% if is_order_cancellation or is_order_cancellation_without_id %}
							<input type="hidden" name="type" value="order_cancellation" />
						{% else %}
							<input type="hidden" name="type" value="contact" />
						{% endif %}

						{# Name input #}

						{% embed "snipplets/forms/form-input.tpl" with{input_for: 'name', type_text: true, input_name: 'name', input_id: 'name', input_label_text: 'Nombre' | translate } %}
						{% endembed %}

						{# Email input #}

						{% embed "snipplets/forms/form-input.tpl" with{input_for: 'email', type_email: true, input_name: 'email', input_id: 'email', input_label_text: 'Email' | translate } %}
						{% endembed %}

						{% if not is_order_cancellation %}
							{# Phone input #}

							{% embed "snipplets/forms/form-input.tpl" with{input_for: 'phone', type_tel: true, input_name: 'phone', input_id: 'phone', input_label_text: 'Teléfono' | translate } %}
							{% endembed %}

							{# Message textarea #}

							{% embed "snipplets/forms/form-input.tpl" with{text_area: true, input_for: 'message', input_name: 'message', input_id: 'message', input_rows: '7', input_label_text: 'Mensaje' | translate } %}
							{% endembed %}
						{% endif %}

					{% endblock %}
				{% endembed %}
			</div>
		</div>
	</div>
</section>