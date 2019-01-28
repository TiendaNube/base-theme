{# /*============================================================================
  #Modal
==============================================================================*/

#Properties
    // ID
    // Position - Top, Right, Bottom, Left
    // Transition - Slide and Fade
    // Width - Full and Box

#Head
    // Block - modal_head
#Body
    // Block - modal_body
#Footer
    // Block - modal_footer

#}

{% set modal_overlay = modal_overlay | default(true) %}

<div id="{{ modal_id }}" class="js-modal modal modal-{{ modal_class }} modal-{{modal_position}} transition-{{modal_transition}} modal-{{modal_width}} transition-soft" style="display: none;">
    <div class="js-modal-close modal-header">
        <span class="modal-close">
            <i class="far fa-times"></i>
        </span>
        {% block modal_head %}{% endblock %}
    </div>
    <div class="modal-body">
        {% block modal_body %}{% endblock %}
    </div>
    {% if modal_footer %}
        <div class="modal-footer d-md-block">
            {% block modal_foot %}{% endblock %}
        </div>
    {% endif %}
</div>

{% if modal_overlay %}
    <div class="js-modal-overlay js-modal-overlay-{{ modal_id }} modal-overlay" style="display: none;"></div>
{% endif %}