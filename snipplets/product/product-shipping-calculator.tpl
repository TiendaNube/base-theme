{# Product shipping calculator (Tailwind, PDP-only — do not reuse for cart) #}

<div class="mb-2 w-full" data-store="shipping-calculator">

    <div class="js-shipping-calculator-head shipping-calculator-head relative transition-soft with-form">
        <div class="js-shipping-calculator-with-zipcode mt-3 mb-4 w-full transition-up absolute">
            <div class="flex items-center justify-between gap-2">
                <span class="text-secondary font-sans text-sm">
                    {{ "Entregas para el CP:" | translate }}
                    <strong class="js-shipping-calculator-current-zip font-semibold"></strong>
                </span>
                <a class="js-shipping-calculator-change-zipcode text-secondary font-sans text-sm font-semibold underline shrink-0 cursor-pointer" href="#">{{ "Cambiar CP" | translate }}</a>
            </div>
        </div>
        <div class="js-shipping-calculator-form shipping-calculator-form transition-up absolute w-full">

            {# Shipping calculator input #}

            <span class="block mb-2 font-sans text-xs font-medium text-fg-muted">{{ 'Envío' | translate }}:</span>

            {% embed "snipplets/forms/form-input.tpl" with{type_tel: true, input_name: 'zipcode', input_custom_class: 'js-shipping-input h-8 min-w-8 w-[95px] px-2 py-1 rounded-lg border-0 bg-control text-secondary font-sans text-sm outline-none placeholder:text-fg-muted', input_placeholder: '00000-000', input_aria_label: 'Tu código postal' | translate, input_label: false, input_append_content: true, input_group_custom_class: '!m-0', form_control_container_custom_class: 'flex items-center gap-2'} %}
                {% block input_form_alert %}
                {% set zipcode_help_countries = ['BR', 'AR', 'MX'] %}
                {% if store.country in zipcode_help_countries %}
                    {% set zipcode_help_ar = 'https://www.correoargentino.com.ar/formularios/cpa' %}
                    {% set zipcode_help_br = 'http://www.buscacep.correios.com.br/sistemas/buscacep/' %}
                    {% set zipcode_help_mx = 'https://www.correosdemexico.gob.mx/SSLServicios/ConsultaCP/Descarga.aspx' %}
                    <a class="block text-secondary font-sans text-xs underline mt-2" href="{% if store.country == 'AR' %}{{ zipcode_help_ar }}{% elseif store.country == 'BR' %}{{ zipcode_help_br }}{% elseif store.country == 'MX' %}{{ zipcode_help_mx }}{% endif %}" target="_blank">{{ "No sé mi código postal" | translate }}</a>
                {% endif %}

                {# Specific error message considering if store has multiple languages #}

                <div class="js-ship-calculator-error invalid-zipcode text-red-600 font-sans text-xs mt-2" style="display: none;">
                    {% for language in languages %}
                        {% if language.active %}
                            {% if languages | length > 1 %}
                                {% set wrong_zipcode_wording = ' para ' | translate ~ language.country_name ~ '. Podés intentar con otro o' | translate %}
                            {% else %}
                                {% set wrong_zipcode_wording = '. ¿Está bien escrito?' | translate %}
                            {% endif %}
                            {{ "No encontramos este código postal{1}" | translate(wrong_zipcode_wording) }}

                            {% if languages | length > 1 %}
                                <a href="#" data-toggle="#product-shipping-country" class="js-modal-open text-secondary underline">
                                    {{ 'cambiar tu país de entrega' | translate }}
                                </a>
                            {% endif %}
                        {% endif %}
                    {% endfor %}
                </div>
                <div class="js-ship-calculator-error js-ship-calculator-common-error text-red-600 font-sans text-xs mt-2" style="display: none;">{{ "Ocurrió un error al calcular el envío. Por favor intentá de nuevo en unos segundos." | translate }}</div>
                <div class="js-ship-calculator-error js-ship-calculator-external-error text-red-600 font-sans text-xs mt-2" style="display: none;">{{ "El calculo falló por un problema con el medio de envío. Por favor intentá de nuevo en unos segundos." | translate }}</div>
                {% endblock input_form_alert %}
                {% block input_append_content %}
                <button type="button" class="js-calculate-shipping flex items-center justify-center shrink-0 h-8 min-w-8 px-2 py-1 rounded-lg bg-control text-secondary font-sans text-sm font-semibold cursor-pointer" aria-label="{{ 'Calcular envío' | translate }}">
                    <span class="js-calculate-shipping-wording">{{ "Calcular costo de envío" | translate }}</span>
                    <span class="js-calculating-shipping-wording" style="display: none;">{{ "Calculando" | translate }}</span>
                </button>
                {% if shipping_calculator_variant %}
                    <input type="hidden" name="variant_id" id="shipping-variant-id" value="{{ shipping_calculator_variant.id }}">
                {% endif %}
                {% endblock input_append_content %}
            {% endembed %}
        </div>
    </div>
    <div class="js-shipping-calculator-spinner shipping-spinner-container mb-3 w-full transition-soft text-center" style="display: none;">
        <div class="spinner-ellipsis">
            <div class="point"></div>
            <div class="point"></div>
            <div class="point"></div>
            <div class="point"></div>
        </div>
    </div>
    <div class="js-shipping-calculator-response list list-readonly mb-3 w-full" style="display: none;"></div>
</div>

{# Shipping country modal #}

{% if languages | length > 1 %}

    {% embed "snipplets/modal.tpl" with{modal_id: 'product-shipping-country', modal_class: 'bottom modal-centered-small js-modal-shipping-country', modal_position: 'center', modal_transition: 'slide', modal_header: true, modal_footer: true, modal_width: 'centered', modal_zindex_top: true, modal_mobile_full_screen: false} %}
        {% block modal_head %}
            {{ 'País de entrega' | translate }}
        {% endblock %}
        {% block modal_body %}
            {% embed "snipplets/forms/form-select.tpl" with{select_label: true, select_label_name: 'País donde entregaremos tu compra' | translate, select_aria_label: 'País donde entregaremos tu compra' | translate, select_custom_class: 'js-shipping-country-select', select_group_custom_class: 'mt-4' } %}
                {% block select_options %}
                    {% for language in languages %}
                        <option value="{{ language.country }}" data-country-url="{{ language.url }}" {% if language.active %}selected{% endif %}>{{ language.country_name }}</option>
                    {% endfor %}
                {% endblock select_options%}
            {% endembed %}
        {% endblock %}
        {% block modal_foot %}
            <a href="#" class="js-save-shipping-country float-right inline-flex items-center justify-center h-10 px-4 rounded-lg bg-secondary text-bg font-sans text-sm font-semibold cursor-pointer">{{ 'Aplicar' | translate }}</a>
        {% endblock %}
    {% endembed %}
{% endif %}
