<div class="js-cart-item cart-item {% if item.product.is_non_shippable %}js-cart-item-non-shippable{% else %}js-cart-item-shippable{% endif %} {% if cart_page %}row align-items-md-center {% if loop.last %}mb-2{% else %}mb-5{% endif %} {% else %}form-row{% endif %}" data-item-id="{{ item.id }}" data-store="cart-item-{{ item.product.id }}">

  {% set show_free_shipping_label = item.product.free_shipping and not (cart.free_shipping.cart_has_free_shipping or cart.free_shipping.min_price_free_shipping.min_price) %}

  {# Cart item image #}
  <div class="{% if cart_page %}col-3 col-md-2{% else %}col-3 pr-3{% endif %}">
    <a href="{{ item.url }}">
      <img src="{{ item.featured_image | product_image_url('medium') }}" class="img-fluid" />
    </a>
  </div>
  <div class="{% if cart_page %}col-9 col-md pl-0 pl-md-3{% else %}col-9 d-flex align-items-center{% endif %}">

    {# Cart item name #}
    <div class="{% if cart_page %}row align-items-center{% else %}w-100{% endif %}">
      <h6 class="font-weight-normal {% if cart_page %}col-12 col-md-6 h4-md mb-2 mb-md-0{% else %}cart-item-name mb-0{% endif %}">
        <a href="{{ item.url }}">
          {{ item.short_name }}
        </a>
        <small>{{ item.short_variant_name }}</small>
        {% if show_free_shipping_label %}
          <div class="my-2">
            <span class="label label-secondary font-smallest">{{ "Envío gratis" | translate }}</span>
          </div>
        {% endif %}
      </h6>
      
      {% if cart_page %}
        {% set cart_quantity_class = 'float-md-none m-auto ' %}
      {% else %}
        {% set cart_quantity_class = 'float-left ' %}
      {% endif %}

      <div class="cart-item-quantity {% if cart_page %}col-7 col-md-3{% endif %}">
        {% embed "snipplets/forms/form-input.tpl" with{
          type_number: true, 
          input_value: item.quantity, 
          input_name: 'quantity[' ~ item.id ~ ']', 
          input_data_attr: 'item-id',
          input_data_val: item.id,
          input_group_custom_class: cart_quantity_class ~ 'form-quantity w-auto mb-2', 
          input_custom_class: 'js-cart-quantity-input cart-item-input form-control', 
          input_label: false, input_append_content: true} %}
            {% block input_prepend_content %}
            <div class="row m-0 justify-content-md-center {% if cart_page %}align-items-center{% endif %}">
              <span class="js-cart-quantity-btn cart-item-btn btn" onclick="LS.minusQuantity({{ item.id }}{% if not cart_page %}, true{% endif %})">
                {% include "snipplets/svg/minus.tpl" with {svg_custom_class: "icon-inline svg-icon-text"} %}
              </span>
            {% endblock input_prepend_content %}
            {% block input_append_content %}
              <span class="js-cart-input-spinner cart-item-spinner" style="display: none;">
                {% include "snipplets/svg/sync-alt.tpl" with {svg_custom_class: "icon-inline icon-spin svg-icon-text"} %}
              </span>
              <span class="js-cart-quantity-btn cart-item-btn btn" onclick="LS.plusQuantity({{ item.id }}{% if not cart_page %}, true{% endif %})">
                {% include "snipplets/svg/plus.tpl" with {svg_custom_class: "icon-inline svg-icon-text"} %}
              </span>
            </div>
            {% endblock input_append_content %}
        {% endembed %}
      </div>

      {# Cart item subtotal #}
      <h6 class="js-cart-item-subtotal cart-item-subtotal {% if cart_page %}col-5 col-md-3 text-right text-md-center h4-md font-weight-bold{% endif %}" data-line-item-id="{{ item.id }}">{{ item.subtotal | money }}</h6>
    </div>
  </div>

  {# Cart item delete #}
  <div class="cart-item-delete {% if cart_page %}position-relative-md col-auto col-md-1{% else %}col-1{% endif %} text-right">
    <button type="button" class="btn h6 {% if cart_page %}h5-md{% endif %} m-0" onclick="LS.removeItem({{ item.id }}{% if not cart_page %}, true{% endif %})">
      {% include "snipplets/svg/trash-alt.tpl" with {svg_custom_class: "icon-inline icon-lg svg-icon-text"} %}
    </button>
  </div>
</div>