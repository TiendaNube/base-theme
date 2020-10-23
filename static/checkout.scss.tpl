{% if store.allows_checkout_styling %}

/*============================================================================
checkout.scss.tpl

    -This file contains all the theme styles related to the checkout based on settings defined by user from config/settings.txt
    -Rest of styling can be found in:
        -static/css/style-colors.scss.tpl --> For color and font styles related to config/settings.txt
        -static/css/style-async.scss.tpl --> For non critical styles witch will be loaded asynchronously
        -static/css/style-critical.tpl --> For critical CSS rendered inline before the rest of the site

==============================================================================*/

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

{% if not store.is_react_checkout_eligible %}

{#/*============================================================================
  New-checkout
==============================================================================*/#}

body {
  font-family: $body-font;
  font-weight: 100;
  background-color: $background-color;
}
a {
  color: darken($accent-brand-color, 5%);
  &:hover, &:focus {
    color: darken($accent-brand-color, 20%);
  }
}
strong { 
  font-weight: 400; 
}
.main-container {
  background-color: $background-color;
}
.header { 
  background-color: lighten($background-color, 10%);
  border-bottom: 2px solid $accent-brand-color;
}
.form-box {
  border-radius: $box-radius;
  border: none;
  padding: 10px 20px 20px 20px;
  background: $box-background;
  border: 1px solid $box-border-color;
}
.form-box h1 {
  font-family: $heading-font;
  color: $foreground-color;
  text-shadow: none;
  border-bottom: 1px solid darken($background-color, 10%);
  font-weight: bold;
}
.form-control {
  background: lighten($accent-brand-color, 100%);
}
.form-control:focus, select:focus, textarea:focus {
  border-color: $accent-brand-color !important;
  outline: none;
}
.input-group-addon-focus {
  border-color: $accent-brand-color !important;
}
.whatsapp-content .whatsapp-form {
  input, .input-group-addon {
    border-color: $accent-brand-color;    
  }
}

input[type=submit], 
button[type=submit], 
.btn-checkout {
  font-family: $heading-font;
  text-transform: uppercase;
  border-radius: 0;
  background-color: $accent-brand-color;
}
.login-btn a,
.login-btn a:hover,
.btn-link,
.btn-link:hover {
  color: $accent-brand-color;
}


input[type=submit]:hover, 
input[type=submit]:focus, 
input[type=submit]:active, 
input[type=submit]:active:hover, 
button[type=submit]:hover, 
button[type=submit]:focus, 
button[type=submit]:active, 
button[type=submit]:active:hover, 
.btn-checkout:hover,
.btn-checkout:focus,
.btn-checkout:active,
.ticket-container .ticket-txt a:hover, 
.ladda-button:active, 
.ladda-button[disabled], 
.ladda-button[disabled]:hover {
  background-color: $accent-brand-color;
  text-decoration: none;
  opacity: 0.9;
}

#breadcrumb{
  list-style:none;
  display: inline-block;
  padding: 0;
  margin: 0 0 10px 0;
  
  li{
    float:left;
    a{
      color:lighten($foreground-color, 100%);
      display:block;
      background: $accent-brand-color;
      text-decoration: none;
      position:relative;
      height: 30px;
      line-height:30px;
      padding: 0 10px 0 5px;
      text-align: center;
      margin-right: 23px;
    }
    &:first-child{
      a{
        padding-left:15px;
        border-radius: 0;
        &:before{
          border:none;
         }
      }
      a.inactive:before{
        border-width: 0;
      }
      a.inactive:after{
        border-left-color: rgba($accent-brand-color, 0.3);
      }
    }

    &:last-child{
      a{
        padding-right:15px;
        border-radius: 0;
        &:after{
          border:none;
        }
      }
    }
    
    a{   
      &:before,
      &:after{
        content: "";
        position:absolute;
        top: 0;
        border:0 solid $accent-brand-color;
        border-width:15px 10px;
        width: 0;
        height: 0;
      }
      &:before{
        left:-20px;
        border-left-color:transparent;
      }
      &:after{
        left:100%;
        border-color:transparent;
        border-left-color:$accent-brand-color;
      }
      &:hover{
        opacity: 0.8;
        
        &:before{
          border-left-color:transparent;
         }
      }
      &:active{
        background-color: $accent-brand-color;
        
        &:before{
          border-color:$accent-brand-color;
          border-left-color:transparent;
         }
        &:after{
          border-left-color:$accent-brand-color;
        }
      }
    }
    a.previous {
        opacity: 0.6;
      &:hover{
        opacity: 1;
      }
    }
    a.inactive {
      background: rgba($accent-brand-color, 0.3);
      cursor: default;
      color: darken($accent-brand-color, 40%);
      &:before {
        content: "";
        position:absolute;
        top: 0;
        border:0 solid rgba($accent-brand-color, 0.3);
        border-width:15px 10px;
        width: 0;
        height: 0;
      }
      &:hover{
        opacity: 1;
      }
      &:before{
        left:-20px;
        border-left-color:transparent;
      }
      &:active{
        background-color: rgba($accent-brand-color, 0.3);
        
        &:before{
          border-color:rgba($accent-brand-color, 0.3);
          border-left-color:transparent;
         }
      }
    }
  }
}

