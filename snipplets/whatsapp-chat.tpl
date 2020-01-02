{% if store.whatsapp %}
    <a href="{{ store.whatsapp }}" target="_blank" class="btn-whatsapp" aria-label="{{ 'Comunicate por WhatsApp' | translate }}">
        {% include "snipplets/svg/whatsapp.tpl" with {svg_custom_class: "icon-inline icon-2x"} %}
    </a>
{% endif %}
