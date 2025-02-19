<section class="category-header mt-4 section-margin">
	<div class="container">
		<div class="row">
			<div class="col text-center">
				{% embed "snipplets/page-header.tpl" with { breadcrumbs: false } %}
					{% block page_header_text %}{{ category.name }}{% endblock page_header_text %}
				{% endembed %}
			</div>
		</div>
	</div>
</section>
<section class="category-body">
	<div class="container">
		<div class="row">
			{% include 'snipplets/defaults/help_item.tpl' with {'help_item_1': true} %}
			{% include 'snipplets/defaults/help_item.tpl' with {'help_item_2': true} %}
			{% include 'snipplets/defaults/help_item.tpl' with {'help_item_3': true} %}
			{% include 'snipplets/defaults/help_item.tpl' with {'help_item_4': true} %}
			{% include 'snipplets/defaults/help_item.tpl' with {'help_item_5': true} %}
			{% include 'snipplets/defaults/help_item.tpl' with {'help_item_6': true} %}
			{% include 'snipplets/defaults/help_item.tpl' with {'help_item_7': true} %}
			{% include 'snipplets/defaults/help_item.tpl' with {'help_item_8': true} %}
			{% include 'snipplets/defaults/help_item.tpl' with {'help_item_1': true} %}
		</div>
	</div>
</section>