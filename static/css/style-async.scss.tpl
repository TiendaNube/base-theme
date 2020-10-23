/*============================================================================
style.css

    -This file contains all the theme non critical styles wich will be loaded asynchronously
    -Rest of styling can be found in:
      --static/css/style-colors.scss.tpl --> For color and font styles related to config/settings.txt
      --static/css/style-critical.tpl --> For critical CSS rendered inline before the rest of the site

==============================================================================*/

/*============================================================================
  Table of Contents

  #Components
    // Margin and Padding
    // Mixins
    // Animations
    // Buttons
    // Forms
    // Icons
    // Alerts and Notifications
    // Modals
    // Tables
    // Tabs
    // Cards
  #Header and nav
    // Nav
    // Search
  #Footer
    // Nav
    // Newsletter
  #Home page
    // Instafeed
    // Banners
  #Product grid
    // Filters
  #Product detail
  	// Image
  	// Form and info
  #Media queries
    // Min width 768px
      //// Components
      //// Footer
  #Critical path utilities

==============================================================================*/

/*============================================================================
  #Components
==============================================================================*/

{# /* // Margin and Padding */ #}

%section-margin {
  margin-bottom: 70px;
}
%element-margin {
  margin-bottom: 35px;
}
%element-margin-small {
  margin-bottom: 20px;
}

{# /* // Mixins */ #}

{# This mixin adds browser prefixes to a CSS property #}

@mixin prefix($property, $value, $prefixes: ()) {
  @each $prefix in $prefixes {
    #{'-' + $prefix + '-' + $property}: $value;
  }
  #{$property}: $value;
}


{# /* // Animations */ #}

.transition-soft {
  @include prefix(transition, all 0.3s ease, webkit ms moz o);
}

.beat {
  animation: .8s 2 beat;
}
@keyframes beat {
  0% {
    @include prefix(transform, scale(1), webkit ms moz o);
  }
  25% {
    @include prefix(transform, scale(1.3), webkit ms moz o);
  }
  40% {
    @include prefix(transform, scale(1), webkit ms moz o);
  }
  60% {
    @include prefix(transform, scale(1.3), webkit ms moz o);
  }
  100% {
    @include prefix(transform, scale(1), webkit ms moz o);
  }
}

@keyframes bounceIn{
  0%{
    transform: scale(1) translate3d(0,0,0);
  }
  50%{
    transform: scale(1.2);
  }
  80%{
    transform: scale(0.89);
  }
  100%{
    transform: scale(1) translate3d(0,0,0);
  }
}

{# /* // Buttons */ #}

.btn-transition {
  position: relative;
  overflow: hidden;
  .transition-container {
    position: absolute;
    top: 50%;
    left: 0;
    width: 100%;
    margin-top: -7px;
    opacity: 0;
    text-align: center;
    @include prefix(transition, all 0.5s ease, webkit ms moz o);
    cursor: not-allowed;
    pointer-events: none;
    &.active {
      opacity: 1;
    }
  }
} 

{# /* // Forms */ #}

.form-group{
  @extend %element-margin;
  .form-label{
    float: left;
    width: 100%;
    margin-bottom: 10px;
  }
  .alert{
    margin: 10px 0 0 0;
  }
}

.radio-button{
  margin-bottom: 0;
  -webkit-tap-highlight-color: rgba(0,0,0,0);
  cursor: pointer;
  &.disabled{
    opacity: 0.6;
    cursor: not-allowed;
    input[type="radio"] {
      cursor: not-allowed;
    }
  }
  &-content{
    position: relative;
    width: 100%;
    float: left;
    padding: 15px; 
    clear: both;
    box-sizing: border-box;
  }
  &-icons-container{
    position: absolute;
    top: 14px;
    left: 10px;
  }
  &-icons{
    position: relative;
    float: left;
  }
  &-icon{
    width: 16px;
    height: 16px;
    border-radius: 50%;
  }
  input[type="radio"]{
    display: none;
    & +  .radio-button-content .unchecked{
      float: left;
    }
    & +  .radio-button-content .checked{
      position: absolute;
      top: 8px;
      left: 8px;
      width:0;
      height: 0;      
      @include prefix(transform, translate(-50%,-50%), webkit ms moz o);
      @include prefix(transition, all 0.2s , webkit ms moz o);
    }
    &:checked {
      .shipping-method-name{
        font-weight: bold;
      } 
      + .radio-button-content .checked{
        width: 8px;
        height: 8px;
      }  
    } 
  }
  &-label{
    width: 100%;
    float: left;
    padding-left: 30px;
  }
}

.radio-button-item:last-of-type .radio-button{
  margin-bottom: 0;
}

.checkbox-container{
  .checkbox {
    position: relative;
    display: block;
    margin-bottom: 15px;
    padding-left: 30px;
    line-height: 20px;
    cursor: pointer;
    @include prefix(user-select, none, webkit ms moz o);

    &-color {
      display: inline-block;
      width: 10px;
      height: 10px;
      margin: 0 0 2px 5px;
      vertical-align: middle;
      border-radius: 100%;
    }

    input {
      display: none;
      &:checked ~ .checkbox-icon:after {
        display: block;
      }
    }

    &-icon {
      position: absolute;
      top: -1px;
      left: 0;
      width: 20px;
      height: 20px;

      &:after {
        position: absolute;
        top: 1px;
        left: 6px;
        display: none;
        width: 7px;
        height: 12px;
        content: '';
        @include prefix(transform, rotate(45deg), webkit ms moz o);
      }
    }
  }
}

.form-select {
  display: block;
  width: 100%;
  &:focus{
    outline:0;
  }
  &::-ms-expand {
    display: none;
  }
}

{# /* Lists */ #}

.list-readonly{
  .radio-button-label{
    width: 100%;
    padding-left: 0;
    cursor: default;
  }
  .list-item{
    position: relative;
    width: 100%;
    float: left;
    padding: 15px;
    clear: both;
    cursor: default;
    .radio-button-content{
      padding: 0;
    }
  }
}

{# /* Disabled controls */ #}

input,
select,
textarea{
  &[disabled],
  &[disabled]:hover,
  &[readonly],
  &[readonly]:hover{
    background-color: #DDD;
    cursor: not-allowed; 
  }
}

{# /* // Icons */ #}

.social-icon {
  display: inline-block;
  padding: 8px;
  font-size: 22px;
}

{# /* // Alerts and notifications */ #}

.alert {
  clear: both;
  padding: 8px;
  border: 1px solid;
  text-align: center;
  @extend %element-margin;
}

.notification-hidden{
  transition: all .1s cubic-bezier(.16,.68,.43,.99);
  @include prefix(transform, rotatex(90deg), webkit ms moz o);
  pointer-events: none;
}
.notification-visible{
  transition: all .5s cubic-bezier(.16,.68,.43,.99);
  @include prefix(transform, rotatex(0deg), webkit ms moz o);
}
.notification-close {
  position: absolute;
  top: 5px;
  right: 10px;
  z-index: 1;
  font-size: 20px; 
  cursor: pointer;
}

{# /* // Modals */ #}

.modal {
  position: fixed;
  top: 0;
  display: block;
  width: 80%;
  height: 100%;
  padding: 10px;
  -webkit-overflow-scrolling: touch;
  overflow-y: auto;
  transition: all .2s cubic-bezier(.16,.68,.43,.99);
  z-index: 20000;
  &-header{
    width: calc(100% + 20px);
    margin: -10px 0 10px -10px;
    padding: 10px 15px;
    font-size: 20px;
  }
  &-footer{
    padding: 10px;
    clear: both;
  }
  &-full {
    width: 100%;
  }
  &-docked-md{
    width: 100%;
  }
  &-docked-small{
    width: 80%;
  }
  &-top{
    top: -100%;
    left: 0;
  }
  &-bottom{
    top: 100%;
    left: 0;
  }
  &-left{
    left: -100%;
  }
  &-right{
    right: -100%;
  }
  &-centered{
    height: 100%;
    width: 100%;
  }
  &-top.modal-show,
  &-bottom.modal-show {
    top: 0;
  }
  &-bottom-sheet {
    top: initial;
    bottom: -100%;
    height: auto;
    &.modal-show {
      top: initial;
      bottom: 0;
      height: auto;
    }
  }
  &-left.modal-show {
    left: 0;
  }
  &-right.modal-show {
    right: 0;
  }
  &-close { 
    display: inline-block;
    padding: 1px 5px 5px 0;
    margin-right: 5px;
    vertical-align: middle;
    cursor: pointer;
  }
  .tab-group{
    margin:  0 -10px 20px -10px;
  }
}

.modal-overlay{
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: #00000047;
  z-index: 10000;
}

.fancybox-slide--html{
  .fancybox-content  {
    width: 100%;
    background: transparent;
  }
  .fancybox-close-small {
    {# Hardcoded neutral color to match non iframe fancybox modal #}
    color: #ccc!important;
  }
}

{# /* // Tables */ #}

.table{
  width: 100%;
  border-collapse: collapse;
  border-spacing: 0;
  thead{
    th{
      padding: 8px;
      &:first-of-type{
        padding-left: 0;
      }
    }
  }
  td{
    padding: 8px;
    text-align: left;
  }
}

{# /* // Tabs */ #}


.tab-group{
  width: 100vw;
  padding: 0;
  overflow-x: scroll;
  white-space: nowrap;
  .tab{
    display: inline-flex;
    float: none;
    &-link{
      float: left;
      padding: 10px;
      text-align: center;
    }
  }
}

.tab-panel:not(.active){
  display: none;
}
.tab-panel.active{
  display: block;
}

{# /* // Cards */ #}

.card {
	position: relative;
	display: -ms-flexbox;
	display: flex;
	margin-bottom: 20px;
	-ms-flex-direction: column;
	flex-direction: column;
	min-width: 0;
	word-wrap: break-word;
	background-clip: border-box;
}

.card-body {
	-ms-flex: 1 1 auto;
	flex: 1 1 auto;
	padding: 15px;
}

.card-header {
	padding: 15px;
	margin-bottom: 0;
}

.card-footer {
	padding: 15px;
}

/*============================================================================
  #Header and nav
==============================================================================*/

{# /* // Nav */ #}

.modal-nav-hamburger {
  text-align: center;
  .modal-header {
      margin-top: 25px;
      .modal-close {
        margin: 0;
        padding: 5px;
      }
  }
}

.nav-primary {
  padding: 0 0 10px;
  .nav-list {
    padding: 10px 0 10px;
    list-style: none;
    .item-with-subitems {
      position: relative;
    }
    .nav-list-link {
      display: block;
      padding: 15px;
      font-size: 18px;
      font-weight: 700;
      border-bottom: 0;
      }
    &-arrow {
      position: absolute;
      top: 15px;
      right: 20px;
      font-size: 14px;
      cursor: pointer;
      &.selected {
        transform: rotate(90deg);
      }
    }
    .list-subitems {
      padding: 0;
      list-style: none;
      .nav-list-link {
        font-weight: 400;
      }
    }
  }

}

.nav-secondary {
  .nav-account {
    margin: 10px 0;
    padding: 0;
    list-style: none;
    .nav-accounts-item {
      display: inline-block;
      margin: 10px;
      font-size: 14px;
    } 
  }
}

.hamburger-panel{
    box-shadow: none;
    .btn-hamburger-close {
        right: 15px;
        top: 6px;
        font-size: 18px;
    }
    .list-items {
        padding: 45px 0 10px;
        .hamburger-panel-link {
            display: block;
            padding: 20px;
            letter-spacing: 1px;
            font-weight: 400;
            border-bottom: 0;
        }
        .list-subitems { 
            padding: 0;
        }
    }
    .hamburger-panel-arrow {
        font-size: 12px;
        &.selected {
            transform: rotate(90deg);
        }
    }
    .hamburger-panel-first-row {
        background: none;
        .mobile-accounts{
            padding: 0 12px;
            .mobile-accounts-item {
                width: auto;
                display: inline-block;
                .mobile-accounts-link {
                    padding: 10px 5px;
                    font-size: 12px;
                    opacity: 0.6;
                }
                &:first-child a:after {
                position: relative;
                right: -7px;
                content: "|";
                }
            }
        }
    }
  &-arrow{
    top: 15px;
    right: 10px;
    margin-top: -10px;
    &.selected svg{
      transform-origin: center;
      transform: rotate(180deg);
      -webkit-transform: rotate(180deg);
      -moz-transform: rotate(180deg);
      -ms-transform: rotate(180deg);
      -o-transform: rotate(180deg);
    }
  }
}

{# /* // Search */ #}

.search-input {
  padding-right: 30px;
}

.search-input[type="search"]::-webkit-search-cancel-button {
  -webkit-appearance:none
}

.search-input-submit {
  position: absolute;
  top: 5px;
  right: 0;
  font-size: 18px;
  background: none;
  border: 0;
}

.search-suggest-list {
  margin: 0 0 10px 0;
  padding: 0;
}

.search-suggest-item {
  padding: 10px 15px;
  list-style: none;
}

.search-suggest-text,
.search-suggest-name {
  margin-bottom: 5px;
  line-height: 18px;
}
.search-suggest-icon {
  margin: 0 10px;
  font-size: 14px;
}

/*============================================================================
  #Footer
==============================================================================*/

footer {
  margin-top: 20px;
  padding: 30px 0; 
}

{# /* // Nav */ #}

.footer-menu {
  list-style: none;
  .footer-menu-item{
  }
}

{# /* // Newsletter */ #}

.newsletter {
  form {
    position: relative;
    .newsletter-btn {
      position: absolute;
      top: 0;
      right: 0px;
      padding: 10px;
    }
  } 
}

.footer-payments-shipping-logos{
  img {
    max-width: 46px;
    margin: 2px;
    padding: 5px;
    border: 1px solid #eaeaea;
  }
}

.powered-by-text {
  display: inline-block; }

.powered-by-logo {
  display: inline-block;
  width: 160px;
}

.footer-logo {
  img {
    max-width: 100px;
    margin: 2px;
    padding: 5px;
  }
}    
   
/*============================================================================
  #Home Page
==============================================================================*/

.section-slider-home,
.section-banners-home,
.section-video-home,
.section-home-modules,
.section-featured-home,
.section-welcome-home {
  @extend %section-margin;
}

{# /* // Instafeed */ #}

.instafeed-user {
	display: inline-block;
	margin: 0 0 0 5px;
  line-height: 24px;
  vertical-align: top;
}

.instafeed-link {
  position: relative;
  display: block;
  overflow: hidden;
  &:hover,
  &:focus {
    .instafeed-img {
      @include prefix(transform, scale(1.03), webkit ms moz o);
    }
    .instafeed-info {
      opacity: 1;
    }
  }
  .instafeed-img {
    @include prefix(transition, all 0.8s ease, webkit ms moz o);
  }
  .instafeed-info {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    padding: 0;
    text-align: center;
    opacity: 0;
    @include prefix(transition, all 0.8s ease, webkit ms moz o);
    .instafeed-info-item {
      display: inline-block;
      margin-top: 45%;
    }
  }
}

{# /* // Banners */ #}

.textbanner {
  .textbanner-image.overlay {
    @include prefix(transition, all 0.8s ease, webkit ms moz o);
  }
  &:hover .textbanner-image.overlay,
  &:focus .textbanner-image.overlay {
    @include prefix(transform, scale(1.03), webkit ms moz o);
  }
}

/*============================================================================
  #Product Grid
==============================================================================*/

{# /* // Filters */ #}

.filter-remove {
  position: relative;
  padding: 10px 28px 10px 10px;
  margin: 0 8px 10px 0;
  line-height: 18px;
  border-radius: 0;
  &:after {
    position: absolute;
    top: 10px;
    right: 10px;
    right: 10px;
    width: 10px;
  }
}

/*============================================================================
  #Product detail
==============================================================================*/

{# /* // Image */ #}

body.compensate-for-scrollbar{overflow:hidden}.fancybox-active{height:auto}.fancybox-is-hidden{left:-9999px;margin:0;position:absolute!important;top:-9999px;visibility:hidden}.fancybox-container{-webkit-backface-visibility:hidden;height:100%;left:0;outline:none;position:fixed;-webkit-tap-highlight-color:transparent;top:0;-ms-touch-action:manipulation;touch-action:manipulation;-webkit-transform:translateZ(0);transform:translateZ(0);width:100%;z-index:99992}.fancybox-container *{box-sizing:border-box}.fancybox-bg,.fancybox-inner,.fancybox-outer,.fancybox-stage{bottom:0;left:0;position:absolute;right:0;top:0}.fancybox-outer{-webkit-overflow-scrolling:touch;overflow-y:auto}.fancybox-bg{background:#1e1e1e;opacity:0;transition-duration:inherit;transition-property:opacity;transition-timing-function:cubic-bezier(.47,0,.74,.71)}.fancybox-is-open .fancybox-bg{opacity:.9;transition-timing-function:cubic-bezier(.22,.61,.36,1)}.fancybox-caption,.fancybox-infobar,.fancybox-navigation .fancybox-button,.fancybox-toolbar{direction:ltr;opacity:0;position:absolute;transition:opacity .25s ease,visibility 0s ease .25s;visibility:hidden;z-index:99997}.fancybox-show-caption .fancybox-caption,.fancybox-show-infobar .fancybox-infobar,.fancybox-show-nav .fancybox-navigation .fancybox-button,.fancybox-show-toolbar .fancybox-toolbar{opacity:1;transition:opacity .25s ease 0s,visibility 0s ease 0s;visibility:visible}.fancybox-infobar{color:#ccc;font-size:13px;-webkit-font-smoothing:subpixel-antialiased;height:44px;left:0;line-height:44px;min-width:44px;mix-blend-mode:difference;padding:0 10px;pointer-events:none;top:0;-webkit-touch-callout:none;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none}.fancybox-toolbar{right:0;top:0}.fancybox-stage{direction:ltr;overflow:visible;-webkit-transform:translateZ(0);transform:translateZ(0);z-index:99994}.fancybox-is-open .fancybox-stage{overflow:hidden}.fancybox-slide{-webkit-backface-visibility:hidden;display:none;height:100%;left:0;outline:none;overflow:auto;-webkit-overflow-scrolling:touch;padding:44px;position:absolute;text-align:center;top:0;transition-property:opacity,-webkit-transform;transition-property:transform,opacity;transition-property:transform,opacity,-webkit-transform;white-space:normal;width:100%;z-index:99994}.fancybox-slide:before{content:"";display:inline-block;font-size:0;height:100%;vertical-align:middle;width:0}.fancybox-is-sliding .fancybox-slide,.fancybox-slide--current,.fancybox-slide--next,.fancybox-slide--previous{display:block}.fancybox-slide--image{overflow:hidden;padding:44px 0}.fancybox-slide--image:before{display:none}.fancybox-slide--html{padding:6px}.fancybox-content{background:#fff;display:inline-block;margin:0;max-width:100%;overflow:auto;-webkit-overflow-scrolling:touch;padding:44px;position:relative;text-align:left;vertical-align:middle}.fancybox-slide--image .fancybox-content{-webkit-animation-timing-function:cubic-bezier(.5,0,.14,1);animation-timing-function:cubic-bezier(.5,0,.14,1);-webkit-backface-visibility:hidden;background:transparent;background-repeat:no-repeat;background-size:100% 100%;left:0;max-width:none;overflow:visible;padding:0;position:absolute;top:0;-webkit-transform-origin:top left;transform-origin:top left;transition-property:opacity,-webkit-transform;transition-property:transform,opacity;transition-property:transform,opacity,-webkit-transform;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;z-index:99995}.fancybox-can-zoomOut .fancybox-content{cursor:zoom-out}.fancybox-can-zoomIn .fancybox-content{cursor:zoom-in}.fancybox-can-pan .fancybox-content,.fancybox-can-swipe .fancybox-content{cursor:-webkit-grab;cursor:grab}.fancybox-is-grabbing .fancybox-content{cursor:-webkit-grabbing;cursor:grabbing}.fancybox-container [data-selectable=true]{cursor:text}.fancybox-image,.fancybox-spaceball{background:transparent;border:0;height:100%;left:0;margin:0;max-height:none;max-width:none;padding:0;position:absolute;top:0;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;width:100%}.fancybox-spaceball{z-index:1}.fancybox-slide--iframe .fancybox-content,.fancybox-slide--map .fancybox-content,.fancybox-slide--pdf .fancybox-content,.fancybox-slide--video .fancybox-content{height:100%;overflow:visible;padding:0;width:100%}.fancybox-slide--video .fancybox-content{background:#000}.fancybox-slide--map .fancybox-content{background:#e5e3df}.fancybox-slide--iframe .fancybox-content{background:#fff}.fancybox-iframe,.fancybox-video{background:transparent;border:0;display:block;height:100%;margin:0;overflow:hidden;padding:0;width:100%}.fancybox-iframe{left:0;position:absolute;top:0}.fancybox-error{background:#fff;cursor:default;max-width:400px;padding:40px;width:100%}.fancybox-error p{color:#444;font-size:16px;line-height:20px;margin:0;padding:0}.fancybox-button{background:rgba(30,30,30,.6);border:0;border-radius:0;box-shadow:none;cursor:pointer;display:inline-block;height:44px;margin:0;padding:10px;position:relative;transition:color .2s;vertical-align:top;visibility:inherit;width:44px}.fancybox-button,.fancybox-button:link,.fancybox-button:visited{color:#ccc}.fancybox-button:hover{color:#fff}.fancybox-button:focus{outline:none}.fancybox-button.fancybox-focus{outline:1px dotted}.fancybox-button[disabled],.fancybox-button[disabled]:hover{color:#888;cursor:default;outline:none}.fancybox-button div{height:100%}.fancybox-button svg{display:block;height:100%;overflow:visible;position:relative;width:100%}.fancybox-button svg path{fill:currentColor;stroke-width:0}.fancybox-button--fsenter svg:nth-child(2),.fancybox-button--fsexit svg:nth-child(1),.fancybox-button--pause svg:nth-child(1),.fancybox-button--play svg:nth-child(2){display:none}.fancybox-progress{background:#ff5268;height:2px;left:0;position:absolute;right:0;top:0;-webkit-transform:scaleX(0);transform:scaleX(0);-webkit-transform-origin:0;transform-origin:0;transition-property:-webkit-transform;transition-property:transform;transition-property:transform,-webkit-transform;transition-timing-function:linear;z-index:99998}.fancybox-close-small{background:transparent;border:0;border-radius:0;color:#ccc;cursor:pointer;opacity:.8;padding:8px;position:absolute;right:-12px;top:-44px;z-index:401}.fancybox-close-small:hover{color:#fff;opacity:1}.fancybox-slide--html .fancybox-close-small{color:currentColor;padding:10px;right:0;top:0}.fancybox-slide--image.fancybox-is-scaling .fancybox-content{overflow:hidden}.fancybox-is-scaling .fancybox-close-small,.fancybox-is-zoomable.fancybox-can-pan .fancybox-close-small{display:none}.fancybox-navigation .fancybox-button{background-clip:content-box;height:100px;opacity:0;position:absolute;top:calc(50% - 50px);width:70px}.fancybox-navigation .fancybox-button div{padding:7px}.fancybox-navigation .fancybox-button--arrow_left{left:0;padding:31px 26px 31px 6px}.fancybox-navigation .fancybox-button--arrow_right{padding:31px 6px 31px 26px;right:0}.fancybox-caption{bottom:0;color:#eee;font-size:14px;font-weight:400;left:0;line-height:1.5;padding:25px 44px;right:0;text-align:center;z-index:99996}.fancybox-caption:before{background-image:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAD6CAQAAADKSeXYAAAAYklEQVQoz42RwQ3AMAgDjfcfup8WoRykfBAK5mQHKSz5rbXJPis1hjiV3CIqgG0hLZPkVkA4p4x5oR1bVeDrdCLrW2Q0D5bcwY3TGMHbdw3mPRuOtaspYP1w//G1OIcW148H0DMCqI/3mMMAAAAASUVORK5CYII=);background-repeat:repeat-x;background-size:contain;bottom:0;content:"";display:block;left:0;pointer-events:none;position:absolute;right:0;top:-44px;z-index:-1}.fancybox-caption a,.fancybox-caption a:link,.fancybox-caption a:visited{color:#ccc;text-decoration:none}.fancybox-caption a:hover{color:#fff;text-decoration:underline}.fancybox-loading{-webkit-animation:a 1s linear infinite;animation:a 1s linear infinite;background:transparent;border:4px solid #888;border-bottom-color:#fff;border-radius:50%;height:50px;left:50%;margin:-25px 0 0 -25px;opacity:.7;padding:0;position:absolute;top:50%;width:50px;z-index:99999}@-webkit-keyframes a{to{-webkit-transform:rotate(1turn);transform:rotate(1turn)}}@keyframes a{to{-webkit-transform:rotate(1turn);transform:rotate(1turn)}}.fancybox-animated{transition-timing-function:cubic-bezier(0,0,.25,1)}.fancybox-fx-slide.fancybox-slide--previous{opacity:0;-webkit-transform:translate3d(-100%,0,0);transform:translate3d(-100%,0,0)}.fancybox-fx-slide.fancybox-slide--next{opacity:0;-webkit-transform:translate3d(100%,0,0);transform:translate3d(100%,0,0)}.fancybox-fx-slide.fancybox-slide--current{opacity:1;-webkit-transform:translateZ(0);transform:translateZ(0)}.fancybox-fx-fade.fancybox-slide--next,.fancybox-fx-fade.fancybox-slide--previous{opacity:0;transition-timing-function:cubic-bezier(.19,1,.22,1)}.fancybox-fx-fade.fancybox-slide--current{opacity:1}.fancybox-fx-zoom-in-out.fancybox-slide--previous{opacity:0;-webkit-transform:scale3d(1.5,1.5,1.5);transform:scale3d(1.5,1.5,1.5)}.fancybox-fx-zoom-in-out.fancybox-slide--next{opacity:0;-webkit-transform:scale3d(.5,.5,.5);transform:scale3d(.5,.5,.5)}.fancybox-fx-zoom-in-out.fancybox-slide--current{opacity:1;-webkit-transform:scaleX(1);transform:scaleX(1)}.fancybox-fx-rotate.fancybox-slide--previous{opacity:0;-webkit-transform:rotate(-1turn);transform:rotate(-1turn)}.fancybox-fx-rotate.fancybox-slide--next{opacity:0;-webkit-transform:rotate(1turn);transform:rotate(1turn)}.fancybox-fx-rotate.fancybox-slide--current{opacity:1;-webkit-transform:rotate(0deg);transform:rotate(0deg)}.fancybox-fx-circular.fancybox-slide--previous{opacity:0;-webkit-transform:scale3d(0,0,0) translate3d(-100%,0,0);transform:scale3d(0,0,0) translate3d(-100%,0,0)}.fancybox-fx-circular.fancybox-slide--next{opacity:0;-webkit-transform:scale3d(0,0,0) translate3d(100%,0,0);transform:scale3d(0,0,0) translate3d(100%,0,0)}.fancybox-fx-circular.fancybox-slide--current{opacity:1;-webkit-transform:scaleX(1) translateZ(0);transform:scaleX(1) translateZ(0)}.fancybox-fx-tube.fancybox-slide--previous{-webkit-transform:translate3d(-100%,0,0) scale(.1) skew(-10deg);transform:translate3d(-100%,0,0) scale(.1) skew(-10deg)}.fancybox-fx-tube.fancybox-slide--next{-webkit-transform:translate3d(100%,0,0) scale(.1) skew(10deg);transform:translate3d(100%,0,0) scale(.1) skew(10deg)}.fancybox-fx-tube.fancybox-slide--current{-webkit-transform:translateZ(0) scale(1);transform:translateZ(0) scale(1)}@media (max-height:576px){.fancybox-caption{padding:12px}.fancybox-slide{padding-left:6px;padding-right:6px}.fancybox-slide--image{padding:6px 0}.fancybox-close-small{right:-6px}.fancybox-slide--image .fancybox-close-small{background:#4e4e4e;color:#f2f4f6;height:36px;opacity:1;padding:6px;right:0;top:0;width:36px}}.fancybox-share{background:#f4f4f4;border-radius:3px;max-width:90%;padding:30px;text-align:center}.fancybox-share h1{color:#222;font-size:35px;font-weight:700;margin:0 0 20px}.fancybox-share p{margin:0;padding:0}.fancybox-share__button{border:0;border-radius:3px;display:inline-block;font-size:14px;font-weight:700;line-height:40px;margin:0 5px 10px;min-width:130px;padding:0 15px;text-decoration:none;transition:all .2s;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;white-space:nowrap}.fancybox-share__button:link,.fancybox-share__button:visited{color:#fff}.fancybox-share__button:hover{text-decoration:none}.fancybox-share__button--fb{background:#3b5998}.fancybox-share__button--fb:hover{background:#344e86}.fancybox-share__button--pt{background:#bd081d}.fancybox-share__button--pt:hover{background:#aa0719}.fancybox-share__button--tw{background:#1da1f2}.fancybox-share__button--tw:hover{background:#0d95e8}.fancybox-share__button svg{height:25px;margin-right:7px;position:relative;top:-1px;vertical-align:middle;width:25px}.fancybox-share__button svg path{fill:#fff}.fancybox-share__input{background:transparent;border:0;border-bottom:1px solid #d7d7d7;border-radius:0;color:#5d5b5b;font-size:14px;margin:10px 0 0;outline:none;padding:10px 15px;width:100%}.fancybox-thumbs{background:#ddd;bottom:0;display:none;margin:0;-webkit-overflow-scrolling:touch;-ms-overflow-style:-ms-autohiding-scrollbar;padding:2px 2px 4px;position:absolute;right:0;-webkit-tap-highlight-color:transparent;top:0;width:212px;z-index:99995}.fancybox-thumbs-x{overflow-x:auto;overflow-y:hidden}.fancybox-show-thumbs .fancybox-thumbs{display:block}.fancybox-show-thumbs .fancybox-inner{right:212px}.fancybox-thumbs__list{font-size:0;height:100%;list-style:none;margin:0;overflow-x:hidden;overflow-y:auto;padding:0;position:absolute;position:relative;white-space:nowrap;width:100%}.fancybox-thumbs-x .fancybox-thumbs__list{overflow:hidden}.fancybox-thumbs-y .fancybox-thumbs__list::-webkit-scrollbar{width:7px}.fancybox-thumbs-y .fancybox-thumbs__list::-webkit-scrollbar-track{background:#fff;border-radius:10px;box-shadow:inset 0 0 6px rgba(0,0,0,.3)}.fancybox-thumbs-y .fancybox-thumbs__list::-webkit-scrollbar-thumb{background:#2a2a2a;border-radius:10px}.fancybox-thumbs__list a{-webkit-backface-visibility:hidden;backface-visibility:hidden;background-color:rgba(0,0,0,.1);background-position:50%;background-repeat:no-repeat;background-size:cover;cursor:pointer;float:left;height:75px;margin:2px;max-height:calc(100% - 8px);max-width:calc(50% - 4px);outline:none;overflow:hidden;padding:0;position:relative;-webkit-tap-highlight-color:transparent;width:100px}.fancybox-thumbs__list a:before{border:6px solid #ff5268;bottom:0;content:"";left:0;opacity:0;position:absolute;right:0;top:0;transition:all .2s cubic-bezier(.25,.46,.45,.94);z-index:99991}.fancybox-thumbs__list a:focus:before{opacity:.5}.fancybox-thumbs__list a.fancybox-thumbs-active:before{opacity:1}@media (max-width:576px){.fancybox-thumbs{width:110px}.fancybox-show-thumbs .fancybox-inner{right:110px}.fancybox-thumbs__list a{max-width:calc(100% - 10px)}}

.user-content img {
	max-width: 100%;
	height: auto !important;
}

{# /* // Form and info */ #}

.social-share-button {
  display: inline-block;
  padding: 8px;
  font-size: 22px;
  &:hover,
  &:focus{
    opacity: 0.8;
  }
}

.section-single-product,
.section-fb-comments,
.section-products-related {
  @extend %section-margin;
}

/*============================================================================
  #Cart detail
==============================================================================*/


{# /* Table */ #}

.cart-table-row{
  padding: 10px 0;
}

.cart-item{
  position: relative;
  @extend %element-margin;
  &-name{
    float: left;
    width: 100%;
    padding: 0 40px 10px 0;
  }
  &-subtotal{
    float: right;
    margin: 10px 0;
    text-align: right;
    font-weight: normal;
  }
  &-btn{
    padding: 6px;
    display: inline-block;
    background: transparent;
    font-size: 16px;
    opacity: 0.8;
    &:hover{
      opacity: 0.6;
    }
  }
  &-input{
    display: inline-block;
    width: 40px;
    height: 30px;
    font-size: 16px;
    text-align: center;
    -moz-appearance:textfield;
    &::-webkit-outer-spin-button,
    &::-webkit-inner-spin-button{
      -webkit-appearance: none;
    }
  }
  .fa-cog{
    display: none;
  }
  &-spinner{
    display: inline-block;
    width: 40px;
    text-align: center;
  }
  &-delete{
    position: absolute;
    right: 0;
    .btn{
      padding-right:0; 
    }
  }
}

.cart-quantity-input-container svg{
  padding: 6px 14px;
}

.cart-unit-price{
  float: left;
  width: 100%;
  margin: 5px 0 2px 0;
}

.cart-promotion-detail{
  float: left;
  width: 65%;
  text-align: left;
} 
.cart-promotion-number{
  position: absolute;
  right: 0;
  bottom: 0;
  float: right;
  text-align: right;
  font-weight: bold;
} 


{# /* // Totals */ #}

.cart-subtotal{
  float: right;
  clear: both;
  margin: 0 0 10px 0;
}
.total-promotions-row{
  float: right;
  width: 100%;
  margin-bottom: 5px;
  position: relative;
  .cart-promotion-number{
    margin-left: 5px;
  }
}
.cart-total{
  clear: both;
  margin: 10px 0;
  font-weight: bold;
}

{# /* Totals */ #}

.cart-promotion-detail{
  width: 65%;
  float: left;
}
.cart-promotion-number{
  position: absolute;
  right: 0;
  bottom: 0;
  width: 35%;
  float: right;
  margin: 0;
  text-align: right;
}

{#/*============================================================================
  #Media queries
==============================================================================*/ #}

{# /* // Min width 768px */ #}

@media (min-width: 768px) { 

  {# /* //// Components */ #}

  {# /* Modals */ #}

  .modal{
    &-centered{
      height: 80%;
      width: 80%;
      left: 10%;
      margin: 5% auto;
    }
    &-docked-md{
      width: 500px;
      &-centered{
        left: calc(50% - 250px);
        bottom: auto;
        height: auto;
      }
    }
    &-bottom-sheet {
      top: 100%;
      &.modal-show {
        top: 0;
        bottom: auto;
      }
    }
    &-docked-small{
      width: 350px;
    }
  }

  .fancybox-slide--html .fancybox-content{
    width: 85%;
  }

  {# /*  Notifications */ #}

  .notification-floating .notification{
    width: 350px;
  }

  {# /* Tabs */ #}

  .tab-group{
    width: calc(100% + 20px);
    overflow-x: auto;
    white-space: normal;
    .tab{
      float: left;
    }
  }

  {# /* //// Footer */ #}

  .footer-menu {
    list-style: none;
    .footer-menu-item{  
      display: inline-block;
      padding: 0 15px;
    }
  }
}

{#/*============================================================================
  #Critical path utilities
==============================================================================*/#}

.visible-when-content-ready{
  visibility: visible!important;
}
.display-when-content-ready{
  display: block!important;
}
