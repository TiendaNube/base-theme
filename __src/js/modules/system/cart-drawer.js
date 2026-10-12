export const cartDrawerSystem = () => {
  const drawer = document.querySelector(".js-cart-drawer");
  if (!drawer) return;

  let isOpen = false;

  const backdrop = drawer.querySelector(".js-cart-drawer-backdrop");
  const closeBtn = drawer.querySelector(".js-cart-drawer-close");
  const panel = drawer.querySelector(".js-cart-drawer-panel");

  const applyDesktopOffset = () => {
    if (!panel) return;
    if (window.innerWidth >= 768) {
      const header = document.querySelector(".js-new-header");
      const headerHeight = header ? header.offsetHeight : 0;
      panel.style.top = headerHeight + "px";
      panel.style.height = "calc(100% - " + headerHeight + "px)";
    } else {
      panel.style.top = "";
      panel.style.height = "";
    }
  };

  let resizeTimer = null;
  const onResize = () => {
    if (!isOpen) return;
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(applyDesktopOffset, 100);
  };

  window.addEventListener("resize", onResize);

  const openDrawer = () => {
    if (isOpen) return;
    isOpen = true;

    // Capture header height BEFORE body lock changes scroll/header state
    const preHeaderHeight = (() => {
      if (!panel || window.innerWidth < 768) return 0;
      const header = document.querySelector(".js-new-header");
      return header ? header.offsetHeight : 0;
    })();

    const scrollPos = window.scrollY;

    window.setHeaderMenuActive?.(true);

    drawer.dataset.state = "open";

    document.body.style.overflow = "hidden";
    document.documentElement.style.overflow = "hidden";
    document.body.style.position = "fixed";
    document.body.style.width = "100%";
    document.body.style.top = "-" + scrollPos + "px";

    // Apply pre-calculated offset (avoids wrong header height after body lock)
    if (panel && window.innerWidth >= 768) {
      panel.style.top = preHeaderHeight + "px";
      panel.style.height = "calc(100% - " + preHeaderHeight + "px)";
    } else if (panel) {
      panel.style.top = "";
      panel.style.height = "";
    }

    refreshCartIfStale();
  };

  const closeDrawer = () => {
    if (!isOpen) return;
    isOpen = false;
    drawer.dataset.state = "closed";

    const scrollY = Math.abs(parseInt(document.body.style.top || "0", 10));
    document.body.style.overflow = "";
    document.documentElement.style.overflow = "";
    document.body.style.position = "";
    document.body.style.width = "";
    document.body.style.top = "";
    window.scrollTo(0, scrollY);
    window.setHeaderMenuActive?.(false);
  };

  // Simple fetch that does NOT abort previous requests
  const fetchPage = () => {
    return fetch(window.location.pathname)
      .then((res) => {
        if (!res.ok) throw new Error("fetch failed");
        return res.text();
      })
      .then((html) => new DOMParser().parseFromString(html, "text/html"));
  };

  // Sync every `.js-cart-progress-bars` instance on the page from the remote doc.
  //
  // The bars come from the SHARED snipplet `cart/cart-drawer-progress-bars.tpl`,
  // rendered twice on a PDP: inside the drawer footer AND inside the sticky buy
  // bar. Both copies are built from the same server-side cart state, so the
  // document already fetched by `refreshCart()` carries the updated markup for
  // every instance — no extra request and no client-side reimplementation of the
  // promo rules (money format, translations, discount tiers) is needed.
  //
  // Fields are copied one by one (width / label / complete flag) instead of
  // replacing innerHTML, so the CSS width transition actually animates and the
  // one-shot `js-cart-progress-complete` animation only re-fires when a bar
  // really crosses into the completed state.
  const syncProgressBars = (doc) => {
    const localRoots = document.querySelectorAll(".js-cart-progress-bars");
    if (!localRoots.length) return;

    // The drawer copy is the canonical one; fall back to any instance.
    const remoteRoot =
      doc.querySelector(".js-cart-drawer .js-cart-progress-bars") ||
      doc.querySelector(".js-cart-progress-bars");

    let injected = false;

    localRoots.forEach((localRoot) => {
      // Server stopped rendering bars entirely (settings turned off)
      if (!remoteRoot) {
        if (localRoot.children.length) localRoot.innerHTML = "";
        return;
      }

      remoteRoot.querySelectorAll(".js-cart-progress-bar[data-progress-bar]").forEach((remoteBar) => {
        const key = remoteBar.dataset.progressBar;
        const localBar = localRoot.querySelector(".js-cart-progress-bar[data-progress-bar='" + key + "']");

        // Bar exists remotely but not locally — clone the server markup as-is
        if (!localBar) {
          localRoot.appendChild(document.importNode(remoteBar, true));
          injected = true;
          return;
        }

        const remoteLabel = remoteBar.querySelector(".js-cart-progress-label");
        const localLabel = localBar.querySelector(".js-cart-progress-label");
        if (remoteLabel && localLabel) {
          if (localLabel.innerHTML !== remoteLabel.innerHTML) {
            localLabel.innerHTML = remoteLabel.innerHTML;
          }
          // className carries the conditional `font-medium` completed state
          if (localLabel.className !== remoteLabel.className) {
            localLabel.className = remoteLabel.className;
          }
        }

        const remoteFill = remoteBar.querySelector(".js-cart-progress-fill");
        const localFill = localBar.querySelector(".js-cart-progress-fill");
        if (remoteFill && localFill) {
          const width = remoteFill.style.width;
          if (width && localFill.style.width !== width) {
            localFill.style.width = width;
          }

          const isComplete = remoteFill.classList.contains("js-cart-progress-complete");
          if (isComplete !== localFill.classList.contains("js-cart-progress-complete")) {
            localFill.classList.toggle("js-cart-progress-complete", isComplete);
          }
        }
      });

      // Bar rendered locally but no longer server-side
      localRoot.querySelectorAll(".js-cart-progress-bar[data-progress-bar]").forEach((localBar) => {
        const key = localBar.dataset.progressBar;
        if (!remoteRoot.querySelector(".js-cart-progress-bar[data-progress-bar='" + key + "']")) {
          localBar.remove();
        }
      });
    });

    // Cloned bars still carry raw <i data-lucide="..."> placeholders
    if (injected && typeof lucide !== "undefined") lucide.createIcons();
  };

  // Update footer, badge, and empty state from remote doc
  const syncMeta = (doc) => {
    const remoteDrawer = doc.querySelector(".js-cart-drawer");
    if (!remoteDrawer) return;

    // Footer (subtotal + CTA)
    const remoteFooter = remoteDrawer.querySelector(".js-cart-drawer-footer");
    const localFooter = drawer.querySelector(".js-cart-drawer-footer");
    if (remoteFooter && localFooter) {
      localFooter.innerHTML = remoteFooter.innerHTML;
      localFooter.style.display = remoteFooter.style.display;
    }

    // Empty state
    const remoteEmpty = remoteDrawer.querySelector(".js-empty-ajax-cart");
    const localEmpty = drawer.querySelector(".js-empty-ajax-cart");
    if (remoteEmpty && localEmpty) {
      localEmpty.style.display = remoteEmpty.style.display;
      localEmpty.innerHTML = remoteEmpty.innerHTML;
    }

    // Header badge (desktop)
    const remoteWidget = doc.querySelector(".js-cart-widget-amount");
    const localWidget = document.querySelector(".js-cart-widget-amount");
    if (remoteWidget && localWidget && localWidget.textContent !== remoteWidget.textContent) {
      localWidget.textContent = remoteWidget.textContent;
    }
    // Our own write is not a platform cart mutation — drop it so the badge
    // observer below does not mark the cart dirty again.
    badgeObserver?.takeRecords();

    // Header badge (mobile)
    const localBadge = document.querySelector(".js-cart-widget-badge");
    if (localBadge && remoteWidget) {
      const countText = remoteWidget.textContent.replace(/\D/g, "");
      const count = parseInt(countText, 10) || 0;
      if (count > 0) {
        localBadge.textContent = count;
        localBadge.hidden = false;
      } else {
        localBadge.hidden = true;
      }
    }

    // Runs AFTER the footer swap above (which already re-rendered the drawer's
    // own copy) so every remaining instance — notably the PDP sticky buy bar —
    // ends up on the same cart state.
    syncProgressBars(doc);

    if (typeof lucide !== "undefined") lucide.createIcons();
  };

  // Detect items present locally but missing from remote (removed by backend due to stock).
  // Items the shopper removed (`data-removing`) are expected to be gone and are skipped,
  // otherwise a sync landing before the platform drops them from the DOM would announce
  // them as "out of stock".
  const detectRemovedItems = (localList, remoteDoc) => {
    const localItems = localList.querySelectorAll(".js-cart-item[data-item-id]:not([data-removing])");
    const remoteDrawer = remoteDoc.querySelector(".js-cart-drawer");
    const remoteIds = new Set();
    if (remoteDrawer) {
      remoteDrawer.querySelectorAll(".js-cart-item[data-item-id]").forEach((el) => {
        remoteIds.add(el.dataset.itemId);
      });
    }

    const removed = [];
    localItems.forEach((el) => {
      if (!remoteIds.has(el.dataset.itemId)) {
        removed.push({
          id: el.dataset.itemId,
          name: el.dataset.itemName || "",
          element: el,
        });
      }
    });
    return removed;
  };

  // Animate out removed items (same pattern as the manual removal below)
  const animateRemovedItems = (items) => {
    return new Promise((resolve) => {
      if (items.length === 0) return resolve();

      items.forEach((item) => {
        const el = item.element;
        const h = el.offsetHeight;
        el.style.overflow = "hidden";
        el.style.maxHeight = h + "px";
        el.style.transition = "opacity 0.2s ease-out, transform 0.2s ease-out";
        el.style.opacity = "0";
        el.style.transform = "translateX(40px)";

        setTimeout(() => {
          el.style.transition = "max-height 0.25s ease-in-out, padding 0.25s ease-in-out, border-width 0.25s ease-in-out";
          el.style.maxHeight = "0";
          el.style.paddingTop = "0";
          el.style.paddingBottom = "0";
          el.style.borderWidth = "0";
          el.style.marginTop = "0";
          el.style.marginBottom = "0";
        }, 200);
      });

      setTimeout(resolve, 450);
    });
  };

  // Cart freshness. Every known cart mutation bumps `cartVersion`; a refresh
  // records the version it started from and, on success, promotes it to
  // `syncedVersion`. Opening the drawer only refetches when they differ, so a
  // plain open/close does not pay for a 600 KB page fetch.
  let cartVersion = 0;
  let syncedVersion = 0;
  let inflightVersion = 0;

  const markCartDirty = () => {
    cartVersion++;
  };

  let isRefreshing = false;
  let refreshQueued = false;

  // Ends the in-flight refresh. A refresh requested while another was running
  // (two fast add-to-cart clicks) is replayed once here, otherwise the second
  // cart state would never reach the progress bars.
  const endRefresh = (ok) => {
    isRefreshing = false;
    if (ok) syncedVersion = inflightVersion;
    if (refreshQueued) {
      refreshQueued = false;
      refreshCart();
    }
  };

  // Full refresh: replaces items list + meta
  const refreshCart = () => {
    if (isRefreshing) {
      refreshQueued = true;
      return;
    }
    isRefreshing = true;
    inflightVersion = cartVersion;

    fetchPage()
      .then((doc) => {
        const remoteDrawer = doc && doc.querySelector(".js-cart-drawer");
        const remoteList = remoteDrawer && remoteDrawer.querySelector(".js-ajax-cart-list");
        const localList = drawer.querySelector(".js-ajax-cart-list");
        if (!remoteList || !localList) {
          endRefresh(false);
          return;
        }

        const removedItems = detectRemovedItems(localList, doc);

        if (removedItems.length > 0) {
          // Animate out removed items, then replace HTML and notify user
          animateRemovedItems(removedItems).then(() => {
            localList.innerHTML = remoteList.innerHTML;
            syncMeta(doc);
            endRefresh(true);

            // Toast feedback
            if (removedItems.length === 1) {
              window.showToast?.({
                message: "\"" + removedItems[0].name + "\" foi removido do carrinho por estar esgotado",
                icon: "alert-circle",
              });
            } else {
              window.showToast?.({
                message: removedItems.length + " produtos foram removidos do carrinho por estarem esgotados",
                icon: "alert-circle",
              });
            }
          });
        } else {
          // No items removed — direct replacement (current behavior)
          localList.innerHTML = remoteList.innerHTML;
          syncMeta(doc);
          endRefresh(true);
        }
      })
      .catch(() => {
        endRefresh(false);
      });
  };

  // Drawer open: skip the refetch when nothing changed since the last sync
  // (or since the one already in flight started).
  const refreshCartIfStale = () => {
    const base = isRefreshing ? inflightVersion : syncedVersion;
    if (cartVersion !== base) refreshCart();
  };

  // ---------------------------------------------------------------------------
  // Sync after platform cart requests (+/−, typed quantity, remove).
  //
  // LS.plusQuantity / LS.minusQuantity / LS.changeQuantity / LS.removeItem fire
  // their own AJAX request and expose no completion hook. Instead of guessing
  // with a fixed delay, the drawer refetches as soon as that request is over:
  //   1. PerformanceObserver("resource") reports the end of any same-origin
  //      fetch/XHR under `/cart/…` (e.g. POST /cart/update/), whatever library
  //      the platform uses to send it — no LS.* call, no monkey-patching.
  //   2. The platform rewrites `.js-cart-widget-amount` from that same response
  //      (badge observer below) — a second signal in case (1) is unavailable.
  //   3. A fallback timer guarantees a sync even if neither signal arrives.
  // Signals are coalesced by a short debounce so a burst of clicks ends in one
  // fetch shortly after the LAST platform request completes.
  // ---------------------------------------------------------------------------
  const SYNC_DEBOUNCE_MS = 200;
  const SYNC_FALLBACK_MS = 2500;

  let syncDebounceTimer = null;
  let syncFallbackTimer = null;
  let pendingPlatformRequests = 0;

  const scheduleSync = () => {
    clearTimeout(syncDebounceTimer);
    syncDebounceTimer = setTimeout(() => {
      syncDebounceTimer = null;
      refreshCart();
    }, SYNC_DEBOUNCE_MS);
  };

  // Called right before/after the drawer hands a mutation to the platform.
  const awaitPlatformRequest = () => {
    markCartDirty();
    pendingPlatformRequests++;
    clearTimeout(syncFallbackTimer);
    syncFallbackTimer = setTimeout(() => {
      syncFallbackTimer = null;
      pendingPlatformRequests = 0;
      scheduleSync();
    }, SYNC_FALLBACK_MS);
  };

  // A platform cart request finished (or its DOM side effects landed).
  const onPlatformCartChange = (isRequestEnd) => {
    markCartDirty();
    if (isRequestEnd && pendingPlatformRequests > 0) pendingPlatformRequests--;
    if (pendingPlatformRequests === 0) {
      clearTimeout(syncFallbackTimer);
      syncFallbackTimer = null;
    }
    // Drawer closed and nothing pending: stay dirty, the next open refetches.
    if (isOpen || syncFallbackTimer) scheduleSync();
  };

  const isPlatformCartRequest = (entry) => {
    if (entry.initiatorType !== "xmlhttprequest" && entry.initiatorType !== "fetch") return false;
    let url;
    try {
      url = new URL(entry.name, window.location.href);
    } catch (e) {
      return false;
    }
    if (url.origin !== window.location.origin) return false;
    // Our own refresh GETs the current page — never treat it as a mutation.
    if (url.pathname === window.location.pathname) return false;
    return /\/cart\/[^/]+/.test(url.pathname);
  };

  if (typeof PerformanceObserver !== "undefined") {
    try {
      const requestObserver = new PerformanceObserver((list) => {
        list.getEntries().forEach((entry) => {
          if (isPlatformCartRequest(entry)) onPlatformCartChange(true);
        });
      });
      requestObserver.observe({ type: "resource" });
    } catch (e) {
      // Unsupported entry type — badge observer + fallback timer still apply.
    }
  }

  // Event: backdrop click
  if (backdrop) backdrop.addEventListener("click", closeDrawer);

  // Event: close button
  if (closeBtn) closeBtn.addEventListener("click", closeDrawer);

  // Event: toggle buttons
  document.addEventListener("click", (e) => {
    const toggle = e.target.closest(".js-cart-drawer-toggle");
    if (!toggle) return;
    e.preventDefault();
    isOpen ? closeDrawer() : openDrawer();
  });

  // Event: Escape key
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && isOpen) closeDrawer();
  });

  // The cart may have changed elsewhere (another tab, page restored from the
  // back/forward cache) — force the next open to refetch.
  document.addEventListener("visibilitychange", () => {
    if (document.visibilityState === "visible") markCartDirty();
  });
  window.addEventListener("pageshow", (e) => {
    if (e.persisted) markCartDirty();
  });

  // Event: animated item removal
  drawer.addEventListener("click", (e) => {
    const removeBtn = e.target.closest(".js-cart-remove-btn");
    if (!removeBtn) return;

    const itemId = removeBtn.dataset.removeItemId;
    if (!itemId) return;

    const cartItem = removeBtn.closest(".js-cart-item");
    if (!cartItem) {
      awaitPlatformRequest();
      LS.removeItem(itemId, true);
      return;
    }

    // Prevent double-click
    if (cartItem.dataset.removing) return;
    cartItem.dataset.removing = "true";

    // Fire server removal in background; the sync starts when it completes
    awaitPlatformRequest();
    LS.removeItem(itemId, true);

    // Animate: fade + slide right
    const h = cartItem.offsetHeight;
    cartItem.style.overflow = "hidden";
    cartItem.style.maxHeight = h + "px";
    cartItem.style.transition = "opacity 0.2s ease-out, transform 0.2s ease-out";
    cartItem.style.opacity = "0";
    cartItem.style.transform = "translateX(40px)";

    // After fade, collapse height
    setTimeout(() => {
      cartItem.style.transition = "max-height 0.25s ease-in-out, padding 0.25s ease-in-out, border-width 0.25s ease-in-out";
      cartItem.style.maxHeight = "0";
      cartItem.style.paddingTop = "0";
      cartItem.style.paddingBottom = "0";
      cartItem.style.borderWidth = "0";
      cartItem.style.marginTop = "0";
      cartItem.style.marginBottom = "0";
    }, 200);

    // After collapse, hide item visually but keep in DOM so platform JS
    // can still reference it during its AJAX callback (avoids null .style errors).
    // refreshCart() replaces the full list HTML once the platform request ends.
    setTimeout(() => {
      if (!cartItem.isConnected) return; // list already re-rendered by a sync
      cartItem.style.display = "none";

      const remaining = drawer.querySelectorAll(".js-cart-item:not([style*='display: none'])");
      if (remaining.length === 0) {
        const emptyState = drawer.querySelector(".js-empty-ajax-cart");
        if (emptyState) emptyState.style.display = "";
        const footer = drawer.querySelector(".js-cart-drawer-footer");
        if (footer) footer.style.display = "none";
      }
    }, 450);
  });

  // +/- buttons (inline onclick → LS.plusQuantity/LS.minusQuantity)
  drawer.addEventListener("click", (e) => {
    if (!e.target.closest(".js-cart-quantity-btn")) return;
    awaitPlatformRequest();
  });

  // Typed quantity: store.js.tpl binds "focusout" on .js-cart-quantity-input and
  // fires LS.changeQuantity (or LS.removeItem after a confirm when the value is 0).
  // The request end is what triggers the sync; this only arms the fallback.
  drawer.addEventListener("focusout", (e) => {
    const input = e.target.closest && e.target.closest(".js-cart-quantity-input");
    if (!input) return;
    awaitPlatformRequest();
  });

  // Observe platform updates to desktop badge: mirror to mobile badge and treat
  // it as a "cart changed" signal (the platform rewrites it from the response of
  // every cart request). Writes made by syncMeta() are discarded via takeRecords().
  const desktopBadge = document.querySelector(".js-cart-widget-amount");
  const mobileBadge = document.querySelector(".js-cart-widget-badge");
  let badgeObserver = null;
  if (desktopBadge) {
    badgeObserver = new MutationObserver(() => {
      if (mobileBadge) {
        const countText = desktopBadge.textContent.replace(/\D/g, "");
        const count = parseInt(countText, 10) || 0;
        if (count > 0) {
          mobileBadge.textContent = count;
          mobileBadge.hidden = false;
        } else {
          mobileBadge.hidden = true;
        }
      }
      onPlatformCartChange(false);
    });
    badgeObserver.observe(desktopBadge, { childList: true, characterData: true, subtree: true });
  }

  // Register window globals
  window.openCartDrawer = openDrawer;
  window.closeCartDrawer = closeDrawer;
  window.onCartUpdate = () => {
    markCartDirty();
    refreshCart();
  };
};
