{% if store.allows_checkout_styling %}

{#/*============================================================================
checkout.scss.tpl

    -This file contains all the theme styles related to the checkout based on settings defined by user from config/settings.txt
    -Rest of styling can be found in:
        -static/css/style-colors.scss.tpl --> For color and font styles related to config/settings.txt
        -static/css/style-async.scss.tpl --> For non critical styles witch will be loaded asynchronously
        -static/css/style-critical.tpl --> For critical CSS rendered inline before the rest of the site

==============================================================================*/#}

{#/*============================================================================
  Global
==============================================================================*/#}

{# /* // Colors */ #}

$accent-brand-color: {{ settings.primary_color | default('rgb(77, 190, 207)' | raw ) }};
$foreground-color: {{ settings.text_color | default('rgb(102, 102, 102)' | raw ) }};
$background-color: {{ settings.background_color | default('rgb(252, 252, 252)' | raw ) }};

{# /* // Font */ #}

$heading-font: {{ settings.font_headings | default('Muli') | raw }};
$body-font: {{ settings.font_rest | default('Muli') | raw }};

{# /* // Box */ #}
$box-border-color: null;
@if lightness($background-color) > 95% {
  $box-border-color: desaturate(darken($background-color, 15%), 10%);
} @else {
  $box-border-color: desaturate(darken($background-color, 8%), 10%);
}
$box-radius: 0;
$box-background: lighten($background-color, 10%);
$box-shadow: null;
@if lightness($background-color) > 50% {
  $box-shadow: 0px 1px 5px -1px rgba(0, 0, 0, 0.2);
} @else {
  $box-shadow: 0px 1px 5px -1px rgba(0, 0, 0, 0.3);
}

{# /* // Functions */ #}

@function set-background-color($background-color) {
  @if lightness($background-color) > 95% {
    @return lighten($background-color, 10%);
  } @else {
    @return desaturate(lighten($background-color, 7%), 5%);
  }
}

@function set-input-color($background-color, $foreground-color) {
  @if lightness($background-color) > 70% {
    @return desaturate(lighten($foreground-color, 5%), 80%);
  } @else {
    @return desaturate(lighten($background-color, 5%), 80%);
  }
}

{#/*============================================================================
  React
==============================================================================*/#}

{# /* // Box */ #}

$box-background: lighten($background-color, 10%);
$box-text-shadow: null;
@if lightness($foreground-color) > 95% {
  $box-text-shadow: 0 2px 1px rgba(darken($foreground-color, 80%), 0.1);
} @else {
  $box-text-shadow: 0 2px 1px rgba(lighten($foreground-color, 80%), 0.1);
}

$base-red: #c13a3a;

$xs: 0;
$sm: 576px;
$md: 768px;
$lg: 992px;
$xl: 1200px;

body {
  font-family: $body-font;
  color: $foreground-color;
  @if lightness($background-color) < 10% {
    background-color: lighten($background-color, 5%);
  } @else if (lightness($background-color) >= 10% and lightness($background-color) < 95%) {
    background-color: desaturate(lighten($background-color, 3%), 2%);
  } @else {
    background-color: desaturate(lighten($background-color, 1%), 2%);
  }
}
a {
  color: darken($accent-brand-color, 5%);
  &:hover, &:focus {
    color: darken($accent-brand-color, 20%);
    
    svg {
      fill: darken($accent-brand-color, 20%);
    }
  }
  
  svg {
    fill: darken($accent-brand-color, 5%);
  }
}

{# /* // Text */ #}

.title {
  color: $foreground-color;
}

{# /* // Header */ #}

.header { 
  background-color: lighten($background-color, 10%);
  border-color: $accent-brand-color;
}

{# /* // Headbar */ #}

.headbar {
  background: lighten($background-color, 4%);
}

{# /* // Form */ #}

.form-control {
  border-color: $box-border-color;
  @if lightness($background-color) > 70% {
    color: desaturate(lighten($foreground-color, 5%), 80%);
  } @else {
    color: desaturate(lighten($background-color, 5%), 80%);
  }

  &:focus {
    border-color: $accent-brand-color !important;
    outline: none;    
  }
}
.form-options-content {
  color: lighten($foreground-color, 15%);
  border-color: rgba($box-border-color, .6);
}
.form-group-error .form-control {
  border-color: $base-red;

  &:focus {
    border-color: $base-red;
  }
}
.form-group input[type="radio"] + .form-options-content .unchecked {
  fill: darken($background-color, 10%);
}
.form-group input[type="radio"] + .form-options-content .checked {
  fill: $accent-brand-color;
}

.form-group input[type="radio"]:checked + .form-options-content {
  border: 1px solid $accent-brand-color;
  border-color: darken($background-color, 10%);
  
  + .form-options-accordion {
    border-color: darken($background-color, 10%);
  }
  
  .checked {
    fill: $accent-brand-color;
  }
}
.form-group input[type="checkbox"]:checked + .form-options-content .checked {
  fill: $foreground-color;
}
.form-group input[disabled] + .form-options-content {
  border-color: darken($background-color, 10%) !important;
  
  .form-options-label {
    color: $foreground-color !important;
  }
  .checked {
    fill: $foreground-color !important;
  }
}
.form-group input[type="checkbox"] + .form-options-content .unchecked {
  fill: $foreground-color;
}

{# /* // Input */ #}

.input-label {
  @if lightness($background-color) > 50% {
    color: lighten($foreground-color, 8%);
  } @else {
    color: desaturate($background-color, 80%);
  }
}

{# /* // Buttons */ #}

.btn-primary {
  border-radius: 0;
  background: $accent-brand-color;

  &:hover,
  &:focus,
  &:active {
    background: $accent-brand-color;
    opacity: 0.9;
  }
}
.btn-secondary {
  color: $foreground-color;
  background: darken($background-color, 5%);
  border-color: darken($background-color, 12%);

  &:hover,
  &:focus,
  &:active,
  &:active:focus {
    color: $foreground-color;
    background: darken($background-color, 10%);
    border-color: darken($background-color, 20%);

    .btn-icon-right {
      fill: $foreground-color;
    }
  }
  .btn-icon-right {
    fill: $foreground-color;
  }
}
.btn-transparent {
  color: lighten($foreground-color, 15%);

  &:hover {
    color: $accent-brand-color;
    
    .btn-icon-right {
      fill: $accent-brand-color;
    }
  }

  .btn-icon-right {
    fill: lighten($foreground-color, 15%);
  }
}

.btn-link {
  color: $foreground-color;
  text-decoration: none;

  &:hover {
    color: $accent-brand-color;

    svg {
      fill: $accent-brand-color;
    }
  }
}

.btn-picker {
  border-color: $box-border-color;
  border-radius: $box-radius;
}

.login-info {
  margin: 5px 0 0;
  font-size: 12px;
  text-align: left;
}

{# /* // Breadcrumb */ #}

.breadcrumb li .breadcrumb-step {
  @if lightness($background-color) > 50% {
    background: darken($background-color, 5%);
  } @else {
    background: $background-color;
  }
  color: rgba($foreground-color, .6);

  &.active {
    background-color: $accent-brand-color;
    @if lightness($accent-brand-color) < 70% {
      color: #fff;
    } @else {
      color: $background-color;  
    }

    &:before {
      border-color: transparent transparent transparent lighten($accent-brand-color, 20%);
    }

    &:after {
      border-color: transparent transparent transparent $accent-brand-color;
    }
  }

  &.visited {
    background: lighten($accent-brand-color, 20%);
  }
}

{# /* // Accordion */ #}

.accordion {
  color: $foreground-color;
  background-color: $background-color;
  border-radius: $box-radius;
  border-color: rgba($box-border-color, 0.5);
}

.accordion-section-header-icon {
  fill: $foreground-color;
}

.accordion-rotate-icon {
  fill: $foreground-color;
}

{# /* // Summary */ #}

.mobile-discount-coupon_btn {
  border-radius: $box-radius;
  border-color: darken($background-color, 10%);
  color: lighten($foreground-color, 20%);
  
  .icon {
    color: lighten($foreground-color, 20%);
  }
}

.summary-details {
  background: lighten($background-color, 15%);
}
.summary-container {
  background: lighten($background-color, 4%);
}
.summary-total {
  color: $foreground-color;
  background: $background-color;
}
.summary-img-thumb {
  border-radius: $box-radius;
}
.summary-arrow-rounded {
  background: $accent-brand-color;
}
.summary-arrow-icon {
  fill: $foreground-color;
}
.summary-title {
  color: darken($accent-brand-color, 10%);
}

{# /* // Radio */ #}

.radio-group.radio-group-accordion {
  border-color: $box-border-color;

  .radio {
    border-color: lighten($box-border-color, 2%);
  }
}

.radio input:checked + .selector:before {
  background-image: radial-gradient(circle, $foreground-color 0%, $foreground-color 40%, transparent 50%, transparent 100%);
  border-color: $foreground-color;
}
.radio input:disabled:checked + .selector:before {
  background-image: radial-gradient(circle, rgba(0, 0, 0, 0.5) 0%, rgba(0, 0, 0, 0.5) 50%, transparent 50%, transparent 100%);
}

.radio .selector:before {
  border-color: rgba($foreground-color, 0.5);
}

.radio-content {
  border-color: $foreground-color;
  @if lightness($background-color) > 50% {
    background: darken($background-color, 2.5%);
  } @else {
    background: darken($background-color, 1.7%);
  }
}
.radio.active .payment-item-discount {
  color: $background-color;
}
.shipping-option {
  border-radius: $box-radius;
  border-color: rgba($box-border-color, 0.7);

  &.active {
    @if lightness($background-color) > 20% {
      border-color: $accent-brand-color;
    } @else {
      border-color: darken(rgba($background-color, 0.7), 10%);
      background: $background-color;
    }
  }
}

{# /* // Panel */ #}

.panel {
  color: lighten($foreground-color, 8%);
  box-shadow: $box-shadow;
  border-radius: $box-radius;
  background-color: set-background-color($background-color);
}
.panel-header {
  color: $foreground-color;
  text-shadow: none;
  border-color: rgba($box-border-color, 0.7);
  font-weight: bold;
}
.panel-header-sticky {
  background-color: set-background-color($background-color);
}
.panel-footer {
  border-bottom-right-radius: $box-radius;
  border-bottom-left-radius: $box-radius;
  background: darken($background-color, 2%);
  &-wa {
    border-color: darken($background-color, 5%);
  }
}
.panel-footer-form {
  input {
    border-color: $foreground-color;
  }
  .input-group-addon {
    background: $background-color;
    border-color: $foreground-color;
  }
  .disabled {
    background: darken($background-color, 15%) !important;
  }
}

{# /* // Table */ #}

.table, 
.table-footer {
  color: desaturate(lighten($foreground-color, 5%), 80%);
  border-color: rgba($foreground-color, 0.09);
}

.table-subtotal {
  border-color: rgba($accent-brand-color, .9);
}

.table .table-discount-coupon, 
.table .table-discount-promotion {
  border-color: rgba($foreground-color, 0.09);
  color: $accent-brand-color;
}

{# /* // Shipping Options */ #}

.shipping-options {
  color: lighten($foreground-color, 7%);
}

.shipping-method-item-desc,
.shipping-method-item-name {
  color: desaturate(lighten($foreground-color, 10%), 80%)
}

.shipping-method-item-price {
  color: $accent-brand-color;
}

{# /* // Discount Coupon */ #}

.box-discount-coupon button {
  @if lightness($foreground-color) < 90% {
    color: lighten($foreground-color, 80%);
  } @else {
    color: $foreground-color;
  }
  background: $accent-brand-color;

  &:hover {
    background: lighten($accent-brand-color, 15%) radial-gradient(circle,transparent 1%, lighten($accent-brand-color, 15%) 1%) center/15000%;
  }
}
.box-discount-coupon-applied {
  background-color: rgba(darken($background-color, 5%), 0.5);
  border-radius: $box-radius;
  color: $accent-brand-color;

  .coupon-icon {
    fill: $accent-brand-color;
  }
}

{# /* // Order Status */ #}

.orderstatus {
  border: 1px solid rgba($foreground-color, .1); 
}

{# /* // Destination */ #}

.destination {
  border-color: rgba($foreground-color, .1);
  &-icon svg {
    fill: $accent-brand-color;
  }
}

{# /* // User Detail */ #}

.user-detail-icon svg {
  fill: $accent-brand-color;
}

{# /* // Bookmark */ #}

.bookmark-icon {
  fill: $accent-brand-color;
  color: $accent-brand-color;
}

{# /* // Delivery Address */ #}

.delivery-address {
  border-color: rgba($box-border-color, 0.5);
  
  &-icon svg {
    fill: rgba($foreground-color, 0.6);
  }
}

{# /* // History */ #}

.history-item-done .history-item-title {
  color: $foreground-color;
}
.history-item-failure .history-item-title {
  color: $base-red;
}
.history-item-progress-icon svg {
  @if lightness($background-color) > 50% {
    fill: darken($background-color, 10%);  
  } @else {
    fill: $background-color;
  }
}
.history-item-progress-icon:after {
  @if lightness($background-color) > 50% {
    fill: darken($background-color, 10%);
    border-color: darken($background-color, 10%);
  } @else {
    fill: $background-color;
    border-color: $background-color;
  }
}
.history-item-progress-icon-failure svg {
  fill: $base-red;
}
.history-item-progress-icon-success svg {
  fill: $accent-brand-color;
}
.history-item-progress-icon-success:after {
  border-color: $accent-brand-color;
}

{# /* // History Canceled */ #}

.history-canceled {
  border-top-right-radius: $box-radius;
  border-top-left-radius: $box-radius;
  
  &-round {
    border-bottom-right-radius: $box-radius;
    border-bottom-left-radius: $box-radius;
  }
}
.history-canceled-header {
  border-color: rgba($box-border-color, 0.7);
  border-top-left-radius: $box-radius;
  border-top-right-radius: $box-radius;
}
.history-canceled-icon svg {
  fill: darken($background-color, 45%);
}

{# /* // Offline Payment */ #}

.ticket-coupon {
  background: darken($background-color, 4%);
  border-color: $box-border-color;
}

{# /* // Status */ #}

.status {
  border: 1px solid rgba($foreground-color, .1); 
  padding: 25px 0;
  &-icon svg {
    fill: $accent-brand-color;
  }
}

{# /* // Tracking */ #}

.tracking-item-time {
  color: $foreground-color;
}

{# /* // Support */ #}

.support {
  border-color: rgba($box-border-color, .6);
  background: lighten($background-color, 5%);
  
  &-left svg {
    fill: $foreground-color;
  }
}

{# /* // WhatsApp Opt-in */ #}

.whatsapp-form input, 
.whatsapp-form .input-group-addon {
  border-color: $accent-brand-color;
}

{# /* // Helpers */ #}

.border-top {
  border-color: rgba($box-border-color, .4);
}

{# /* // Errors */ #}

.general-error {
  background: $base-red;
  border-color: lighten($base-red, 10%);
}

{# /* // Badge */ #}

.badge {
  border-color: $box-border-color;
}

{# /* // Payment */ #}

.payment-item-discount {
  color: $accent-brand-color;
}

.payment-option {
  border-radius: $box-radius;
  color: $foreground-color;
  background-color: $background-color;
  border-color: rgba($box-border-color, 0.5);
}

.radio-content.payment-option-content {
  background: darken($background-color, 2%);
  border: 1px solid rgba($box-border-color, 0.5);
  border-top: 0;
  border-bottom-right-radius: $box-radius;
  border-bottom-left-radius: $box-radius;
}

{# /* // Overlay */ #}

.overlay {
  background: rgba(darken($background-color, 10%), 0.6);
}
.overlay-title {
  color: rgba($foreground-color, .7);
}

{# /* // List Picker */ #}

.list-picker .unchecked {
  fill: $foreground-color;
}
.list-picker li {
  border-color: $box-border-color;
  background: lighten($background-color, 10%);

  &.active {
    background: $background-color;
    color: $accent-brand-color;

    .checked {
      fill: $accent-brand-color;
    }
  }
}

.list-picker-content {
  background: lighten($background-color, 10%);
  border-color: $box-border-color;
}

{# /* // Loading */ #}

.loading {
  background: rgba(darken($background-color, 2%), 0.5);
  color: $accent-brand-color;
}
.loading-spinner {
  color: $accent-brand-color;
}

{# /* // Spinner */ #}

.round-spinner {
  border-color: $accent-brand-color;
  border-left-color: darken($accent-brand-color, 5%);
  
  &:after {
    border-color: $accent-brand-color;
    border-left-color: darken($accent-brand-color, 5%);
  }
}

.spinner > .spinner-elem {
  background: $accent-brand-color;
}

.spinner-inverted > .spinner-elem {
  background: $background-color;
}

{# /* // Sign Up */ #}

.signup {
  border: 1px solid rgba($foreground-color, .1); 
  padding: 25px 0;
  &-icon svg {
    fill: $accent-brand-color;
  }
}

{# /* // Modal */ #}

.modal-dialog {
  background: $background-color;
}

{# /* // List */ #}

.list-group-item {
  border-color: rgba($foreground-color, .1);
}

{# /* // Announcement */ #}

.announcement {
  color: darken($accent-brand-color, 10%);

  &-bg {
    background: $accent-brand-color;
    box-shadow: 0px 3px 5px -1px rgba(darken($accent-brand-color, 20%), 0.35);
    border-radius: $box-radius;
  }

  &-close {
    color: $accent-brand-color;
  }
}

{# /* // Alert */ #}

.alert-info {
  background-color: rgba($accent-brand-color, .15);
  border-color: rgba($accent-brand-color, .2);
  color: desaturate(darken($accent-brand-color, 10%), 30%);

  .alert-icon {
    fill: desaturate(darken($accent-brand-color, 10%), 20%);
  }
}

{# /* // Chip */ #}

.chip {
  background-color: rgba($accent-brand-color, .15);
  color: desaturate(darken($accent-brand-color, 10%), 30%);
  border-radius: 0;
}

{# /* // Tooltip */ #}

.tooltip-icon {
  fill: $foreground-color;
}

{# /* // Review Block Detailed  */ #}

.price--display__free {
  color: $accent-brand-color;
}

.review-block-detailed-item {
  border-bottom: 1px solid rgba($foreground-color, .15);
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
  &:last-child{
    border-radius: 0 0 $box-radius $box-radius;
  }
}

.review-block-detailed {
  border: 0;
  box-shadow: $box-shadow;
  border-radius: $box-radius;
  background-color: $background-color;
  border-color: rgba($box-border-color, 0.5);
}

{# /* // Tabs */ #}

.tabs-wrapper {
  background: $background-color;
  border-bottom-color: darken($background-color, 10%);
}

.tab-item.active {
  color: $accent-brand-color;
  font-weight: bold;
}

.tab-indicator {
  background-color: $accent-brand-color;
}

{#/*============================================================================
  #Media queries
==============================================================================*/ #}

{# /* // Max width 576px */ #}

@media (max-width: $sm) {

  .summary .panel {
    border: 0;
  }

  .orderstatus-footer {
    background: $background-color;
  }

  .support-left {
    border-color: darken($background-color, 5%);
  }

}

{# /* // Min width 768px */ #}

@media (min-width: $md) {

  .status,
  .signup {
    padding: 40px 0;
  }

  .support {
    background: none;
  }

}

{# /* // Max width 0px */ #}

@media (max-width: $xs) {

  .modal-xs {
    background: $background-color;
  }

}

{% endif %}
