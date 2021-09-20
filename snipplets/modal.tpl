{# /*============================================================================
  #Modal
==============================================================================*/

#Properties
    // ID
    // Position - Top, Right, Bottom, Left
    // Transition - Slide and Fade
    // Width - Full and Box
    // modal_form_action - For modals that has a form
    // modal_fixed_footer - For modals with fixed footer. Need to include the fixed part inside the footer


#Head
    // Block - modal_head
#Body
    // Block - modal_body
#Footer
    // Block - modal_footer

#}

{% set modal_overlay = modal_overlay | default(true) %}

<div id="{{ modal_id }}" class="js-modal {% if modal_mobile_full_screen %}js-fullscreen-modal{% endif %} modal modal-{{ modal_class }} modal-{{modal_position}} transition-{{modal_transition}} modal-{{modal_width}} transition-soft {% if modal_zindex_top %}modal-zindex-top{% endif %}" style="display: none;">
    {% if modal_form_action %}
    <form action="{{ modal_form_action }}" method="post" class="{{ modal_form_class }} {% if modal_footer and modal_fixed_footer %}modal-with-fixed-footer{% endif %}" {% if modal_form_hook %}data-store="{{ modal_form_hook }}"{% endif %}>
    {% endif %}
    {% if modal_footer and modal_fixed_footer %}
        <div class="modal-with-fixed-footer">
            <div class="modal-scrollable-area">
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
        {% if modal_footer and modal_fixed_footer %}
            </div>
        {% endif %}
    {% if modal_footer %}
            <div class="modal-footer {% if not modal_fixed_footer %}d-md-block{% endif %} {{ modal_footer_class }}">
                {% block modal_foot %}{% endblock %}
            </div>
        {% if modal_fixed_footer %}
        </div>
        {% endif %}
    {% endif %}
    {% if modal_form_action %}
    </form>
    {% endif %}
</div>

<div class="js-modal-overlay {% if modal_mobile_full_screen %}js-fullscreen-overlay{% endif %} modal-overlay {% if modal_zindex_top %}modal-zindex-top{% endif %}" data-modal-id="#{{ modal_id }}" style="display: none;"></div>