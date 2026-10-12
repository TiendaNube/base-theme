export const productGallery = () => {
  const container = document.querySelector(".js-product-gallery");
  if (!container) return;

  // Includes the legacy video slide from product-video.tpl (untouched by this
  // spec), which already carries .swiper-slide + data-image-position.
  const slides = Array.from(container.querySelectorAll(".swiper-slide"));
  const paginationContainer = document.querySelector(".js-product-gallery-pagination");
  const prevBtn = document.querySelector(".js-product-gallery-prev");
  const nextBtn = document.querySelector(".js-product-gallery-next");

  // SVG for seed pagination dot
  const styles = getComputedStyle(document.documentElement);
  const activeColor = styles.getPropertyValue("--text-color").trim();
  const inactiveColor = "color-mix(in srgb, var(--text-color) 40%, transparent)";
  const seedSVG = (active) => `
    <svg xmlns="http://www.w3.org/2000/svg" width="11" height="8" viewBox="0 0 11 8" fill="none">
      <path d="M6.93294 6.9178C10.0118 6.33768 11.5457 4.64453 10.8236 2.44759C10.2482 0.697531 8.31108 -0.0463472 6.24753 0.00222694C4.0117 0.0549646 2.34216 1.16245 1.5248 2.83063C1.07947 3.73966 0.564497 5.41477 0.0330304 6.99968C-0.164895 7.58812 0.559 8.12244 1.34154 7.97533C2.63722 7.73523 5.76371 7.13846 6.93294 6.9178Z" fill="${active ? activeColor : inactiveColor}"/>
    </svg>`;

  let swiper = null;

  function setActivePosition(index) {
    const slide = slides[index];
    if (!slide) return;
    container.dataset.activePosition = slide.dataset.imagePosition;
  }

  function renderPagination(activeIndex) {
    if (!paginationContainer) return;

    let html = "";
    slides.forEach((_, index) => {
      html += `<span class="inline-flex items-center justify-center w-6 h-6 cursor-pointer js-product-gallery-seed" data-index="${index}">${seedSVG(index === activeIndex)}</span>`;
    });
    paginationContainer.innerHTML = html;

    paginationContainer.querySelectorAll(".js-product-gallery-seed").forEach((seed) => {
      seed.addEventListener("click", () => {
        if (!swiper) return;
        swiper.slideTo(parseInt(seed.dataset.index, 10));
      });
    });
  }

  setTimeout(() => {
    swiper = new Swiper(container, {
      slidesPerView: 1,
      spaceBetween: 0,
      on: {
        init: function () {
          renderPagination(0);
          setActivePosition(0);
        },
        slideChange: function () {
          renderPagination(this.activeIndex);
          setActivePosition(this.activeIndex);
        },
      },
    });
  }, 0);

  if (prevBtn) {
    prevBtn.addEventListener("click", () => {
      if (swiper) swiper.slidePrev();
    });
  }

  if (nextBtn) {
    nextBtn.addEventListener("click", () => {
      if (swiper) swiper.slideNext();
    });
  }

  window.setProductGalleryImage = function (imagePosition) {
    if (!swiper) return;
    const index = slides.findIndex((slide) => slide.dataset.imagePosition === String(imagePosition));
    if (index === -1) return;
    swiper.slideTo(index);
  };
};
