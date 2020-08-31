{% set has_social_network = store.facebook or store.twitter or store.pinterest or store.instagram %}
{% set has_footer_contact_info = store.phone or store.email or store.blog or store.address %}          

{% set has_footer_menu = settings.footer_menu %}
{% set has_payment_logos = settings.payments %}
{% set has_shipping_logos = settings.shipping %}
{% set has_shipping_payment_logos = has_payment_logos or has_shipping_logos %}
<footer class="js-hide-footer-while-scrolling display-when-content-ready" data-store="footer">
	<div class="container">

		{% if template != 'password' %}

			{# Newsletter #}
			{% if settings.news_show %}
			    {% include "snipplets/newsletter.tpl" %}
			{% endif %}

		{% endif %}
        

        {# Social #}
 		{% if has_social_network %}
 			<div class="row element-footer">
 				<div class="col text-center">{% include "snipplets/social/social-links.tpl" %}</div>
			</div>
		{% endif %}

		{% if template != 'password' %}

			{# Foot Nav #}
			{% if has_footer_menu %}
				<div class="row element-footer">
	 				<div class="col text-center">{% include "snipplets/navigation/navigation-foot.tpl" %}</div>
				</div>
			{% endif %}

		{% endif %}

		{# Contact #}
 		{% if has_footer_contact_info %}
 			<div class="row element-footer">
 				<div class="col text-center">{% include "snipplets/contact-links.tpl" %}</div>
			</div>
		{% endif %}

		{# Logos Payments and Shipping #}
 		{% if has_shipping_payment_logos %}
 			<div class="row element-footer footer-payments-shipping-logos">
 				{% if has_payment_logos %}
 					<div class="col text-center">{% include "snipplets/logos-icons.tpl" with {'payments': true} %}</div>
				{% endif %}
 				<div class="w-100 my-2"></div>
 				{% if has_shipping_logos %}
 					<div class="col text-center">{% include "snipplets/logos-icons.tpl" with {'shipping': true} %}</div>
 				{% endif %}
			</div>
		{% endif %}

		<div class="row element-footer">
			<div class="col-md-6 text-center text-md-left">
                {#
                La leyenda que aparece debajo de esta linea de código debe mantenerse
                con las mismas palabras y con su apropiado link a Tienda Nube;
                como especifican nuestros términos de uso: http://www.tiendanube.com/terminos-de-uso .
                Si quieres puedes modificar el estilo y posición de la leyenda para que se adapte a
                tu sitio. Pero debe mantenerse visible para los visitantes y con el link funcional.
                Os créditos que aparece debaixo da linha de código deverá ser mantida com as mesmas
                palavras e com seu link para Nuvem Shop; como especificam nossos Termos de Uso:
                http://www.nuvemshop.com.br/termos-de-uso. Se você quiser poderá alterar o estilo
                e a posição dos créditos para que ele se adque ao seu site. Porém você precisa
                manter visivél e com um link funcionando.
                #}
                {{ new_powered_by_link }}
            </div>
            <div class="col-md-6 copyright text-center text-md-right pt-4 pt-md-0">
                {{ "Copyright {1} - {2}. Todos los derechos reservados." | translate( (store.business_name ? store.business_name : store.name) ~ (store.business_id ? ' - ' ~ store.business_id : ''), "now" | date('Y') ) }}
            </div>
        </div>

        {# AFIP - EBIT - Custom Seal #}
		{% if store.afip or ebit or settings.custom_seal_code or ("seal_img.jpg" | has_custom_image) %}
			{% if store.afip or ebit %}
				<div class="row element-footer">
	 				<div class="col text-center">
	 					{% if store.afip %}
	                        <div class="footer-logo afip seal-afip">
	                            {{ store.afip | raw }}
	                        </div>
	                    {% endif %}
	                    {% if ebit %}
	                        <div class="footer-logo ebit seal-ebit">
	                            {{ ebit }}
	                        </div>
	                    {% endif %}
	 				</div>
	 			</div>
 			{% endif %}
 			{% if "seal_img.jpg" | has_custom_image or settings.custom_seal_code %}
                <div class="row element-footer">
 					<div class="col text-center">
	                    {% if "seal_img.jpg" | has_custom_image %}
	                        <div class="footer-logo custom-seal">
	                            {% if settings.seal_url != '' %}
                                    <a href="{{ settings.seal_url }}" target="_blank">
                                {% endif %}
                                    <img src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ "seal_img.jpg" | static_url }}" class="custom-seal-img lazyload" alt="{{ 'Sello de' | translate }} {{ store.name }}"/>
                                {% if settings.seal_url != '' %}
                                    </a>
                                {% endif %}
	                        </div>
	                    {% endif %}
	                    {% if settings.custom_seal_code %}
	                        <div class="custom-seal custom-seal-code">
	                            {{ settings.custom_seal_code | raw }}
	                        </div>
	                    {% endif %}
	                </div>
                </div>
            {% endif %}
		{% endif %}

	</div>
</footer>