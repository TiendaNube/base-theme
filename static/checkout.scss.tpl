{% if store.allows_checkout_styling %}

/*============================================================================
checkout.scss.tpl

    -This file contains all the theme styles related to the checkout based on settings defined by user from config/settings.txt
    -Rest of styling can be found in:
        -static/css/custom-styles.scss.tpl --> For color and font styles related to config/settings.txt
        -static/css/style.scss.tpl --> For the rest of the theme styles

==============================================================================*/



{# You should keep all settings in SASS variables for reuse #}
{# Color Variables #}
$primary-brand-color: {{ settings.primary_color | default('rgb(77, 190, 207)' | raw ) }};
$accent-brand-color: {{ settings.primary_color | default('rgb(77, 190, 207)' | raw ) }};
$foreground-color: {{ settings.texto_color | default('rgb(102, 102, 102)' | raw ) }};
$background-color: {{  settings.fondo_color | default('rgb(252, 252, 252)' | raw ) }};

{# Font Family #}
$heading-font: {{ settings.font_headings | raw }};
$body-font: {{ settings.font_rest | raw}};
$logo-font: {{ settings.font_rest | raw }};

body {
  font-family: $body-font;
  background-color: $background-color;
}
.main-container {
  background-color: $background-color;
}
.header { 
  background-color: lighten($background-color, 10%);
  border-bottom: 2px solid $primary-brand-color;
}
.form-box {
  border-radius: 3px;
  border: none;
  box-shadow: 0 0 5px 0 rgba(0, 0, 0, .1), 0 2px 3px 0 rgba(0, 0, 0, .2);
  padding: 10px 20px 20px 20px;
  background: lighten($background-color, 10%);
}
.form-box h1 {
  margin-bottom: 0;
  font-family: $heading-font;
  color: $foreground-color;
  text-shadow: none;
  text-transform: uppercase;
  border-bottom: none;
}
.form-control {
  background: lighten($primary-brand-color, 100%);
}
.form-control:focus, select:focus, textarea:focus {
  border-color: $primary-brand-color !important;
  outline: none;
}
.input-group-addon-focus {
  border-color: $primary-brand-color !important;
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
  border-radius: 3px;
  background-color: $accent-brand-color;
}
.login-btn a,
.login-btn a:hover,
.btn-link,
.btn-link:hover {
  color: $primary-brand-color;
}


input[type=submit]:hover, 
input[type=submit]:focus, 
input[type=submit]:active, 
button[type=submit]:hover, 
button[type=submit]:focus, 
button[type=submit]:active, 
.btn-checkout:hover,
.btn-checkout:focus,
.btn-checkout:active,
.ticket-container .ticket-txt a:hover {
  background-color: darken($accent-brand-color, 10%);
  border-color: rgba($accent-brand-color, 0.6);
  text-decoration: none;
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
        border-radius: 3px 0 0 3px;
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
        border-radius: 0 3px 3px 0;
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
  border-radius: 3px;
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
    color: rgba($primary-brand-color, 0.3);
    background-color: $background-color;
  }
  hr {
    border-top-color: rgba($primary-brand-color, 0.3);
  }
}

.custom-checkbox > .box > .tick {
  border-bottom-color: $primary-brand-color;
  border-left-color: $primary-brand-color;
}
.customOption input:checked + label {
  border-color: $primary-brand-color;
}
.customOption input:checked + label span.custom-radio {
  background: $primary-brand-color;
}
.customOption.pickup label {
  border-color: rgba($primary-brand-color, 0.3);
}
.customOption input:checked + label .description .name {
  color: $primary-brand-color;
}

.thankyou .success-msg a {
  color: $primary-brand-color;
}
.thankyou .success-msg .title h1, .thankyou .success-msg h3, .thankyou .form-box .create-account span.label-email {
  font-family: $heading-font;
}

h5 {
  color: $foreground-color;
}
.form-control, select {
  border-color: rgba($primary-brand-color, 0.3);
  border-radius: 3px;
}
.table::-webkit-scrollbar-thumb {
  background-color: $primary-brand-color;
}
.table-striped > tbody > tr:first-child {
  border-top: none;
}
.table-striped > tbody > tr:nth-of-type(odd) {
  border-top: 1px dotted rgba($primary-brand-color, 0.03);
  background: rgba($foreground-color, 0.05);
}
.table-striped > tbody > tr:nth-of-type(even) {
  border-top: 1px dotted rgba($primary-brand-color, 0.1);
  background: rgba($foreground-color, 0.01);
}
.header .header-container {
  padding-left: 0;
}
.header .header-container .store-name {
  padding-left: 0;
  text-align: left;
}
.header .header-container .store-name img {
  padding-top: 5px;
}
.summary-container .summary #total-box .table {
  border-radius: 3px 3px 0 0;
}
.summary-container .summary .table td {
  color: $foreground-color;
}
.summary-container .summary #total-box .table.total-table {
  border-radius: 0 0 3px 3px;
}
.summary-container .summary #total-box .table.total-table tr td {
  color: $primary-brand-color;
}
.summary-container .summary .slidingDiv {
  background-color: lighten($background-color, 10%);
  border-radius: 3px;
} 
.summary-container .summary #total-box .table tbody.total {
  border-color: $primary-brand-color;
}
.summary-container .summary #total-box .table .success {
  border-color: $primary-brand-color;
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
  background: $primary-brand-color;
  border: 1px solid $primary-brand-color;
}
.summary-container .summary #total-box .table tbody.total tr.discount {
  background-color: rgba($primary-brand-color, 0.1);
  color: $primary-brand-color;
}
.summary-container .summary #total-box .table .success td {
  color: $foreground-color;
  background-color: $primary-brand-color;
}
.summary-container .summary #total-box .table.total-table tr.success td {
  color: lighten($background-color, 10%);
}

