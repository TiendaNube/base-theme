export const heroBanner2Carousel = () => {
  const section = document.querySelector(".js-hero-banner-2");
  if (!section) return;

  const slides = section.querySelectorAll(".js-hero2-slide");
  if (slides.length < 2) return;

  const paginationContainer = section.querySelector(".js-hero2-pagination");
  const prevBtn = section.querySelector(".js-hero2-prev");
  const nextBtn = section.querySelector(".js-hero2-next");

  // Get slide colors from data attribute
  let slideColors = ["white", "white"];
  try {
    const colorsData = section.dataset.slideColors;
    if (colorsData) {
      slideColors = JSON.parse(colorsData);
    }
  } catch (e) {
    // fallback to white
  }

  // Color mapping: setting value -> actual color
  const colorMap = {
    white: "#FFFFFF", // lint-styles: allow admin-white
    primary: "var(--primary-color)",
    background: "var(--background-color)",
  };

  const getColor = (colorSetting) => colorMap[colorSetting] || "#FFFFFF"; // lint-styles: allow admin-white
  const getInactiveColor = (colorSetting) => {
    // Inactive seeds should have 40% opacity
    if (colorSetting === "white") return "rgba(255,255,255,0.4)";
    if (colorSetting === "primary") return "color-mix(in srgb, var(--primary-color) 40%, transparent)";
    if (colorSetting === "background") return "color-mix(in srgb, var(--background-color) 40%, transparent)";
    return "rgba(255,255,255,0.4)";
  };

  let currentSlide = 0;
  const AUTOPLAY_INTERVAL = 6000; // 6 seconds for hero banner
  let autoplayTimer = null;

  // SVG for seed pagination dot - dynamic color based on slide
  const seedSVG = (active, activeColor, inactiveColor) => `
    <svg xmlns="http://www.w3.org/2000/svg" width="11" height="8" viewBox="0 0 11 8" fill="none">
      <path d="M6.93294 6.9178C10.0118 6.33768 11.5457 4.64453 10.8236 2.44759C10.2482 0.697531 8.31108 -0.0463472 6.24753 0.00222694C4.0117 0.0549646 2.34216 1.16245 1.5248 2.83063C1.07947 3.73966 0.564497 5.41477 0.0330304 6.99968C-0.164895 7.58812 0.559 8.12244 1.34154 7.97533C2.63722 7.73523 5.76371 7.13846 6.93294 6.9178Z" fill="${active ? activeColor : inactiveColor}"/>
    </svg>`;

  function updateControlsColor(index) {
    const colorSetting = slideColors[index] || "white";
    const color = getColor(colorSetting);

    // Re-query arrows since lucide.createIcons() may have replaced them
    const currentArrows = section.querySelectorAll(".js-hero2-arrow");
    currentArrows.forEach((arrow) => {
      arrow.style.color = color;
    });
  }

  function showSlide(index) {
    slides.forEach((slide, i) => {
      if (i === index) {
        slide.classList.remove("opacity-0", "z-0");
        slide.classList.add("opacity-100", "z-10");
      } else {
        slide.classList.remove("opacity-100", "z-10");
        slide.classList.add("opacity-0", "z-0");
      }
    });
    updateControlsColor(index);
    renderPagination(index);
    if (typeof lucide !== "undefined") lucide.createIcons();
    // Re-apply color after lucide recreates icons
    setTimeout(() => updateControlsColor(index), 60);
  }

  function renderPagination(currentIndex) {
    if (!paginationContainer) return;

    const colorSetting = slideColors[currentIndex] || "white";
    const activeColor = getColor(colorSetting);
    const inactiveColor = getInactiveColor(colorSetting);

    let html = "";
    for (let i = 0; i < slides.length; i++) {
      html += `<span class="cursor-pointer js-hero2-seed" data-index="${i}">${seedSVG(i === currentIndex, activeColor, inactiveColor)}</span>`;
    }
    paginationContainer.innerHTML = html;

    // Click listeners on seeds
    paginationContainer.querySelectorAll(".js-hero2-seed").forEach((seed) => {
      seed.addEventListener("click", () => {
        const idx = parseInt(seed.dataset.index);
        goToSlide(idx);
      });
    });
  }

  function goToSlide(index) {
    currentSlide = index;
    showSlide(currentSlide);
    resetAutoplay();
  }

  function nextSlide() {
    currentSlide = (currentSlide + 1) % slides.length;
    showSlide(currentSlide);
  }

  function prevSlide() {
    currentSlide = (currentSlide - 1 + slides.length) % slides.length;
    showSlide(currentSlide);
  }

  function resetAutoplay() {
    if (autoplayTimer) clearInterval(autoplayTimer);
    autoplayTimer = setInterval(nextSlide, AUTOPLAY_INTERVAL);
  }

  // Navigation buttons
  if (prevBtn) {
    prevBtn.addEventListener("click", (e) => {
      e.preventDefault();
      e.stopPropagation();
      prevSlide();
      resetAutoplay();
    });
  }

  if (nextBtn) {
    nextBtn.addEventListener("click", (e) => {
      e.preventDefault();
      e.stopPropagation();
      nextSlide();
      resetAutoplay();
    });
  }

  // Initialize with first slide colors
  updateControlsColor(0);
  renderPagination(0);
  resetAutoplay();
};