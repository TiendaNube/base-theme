{% if settings.welcome_message %}
    <section class="section-welcome-home">
        <div class="container">
            <div class="row">
                <div class="col-md-8 offset-md-2">
                    <h2 class="welcome-title">{{ settings.welcome_message }}</h2>
                    {% if settings.welcome_text %}
                        <p class="welcome-text">{{ settings.welcome_text }}</p>
                    {% endif %}
                </div>
            </div>
        </div>
    </section>
{% endif %}