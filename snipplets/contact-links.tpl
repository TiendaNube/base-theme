{# /*============================================================================
  #Contact links
==============================================================================*/#}

<ul class="contact-info text-center{% if columns %} row{% endif %}">
{% if store.whatsapp %}
	<li class="contact-item{% if columns %} col-6 col-md{% endif %}">
		{% include "snipplets/svg/whatsapp.tpl" with {svg_custom_class: "icon-inline icon-lg icon-w mx-2 svg-icon-text"} %}
		<a href="{{ store.whatsapp }}" class="contact-link">{{ store.whatsapp |trim('https://wa.me/') }}</a>
	</li>
{% elseif store.phone %}
    <li class="contact-item{% if columns %} col-6 col-md{% endif %}">
		{% include "snipplets/svg/phone.tpl" with {svg_custom_class: "icon-inline icon-lg icon-w mx-2 svg-icon-text"} %}
    	<a href="tel:{{ store.phone }}" class="contact-link">{{ store.phone }}</a>
    </li>
{% endif %}
{% if store.email %}
    <li class="contact-item{% if columns %} col-6 col-md{% endif %}">
		{% include "snipplets/svg/envelope.tpl" with {svg_custom_class: "icon-inline icon-lg icon-w mx-2 svg-icon-text"} %}
    	<a href="mailto:{{ store.email }}" class="contact-link">{{ store.email }}</a>
    </li>
{% endif %}
{% if store.address %}
    <li class="contact-item{% if columns %} col-6 col-md{% endif %}">
		{% include "snipplets/svg/map-marker-alt.tpl" with {svg_custom_class: "icon-inline icon-lg icon-w mx-2 svg-icon-text"} %}
    	{{ store.address }}
    </li>
{% endif %}
{% if store.blog %}
    <li class="contact-item{% if columns %} col-6 col-md{% endif %}">
		{% include "snipplets/svg/comments.tpl" with {svg_custom_class: "icon-inline icon-lg icon-w mx-2 svg-icon-text"} %}
    	<a target="_blank" href="{{ store.blog }}" class="contact-link">{{ "Visita nuestro Blog!" | translate }}</a>
    </li>
{% endif %}
</ul>