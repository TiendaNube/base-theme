<div class="utilities-container">
	<div class="utilities-item">
		<a href="#" class="js-modal-open js-toggle-search utilities-link" data-toggle="#nav-search">
			{% include "snipplets/svg/search.tpl" %}
		</a>
	</div>
	{% if not store.is_catalog %}    
	<div class="utilities-item">
		<div id="ajax-cart" class="cart-summary">
		    <a href="#" class="js-modal-open js-toggle-cart" data-toggle="#modal-cart">
		    	{% include "snipplets/svg/shopping-bag.tpl" %}
		    	<span class="js-cart-widget-amount cart-widget-amount">{{ "{1}" | translate(cart.items_count ) }}</span>
		    </a>
		</div>
	</div>
	{% endif %}
</div>