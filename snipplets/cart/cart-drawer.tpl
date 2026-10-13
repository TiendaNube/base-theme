{# Cart Drawer - slides in from right #}
<div
  class="js-cart-drawer fixed inset-0 z-90"
  data-state="closed"
>
  {# Transparent backdrop - captures clicks outside #}
  <div class="js-cart-drawer-backdrop absolute inset-0"></div>

  {# Drawer panel #}
  <div class="js-cart-drawer-panel absolute top-0 right-0 bottom-0 w-full max-w-[383px] flex flex-col bg-bg text-secondary">

    {# Header - Figma: 24px side padding, title ~24px #}
    <div class="flex items-center justify-between px-6 py-4">
      <h2 class="font-heading text-2xl font-semibold m-0">
        {{ "Carrinho" | translate }}
      </h2>
      <button
        type="button"
        class="js-cart-drawer-close -mr-2 w-10 h-10 flex items-center justify-center cursor-pointer text-secondary bg-transparent border-0 p-0"
        aria-label="{{ 'Fechar' | translate }}"
      >
        <i data-lucide="x" class="w-5 h-5"></i>
      </button>
    </div>

    {# Cart form - platform expects .js-ajax-cart-panel wrapping cart items for AJAX operations #}
    <form action="{{ store.cart_url }}" method="post" class="js-ajax-cart-panel flex-1 flex flex-col min-h-0" data-store="cart-form" data-component="cart">

      {# Items list - scrollable area #}
      <div class="js-ajax-cart-list flex-1 overflow-y-auto px-6 py-4">
        {% if cart.items %}
          {% for item in cart.items %}
            {# .js-cart-item + data-item-id required by platform for LS.removeItem/LS.changeQuantity #}
            <div class="js-cart-item flex items-start gap-4 py-3" data-item-id="{{ item.id }}" data-item-name="{{ item.short_name }}" data-store="cart-item-{{ item.product.id }}" data-component="cart.line-item">
              {# Item image - Figma cartItem 52:2058: small thumb, no border/background #}
              <a href="{{ item.url }}" class="shrink-0">
                <img
                  src="{{ item.featured_image | product_image_url('small') }}"
                  alt="{{ item.short_name }}"
                  class="w-10 aspect-[4/5] object-cover"
                />
              </a>

              {# Item details #}
              <div class="flex-1 min-w-0 flex flex-col gap-1">
                <a href="{{ item.url }}" class="text-base font-normal leading-tight text-secondary no-underline line-clamp-2" data-component="name.short-name">
                  {{ item.short_name }}
                </a>
                {% if item.short_variant_name %}
                  <small class="text-xs text-secondary opacity-60 truncate" data-component="name.short-variant-name">
                    {{ item.short_variant_name }}
                  </small>
                {% endif %}
                <div class="flex items-center gap-2">
                  {# Price - platform auto-updates .js-cart-item-subtotal #}
                  <span class="js-cart-item-subtotal text-base font-bold text-secondary" data-line-item-id="{{ item.id }}" data-component="subtotal.value" data-component-value="{{ item.subtotal | money }}">
                    {{ item.subtotal | money }}
                  </span>

                  {# Quantity controls - uses LS.minusQuantity/LS.plusQuantity with true for AJAX mode.
                     Each button has a 40px hit area (Fibery 224) around a 32px visual square. #}
                  <div class="flex items-center">
                    <span
                      class="js-cart-quantity-btn w-10 h-10 flex items-center justify-center cursor-pointer text-secondary"
                      onclick="LS.minusQuantity({{ item.id }}, true)"
                      data-component="quantity.minus"
                    >
                      <span class="size-8 flex items-center justify-center rounded-md bg-control">
                        <i data-lucide="minus" class="w-3.5 h-3.5"></i>
                      </span>
                    </span>
                    <input
                      type="number"
                      name="quantity[{{ item.id }}]"
                      value="{{ item.quantity }}"
                      class="js-cart-quantity-input size-8 mx-1 text-center text-base font-medium text-secondary bg-control rounded-md border-0 p-0 outline-none [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
                      data-item-id="{{ item.id }}"
                      data-component="quantity.value"
                    />
                    {# Spinner - required by platform to show loading during AJAX operations #}
                    <span class="js-cart-input-spinner cart-item-spinner" style="display:none">
                    </span>
                    <span
                      class="js-cart-quantity-btn w-10 h-10 flex items-center justify-center cursor-pointer text-secondary"
                      onclick="LS.plusQuantity({{ item.id }}, true)"
                      data-component="quantity.plus"
                    >
                      <span class="size-8 flex items-center justify-center rounded-md bg-control">
                        <i data-lucide="plus" class="w-3.5 h-3.5"></i>
                      </span>
                    </span>
                  </div>
                </div>
              </div>

              {# Delete button - animated removal handled by cart-drawer.js; 40px hit area #}
              <button
                type="button"
                class="js-cart-remove-btn shrink-0 self-start -mt-2 -mr-2 w-10 h-10 flex items-center justify-center cursor-pointer text-secondary opacity-50 bg-transparent border-0 p-0"
                data-remove-item-id="{{ item.id }}"
                aria-label="{{ 'Remover item' | translate }}"
                data-component="line-item.remove"
              >
                <i data-lucide="trash-2" class="w-4 h-4"></i>
              </button>
            </div>
          {% endfor %}
        {% endif %}
      </div>

      {# Empty cart - platform shows .js-empty-ajax-cart when cart becomes empty #}
      <div class="js-empty-ajax-cart flex flex-col items-center justify-center h-full gap-4 text-center px-5" {% if cart.items %}style="display:none"{% endif %}>
        <i data-lucide="shopping-cart" class="w-12 h-12 opacity-30 text-secondary"></i>
        <p class="text-sm text-secondary opacity-60 m-0">
          {{ "Seu carrinho está vazio" | translate }}
        </p>
        <a href="{{ store.products_url }}" class="text-sm text-secondary underline">
          {{ "Ver produtos" | translate }}
        </a>
      </div>

      {# Hidden subtotal for platform JS calculations #}
      <div class="js-subtotal-price hidden" data-priceraw="{{ cart.total }}"></div>

      {# Footer - total + CTA (inside form so submit triggers checkout) #}
      <div class="js-cart-drawer-footer js-visible-on-cart-filled sticky bottom-0 px-6 py-4" {% if not cart.items %}style="display:none"{% endif %}>
        {# Progress bars (free shipping + progressive discounts) #}
        {% snipplet "cart/cart-drawer-progress-bars.tpl" %}
        {# Figma finalizeCheckoutContainer 24:2034: emphasized, right-aligned. The value is cart.subtotal, so the label stays "Subtotal". #}
        <div class="flex flex-col items-end gap-1 mb-3">
          <div class="flex items-baseline gap-1 text-lg font-bold text-secondary">
            <span>{{ "Subtotal" | translate }}:</span>
            <span class="js-ajax-cart-total js-cart-subtotal" data-priceraw="{{ cart.subtotal }}">{{ cart.subtotal | money }}</span>
          </div>
          {# Installments come from the store's payment configuration via the platform "installments"
             component (cart location, computed on the cart total; renders nothing when there is no
             interest-free option). Pix discount from the platform component. 10px highlight labels. #}
          <div class="flex items-center gap-3 font-sans text-[10px] font-medium text-highlight empty:hidden">
            {{- component('installments', {'location': 'cart', container_classes: { installment: 'text-[10px] font-medium text-highlight' }}) -}}
            {%- if settings.payment_discount_price -%}
              {{- component('payment-discount-price', {visibility_condition: true, location: 'cart', container_classes: 'text-[10px] font-medium text-highlight'}) -}}
            {%- endif -%}
          </div>
        </div>
        {% if not settings.payment_discount_price %}
          <div class="js-payment-discount-price-cart-container" style="display:none">
            <span class="js-payment-discount-price-cart"></span>
            <span class="js-payment-discount-name-cart"></span>
          </div>
        {% endif %}
        <input
          type="submit"
          name="go_to_checkout"
          value="{{ 'Ir para o Checkout' | translate }}"
          class="js-cart-drawer-checkout block w-full h-10 text-center bg-secondary text-bg rounded-lg text-base font-semibold no-underline transition-opacity duration-150 cursor-pointer border-0"
        />
      </div>

    </form>
  </div>
</div>
