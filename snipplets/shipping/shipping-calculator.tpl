<div class="{% if product_detail %}product-shipping-calculator{% endif %} {% if store.branches %}mb-4{% else %}mb-2{% endif %}" data-store="shipping-calculator">
	<div class="js-shipping-calculator-form">

		{# Shipping calcualtor input #}
		
		{% embed "snipplets/forms/form-input.tpl" with{type_tel: true, input_value: cart.shipping_zipcode, input_name: 'zipcode', input_custom_class: 'js-shipping-input', input_placeholder: "Tu código postal" | translate, input_aria_label: 'Tu código postal' | translate, input_label: false, input_append_content: true, input_group_custom_class: 'form-row align-items-center mb-3', form_control_container_custom_class: 'col-5'} %}
			{% block input_prepend_content %}
				<div class="col-12 mb-2">

					{% include "snipplets/svg/truck.tpl" with {svg_custom_class: "icon-inline icon-w-18 icon-lg svg-icon-text mr-2"} %}

					{# Free shipping achieved label #}

					<span class="js-free-shipping-message font-weight-bold text-accent" {% if not cart.free_shipping.cart_has_free_shipping %}style="display: none;"{% endif %}>
						{{ "¡Genial! Tenés envío gratis" | translate }}
					</span>

					{# Free shipping with min price label #}

					<span class="js-shipping-calculator-label font-weight-bold" {% if cart.free_shipping.cart_has_free_shipping or not cart.free_shipping.min_price_free_shipping.min_price %}style="display: none;"{% endif %}>
						{{ "<strong class='text-accent'>Envío gratis</strong> superando los" | translate }} <span>{{ cart.free_shipping.min_price_free_shipping.min_price }}</span>
					</span>

					{# Shipping default label #}

					<span class="js-shipping-calculator-label-default" {% if cart.free_shipping.cart_has_free_shipping or cart.free_shipping.min_price_free_shipping.min_price %}style="display: none;"{% endif %}>

						{# Regular shipping calculator label #}
						
						{{ 'Medios de envío' | translate }}
					</span>
				</div>
			{% endblock input_prepend_content %}
			{% block input_form_alert %}
			{% if store.country == 'BR' or 'AR' or 'MX' %}
				{% set zipcode_help_ar = 'https://www.correoargentino.com.ar/formularios/cpa' %}
				{% set zipcode_help_br = 'http://www.buscacep.correios.com.br/sistemas/buscacep/' %}
				{% set zipcode_help_mx = 'https://www.correosdemexico.gob.mx/datosabiertos/gobmx/gobmx_Descarga.html' %}
				<div class="col-12">
					<a class="font-small text-primary mt-3 mb-2 d-block" href="{% if store.country == 'AR' %}{{ zipcode_help_ar }}{% elseif store.country == 'BR' %}{{ zipcode_help_br }}{% elseif store.country == 'MX' %}{{ zipcode_help_mx }}{% endif %}" target="_blank">{{ "No sé mi código postal" | translate }}</a>
				</div>
			{% endif %}
			<div class="col-12">
				<div class="js-ship-calculator-error invalid-zipcode alert alert-danger" style="display: none;">{{ "No encontramos este código postal. ¿Está bien escrito?" | translate }}</div>
				<div class="js-ship-calculator-error js-ship-calculator-common-error alert alert-danger" style="display: none;">{{ "Ocurrió un error al calcular el envío. Por favor intentá de nuevo en unos segundos." | translate }}</div>
				<div class="js-ship-calculator-error js-ship-calculator-external-error alert alert-danger" style="display: none;">{{ "El calculo falló por un problema con el medio de envío. Por favor intentá de nuevo en unos segundos." | translate }}</div>
			</div>
			{% endblock input_form_alert %}
			{% block input_append_content %}
			<span class="col-6">
				<button class="js-calculate-shipping btn btn-default btn-block" aria-label="{{ 'Calcular envío' | translate }}">	
					<span class="js-calculate-shipping-wording">{{ "Calcular" | translate }}</span>
					<span class="js-calculating-shipping-wording" style="display: none;">{{ "Calculando" | translate }}</span>
					<span class="loading" style="display: none;">
						{% include "snipplets/svg/sync-alt.tpl" with {svg_custom_class: "icon-inline svg-icon-text icon-spin"} %}
					</span>
				</button>
				{% if shipping_calculator_variant %}
					<input type="hidden" name="variant_id" id="shipping-variant-id" value="{{ shipping_calculator_variant.id }}">
				{% endif %}
			</span>
			{% endblock input_append_content %}
		{% endembed %}
	</div>
	<div class="js-shipping-calculator-response mb-3 float-left w-100 {% if product_detail %}list list-readonly{% endif %}" style="display: none;"></div>
</div>