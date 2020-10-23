{% if settings.video_embed %}
    <section class="section-video-home" data-store="video-home">
        <div class="container{% if settings.video_full %}-fluid p-0{% endif %}">
            <div class="row no-gutters">
                <div class="col">
                    {% include 'snipplets/video-item.tpl' %}
                </div>
            </div>
        </div>
    </section>
{% endif %}