div.help {
  background-color: $background-color;
  color: $foreground-color;
  border-radius: 0;
  a {
    color: $foreground-color;
  }
  &-warning {
    background-color: #DB3E3E;
    color: #fff;
  }
}

.form-divider {
  .form-divider-title {
    color: rgba($accent-brand-color, 0.3);
    background-color: $background-color;
  }
  hr {
    border-top-color: rgba($accent-brand-color, 0.3);
  }
}

.custom-checkbox > .box > .tick {
  border-bottom-color: $accent-brand-color;
  border-left-color: $accent-brand-color;
}
.customOption input:checked + label {
  border-color: $accent-brand-color;
}
.customOption input:checked + label span.custom-radio {
  background: $accent-brand-color;
}
.customOption.pickup label {
  border-color: rgba($accent-brand-color, 0.3);
}
.customOption input:checked + label .description .name {
  color: $accent-brand-color;
}

.thankyou .success-msg a {
  color: $accent-brand-color;
}
.thankyou .success-msg .title h1, .thankyou .success-msg h3, .thankyou .form-box .create-account span.label-email {
  font-family: $heading-font;
}

h5 {
  color: $foreground-color;
}
.form-control, select {
  border-color: rgba($accent-brand-color, 0.3);
  border-radius: 0;
}
.table::-webkit-scrollbar-thumb {
  background-color: $accent-brand-color;
}
.table-striped > tbody > tr:first-child {
  border-top: none;
}
.table-striped > tbody > tr:nth-of-type(odd) {
  border-top: 1px dotted rgba($accent-brand-color, 0.03);
  background: rgba($foreground-color, 0.02);
}
.table-striped > tbody > tr:nth-of-type(even) {
  border-top: 1px dotted rgba($accent-brand-color, 0.1);
  background: rgba($foreground-color, 0.01);
}
.header .header-container {
  padding-left: 0;
  padding-right: 8px;
}
.header .header-container .store-name {
  text-align: left;
  &.store-link {
    color: $foreground-color;
    text-shadow: 0 2px 1px $background-color;
  }
}
.header .header-container .store-name img {
  padding-top: 5px;
}
.summary-container .summary {
  background-color: $box-background;
  .show-cart-button {
    background: $box-background;
  }
}
.summary-container .summary #total-box .table {
  border-radius: 0;
}
.summary-container .summary .table td {
  color: $foreground-color;
}
.summary-container .summary #total-box .table.total-table {
  border-radius: 0;
}
.summary-container .summary #total-box .table.total-table tr td {
  color: $accent-brand-color;
}
.summary-container .summary .slidingDiv {
  background-color: lighten($background-color, 10%);
  border-radius: $box-radius;
  border: 1px solid darken($background-color, 10%);
  @media (max-width: 768px) {
      border: none;
  }
  .arrow-down {
    border-top: 10px solid $box-border-color;
  }
}
.summary-container .summary #total-box .table td img {
  border-radius: 0;
} 
.summary-container .summary #total-box .table tbody.total {
  border-color: $accent-brand-color;
}
.summary-container .summary #total-box .table .success {
  border-color: $accent-brand-color;
}
.summary-container .summary #total-box .table tbody.total tr { 
  background: $background-color;
}
.summary-container .summary .show-cart-button .fa-circle, .summary-container .summary .show-cart-button .show-details {
  color: $accent-brand-color;
}
.summary-container .summary .show-cart-button span.total-cart {
  margin-top: 2px;
  background-color: $accent-brand-color;
}
.summary-container .summary #coupon-form .coupon-field button {
  background: $accent-brand-color;
  border: 1px solid $accent-brand-color;
}
.summary-container .summary #total-box .table tbody.total tr.discount {
  background-color: rgba($accent-brand-color, 0.1);
  color: $accent-brand-color;
}
.summary-container .summary #total-box .table .success td {
  color: $foreground-color;
  background-color: $accent-brand-color;
}
.summary-container .summary #total-box .table.total-table tr.success td {
  color: lighten($background-color, 10%);
  font-weight: bold;
}

