(function () {
  const toggle = document.querySelector(".nav-toggle");
  const navLinks = document.querySelector("#nav-links");
  const desktopNavigation = window.matchMedia
    ? window.matchMedia("(min-width: 1041px)")
    : null;
  const reducedMotion = window.matchMedia
    ? window.matchMedia("(prefers-reduced-motion: reduce)")
    : null;

  function prefersReducedMotion() {
    return reducedMotion ? reducedMotion.matches : false;
  }

  function setMenuOpen(isOpen) {
    if (!toggle || !navLinks) {
      return;
    }

    toggle.setAttribute("aria-expanded", String(isOpen));
    navLinks.classList.toggle("is-open", isOpen);
    document.body.classList.toggle("nav-open", isOpen);
  }

  function closeMenu() {
    setMenuOpen(false);
  }

  function getAnchorTarget(hash) {
    if (!hash || hash === "#") {
      return null;
    }

    try {
      return document.querySelector(hash);
    } catch (error) {
      return null;
    }
  }

  function focusAnchorTarget(target) {
    if (!target.hasAttribute("tabindex")) {
      target.setAttribute("tabindex", "-1");
    }

    target.focus({ preventScroll: true });
  }

  if (toggle && navLinks) {
    toggle.addEventListener("click", function () {
      const isOpen = toggle.getAttribute("aria-expanded") === "true";
      setMenuOpen(!isOpen);
    });

    navLinks.addEventListener("click", function (event) {
      if (event.target instanceof HTMLAnchorElement) {
        closeMenu();
      }
    });
  }

  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
      closeMenu();
    }
  });

  document.querySelectorAll('a[href^="#"]').forEach(function (link) {
    link.addEventListener("click", function (event) {
      const target = getAnchorTarget(link.hash);

      if (!target) {
        return;
      }

      event.preventDefault();
      closeMenu();
      focusAnchorTarget(target);
      target.scrollIntoView({
        behavior: prefersReducedMotion() ? "auto" : "smooth",
        block: "start"
      });

      if (window.history && window.history.pushState) {
        window.history.pushState(null, "", link.hash);
      } else {
        window.location.hash = link.hash;
      }
    });
  });

  if (!desktopNavigation) {
    return;
  }

  function handleDesktopNavigation(event) {
    if (event.matches) {
      closeMenu();
    }
  }

  if (desktopNavigation.addEventListener) {
    desktopNavigation.addEventListener("change", handleDesktopNavigation);
  } else if (desktopNavigation.addListener) {
    desktopNavigation.addListener(handleDesktopNavigation);
  }
})();
