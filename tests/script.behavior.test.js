const assert = require("assert");
const fs = require("fs");
const path = require("path");
const vm = require("vm");

class FakeClassList {
  constructor() {
    this.classes = new Set();
  }

  add(className) {
    this.classes.add(className);
  }

  remove(className) {
    this.classes.delete(className);
  }

  toggle(className, force) {
    const shouldAdd = force === undefined ? !this.classes.has(className) : force;

    if (shouldAdd) {
      this.add(className);
    } else {
      this.remove(className);
    }
  }

  contains(className) {
    return this.classes.has(className);
  }
}

class FakeElement {
  constructor() {
    this.attributes = new Map();
    this.classList = new FakeClassList();
    this.listeners = new Map();
    this.focusCalls = [];
    this.scrollCalls = [];
  }

  addEventListener(type, handler) {
    const handlers = this.listeners.get(type) || [];
    handlers.push(handler);
    this.listeners.set(type, handlers);
  }

  dispatch(type, overrides = {}) {
    const event = {
      type,
      target: this,
      defaultPrevented: false,
      preventDefault() {
        this.defaultPrevented = true;
      },
      ...overrides
    };

    (this.listeners.get(type) || []).forEach((handler) => handler(event));
    return event;
  }

  getAttribute(name) {
    return this.attributes.has(name) ? this.attributes.get(name) : null;
  }

  hasAttribute(name) {
    return this.attributes.has(name);
  }

  setAttribute(name, value) {
    this.attributes.set(name, String(value));
  }

  focus(options) {
    this.focusCalls.push(options);
  }

  scrollIntoView(options) {
    this.scrollCalls.push(options);
  }
}

class FakeAnchorElement extends FakeElement {
  constructor(hash) {
    super();
    this.hash = hash;
  }
}

function createMediaQuery(matches = false) {
  const listeners = [];

  return {
    matches,
    addEventListener(type, handler) {
      if (type === "change") {
        listeners.push(handler);
      }
    },
    trigger(nextMatches) {
      this.matches = nextMatches;
      listeners.forEach((handler) => handler({ matches: nextMatches }));
    }
  };
}

function loadScript(options = {}) {
  const navToggle = new FakeElement();
  const navLinks = new FakeElement();
  const body = new FakeElement();
  const heroLink = new FakeAnchorElement("#hero");
  const servicesLink = new FakeAnchorElement("#services");
  const servicesSection = new FakeElement();
  const heroSection = new FakeElement();
  const desktopQuery = createMediaQuery(false);
  const reducedMotionQuery = createMediaQuery(Boolean(options.reducedMotion));
  const documentListeners = new Map();
  const historyCalls = [];

  navToggle.setAttribute("aria-expanded", "false");

  const document = {
    body,
    querySelector(selector) {
      return {
        ".nav-toggle": navToggle,
        "#nav-links": navLinks,
        "#hero": heroSection,
        "#services": servicesSection
      }[selector] || null;
    },
    querySelectorAll(selector) {
      return selector === 'a[href^="#"]' ? [heroLink, servicesLink] : [];
    },
    addEventListener(type, handler) {
      const handlers = documentListeners.get(type) || [];
      handlers.push(handler);
      documentListeners.set(type, handlers);
    },
    dispatch(type, overrides = {}) {
      (documentListeners.get(type) || []).forEach((handler) => {
        handler({ type, ...overrides });
      });
    }
  };

  const context = {
    document,
    HTMLAnchorElement: FakeAnchorElement,
    window: {
      history: {
        pushState: (...args) => historyCalls.push(args)
      },
      location: { hash: "" },
      matchMedia(query) {
        if (query === "(min-width: 1041px)") {
          return desktopQuery;
        }

        if (query === "(prefers-reduced-motion: reduce)") {
          return reducedMotionQuery;
        }

        return createMediaQuery(false);
      }
    }
  };

  const scriptPath = path.join(__dirname, "..", "script.js");
  vm.runInNewContext(fs.readFileSync(scriptPath, "utf8"), context);

  return {
    body,
    desktopQuery,
    historyCalls,
    navLinks,
    navToggle,
    servicesLink,
    servicesSection
  };
}

{
  const { body, desktopQuery, navLinks, navToggle, servicesLink } = loadScript();

  navToggle.dispatch("click");
  assert.strictEqual(navToggle.getAttribute("aria-expanded"), "true");
  assert.strictEqual(navLinks.classList.contains("is-open"), true);
  assert.strictEqual(body.classList.contains("nav-open"), true);

  navLinks.dispatch("click", { target: servicesLink });
  assert.strictEqual(navToggle.getAttribute("aria-expanded"), "false");
  assert.strictEqual(navLinks.classList.contains("is-open"), false);
  assert.strictEqual(body.classList.contains("nav-open"), false);

  navToggle.dispatch("click");
  desktopQuery.trigger(true);
  assert.strictEqual(navToggle.getAttribute("aria-expanded"), "false");
}

{
  const { body, navLinks, navToggle } = loadScript();

  navToggle.dispatch("click");
  navLinks.dispatch("click", { target: new FakeElement() });
  assert.strictEqual(navToggle.getAttribute("aria-expanded"), "true");

  navLinks.dispatch("click", { target: new FakeAnchorElement("#services") });
  assert.strictEqual(navToggle.getAttribute("aria-expanded"), "false");
  assert.strictEqual(body.classList.contains("nav-open"), false);
}

{
  const { historyCalls, servicesLink, servicesSection } = loadScript();
  const event = servicesLink.dispatch("click");

  assert.strictEqual(event.defaultPrevented, true);
  assert.strictEqual(servicesSection.focusCalls.length, 1);
  assert.strictEqual(servicesSection.focusCalls[0].preventScroll, true);
  assert.strictEqual(servicesSection.scrollCalls.length, 1);
  assert.strictEqual(servicesSection.scrollCalls[0].behavior, "smooth");
  assert.strictEqual(servicesSection.scrollCalls[0].block, "start");
  assert.strictEqual(servicesSection.getAttribute("tabindex"), "-1");
  assert.strictEqual(historyCalls[0][0], null);
  assert.strictEqual(historyCalls[0][1], "");
  assert.strictEqual(historyCalls[0][2], "#services");
}

{
  const { servicesLink, servicesSection } = loadScript({ reducedMotion: true });

  servicesLink.dispatch("click");
  assert.strictEqual(servicesSection.scrollCalls.length, 1);
  assert.strictEqual(servicesSection.scrollCalls[0].behavior, "auto");
  assert.strictEqual(servicesSection.scrollCalls[0].block, "start");
}
