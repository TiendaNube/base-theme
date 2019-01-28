<meta name="twitter:card" content="product">
<meta name="twitter:url" content="{{ product.social_url }}">
<meta name="twitter:image:src" content="{{ ('http:' ~ product.featured_image | product_image_url('huge')) }}">
{% if store.twitter_user %}
    <meta name="twitter:site" content="{{ store.twitter_user }}">
{% endif %}
<meta name="twitter:title" content="{{ product.name }}">
<meta name="twitter:data1" content="{{ product.display_price ? product.price | money_long : 'Consultar' | translate }}">
<meta name="twitter:label1" content="{{ 'Precio' | translate | upper }}">
<meta name="twitter:data2" content="{{ product.stock_control ? (product.stock > 0 ? product.stock : 'No' | translate) : 'Si' | translate }}">
<meta name="twitter:label2" content="{{ 'Stock' | translate | upper }}">