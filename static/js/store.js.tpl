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
		// Instagram feed
        // Facebook login
	#Product grid
		// Show filters
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
    #Forms

==============================================================================*/#}

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


$(document).ready(function(){

	{#/*============================================================================
	  #Notifications
	==============================================================================*/ #}

	{# /* // Follow order status notification */ #}

    var $js_notification = $(".js-notification");
    if ($js_notification.size() > 0){
        if (LS.shouldShowOrderStatusNotification($js_notification.data('url'))){
            $js_notification.show();
        };
        $(".js-notification-close").on( "click", function(e) {
            e.preventDefault();
            LS.dontShowOrderStatusNotificationAgain($js_notification.data('url'));
            $(".js-notification").hide();
        });
    }

    {#/*============================================================================
      #Modals
    ==============================================================================*/ #}

    var $modal_close = $('.js-modal-close');
    var $modal_open = $('.js-modal-open');
    
    $modal_open.click(function (e) {
        e.preventDefault(); 
        var $modal_id = $(this).data('toggle');
        $(".js-modal-overlay").fadeToggle();
        if ($($modal_id).hasClass("modal-show")) {
            $($modal_id).removeClass("modal-show").delay(200).hide(0);
        } else {
            $($modal_id).detach().insertAfter(".js-modal-overlay").show(0).addClass("modal-show");
        }             
    });

    $modal_close.click(function (e) {
        e.preventDefault();  
        $(this).closest(".js-modal").removeClass("modal-show").delay(200).hide(0); 
        $(".js-modal-overlay").fadeOut(300);     
    });

    $(".js-modal-overlay").click(function (e) {
        e.preventDefault();  
        $(".js-modal.modal-show").removeClass("modal-show").delay(200).hide(0);   
        $(this).fadeOut(300);   
    });

    {#/*============================================================================
      #Tabs
    ==============================================================================*/ #}

    var $tab_open = $('.js-tab');

    $tab_open.click(function (e) {
        e.preventDefault(); 
        var $tab_container = $(this).closest(".js-tab-container");
        $tab_container.find(".js-tab, .js-tab-panel").removeClass("active");
        $(this).addClass("active");
        var tab_to_show = $(this).find(".js-tab-link").attr("href");
        $tab_container.find(tab_to_show).addClass("active");    
    });

	{#/*============================================================================
      #Header and nav
    ==============================================================================*/ #}

    {# /* // Header */ #}

        {% if template == 'home' and settings.head_transparent %}
            {% if settings.slider and settings.slider is not empty %}        

                var $swiper_height = $(window).height() - 100;
                
                $(document).scroll(function() {
                    if ($(document).scrollTop() > $swiper_height ) {
                        $(".js-head-main").removeClass("head-transparent");
                    } else {
                        $(".js-head-main").addClass("head-transparent");
                    }
                });

            {% endif %}
        {% endif %}

        {# /* // Nav offset */ #}

        function applyOffset(selector, is_negative){

            // Get nav height on load
            var head_height = $(".js-head-main").height();

            // Apply offset nav height on load
            if(is_negative){
                $(selector).css("margin-top", - head_height); 
                $(window).resize(function() {

                    // Get nav height on resize
                    var head_height = $(".js-head-main").height();

                    // Apply offset on resize
                    $(selector).css("margin-top", - head_height);
                });
            }else{
                $(selector).css("padding-top", head_height); 
                $(window).resize(function() {

                    // Get nav height on resize
                    var head_height = $(".js-head-main").height();

                    // Apply offset on resize
                    $(selector).css("padding-top", head_height);
                });
            }
        }

        {% if settings.head_fix %}
            applyOffset(".js-head-offset", false);
        {% endif %}

    {# /* // Nav */ #}

        var $top_nav = $(".js-mobile-nav");
        var $page_main_content = $(".js-main-content");
        var $search_backdrop = $(".js-search-backdrop");

        $top_nav.addClass("move-down").removeClass("move-up");


        {# Nav subitems #}

        $(".js-toggle-page-accordion").click(function (e) {
            e.preventDefault();
            $(this).toggleClass("selected").closest(".js-nav-list-toggle-accordion").next(".js-pages-accordion").slideToggle(300);
        });

        {# Focus search #}

        $(".js-toggle-search").click(function (e) {
            e.preventDefault;
            $(".js-search-input").focus();
        });


    {# /* // Search suggestions */ #}

        LS.search($(".js-search-input"), function (html, count) {
            $search_suggests = $(this).closest(".js-search-container").next(".js-search-suggest");
            if (count > 0) {
                $search_suggests.html(html).show();
            } else {
                $search_suggests.hide();
            }
            if ($(this).val().length == 0) {
                $search_suggests.hide();
            }
        }, {
            snipplet: 'header/header-search-results.tpl'
        });

        $(".js-search-suggest").on("click", ".js-search-suggest-all-link", function (e) {
            e.preventDefault();
            $this_closest_form = $(this).closest(".js-search-suggest").prev(".js-search-form");
            $this_closest_form.submit();
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
                            '<div style="background-image: url(' + aSlide.src + ')" class="slider-slide"></div>' +
                            (aSlide.link ? '</a>' : '' ) +
                        '</div>'
                    );
                });
                if(!slides.length){
                    $(".js-home-slider-container").addClass("hidden");
                    $(".js-home-empty-slider-container").removeClass("hidden")
                }else{
                    $(".js-home-slider-container").removeClass("hidden");
                    $(".js-home-empty-slider-container").addClass("hidden");
                }
            },
            changeAutoRotation: function(){

            },
        };
        var homeSwiper = new Swiper ('.js-home-slider', {
            {% if not params.preview %}
            lazy: {
                loadPrevNext: true,
            },
            {% endif %}
            {% if settings.slider | length > 1 %}
                loop: true,
            {% endif %}
            autoplay: slider_autoplay,
            watchOverflow: true,
            pagination: {
                el: '.js-swiper-home-pagination',
                clickable: true,
            },
            navigation: {
                nextEl: '.js-swiper-home-next',
                prevEl: '.js-swiper-home-prev',
            },
            on: {
                init: function () {
                  $(".js-home-slider-placeholder").hide();
                  $(".js-home-slider").css({"visibility" : "visible" , "height" : "100%"});
                },
            },
        });

        {% if settings.slider | length == 1 %}
            $('.js-swiper-home .swiper-wrapper').addClass( "disabled" );
            $('.js-swiper-home-pagination, .js-swiper-home-prev, .js-swiper-home-next').remove();
        {% endif %}

        {% if not settings.head_transparent %}
            applyOffset(".js-home-slider", false);
        {% endif %}
        
        applyOffset(".js-home-slider", true);          

        {% if sections.primary.products %}

            {% set columns = settings.grid_columns %}
            var featuredSwiper = new Swiper ('.js-swiper-featured', {
                lazy: true,
                loop: true,
                spaceBetween: 30,
                slidesPerView: {% if columns == 2 %}2{% else %}1{% endif %},
                pagination: {
                    el: '.js-swiper-featured-pagination',
                    clickable: true,
                },
                navigation: {
                    nextEl: '.js-swiper-featured-next',
                    prevEl: '.js-swiper-featured-prev',
                },
                breakpointsInverse: true,
                breakpoints: {
                    640: {
                        slidesPerView: {% if columns == 2 %}4{% else %}3{% endif %},
                    }
                }
            });

        {% endif %}

	{% endif %}

    {% if template == 'product' %}

        {# /* // Product Related */ #}

            {% set related_products_ids = product.metafields.related_products.related_products_ids %}
            {% if related_products_ids %}
                {% set related_products = related_products_ids | get_products %}
                {% set show = (related_products | length > 0) %}
            {% endif %}
            {% if not show %}
                {% set related_products = category.products | shuffle | take(8) %}
                {% set show = (related_products | length > 1) %}
            {% endif %}

            {% set columns = settings.grid_columns %}
            var relatedSwiper = new Swiper ('.js-swiper-related', {
                lazy: true,
                {% if related_products | length > 4 %}
                loop: true,
                {% endif %}
                spaceBetween: 30,
                slidesPerView: {% if columns == 2 %}2{% else %}1{% endif %},
                pagination: {
                    el: '.js-swiper-related-pagination',
                    clickable: true,
                },
                navigation: {
                    nextEl: '.js-swiper-related-next',
                    prevEl: '.js-swiper-related-prev',
                },
                breakpointsInverse: true,
                breakpoints: {
                    767: {
                        slidesPerView: {% if columns == 2 %}4{% else %}3{% endif %},
                    }
                }
            });

    {% endif %}



	{% set has_banner_services = settings.banner_services %}

	{% if has_banner_services %}

		{# /* // Banner services slider */ #}

        var width = window.innerWidth;
        if (width < 767) {   
            var swiperInformative = new Swiper ('.js-informative-banners', {
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

	{% if template == 'home' and (settings.video_embed or settings.show_instafeed) %}

        {# /* // Youtube or Vimeo video */ #}

        {% if settings.video_embed %}
            function parseVideo (url) {

                url.match(/(http:|https:|)\/\/(player.|www.)?(vimeo\.com|youtu(be\.com|\.be|be\.googleapis\.com))\/(video\/|embed\/|watch\?v=|v\/)?([A-Za-z0-9._%-]*)(\&\S+)?/);

                if (RegExp.$3.indexOf('youtu') > -1) {
                    var type = 'youtube';
                } else if (RegExp.$3.indexOf('vimeo') > -1) {
                    var type = 'vimeo';
                }

                return {
                    type: type,
                    id: RegExp.$6
                };
            }

            var videoObj = parseVideo('{{ settings.video_embed }}');
            var $iframe = $('.js-video-home');
            if (videoObj.type == 'youtube') {
                $('.js-play-button').click(function() {
                    $iframe.html('<iframe class="embed-responsive-item" src="https://youtube.com/embed/' + videoObj.id + '?color=white&amp;rel=0&amp;showinfo=0&amp;autoplay=1" allow="autoplay; encrypted-media"></iframe>');
                });
                var thumbYoutube = ('https://img.youtube.com/vi/' + videoObj.id + '/maxresdefault.jpg');
                $('.js-video-image img').attr('data-src', thumbYoutube);
            } else if (videoObj.type == 'vimeo') {
                $('.js-play-button').click(function() {
                    $iframe.html('<iframe class="embed-responsive-item" src="https://player.vimeo.com/video/' + videoObj.id + '?color={{ settings.button_bg | ltrim('#') }}&title=0&byline=0&portrait=0&autoplay=1" frameborder="0" webkitallowfullscreen mozallowfullscreen></iframe>');
                });
                $.get('https://vimeo.com/api/v2/video/' + videoObj.id + '.json', function(data) {
                  var thumbVimeo = data[0].thumbnail_large;
                  var thumbSplit = thumbVimeo.split(/\d{3}(?=.jpg)/);
                  $(".js-video-image img").attr('data-src', thumbSplit[0] + '1280x720' + thumbSplit[1]);
                });
            }
        {% endif %}

        {# /* // Instagram feed */ #}

        {% if settings.show_instafeed %}
            var width = window.innerWidth;
            if (width > 767) {  
                var resolution = "standard_resolution";  
            } else {
                var resolution = "low_resolution";
            }
            var feedqty = 9;
            {% set userid = settings.instafeed_accesstoken|split('.')|first %}

            {% set instlink = '{{link}}' %}
            {% set instimg = '{{image}}' %}
            {% set instlike = '{{likes}}' %}
            {% set instcomm = '{{comments}}' %}

            var userFeed = new Instafeed({
            get: 'user',
                userId: '{{ userid }}',
                accessToken: '{{ settings.instafeed_accesstoken }}',
                resolution: resolution,
                template: '<div class="col-4"><a class="instafeed-link" href="{{instlink}}" target="_blank"><div class="instafeed-img lazyload" data-bg="{{instimg}}">{% if settings.instafeed_like %}<div class="instafeed-info"><span class="instafeed-info-item">{% include "snipplets/svg/heart.tpl" with {svg_custom_class: "icon-inline"} %} {{instlike}}</span></div>{% endif %}</div></a></div>',
                limit: feedqty
           });
           userFeed.run();
       {% endif %}

   	{% endif %}

	{#/*============================================================================
	  #Product grid
	==============================================================================*/ #}

	{% if template == 'category' %}

		{# /* // Show filters */ #}

		LS.showWhiteListedFilters("{{ filters|json_encode() }}");

		{# /* // Sort by */ #}

		$('.js-sort-by').change(function () {
            var params = LS.urlParams;
            params['sort_by'] = $(this).val();
            var sort_params_array = [];
            for (var key in params) {
                if ($.inArray(key, ['results_only', 'page']) == -1) {
                    sort_params_array.push(key + '=' + params[key]);
                }
            }
            var sort_params = sort_params_array.join('&');
            window.location = window.location.pathname + '?' + sort_params;
        });

	{% endif %}

    {% if template == 'category' or template == 'search' %}

        $(function() {

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
        });

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

	{# Refresh installments inside detail popup #}

	function refreshInstallmentv2(price){
	    $(".js-modal-installment-price" ).each(function( index ) {
	        const installment = Number($(this).data('installment'));
	        $(this).text(LS.currency.display_short + (price/installment).toLocaleString('de-DE', {maximumFractionDigits: 2, minimumFractionDigits: 2}));
	    });
	}

	{# /* // Change variant */ #}

	{# Updates price, installments, labels and CTA on variant change #}

	function changeVariant(variant){
	    $(".js-product-detail .js-shipping-calculator-response").hide();
	    $("#shipping-variant-id").val(variant.id);

	    var parent = $("body");
	    if (variant.element){
	        parent = $(variant.element);
	    }

	    var sku = parent.find('#sku');
	    if(sku.length) {
	        sku.text(variant.sku).show();
	    }

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
	        $.each(variant_installments, function(payment_method, installments) {
	            $.each(installments, function(number_of_installment, installment_data) {
	                max_installments_without_interests = get_max_installments_without_interests(number_of_installment, installment_data, max_installments_without_interests);
	                max_installments_with_interests = get_max_installments_with_interests(number_of_installment, installment_data, max_installments_with_interests);
	                var installment_container_selector = '#installment_' + payment_method + '_' + number_of_installment;

	                if(!parent.hasClass("js-quickshop-container")){
	                    installment_helper($(installment_container_selector), number_of_installment, installment_data.installment_value.toFixed(2));
	                }
	            });
	        });
	        var $installments_container = $(variant.element + ' .js-max-installments-container .js-max-installments');
	        var $installments_modal_link = $(variant.element + ' #btn-installments');
	        var $payments_module = $(variant.element + ' .js-product-payments-container');
	        var $installmens_card_icon = $(variant.element + ' .js-installments-credit-card-icon');

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
	    	$('#installments-modal .js-installments-one-payment').text(variant.price_short).attr("data-value", variant.price_number);
		}
	    
	    if (variant.price_short){
	        parent.find('.js-price-display').text(variant.price_short).show();
	        parent.find('.js-price-display').attr("content", variant.price_number);
	    } else {
	        parent.find('.js-price-display').hide();
	    }

	    if ((variant.compare_at_price_short) && !(parent.find(".js-price-display").css("display") == "none")) {
	        parent.find('.js-compare-price-display').text(variant.compare_at_price_short).show();
	    } else {
	        parent.find('.js-compare-price-display').hide();
	    }

	    var button = parent.find('.js-addtocart');
	    button.removeClass('cart').removeClass('contact').removeClass('nostock');
	    var $product_shipping_calculator = parent.find("#product-shipping-container");
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
	        const base_price = Number($("#price_display").attr("content"));
	        refreshInstallmentv2(base_price);
	    {% endif %}
	}

	{# /* // Product labels on variant change */ #}

	{# Stock, Offer and discount labels update #}

	$(document).on("change", ".js-variation-option", function(e) {
        LS.changeVariant(changeVariant, '#single-product');
	    var $this_compare_price =  $(this).closest(".js-product-container").find(".js-compare-price-display");
	    var $this_price = $(this).closest(".js-product-container").find(".js-price-display");
	    var $installment_container = $(this).closest(".js-product-container").find(".js-product-payments-container");
	    var $installment_text = $(this).closest(".js-product-container").find(".js-max-installments-container");
	    var $this_product_container = $(this).closest(".js-product-container");
	    var $this_add_to_cart =  $(this).closest(".js-product-container").find(".js-prod-submit-form");
	    // Get the current product discount percentage value
	    var current_percentage_value = $this_product_container.find(".js-offer-percentage");
	    // Get the current product price and promotional price
	    var compare_price_value = $this_compare_price.html();
	    var price_value = $this_price.html();
	    // Filter prices to only have numbers
	    old_price_value_filtered = parseInt(compare_price_value.replace(/[^0-9]/gi, ''), 10)/100;
	    current_price_value_filtered = parseInt(price_value.replace(/[^0-9]/gi, ''), 10)/100;
	    // Calculate new discount percentage based on difference between filtered old and new prices
	    price_difference = (old_price_value_filtered-current_price_value_filtered);
	    updated_discount_percentage = Math.round(((price_difference*100)/old_price_value_filtered));
	    $this_product_container.find(".js-offer-percentage").html(updated_discount_percentage);
	    if ($this_compare_price.css("display") == "none") {
	        $this_product_container.find(".js-offer-label").hide();
	    }
	    else {
	        $this_product_container.find(".js-offer-label").css("display" , "table");
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

	{# /* // Submit to contact */ #}

	{# Submit to contact form when product has no price #}

	$(".js-product-form").submit(function (e) {
	    var button = $(this).find(':submit');
	    button.attr('disabled', 'disabled');
	    if ((button.hasClass('contact')) || (button.hasClass('catalog'))) {
	        e.preventDefault();
	        var product_id = $(this).find("input[name='add_to_cart']").val();
	        window.location = "{{ store.contact_url | escape('js') }}?product=" + product_id;
	    } else if (button.hasClass('cart')) {
	        button.val('{{ "Agregando..." | translate }}');
	    }
	});

	{% if template == 'product' %}

	    {# /* // Product slider */ #}

            var productSwiper = new Swiper ('.js-swiper-product', {
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
                      $(".js-product-slider-placeholder").hide();
                      $(".js-swiper-product").css({"visibility" : "visible" , "height" : "auto"});
                    },
                },
            });

            $().fancybox({
                selector : '[data-fancybox="product-gallery"]',
                toolbar  : false,
                smallBtn : true,
                beforeClose : function(instance) {                    
                    // Update position of the slider
                    productSwiper.slideTo( instance.currIndex, 0 );
                    
                  }
            });

	    {% if product.images_count > 1 %}
	        LS.registerOnChangeVariant(function(variant){
	            var liImage = $('.js-swiper-product').find("[data-image='"+variant.image+"']");
	            var selectedPosition = liImage.data('image-position');
	            var slideToGo = parseInt(selectedPosition);
                productSwiper.slideTo(slideToGo);
	        });
	    {% endif %}

        {# /* // Pinterest sharing */ #}

        $('.js-pinterest-share').click(function(e){
            e.preventDefault();
            $(".pinterest-hidden a")[0].click();
        });

	{% endif %}

    {# Product quantitiy #}

    $('.js-quantity .js-quantity-up').on('click', function() {
        $quantity_input = $(this).closest(".js-quantity").find(".js-quantity-input");
        $quantity_input.val( parseInt($quantity_input.val(), 10) + 1);
    });

    $('.js-quantity .js-quantity-down').on('click', function() {
        $quantity_input = $(this).closest(".js-quantity").find(".js-quantity-input");
        quantity_input_val = $quantity_input.val();
        if (quantity_input_val>1) { 
            $quantity_input.val( parseInt($quantity_input.val(), 10) - 1);
        }
    });

	{#/*============================================================================
	  #Cart
	==============================================================================*/ #}

    {# /* // Add to cart */ #}

	$(document).on("click", ".js-addtocart", function (e) {
        if (!$(this).hasClass('contact')) {
            e.preventDefault();
            var callback_add_to_cart = function(){
                if ($(window).width() > 768) {
                    $(".js-toggle-cart").click();
                }else{
                   $(".js-alert-added-to-cart").show().toggleClass("notification-visible notification-hidden");
                    setTimeout(function(){
                        $(".js-alert-added-to-cart").toggleClass("notification-visible notification-hidden");
                    },7000);
                }
                $(".js-shipping-filled-cart").show();
            }
            $prod_form = $(this).closest("form");
            LS.addToCartEnhanced(
                $prod_form,
                '{{ "Agregar al carrito" | translate }}',
                '{{ "Agregando..." | translate }}',
                '{{ "¡Uy! No tenemos más stock de este producto para agregar este producto al carrito." | translate }}',
                {{ store.editable_ajax_cart_enabled ? 'true' : 'false' }},
                    callback_add_to_cart
            );
        }
    });


    {# /* // Cart quantitiy changes */ #}

    $(document).on("keypress", ".js-cart-quantity-input", function (e) {
        if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
            return false;
        }
    });

    $(document).on("focusout", ".js-cart-quantity-input", function (e) {
        $(".js-shipping-calculator-response").hide().empty();
        $(".js-go-checkout-btn").prop("disabled", true);
        var itemID = $(this).attr("data-item-id");
        var itemVAL = $(this).val();
        if (itemVAL == 0) {
            var r = confirm("{{ '¿Seguro que quieres borrar este artículo?' | translate }}");
            if (r == true) {
                LS.removeItem(itemID, true);
            } else {
                $(this).val(1);
            }
        } else {
            LS.changeQuantity(itemID, itemVAL, true);
        }
    });

    {# /* // Empty cart alert */ #}

    $(".js-trigger-empty-cart-alert").click(function (e) {
        e.preventDefault();
        $(".js-mobile-nav-empty-cart-alert").fadeIn(100).delay(1500).fadeOut(500);
    });

	{#/*============================================================================
	  #Shipping calculator
	==============================================================================*/ #}

	{# /* // Select and save shipping function */ #}

    selectAndSaveShippingOption = function(elem){
        $(".js-shipping-method, .js-branch-method").removeClass('js-selected-shipping-method');
        $(elem).addClass('js-selected-shipping-method');
        LS.saveCalculatedShipping(true);
        var $closest_shipping_container = $(elem).closest(".js-shipping-calculator-container");
        if($(elem).hasClass("js-shipping-method-hidden")){
            $closest_shipping_container.find(".js-shipping-see-more").hide();
            $closest_shipping_container.find(".js-shipping-see-less").show();
            $closest_shipping_container.find(".js-other-shipping-options").show();
        }
    };

    {# /* // Calculate shipping function */ #}

	$(".js-calculate-shipping").click(function (e) {
	    e.preventDefault();

	        {# Take the Zip code to all shipping calculators on screen #}
	        let shipping_input_val = $(this).closest(".js-shipping-calculator-form").find(".js-shipping-input").val();
	        if (shipping_input_val.length != 0){
	            $(".js-shipping-input").val(shipping_input_val);
	        }
	        
	    LS.calculateShippingAjax(
	        $(this).closest(".js-shipping-calculator-container").find(".js-shipping-input").val(),
	        '{{ store.shipping_calculator_url | escape('js') }}',
	        $(this).closest(".js-shipping-calculator-container")
	    );
	});

	{# /* // Calculate shipping by submit */ #}

	$(".js-shipping-input").keydown(function (e) {
	    var key = e.which ? e.which : e.keyCode;
	    var enterKey = 13;
	    if (key === enterKey) {
	        e.preventDefault();
	        $(this).closest(".js-shipping-calculator-form").find(".js-calculate-shipping").click();
	        if ($(window).width() < 768) {
	            $(this).blur();
	        }
	    }
	});

    {# /* // Shipping and branch click */ #}

    $(document).on("change", ".js-shipping-method, .js-branch-method", function () {
        selectAndSaveShippingOption(this);
        $(".js-shipping-method-unavailable").hide();
    });

    {# /* // Select shipping first option on results */ #}

	$('.js-shipping-method:checked').livequery(function () {
	    let shippingPrice = $(this).attr("data-price");
	    LS.addToTotal(shippingPrice);
        selectAndSaveShippingOption(this);
	});

    {# /* // Toggle branches link */ #}

    $(document).on("click", ".js-toggle-branches", function (e) {
        e.preventDefault();
        $(this).next().slideToggle("fast");
        $(this).find(".js-see-branches, .js-hide-branches").toggle();
    });

    {# /* // Toggle more shipping options */ #}

	$(document).on("click", ".js-show-more-shipping-options", function(e) {
	    e.preventDefault();
	    $(this).next().slideToggle("fast");
	    $(this).find(".js-shipping-see-more, .js-shipping-see-less").toggle();
	});

    {# /* // Calculate shipping on page load */ #}

    {# Only shipping input has value, cart has saved shipping and there is no branch selected #}

    if($("#cart-shipping-container .js-shipping-input").val() && !$(".js-branch-method").hasClass('js-selected-shipping-method') && $(".js-cart-total").hasClass('js-cart-saved-shipping')){
       
        // If user already had calculated shipping: recalculate shipping
       
       setTimeout(function() { 
            LS.calculateShippingAjax(
                $('#cart-shipping-container').find(".js-shipping-input").val(), 
                '{{store.shipping_calculator_url | escape('js')}}',
                $("#cart-shipping-container").closest(".js-shipping-calculator-container") );
        }, 100);
    }else if($(".js-branch-method").hasClass('js-selected-shipping-method')){
        $("#cart-shipping-container .js-toggle-branches").click();

        // Trigger function only for free pickup stores
        LS.saveCalculatedShipping(false);
    }

	{# /* // Shipping provinces */ #}

	{% if provinces_json %}
		$('select[name="country"]').change(function () {
		    var provinces = {{ provinces_json | default('{}') | raw }};
		    LS.swapProvinces(provinces[$(this).val()]);
		}).change();
	{% endif %}

    {#/*============================================================================
      #Forms
    ==============================================================================*/ #}

    $(".js-winnie-pooh-form").submit(function (e) {
        $(this).attr('action', '');
    });

});
