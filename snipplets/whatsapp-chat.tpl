{% if store.whatsapp %}    
    <a href="{{ store.whatsapp }}" target="_blank" class="btn-whatsapp">
        {% include "snipplets/svg/whatsapp.tpl" with {'chat' : true} %}
    </a>
{% endif %}
