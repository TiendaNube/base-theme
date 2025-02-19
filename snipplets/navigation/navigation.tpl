<div class="utilities-container">
	<div class="utilities-item">
		<a href="#" class="js-modal-open utilities-link" data-toggle="#nav-hamburger" aria-label="{{ 'Menú' | translate }}" data-component="menu-button">
			{% include "snipplets/svg/bars.tpl" with {svg_custom_class: "icon-inline icon-w-14 svg-icon-text"} %}
		</a>
	</div>
	{% if languages | length > 1 and settings.languages_header %}
		<span class="utilities-item nav-dropdown position-relative">
			{% include "snipplets/svg/globe.tpl" with {svg_custom_class: "icon-inline icon-w-16 svg-icon-text"} %}
			<div class="nav-dropdown-content desktop-dropdown-small position-absolute">
				{% include "snipplets/navigation/navigation-lang.tpl" with { header: true } %}
			</div>
		</span>
	{% endif %}
</div>
	