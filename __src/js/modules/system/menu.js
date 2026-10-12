export const menuSystem = () => {
  const menuMobile = document.querySelector(".js-menu-mobile");
  const menuMobileToggle = document.querySelector(".js-menu-mobile-toggle");
  const menuMobileClose = document.querySelector(".js-menu-mobile-close");
  const menuMobileTabs = document.querySelectorAll(".js-menu-mobile-tab");
  const menuMobilePanels = document.querySelectorAll(".js-menu-mobile-panel");
  const menuDesktopToggles = document.querySelectorAll(".js-menu-desktop-toggle");
  const menuDropdowns = document.querySelectorAll(".js-menu-dropdown");

  let isMobileMenuOpen = false;
  let activeDesktopMenu = null;

  // === MOBILE ===

  const openMobileMenu = () => {
    if (!menuMobile) return;
    isMobileMenuOpen = true;
    menuMobile.hidden = false;

    const scrollPos = window.scrollY;
    document.body.style.overflow = "hidden";
    document.documentElement.style.overflow = "hidden";
    document.body.style.position = "fixed";
    document.body.style.width = "100%";
    document.body.style.top = "-" + scrollPos + "px";

    window.setHeaderMenuActive?.(true);

    reinitIcons();
    requestAnimationFrame(initMenuCarousel);
  };

  const closeMobileMenu = () => {
    if (!menuMobile) return;
    isMobileMenuOpen = false;
    menuMobile.hidden = true;

    const scrollY = Math.abs(parseInt(document.body.style.top || "0", 10));
    document.body.style.overflow = "";
    document.documentElement.style.overflow = "";
    document.body.style.position = "";
    document.body.style.width = "";
    document.body.style.top = "";
    window.scrollTo(0, scrollY);

    window.setHeaderMenuActive?.(false);
  };

  const switchMobileTab = (index) => {
    menuMobileTabs.forEach((tab, i) => {
      if (i === index) {
        tab.classList.add("bg-black/5!", "font-semibold!");
      } else {
        tab.classList.remove("bg-black/5!", "font-semibold!");
      }
    });
    menuMobilePanels.forEach((panel, i) => {
      if (i === index) {
        panel.classList.remove("hidden");
        panel.classList.add("block");
      } else {
        panel.classList.remove("block");
        panel.classList.add("hidden");
      }
    });
    reinitIcons();
  };

  menuMobileToggle?.addEventListener("click", () => {
    isMobileMenuOpen ? closeMobileMenu() : openMobileMenu();
  });

  menuMobileClose?.addEventListener("click", closeMobileMenu);

  menuMobileTabs.forEach((tab, index) => {
    tab.addEventListener("click", () => switchMobileTab(index));
  });

  // === MENU CAROUSEL (Swiper) ===

  const menuSeedSVG = (() => {
    const styles = getComputedStyle(document.documentElement);
    const activeColor = styles.getPropertyValue("--text-color").trim();
    const inactiveColor = "color-mix(in srgb, var(--text-color) 40%, transparent)";
    return (active) => `
      <svg xmlns="http://www.w3.org/2000/svg" width="11" height="8" viewBox="0 0 11 8" fill="none">
        <path d="M6.93294 6.9178C10.0118 6.33768 11.5457 4.64453 10.8236 2.44759C10.2482 0.697531 8.31108 -0.0463472 6.24753 0.00222694C4.0117 0.0549646 2.34216 1.16245 1.5248 2.83063C1.07947 3.73966 0.564497 5.41477 0.0330304 6.99968C-0.164895 7.58812 0.559 8.12244 1.34154 7.97533C2.63722 7.73523 5.76371 7.13846 6.93294 6.9178Z" fill="${active ? activeColor : inactiveColor}"/>
      </svg>`;
  })();

  function renderMenuPagination(swiper, paginationEl, realCount) {
    if (!paginationEl) return;
    const current = swiper.realIndex;
    let html = "";
    for (let i = 0; i < realCount; i++) {
      html += `<span class="inline-flex items-center justify-center w-6 h-6 cursor-pointer js-menu-carousel-seed" data-index="${i}">${menuSeedSVG(i === current)}</span>`;
    }
    paginationEl.innerHTML = html;
    paginationEl.querySelectorAll(".js-menu-carousel-seed").forEach((seed) => {
      seed.addEventListener("click", () => {
        swiper.slideToLoop(parseInt(seed.dataset.index));
      });
    });
  }

  function initMenuCarousel() {
    document.querySelectorAll(".js-menu-carousel").forEach((carousel) => {
      if (carousel._swiperInit) return;
      carousel._swiperInit = true;

      const controlsBar = carousel.nextElementSibling?.classList.contains("js-menu-carousel-controls")
        ? carousel.nextElementSibling
        : null;
      const paginationEl = controlsBar?.querySelector(".js-menu-carousel-pagination");
      const prevBtn = controlsBar?.querySelector(".js-menu-carousel-prev");
      const nextBtn = controlsBar?.querySelector(".js-menu-carousel-next");

      const realCount = carousel.querySelectorAll(".swiper-slide").length;

      const swiper = new Swiper(carousel, {
        slidesPerView: "auto",
        spaceBetween: 0,
        threshold: 10,
        loop: true,
        watchOverflow: true,
        on: {
          slideChange: function () {
            renderMenuPagination(this, paginationEl, realCount);
          },
          init: function () {
            renderMenuPagination(this, paginationEl, realCount);
            if (this.isLocked && controlsBar) controlsBar.style.display = "none";
          },
        },
      });

      if (prevBtn) {
        prevBtn.addEventListener("click", () => swiper.slidePrev());
      }
      if (nextBtn) {
        nextBtn.addEventListener("click", () => swiper.slideNext());
      }

      if (typeof lucide !== "undefined") lucide.createIcons();
    });
  }

  // === DESKTOP ===

  const openDesktopMenu = (index) => {
    const dropdown = menuDropdowns[index];
    const toggle = menuDesktopToggles[index];
    if (!dropdown || !toggle) return;

    closeAllDesktopMenus();
    activeDesktopMenu = index;
    dropdown.hidden = false;
    toggle.setAttribute("aria-expanded", "true");

    const iconClosed = toggle.querySelector(".js-icon-closed");
    const iconOpen = toggle.querySelector(".js-icon-open");
    if (iconClosed) iconClosed.classList.add("hidden");
    if (iconOpen) iconOpen.classList.remove("hidden");

    window.setHeaderMenuActive?.(true);
    reinitIcons();
    requestAnimationFrame(initMenuCarousel);
  };

  const closeDesktopMenu = (index) => {
    const dropdown = menuDropdowns[index];
    const toggle = menuDesktopToggles[index];
    if (!dropdown || !toggle) return;

    dropdown.hidden = true;
    toggle.setAttribute("aria-expanded", "false");

    const iconClosed = toggle.querySelector(".js-icon-closed");
    const iconOpen = toggle.querySelector(".js-icon-open");
    if (iconClosed) iconClosed.classList.remove("hidden");
    if (iconOpen) iconOpen.classList.add("hidden");
  };

  const closeAllDesktopMenus = () => {
    menuDesktopToggles.forEach((_, i) => closeDesktopMenu(i));
    activeDesktopMenu = null;
    window.setHeaderMenuActive?.(false);
  };

  menuDesktopToggles.forEach((toggle, index) => {
    toggle.addEventListener("click", (e) => {
      e.preventDefault();
      activeDesktopMenu === index ? closeAllDesktopMenus() : openDesktopMenu(index);
    });
  });

  document.addEventListener("click", (e) => {
    if (activeDesktopMenu === null) return;
    if (!e.target.closest("[data-menu-desktop]") && !e.target.closest(".js-menu-dropdown")) {
      closeAllDesktopMenus();
    }
  });

  // === ACCORDION (event delegation) ===

  document.addEventListener("click", (e) => {
    const toggle = e.target.closest(".js-menu-accordion-toggle");
    if (!toggle) return;

    const isExpanded = toggle.getAttribute("aria-expanded") === "true";
    const currentLi = toggle.closest("li");
    const content = currentLi?.querySelector(".js-menu-accordion-content");
    if (!content) return;

    // Close siblings at the same level
    const parentUl = currentLi.parentElement;
    if (parentUl && !isExpanded) {
      parentUl.querySelectorAll(":scope > li").forEach((li) => {
        if (li === currentLi) return;
        const siblingToggle = li.querySelector(".js-menu-accordion-toggle");
        const siblingContent = li.querySelector(".js-menu-accordion-content");
        if (siblingToggle && siblingContent) {
          siblingToggle.setAttribute("aria-expanded", "false");
          siblingContent.hidden = true;
        }
      });
    }

    toggle.setAttribute("aria-expanded", String(!isExpanded));
    content.hidden = isExpanded;
    if (!isExpanded) reinitIcons();
  });

  // === ESC KEY ===

  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape") {
      if (isMobileMenuOpen) closeMobileMenu();
      if (activeDesktopMenu !== null) closeAllDesktopMenus();
    }
  });

  // === HELPERS ===

  function reinitIcons() {
    setTimeout(() => {
      if (typeof lucide !== "undefined") lucide.createIcons();
    }, 50);
  }
};