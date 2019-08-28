{# Mobile home slider placeholder: to be hidden after content loaded #}
{% if settings.slider and settings.slider is not empty %}
    <div class="js-home-slider-placeholder placeholder-full-height placeholder-container d-md-none overflow-hidden">
        <div class="container home-placeholder-icons">
            <div class="row">
                <div class="col-10 offset-1 mb-3 placeholder-line-medium placeholder-color">
                </div>
                <div class="col-8 offset-2 mb-3 placeholder-line-medium placeholder-color">
                </div>
                <div class="col-6 offset-3 mb-3 placeholder-line-medium placeholder-color">
                </div>
            </div>
        </div>
        <div class="placeholder-shine">
        </div>
    </div>
    <div class="js-slider-desktop-placeholder slider-desktop-placeholder">
    </div>
{% endif %}