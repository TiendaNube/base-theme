{# /*============================================================================
  #Item grid
==============================================================================*/

#Properties

#Slide Item

#}

{% set slide_item = slide_item | default(false) %}
{% set columns = settings.grid_columns %}

<div class="{% if slide_item %}swiper-slide{% else %}col{% if columns == 2 %}-6 col-md-3{% else %}-12 col-md-4{% endif %}{% endif %} item item-product">
    <div class="item-image mb-2">
        <a href="{{ store.url }}/product/example" title="{{ "Producto de ejemplo" | translate }}">
            {% set type_value = 
                help_item_1 ? 'shirt' : 
                help_item_2 ? 'camera' :
                help_item_3 ? 'dress' :
                help_item_4 ? 'sneakers' :
                help_item_5 ? 'joystick' :
                help_item_6 ? 'shoes' :
                help_item_7 ? 'bag' :
                help_item_8 ? 'glasses' 
            %}
            {{ component('placeholders/product-placeholder',{
                    type: type_value,
                })
            }}
        </a>
        {% if help_item_1 %}
            <div class="labels">
                <div class="label label-primary">{{ "20% OFF" | translate }}</div>
            </div>
        {% elseif help_item_2 %}
            <div class="labels">
                <div class="label label-secondary">{{ "Envío gratis" | translate }}</div>
            </div>
        {% elseif help_item_3 %}
            <div class="labels">
                <div class="label label-primary">{{ "35% OFF" | translate }}</div>
            </div>
        {% elseif help_item_7 %}
            <div class="labels">
                <div class="label label-primary">{{ "20% OFF" | translate }}</div>
            </div>
        {% endif %}
    </div>
    <div class="item-description">
        <a href="{{ store.url }}/product/example" title="{{ "Producto de ejemplo" | translate }}" class="item-link">
            <div class="item-name mb-1">{{ "Producto de ejemplo" | translate }}</div>
            <div class="item-price-container mb-1">
                {% set help_item_price = 
                    help_item_1 ? '9600' : 
                    help_item_2 ? '68000' :
                    help_item_3 ? '18200' :
                    help_item_4 ? '32000' :
                    help_item_5 ? '24900' :
                    help_item_6 ? '42000' :
                    help_item_7 ? '36800' :
                    help_item_8 ? '12200' 
                %}
                {% if help_item_1 or help_item_3 or help_item_7 %}
                    {% set item_promotional_price = true %}
                    {% set help_item_price_compare = 
                        help_item_1 ? '120000' : 
                        help_item_3 ? '28000' :
                        help_item_7 ? '46000'
                    %}
                {% endif %}
                {% if store.country != 'BR' %}
                    {% set help_item_price = help_item_price ~ "00" %}
                    {% if item_promotional_price %}
                        {% set help_item_price_compare = help_item_price_compare ~ "00" %}
                    {% endif %}
                {% endif %}
                {% if item_promotional_price %}
                    <span class="price-compare">{{ help_item_price_compare | money }}</span>
                {% endif %}
                <span class="item-price">{{ help_item_price | money }}</span>
            </div>
        </a>
    </div>
</div>