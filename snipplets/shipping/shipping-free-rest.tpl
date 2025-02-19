{% if product_detail %}
	
	{% if not product.free_shipping %}
		{# Wording to notice that adding one more product free shipping is achieved #}

		<div class="js-shipping-add-product-label full-width-container mb-4 text-center text-md-left h6" style="display: none;">
			<span class='js-fs-add-this-product'>{{ "¡Agregá este producto y " | translate }}</span>
			<span class='js-fs-add-one-more' style='display: none;'>{{ "¡Agregá uno más y " | translate }}</span>
			<strong class='text-accent'>{{ "tenés envío gratis!" | translate }}</strong>
		</div>
	{% endif %}

{% else %}

	<div class="js-fulfillment-info js-allows-non-shippable" {% if not cart.has_shippable_products %}style="display: none"{% endif %}>

		{# Free shipping progress bar #}
		<div class="js-ship-free-rest">
			<div class="js-bar-progress bar-progress">
				<div class="js-bar-progress-active bar-progress-active transition-soft"></div>
			</div>
			<div class="js-ship-free-rest-message ship-free-rest-message">
				<div class="ship-free-rest-text bar-progress-success h5 text-accent transition-soft">
					{{ "¡Genial! Tenés envío gratis" | translate }}
				</div>
				<div class="ship-free-rest-text bar-progress-amount h6 transition-soft">
					{{ "¡Estás a <strong class='js-ship-free-dif h5'></strong> de tener <strong class='text-accent'>envío gratis</strong>!" | translate }}
				</div>
				<div class="ship-free-rest-text bar-progress-condition transition-soft">
					<strong class="text-accent">{{ "Envío gratis" | translate }}</strong> {{ "superando los" | translate }} <span>{{ cart.free_shipping.min_price_free_shipping.min_price }}</span>
				</div>
			</div>
		</div>
	</div>
{% endif %}