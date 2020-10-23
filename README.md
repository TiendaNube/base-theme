# Base Theme
v1.14.0

The main purpose of this theme is to create a clean and ordered base for future themes. It includes all Nuvemshop´s features up to 01/01/19.
It was conceived as Mobile First and then adapted to Desktop, and the code is focused an generating small and easy to use or update components.
In terms of speed and performance, involves changes that benefit the weight and loading time but also cares for a excellent experience specially on the first loading seconds were the user gets to see part of the store´s content.

**External CSS** (static/css/style-critical.tpl)
  ```
  // Bootstrap Grid v4.1.3
  // Swiper 4.4.2
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
	// Instafeed
	// Swiper 4.4.2 (Custom Build)
  ```

**Folders Structure**
  ```
  - config
  - layouts
  - snipplets
    -- banner-services
    -- forms
    -- grid
    -- header
    -- home
    -- metas
    -- navigation
    -- payments
    -- placeholders
    -- product
    -- shipping
    -- shipping_suboptions
    -- social
    -- structured_data
    -- svg
    
  _____________
  - components
  - static
  	-- css
  	-- js
  	-- images
  - templates
  ```

**Demo**
[Base Theme Demo](https://basetheme.mitiendanube.com/)
