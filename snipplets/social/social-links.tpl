{% for sn in ['facebook', 'twitter', 'google_plus', 'pinterest', 'instagram'] %}
    {% set sn_url = attribute(store,sn) %}
    {% if sn_url %}
        <a class="social-icon" href="{{ sn_url }}" target="_blank" {% if sn == 'google_plus' %}rel="publisher"{% endif %} aria-label="{{ sn }} {{ store.name }}">
            {% if sn == "google_plus" %}
                {% include "snipplets/svg/google-plus.tpl" with {svg_custom_class: "icon-inline"} %}
            {% elseif sn == "facebook" %}
                {% include "snipplets/svg/facebook-f.tpl" with {svg_custom_class: "icon-inline"} %}
            {% elseif sn == "instagram" %}
                {% include "snipplets/svg/instagram.tpl" with {svg_custom_class: "icon-inline"} %}
            {% elseif sn == "pinterest" %}
                {% include "snipplets/svg/pinterest.tpl" with {svg_custom_class: "icon-inline"} %}
            {% else %}
                {% include "snipplets/svg/twitter.tpl" with {svg_custom_class: "icon-inline"} %}
            {% endif %}
        </a>
    {% endif %}
{% endfor %}