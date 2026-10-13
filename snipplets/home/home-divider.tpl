{# Section divider (Figma seedDivider 97:4194 / 82:3296, whiteDivider 52:190 / 82:3108).
   Params:
   - type: 'seed' (4 centered seeds, 64px tall) | 'white' (empty spacer on bg-bg). Default 'white'.
   The white divider is the TOTAL gap between two sections (64px, mobile and desktop; Figma's 40px
   desktop was ignored by owner decision), so the neighbouring sections drop their own padding. #}
{% set divider_height = 'h-16' %}
{% if type == 'seed' %}
<div class="{{ divider_height }} bg-bg flex items-center justify-center text-secondary" data-store="home-divider-seed" role="presentation">
    <svg class="w-9 h-auto" aria-hidden="true" width="23" height="16" viewBox="0 0 23 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M2.36204 5.32905C0.573932 4.88216 -0.316928 3.57786 0.102425 1.8844C0.436631 0.537335 1.56165 -0.035703 2.7601 0.00171553C4.05861 0.0423414 5.02823 0.895484 5.50293 2.18054C5.76157 2.88081 6.06065 4.17121 6.36931 5.39213C6.48426 5.84542 6.06384 6.25703 5.60936 6.1437C4.85687 5.95875 3.04109 5.49904 2.36204 5.32905Z" fill="currentColor"/>
                <path d="M8.26385 13.6274C7.81895 15.4235 6.52045 16.3183 4.83558 15.8971C3.49344 15.5614 2.92401 14.4314 2.9602 13.2276C3.00065 11.9233 3.85 10.9493 5.12934 10.4725C5.82649 10.2127 7.11116 9.91229 8.32665 9.60225C8.77793 9.48678 9.1877 9.90908 9.07488 10.3656C8.89075 11.1214 8.43308 12.9453 8.26385 13.6274Z" fill="currentColor"/>
                <path d="M20.638 5.32905C22.4261 4.88216 23.3169 3.57786 22.8976 1.88547C22.5634 0.537335 21.4384 -0.035703 20.2399 0.00171553C18.9414 0.0423414 17.9718 0.895484 17.4971 2.18054C17.2384 2.88081 16.9394 4.17121 16.6307 5.39213C16.5157 5.84542 16.9362 6.25703 17.3906 6.1437C18.1431 5.95875 19.9589 5.49904 20.638 5.32905Z" fill="currentColor"/>
                <path d="M14.7362 13.6274C15.1811 15.4235 16.4796 16.3183 18.1644 15.8971C19.5066 15.5614 20.076 14.4314 20.0398 13.2276C19.9994 11.9233 19.15 10.9493 17.8707 10.4725C17.1735 10.2127 15.8888 9.91229 14.6734 9.60225C14.2221 9.48678 13.8123 9.90908 13.9251 10.3656C14.1093 11.1214 14.5669 12.9453 14.7362 13.6274Z" fill="currentColor"/>
            </svg>
</div>
{% else %}
<div class="{{ divider_height }} bg-bg" data-store="home-divider-white" role="presentation" aria-hidden="true"></div>
{% endif %}
