{% if payments %}
	{% for payment in settings.payments %}
		<img src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ payment | payment_new_logo }}" class="icon-logo lazyload" alt="{{ payment }}">
    {% endfor %}
{% elseif shipping %}
	{% for shipping in settings.shipping %}
		<img src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ shipping | shipping_logo }}" class="icon-logo lazyload" alt="{{ shipping }}">
    {% endfor %}
{% endif %}