<form class="js-search-container js-search-form" action="{{ store.search_url }}" method="get">
	<div class="form-group m-0">
        <input class="js-search-input form-control search-input" autocomplete="off" type="search" name="q" placeholder="{{ 'Buscar' | translate }}" autofocus/>
        <button type="submit" class="btn search-input-submit" value="">
            <i class="far fa-search"></i>
        </button>
	</div>
</form>
<div class="js-search-suggest search-suggest">
    {# AJAX container for search suggestions #}
</div>
