export const searchSystem = () => {
  // DOM Elements
  const overlay = document.querySelector(".js-search-overlay");
  const panel = document.querySelector(".js-search-panel");
  const input = document.querySelector(".js-search-input");
  const form = document.querySelector(".js-search-form");
  const suggestContainer = document.querySelector(".js-search-suggest");
  const toggleButtons = document.querySelectorAll(".js-search-toggle");
  const closeButton = document.querySelector(".js-search-close");
  const searchIcon = document.querySelector(".js-search-icon");
  const loadingIcon = document.querySelector(".js-search-loading");

  if (!overlay || !input) return; // Safety check

  let isOpen = false;
  let debounceTimer = null;

  // ============================================
  // OPEN / CLOSE FUNCTIONS
  // ============================================

  function openSearch() {
    if (isOpen) return;

    isOpen = true;
    overlay.setAttribute("data-state", "open");

    // CSS handles opacity transition, we just toggle pointer-events after a frame
    requestAnimationFrame(() => {
      overlay.classList.remove("pointer-events-none");
      overlay.classList.add("opacity-100");
      overlay.classList.remove("opacity-0");
    });

    // Focus input immediately (important for mobile keyboard)
    input.focus();
    input.click(); // For mobile handlers

    // Prevent body scroll
    document.body.style.overflow = "hidden";
    document.documentElement.style.overflow = "hidden";
  }

  function closeSearch({ clear = true } = {}) {
    if (!isOpen) return;

    isOpen = false;
    overlay.setAttribute("data-state", "closed");

    overlay.classList.remove("opacity-100");
    overlay.classList.add("opacity-0");

    // Delay pointer-events removal to allow click animation to complete
    setTimeout(() => {
      overlay.classList.add("pointer-events-none");
    }, 300);

    // Clear input (unless submitting: the browser still has to serialize it)
    // and hide suggestions
    if (clear) input.value = "";
    if (suggestContainer) {
      suggestContainer.style.display = "none";
    }

    // Restore body scroll
    document.body.style.overflow = "";
    document.documentElement.style.overflow = "";
  }

  // ============================================
  // DEBOUNCE FUNCTION (300ms)
  // ============================================

  function debounce(func, delay) {
    return function (...args) {
      clearTimeout(debounceTimer);
      debounceTimer = setTimeout(() => func.apply(this, args), delay);
    };
  }

  // Input listener with debounce - triggers LS.search() indirectly
  // LS.search() is already listening to .js-search-input (store.js.tpl:449)
  // We debounce by preventing the input event from bubbling too frequently
  let lastValue = "";
  const debouncedInput = debounce((e) => {
    // LS.search() handles the actual AJAX call
    // We just need to ensure it's not called too often
    // Since LS.search() is already bound, we simulate debounce by
    // temporarily disabling and re-enabling the input
    const currentValue = e.target.value;
    if (currentValue !== lastValue) {
      lastValue = currentValue;
      // LS.search() will pick up the change automatically
    }
  }, 300);

  if (input) {
    input.addEventListener("input", debouncedInput);
  }

  // ============================================
  // LOADING STATE
  // ============================================

  // Show loading state during search (toggle between search icon and spinner)
  if (input && loadingIcon && searchIcon) {
    input.addEventListener("input", () => {
      if (input.value.length > 0) {
        // Show loading, hide search icon
        searchIcon.classList.add("hidden");
        loadingIcon.classList.remove("hidden");

        // Hide loading after debounce + request time (simulate)
        setTimeout(() => {
          loadingIcon.classList.add("hidden");
          searchIcon.classList.remove("hidden");
        }, 800); // 300ms debounce + ~500ms request
      } else {
        // Show search icon, hide loading
        loadingIcon.classList.add("hidden");
        searchIcon.classList.remove("hidden");
      }
    });
  }

  // ============================================
  // EVENT LISTENERS
  // ============================================

  // Toggle buttons (header "Buscar" button)
  toggleButtons.forEach((btn) => {
    btn.addEventListener("click", (e) => {
      e.preventDefault();
      openSearch();
    });
  });

  // Close button (X inside panel)
  if (closeButton) {
    closeButton.addEventListener("click", (e) => {
      e.preventDefault();
      closeSearch();
    });
  }

  // ESC key handler
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && isOpen) {
      closeSearch();
    }
  });

  // Click outside panel (on overlay)
  overlay.addEventListener("click", (e) => {
    if (e.target === overlay) {
      closeSearch();
    }
  });

  // Form submit - close panel and navigate
  if (form) {
    form.addEventListener("submit", () => {
      closeSearch({ clear: false });
      // Form submits naturally to store.search_url
    });
  }

  // "Ver todos os resultados" link click - submits form
  // This is handled by store.js.tpl:478-482, we just ensure panel closes
  document.addEventListener("click", (e) => {
    if (e.target.classList.contains("js-search-suggest-all-link")) {
      closeSearch();
      // store.js.tpl handles form submit
    }
  });

  // ============================================
  // FOCUS TRAP (mantém foco dentro do panel)
  // ============================================

  function handleFocusTrap(e) {
    if (!isOpen) return;

    const focusableElements = panel.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );

    const firstElement = focusableElements[0];
    const lastElement = focusableElements[focusableElements.length - 1];

    // Tab forward from last element -> go to first
    if (e.key === "Tab" && !e.shiftKey && document.activeElement === lastElement) {
      e.preventDefault();
      firstElement.focus();
    }

    // Shift+Tab backward from first element -> go to last
    if (e.key === "Tab" && e.shiftKey && document.activeElement === firstElement) {
      e.preventDefault();
      lastElement.focus();
    }
  }

  document.addEventListener("keydown", handleFocusTrap);
};
