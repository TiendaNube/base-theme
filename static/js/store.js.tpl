{#/*============================================================================
    #Specific store JS functions: product variants, cart, shipping, etc
==============================================================================*/#}

{#/*============================================================================
  
  Table of Contents

  	#Lazy load
  	#Notificactions
    #Modals
    #Tabs
  	#Header and nav
        // Nav
        // Search suggestions
	#Sliders
	  	// Home slider
	  	// Banner services slider
	#Social
		// Youtube or Vimeo video
        // Facebook login
	#Product grid
		// Filters
		// Sort by
		// Infinite scroll
  	#Product detail functions
	  	// Installments
	  	// Change Variant
	  	// Product labels on variant change
	  	// Color and size variants change
	  	// Custom mobile variants change
	  	// Submit to contact
	  	// Product slider
	  	// Pinterest sharing
        // Product quantity
  	#Cart
  		// Toggle cart 
  		// Add to cart
  		// Cart quantitiy changes
  		// Empty cart alert
        // Go to checkout
	#Shipping calculator
		// Select and save shipping function
		// Calculate shipping function
		// Calculate shipping by submit
		// Shipping and branch click
		// Select shipping first option on results
		// Toggle branches link
		// Toggle more shipping options
		// Calculate shipping on page load
		// Shipping provinces
		// Change store country
    #Forms
    #Footer

==============================================================================*/#}

// Move to our_content
window.urls = {
    "shippingUrl": "{{ store.shipping_calculator_url | escape('js') }}"
}

{#/*============================================================================
  #Lazy load
==============================================================================*/ #}

document.addEventListener('lazybeforeunveil', function(e){
    if ((e.target.parentElement) && (e.target.nextElementSibling)) {
        var parent = e.target.parentElement;
        var sibling = e.target.nextElementSibling;
        if (sibling.classList.contains('js-lazy-loading-preloader')) {
            sibling.style.display = 'none';
            parent.style.display = 'block';
        }
    }
});


window.lazySizesConfig = window.lazySizesConfig || {};
lazySizesConfig.hFac = 0.4;


DOMContentLoaded.addEventOrExecute(() => {

	{#/*============================================================================
	  #Notifications
	==============================================================================*/ #}

    {# Notifications variables #}

    var $notification_status_page = jQueryNuvem(".js-notification-status-page");
    var $fixed_bottom_button = jQueryNuvem(".js-btn-fixed-bottom");

    {# /* // Close notification */ #}

    jQueryNuvem(".js-notification-close").on( "click", function(e) {
        e.preventDefault();
        jQueryNuvem(e.currentTarget).closest(".js-notification").hide();
    });

    {# /* // Follow order status notification */ #}
    
    if ($notification_status_page.length > 0){
        if (LS.shouldShowOrderStatusNotification($notification_status_page.data('url'))){
            $notification_status_page.show();
        };
        jQueryNuvem(".js-notification-status-page-close").on( "click", function(e) {
            e.preventDefault();
            LS.dontShowOrderStatusNotificationAgain($notification_status_page.data('url'));
        });
    }

    {# /* // Cart notification: Dismiss notification */ #}

    jQueryNuvem(".js-cart-notification-close").on("click", function(){
        jQueryNuvem(".js-alert-added-to-cart").removeClass("notification-visible").addClass("notification-hidden");
        setTimeout(function(){
            jQueryNuvem('.js-cart-notification-item-img').attr('src', '');
            jQueryNuvem(".js-alert-added-to-cart").hide();
        },2000);
    });

    {% if not params.preview %}

        const footer = jQueryNuvem(".js-footer");
        
        {# /* // Cookie banner notification */ #}

        restoreNotifications = function(){

            // Whatsapp button position
            if (window.innerWidth < 768) {
                $fixed_bottom_button.css("marginBottom", "10px");
            }

            {# Restore notifications when Cookie Banner is closed #}

            footer.removeAttr("style");
        };

        if (!window.cookieNotificationService.isAcknowledged()) {
            jQueryNuvem(".js-notification-cookie-banner").show();

            {# Offset to show legal footer #}

            const cookieBannerHeight = jQueryNuvem(".js-notification-cookie-banner").outerHeight();
            footer.css("paddingBottom", cookieBannerHeight + 10 + "px");

            {# Whatsapp button position #}
            if (window.innerWidth < 768) {
                $fixed_bottom_button.css("marginBottom", "120px");
            }else{
                $fixed_bottom_button.css("marginBottom", "70px");
            }
        }

        jQueryNuvem(".js-acknowledge-cookies").on( "click", function(e) {
            window.cookieNotificationService.acknowledge();
            restoreNotifications();
        });

    {% endif %}

    {#/*============================================================================
      #Modals
    ==============================================================================*/ #}

    {% if settings.quick_shop %}

        restoreQuickshopForm = function(){

            {# Restore form to item when quickshop closes #}

            {# Clean quickshop modal #}

            jQueryNuvem("#quickshop-modal .js-item-product").removeClass("js-swiper-slide-visible js-item-slide");
            jQueryNuvem("#quickshop-modal .js-quickshop-container").attr( { 'data-variants' : '' , 'data-quickshop-id': '' } );
            jQueryNuvem("#quickshop-modal .js-item-product").attr('data-product-id', '');

            {# Wait for modal to become invisible before removing form #}
            
            setTimeout(function(){
                var $quickshop_form = jQueryNuvem("#quickshop-form").find('.js-product-form');
                var $item_form_container = jQueryNuvem(".js-quickshop-opened").find(".js-item-variants");
                
                $quickshop_form.detach().appendTo($item_form_container);
                jQueryNuvem(".js-quickshop-opened").removeClass("js-quickshop-opened");
            },350);

        };

    {% endif %}
    
    {# Full screen mobile modals back events #}

    if (window.innerWidth < 768) {

        {# Clean url hash function #}

        cleanURLHash = function(){
            const uri = window.location.toString();
            const clean_uri = uri.substring(0, uri.indexOf("#"));
            window.history.replaceState({}, document.title, clean_uri);
        };

        {# Go back 1 step on browser history #}

        goBackBrowser = function(){
            cleanURLHash();
            history.back();
        };

        {# Clean url hash on page load: All modals should be closed on load #}

        if(window.location.href.indexOf("modal-fullscreen") > -1) {
            cleanURLHash();
        }

        {# Open full screen modal and url hash #}

        jQueryNuvem(document).on("click", ".js-fullscreen-modal-open", function(e) {
            e.preventDefault();
            var modal_url_hash = jQueryNuvem(this).data("modalUrl");
            window.location.hash = modal_url_hash;
        });

        {# Close full screen modal: Remove url hash #}

        jQueryNuvem(document).on("click", ".js-fullscreen-modal-close", function(e) {
            e.preventDefault();
            goBackBrowser();
        });

        {# Hide panels or modals on browser backbutton #}

        window.onhashchange = function() {
            if(window.location.href.indexOf("modal-fullscreen") <= -1) {

                {# Close opened modal #}

                if(jQueryNuvem(".js-fullscreen-modal").hasClass("modal-show")){

                    {# Remove body lock only if a single modal is visible on screen #}

                    if(jQueryNuvem(".js-modal.modal-show").length == 1){
                        jQueryNuvem("body").removeClass("overflow-none");
                    }

                    var $opened_modal = jQueryNuvem(".js-fullscreen-modal.modal-show");
                    var $opened_modal_overlay = $opened_modal.prev();

                    $opened_modal.removeClass("modal-show");
                    setTimeout(() => $opened_modal.hide(), 500);
                    $opened_modal_overlay.fadeOut(500);

                    {% if settings.quick_shop %}
                        restoreQuickshopForm();
                    {% endif %}
                }
            }
        }

    }
    
    jQueryNuvem(document).on("click", ".js-modal-open", function(e) {
        e.preventDefault(); 
        var modal_id = jQueryNuvem(this).data('toggle');
        var $overlay_id = jQueryNuvem('.js-modal-overlay[data-modal-id="' + modal_id + '"]');
        if (jQueryNuvem(modal_id).hasClass("modal-show")) {
            let modal = jQueryNuvem(modal_id).removeClass("modal-show");
            setTimeout(() => modal.hide(), 500);
        } else {

            {# Lock body scroll if there is no modal visible on screen #}
            
            if(!jQueryNuvem(".js-modal.modal-show").length){
                jQueryNuvem("body").addClass("overflow-none");
            }
            $overlay_id.fadeIn(400);
            jQueryNuvem(modal_id).detach().appendTo("body");
            $overlay_id.detach().insertBefore(modal_id);
            jQueryNuvem(modal_id).show().addClass("modal-show");
        }             
    });

    jQueryNuvem(document).on("click", ".js-modal-close", function(e) {
        e.preventDefault();  
        {# Remove body lock only if a single modal is visible on screen #}

        if(jQueryNuvem(".js-modal.modal-show").length == 1){
            jQueryNuvem("body").removeClass("overflow-none");
        }
        var $modal = jQueryNuvem(this).closest(".js-modal");
        var modal_id = $modal.attr('id');
        var $overlay_id = jQueryNuvem('.js-modal-overlay[data-modal-id="#' + modal_id + '"]');
        $modal.removeClass("modal-show");
        setTimeout(() => $modal.hide(), 500);
        $overlay_id.fadeOut(500);
        {% if settings.quick_shop %}
            restoreQuickshopForm();
        {% endif %}

        {# Close full screen modal: Remove url hash #}

        if ((window.innerWidth < 768) && (jQueryNuvem(this).hasClass(".js-fullscreen-modal-close"))) {
            goBackBrowser();
        }    
    });

    jQueryNuvem(document).on("click", ".js-modal-overlay", function(e) {
        e.preventDefault();
        {# Remove body lock only if a single modal is visible on screen #}

        if(jQueryNuvem(".js-modal.modal-show").length == 1){
            jQueryNuvem("body").removeClass("overflow-none");
        }
        var modal_id = jQueryNuvem(this).data('modalId');
        let modal = jQueryNuvem(modal_id).removeClass("modal-show");
        setTimeout(() => modal.hide(), 500); 
        jQueryNuvem(this).fadeOut(500);   
        {% if settings.quick_shop %}
            restoreQuickshopForm();
        {% endif %}

        if (jQueryNuvem(this).hasClass("js-fullscreen-overlay") && (window.innerWidth < 768)) {
            cleanURLHash();
        }
    });

    {% if template == 'home' and settings.home_promotional_popup %}

        {# /* // Home popup and newsletter popup */ #}

        jQueryNuvem('#news-popup-form').on("submit", function () {
            jQueryNuvem(".js-news-spinner").show();
            jQueryNuvem(".js-news-send, .js-news-popup-submit").hide();
            jQueryNuvem(".js-news-popup-submit").prop("disabled", true);
        });

        LS.newsletter('#news-popup-form-container', '#home-modal', '{{ store.contact_url | escape('js') }}', function (response) {
            jQueryNuvem(".js-news-spinner").hide();
            jQueryNuvem(".js-news-send, .js-news-popup-submit").show();
            var selector_to_use = response.success ? '.js-news-popup-success' : '.js-news-popup-failed';
            let newPopupAlert = jQueryNuvem(this).find(selector_to_use).fadeIn(100);
            setTimeout(() => newPopupAlert.fadeOut(500), 4000);
            if (jQueryNuvem(".js-news-popup-success").css("display") == "block") {
                setTimeout(function () {
                    jQueryNuvem('[data-modal-id="#home-modal"]').fadeOut(500);
                    let homeModal = jQueryNuvem("#home-modal").removeClass("modal-show");
                    setTimeout(() => homeModal.hide(), 500);
                }, 2500);
            }
            jQueryNuvem(".js-news-popup-submit").prop("disabled", false);
        });


        var callback_show = function(){
            jQueryNuvem('.js-modal-overlay[data-modal-id="#home-modal"]').fadeIn(500);
            jQueryNuvem("#home-modal").detach().appendTo("body").show().addClass("modal-show");
        }
        var callback_hide = function(){
            jQueryNuvem('.js-modal-overlay[data-modal-id="#home-modal"]').fadeOut(500);
            let homeModal = jQueryNuvem("#home-modal").removeClass("modal-show");
            setTimeout(() => homeModal.hide(), 500);
        }
        LS.homePopup({
            selector: "#home-modal",
            timeout: 10000,
            mobile_max_pixels: 0,
        }, callback_hide, callback_show);

    {% endif %}

    {#/*============================================================================
      #Accordions
    ==============================================================================*/ #}
    
    jQueryNuvem(document).on("click", ".js-accordion-toggle", function(e) {
        e.preventDefault();
        if(jQueryNuvem(this).hasClass("js-accordion-show-only")){
            jQueryNuvem(this).hide();
        }else{
            jQueryNuvem(this).find(".js-accordion-toggle-inactive").toggle();
            jQueryNuvem(this).find(".js-accordion-toggle-active").toggle();
        }
        jQueryNuvem(this).prev(".js-accordion-container").slideToggle();
    });

	{#/*============================================================================
      #Header and nav
    ==============================================================================*/ #}

    {# /* // Header */ #}

    {% if template == 'home' and settings.head_transparent %}
        {% if settings.slider and settings.slider is not empty %}        

            var $swiper_height = window.innerHeight - 100;
            
            document.addEventListener("scroll", function() {
                if (document.documentElement.scrollTop > $swiper_height ) {
                    jQueryNuvem(".js-head-main").removeClass("head-transparent");
                } else {
                    jQueryNuvem(".js-head-main").addClass("head-transparent");
                }
            });

        {% endif %}
    {% endif %}

    {# /* // Nav offset */ #}

    function applyOffset(selector){

        // Get nav height on load
        if (window.innerWidth > 768) {
            var head_height = jQueryNuvem(".js-head-main").height();
            jQueryNuvem(selector).css("paddingTop", head_height.toString() + 'px');
        }else{

            {# On mobile there is no top padding due to position sticky CSS #}
            var head_height = 0;
        }

        // Apply offset nav height on load

        window.addEventListener("resize", function() {

            // Get nav height on resize
            var head_height = jQueryNuvem(".js-head-main").height();

            // Apply offset on resize
            if (window.innerWidth > 768) {
                jQueryNuvem(selector).css("paddingTop", head_height.toString() + 'px');
            }else{

                {# On mobile there is no top padding due to position sticky CSS #}
                jQueryNuvem(selector).css("paddingTop", "0px");
            }
        });
    }

    {% if settings.head_fix and ((settings.head_transparent and template != 'home') or (not settings.head_transparent)) %}
        applyOffset(".js-head-offset");
    {% endif %}

    {# /* // Nav */ #}

        var $top_nav = jQueryNuvem(".js-mobile-nav");
        var $page_main_content = jQueryNuvem(".js-main-content");
        var $search_backdrop = jQueryNuvem(".js-search-backdrop");

        $top_nav.addClass("move-down").removeClass("move-up");


        {# Nav subitems #}

        jQueryNuvem(".js-toggle-page-accordion").on("click", function (e) {
            e.preventDefault();
            jQueryNuvem(e.currentTarget).toggleClass("active").closest(".js-nav-list-toggle-accordion").next(".js-pages-accordion").slideToggle(300);
        });

        {# Focus search #}

        jQueryNuvem(".js-toggle-search").click(function (e) {
            e.preventDefault;
            jQueryNuvem(".js-search-input").each(el => el.focus());
        });


    {# /* // Search suggestions */ #}

        LS.search(jQueryNuvem(".js-search-input"), function (html, count) {
            $search_suggests = jQueryNuvem(this).closest(".js-search-container").next(".js-search-suggest");
            if (count > 0) {
                $search_suggests.html(html).show();
            } else {
                $search_suggests.hide();
            }
            if (jQueryNuvem(this).val().length == 0) {
                $search_suggests.hide();
            }
        }, {
            snipplet: 'header/header-search-results.tpl'
        });

        if (window.innerWidth > 768) {

            {# Hide search suggestions if user click outside results #}

            jQueryNuvem("body").on("click", function () {
                jQueryNuvem(".js-search-suggest").hide();
            });

            {# Maintain search suggestions visibility if user click on links inside #}

            jQueryNuvem(document).on("click", ".js-search-suggest a", function () {
                jQueryNuvem(".js-search-suggest").show();
            });
        }

        jQueryNuvem(".js-search-suggest").on("click", ".js-search-suggest-all-link", function (e) {
            e.preventDefault();
            $this_closest_form = jQueryNuvem(this).closest(".js-search-suggest").prev(".js-search-form");
            $this_closest_form.submit();
        });

    {# /* // Lang select */ #}


    changeLang = function(element) {
        var selected_country_url = element.find("option").filter((el) => el.selected).attr("data-country-url");
        location.href = selected_country_url;
    };

    jQueryNuvem('.js-lang-select').on("change", function (e) {
        lang_select_option = jQueryNuvem(this);

        changeLang(lang_select_option);
    });

	{#/*============================================================================
	  #Sliders
	==============================================================================*/ #}

	{% if template == 'home' %}

		{# /* // Home slider */ #}

        var width = window.innerWidth;
        if (width > 767) {  
            var slider_autoplay = {delay: 6000,};
        } else {
            var slider_autoplay = false;
        }

        window.homeSlider = {
            getAutoRotation: function() {
                return slider_autoplay;
            },
            updateSlides: function(slides) {
                homeSwiper.removeAllSlides();
                slides.forEach(function(aSlide){
                    homeSwiper.appendSlide(
                        '<div class="swiper-slide slide-container">' +
                            (aSlide.link ? '<a href="' + aSlide.link + '">' : '' ) +
                                '<img src="' + aSlide.src + '" class="slider-image"/>' +
                                '<div class="swiper-text swiper-' + aSlide.color + '">' +
                                    (aSlide.title ? '<div class="swiper-title">' + aSlide.title + '</div>' : '' ) +
                                    (aSlide.description ? '<div class="swiper-description mb-3">' + aSlide.description + '</div>' : '' ) +
                                    (aSlide.button && aSlide.link ? '<div class="btn btn-primary d-inline-block mt-3">' + aSlide.button + '</div>' : '' ) +
                                '</div>' +
                            (aSlide.link ? '</a>' : '' ) +
                        '</div>'
                    );
                });
                if(!slides.length){
                    jQueryNuvem(".js-home-main-slider-container").addClass("hidden");
                    jQueryNuvem(".js-home-empty-slider-container").removeClass("hidden");
                    jQueryNuvem(".js-home-mobile-slider-visibility").removeClass("d-md-none");
                    {% if has_mobile_slider %}
                        jQueryNuvem(".js-home-main-slider-visibility").removeClass("d-none d-md-block");
                        homeMobileSwiper.update();
                    {% endif %}
                }else{
                    jQueryNuvem(".js-home-main-slider-container").removeClass("hidden");
                    jQueryNuvem(".js-home-empty-slider-container").addClass("hidden");
                    jQueryNuvem(".js-home-mobile-slider-visibility").addClass("d-md-none");
                    {% if has_mobile_slider %}
                        jQueryNuvem(".js-home-main-slider-visibility").addClass("d-none d-md-block");
                    {% endif %}
                }
            },
            changeAutoRotation: function(){

            },
        };

        var preloadImagesValue = false;
        var lazyValue = true;
        var loopValue = true;
        var watchOverflowValue = true;
        var paginationClickableValue = true;

        var homeSwiper = null;
        createSwiper(
            '.js-home-slider',
            {
                lazy: lazyValue,
                preloadImages: preloadImagesValue,
                {% if settings.slider | length > 1 %}
                    loop: loopValue,
                {% endif %}
                autoplay: slider_autoplay,
                watchOverflow: watchOverflowValue,
                pagination: {
                    el: '.js-swiper-home-pagination',
                    clickable: paginationClickableValue,
                },
                navigation: {
                    nextEl: '.js-swiper-home-next',
                    prevEl: '.js-swiper-home-prev',
                },
            },
            function(swiperInstance) {
                homeSwiper = swiperInstance;
            }
        );

        var homeMobileSwiper = null;
        createSwiper(
            '.js-home-slider-mobile',
            {
                lazy: lazyValue,
                preloadImages: preloadImagesValue,
                {% if settings.slider_mobile | length > 1 %}
                    loop: loopValue,
                {% endif %}
                autoplay: slider_autoplay,
                watchOverflow: watchOverflowValue,
                pagination: {
                    el: '.js-swiper-home-pagination-mobile',
                    clickable: paginationClickableValue,
                },
                navigation: {
                    nextEl: '.js-swiper-home-next-mobile',
                    prevEl: '.js-swiper-home-prev-mobile',
                },
            },
            function(swiperInstance) {
                homeMobileSwiper = swiperInstance;
            }
        );
     
        {% if sections.primary.products %}

            {% if settings.product_color_variants or settings.quick_shop %}

                {# Duplicate cloned slide elements for quickshop or colors forms #}

                updateClonedItemsIDs = function(element){
                    jQueryNuvem(element).each(function(el) {
                        var $this = jQueryNuvem(el);
                        var slide_index = $this.attr("data-swiper-slide-index");
                        var clone_quick_id = $this.find(".js-quickshop-container").attr("data-quickshop-id");
                        var clone_product_id = $this.attr("data-product-id");
                        $this.attr("data-product-id" , clone_product_id + "-clone-" + slide_index);
                        $this.find(".js-quickshop-container").attr("data-quickshop-id" , clone_quick_id + "-clone-" + slide_index);
                    });
                };

            {% endif %}

            {% set columns = settings.grid_columns %}
            createSwiper('.js-swiper-featured', {
                lazy: true,
                loop: true,
                spaceBetween: 30,
                threshold: 5,
                watchSlidesVisibility: true,
                slideVisibleClass: 'js-swiper-slide-visible',
                slidesPerView: {% if columns == 2 %}2{% else %}1{% endif %},
                pagination: {
                    el: '.js-swiper-featured-pagination',
                    clickable: true,
                },
                navigation: {
                    nextEl: '.js-swiper-featured-next',
                    prevEl: '.js-swiper-featured-prev',
                },
                breakpoints: {
                    640: {
                        slidesPerView: {% if columns == 2 %}4{% else %}3{% endif %},
                    }
                },
                {% if settings.product_color_variants or settings.quick_shop %}
                    on: {
                        init: function () {
                            updateClonedItemsIDs(".js-swiper-featured .js-item-slide.swiper-slide-duplicate");
                        },
                    }
                {% endif %}
            });

        {% endif %}

	{% endif %}

    {% if template == 'product' %}

        {# /* // Product Related */ #}

            
            // Set loop for related products products sliders

            {% set columns = settings.grid_columns %}
            const desktopColumns = {% if columns == 1 %}3{% else %}4{% endif %};

            function calculateRelatedLoopVal(sectionSelector) {                
                let productsAmount = jQueryNuvem(sectionSelector).attr("data-related-amount");
                let loopVal = false;
                const applyLoop = (window.innerWidth < 768 && productsAmount > {{ columns }}) || (window.innerWidth > 768 && productsAmount > desktopColumns);
                
                if (applyLoop) {
                    loopVal = true;
                }

                return loopVal;
            }

            let alternativeLoopVal = calculateRelatedLoopVal(".js-related-products");
            let complementaryLoopVal = calculateRelatedLoopVal(".js-complementary-products");

            {# Alternative products #}

            createSwiper('.js-swiper-related', {
                lazy: true,
                watchOverflow: true,
                loop: alternativeLoopVal,
                centerInsufficientSlides: true,
                spaceBetween: 30,
                slidesPerView: {{ columns }},
                pagination: {
                    el: '.js-swiper-related-pagination',
                    clickable: true,
                },
                navigation: {
                    nextEl: '.js-swiper-related-next',
                    prevEl: '.js-swiper-related-prev',
                },
                breakpoints: {
                    767: {
                        slidesPerView: desktopColumns,
                    }
                }
            });

            {# Complementary products #}

            createSwiper('.js-swiper-complementary', {
                lazy: true,
                watchOverflow: true,
                loop: complementaryLoopVal,
                centerInsufficientSlides: true,
                spaceBetween: 30,
                slidesPerView: {{ columns }},
                pagination: {
                    el: '.js-swiper-complementary-pagination',
                    clickable: true,
                },
                navigation: {
                    nextEl: '.js-swiper-complementary-next',
                    prevEl: '.js-swiper-complementary-prev',
                },
                breakpoints: {
                    767: {
                        slidesPerView: desktopColumns,
                    }
                }
            });

    {% endif %}



	{% set has_banner_services = settings.banner_services %}

	{% if has_banner_services %}

		{# /* // Banner services slider */ #}

        var width = window.innerWidth;
        if (width < 767) {   
            createSwiper('.js-informative-banners', {
                pagination: {
                    el: '.js-informative-banners-pagination',
                    clickable: true,
                },
            });
        }

    {% endif %}

	{#/*============================================================================
	  #Social
	==============================================================================*/ #}

    {% if template == 'home' %}
        {% set video_url = settings.video_embed %}
    {% elseif template == 'product' and product.video_url %}
        {% set video_url = product.video_url %}
    {% endif %}

    {% if video_url %}

        {# /* // Youtube or Vimeo video for home or each product */ #}

        LS.loadVideo('{{ video_url }}');

    {% endif %}

	{#/*============================================================================
	  #Product grid
	==============================================================================*/ #}

    var $category_controls = jQueryNuvem(".js-category-controls");
    var mobile_nav_height = jQueryNuvem(".js-head-main").outerHeight();

	{% if template == 'category' %}

        {# /* // Fixed category controls */ #}

        if (window.innerWidth < 768) {
            {% if settings.head_fix %}
                $category_controls.css("top" , mobile_nav_height.toString() + 'px');
            {% else %}
                jQueryNuvem(".js-category-controls").css("top" , "0px");
            {% endif %}

            {# Detect if category controls are sticky and add css #}

            var observer = new IntersectionObserver(function(entries) {
                if(entries[0].intersectionRatio === 0)
                    document.querySelector(".js-category-controls").classList.add("is-sticky");
                else if(entries[0].intersectionRatio === 1)
                    document.querySelector(".js-category-controls").classList.remove("is-sticky");
                }, { threshold: [0,1] 
            });

            observer.observe(document.querySelector(".js-category-controls-prev"));
        }

        {# /* // Filters */ #}

        jQueryNuvem(document).on("click", ".js-apply-filter, .js-remove-filter", function(e) {
            e.preventDefault();
            var filter_name = jQueryNuvem(this).data('filterName');
            var filter_value = jQueryNuvem(this).data('filterValue');
            if(jQueryNuvem(this).hasClass("js-apply-filter")){
                jQueryNuvem(this).find("[type=checkbox]").prop("checked", true);
                LS.urlAddParam(
                    filter_name,
                    filter_value,
                    true
                );
            }else{
                jQueryNuvem(this).find("[type=checkbox]").prop("checked", false);
                LS.urlRemoveParam(
                    filter_name,
                    filter_value
                );
            }

            {# Toggle class to avoid adding double parameters in case of double click and show applying changes feedback #}

            if (jQueryNuvem(this).hasClass("js-filter-checkbox")){
                if (window.innerWidth < 768) {
                    jQueryNuvem(".js-filters-overlay").show();
                    if(jQueryNuvem(this).hasClass("js-apply-filter")){
                        jQueryNuvem(".js-applying-filter").show();
                    }else{
                        jQueryNuvem(".js-removing-filter").show();
                    }
                }
                jQueryNuvem(this).toggleClass("js-apply-filter js-remove-filter");
            }
        });

        jQueryNuvem(document).on("click", ".js-remove-all-filters", function(e) {
            e.preventDefault();
            LS.urlRemoveAllParams();
        });

		{# /* // Sort by */ #}

		jQueryNuvem('.js-sort-by').on("change", function (e) {
            var params = LS.urlParams;
            params['sort_by'] = jQueryNuvem(e.currentTarget).val();
            var sort_params_array = [];
            for (var key in params) {
                if (!['results_only', 'page'].includes(key)) {
                    sort_params_array.push(key + '=' + params[key]);
                }
            }
            var sort_params = sort_params_array.join('&');
            window.location = window.location.pathname + '?' + sort_params;
        });

	{% endif %}

    {% if template == 'category' or template == 'search' %}

        !function() {

            {# /* // Infinite scroll */ #}

            {% if pages.current == 1 and not pages.is_last %}
                LS.hybridScroll({
                    productGridSelector: '.js-product-table',
                    spinnerSelector: '#js-infinite-scroll-spinner',
                    loadMoreButtonSelector: '.js-load-more',
                    hideWhileScrollingSelector: ".js-hide-footer-while-scrolling",
                    productsBeforeLoadMoreButton: 50,
                    productsPerPage: 12
                });
            {% endif %}
        }();

	{% endif %}

    {#/*============================================================================
	  #Product detail functions
	==============================================================================*/ #}

	{# /* // Installments */ #}

	{# Installments without interest #}

    function get_max_installments_without_interests(number_of_installment, installment_data, max_installments_without_interests) {
        if (parseInt(number_of_installment) > parseInt(max_installments_without_interests[0])) {
            if (installment_data.without_interests) {
                return [number_of_installment, installment_data.installment_value.toFixed(2)];
            }
        }
        return max_installments_without_interests;
    }

    {# Installments with interest #}

    function get_max_installments_with_interests(number_of_installment, installment_data, max_installments_with_interests) {
        if (parseInt(number_of_installment) > parseInt(max_installments_with_interests[0])) {
            if (installment_data.without_interests == false) {
                return [number_of_installment, installment_data.installment_value.toFixed(2)];
            }
        }
        return max_installments_with_interests;
    }

	{# Updates installments on payment popup for native integrations #}

    function refreshInstallmentv2(price){
        jQueryNuvem(".js-modal-installment-price" ).each(function( el ) {
            const installment = Number(jQueryNuvem(el).data('installment'));
            jQueryNuvem(el).text(LS.currency.display_short + (price/installment).toLocaleString('de-DE', {maximumFractionDigits: 2, minimumFractionDigits: 2}));
        });
    }

    {# Refresh price on payments popup with payment discount applied #}

    function refreshPaymentDiscount(price){
        jQueryNuvem(".js-price-with-discount" ).each(function( el ) {
            const payment_discount = jQueryNuvem(el).data('paymentDiscount');
            jQueryNuvem(el).text(LS.formatToCurrency(price - ((price * payment_discount) / 100)))
        });
    }

    {% set should_show_discount = product.maxPaymentDiscount.value > 0 %}
    {% if should_show_discount %}

        {# Shows/hides price with discount and strikethrough original price for every payment method #}

        function togglePaymentDiscounts(variant){
            jQueryNuvem(".js-payment-method-total").each(function( paymentMethodTotalElement ){
                const priceComparerElement = jQueryNuvem(paymentMethodTotalElement).find(".js-compare-price-display");
                const installmentsOnePaymentElement = jQueryNuvem(paymentMethodTotalElement).find('.js-installments-no-discount');
                const priceWithDiscountElement = jQueryNuvem(paymentMethodTotalElement).find('.js-price-with-discount');

                priceComparerElement.hide();
                installmentsOnePaymentElement.hide();
                priceWithDiscountElement.hide();

                const discount = priceWithDiscountElement.data('paymentDiscount');

                if (discount > 0 && showMaxPaymentDiscount(variant)){
                    priceComparerElement.show();
                    priceWithDiscountElement.show()
                } else {
                    installmentsOnePaymentElement.show();
                }
            })
        }

        {# Toggle discount and discount disclaimer both on product details and popup #}

        function updateDiscountDisclaimers(variant){
            updateProductDiscountDisclaimer(variant);
            updatePopupDiscountDisclaimers(variant);
        }

        {# Toggle discount and discount disclaimer in product details #}

        function updateProductDiscountDisclaimer(variant){
            jQueryNuvem(".js-product-discount-container, .js-product-discount-disclaimer").hide();

            if (showMaxPaymentDiscount(variant)){
                jQueryNuvem(".js-product-discount-container").show();
            }

            if (showMaxPaymentDiscountNotCombinableDisclaimer(variant)){
                jQueryNuvem(".js-product-discount-disclaimer").show();
            }
        }

        {# Shows/hides discount message for payment method and discount disclaimer in popup, for every payment method #}

        function updatePopupDiscountDisclaimers(variant){
            jQueryNuvem(".js-modal-tab-discount, .js-payment-method-discount").hide();

            {% if product.maxPaymentDiscount.value > 0 %}
                if (showMaxPaymentDiscount(variant)){
                    {% for key, method in product.payment_methods_config %}
                        {% if method.max_discount > 0 %}
                            {% if method.allows_discount_combination %}
                                jQueryNuvem("#method_{{ key | sanitize }} .js-modal-tab-discount").show();
                            {% elseif not product.free_shipping %}
                                if (!variantHasPromotionalPrice(variant)){
                                    jQueryNuvem("#method_{{ key | sanitize }} .js-modal-tab-discount").show();
                                }
                            {% endif %}
                        {% endif %}
                    {% endfor %}
                }
            {% endif %}

            jQueryNuvem(".js-info-payment-method-container").each(function(infoPaymentMethodElement){
                {# For each payment method this will show the payment method discount and discount explanation #}

                const infoPaymentMethod = jQueryNuvem(infoPaymentMethodElement)
                infoPaymentMethod.find(".js-discount-explanation").hide();
                infoPaymentMethod.find(".js-discount-disclaimer").hide();

                const priceWithDiscountElement = infoPaymentMethod.find('.js-price-with-discount');
                const discount = priceWithDiscountElement.data('paymentDiscount');

                if (discount > 0 && showMaxPaymentDiscount(variant)){
                    infoPaymentMethod.find(".js-discount-explanation").show();
                    infoPaymentMethod.find(".js-payment-method-discount").show();
                }

                if (discount > 0 && showMaxPaymentDiscountNotCombinableDisclaimer(variant)){
                    infoPaymentMethod.find(".js-discount-disclaimer").show();
                }
            })
        }

        function variantHasPromotionalPrice(variant) { return variant.compare_at_price_number > variant.price_number }

        function showMaxPaymentDiscount(variant) {
            {% if product.maxPaymentDiscount()["allowsDiscountCombination"] %}
                return true;
            {% elseif product.free_shipping %}
                return false;
            {% else %}
                return !variantHasPromotionalPrice(variant);
            {% endif %}
        }

        function showMaxPaymentDiscountNotCombinableDisclaimer(variant) {
            {% if product.maxPaymentDiscount()["allowsDiscountCombination"] or product.free_shipping %}
                return false
            {% else %}
                return !variantHasPromotionalPrice(variant)
            {% endif %}
        }

    {% endif %}

	{# /* // Change variant */ #}

    {# Updates price, installments, labels and CTA on variant change #}

	function changeVariant(variant){

	    jQueryNuvem(".js-product-detail .js-shipping-calculator-response").hide();
	    jQueryNuvem("#shipping-variant-id").val(variant.id);

	    var parent = jQueryNuvem("body");
	    if (variant.element){
	        parent = jQueryNuvem(variant.element);
	    }

	    var sku = parent.find('#sku');
	    if(sku.length) {
	        sku.text(variant.sku).show();
	    }

        {# Updates installments on list item and inside payment popup for Payments Apps #}

	    var installment_helper = function($element, amount, price){
            $element.find('.js-installment-amount').text(amount);
            $element.find('.js-installment-price').attr("data-value", price);
            $element.find('.js-installment-price').text(LS.currency.display_short + parseFloat(price).toLocaleString('de-DE', { minimumFractionDigits: 2 }));
            if(variant.price_short && Math.abs(variant.price_number - price * amount) < 1) {
                $element.find('.js-installment-total-price').text((variant.price_short).toLocaleString('de-DE', { minimumFractionDigits: 2 }));
            } else {
                $element.find('.js-installment-total-price').text(LS.currency.display_short + (price * amount).toLocaleString('de-DE', { minimumFractionDigits: 2 }));
            }
        };

        if (variant.installments_data) {
            var variant_installments = JSON.parse(variant.installments_data);
            var max_installments_without_interests = [0,0];
            var max_installments_with_interests = [0,0];

            {# Hide all installments rows on payments modal #}
            jQueryNuvem('.js-payment-provider-installments-row').hide();

            for (let payment_method in variant_installments) {

                {# Identifies the minimum installment value #}
                var paymentMethodId = '#installment_' + payment_method.replace(" ", "_") + '_1';
                var minimumInstallmentValue = jQueryNuvem(paymentMethodId).closest('.js-info-payment-method').attr("data-minimum-installment-value");

                let installments = variant_installments[payment_method];
                for (let number_of_installment in installments) {
                    let installment_data = installments[number_of_installment];
                    max_installments_without_interests = get_max_installments_without_interests(number_of_installment, installment_data, max_installments_without_interests);
                    max_installments_with_interests = get_max_installments_with_interests(number_of_installment, installment_data, max_installments_with_interests);
                    var installment_container_selector = '#installment_' + payment_method.replace(" ", "_") + '_' + number_of_installment;

                    {# Shows installments rows on payments modal according to the minimum value #}
                    if(minimumInstallmentValue <= installment_data.installment_value) {
                        jQueryNuvem(installment_container_selector).show();
                    }

                    if(!parent.hasClass("js-quickshop-container")){
                        installment_helper(jQueryNuvem(installment_container_selector), number_of_installment, installment_data.installment_value.toFixed(2));
                    }
                }
            }
            var $installments_container = jQueryNuvem(variant.element + ' .js-max-installments-container .js-max-installments');
            var $installments_modal_link = jQueryNuvem(variant.element + ' #btn-installments');
            var $payments_module = jQueryNuvem(variant.element + ' .js-product-payments-container');
            var $installmens_card_icon = jQueryNuvem(variant.element + ' .js-installments-credit-card-icon');

	        {% if product.has_direct_payment_only %}
	        var installments_to_use = max_installments_without_interests[0] >= 1 ? max_installments_without_interests : max_installments_with_interests;

	        if(installments_to_use[0] <= 0 ) {
	        {%  else %}
	        var installments_to_use = max_installments_without_interests[0] > 1 ? max_installments_without_interests : max_installments_with_interests;

	        if(installments_to_use[0] <= 1 ) {
	        {% endif %}
	            $installments_container.hide();
	            $installments_modal_link.hide();
	            $payments_module.hide();
	            $installmens_card_icon.hide();
	        } else {
	            $installments_container.show();
	            $installments_modal_link.show();
	            $payments_module.show();
	            $installmens_card_icon.show();
	            installment_helper($installments_container, installments_to_use[0], installments_to_use[1]);
	        }
	    }

	    if(!parent.hasClass("js-quickshop-container")){
	    	jQueryNuvem('#installments-modal .js-installments-one-payment').text(variant.price_short).attr("data-value", variant.price_number);
		}
	    
	    if (variant.price_short){
	        var variant_price_clean = variant.price_short.replace('$', '').replace('R', '').replace(',', '').replace('.', '');
            var variant_price_raw = parseInt(variant_price_clean, 10);

            parent.find('.js-price-display').text(variant.price_short).show();
            parent.find('.js-price-display').attr("content", variant.price_number).data('productPrice', variant_price_raw);

            parent.find('.js-payment-discount-price-product').text(variant.price_with_payment_discount_short);
            parent.find('.js-payment-discount-price-product-container').show();
	    } else {
	        parent.find('.js-price-display, .js-payment-discount-price-product-container').hide();
	    }

	    if ((variant.compare_at_price_short) && !(parent.find(".js-price-display").css("display") == "none")) {
	        parent.find('.js-compare-price-display').text(variant.compare_at_price_short).show();
	    } else {
	        parent.find('.js-compare-price-display').hide();
	    }

	    var button = parent.find('.js-addtocart');
	    button.removeClass('cart').removeClass('contact').removeClass('nostock');
	    var $product_shipping_calculator = parent.find("#product-shipping-container");

        {# Update CTA wording and status #}

	    {% if not store.is_catalog %}
	    if (!variant.available){
	        button.val('{{ "Sin stock" | translate }}');
            button.addClass('nostock');
            button.attr('disabled', 'disabled');
	        $product_shipping_calculator.hide();
	    } else if (variant.contact) {
	        button.val('{{ "Consultar precio" | translate }}');
            button.addClass('contact');
            button.removeAttr('disabled');
            $product_shipping_calculator.hide();
	    } else {
	        button.val('{{ "Agregar al carrito" | translate }}');
            button.addClass('cart');
            button.removeAttr('disabled');
            $product_shipping_calculator.show();
	    }

	    {% endif %}

        {% if template == 'product' %}
            const base_price = Number(jQueryNuvem("#price_display").attr("content"));
            refreshInstallmentv2(base_price);
            refreshPaymentDiscount(variant.price_number);
            {% if should_show_discount %}
                togglePaymentDiscounts(variant);
                updateDiscountDisclaimers(variant);
            {% endif %}

            {% if settings.last_product and product.variations %}
                if(variant.stock == 1) {
                    jQueryNuvem('.js-last-product').show();
                } else {
                    jQueryNuvem('.js-last-product').hide();
                }
            {% endif %}
        {% endif %}

        {# Update shipping on variant change #}

        LS.updateShippingProduct();

        zipcode_on_changevariant = jQueryNuvem("#product-shipping-container .js-shipping-input").val();
        jQueryNuvem("#product-shipping-container .js-shipping-calculator-current-zip").text(zipcode_on_changevariant);
	}

	{# /* // Product labels on variant change */ #}

	{# Stock, Offer and discount labels update #}

	jQueryNuvem(document).on("change", ".js-variation-option", function(e) {

        var $parent = jQueryNuvem(this).closest(".js-product-variants");
        var $variants_group = jQueryNuvem(this).closest(".js-product-variants-group");
        var $quickshop_parent_wrapper = jQueryNuvem(this).closest(".js-quickshop-container");

        {# If quickshop is used from modal, use quickshop-id from the item that opened it #}
        
        if($quickshop_parent_wrapper.hasClass("js-quickshop-modal")){
            var quick_id = jQueryNuvem(".js-quickshop-opened .js-quickshop-container").data("quickshopId");
        }else{
            var quick_id = $quickshop_parent_wrapper.data("quickshopId");
        }

        if($parent.hasClass("js-product-quickshop-variants")){

            var $quickshop_parent = jQueryNuvem(this).closest(".js-item-product");

            {# Target visible slider item if necessary #}
            
            if($quickshop_parent.hasClass("js-item-slide")){
                var $quickshop_variant_selector = '.js-swiper-slide-visible .js-quickshop-container[data-quickshop-id="'+quick_id+'"]';
            }else{
                var $quickshop_variant_selector = '.js-quickshop-container[data-quickshop-id="'+quick_id+'"]';
            }
            
            LS.changeVariant(changeVariant, $quickshop_variant_selector);

            {% if settings.product_color_variants %}
                {# Match selected color variant with selected quickshop variant #}

                if(($variants_group).hasClass("js-color-variants-container")){
                    var selected_option_id = jQueryNuvem(this).find("option").filter((el) => el.selected).val();
                    if($quickshop_parent.hasClass("js-item-slide")){
                        var $color_parent_to_update = jQueryNuvem('.js-swiper-slide-visible .js-quickshop-container[data-quickshop-id="'+quick_id+'"]');
                    }else{
                        var $color_parent_to_update = jQueryNuvem('.js-quickshop-container[data-quickshop-id="'+quick_id+'"]');
                    }
                    $color_parent_to_update.find('.js-color-variant[data-option="'+selected_option_id+'"], .js-insta-variant[data-option="'+selected_option_id+'"]').addClass("selected").siblings().removeClass("selected");
                }
            {% endif %} 
        } else {
            LS.changeVariant(changeVariant, '#single-product');
        }

        {# Offer and discount labels update #}

        var $this_product_container = jQueryNuvem(this).closest(".js-product-container");

        if($this_product_container.hasClass("js-quickshop-container")){
            var this_quickshop_id = $this_product_container.attr("data-quickshop-id");
            var $this_product_container = jQueryNuvem('.js-product-container[data-quickshop-id="'+this_quickshop_id+'"]');
        }
        var $this_compare_price = $this_product_container.find(".js-compare-price-display");
        var $this_price = $this_product_container.find(".js-price-display");
        var $installment_container = $this_product_container.find(".js-product-payments-container");
        var $installment_text = $this_product_container.find(".js-max-installments-container");
        var $this_add_to_cart = $this_product_container.find(".js-prod-submit-form");

        // Get the current product discount percentage value
        var current_percentage_value = $this_product_container.find(".js-offer-percentage");

        // Get the current product price and promotional price
        var compare_price_value = $this_compare_price.html();
        var price_value = $this_price.html();

        // Calculate new discount percentage based on difference between filtered old and new prices
        const percentageDifference = window.moneyDifferenceCalculator.percentageDifferenceFromString(compare_price_value, price_value);
        if(percentageDifference){
            $this_product_container.find(".js-offer-percentage").text(percentageDifference);
            $this_product_container.find(".js-offer-label").css("display" , "table");
        }

	    if ($this_compare_price.css("display") == "none" || !percentageDifference) {
	        $this_product_container.find(".js-offer-label").hide();
	    }

	    if ($this_add_to_cart.hasClass("nostock")) {
	        $this_product_container.find(".js-stock-label").show();
	    }
	    else {
	        $this_product_container.find(".js-stock-label").hide();
	    }
	    if ($this_price.css('display') == 'none'){
	        $installment_container.hide();
	        $installment_text.hide();
	    }else{
	        $installment_text.show();
	    }
	});

    {% if settings.product_color_variants %}

        {# Product color variations #}

        jQueryNuvem(document).on("click", ".js-color-variant", function(e) {
            e.preventDefault();
            $this = jQueryNuvem(this);

            var option_id = $this.data('option');
            $selected_option = $this.closest('.js-item-product').find('.js-variation-option option').filter(function(el) {
                return el.value == option_id;
            });
            
            $selected_option.prop('selected', true).trigger('change');
            var available_variant = jQueryNuvem(this).closest(".js-quickshop-container").data('variants');

            var available_variant_color = jQueryNuvem(this).closest('.js-color-variant-active').data('option');

            for (var variant in available_variant) {
                if (option_id == available_variant[variant]['option'+ available_variant_color ]) {

                    if (available_variant[variant]['stock'] == null || available_variant[variant]['stock'] > 0 ) {

                        var otherOptions = getOtherOptionNumbers(available_variant_color);

                        var otherOption = available_variant[variant]['option' + otherOptions[0]];
                        var anotherOption = available_variant[variant]['option' + otherOptions[1]];

                        changeSelect(jQueryNuvem(this), otherOption, otherOptions[0]);
                        changeSelect(jQueryNuvem(this), anotherOption, otherOptions[1]);
                        break;

                    }
                }
            }
            $this.siblings().removeClass("selected");
            $this.addClass("selected");
        });

        function getOtherOptionNumbers(selectedOption) {
            switch (selectedOption) {
                case 0:
                    return [1, 2];
                case 1:
                    return [0, 2];
                case 2:
                    return [0, 1];
            }
        }

        function changeSelect(element, optionToSelect, optionIndex) {
            if (optionToSelect != null) {
                var selected_option_attribute = element.closest('.js-item-product').find('.js-color-variant-available-' + (optionIndex + 1)).data('value');
                var selected_option = element.closest('.js-item-product').find('#' + selected_option_attribute + " option").filter(function(el) {
                    return el.value == optionToSelect;
                });

                selected_option.prop('selected', true).trigger('change');
            }
        }

    {% endif %}

    {% if settings.bullet_variants %}

        changeVariantButton = function(selector, parentSelector) {
            selector.siblings().removeClass("selected");
            selector.addClass("selected");
            var option_id = selector.attr('data-option');
            var parent = selector.closest(parentSelector);
            var selected_option = parent.find('.js-variation-option option').filter(function (el) {
                return el.value == option_id;
            });
            selected_option.prop('selected', true).trigger('change');
        }
            
        jQueryNuvem(document).on("click", ".js-insta-variant", function (e) {
            e.preventDefault();
            $this = jQueryNuvem(this);
            changeVariantButton($this, '.js-product-variants-group');
        });

    {% endif %}

    {% if settings.product_color_variants or settings.quick_shop %}
    
        {# Product quickshop for color variations #}

        LS.registerOnChangeVariant(function(variant){
            {# Show product image on color change #}
            var current_image = jQueryNuvem('.js-item-product[data-product-id="'+variant.product_id+'"] .js-item-image');
            current_image.attr('srcset', variant.image_url);
        });

        
    {% endif %}

    {% if settings.quick_shop %}
        
        jQueryNuvem(document).on("click", ".js-quickshop-modal-open", function (e) {
            e.preventDefault();
            var $this = jQueryNuvem(this);
            if($this.hasClass("js-quickshop-slide")){
                jQueryNuvem("#quickshop-modal .js-item-product").addClass("js-swiper-slide-visible js-item-slide");
            }
            LS.fillQuickshop($this);
        });

        {# Get width of the placeholder button #}

        var productButttonWidth = jQueryNuvem(".js-addtocart-placeholder-inline").prev(".js-addtocart").innerWidth();
        jQueryNuvem(".js-addtocart-placeholder-inline").width(productButttonWidth-20);
    {% endif %}

	{# /* // Submit to contact */ #}

	{# Submit to contact form when product has no price #}

	jQueryNuvem(".js-product-form").on("submit", function (e) {
        var button = jQueryNuvem(e.currentTarget).find('[type="submit"]');
        button.attr('disabled', 'disabled');
        if ((button.hasClass('contact')) || (button.hasClass('catalog'))) {
            e.preventDefault();
            var product_id = jQueryNuvem(e.currentTarget).find("input[name='add_to_cart']").val();
            window.location = "{{ store.contact_url | escape('js') }}?product=" + product_id;
        } else if (button.hasClass('cart')) {
            button.val('{{ "Agregando..." | translate }}');
        }
    });

	{% if template == 'product' %}

	    {# /* // Product slider */ #}

            {% set has_multiple_slides = product.images_count > 1 or video_url %}

            var productSwiper = null;
            createSwiper(
                '.js-swiper-product',
                {
                    lazy: true,
                    loop: false,
                    pagination: {
                        el: '.js-swiper-product-pagination',
                        type: 'fraction',
                        clickable: true,
                    },
                    navigation: {
                        nextEl: '.js-swiper-product-next',
                        prevEl: '.js-swiper-product-prev',
                    },
                    on: {
                        init: function () {
                            jQueryNuvem(".js-product-slider-placeholder").hide();
                            jQueryNuvem(".js-swiper-product").css("visibility", "visible").css("height", "auto");
                            {% if video_url %}
                                productSwiperHeight = jQueryNuvem(".js-swiper-product").height();
                                jQueryNuvem(".js-product-video-slide").height(productSwiperHeight);
                            {% endif %}
                        },
                        {% if video_url %}
                            slideChangeTransitionEnd: function () {
                                if(jQueryNuvem(".js-product-video-slide").hasClass("swiper-slide-active")){
                                    jQueryNuvem(".js-labels-group").fadeOut(100);
                                }else{
                                    jQueryNuvem(".js-labels-group").fadeIn(100);
                                }
                                jQueryNuvem('.js-video').show();
                                jQueryNuvem('.js-video-iframe').hide().find("iframe").remove();
                            },
                        {% endif %}
                    },
                },
                function(swiperInstance) {
                    productSwiper = swiperInstance;
                }
            );

            Fancybox.bind('[data-fancybox="product-gallery"]', {
                Toolbar: { display: ['counter', 'close'] },
                Thumbs: { autoStart: false },
                on: {
                    shouldClose: (fancybox, slide) => {
                        if (!productSwiper) {
                            return;
                        }

                        // Update position of the slider
                        productSwiper.slideTo( fancybox.getSlide().index, 0 );
                    },
                },
            });

	    {% if has_multiple_slides %}
	        LS.registerOnChangeVariant(function(variant){
                var liImage = jQueryNuvem('.js-swiper-product').find("[data-image='"+variant.image+"']");
                var selectedPosition = liImage.data('imagePosition');
                var slideToGo = parseInt(selectedPosition);
                productSwiper.slideTo(slideToGo);
                jQueryNuvem(".js-product-slide-img").removeClass("js-active-variant");
                liImage.find(".js-product-slide-img").addClass("js-active-variant");
            });
	    {% endif %}

        {# /* // Pinterest sharing */ #}

        jQueryNuvem('.js-pinterest-share').on("click", function(e){
            e.preventDefault();
            jQueryNuvem(".pinterest-hidden a").get()[0].click();
        });

	{% endif %}

    {# Product quantitiy #}

    jQueryNuvem('.js-quantity .js-quantity-up').on('click', function(e) {
        $quantity_input = jQueryNuvem(e.currentTarget).closest(".js-quantity").find(".js-quantity-input");
        $quantity_input.val( parseInt($quantity_input.val(), 10) + 1);
    });

    jQueryNuvem('.js-quantity .js-quantity-down').on('click', function(e) {
        $quantity_input = jQueryNuvem(e.currentTarget).closest(".js-quantity").find(".js-quantity-input");
        quantity_input_val = $quantity_input.val();
        if (quantity_input_val>1) { 
            $quantity_input.val( parseInt($quantity_input.val(), 10) - 1);
        }
    });

	{#/*============================================================================
	  #Cart
	==============================================================================*/ #}

    {# /* // Position of cart page summary */ #}

    var head_height = jQueryNuvem(".js-head-main").outerHeight();

    if (window.innerWidth > 768) {
        {% if settings.head_fix %}
            jQueryNuvem("#cart-sticky-summary").css("top" , (head_height + 10).toString() + 'px');
        {% else %}
            jQueryNuvem("#cart-sticky-summary").css("top" , "10px");
        {% endif %}
    }

    {# /* // Add to cart */ #}

	jQueryNuvem(document).on("click", ".js-addtocart:not(.js-addtocart-placeholder)", function (e) {

        {# Button variables for transitions on add to cart #}

        var $productContainer = jQueryNuvem(this).closest('.js-product-container');
        var $productVariants = $productContainer.find(".js-variation-option");
        var $productButton = $productContainer.find("input[type='submit'].js-addtocart");
        var $productButtonPlaceholder = $productContainer.find(".js-addtocart-placeholder");
        var $productButtonText = $productButtonPlaceholder.find(".js-addtocart-text");
        var $productButtonAdding = $productButtonPlaceholder.find(".js-addtocart-adding");
        var $productButtonSuccess = $productButtonPlaceholder.find(".js-addtocart-success");

        {# Define if event comes from quickshop or product page #}

        var isQuickShop = $productContainer.hasClass('js-quickshop-container');

        if (!isQuickShop) {
            if(jQueryNuvem(".js-product-slide-img.js-active-variant").length) {
                var imageSrc = $productContainer.find('.js-product-slide-img.js-active-variant').data('srcset').split(' ')[0];
            } else {
                var imageSrc = $productContainer.find('.js-product-slide-img').attr('srcset').split(' ')[0];
            }
            var name = $productContainer.find('.js-product-name').text();
            var price = $productContainer.find('.js-price-display').text();
        } else {
            var imageSrc = jQueryNuvem(this).closest('.js-quickshop-container').find('img').attr('srcset');
            var name = $productContainer.find('.js-item-name').text();
            var price = $productContainer.find('.js-price-display').text().trim(); 
        }

        var quantity = $productContainer.find('.js-quantity-input').val();
        var addedToCartCopy = "{{ 'Agregar al carrito' | translate }}";


        if (!jQueryNuvem(this).hasClass('contact')) {

            {% if settings.ajax_cart %}
                e.preventDefault();
            {% endif %}

            {# Hide real button and show button placeholder during event #}

            $productButton.hide();
            $productButtonPlaceholder.show().addClass("active");
            $productButtonText.removeClass("active");
            setTimeout(function(){
                $productButtonAdding.addClass("active");
            },300);

            {% if settings.ajax_cart %}

                var callback_add_to_cart = function(){

                    {# Animate cart amount #}

                    jQueryNuvem(".js-cart-widget-amount").addClass("beat");

                    setTimeout(function(){
                        jQueryNuvem(".js-cart-widget-amount").removeClass("beat");
                    },4000);

                    {# Fill notification info #}

                    jQueryNuvem('.js-cart-notification-item-img').attr('srcset', imageSrc);
                    jQueryNuvem('.js-cart-notification-item-name').text(name);
                    jQueryNuvem('.js-cart-notification-item-quantity').text(quantity);
                    jQueryNuvem('.js-cart-notification-item-price').text(price);

                    if($productVariants.length){
                        var output = [];

                        $productVariants.each( function(el){
                            var variants = jQueryNuvem(el);
                            output.push(variants.val());
                        });
                        jQueryNuvem(".js-cart-notification-item-variant-container").show();
                        jQueryNuvem(".js-cart-notification-item-variant").text(output.join(', '))
                    }else{
                        jQueryNuvem(".js-cart-notification-item-variant-container").hide();
                    }

                    {# Set products amount wording visibility #}

                    var cartItemsAmount = jQueryNuvem(".js-cart-widget-amount").text();

                    if(cartItemsAmount > 1){
                        jQueryNuvem(".js-cart-counts-plural").show();
                        jQueryNuvem(".js-cart-counts-singular").hide();
                    }else{
                        jQueryNuvem(".js-cart-counts-singular").show();
                        jQueryNuvem(".js-cart-counts-plural").hide();
                    }

                    {# Show button placeholder with transitions #}

                    $productButtonAdding.removeClass("active");

                    setTimeout(function(){
                        $productButtonSuccess.addClass("active");
                    },300);
                    setTimeout(function(){
                        $productButtonSuccess.removeClass("active");
                        setTimeout(function(){
                            $productButtonText.addClass("active");
                        },300);
                        $productButtonPlaceholder.removeClass("active");
                    },2000);

                    setTimeout(function(){
                        $productButtonPlaceholder.hide();
                        $productButton.css('display' , 'inline-block');
                    },4000);

                    $productContainer.find(".js-added-to-cart-product-message").slideDown();

                    if (isQuickShop) {
                        jQueryNuvem("#quickshop-modal").removeClass('modal-show');
                        jQueryNuvem(".js-modal-overlay[data-modal-id='#quickshop-modal']").hide();
                        jQueryNuvem("body").removeClass("overflow-none");
                        restoreQuickshopForm();
                        if (window.innerWidth < 768) {
                            cleanURLHash();
                        }
                    }
                    
                   {# Show notification and hide it only after second added to cart #}

                    setTimeout(function(){
                        jQueryNuvem(".js-alert-added-to-cart").show().addClass("notification-visible").removeClass("notification-hidden");
                    },500);

                    if (!cookieService.get('first_product_added_successfully')) {
                        cookieService.set('first_product_added_successfully', 1, 7 ); 
                    } else{
                        setTimeout(function(){
                            jQueryNuvem(".js-alert-added-to-cart").removeClass("notification-visible").addClass("notification-hidden");
                            setTimeout(function(){
                                jQueryNuvem('.js-cart-notification-item-img').attr('src', '');
                                jQueryNuvem(".js-alert-added-to-cart").hide();
                            },2000);
                        },8000);
                    }

                    {# Update shipping input zipcode on add to cart #}

                    {# Use zipcode from input if user is in product page, or use zipcode cookie if is not #}

                    if (jQueryNuvem("#product-shipping-container .js-shipping-input").val()) {
                        zipcode_on_addtocart = jQueryNuvem("#product-shipping-container .js-shipping-input").val();
                        jQueryNuvem("#cart-shipping-container .js-shipping-input").val(zipcode_on_addtocart);
                        jQueryNuvem(".js-shipping-calculator-current-zip").text(zipcode_on_addtocart);
                    } else if (cookieService.get('calculator_zipcode')){
                        var zipcode_from_cookie = cookieService.get('calculator_zipcode');
                        jQueryNuvem('.js-shipping-input').val(zipcode_from_cookie);
                        jQueryNuvem(".js-shipping-calculator-current-zip").text(zipcode_from_cookie);
                    }
                }
                var callback_error = function(){

                    {# Restore real button visibility in case of error #}

                    $productButtonPlaceholder.removeClass("active");
                    $productButtonText.fadeIn("active");
                    $productButtonAdding.removeClass("active");
                    $productButtonPlaceholder.hide();
                    $productButton.css('display' , 'inline-block');
                }
                $prod_form = jQueryNuvem(this).closest("form");
                LS.addToCartEnhanced(
                    $prod_form,
                    '{{ "Agregar al carrito" | translate }}',
                    '{{ "Agregando..." | translate }}',
                    '{{ "¡Uy! No tenemos más stock de este producto para agregarlo al carrito." | translate }}',
                    {{ store.editable_ajax_cart_enabled ? 'true' : 'false' }},
                        callback_add_to_cart,
                        callback_error
                );
            {% endif %}
        }
    });


    {# /* // Cart quantitiy changes */ #}

    jQueryNuvem(document).on("keypress", ".js-cart-quantity-input", function (e) {
        if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
            return false;
        }
    });

    jQueryNuvem(document).on("focusout", ".js-cart-quantity-input", function (e) {
        var itemID = jQueryNuvem(this).attr("data-item-id");
        var itemVAL = jQueryNuvem(this).val();
        if (itemVAL == 0) {
            var r = confirm("{{ '¿Seguro que quieres borrar este artículo?' | translate }}");
            if (r == true) {
                LS.removeItem(itemID, true);
            } else {
                jQueryNuvem(this).val(1);
            }
        } else {
            LS.changeQuantity(itemID, itemVAL, true);
        }
    });

    {# /* // Empty cart alert */ #}

    jQueryNuvem(".js-trigger-empty-cart-alert").on("click", function (e) {
        e.preventDefault();
        let emptyCartAlert = jQueryNuvem(".js-mobile-nav-empty-cart-alert").fadeIn(100);
        setTimeout(() => emptyCartAlert.fadeOut(500), 1500);
    });

    {# /* // Go to checkout */ #}

    {# Clear cart notification cookie after consumers continues to checkout #}

    jQueryNuvem('form[action="{{ store.cart_url | escape('js') }}"]').on("submit", function() {
        cookieService.remove('first_product_added_successfully');
    });

	{#/*============================================================================
	  #Shipping calculator
	==============================================================================*/ #}

	{# /* // Select and save shipping function */ #}

    selectShippingOption = function(elem, save_option) {
        jQueryNuvem(".js-shipping-method, .js-branch-method").removeClass('js-selected-shipping-method');
        jQueryNuvem(elem).addClass('js-selected-shipping-method');
        if (save_option) {
            LS.saveCalculatedShipping(true);
        }
        if(jQueryNuvem(elem).hasClass("js-shipping-method-hidden")){

            {# Toggle other options visibility depending if they are pickup or delivery for cart and product at the same time #}

            if(jQueryNuvem(elem).hasClass("js-pickup-option")){
                jQueryNuvem(".js-other-pickup-options, .js-show-other-pickup-options .js-shipping-see-less").show();
                jQueryNuvem(".js-show-other-pickup-options .js-shipping-see-more").hide();

            }else{
                jQueryNuvem(".js-other-shipping-options, .js-show-more-shipping-options .js-shipping-see-less").show();
                jQueryNuvem(".js-show-more-shipping-options .js-shipping-see-more").hide()
            }          
        }
    };

    {# Apply zipcode saved by cookie if there is no zipcode saved on cart from backend #}

    if (cookieService.get('calculator_zipcode')) {

        {# If there is a cookie saved based on previous calcualtion, add it to the shipping input to triggert automatic calculation #}

        var zipcode_from_cookie = cookieService.get('calculator_zipcode');
        
        {% if settings.ajax_cart %}

            {# If ajax cart is active, target only product input to avoid extra calulation on empty cart #}

            jQueryNuvem('#product-shipping-container .js-shipping-input').val(zipcode_from_cookie);

        {% else %}

            {# If ajax cart is inactive, target the only input present on screen #}

            jQueryNuvem('.js-shipping-input').val(zipcode_from_cookie);

        {% endif %}

        jQueryNuvem(".js-shipping-calculator-current-zip").text(zipcode_from_cookie);

        {# Hide the shipping calculator and show spinner  #}

        jQueryNuvem(".js-shipping-calculator-head").addClass("with-zip").removeClass("with-form");
        jQueryNuvem(".js-shipping-calculator-with-zipcode").addClass("transition-up-active");
        jQueryNuvem(".js-shipping-calculator-spinner").show();
    } else {

        {# If there is no cookie saved, show calcualtor #}

        jQueryNuvem(".js-shipping-calculator-form").addClass("transition-up-active");
    }           

    {# Remove shipping suboptions from DOM to avoid duplicated modals #}

    removeShippingSuboptions = function(){
        var shipping_suboptions_id = jQueryNuvem(".js-modal-shipping-suboptions").attr("id");
        jQueryNuvem("#" + shipping_suboptions_id).remove();
        jQueryNuvem('.js-modal-overlay[data-modal-id="#' + shipping_suboptions_id + '"').remove();
    };

    {# /* // Calculate shipping function */ #}

	jQueryNuvem(".js-calculate-shipping").on("click", function (e) {
        e.preventDefault();

        {# Take the Zip code to all shipping calculators on screen #}
        let shipping_input_val = jQueryNuvem(e.currentTarget).closest(".js-shipping-calculator-form").find(".js-shipping-input").val();

        jQueryNuvem(".js-shipping-input").val(shipping_input_val);

        {# Calculate on page load for both calculators: Product and Cart #}

        if (jQueryNuvem(".js-cart-item").length) {
            LS.calculateShippingAjax(
            jQueryNuvem('#cart-shipping-container').find(".js-shipping-input").val(),
            '{{store.shipping_calculator_url | escape('js')}}',
            jQueryNuvem("#cart-shipping-container").closest(".js-shipping-calculator-container") );
        }

        jQueryNuvem(".js-shipping-calculator-current-zip").html(shipping_input_val);
        removeShippingSuboptions();

    });

	{# /* // Calculate shipping by submit */ #}

	jQueryNuvem(".js-shipping-input").on('keydown', function (e) {
        var key = e.which ? e.which : e.keyCode;
        var enterKey = 13;
        if (key === enterKey) {
            e.preventDefault();
            jQueryNuvem(e.currentTarget).closest(".js-shipping-calculator-form").find(".js-calculate-shipping").trigger('click');
            if (window.innerWidth < 768) {
                jQueryNuvem(e.currentTarget).trigger('blur');
            }
        }
    });

    {# /* // Shipping and branch click */ #}

    jQueryNuvem(document).on("change", ".js-shipping-method, .js-branch-method", function (e) {
        selectShippingOption(this, true);
        jQueryNuvem(".js-shipping-method-unavailable").hide();
    });

    {# /* // Select shipping first option on results */ #}

    jQueryNuvem(document).on('shipping.options.checked', '.js-shipping-method', function (e) {
        let shippingPrice = jQueryNuvem(this).attr("data-price");
        LS.addToTotal(shippingPrice);

        let total = (LS.data.cart.total / 100) + parseFloat(shippingPrice);
        jQueryNuvem(".js-cart-widget-total").html(LS.formatToCurrency(total));

        selectShippingOption(this, false);
    });

    {# /* // Toggle branches link */ #}

    jQueryNuvem(document).on("click", ".js-toggle-branches", function (e) {
        e.preventDefault();
        jQueryNuvem(".js-store-branches-container").slideToggle("fast");
        jQueryNuvem(".js-see-branches, .js-hide-branches").toggle();
    });

    {# /* // Toggle more shipping options */ #}

    jQueryNuvem(document).on("click", ".js-toggle-more-shipping-options", function(e) {
        e.preventDefault();

        {# Toggle other options depending if they are pickup or delivery for cart and product at the same time #}

        if(jQueryNuvem(this).hasClass("js-show-other-pickup-options")){
            jQueryNuvem(".js-other-pickup-options").slideToggle(600);
            jQueryNuvem(".js-show-other-pickup-options .js-shipping-see-less, .js-show-other-pickup-options .js-shipping-see-more").toggle();
        }else{
            jQueryNuvem(".js-other-shipping-options").slideToggle(600);
            jQueryNuvem(".js-show-more-shipping-options .js-shipping-see-less, .js-show-more-shipping-options .js-shipping-see-more").toggle();
        }
    });

    {# /* // Calculate shipping on page load */ #}

    {# Only shipping input has value, cart has saved shipping and there is no branch selected #}

    calculateCartShippingOnLoad = function(){
        if(jQueryNuvem("#cart-shipping-container .js-shipping-input").val()){
       
            // If user already had calculated shipping: recalculate shipping

            setTimeout(function() { 
                LS.calculateShippingAjax(
                    jQueryNuvem('#cart-shipping-container').find(".js-shipping-input").val(),
                    '{{store.shipping_calculator_url | escape('js')}}',
                    jQueryNuvem("#cart-shipping-container").closest(".js-shipping-calculator-container") );
                    removeShippingSuboptions();
            }, 100);
        }

        if(jQueryNuvem(".js-branch-method").hasClass('js-selected-shipping-method')){
            {% if store.branches|length > 1 %}
                jQueryNuvem(".js-store-branches-container").slideDown("fast");
                jQueryNuvem(".js-see-branches").hide();
                jQueryNuvem(".js-hide-branches").show();
            {% endif %}
        }
    };
    
    {% if cart.has_shippable_products %}
        calculateCartShippingOnLoad();
    {% endif %}

    {# /* // Change CP */ #}

    jQueryNuvem(document).on("click", ".js-shipping-calculator-change-zipcode", function(e) {
        e.preventDefault();
        jQueryNuvem(".js-shipping-calculator-response").fadeOut(100);
        jQueryNuvem(".js-shipping-calculator-head").addClass("with-form").removeClass("with-zip");
        jQueryNuvem(".js-shipping-calculator-with-zipcode").removeClass("transition-up-active");
        jQueryNuvem(".js-shipping-calculator-form").addClass("transition-up-active");
    }); 

    {# /* // Shipping provinces */ #}

    {% if provinces_json %}
        jQueryNuvem('select[name="country"]').on("change", function (e) {
            var provinces = {{ provinces_json | default('{}') | raw }};
            LS.swapProvinces(provinces[jQueryNuvem(e.currentTarget).val()]);
        }).trigger('change');
    {% endif %}

    {# /* // Change store country: From invalid zipcode message */ #}

    jQueryNuvem(document).on("click", ".js-save-shipping-country", function(e) {

        e.preventDefault();

        {# Change shipping country #}

        lang_select_option = jQueryNuvem(this).closest(".js-modal-shipping-country");
        changeLang(lang_select_option);

        jQueryNuvem(this).text('{{ "Aplicando..." | translate }}').addClass("disabled");
    });

    {#/*============================================================================
      #Forms
    ==============================================================================*/ #}

    jQueryNuvem(".js-winnie-pooh-form").on("submit", function (e) {
        jQueryNuvem(e.currentTarget).attr('action', '');
    });

    {# Show the success or error message when resending the validation link #}

    {% if template == 'account.register' or template == 'account.login' %}
        jQueryNuvem(".js-resend-validation-link").on("click", function(e){
            window.accountVerificationService.resendVerificationEmail('{{ customer_email }}');
        });
    {% endif %}

    {% if template == 'account.login' %}
        {% if result.invalid %}
            jQueryNuvem(".js-account-input").addClass("alert-danger");
            jQueryNuvem(".js-account-input.alert-danger").on("focus", function() {
                jQueryNuvem(".js-account-input").removeClass("alert-danger");
            });
        {% endif %}
    {% endif %}

    jQueryNuvem('.js-password-view').on("click", function (e) {
        jQueryNuvem(e.currentTarget).toggleClass('password-view');

        if(jQueryNuvem(e.currentTarget).hasClass('password-view')){
            jQueryNuvem(e.currentTarget).parent().find(".js-password-input").attr('type', '');
            jQueryNuvem(e.currentTarget).find(".js-eye-open, .js-eye-closed").toggle();
        } else {
            jQueryNuvem(e.currentTarget).parent().find(".js-password-input").attr('type', 'password');
            jQueryNuvem(e.currentTarget).find(".js-eye-open, .js-eye-closed").toggle();
        }
    });

    {#/*============================================================================
      #Footer
    ==============================================================================*/ #}

    {% if store.afip %}

        {# Add alt attribute to external AFIP logo to improve SEO #}

        jQueryNuvem('img[src*="www.afip.gob.ar"]').attr('alt', '{{ "Logo de AFIP" | translate }}');

    {% endif %}

});
