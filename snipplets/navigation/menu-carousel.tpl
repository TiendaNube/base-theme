{#
  Menu Carousel Component
  Exibe até 6 categorias configuráveis com imagem, título e botão.
#}

{% set categories = [] %}

{% if "menu_category_01.jpg" | has_custom_image and settings.menu_category_01_title %}
  {% set categories = categories | merge([{
    image: 'menu_category_01.jpg' | static_url | settings_image_url('original'),
    title: settings.menu_category_01_title,
    button: settings.menu_category_01_button | default('Ver Tudo' | translate),
    url: settings.menu_category_01_url
  }]) %}
{% endif %}

{% if "menu_category_02.jpg" | has_custom_image and settings.menu_category_02_title %}
  {% set categories = categories | merge([{
    image: 'menu_category_02.jpg' | static_url | settings_image_url('original'),
    title: settings.menu_category_02_title,
    button: settings.menu_category_02_button | default('Ver Tudo' | translate),
    url: settings.menu_category_02_url
  }]) %}
{% endif %}


{% if "menu_category_03.jpg" | has_custom_image and settings.menu_category_03_title %}
  {% set categories = categories | merge([{
    image: 'menu_category_03.jpg' | static_url | settings_image_url('original'),
    title: settings.menu_category_03_title,
    button: settings.menu_category_03_button | default('Ver Tudo' | translate),
    url: settings.menu_category_03_url
  }]) %}
{% endif %}


{% if "menu_category_04.jpg" | has_custom_image and settings.menu_category_04_title %}
  {% set categories = categories | merge([{
    image: 'menu_category_04.jpg' | static_url | settings_image_url('original'),
    title: settings.menu_category_04_title,
    button: settings.menu_category_04_button | default('Ver Tudo' | translate),
    url: settings.menu_category_04_url
  }]) %}
{% endif %}


{% if "menu_category_05.jpg" | has_custom_image and settings.menu_category_05_title %}
  {% set categories = categories | merge([{
    image: 'menu_category_05.jpg' | static_url | settings_image_url('original'),
    title: settings.menu_category_05_title,
    button: settings.menu_category_05_button | default('Ver Tudo' | translate),
    url: settings.menu_category_05_url
  }]) %}
{% endif %}

{% if "menu_category_06.jpg" | has_custom_image and settings.menu_category_06_title %}
  {% set categories = categories | merge([{
    image: 'menu_category_06.jpg' | static_url | settings_image_url('original'),
    title: settings.menu_category_06_title,
    button: settings.menu_category_06_button | default('Ver Tudo' | translate),
    url: settings.menu_category_06_url
  }]) %}
{% endif %}

{% if categories | length > 0 %}
<div class="js-menu-carousel swiper relative w-full">
  <div class="swiper-wrapper">
    {% for category in categories %}
      <div class="swiper-slide" style="width:auto">
        <a href="{{ category.url }}" class="no-underline block w-70">
          <div class="relative aspect-4/5 overflow-hidden">
            <img
              src="{{ category.image }}"
              alt="{{ category.title }}"
              class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
            />
            <div class="absolute inset-x-0 bottom-0 px-5 py-12 bg-linear-to-t from-black/70 to-transparent text-white flex flex-col items-center"> {# lint-styles: allow overlay #}
              <span class="text-base font-heading font-semibold">{{ category.title }}</span>
              <span class="text-sm flex items-center">
                {{ category.button }}
                <i data-lucide="arrow-right" class="w-3 h-3 ml-1"></i>
              </span>
            </div>
          </div>
        </a>
      </div>
    {% endfor %}
  </div>
</div>
<div class="js-menu-carousel-controls flex items-center justify-between mt-4 px-4 md:px-0">
  <div class="js-menu-carousel-pagination flex items-center gap-2"></div>
  <div class="flex items-center gap-2">
    <button type="button" class="js-menu-carousel-prev flex w-8 h-8 justify-center items-center cursor-pointer" aria-label="{{ 'Anterior' | translate }}">
      <i data-lucide="arrow-left" class="w-5 h-5 text-secondary"></i>
    </button>
    <button type="button" class="js-menu-carousel-next flex w-8 h-8 justify-center items-center cursor-pointer" aria-label="{{ 'Siguiente' | translate }}">
      <i data-lucide="arrow-right" class="w-5 h-5 text-secondary"></i>
    </button>
  </div>
</div>
{% endif %}
