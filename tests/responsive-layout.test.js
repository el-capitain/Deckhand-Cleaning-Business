const assert = require("assert");
const fs = require("fs");
const path = require("path");

const root = path.join(__dirname, "..");
const css = fs.readFileSync(path.join(root, "styles.css"), "utf8");
const html = fs.readFileSync(path.join(root, "index.html"), "utf8");

function compact(value) {
  return value.replace(/\s+/g, " ").trim();
}

function rule(selector) {
  const escapedSelector = selector.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const match = css.match(new RegExp(`${escapedSelector}\\s*\\{([^}]*)\\}`, "m"));

  assert.ok(match, `${selector} rule is missing`);
  return compact(match[1]);
}

function mediaRule(query, selector) {
  const mediaStart = css.indexOf(query);
  assert.notStrictEqual(mediaStart, -1, `${query} media query is missing`);

  const nextMedia = css.indexOf("@media", mediaStart + query.length);
  const mediaBlock = css.slice(mediaStart, nextMedia === -1 ? undefined : nextMedia);
  const escapedSelector = selector.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const match = mediaBlock.match(new RegExp(`${escapedSelector}\\s*\\{([^}]*)\\}`, "m"));

  assert.ok(match, `${selector} rule is missing inside ${query}`);
  return compact(match[1]);
}

function assertIncludes(source, expected, message) {
  assert.ok(source.includes(expected), message || `expected CSS to include ${expected}`);
}

function assertNoIncludes(source, unexpected, message) {
  assert.ok(!source.includes(unexpected), message || `expected CSS not to include ${unexpected}`);
}

assertIncludes(html, '<meta name="viewport" content="width=device-width, initial-scale=1">');
assert.ok(!/font-size:\s*[^;]*vw/.test(css), "font sizes must not scale directly with viewport width");

{
  const nav = rule(".nav");
  const brand = rule(".brand");
  const navActions = rule(".nav-actions");
  const navCta = rule(".nav-cta");

  assertIncludes(nav, "min-width: 0", "header row must allow children to shrink safely");
  assertIncludes(brand, "max-width: clamp(8rem, 44vw, 18rem)", "brand needs a bounded width on narrow screens");
  assertIncludes(brand, "overflow: hidden", "brand must not collide with header controls");
  assertIncludes(brand, "text-overflow: ellipsis", "brand needs a visible overflow fallback");
  assertIncludes(brand, "white-space: nowrap", "brand should keep the header height stable");
  assertIncludes(navActions, "flex: 0 0 auto", "header controls need stable sizing");
  assertIncludes(navActions, "min-width: max-content", "header controls must not collapse into text");
  assertIncludes(navCta, "max-width: 32vw", "header CTA needs a narrow-screen width guard");
  assertIncludes(navCta, "min-width: 5.75rem", "header CTA needs a stable minimum width");
  assertIncludes(navCta, "overflow: hidden", "header CTA must not push beyond the viewport");
  assertIncludes(navCta, "text-overflow: ellipsis", "header CTA needs an overflow fallback");
  assertIncludes(navCta, "white-space: nowrap", "header CTA should keep the header height stable");
}

{
  const sharedLayoutRule = rule(".hero > *,\n.section__intro > *,\n.why__intro > *,\n.split > *,\n.area-section > *,\n.pricing-section__intro > *");
  const textRule = rule("h1,\nh2,\nh3,\np,\nli");
  const actions = rule(".button,\n.contact-links a");

  assertIncludes(sharedLayoutRule, "min-width: 0", "grid/flex children need a shrink guard");
  assertIncludes(textRule, "overflow-wrap: anywhere", "long copy must wrap instead of overlapping");
  assertIncludes(actions, "max-width: 100%", "action links must stay inside their containers");
  assertIncludes(actions, "min-width: 0", "action links need a shrink guard");
  assertIncludes(actions, "min-inline-size: min(100%, 9.5rem)", "buttons need stable responsive width");
  assertIncludes(actions, "min-height: 48px", "buttons need stable touch height");
  assertIncludes(actions, "overflow-wrap: anywhere", "long contact labels must wrap safely");
}

{
  const hero = rule(".hero");
  const heroImage = rule(".hero__media img");
  const heroImageTablet = mediaRule("@media (max-width: 1040px)", ".hero__media img");
  const serviceImage = rule(".service-visuals img");

  assertIncludes(hero, "grid-template-columns: minmax(0, 1fr) minmax(320px, 0.9fr)");
  assertIncludes(heroImage, "aspect-ratio: 4 / 5", "desktop hero image needs a stable ratio");
  assertIncludes(heroImageTablet, "aspect-ratio: 16 / 11", "tablet/mobile hero image needs a stable ratio");
  assertIncludes(serviceImage, "aspect-ratio: 3 / 2", "service images need stable dimensions");
}

{
  const serviceCard = rule(".service-card");
  const whyPoint = rule(".why-point");
  const pricingCard = rule(".pricing-card");
  const stepTile = rule(".steps li");
  const mobileServiceCard = mediaRule("@media (max-width: 600px)", ".service-card");
  const mobileWhyPoint = mediaRule("@media (max-width: 600px)", ".why-point");
  const mobilePricingCard = mediaRule("@media (max-width: 600px)", ".pricing-card");
  const mobileStepTile = mediaRule("@media (max-width: 600px)", ".steps li");

  assertIncludes(serviceCard, "min-height: 12rem", "service cards need a stable desktop minimum");
  assertIncludes(whyPoint, "min-height: 14.5rem", "proof cards need a stable desktop minimum");
  assertIncludes(pricingCard, "min-height: 13.75rem", "pricing cards need a stable desktop minimum");
  assertIncludes(stepTile, "min-height: 8.5rem", "step tiles need a stable desktop minimum");
  assertIncludes(mobileServiceCard, "min-height: 10.5rem", "service cards need a stable mobile minimum");
  assertIncludes(mobileWhyPoint, "min-height: 10.5rem", "proof cards need a stable mobile minimum");
  assertIncludes(mobilePricingCard, "min-height: 10.5rem", "pricing cards need a stable mobile minimum");
  assertIncludes(mobileStepTile, "min-height: 6rem", "step tiles need a stable mobile minimum");
  assertNoIncludes(css, "min-height: 0", "fixed-format tiles must not drop to unstable zero-height minimums");
}

{
  const narrowBrand = mediaRule("@media (max-width: 360px)", ".brand");
  const narrowCta = mediaRule("@media (max-width: 360px)", ".nav-cta");

  assertIncludes(narrowBrand, "max-width: 39vw", "very narrow phones need a stricter brand width");
  assertIncludes(narrowCta, "min-width: 4.85rem", "very narrow phones need a compact stable CTA");
}