.error-msg-single, .bg-danger, .bg-success {
  border-radius: 3px;
}
.text-muted {
  color: rgba($foreground-color, 0.6);
}
.seals {
  border-color: rgba($primary-brand-color, 0.3);
}
.ticket-container .ticket-txt a, .custom-container .ticket-txt a {
  font-family: $heading-font;
  text-transform: uppercase;
  border-radius: 3px;
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
  border-color: rgba($primary-brand-color, 0.1);
}
.ac-container label.accordion {
  font-family: $heading-font;
  color: $foreground-color;
  text-shadow: none;
  border-bottom-color: rgba($primary-brand-color, 0.1);
  background: rgba($background-color, 0.3);
}
.ac-container label.accordion:hover {
  background: rgba($background-color, 0.02);
}
.ac-container input.accordion:checked + label span {
  background: $primary-brand-color;
}
.ac-container, .summary-container .summary .show-cart-button span.total-cart {
  font-family: $heading-font;
  border-radius: 3px;
}
.ac-container article {
  box-shadow: 0px 3px 0px 0px $primary-brand-color inset;
  background-color: rgba($background-color, 0.8);
}
.ac-container div:first-child label.accordion {
  border-radius: 3px 3px 0 0;
}
.ac-container div:last-child label.accordion {
  border-radius: 0 0 3px 3px;
}
.ac-container input.accordion:checked + label.accordion, 
.ac-container input.accordion:checked + label.accordion:hover
 {
  background-color: $primary-brand-color;
  text-shadow: none;
  color: lighten($background-color, 10%);
}
.ac-container input.accordion:checked ~ article {
  background: rgba($foreground-color, 0.05);
  box-shadow: none;
}
.ac-container div:last-child input.accordion:checked + label.accordion {
    border-radius: 0;
    border-bottom: 1px solid rgba($primary-brand-color, 0.1);
}

.ac-container label.accordion p.tag-discount {
  color: lighten($background-color, 10%);
  background-color: $primary-brand-color;
}
.ac-container input.accordion:checked + label.accordion p.tag-discount {
  color: $primary-brand-color;
  background-color: lighten($background-color, 10%);
}

.thankyou .form-box {
  overflow: hidden;
}
.thankyou .form-box .create-account {
  padding: 10px 20px 20px 20px;
  color: lighten($background-color, 70%);
  background: rgba($foreground-color, 0.05);
  border-radius: 3px;
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
}
.create-account .label-email {
  font-weight: bold;
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
.coupon-show-link, .submit-coupon-btn i.fa-stack-2x {
  color: $primary-brand-color;
}
.coupon-show-link {
  border-radius: 3px;
}
.submit-coupon-btn:active i.fa-stack-2x {
  color: darken($primary-brand-color, 10%);
}
.coupon-success {
  background: $primary-brand-color;
  border-radius: 0;
  font-size: 14px;
}
.coupon-success .arrow-up {
  border-bottom-color: $primary-brand-color;
}
@media (min-width: 768px) {
  .thankyou .form-box .ticket-txt p {
    text-align: left;
  }
}
@media (min-width: 992px) {
  .thankyou .success-msg {
      width: 66%;
  }
}


/*============================================================================
    CSS react
============================================================================*/

.submit-container button,
.summary,
.btn-primary,
.btn-primary:hover,
.btn-primary:active {
    background: $primary-brand-color;
}

.form-group input[type="checkbox"]:checked + .form-options-content,
.form-group input[type="radio"]:checked + .form-options-content{
    border: $primary-brand-color;
}

.form-group input[type="checkbox"]:checked + .form-options-content .checked,
.form-group input[type="radio"] + .form-options-content .checked,
.text-primary {
    color: $primary-brand-color;
}
 
{%  endif %}
