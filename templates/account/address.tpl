{% embed "snipplets/page-header.tpl" %}
    {% block page_header_text %}{{ "Mi cuenta" | translate }}{% endblock page_header_text %}
{% endembed %}

{# User edit address form #}

<section class="account-page">
    <div class="container">
        <div class="row justify-content-md-center">
            <div class="col-md-8">
                {% embed "snipplets/forms/form.tpl" with{form_id: 'address-form', submit_text: 'Guardar cambios' | translate } %}
                    {% block form_body %}

                        {# Name input #}
                        
                        {% embed "snipplets/forms/form-input.tpl" with{type_text: true, input_for: 'name', input_value: result.name | default(address.name), input_name: 'name', input_id: 'name', input_label_text: 'Nombre' | translate } %}
                            {% block input_form_alert %}
                                {% if result.errors.name %}
                                    <div class="alert alert-danger">{{ 'Necesitamos saber tu nombre para actualizar tu información.' | translate }}</div>
                                {% endif %}
                            {% endblock input_form_alert %}
                        {% endembed %}

                        {# Address input #}
                        
                        {% embed "snipplets/forms/form-input.tpl" with{type_text: true, input_for: 'address', input_value: result.address | default(address.address), input_name: 'address', input_id: 'address', input_label_text: 'Dirección' | translate } %}
                            {% block input_form_alert %}
                                {% if result.errors.address %}
                                    <div class="alert alert-danger">{{ 'Necesitamos saber tu dirección para actualizar tu información.' | translate }}</div>
                                {% endif %}
                            {% endblock input_form_alert %}
                        {% endembed %}

                        {% if current_language.country == 'BR' %}

                            {# Address number #}
                            
                            {% embed "snipplets/forms/form-input.tpl" with{type_number: true, input_for: 'number', input_value: result.number | default(address.number), input_name: 'number', input_id: 'number', input_label_text: 'Número' | translate } %}
                                {% block input_form_alert %}
                                    {% if result.errors.number %}
                                        <div class="alert alert-danger">{{ 'Necesitamos saber tu número para actualizar tu información.' | translate }}</div>
                                    {% endif %}
                                {% endblock input_form_alert %}
                            {% endembed %}

                            {# Address Floor #}
                            
                            {% embed "snipplets/forms/form-input.tpl" with{type_number: true, input_for: 'floor', input_value: result.floor | default(address.floor), input_name: 'floor', input_id: 'floor', input_label_text: 'Piso' | translate } %}
                                {% block input_form_alert %}
                                    {% if result.errors.floor %}
                                        <div class="alert alert-danger">{{ 'Necesitamos saber tu piso para actualizar tu información.' | translate }}</div>
                                    {% endif %}
                                {% endblock input_form_alert %}
                            {% endembed %}

                            {# Address Locality #}
                            
                            {% embed "snipplets/forms/form-input.tpl" with{type_text: true, input_for: 'locality', input_value: result.locality | default(address.locality), input_name: 'locality', input_id: 'locality', input_label_text: 'Localidad' | translate } %}
                                {% block input_form_alert %}
                                    {% if result.errors.locality %}
                                        <div class="alert alert-danger">{{ 'Necesitamos saber tu localidad para actualizar tu información.' | translate }}</div>
                                    {% endif %}
                                {% endblock input_form_alert %}
                            {% endembed %}

                        {% endif %}

                        {# Address Zipcode #}
                            
                        {% embed "snipplets/forms/form-input.tpl" with{type_tel: true, input_for: 'zipcode', input_value: result.zipcode | default(address.zipcode), input_name: 'zipcode', input_id: 'zipcode', input_label_text: 'Código Postal' | translate } %}
                            {% block input_form_alert %}
                                {% if result.errors.zipcode %}
                                    <div class="alert alert-danger">{{ 'Debes ingresar tu código postal' | translate }}</div>
                                {% endif %}
                            {% endblock input_form_alert %}
                        {% endembed %}


                       {# Address City #}
                            
                        {% embed "snipplets/forms/form-input.tpl" with{type_text: true, input_for: 'city', input_value: result.city | default(address.city), input_name: 'city', input_id: 'city', input_label_text: 'Ciudad' | translate } %}
                            {% block input_form_alert %}
                                {% if result.errors.city %}
                                    <div class="alert alert-danger">{{ 'Necesitamos saber tu ciudad para actualizar tu información.' | translate }}</div>
                                {% endif %}
                            {% endblock input_form_alert %}
                        {% endembed %}

                       {# Address Province #}
                            
                        {% embed "snipplets/forms/form-input.tpl" with{type_text: true, input_for: 'province', input_value: result.province | default(address.province), input_name: 'province', input_id: 'province', input_label_text: 'Provincia' | translate } %}
                            {% block input_form_alert %}
                                {% if result.errors.province %}
                                    <div class="alert alert-danger">{{ 'Necesitamos saber tu provincia para actualizar tu información.' | translate }}</div>
                                {% endif %}
                            {% endblock input_form_alert %}
                        {% endembed %}


                        {# Address Country #}
                        
                        {% embed "snipplets/forms/form-select.tpl" with{select_for: 'country', select_name: 'country', select_id: 'country', select_label: 'País' | translate } %}
                            {% block select_options %}{{ country_options }}{% endblock select_options %}
                            {% block input_form_alert %}
                                {% if result.errors.country %}
                                    <div class="alert alert-danger">{{ 'Necesitamos saber tu país para actualizar tu información.' | translate }}</div>
                                {% endif %}
                            {% endblock input_form_alert %}
                        {% endembed %}


                        {# Phone input #}

                        {% embed "snipplets/forms/form-input.tpl" with{type_tel: true, input_for: 'phone', input_value: result.phone | default(address.phone), input_name: 'phone', input_id: 'phone', input_label_text: 'Teléfono' | translate } %}
                            {% block input_form_alert %}
                                {% if result.errors.phone %}
                                    <div class="alert alert-danger">{{ 'Necesitamos saber tu teléfono para actualizar tu información.' | translate }}</div>
                                {% endif %}
                            {% endblock input_form_alert %}
                        {% endembed %}
                        
                    {% endblock %}
                {% endembed %}
            </div>
        </div>
    </div>
</section>