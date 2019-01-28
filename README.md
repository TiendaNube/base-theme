# Base Theme
BETA v1.0.0

The main purpose of this theme is to create a clean and ordered base for future themes. It includes all Tienda Nube´s features up to 01/01/19.
It was conceived as Mobile First and then adapted to Desktop, and the code is focused an generating small and easy to use or update components.
In terms of speed and performance, involves changes that benefit the weight and loading time but also cares for a excellent experience specially on the first loading seconds were the user gets to see part of the store´s content.

**External CSS** (static/css/style-critical.tpl)
  ```
  // Bootstrap Grid v4.1.3
  // Swiper 4.4.2
  // Font Awesome 5.5.0
  ```
  
**CSS / SCSS**
  ```
  static/css/style-critical.tpl
  static/css/style-colors.scss.tpl
  static/css/style-async.scss.tpl
  static/checkout.scss.tpl
  ```
  
**JS**
  ```
	// jquery 1.11.1
	// Google survey JS
	// Load async styling
	// Store JS (static/js/store.js.tpl)
  ```
  
**External JS** (static/js/external.js.tpl)
  ```
	// jquery.cookie v1.4.1
	// jquery.livequery v1.3.6
	// Olark code
	// Fancybox 3
  ```
  
**External No Dependencies JS** (static/js/external-no-dependencies.js.tpl)
  ```
	// lazysizes - v4.0.0-rc2
	// lazysizes extension to bgset 
	// lazysizes - v4.1.5 extension
	// Instafeed
	// Swiper 4.4.2 (Custom Build)
  ```

**Folders Structure**
  ```
  - config
  - layouts
  - snipplets
    -- header
    -- footer
    -- metas
    -- navigation
    -- forms
    -- placeholders
    -- shipping
    -- payments
    -- social
    -- svg
    -- home
    -- grid
    -- product
  _____________
  - components
  - static
  	-- css
  	-- js
  	-- images
  	-- font-awesome
  - templates
  ```

**Demo**
[Base Theme Demo - Gnix](https://basetheme.mitiendanube.com/)
