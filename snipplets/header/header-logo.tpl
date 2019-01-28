<div id="logo" class="logo-img-container {% if not has_logo %}hidden{% endif %}">
    {{ store.logo('medium') | img_tag('', {class: 'logo-img  transition-soft-slow'}) | a_tag(store.url) }}
</div>
<div id="no-logo" class="logo-text-container {% if has_logo %} hidden{% endif %}">
    <a class="logo-text h1" href="{{ store.url }}">{{ store.name }}</a>
</div>