.error-msg-single, .bg-danger, .bg-success, label.same-address, .form-box textarea, div.customOption label, .customOption input:checked + label {
  border-radius: 0;
}
.text-muted {
  color: rgba($foreground-color, 0.6);
}
.text-primary {
  color: $accent-brand-color;
}
.seals {
  border-color: rgba($accent-brand-color, 0.3);
}
.ticket-container .ticket-txt a, .custom-container .ticket-txt a {
  font-family: $heading-font;
  text-transform: uppercase;
  border-radius: 0;
  background-color: $accent-brand-color;
}

.card-info-container #cvv-help, .card-info-container div.cvv-helper {
  background-color: $accent-brand-color;
}
.card-info-container #cvv-help.pressed {
  background-color: rgba($accent-brand-color, 0.6);
}
.card-info-container div.cvv-helper .help-container p {
  font-family: $heading-font;
  color: $accent-brand-color;
}
.card-info-container div.cvv-helper .arrow-up {
  border-bottom-color: $accent-brand-color;
}
.ac-container {
  border-color: rgba($accent-brand-color, 0.1);
}
.ac-container label.accordion {
  font-family: $heading-font;
  color: $foreground-color;
  text-shadow: none;
  border-bottom-color: rgba($accent-brand-color, 0.1);
  background: rgba($background-color, 0.3);
}
.ac-container label.accordion:hover {
  background: rgba($background-color, 0.02);
}
.ac-container input.accordion:checked + label span {
  background: $accent-brand-color;
}
.ac-container, .summary-container .summary .show-cart-button span.total-cart {
  font-family: $heading-font;
  border-radius: 0;
}
.ac-container article {
  box-shadow: 0px 3px 0px 0px $accent-brand-color inset;
  background-color: rgba($background-color, 0.8);
}
.ac-container div:first-child label.accordion {
  border-radius: 0;
}
.ac-container div:last-child label.accordion {
  border-radius: 0;
}
.ac-container input.accordion:checked + label.accordion, 
.ac-container input.accordion:checked + label.accordion:hover
 {
  background-color: $accent-brand-color;
  text-shadow: none;
  color: lighten($background-color, 10%);
}
.ac-container input.accordion:checked ~ article {
  background: rgba($foreground-color, 0.02);
  box-shadow: none;
}
.ac-container div:last-child input.accordion:checked + label.accordion {
    border-radius: 0;
    border-bottom: 1px solid rgba($accent-brand-color, 0.1);
}
.ac-container label.accordion p {
  margin: 6px 0 5px 0;
}
.ac-container label.accordion p.tag-discount {
  color: lighten($background-color, 10%);
  background-color: $accent-brand-color;
  border-radius: 0;
}
.ac-container input.accordion:checked + label.accordion p.tag-discount {
  color: $accent-brand-color;
  background-color: lighten($background-color, 10%);
}
div.customOption p.name { 
  font-weight: 400; 
}

.thankyou .form-box {
  overflow: hidden;
}
.thankyou .form-box .create-account {
  padding: 10px 20px 20px 20px;
  color: lighten($background-color, 70%);
  background: rgba($foreground-color, 0.05);
  border-radius: 0;
  border: none;
}
.thankyou .form-box p {
  padding: 25px 0;
  margin-bottom: 20px;
  border-bottom: 1px solid $background-color;
}
.thankyou .form-box .create-account p {
  padding: 0;
  margin: 0;
  color: $foreground-color;
  border-bottom: none;
  font-weight: 100;
}
.create-account .label-email {
  font-weight: 400;
  color: $foreground-color;
  letter-spacing: 1px;
}
.thankyou .form-box .ticket-container {
  margin: 0 0 10px 0;
}
.form-password .btn-submit {
  float: none;
  margin-top: 4px;
  display: inline-block;
}
ul.list-unstyled {
  width: 145px;
  float: right;
}
.safe-box {
  overflow: hidden;
}
.safe-box img {
  max-width: 36px;
}
.safe-box p {
  width: 105px;
  text-align: left;
  float: right;
  padding: 2px 10px 0 4px;
  margin: 0;
  font-family: "Open sans", sans-serif;
  font-size: 11px;
}
.coupon-show-link {
  border-radius: 0;
  color: $accent-brand-color;
}
.submit-coupon-btn i.fa-stack-2x {
  color: $accent-brand-color;
}
.submit-coupon-btn:active i.fa-stack-2x {
  color: darken($accent-brand-color, 10%);
}
.coupon-success {
  background: $accent-brand-color;
  border-radius: 0;
  font-size: 14px;
}
.coupon-success .arrow-up {
  border-bottom-color: $accent-brand-color;
}

