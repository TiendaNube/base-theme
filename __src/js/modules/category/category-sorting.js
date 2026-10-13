// Ordering of the category grid. Two entry points share one mechanism (sort_by in the URL + reload):
// - the desktop dropdown in the title row (.js-category-sorting);
// - the "Ordenar:" chips of the mobile filter panel (snipplets/grid/sort-by.tpl, Fibery 237).
// The chips live in .js-category-filter-content, which the gaius modal copies by innerHTML, so the
// option click is delegated on document instead of bound per element.
const applySort = (sortValue) => {
  if (!sortValue) return;
  const url = new URL(window.location.href);
  url.searchParams.set("sort_by", sortValue);
  window.location.href = url.toString();
};

export const categorySorting = () => {
  if (!document.querySelector(".js-category-sorting-option")) return;

  document.addEventListener("click", (e) => {
    const option = e.target.closest(".js-category-sorting-option");
    if (!option || option.getAttribute("aria-current") === "true") return;
    applySort(option.dataset.sortValue);
  });

  document.querySelectorAll(".js-category-sorting").forEach((dropdown) => {
    const trigger = dropdown.querySelector(".js-category-sorting-trigger");
    const list = dropdown.querySelector(".js-category-sorting-list");
    const icon = dropdown.querySelector(".js-category-sorting-icon");
    if (!trigger || !list) return;

    function open() {
      list.hidden = false;
      trigger.setAttribute("aria-expanded", "true");
      if (icon) icon.style.transform = "rotate(180deg)";
    }

    function close() {
      list.hidden = true;
      trigger.setAttribute("aria-expanded", "false");
      if (icon) icon.style.transform = "";
    }

    function toggle() {
      if (list.hidden) {
        open();
      } else {
        close();
      }
    }

    trigger.addEventListener("click", toggle);

    document.addEventListener("click", function (e) {
      if (!dropdown.contains(e.target)) {
        close();
      }
    });
  });
};
