export const productCarousel = () => {
  const section = document.querySelector(".js-product-carousel");
  if (!section) return;

  const dropdown = section.querySelector(".js-carousel-dropdown");
  const dropdownTrigger = section.querySelector(".js-carousel-dropdown-trigger");
  const dropdownLabel = section.querySelector(".js-carousel-dropdown-label");
  const dropdownList = section.querySelector(".js-carousel-dropdown-list");
  const dropdownIcon = section.querySelector(".js-carousel-dropdown-icon");
  const dropdownOptions = section.querySelectorAll(".js-carousel-dropdown-option");
  const tabs = section.querySelectorAll(".js-carousel-tab");
  const paginationContainer = section.querySelector(".js-carousel-pagination");
  const prevBtn = section.querySelector(".js-carousel-prev");
  const nextBtn = section.querySelector(".js-carousel-next");

  // SVG for seed pagination dot
  // Theme colors only (ADR-0003): same pattern as product-gallery.js / menu.js
  // Figma (Fibery task 231): inactive seeds are almost the background colour — the text colour
  // diluted ~15% into the theme background (opaque, so it reads the same over any section bg).
  const activeColor = "var(--text-color)";
  const inactiveColor = "color-mix(in srgb, var(--text-color) 15%, var(--background-color))";
  const seedSVG = (active) => `
    <svg xmlns="http://www.w3.org/2000/svg" width="11" height="8" viewBox="0 0 11 8" fill="none">
      <path d="M6.93294 6.9178C10.0118 6.33768 11.5457 4.64453 10.8236 2.44759C10.2482 0.697531 8.31108 -0.0463472 6.24753 0.00222694C4.0117 0.0549646 2.34216 1.16245 1.5248 2.83063C1.07947 3.73966 0.564497 5.41477 0.0330304 6.99968C-0.164895 7.58812 0.559 8.12244 1.34154 7.97533C2.63722 7.73523 5.76371 7.13846 6.93294 6.9178Z" fill="${active ? activeColor : inactiveColor}"/>
    </svg>`;

  // Controls container (seeds + arrows)
  const controlsContainer = section.querySelector(".js-carousel-controls");

  // Initialize Swiper instances
  const swipers = {};
  const realSlideCounts = {};
  let activeTab = "tab-1";
  let initCount = 0;

  function getActiveSwiper() {
    return swipers[activeTab];
  }

  // Show/hide controls (invisible but keeping space) when not needed
  function updateControlsVisibility(realCount) {
    if (!controlsContainer) return;
    // With infinite loop, always show controls if there are at least 2 items
    // Hide only when there's 1 or 0 items (nothing to scroll)
    const needsControls = realCount >= 2;
    controlsContainer.style.visibility = needsControls ? "visible" : "hidden";
  }

  // Update seed pagination (1 seed per real product)
  function updatePagination(swiper) {
    if (!paginationContainer || !swiper) return;
    const realCount = realSlideCounts[activeTab] || 0;
    const isLoop = swiper.params.loop;
    const currentIndex = isLoop ? swiper.realIndex : swiper.activeIndex;
    renderPagination(realCount, currentIndex);
  }

  // Update pagination with a specific index (used when switching tabs)
  function updatePaginationForIndex(index) {
    const realCount = realSlideCounts[activeTab] || 0;
    renderPagination(realCount, index);
  }

  // Render the pagination seeds
  function renderPagination(realCount, currentIndex) {
    if (!paginationContainer) return;

    let html = "";
    for (let i = 0; i < realCount; i++) {
      // 24x40 hit area around the 11x8 glyph: 24px pitch keeps the seeds close like Figma (WCAG 2.5.8 minimum); the 40px arrows are the primary control
      html += `<span class="inline-flex items-center justify-center w-6 h-10 shrink-0 cursor-pointer js-carousel-seed" data-index="${i}">${seedSVG(i === currentIndex)}</span>`;
    }
    paginationContainer.innerHTML = html;

    // Click listeners on seeds
    paginationContainer.querySelectorAll(".js-carousel-seed").forEach((seed) => {
      seed.addEventListener("click", () => {
        const idx = parseInt(seed.dataset.index);
        const sw = getActiveSwiper();
        if (!sw) return;
        if (sw.params.loop) {
          sw.slideToLoop(idx);
        } else {
          sw.slideTo(idx);
        }
      });
    });
  }

  // Init swipers for each tab (using setTimeout like the theme's createSwiper)
  // Figma (Fibery task 231) on mobile: fixed 234px cards (width set on the slide by the template,
  // slidesPerView: 'auto'), track edge to edge, gap 0 → ~1.7 visible at 393px (peek of the 2nd).
  // From md the cards go fluid with a peek, as before the Figma pass — fixed 234px cards left huge
  // gaps on wide screens:
  //   tablet  (768+)   3.25 per view, gap 16px
  //   desktop (1280+)  4.25 per view, gap 16px
  // The loop needs at least twice the visible count plus one; 6 covers every case above.
  const maxVisibleSlides = 6;

  for (let i = 1; i <= 3; i++) {
    const container = section.querySelector(`.js-swiper-product-carousel-${i}`);
    if (container) {
      const slideCount = container.querySelectorAll(".swiper-slide").length;
      realSlideCounts[`tab-${i}`] = slideCount;

      // Garantir slides suficientes para o loop na tela mais larga
      // Necessário: maxVisibleSlides * 2 + 1 = 13 slides mínimo
      const minSlidesForLoop = maxVisibleSlides * 2 + 1;

      if (slideCount < minSlidesForLoop && slideCount >= 1) {
        const wrapper = container.querySelector(".swiper-wrapper");
        const originalSlides = Array.from(
          wrapper.querySelectorAll(".swiper-slide")
        );

        // Duplicar o conjunto inteiro até passar do mínimo: uma cópia parcial quebra a
        // paginação (realIndex % slideCount salta da última cópia incompleta para o seed 1)
        let currentCount = slideCount;
        while (currentCount < minSlidesForLoop) {
          for (const slide of originalSlides) {
            wrapper.appendChild(slide.cloneNode(true));
          }
          currentCount += slideCount;
        }
      }

      setTimeout(() => {
        // For loop to work smoothly, we need enough cloned slides. With slidesPerView 'auto'
        // Swiper 6 cannot infer how many to clone, so loopedSlides is mandatory: clone the
        // whole (already padded) set, never fewer than the widest visible count + 1.
        const actualSlideCount = container.querySelectorAll(".swiper-slide").length;
        const loopSlides = Math.max(actualSlideCount, maxVisibleSlides + 1);

        swipers[`tab-${i}`] = new Swiper(container, {
          slidesPerView: "auto",
          spaceBetween: 0,
          threshold: 10,
          loop: true,
          loopedSlides: loopSlides,
          loopAdditionalSlides: 2,
          breakpoints: {
            768: {
              slidesPerView: 3.25,
              spaceBetween: 16,
            },
            1280: {
              slidesPerView: 4.25,
              spaceBetween: 16,
            },
          },
          on: {
            slideChange: function () {
              if (`tab-${i}` === activeTab) {
                // realIndex already handles loop correctly
                const realIndex = this.realIndex % slideCount;
                updatePaginationForIndex(realIndex);
              }
            },
          },
        });

        initCount++;
        // After first tab swiper is ready, update UI
        if (i === 1 || (initCount === 1 && `tab-${i}` === activeTab)) {
          updatePagination(swipers[`tab-${i}`]);
          updateControlsVisibility(slideCount);
        }
      }, 0);
    }
  }

  // Switch to a given tab
  function switchTab(newTab) {
    tabs.forEach((tab) => {
      if (tab.dataset.tab === newTab) {
        tab.classList.remove("hidden");
      } else {
        tab.classList.add("hidden");
      }
    });
    activeTab = newTab;
    const swiper = getActiveSwiper();
    if (swiper) {
      swiper.update();
      // Reset to first slide when switching tabs
      if (swiper.params.loop) {
        swiper.slideToLoop(0, 0);
      } else {
        swiper.slideTo(0, 0);
      }
      // Force pagination to show first seed as active
      updatePaginationForIndex(0);
      updateControlsVisibility(realSlideCounts[activeTab] || 0);
    }
    if (typeof lucide !== "undefined") lucide.createIcons();
  }

  // Custom dropdown
  function closeDropdown() {
    if (!dropdownList) return;
    dropdownList.classList.add("hidden");
    if (dropdownIcon) dropdownIcon.style.transform = "";
    if (dropdownTrigger) dropdownTrigger.setAttribute("aria-expanded", "false");
  }

  function openDropdown() {
    if (!dropdownList) return;
    dropdownList.classList.remove("hidden");
    if (dropdownIcon) dropdownIcon.style.transform = "rotate(180deg)";
    if (dropdownTrigger) dropdownTrigger.setAttribute("aria-expanded", "true");
  }

  if (dropdownTrigger) {
    dropdownTrigger.addEventListener("click", () => {
      const isOpen = !dropdownList.classList.contains("hidden");
      isOpen ? closeDropdown() : openDropdown();
    });
  }

  dropdownOptions.forEach((option) => {
    option.addEventListener("click", () => {
      const newTab = option.dataset.value;
      if (dropdownLabel) dropdownLabel.textContent = option.textContent.trim();
      dropdownOptions.forEach((o) => o.removeAttribute("data-selected"));
      option.setAttribute("data-selected", "true");
      closeDropdown();
      switchTab(newTab);
    });
  });

  // Close dropdown when clicking outside
  document.addEventListener("click", (e) => {
    if (dropdown && !dropdown.contains(e.target)) {
      closeDropdown();
    }
  });

  // Navigation arrows
  if (prevBtn) {
    prevBtn.addEventListener("click", () => {
      const swiper = getActiveSwiper();
      if (swiper) swiper.slidePrev();
    });
  }

  if (nextBtn) {
    nextBtn.addEventListener("click", () => {
      const swiper = getActiveSwiper();
      if (swiper) swiper.slideNext();
    });
  }

  // Update controls visibility on resize (breakpoint may change)
  window.addEventListener("resize", () => {
    const swiper = getActiveSwiper();
    if (swiper) {
      updateControlsVisibility(realSlideCounts[activeTab] || 0);
    }
  });

  // Reinit icons for lazy loaded content
  if (typeof lucide !== "undefined") lucide.createIcons();
};