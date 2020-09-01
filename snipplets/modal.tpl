{# /*============================================================================
  #Modal
==============================================================================*/

#Properties
    // ID
    // Position - Top, Right, Bottom, Left
    // Transition - Slide and Fade
    // Width - Full and Box
    // modal_form_action - For modals that has a form


#Head
    // Block - modal_head
#Body
    // Block - modal_body
#Footer
    // Block - modal_footer

#}

{% set modal_overlay = modal_overlay | default(true) %}

<div id="{{ modal_id }}" class="js-modal {% if modal_mobile_full_screen %}js-fullscreen-modal{% endif %} modal modal-{{ modal_class }} modal-{{modal_position}} transition-{{modal_transition}} modal-{{modal_width}} transition-soft" style="display: none;">
    {% if modal_form_action %}
    <form action="{{ modal_form_action }}" method="post" class="{{ modal_form_class }}" {% if modal_form_hook %}data-store="{{ modal_form_hook }}"{% endif %}>
    {% endif %}
    <div class="js-modal-close {% if modal_mobile_full_screen %}js-fullscreen-modal-close{% endif %} modal-header">
        <span class="modal-close">
            {% include "snipplets/svg/times.tpl" with {svg_custom_class: "icon-inline svg-icon-text"} %}
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
    {% if modal_form_action %}
    </form>
    {% endif %}
</div>