@media (min-width: 768px) {
  .thankyou .form-box .ticket-txt p {
    text-align: left;
  }
  input[type=submit], button[type=submit] {
    width: auto;
    padding: 11px 10px;
    font-size: 20px;
  }
}
@media (min-width: 992px) {
  .thankyou .success-msg {
      width: 66%;
  }
}

{# order status page #}

.orderstatus {
  background: $background-color;
  color: $foreground-color;
  .custom-container, 
  .ticket-center-container {
    background: $box-background;
    border-radius: $box-radius;
    border: 1px solid $box-border-color;
    box-shadow: $box-shadow;
  }
}
.orderstatus-footer {
  background: darken($background-color, 3%);
  border-bottom-right-radius: $box-radius;
  border-bottom-left-radius: $box-radius;
}
.state-wrap {
  border: 1px solid $box-border-color;
  border-radius: $box-radius;
  background: $box-background;
  box-shadow: $box-shadow;
  h2 {
    font-family: $foreground-color;
    text-shadow: 0 2px 1px $background-color;
  }
}
.state-address {
  border-color: darken($background-color, 3%);
}
.state {
  border-top-right-radius: $box-radius;
  border-top-left-radius: $box-radius;
  &-round {
    border-bottom-right-radius: $box-radius;
    border-bottom-left-radius: $box-radius;
  }
}
.state-header {
  height: 90px;
  border-color: darken($background-color, 3%);
  border-top-left-radius: $box-radius;
  border-top-right-radius: $box-radius;
}
.tracking-item {
  &-title {
    color: $foreground-color;
  }
  &-date {
    color: desaturate($foreground-color, 20%);
  }
  &-done {
    .tracking-item {
      &-title {
        color: $accent-brand-color;
      }
    }
  }
}
.state-icon {
  svg {
    fill: $foreground-color;
  }
}
.tracking-event-content {
  color: $foreground-color;
}
.tracking-event-time {
  color: $foreground-color;
  opacity: .6;
}
.tracking-progress-icon {
  svg {
    fill: darken($background-color, 7%);
    color: darken($background-color, 7%);
  }
  &:after {
    border-color: darken($background-color, 7%);
  }
  &-success {
    svg {
      fill: $accent-brand-color;
    }
    &:after {
      border-color: $accent-brand-color;
    }
  }
}
.bookmark-icon {
  fill: $accent-brand-color;
  color: $accent-brand-color;
}
.summary-container-new {
  .summary {
    .slidingDiv {
      background: $box-background;
      box-shadow: $box-shadow;
      @media (min-width: 768px) {
        border-radius: $box-radius;
      }
    }
  }
}
.support {
  border-color: darken($background-color, 4%);
  @media (max-width: 768px) {
    background: $box-background;
  }
}
.support-left {
  @media (max-width: 768px) {
    border-color: darken($background-color, 4%);
  }
}
.detail-icon-circle {
  background: lighten($background-color, 10%);
  
  svg {
    color: $foreground-color;
    fill: $foreground-color;
  }
}
.footer-center {
  background: $box-background;
}

{% else %}


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
.form-group {

  &-error { 

  .form-control {
      border-color: $base-red;

      &:focus {
        border-color: $base-red;
      }
    }
  }
}
.form-group input[type="radio"] + .form-options-content {
  .unchecked {
    fill: darken($background-color, 10%);
  }
  .checked {
    fill: $accent-brand-color;
  }
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
.form-group input[type="checkbox"]:checked + .form-options-content {
  .checked {
    fill: $foreground-color;
  }
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
.form-group input[type="checkbox"] + .form-options-content {
  .unchecked {
    fill: $foreground-color;
  }
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

.breadcrumb {

  li {

    .breadcrumb-step {
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
.summary {
  
  .panel {
    @media (max-width: $sm) {
      border: 0;
    }
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
.summary-arrow {

  &-rounded {
    background: $accent-brand-color;
  }
}
.summary-arrow-icon {
  fill: $foreground-color;
}
.summary-title {
  color: darken($accent-brand-color, 10%);
}

{# /* // Radio */ #}

.radio-group {

  &.radio-group-accordion {
    border-color: $box-border-color;

    .radio {
      border-color: lighten($box-border-color, 2%);
    }
  }
}
.radio {

  input {

    &:checked + .selector:before {
      background-image: radial-gradient(circle, $foreground-color 0%, $foreground-color 40%, transparent 50%, transparent 100%);
      border-color: $foreground-color;
    }
    &:disabled:checked + .selector:before {
      background-image: radial-gradient(circle, rgba(0, 0, 0, 0.5) 0%, rgba(0, 0, 0, 0.5) 50%, transparent 50%, transparent 100%);
    }
  }
  .selector {

    &:before {
      border-color: rgba($foreground-color, 0.5);
    }
  }
}
.radio-content {
  border-color: $foreground-color;
  @if lightness($background-color) > 50% {
    background: darken($background-color, 2.5%);
  } @else {
    background: darken($background-color, 1.7%);
  }
}
.radio.active {
  .payment-item-discount {
    color: $background-color;
  }
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

.table {
  .table-discount-coupon, .table-discount-promotion {
    border-color: rgba($foreground-color, 0.09);
    color: $accent-brand-color;
  }
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

.box-discount-coupon {

  button {
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

.orderstatus-footer {
  @media (max-width: $sm) {
    background: $background-color;
  }
}

{# /* // Destination */ #}

.destination {
  border-color: rgba($foreground-color, .1);
}

.destination-icon {
  svg {
    fill: $accent-brand-color;
  }
}

{# /* // User Detail */ #}

.user-detail-icon {
  svg {
    fill: $accent-brand-color;
  }
}

{# /* // Bookmark */ #}

.bookmark-icon {
  fill: $accent-brand-color;
  color: $accent-brand-color;
}

{# /* // Delivery Address */ #}

.delivery-address {
  border-color: rgba($box-border-color, 0.5);
  
  &-icon {
    svg {
      fill: rgba($foreground-color, 0.6);
    }
  }
}

{# /* // History */ #}

.history-item {

  &-done {
    .history-item {
      &-title {
        color: $foreground-color;
      }
    }
  }
  &-failure {
    .history-item {
      &-title {
        color: $base-red;
      }
    }
  }
}
.history-item-progress-icon {

  svg {
    @if lightness($background-color) > 50% {
      fill: darken($background-color, 10%);  
    } @else {
      fill: $background-color;
    }
  }
  &:after {
    @if lightness($background-color) > 50% {
      fill: darken($background-color, 10%);
      border-color: darken($background-color, 10%);
    } @else {
      fill: $background-color;
      border-color: $background-color;
    }
  }
  &-failure {
    svg {
      fill: $base-red;
    }
  }
  &-success {
    svg {
      fill: $accent-brand-color;
    }
    &:after {
      border-color: $accent-brand-color;
    }
  }
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
.history-canceled-icon {
  svg {
    fill: darken($background-color, 45%);
  }
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
  @media (min-width: $md) {
    padding: 40px 0;
  }
}
.status-icon {
  svg {
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

  @media (min-width: $md) {
    background: none;
  }
  
  &-left {
    @media (max-width: $sm) {
      border-color: darken($background-color, 5%);
    }
    
    svg {
      fill: $foreground-color;
    }
  }
}

{# /* // WhatsApp Opt-in */ #}

.whatsapp-form {
  input, 
  .input-group-addon {
    border-color: $accent-brand-color;
  }
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

.list-picker {

  .unchecked {
    fill: $foreground-color;
  }
  li {
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
  @media (min-width: $md) {
    padding: 40px 0;
  }
}

.signup-icon {
  svg {
    fill: $accent-brand-color;
  }
}

{# /* // Modal */ #}

.modal {
  &-dialog {
    background: $background-color;
  }
}

@media (max-width: $xs) {
  .modal-xs {
    background: $background-color;
  }
}

@media (max-width: $xs) {
  .modal-xs {
    background: $background-color;
  }
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

{# /* // Tooltip */ #}

.tooltip-icon {
  fill: $foreground-color;
}

{# /* // Tabs */ #}

.tabs-wrapper {
  background: $background-color;
  border-bottom-color: darken($background-color, 10%);
}

.tab-item {
  &.active {
    color: $accent-brand-color;
    font-weight: bold;
  }
}

.tab-indicator {
  background-color: $accent-brand-color;
}

{%  endif %}

{%  endif %}