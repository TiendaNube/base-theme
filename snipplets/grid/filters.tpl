{% set default_lang = current_language.lang %}
{% set filter_colors = insta_colors|length > 0 %}
{% set filter_more_colors = other_colors|length > 0 %}
{% set filter_sizes = size_properties_values|length > 0 %}
{% set filter_other = variants_properties|length > 0 %}

{% if default_lang == 'pt' %}
    {% set color_name = 'Cor' %}
    {% set size_name = 'Tamanho' %}
{% endif %}
{% if default_lang == 'es' %}
    {% set color_name = 'Color' %}
    {% set size_name = 'Talle' %}
{% endif %}
{% if default_lang == 'en' %}
    {% set color_name = 'Color' %}
    {% set size_name = 'Size' %}
{% endif %}
<div id="filters" data-store="filters-nav">
    {% if filter_colors or filter_more_colors %}
        <div class="mb-4" data-store="filters-group">
            <h6 class="mb-3">{{ 'Color' | translate }}</h6>
            {% for name,color in insta_colors %}
                <label class="checkbox-container font-weight-bold {% if mobile %}mb-3{% else %}mb-2{% endif %}" onclick="LS.urlAddParam('{{ color_name|replace("'","%27") }}', '{{ name|replace("'","%27") }}');">
                    <span class="checkbox">
                        <input type="checkbox" autocomplete="off">
                        <span class="checkbox-icon"></span>
                        <span class="checkbox-text">{{ name }}</span>
                        <span class="checkbox-color" style="background-color: {{ color[name] }};" title="{{ name }}"></span>
                    </span>
                </label>
            {% endfor %}
            {% for color in other_colors %}
                <label class="checkbox-container font-weight-bold {% if mobile %}mb-3{% else %}mb-2{% endif %}" onclick="LS.urlAddParam('{{ color_name|replace("'","%27") }}', '{{ color|replace("'","%27") }}');">
                    <span class="checkbox">
                        <input type="checkbox" autocomplete="off">
                        <span class="checkbox-icon"></span>
                        <span class="checkbox-text">{{ color }}</span>
                    </span>
                </label>
            {% endfor %}
        </div>
    {% endif %}
    {% if filter_sizes %}
        <div class="mb-4" data-store="filters-group">
            <h6 class="mb-3">{{ 'Talle' | translate }}</h6>
            {% for size in size_properties_values %}
                <label class="checkbox-container font-weight-bold {% if mobile %}mb-3{% else %}mb-2{% endif %}" onclick="LS.urlAddParam('{{ size_name|replace("'","%27") }}', '{{ size|replace("'","%27") }}');">
                    <span class="checkbox">
                        <input type="checkbox" autocomplete="off">
                        <span class="checkbox-icon"></span>
                        <span class="checkbox-text">{{ size }}</span>
                    </span>
                </label>
            {% endfor %}
        </div>
    {% endif %}

    {% for variants_property in variants_properties %}
        {% if filter_other %}
            <div class="mb-4" data-store="filters-group">
                <h6 class="mb-3">{{ variants_property }}</h6>
                {% for value in variants_properties_values[variants_property] %}
                    <label class="checkbox-container font-weight-bold {% if mobile %}mb-3{% else %}mb-2{% endif %}" onclick="LS.urlAddParam('{{ variants_property|replace("'","%27") }}', '{{ value|replace("'","%27") }}');">
                        <span class="checkbox">
                            <input type="checkbox" autocomplete="off">
                            <span class="checkbox-icon"></span>
                            <span class="checkbox-text">{{value}}</span>
                        </span>
                    </label>
                {% endfor %}
            </div>
        {% endif %}
    {% endfor %}
</div>