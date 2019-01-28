{% if settings.video_embed %}
    <section class="section-video-home">
        <div class="container{% if settings.video_full %}-fluid p-0{% endif %}">
            <div class="row no-gutters">
                <div class="col">
                    <div class="js-video-home embed-responsive embed-responsive-16by9">
                        <div class="js-play-button video-player">
                            <div class="video-player-icon"><i class="far fa-2x fa-play-circle"></i></div>
                        </div>
                        <div class="js-video-image">
                            <img data-src="" class="lazyload js-lazy-loading img-fluid video-image">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
{% endif %}