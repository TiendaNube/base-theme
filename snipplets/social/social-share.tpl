{# Mobile Sharing #}
<div class="social-share text-center">
	<h5 class="my-3">{{ "Compartir" | translate }}</h5>

	{# Whatsapp button #}
	<a class="social-share-button d-inline-block d-md-none" data-network="whatsapp" target="_blank" href="whatsapp://send?text={{ product.social_url }}" title="{{ 'Compartir en WhatsApp' | translate }}" aria-label="{{ 'Compartir en WhatsApp' | translate }}">
	 	{% include "snipplets/svg/whatsapp.tpl" with {svg_custom_class: "icon-inline svg-icon-text"} %}
	</a>

	{# Facebook button #}
	<a class="social-share-button" data-network="facebook" target="_blank" href="https://www.facebook.com/sharer/sharer.php?u={{ product.social_url }}" title="{{ 'Compartir en Facebook' | translate }}" aria-label="{{ 'Compartir en Facebook' | translate }}">
	 	{% include "snipplets/svg/facebook-f.tpl" with {svg_custom_class: "icon-inline svg-icon-text"} %}
	</a>

	{# Twitter button #}
	<a class="social-share-button" data-network="twitter" target="_blank" href="https://twitter.com/share?url={{ product.social_url }}" title="{{ 'Compartir en Twitter' | translate }}" aria-label="{{ 'Compartir en Twitter' | translate }}">
	 	{% include "snipplets/svg/twitter.tpl" with {svg_custom_class: "icon-inline svg-icon-text"} %}
	</a>
	
	{# Pinterest button #}
 	<a class="js-pinterest-share social-share-button" data-network="pinterest" target="_blank" href="#" title="{{ 'Compartir en Pinterest' | translate }}" aria-label="{{ 'Compartir en Pinterest' | translate }}">
		{% include "snipplets/svg/pinterest.tpl" with {svg_custom_class: "icon-inline svg-icon-text"} %}
 	</a>
 	<div class="pinterest-hidden social-share-button" style="display: none;" data-network="pinterest">
        {{product.social_url | pin_it('https:' ~ product.featured_image | product_image_url('large'))}}
    </div>
</div>