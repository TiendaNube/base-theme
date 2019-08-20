{% if shipping_calculator_show %}
	<div class="{% if product_detail %}product-shipping-calculator{% endif %} {% if store.branches and store.country != 'BR' %}mb-4{% else %}mb-2{% endif %}">
	    <div class="js-shipping-calculator-form">

	    	{# Shipping calcualtor input #}
            
            {% embed "snipplets/forms/form-input.tpl" with{type_tel: true, input_value: cart.shipping_zipcode, input_name: 'zipcode', input_custom_class: 'js-shipping-input', input_placeholder: "Código postal" | translate, input_label: false, input_append_content: true, input_group_custom_class: 'form-row align-items-center mb-3', form_control_container_custom_class: 'col-5'} %}
	            {% block input_prepend_content %}
	            	<div class="col-12 mb-2">

	            		{% include "snipplets/svg/truck.tpl" with {svg_custom_class: "icon-inline icon-w-18 icon-lg svg-icon-text mr-2"} %}

	            		{# Free shipping achieved label #}

						<span class="js-free-shipping-message" {% if not free_shipping.cart_has_free_shipping %}style="display: none;"{% endif %}>
							{{ "¡Genial! <strong class='text-primary'>Tenés envío gratis</strong> en esta compra" | translate }}
						</span>

						{# Free shipping with min price label #}

						<span class="js-shipping-calculator-label" {% if free_shipping.cart_has_free_shipping or not free_shipping.min_price_free_shipping.min_price %}style="display: none;"{% endif %}>
							{{ "<strong class='text-primary'>Envío gratis</strong> superando los" | translate }} <span>{{ free_shipping.min_price_free_shipping.min_price }}</span>
						</span>

						{# Shipping default label #}

						<span class="js-shipping-calculator-label-default" {% if free_shipping.cart_has_free_shipping or free_shipping.min_price_free_shipping.min_price %}style="display: none;"{% endif %}>

							{# Regular shipping calculator label #}
							
							{{ 'Costos de envío' | translate }}
						</span>
	            	</div>
	    		{% endblock input_prepend_content %}
                {% block input_form_alert %}
                <div class="col-12">
                    <div class="js-ship-calculator-error invalid-zipcode alert alert-danger" style="display: none;">{{ "No encontramos este código postal. ¿Está bien escrito?" | translate }}</div>
				    <div class="js-ship-calculator-error js-ship-calculator-common-error alert alert-danger" style="display: none;">{{ "Ocurrió un error al calcular el envío. Por favor intentá de nuevo en unos segundos." | translate }}</div>
				    <div class="js-ship-calculator-error js-ship-calculator-external-error alert alert-danger" style="display: none;">{{ "El calculo falló por un problema con el medio de envío. Por favor intentá de nuevo en unos segundos." | translate }}</div>
			    </div>
                {% endblock input_form_alert %}
                {% block input_append_content %}
                <span class="col-6">
	                <button class="js-calculate-shipping btn btn-default btn-block">	
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
		<div class="js-shipping-calculator-response mb-3 float-left w-100 {% if product_detail %}list{% endif %}" style="display: none;"></div>
	</div>
{% endif %}