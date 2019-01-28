{% for sn in ['facebook', 'twitter', 'google_plus', 'pinterest', 'instagram'] %}
    {% set sn_url = attribute(store,sn) %}
    {% if sn_url %}
        <a class="social-icon" href="{{ sn_url }}" target="_blank" {% if sn == 'google_plus' %}rel="publisher"{% endif %}><i class="fab fa-{% if sn == "google_plus" %}google-plus-g{% elseif sn == "facebook" %}facebook-f{% elseif sn == "pinterest" %}pinterest-p{% else%}{{ sn }}{% endif %}"></i></a>
    {% endif %}
{% endfor %}