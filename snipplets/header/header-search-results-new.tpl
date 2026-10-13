{# Limita a 3 produtos apenas #}
{% set search_suggestions = products | take(3) %}
{% set total_products = products | length %}

{# Resultados: sem card próprio, vivem no card único do painel #}
<div class="flex w-full flex-col gap-1">

  {% if search_suggestions is not empty %}

    {# Lista de produtos (máximo 3) #}
    {% for product in search_suggestions %}
      <a
        href="{{ product.url }}"
        class="flex items-center gap-3 px-2 py-1 w-full hover:bg-white/10 rounded transition-colors duration-200"
        role="option"
      >
        {# Imagem do produto (tiny) #}
        <div class="shrink-0 w-12 aspect-4/5 bg-white/5 rounded overflow-hidden">
          {{ product.featured_image | product_image_url("small") | img_tag(product.featured_image.alt, {class: 'w-full h-full object-cover'}) }}
        </div>

        {# Informações do produto #}
        <div class="flex-1 min-w-0">
          <p class="search-result-name text-bg font-sans text-sm font-medium leading-[120%] truncate">
            {{ product.name | highlight(query) }}
          </p>
          {% if product.display_price %}
            <p class="text-bg font-sans text-sm font-extrabold leading-[120%]">
              {{ product.price | money }}
            </p>
          {% endif %}
        </div>

        {# Chevron right icon #}
        <i data-lucide="chevron-right" class="w-4 h-4 text-bg shrink-0"></i>
      </a>
    {% endfor %}

    {# Link "Ver todos os resultados" se houver mais de 3 produtos #}
    {% if total_products > 3 %}
      <button
        type="button"
        class="js-search-suggest-all-link w-full px-2 py-2 text-bg font-sans text-sm font-medium text-center hover:bg-white/10 rounded transition-colors duration-200 cursor-pointer"
      >
        {{ 'Ver todos os resultados' | translate }} ({{ total_products }})
      </button>
    {% endif %}

  {% else %}
    {# Mensagem quando não há resultados #}
    <p class="text-bg font-sans text-sm text-center w-full py-4">
      {{ 'Nenhum resultado encontrado' | translate }}
    </p>
  {% endif %}

</div>
