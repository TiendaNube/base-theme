{# Search Overlay - Hidden by default, controlled by JS #}
<div class="js-search-overlay fixed inset-0 z-9999 bg-black/30 backdrop-blur-sm opacity-0 pointer-events-none transition-opacity duration-300"
     data-state="closed"
     role="dialog"
     aria-modal="true"
     aria-label="{{ 'Busca de produtos' | translate }}">

  {# Search Panel - Fixed position: mobile closer to header (20%), desktop at 30% #}
  <div class="js-search-panel fixed top-20 md:top-[30%] left-1/2 -translate-x-1/2 w-[90vw] max-w-125 bg-black/30 backdrop-blur-sm p-2 rounded-lg">

    {# Card único: o painel envolve input + resultados #}
    {# Search Form - Classes obrigatórias para LS.search() #}
    <form class="js-search-container js-search-form flex items-center gap-2"
          action="{{ store.search_url }}"
          method="get"
          role="search">

      {# Icon container - always takes space to prevent text shift #}
      <div class="w-5 h-5 shrink-0 flex items-center justify-center relative">
        {# Search icon wrapper - shown by default, positioned absolutely #}
        <div class="js-search-icon w-5 h-5 absolute flex items-center justify-center">
          <i data-lucide="search" class="w-5 h-5 text-bg" aria-hidden="true"></i>
        </div>

        {# Loading spinner - hidden by default, overlays search icon when shown #}
        <svg class="js-search-loading w-5 h-5 text-bg animate-spin hidden absolute" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" aria-hidden="true">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
      </div>

      {# Search Input - Class obrigatória js-search-input #}
      <input
        class="js-search-input flex-1 bg-transparent border-0 outline-none text-bg placeholder:text-bg/60 font-sans text-base"
        type="search"
        name="q"
        autocomplete="off"
        placeholder="{{ 'Busque o produto que deseja' | translate }}"
        aria-label="{{ 'Campo de busca de produtos' | translate }}"
        aria-autocomplete="list"
        aria-controls="search-suggestions"
      />

      {# Close Button #}
      <button
        type="button"
        class="js-search-close shrink-0 p-1 hover:opacity-70 transition-opacity cursor-pointer"
        aria-label="{{ 'Fechar busca' | translate }}"
      >
        <i data-lucide="x" class="w-5 h-5 text-bg" aria-hidden="true"></i>
      </button>
    </form>

    {# Search Suggestions Container - Injetado via LS.search() #}
    <div id="search-suggestions" class="js-search-suggest mt-2 pt-2 border-t border-white/10" role="listbox" style="display: none;"></div>

  </div>
</div>
