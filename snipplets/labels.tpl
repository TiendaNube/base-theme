{% set label_accent_classes = 'label label-accent' %}
{% set label_default_classes = 'label label-default' %}

{{ component(
  'labels', {
    prioritize_promotion_over_offer: true,
    promotion_quantity_long_wording: true,
    promotion_nxm_long_wording: false,
    labels_classes: {
      group: 'js-labels-floating-group',
      promotion: label_accent_classes,
      promotion_primary_text: 'd-block',
      offer: 'js-offer-label ' ~ label_accent_classes,
      shipping: 'label label-secondary',
      no_stock: 'js-stock-label ' ~ label_default_classes,
    },
  })
}}
