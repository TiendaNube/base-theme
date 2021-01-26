{% set selected_option = loop.first or cart.shipping_option == option.name %}
<div class="js-shipping-suboption {{suboptions.name}}">
    {% if suboptions.options %}

        {# Read only suboptions inside popup #}

        {% set modal_id_val = (suboptions.name | sanitize) ~ '-pickup-modal-' ~ random() %}

        <div data-toggle="#{{ modal_id_val }}" class="js-modal-open mt-2">
            {% include "snipplets/svg/map-marker-alt.tpl" with {svg_custom_class: "icon-inline icon-lg mr-1"} %}
            <span class="btn-link btn-link-primary align-bottom">{{ 'Ver puntos de retiro' | translate }}</span>
        </div>

        {% embed "snipplets/modal.tpl" with{modal_id: modal_id_val, modal_class: 'bottom modal-centered-small js-modal-shipping-suboptions', modal_position: 'center', modal_transition: 'slide', modal_header: true, modal_footer: false, modal_width: 'centered', modal_zindex_top: true} %}
            {% block modal_head %}
                {{ 'Puntos de retiro' | translate }}
            {% endblock %}
            {% block modal_body %}
                <ul class="list-unstyled py-2">
                    {% for option in suboptions.options %}
                        <li class="text-capitalize mb-3">{% include "snipplets/svg/map-marker-alt.tpl" with {svg_custom_class: "icon-inline svg-icon-primary d-flex float-left mr-2"} %} <span class="d-flex">{{ option.name | lower }}</span></li>
                    {% endfor %}
                </ul>
                <div class="mt-4"><span class="opacity-50">{{ 'Cercanos al CP:'}}</span> <span class="text-primary font-weight-bold">{{cart.shipping_zipcode}}</span></div>
                <div class="mt-2 font-small">
                    {% include "snipplets/svg/info-circle.tpl" with {svg_custom_class: "icon-inline svg-icon-text"} %}
                    <i>{{ "Vas a poder elegir estas opciones antes de finalizar tu compra" | translate }}</i>
                </div>
            {% endblock %}
        {% endembed %}

    {% else %}
        <input type="hidden" name="{{suboptions.name}}"/>
        <div>{{ suboptions.no_options_message | translate }}</div>
    {% endif %}
</div>