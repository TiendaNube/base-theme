{# Site Overlay #}
<div class="js-overlay site-overlay" style="display: none;"></div>

{# New Header - Fixed at top #}
<header
    class="js-new-header fixed top-0 left-0 right-0 z-50 flex flex-col w-full transition-[background-color,backdrop-filter] duration-300 overflow-hidden"
    data-state="{% if template == 'home' %}transparent{% else %}active{% endif %}"
    data-initial-state="{% if template == 'home' %}transparent{% else %}active{% endif %}"
    data-store="head"
>
    {# Advertising Bar - inside header, simulates scroll with translateY #}
    {% if settings.ad_bar and settings.ad_text %}
        {% snipplet "header/header-advertising-new.tpl" %}
    {% endif %}

    {# Main Header Container #}
    <div class="flex items-center justify-between w-full px-4 md:px-16 py-5.5">

        {# Mobile: Hamburger | Desktop: Logo #}
        <div class="flex items-center gap-4 flex-1">
            {# Hamburger - Mobile only (just opens menu, X is inside mobile menu) #}
            <button
              type="button"
              class="js-menu-mobile-toggle nav-link md:hidden p-1 cursor-pointer bg-transparent border-0"
              aria-label="{{ 'Menu' | translate }}"
            >
              <i data-lucide="menu" class="w-5 h-5"></i>
            </button>

            {# Logo - Desktop only (left aligned) #}
            <div class="hidden md:block">
                <a href="/">
                    {% if settings.logo_active_svg %}
                        <div class="logo-text text-2xl font-heading font-bold m-0 transition-colors duration-300">
                            {{ settings.logo_active_svg | raw }}
                        </div>
                    {% elseif "logo_active.png" | has_custom_image %}
                        <img
                            src="{{ 'images/empty-placeholder.png' | static_url }}"
                            data-src="{{ "logo_active.png" | static_url }}"
                            class="lazyload transition-all duration-300 h-8"
                            alt="{{ store.name }} - Menu Logo"
                        />
                    {% endif %}
                </a>
            </div>
        </div>

        {# Mobile: Logo (center) | Desktop: Navigation (center) #}
        <div class="flex items-center justify-center flex-1">
            {# Logo - Mobile only (centered) #}
            <div class="md:hidden">
                <a href="/">
                    {% if settings.logo_active_svg %}
                        <div class="logo-text text-xl font-heading font-bold m-0 transition-colors duration-300">
                            {{ settings.logo_active_svg | raw }}
                        </div>
                    {% elseif "logo_active.png" | has_custom_image %}
                        <img
                            src="{{ 'images/empty-placeholder.png' | static_url }}"
                            data-src="{{ "logo_active.png" | static_url }}"
                            class="lazyload transition-all duration-300 h-8"
                            alt="{{ store.name }} - Menu Logo"
                        />
                    {% endif %}
                </a>
            </div>

            {# Navigation - Desktop only #}
            {% if settings.menu_principal %}
              {% set main_menu = menus[settings.menu_principal] %}
              {% set highlighted_list = settings.menu_highlighted_items | default('') | split(',') | map(item => item | trim | lower) %}

              <nav class="hidden md:flex items-center gap-8" data-menu-desktop>
                {% for item in main_menu %}
                  {% set has_subitems = item.subitems is not empty %}
                  {% set is_highlighted = item.name | lower | trim in highlighted_list %}

                  {% if has_subitems %}
                    <button
                      type="button"
                      class="js-menu-desktop-toggle nav-link flex items-center gap-1 text-sm font-medium transition-colors duration-300 cursor-pointer bg-transparent border-0 {% if is_highlighted %}text-fg{% endif %}"
                      data-menu-index="{{ loop.index0 }}"
                      aria-expanded="false"
                    >
                      {{ item.name }}
                      <i data-lucide="plus" class="js-icon-closed w-3 h-3"></i>
                      <i data-lucide="minus" class="js-icon-open w-3 h-3 hidden"></i>
                    </button>
                  {% else %}
                    <a
                      href="{{ item.url }}"
                      class="nav-link flex items-center gap-1 text-sm font-medium transition-colors duration-300 {% if is_highlighted %}text-fg{% endif %}"
                      {% if item.url | is_external %}target="_blank" rel="noopener"{% endif %}
                    >
                      {{ item.name }}
                      <i data-lucide="arrow-right" class="w-3 h-3"></i>
                    </a>
                  {% endif %}
                {% endfor %}
              </nav>
            {% endif %}
        </div>

        {# Utilities - Right #}
        <div class="flex items-center justify-end gap-4 md:gap-6 flex-1">
            {# Buscar #}
            <button
              type="button"
              class="js-search-toggle nav-link text-sm font-medium transition-colors duration-300 flex items-center gap-1 cursor-pointer bg-transparent border-0"
              aria-label="{{ 'Abrir busca' | translate }}"
            >
                <i data-lucide="search" class="w-5 h-5 md:hidden"></i>
                <span class="hidden md:inline">Buscar</span>
            </button>
            {# Login #}
            <a href="{{ store.customer_login_url }}" class="nav-link text-sm font-medium transition-colors duration-300 flex items-center gap-1">
                <i data-lucide="user" class="w-5 h-5 md:hidden"></i>
                <span class="hidden md:inline">Login</span>
            </a>
            {# Carrinho #}
            <button
              type="button"
              class="js-cart-drawer-toggle nav-link text-sm font-medium transition-colors duration-300 flex items-center gap-1 cursor-pointer bg-transparent border-0"
              aria-label="{{ 'Carrinho' | translate }}"
            >
                <span class="relative md:hidden">
                  <i data-lucide="shopping-cart" class="w-5 h-5"></i>
                  <span class="js-cart-widget-badge absolute -top-1.5 -right-2 bg-fg text-bg text-[0.625rem] font-bold leading-none min-w-4 h-4 flex items-center justify-center rounded-full px-1" {% if cart.items_count == 0 %}hidden{% endif %}>{{ cart.items_count }}</span>
                </span>
                <span class="hidden md:inline">Carrinho</span>
                <span class="js-cart-widget-amount hidden md:inline">({{ cart.items_count }})</span>
            </button>
            <noscript>
              <a href="{{ store.cart_url }}" class="nav-link text-sm font-medium flex items-center gap-1">Carrinho</a>
            </noscript>
        </div>
    </div>

    {# Dropdown panels for each menu item with subitems - Desktop only #}
    {% if settings.menu_principal %}
      {% set main_menu = menus[settings.menu_principal] %}
      <div class="hidden md:block">
        {% for item in main_menu %}
          {% if item.subitems is not empty %}
            {% include 'snipplets/navigation/menu-dropdown-desktop.tpl' with {
              menu_items: item.subitems,
              show_carousel: loop.first,
              highlighted_items: settings.menu_highlighted_items
            } %}
          {% endif %}
        {% endfor %}
      </div>
    {% endif %}

    {# Mobile Menu #}
    {% include 'snipplets/navigation/menu-mobile.tpl' %}
</header>

{# Search Panel - FORA do header para não herdar posicionamento #}
{% include 'snipplets/header/header-search-new.tpl' %}

{# Spacer para compensar header fixed - oculto quando hero_banner é primeira seção #}
{% set hero_banner_first = settings.home_order_position_0 == 'hero_banner' and 'hero_banner_desktop.jpg' | has_custom_image %}
<div class="js-header-spacer h-25 md:h-30 {% if template == 'home' and hero_banner_first %}hidden{% endif %}"></div>
