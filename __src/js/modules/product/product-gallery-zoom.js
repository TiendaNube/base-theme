export const productGalleryZoom = () => {
  const container = document.querySelector(".js-product-gallery-zoom");
  if (!container) return;

  const closeBtn = container.querySelector(".js-product-gallery-zoom-close");
  const backdrop = container.querySelector(".js-product-gallery-zoom-backdrop");
  const swiperEl = container.querySelector(".js-product-gallery-zoom-swiper");
  const paginationContainer = container.querySelector(".js-product-gallery-zoom-pagination");
  const slides = Array.from(swiperEl ? swiperEl.querySelectorAll(".swiper-slide") : []);

  // Dots rendered over the dark blurred backdrop, so contrast must stay
  // consistent regardless of the theme's own text color (A8 rgba exception).
  const seedSVG = (active) => `
    <svg xmlns="http://www.w3.org/2000/svg" width="11" height="8" viewBox="0 0 11 8" fill="none">
      <path d="M6.93294 6.9178C10.0118 6.33768 11.5457 4.64453 10.8236 2.44759C10.2482 0.697531 8.31108 -0.0463472 6.24753 0.00222694C4.0117 0.0549646 2.34216 1.16245 1.5248 2.83063C1.07947 3.73966 0.564497 5.41477 0.0330304 6.99968C-0.164895 7.58812 0.559 8.12244 1.34154 7.97533C2.63722 7.73523 5.76371 7.13846 6.93294 6.9178Z" fill="${active ? "rgba(255,255,255,0.95)" : "rgba(255,255,255,0.4)"}"/>
    </svg>`;

  let swiper = null;
  let isOpen = false;
  let savedOverflow = "";

  function renderPagination(activeIndex) {
    if (!paginationContainer) return;

    let html = "";
    slides.forEach((_, index) => {
      html += `<span class="inline-flex items-center justify-center w-6 h-6 cursor-pointer js-product-gallery-zoom-seed" data-index="${index}">${seedSVG(index === activeIndex)}</span>`;
    });
    paginationContainer.innerHTML = html;

    paginationContainer.querySelectorAll(".js-product-gallery-zoom-seed").forEach((seed) => {
      seed.addEventListener("click", () => {
        if (!swiper) return;
        swiper.slideTo(parseInt(seed.dataset.index, 10));
      });
    });
  }

  // Swiper is initialized on first open, never at page load. While the overlay
  // is closed it sits behind `visibility: hidden` + `transform: scale(.95)`
  // (see the PRODUCT GALLERY ZOOM section of app.css), and Swiper caches slide
  // geometry at init — measuring it in that state yields sizes that never
  // recover once the overlay becomes visible.
  function ensureSwiper() {
    if (swiper || !swiperEl) return;
    if (typeof Swiper === "undefined") return;

    swiper = new Swiper(swiperEl, {
      slidesPerView: 1.15,
      centeredSlides: true,
      spaceBetween: 12,
      on: {
        slideChange: function () {
          renderPagination(this.activeIndex);
        },
      },
    });
  }

  const lockScroll = () => {
    savedOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
  };

  const unlockScroll = () => {
    document.body.style.overflow = savedOverflow;
  };

  function openZoom(imagePosition) {
    if (isOpen) return;
    isOpen = true;
    container.dataset.state = "open";
    lockScroll();

    const index = slides.findIndex((slide) => slide.dataset.imagePosition === String(imagePosition));
    const targetIndex = index === -1 ? 0 : index;

    // Wait for the open state to paint before Swiper reads any dimension.
    requestAnimationFrame(() => {
      ensureSwiper();

      if (swiper) {
        swiper.update();
        swiper.slideTo(targetIndex, 0);
      }

      renderPagination(targetIndex);
    });
  }

  function closeZoom() {
    if (!isOpen) return;
    isOpen = false;
    container.dataset.state = "closed";
    unlockScroll();
  }

  if (closeBtn) closeBtn.addEventListener("click", closeZoom);
  if (backdrop) backdrop.addEventListener("click", closeZoom);

  // The content layer covers the backdrop, so a click on the dark area lands on
  // the content / swiper / wrapper / slide instead. Close only when the click
  // is on that empty area (not the <img>, X, seeds or arrows) and the pointer
  // did not travel — a Swiper drag that ends on empty area must not close.
  const content = container.querySelector(".js-product-gallery-zoom-content");
  const wrapperEl = swiperEl ? swiperEl.querySelector(".swiper-wrapper") : null;
  const DRAG_THRESHOLD = 10;
  let downX = 0;
  let downY = 0;

  if (content) {
    content.addEventListener("pointerdown", (e) => {
      downX = e.clientX;
      downY = e.clientY;
    });

    content.addEventListener("click", (e) => {
      const t = e.target;
      const isEmptyArea = t === content || t === swiperEl || t === wrapperEl || slides.includes(t);
      if (!isEmptyArea) return;
      if (Math.hypot(e.clientX - downX, e.clientY - downY) > DRAG_THRESHOLD) return;
      closeZoom();
    });
  }

  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && isOpen) closeZoom();
  });

  // Delegated so it survives any re-render of the gallery markup and does not
  // depend on the trigger elements existing when this module runs.
  document.addEventListener("click", (e) => {
    const trigger = e.target.closest("[data-open-gallery-zoom]");
    if (!trigger) return;

    e.preventDefault();

    const slide = trigger.closest("[data-image-position]");
    const mainGallery = document.querySelector(".js-product-gallery");
    const imagePosition = slide ? slide.dataset.imagePosition : mainGallery?.dataset.activePosition;

    openZoom(imagePosition);
  });

  if (typeof lucide !== "undefined") lucide.createIcons();
};
