{% if settings.video_embed %}
    <section class="section-video-home" data-store="video-home">
        <div class="container{% if settings.video_full %}-fluid p-0{% endif %}">
            <div class="row no-gutters">
                <div class="col">
                    <div class="js-video-home embed-responsive embed-responsive-16by9">
                        <div class="js-play-button video-player">
                            <div class="video-player-icon">
                                {% include "snipplets/svg/play-circle.tpl" with {svg_custom_class: "icon-inline icon-2x svg-icon-invert"} %}
                            </div>
                        </div>
                        <div class="js-video-image">
                            <img data-src="" class="lazyload js-lazy-loading img-fluid video-image" alt="{{ 'Video de' | translate }} {{ store.name }}">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
{% endif %}