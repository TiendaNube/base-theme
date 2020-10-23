<div class="nav-primary">
    <ul class="nav-list" data-store="navigation">
        {% snipplet "navigation/navigation-nav-list.tpl" %}
    </ul>
</div>

<div class="nav-secondary">
    {% if languages | length > 1 %}
        <div class="languages">
            {% for language in languages %}
                {% set class = language.active ? "" : "opacity-50" %}
                <a href="{{ language.url }}" class="{{ class }}">
                    <img class="lazyload" src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ language.country | flag_url }}" alt="{{ language.name }}" />
                </a>
            {% endfor %}
        </div>
    {% endif %}
    <ul class="nav-account" data-store="account-links">
        {% if not customer %}
            {% if 'mandatory' not in store.customer_accounts %}
            <li class="nav-accounts-item">{{ "Crear cuenta" | translate | a_tag(store.customer_register_url, '', 'nav-accounts-link') }}</li>
            {% endif %}
            <li class="nav-accounts-item">{{ "Iniciar sesión" | translate | a_tag(store.customer_login_url, '', 'nav-accounts-link') }}</li>
        {% else %}
            <li class="nav-accounts-item">{{ "Mi cuenta" | translate | a_tag(store.customer_home_url, '', 'nav-accounts-link') }}</li>
            <li class="nav-accounts-item">{{ "Cerrar sesión" | translate | a_tag(store.customer_logout_url, '', 'nav-accounts-link') }}</li>
        {% endif %}
    </ul>
</div>