<div class="col-4">
	<div class="instafeed-link">
		<div class="instafeed-img">
			{% set type_value = help_item_1 ? 'like_icon' : 'instagram_icon' %}
			{{ component('placeholders/instagram-post-placeholder',{type: type_value})}}
		</div>
	</div>
</div>