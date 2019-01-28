<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml" xmlns:og="http://opengraphprotocol.org/schema/">
    <head>
        <link rel="preconnect" href="https://d26lpennugtm8s.cloudfront.net" />
        <link rel="dns-prefetch" href="https://d26lpennugtm8s.cloudfront.net" />
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1" />
        <title>{{ page_title }}</title>
        <meta name="description" content="{{ page_description }}" />
        {% if settings.fb_admins %}
            <meta property="fb:admins" content="{{ settings.fb_admins }}" />
        {% endif %}
        {% if store_fb_app_id %}
        <meta property="fb:app_id" content="{{ store_fb_app_id }}" />
        {% elseif not store.has_custom_domain %}
        <meta property="fb:app_id" content="{{ fb_app.id }}" />
        {% endif %}
        {{ store.name | og('site_name') }}
        {% if template == 'home' and store.logo %}
            {{ ('http:' ~ store.logo) | og('image') }}
            {{ ('https:' ~ store.logo) | og('image:secure_url') }}
        {% endif %}

        {# OG tags to control how the page appears when shared on Facebook. See http://ogp.me/ #}
        {% snipplet "metas/facebook-og.tpl" %}
        {# Twitter tags to control how the page appears when shared on Twitter. See https://dev.twitter.com/cards/markup #}
        {% if template == 'product' %}
            {# Twitter #}
            {% snipplet "metas/twitter-product.tpl" %}
            {# Facebook #}
            {% snipplet "metas/facebook-product-og.tpl" %}
        {% elseif template == 'category' %}
            {# Facebook #}
            {% snipplet "metas/facebook-category-og.tpl" %}
        {% endif %}

        {#/*============================================================================
            #CSS and fonts
        ==============================================================================*/#}

        {# Critical CSS needed to show first elements of store while CSS async is loading #}

        <style>
            {# Font families #}

            {% if params.preview %}

                {# If page is loaded from customization page on the admin, load all fonts #}

                @import url('https://fonts.googleapis.com/css?family=Muli:400,700|Lato:400,700|Open+Sans:400,700|Lora:400,700|Slabo+27px|Playfair+Display:00,700|Droid+Sans:400,700');

            {% else %}

                {# If page is NOT loaded from customization only load saved fonts #}

                {# Get only the saved fonts on settings #}

                @import url('{{ [settings.font_headings, settings.font_rest] | google_fonts_url }}');

            {% endif %}


            {% include "static/css/style-critical.tpl" %}
        </style>

        {# Colors and fonts used from settings.txt and defined on theme customization #}

        {{ 'css/style-colors.scss.tpl' | static_url | css_tag }}

        {# Load async styling not mandatory for first meaningfull paint #}

        {% include "static/js/load-css-async.tpl" %}

        {# Loads custom CSS added from Advanced Settings on the admin´s theme customization screen #}

        <style>
            {{ settings.css_code | raw }}
        </style>

        {#/*============================================================================
            #Javascript: Needed before HTML loads
        ==============================================================================*/#}

        {# Defines if async JS will be used by using script_tag(true) #}

        {% set async_js = true %}

        {# Defines the usage of jquery loaded below, if nojquery = true is deleted it will fallback to jquery 1.5 #}

        {% set nojquery = true %}

        {# Jquery async by adding script_tag(true) #}

        {{ '//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js' | script_tag(true) }}

        {# Loads private Tienda Nube JS #}

        {% head_content %}

    </head>
    <body {% if settings.head_fix %}class="js-head-offset head-offset"{% endif %} itemscope itemtype="http://schema.org/WebPage" itemid="body">
        {# Facebook comments on product page #}

        {% if template == 'product' %}

            {# Facebook comment box JS #}
            {% if settings.show_product_fb_comment_box %}
                {{ fb_js }}
            {% endif %}
            
            {# Pinterest share button JS #}
            {{ pin_js }}

        {% endif %}

        {# Facebook account login and register #}

        {% if template == 'account.login' or template == 'account.register' %}
            {{ fb_js }}
            <script>
                function loginFacebook() {
                    LS.ready.then(function(){
                        LS.facebookLogin(FB, function(status, hasEmail) {
                            if (status === 'connected') {
                                if (hasEmail) {
                                    window.location = "{{ store.url }}/account/facebook_login/";
                                } else {
                                    $('#login-form').prepend(
                                            "<div class=\"alert alert-danger\">{{ 'Tienes que compartír tu e-mail.' | translate }}</div>");
                                }
                            } else {
                                $('#login-form').prepend(
                                        "<div class=\"alert alert-danger\">{{ 'Debes completar el login.' | translate }}</div>");
                            }
                        });
                    });
                }
            </script>
        {% endif %}
        
        {# Back to admin bar #}

        {{back_to_admin}}

        {# Header = Advertising + Nav + Logo + Search + Ajax Cart #}

        {% snipplet "header/header.tpl" %}

        {# Page content #}

        {% template_content %}

        {# WhatsApp chat button #}

        {% snipplet "whatsapp-chat.tpl" %}

        {# Footer #}

        {% snipplet "footer/footer.tpl" %}

        {#/*============================================================================
            #Javascript: Needed after HTML loads
        ==============================================================================*/#}
        
        {# Javascript used in the store #}

        <script type="text/javascript">

            {# Libraries that do NOT depend on other libraries, e.g: Jquery #}

            {% include "static/js/external-no-dependencies.js.tpl" %}

            {# LS.ready.then function waits to Jquery and private Tienda Nube JS to be loaded before executing what´s inside #}

            LS.ready.then(function(){

                {# Libraries that requires Jquery to work #}

                {% include "static/js/external.js.tpl" %}

                {# Specific store JS functions: product variants, cart, shipping, etc #}

                {% include "static/js/store.js.tpl" %}
            });
        </script>
        
        {# Google survey JS for Tienda Nube Survey #}

        {% include "static/js/google-survey.js.tpl" %}

    </body>
</html>
