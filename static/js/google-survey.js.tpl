{#/*============================================================================
    #Google survey JS for Tienda Nube Survey
==============================================================================*/#}

{% if store.google_merchant_id %}
  <script src="https://apis.google.com/js/platform.js?onload=renderBadge"
    async defer>
  </script>
  <script>
    window.renderBadge = function() {
      var ratingBadgeContainer = document.createElement("div");
      document.body.appendChild(ratingBadgeContainer);
      window.gapi.load('ratingbadge', function() {
        window.gapi.ratingbadge.render(
          ratingBadgeContainer, {
            "merchant_id": {{ store.google_merchant_id | escape('js') }},
            "position": "BOTTOM_LEFT"
          });
      });
      };
    window.___gcfg = {
      lang: '{% if store.country == 'BR' %}pt_BR{% else %}es{% endif %}'
    };
  </script>
{% endif %}