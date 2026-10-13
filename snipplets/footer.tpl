{# Variaveis auxiliares #}
{% set has_social_network = settings.footer_social_whatsapp_url or settings.footer_social_instagram_url or settings.footer_social_facebook_url or settings.footer_social_youtube_url or settings.footer_social_pinterest_url or settings.footer_social_linkedin_url or settings.footer_social_tiktok_url %}
{% set has_payment_logos = settings.payments %}
{% set has_shipping_logos = settings.shipping %}
{% set has_shipping_payment_logos = has_payment_logos or has_shipping_logos %}
{% set has_support_links = settings.footer_support_link_1_text or settings.footer_support_link_2_text or settings.footer_support_link_3_text %}
{% set has_about_links = settings.footer_about_link_1_text or settings.footer_about_link_2_text or settings.footer_about_link_3_text %}

<footer class="js-footer js-hide-footer-while-scrolling display-when-content-ready bg-secondary" data-store="footer">
    <div class="flex flex-col items-start gap-8 self-stretch px-6 py-8 md:px-16">

        {# Main Footer Content - 3 Columns #}
        <div class="w-full">
            {# Logo do Rodape: SVG > Imagem > Nada #}
            {% if settings.logo_footer_svg %}
                <div class="mb-6 footer-logo-svg max-h-12">
                    {{ settings.logo_footer_svg | raw }}
                </div>
            {% elseif "logo_footer.png" | has_custom_image %}
                <div class="mb-6">
                    <img src="{{ 'images/empty-placeholder.png' | static_url }}"
                         data-src="{{ "logo_footer.png" | static_url }}"
                         class="lazyload max-h-12"
                         alt="{{ store.name }} - Logo" />
                </div>
            {% endif %}

            {# Grid de 3 Colunas #}
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">

                {# Coluna 1: Contato (Redes Sociais) #}
                <div class="flex flex-col gap-4">
                    <h3 class="text-fg font-heading text-2xl font-semibold">
                        {{ "Contato" | translate }}
                    </h3>

                    {# Social Icons #}
                    {% if has_social_network %}
                        <div class="flex flex-wrap gap-x-0.5 gap-y-0.5 -ml-[3px] py-[5px]">
                            {% if settings.footer_social_whatsapp_url %}
                                <a href="{{ settings.footer_social_whatsapp_url | setting_url }}" target="_blank" aria-label="WhatsApp {{ store.name }}" class="flex p-2.5 text-fg hover:opacity-70 transition-opacity">
                                    {% include "snipplets/svg/whatsapp.tpl" with {svg_custom_class: "w-5 h-5"} %}
                                </a>
                            {% endif %}
                            {% if settings.footer_social_instagram_url %}
                                <a href="{{ settings.footer_social_instagram_url | setting_url }}" target="_blank" aria-label="Instagram {{ store.name }}" class="flex p-2.5 text-fg hover:opacity-70 transition-opacity">
                                    {% include "snipplets/svg/instagram.tpl" with {svg_custom_class: "w-5 h-5"} %}
                                </a>
                            {% endif %}
                            {% if settings.footer_social_facebook_url %}
                                <a href="{{ settings.footer_social_facebook_url | setting_url }}" target="_blank" aria-label="Facebook {{ store.name }}" class="flex p-2.5 text-fg hover:opacity-70 transition-opacity">
                                    {% include "snipplets/svg/facebook.tpl" with {svg_custom_class: "w-5 h-5"} %}
                                </a>
                            {% endif %}
                            {% if settings.footer_social_youtube_url %}
                                <a href="{{ settings.footer_social_youtube_url | setting_url }}" target="_blank" aria-label="YouTube {{ store.name }}" class="flex p-2.5 text-fg hover:opacity-70 transition-opacity">
                                    {% include "snipplets/svg/youtube.tpl" with {svg_custom_class: "w-5 h-5"} %}
                                </a>
                            {% endif %}
                            {% if settings.footer_social_pinterest_url %}
                                <a href="{{ settings.footer_social_pinterest_url | setting_url }}" target="_blank" aria-label="Pinterest {{ store.name }}" class="flex p-2.5 text-fg hover:opacity-70 transition-opacity">
                                    {% include "snipplets/svg/pinterest.tpl" with {svg_custom_class: "w-5 h-5"} %}
                                </a>
                            {% endif %}
                            {% if settings.footer_social_linkedin_url %}
                                <a href="{{ settings.footer_social_linkedin_url | setting_url }}" target="_blank" aria-label="LinkedIn {{ store.name }}" class="flex p-2.5 text-fg hover:opacity-70 transition-opacity">
                                    {% include "snipplets/svg/linkedin.tpl" with {svg_custom_class: "w-5 h-5"} %}
                                </a>
                            {% endif %}
                            {% if settings.footer_social_tiktok_url %}
                                <a href="{{ settings.footer_social_tiktok_url | setting_url }}" target="_blank" aria-label="TikTok {{ store.name }}" class="flex p-2.5 text-fg hover:opacity-70 transition-opacity">
                                    {% include "snipplets/svg/tiktok.tpl" with {svg_custom_class: "w-5 h-5"} %}
                                </a>
                            {% endif %}
                        </div>
                    {% endif %}
                </div>

                {# Coluna 2: Suporte #}
                <div class="flex flex-col gap-4">
                    <h3 class="text-fg font-heading text-2xl font-semibold">
                        {{ settings.footer_support_title | default("Suporte" | translate) }}
                    </h3>

                    <nav class="flex flex-col gap-1.75">
                        {% if settings.footer_support_link_1_text and settings.footer_support_link_1_url %}
                            <a href="{{ settings.footer_support_link_1_url | setting_url }}" class="text-fg hover:opacity-70 transition-opacity text-sm font-medium">
                                {{ settings.footer_support_link_1_text }}
                            </a>
                        {% endif %}
                        {% if settings.footer_support_link_2_text and settings.footer_support_link_2_url %}
                            <a href="{{ settings.footer_support_link_2_url | setting_url }}" class="text-fg hover:opacity-70 transition-opacity text-sm font-medium">
                                {{ settings.footer_support_link_2_text }}
                            </a>
                        {% endif %}
                        {% if settings.footer_support_link_3_text and settings.footer_support_link_3_url %}
                            <a href="{{ settings.footer_support_link_3_url | setting_url }}" class="text-fg hover:opacity-70 transition-opacity text-sm font-medium">
                                {{ settings.footer_support_link_3_text }}
                            </a>
                        {% endif %}
                        {% if settings.footer_support_link_4_text and settings.footer_support_link_4_url %}
                            <a href="{{ settings.footer_support_link_4_url | setting_url }}" class="text-fg hover:opacity-70 transition-opacity text-sm font-medium">
                                {{ settings.footer_support_link_4_text }}
                            </a>
                        {% endif %}
                        {% if settings.footer_support_link_5_text and settings.footer_support_link_5_url %}
                            <a href="{{ settings.footer_support_link_5_url | setting_url }}" class="text-fg hover:opacity-70 transition-opacity text-sm font-medium">
                                {{ settings.footer_support_link_5_text }}
                            </a>
                        {% endif %}
                        {% if settings.footer_support_link_6_text and settings.footer_support_link_6_url %}
                            <a href="{{ settings.footer_support_link_6_url | setting_url }}" class="text-fg hover:opacity-70 transition-opacity text-sm font-medium">
                                {{ settings.footer_support_link_6_text }}
                            </a>
                        {% endif %}
                    </nav>
                </div>

                {# Coluna 3: Sobre #}
                <div class="flex flex-col gap-4">
                    <h3 class="text-fg font-heading text-2xl font-semibold">
                        {{ settings.footer_about_title | default("Sobre" | translate) }}
                    </h3>

                    <nav class="flex flex-col gap-1.75">
                        {% if settings.footer_about_link_1_text and settings.footer_about_link_1_url %}
                            <a href="{{ settings.footer_about_link_1_url | setting_url }}" class="text-fg hover:opacity-70 transition-opacity text-sm font-medium">
                                {{ settings.footer_about_link_1_text }}
                            </a>
                        {% endif %}
                        {% if settings.footer_about_link_2_text and settings.footer_about_link_2_url %}
                            <a href="{{ settings.footer_about_link_2_url | setting_url }}" class="text-fg hover:opacity-70 transition-opacity text-sm font-medium">
                                {{ settings.footer_about_link_2_text }}
                            </a>
                        {% endif %}
                        {% if settings.footer_about_link_3_text and settings.footer_about_link_3_url %}
                            <a href="{{ settings.footer_about_link_3_url | setting_url }}" class="text-fg hover:opacity-70 transition-opacity text-sm font-medium">
                                {{ settings.footer_about_link_3_text }}
                            </a>
                        {% endif %}
                        {% if settings.footer_about_link_4_text and settings.footer_about_link_4_url %}
                            <a href="{{ settings.footer_about_link_4_url | setting_url }}" class="text-fg hover:opacity-70 transition-opacity text-sm font-medium">
                                {{ settings.footer_about_link_4_text }}
                            </a>
                        {% endif %}
                        {% if settings.footer_about_link_5_text and settings.footer_about_link_5_url %}
                            <a href="{{ settings.footer_about_link_5_url | setting_url }}" class="text-fg hover:opacity-70 transition-opacity text-sm font-medium">
                                {{ settings.footer_about_link_5_text }}
                            </a>
                        {% endif %}
                    </nav>
                </div>

            </div>
        </div>

        {# Logo de Apoio (Opcional): SVG > Imagem > Nada #}
        {% if settings.logo_support_svg %}
            <div class="w-full flex justify-center py-4 footer-logo-svg max-h-16">
                {{ settings.logo_support_svg | raw }}
            </div>
        {% elseif "logo_support.png" | has_custom_image %}
            <div class="w-full flex justify-center py-4">
                <img src="{{ 'images/empty-placeholder.png' | static_url }}"
                     data-src="{{ "logo_support.png" | static_url }}"
                     class="lazyload max-h-16"
                     alt="{{ store.name }} - Logo de Apoio" />
            </div>
        {% endif %}

        {# Meios de Pagamento e Envio #}
        {% if has_shipping_payment_logos %}
            <div class="w-full flex flex-col md:flex-row justify-center items-center gap-4 py-4">
                {% if has_payment_logos %}
                    <div class="flex justify-center">
                        {% include "snipplets/logos-icons.tpl" with {'payments': true} %}
                    </div>
                {% endif %}
                {% if has_shipping_logos %}
                    <div class="flex justify-center">
                        {% include "snipplets/logos-icons.tpl" with {'shipping': true} %}
                    </div>
                {% endif %}
            </div>
        {% endif %}

        {# AFIP - EBIT - Custom Seal #}
        {% if store.afip or ebit or settings.custom_seal_code or ("seal_img.jpg" | has_custom_image) %}
            <div class="w-full flex flex-wrap justify-center items-center gap-4 py-4">
                {% if store.afip %}
                    <div class="footer-logo afip seal-afip">
                        {{ store.afip | raw }}
                    </div>
                {% endif %}
                {% if ebit %}
                    <div class="footer-logo ebit seal-ebit">
                        {{ ebit }}
                    </div>
                {% endif %}
                {% if "seal_img.jpg" | has_custom_image %}
                    <div class="footer-logo custom-seal">
                        {% if settings.seal_url != '' %}
                            <a href="{{ settings.seal_url | setting_url }}" target="_blank">
                        {% endif %}
                            <img src="{{ 'images/empty-placeholder.png' | static_url }}"
                                 data-src="{{ "seal_img.jpg" | static_url }}"
                                 class="custom-seal-img lazyload max-h-12"
                                 alt="{{ 'Sello de' | translate }} {{ store.name }}"/>
                        {% if settings.seal_url != '' %}
                            </a>
                        {% endif %}
                    </div>
                {% endif %}
                {% if settings.custom_seal_code %}
                    <div class="custom-seal custom-seal-code">
                        {{ settings.custom_seal_code | raw }}
                    </div>
                {% endif %}
            </div>
        {% endif %}

        {# Copyright - Centralizado #}
        <div class="w-full flex flex-col items-center gap-4 pt-2">
            <div class="text-fg text-xs font-medium text-center">
                {{ "Copyright {1} - {2}. Todos los derechos reservados." | translate( (store.business_name ? store.business_name : store.name) ~ (store.business_id ? ' - ' ~ store.business_id : ''), "now" | date('Y') ) }}
                {{ component('claim-info', {
                    container_classes: "mt-2",
                    divider_classes: "mx-1 hidden md:inline-block",
                    text_classes: {text_consumer_defense: 'inline-block mb-1'},
                    link_classes: {
                        link_consumer_defense: "font-bold",
                        link_order_cancellation: "font-bold md:inline-block block mt-3 md:mt-0 mb-2",
                    },
                }) }}
            </div>
        </div>

        {# Powered By Nuvemshop (OBRIGATORIO) - Canto inferior #}
        <div class="w-full flex justify-end pt-2">
            <div class="text-fg text-sm powered-by-wrapper">
                {#
                La leyenda que aparece debajo de esta linea de codigo debe mantenerse
                con las mismas palabras y con su apropiado link a Tienda Nube;
                como especifican nuestros terminos de uso: http://www.tiendanube.com/terminos-de-uso .
                Os creditos que aparece debaixo da linha de codigo devera ser mantida com as mesmas
                palavras e com seu link para Nuvem Shop; como especificam nossos Termos de Uso:
                http://www.nuvemshop.com.br/termos-de-uso.
                #}
                {{ new_powered_by_link }}
            </div>
        </div>

    </div>
</footer>
