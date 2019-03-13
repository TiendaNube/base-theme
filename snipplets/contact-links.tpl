{# /*============================================================================
  #Contact links
==============================================================================*/

#Properties

#Columns

#}

{% set columns = columns | default(false) %}

<ul class="contact-info text-center{% if columns %} row{% endif %}">
{% if store.whatsapp %}
	<li class="contact-item{% if columns %} col-6 col-md{% endif %}"><i class="footer-icon fab fa-lg fa-fw fa-whatsapp{% if columns %} contact-icon{% else %} mx-2{% endif %}"></i><a href="{{ store.whatsapp }}" class="contact-link">{{ store.whatsapp |trim('https://wa.me/') }}</a></li>
{% elseif store.phone %}
    <li class="contact-item{% if columns %} col-6 col-md{% endif %}"><i class="footer-icon far fa-lg fa-fw fa-phone{% if columns %} contact-icon{% else %} mx-2{% endif %}"></i><a href="tel:{{ store.phone }}" class="contact-link">{{ store.phone }}</a></li>
{% endif %}
{% if store.email %}
    <li class="contact-item{% if columns %} col-6 col-md{% endif %}"><i class="footer-icon far fa-lg fa-fw fa-envelope{% if columns %} contact-icon{% else %} mx-2{% endif %}"></i><a href="mailto:{{ store.email }}" class="contact-link">{{ store.email }}</a></li>
{% endif %}
{% if store.address %}
    <li class="contact-item{% if columns %} col-6 col-md{% endif %}"><i class="footer-icon far fa-lg fa-fw fa-map-marker-alt{% if columns %} contact-icon{% else %} mx-2{% endif %}"></i>{{ store.address }}</li>
{% endif %}
{% if store.blog %}
    <li class="contact-item{% if columns %} col-6 col-md{% endif %}"><i class="footer-icon far fa-lg fa-fw fa-comments{% if columns %} contact-icon{% else %} mx-2{% endif %}"></i><a target="_blank" href="{{ store.blog }}" class="contact-link">{{ "Visita nuestro Blog!" | translate }}</a></li>
{% endif %}
</ul>