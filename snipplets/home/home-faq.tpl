{# FAQ - Accordion with up to 6 questions #}

{% set faq_items = [] %}

{% if settings.faq_question_1 and settings.faq_answer_1 %}
    {% set faq_items = faq_items | merge([{question: settings.faq_question_1, answer: settings.faq_answer_1}]) %}
{% endif %}
{% if settings.faq_question_2 and settings.faq_answer_2 %}
    {% set faq_items = faq_items | merge([{question: settings.faq_question_2, answer: settings.faq_answer_2}]) %}
{% endif %}
{% if settings.faq_question_3 and settings.faq_answer_3 %}
    {% set faq_items = faq_items | merge([{question: settings.faq_question_3, answer: settings.faq_answer_3}]) %}
{% endif %}
{% if settings.faq_question_4 and settings.faq_answer_4 %}
    {% set faq_items = faq_items | merge([{question: settings.faq_question_4, answer: settings.faq_answer_4}]) %}
{% endif %}
{% if settings.faq_question_5 and settings.faq_answer_5 %}
    {% set faq_items = faq_items | merge([{question: settings.faq_question_5, answer: settings.faq_answer_5}]) %}
{% endif %}
{% if settings.faq_question_6 and settings.faq_answer_6 %}
    {% set faq_items = faq_items | merge([{question: settings.faq_question_6, answer: settings.faq_answer_6}]) %}
{% endif %}

{% set has_faq = faq_items | length > 0 %}

{% set faq_bg_map = {
    'none': 'transparent',
    'primary': 'var(--primary-color)',
    'secondary': 'var(--text-color)',
    'background': 'var(--background-color)',
    'accent': 'var(--accent-color)'
} %}
{% set faq_bg_value = faq_bg_map[settings.faq_bg] | default('transparent') %}
{# "none" and "background" paint no visible block: the divider supplies the spacing, so drop the padding. #}
{% set faq_flat = settings.faq_bg == 'none' or settings.faq_bg == 'background' or not settings.faq_bg %}

{% if has_faq %}
<section class="section-faq px-4 md:px-16 lg:px-32 {{ faq_flat ? 'py-0' : 'py-8 md:py-12' }}" data-store="home-faq" style="background-color: {{ faq_bg_value }}">

    {# Title #}
    {% if settings.faq_title %}
        <div class="mb-6 md:mb-8 md:text-center">
            <h2 class="text-secondary font-heading text-[32px] md:text-[40px] font-extrabold leading-[80%]">
                {{ settings.faq_title }}
            </h2>
        </div>
    {% endif %}

    {# FAQ Accordion #}
    <div class="faq-accordion max-w-3xl mx-auto">
        <ul class="list-none m-0 p-0">
            {% for item in faq_items %}
                <li class="border-b border-secondary/20" data-faq-item>
                    <button
                        type="button"
                        class="js-faq-accordion-toggle flex w-full justify-between items-center py-4 md:py-5 bg-transparent border-0 cursor-pointer text-left text-secondary transition-colors duration-200 hover:opacity-70"
                        aria-expanded="false"
                    >
                        <span class="font-heading text-lg md:text-xl font-bold leading-[120%] pr-4">
                            {{ item.question }}
                        </span>
                        <i data-lucide="plus" class="js-icon-closed w-5 h-5 shrink-0"></i>
                        <i data-lucide="minus" class="js-icon-open w-5 h-5 shrink-0 hidden"></i>
                    </button>

                    <div class="js-faq-accordion-content overflow-hidden" hidden>
                        <div class="pb-4 md:pb-5 pr-8 text-secondary/80 font-sans text-base leading-relaxed">
                            {{ item.answer | raw }}
                        </div>
                    </div>
                </li>
            {% endfor %}
        </ul>
    </div>

</section>

{# FAQ Accordion JavaScript - uses same pattern as menu accordion #}
<script>
document.addEventListener("DOMContentLoaded", function() {
    document.addEventListener("click", function(e) {
        var toggle = e.target.closest(".js-faq-accordion-toggle");
        if (!toggle) return;

        var isExpanded = toggle.getAttribute("aria-expanded") === "true";
        var currentLi = toggle.closest("li");
        var content = currentLi ? currentLi.querySelector(".js-faq-accordion-content") : null;
        if (!content) return;

        // Toggle icons
        var iconClosed = toggle.querySelector(".js-icon-closed");
        var iconOpen = toggle.querySelector(".js-icon-open");

        if (isExpanded) {
            // Close current
            toggle.setAttribute("aria-expanded", "false");
            content.hidden = true;
            if (iconClosed) iconClosed.classList.remove("hidden");
            if (iconOpen) iconOpen.classList.add("hidden");
        } else {
            // Close all other items first (optional - remove this block for independent accordions)
            var parentUl = currentLi.parentElement;
            if (parentUl) {
                parentUl.querySelectorAll(":scope > li").forEach(function(li) {
                    if (li === currentLi) return;
                    var siblingToggle = li.querySelector(".js-faq-accordion-toggle");
                    var siblingContent = li.querySelector(".js-faq-accordion-content");
                    if (siblingToggle && siblingContent) {
                        siblingToggle.setAttribute("aria-expanded", "false");
                        siblingContent.hidden = true;
                        var siblingIconClosed = siblingToggle.querySelector(".js-icon-closed");
                        var siblingIconOpen = siblingToggle.querySelector(".js-icon-open");
                        if (siblingIconClosed) siblingIconClosed.classList.remove("hidden");
                        if (siblingIconOpen) siblingIconOpen.classList.add("hidden");
                    }
                });
            }

            // Open current
            toggle.setAttribute("aria-expanded", "true");
            content.hidden = false;
            if (iconClosed) iconClosed.classList.add("hidden");
            if (iconOpen) iconOpen.classList.remove("hidden");

            // Reinitialize Lucide icons if available
            if (typeof lucide !== "undefined" && lucide.createIcons) {
                lucide.createIcons();
            }
        }
    });
});
</script>
{% endif %}
