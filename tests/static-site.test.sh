#!/bin/sh
set -eu

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

for path in index.html styles.css script.js CNAME README.md assets; do
  [ -e "$path" ] || fail "$path is missing"
done

[ -f tests/responsive-layout.test.js ] || fail "responsive layout regression test is missing"

grep -q '## Local Preview' README.md || fail "README local preview section is missing"
grep -q 'open index.html' README.md || fail "README direct local preview command is missing"
grep -q 'python3 -m http.server 8000' README.md || fail "README local server command is missing"
grep -q 'http://localhost:8000' README.md || fail "README local server URL is missing"
grep -q '## GitHub Pages Publishing' README.md || fail "README GitHub Pages publishing section is missing"
grep -q 'Deploy from a branch' README.md || fail "README branch deployment setting is missing"
grep -q '/ (root)' README.md || fail "README root publishing source is missing"
grep -q '## Custom Domain' README.md || fail "README custom domain section is missing"
grep -q 'CNAME' README.md || fail "README CNAME instructions are missing"
grep -q 'Custom domain' README.md || fail "README GitHub custom domain setting is missing"
grep -q 'Enforce HTTPS' README.md || fail "README HTTPS instruction is missing"
grep -q '## Placeholder Replacement' README.md || fail "README placeholder replacement section is missing"
grep -q 'hello@callthedeckhand.com.au' README.md || fail "README email placeholder note is missing"
grep -q '0400 000 000' README.md || fail "README phone placeholder note is missing"
grep -q '@callthedeckhand' README.md || fail "README Instagram placeholder note is missing"
grep -q 'assets/favicon-placeholder.svg' README.md || fail "README favicon replacement note is missing"
grep -q 'assets/deck-reset-hero.jpg' README.md || fail "README hero image replacement note is missing"
grep -q 'assets/laundry-essentials-detail.jpg' README.md || fail "README laundry and essentials image replacement note is missing"
grep -q '## Final Static QA' README.md || fail "README final static QA section is missing"
grep -q 'Last checked: 2026-05-08.' README.md || fail "README final static QA date is missing"
grep -q 'Launch blockers to clear before public launch' README.md || fail "README launch blockers list is missing"
grep -q 'placeholder phone number `0400 000 000`' README.md || fail "README phone launch blocker is missing"
grep -q 'GitHub Pages custom domain setup, DNS propagation, and `Enforce HTTPS`' README.md || fail "README domain launch blocker is missing"
grep -q 'placeholder favicon and generated launch imagery' README.md || fail "README asset launch blocker is missing"

[ -f assets/deck-detail-placeholder.svg ] || fail "deck visual placeholder is missing"
[ -f assets/favicon-placeholder.svg ] || fail "favicon placeholder is missing"
[ -f assets/deck-reset-hero.jpg ] || fail "hero deck reset image is missing"
[ -f assets/below-deck-reset.jpg ] || fail "below deck reset image is missing"
[ -f assets/sail-packaway-detail.jpg ] || fail "sail pack-away detail image is missing"
[ -f assets/laundry-essentials-detail.jpg ] || fail "laundry and essentials detail image is missing"
[ "$(tr -d '\r\n' < CNAME)" = "callthedeckhand.com.au" ] || fail "CNAME has unexpected domain"

for image in assets/deck-reset-hero.jpg assets/below-deck-reset.jpg assets/sail-packaway-detail.jpg assets/laundry-essentials-detail.jpg; do
  file "$image" | grep -q 'JPEG image data' || fail "$image is not a JPEG image"
  [ "$(wc -c < "$image")" -le 350000 ] || fail "$image is too large for the static launch site"
done

grep -q '<link rel="stylesheet" href="styles.css">' index.html || fail "stylesheet is not linked"
grep -q '<script src="script.js"></script>' index.html || fail "script is not linked"
grep -q 'assets/deck-reset-hero.jpg' index.html || fail "hero visual asset is not referenced"
grep -q 'assets/below-deck-reset.jpg' index.html || fail "below deck visual asset is not referenced"
grep -q 'assets/sail-packaway-detail.jpg' index.html || fail "sail pack-away visual asset is not referenced"
grep -q 'assets/laundry-essentials-detail.jpg' index.html || fail "laundry and essentials visual asset is not referenced"
grep -q '<link rel="canonical" href="https://callthedeckhand.com.au/">' index.html || fail "canonical URL is missing"
grep -q '<link rel="icon" href="assets/favicon-placeholder.svg" type="image/svg+xml">' index.html || fail "favicon placeholder is not linked"
grep -q '<link rel="apple-touch-icon" href="assets/favicon-placeholder.svg">' index.html || fail "apple touch icon placeholder is not linked"
grep -q '<meta name="theme-color" content="#254C45">' index.html || fail "theme color metadata is missing"
grep -q '<meta property="og:title" content="Call the Deckhand">' index.html || fail "Open Graph title is missing"
grep -q '<meta property="og:type" content="website">' index.html || fail "Open Graph type is missing"
grep -q '<meta property="og:url" content="https://callthedeckhand.com.au/">' index.html || fail "Open Graph URL is missing"
grep -q '<meta property="og:image" content="https://callthedeckhand.com.au/assets/deck-reset-hero.jpg">' index.html || fail "Open Graph image is missing"
grep -q '<meta property="og:image:alt" content="Tidy yacht deck detail in harbour light">' index.html || fail "Open Graph image alt text is missing"
grep -q 'mailto:hello@callthedeckhand.com.au' index.html || fail "email contact link is missing"
grep -q 'tel:+61400000000' index.html || fail "phone contact link is missing"

for token in \
  '--color-chalk: #f7f3ea' \
  '--color-salt-white: #fffdf8' \
  '--color-ink-navy: #111827' \
  '--color-harbour-green: #254c45' \
  '--color-brass: #b88a44' \
  '--color-signal-coral: #f26d5b' \
  '--color-weathered-blue: #6f93a5' \
  '--color-stainless-grey: #d7d2c8'; do
  grep -q -- "$token" styles.css || fail "required colour token is missing: $token"
done

grep -q -- '--font-display: Georgia, "Times New Roman", serif' styles.css || fail "display typography stack is missing"
grep -q -- '--font-body: Inter, "Avenir Next", "Helvetica Neue", Arial, sans-serif' styles.css || fail "body typography stack is missing"
grep -q -- '--space-section: clamp(4rem, 8vw, 7rem)' styles.css || fail "responsive section spacing token is missing"
grep -q -- '--gutter: clamp(1rem, 4vw, 2rem)' styles.css || fail "responsive gutter token is missing"
grep -q -- 'scroll-padding-top: calc(var(--header-height) + var(--space-sm))' styles.css || fail "anchor scroll offset is missing"
grep -q -- ':where(a, button):focus-visible' styles.css || fail "visible keyboard focus style is missing"
grep -q -- 'outline: 3px solid var(--coral)' styles.css || fail "focus outline does not use signal coral"
grep -q -- 'min-height: 48px' styles.css || fail "primary touch target sizing is missing"
grep -q -- 'min-inline-size: min(100%, 9.5rem)' styles.css || fail "responsive button width guard is missing"
grep -q -- 'text-overflow: ellipsis' styles.css || fail "narrow header overflow guard is missing"
grep -q -- '@media (max-width: 360px)' styles.css || fail "narrow mobile layout guard is missing"
grep -q -- '@media (prefers-reduced-motion: reduce)' styles.css || fail "reduced motion media query is missing"
grep -q -- 'transition-duration: 0.01ms !important' styles.css || fail "reduced motion transition override is missing"
if grep -n 'font-size:.*vw' styles.css >/dev/null; then
  fail "font sizes should not scale directly with viewport width"
fi

grep -q 'brand must not collide with header controls' tests/responsive-layout.test.js || fail "responsive test does not check header collision guards"
grep -q 'long copy must wrap instead of overlapping' tests/responsive-layout.test.js || fail "responsive test does not check text wrapping guards"
grep -q 'buttons need stable touch height' tests/responsive-layout.test.js || fail "responsive test does not check fixed control sizing"
grep -q 'desktop hero image needs a stable ratio' tests/responsive-layout.test.js || fail "responsive test does not check hero media ratio"

placeholder_block="$(sed -n '/LAUNCH PLACEHOLDERS/,/-->/p' index.html)"
[ -n "$placeholder_block" ] || fail "launch placeholders are not grouped in HTML"
printf '%s\n' "$placeholder_block" | grep -q 'https://callthedeckhand.com.au/' || fail "domain placeholder is missing from grouped launch placeholders"
printf '%s\n' "$placeholder_block" | grep -q 'hello@callthedeckhand.com.au' || fail "email placeholder is missing from grouped launch placeholders"
printf '%s\n' "$placeholder_block" | grep -q '0400 000 000' || fail "phone placeholder is missing from grouped launch placeholders"
printf '%s\n' "$placeholder_block" | grep -q '@callthedeckhand' || fail "Instagram placeholder is missing from grouped launch placeholders"
printf '%s\n' "$placeholder_block" | grep -q 'assets/favicon-placeholder.svg' || fail "favicon placeholder is missing from grouped launch placeholders"
printf '%s\n' "$placeholder_block" | grep -q 'assets/deck-reset-hero.jpg' || fail "hero image placeholder is missing from grouped launch placeholders"
printf '%s\n' "$placeholder_block" | grep -q 'assets/below-deck-reset.jpg' || fail "below deck image placeholder is missing from grouped launch placeholders"
printf '%s\n' "$placeholder_block" | grep -q 'assets/sail-packaway-detail.jpg' || fail "sail pack-away image placeholder is missing from grouped launch placeholders"
printf '%s\n' "$placeholder_block" | grep -q 'assets/laundry-essentials-detail.jpg' || fail "laundry and essentials image placeholder is missing from grouped launch placeholders"

last_section_line=0
for section in hero services why how service-area pricing about contact; do
  line="$(grep -n "<section.*id=\"$section\"" index.html | cut -d: -f1)"
  [ -n "$line" ] || fail "#$section section is missing"
  [ "$line" -gt "$last_section_line" ] || fail "#$section section is out of order"
  last_section_line="$line"
  grep -q "href=\"#$section\"" index.html || fail "#$section navigation link is missing"
done

grep -q 'aria-labelledby="hero-title"' index.html || fail "hero section lacks an accessible label"
grep -q 'aria-labelledby="services-title"' index.html || fail "services section lacks an accessible label"
grep -q 'aria-labelledby="why-title"' index.html || fail "why section lacks an accessible label"
grep -q 'aria-labelledby="how-title"' index.html || fail "how section lacks an accessible label"
grep -q 'aria-labelledby="service-area-title"' index.html || fail "service area section lacks an accessible label"
grep -q 'aria-labelledby="pricing-title"' index.html || fail "pricing section lacks an accessible label"
grep -q 'aria-labelledby="about-title"' index.html || fail "about section lacks an accessible label"
grep -q 'aria-labelledby="contact-title"' index.html || fail "contact section lacks an accessible label"
grep -q 'id="hero-title">Call the Deckhand</h1>' index.html || fail "hero title is missing"
hero_block="$(sed -n '/<section class="hero section" id="hero"/,/<\/section>/p' index.html)"
[ -n "$hero_block" ] || fail "hero section block is missing"
printf '%s\n' "$hero_block" | grep -q '<p class="eyebrow">Eastern Suburbs, Sydney</p>' || fail "hero Eastern Suburbs service-area cue is missing"
printf '%s\n' "$hero_block" | grep -q '<h1 id="hero-title">Call the Deckhand</h1>' || fail "hero business name is missing"
printf '%s\n' "$hero_block" | grep -q '<p class="hero__line">You sail. We reset the boat.</p>' || fail "hero positioning line is missing"
printf '%s\n' "$hero_block" | grep -q 'class="button button--primary" href="mailto:hello@callthedeckhand.com.au">Enquire now</a>' || fail "hero primary enquiry CTA is missing"
printf '%s\n' "$hero_block" | grep -q 'class="button button--secondary" href="#services">View services</a>' || fail "hero secondary services CTA is missing"
printf '%s\n' "$hero_block" | grep -q '<figure class="hero__media">' || fail "hero boat visual figure is missing"
printf '%s\n' "$hero_block" | grep -q 'src="assets/deck-reset-hero.jpg"' || fail "hero boat visual source is missing"
printf '%s\n' "$hero_block" | grep -q 'alt="Clean yacht deck detail with coiled line and stainless fittings in harbour light"' || fail "hero boat visual alt text is missing"
printf '%s\n' "$hero_block" | grep -q 'fetchpriority="high"' || fail "hero first-viewport image is not prioritized"
printf '%s\n' "$hero_block" | grep -q 'decoding="async"' || fail "hero image decode hint is missing"
grep -q 'grid-template-columns: minmax(0, 1fr) minmax(320px, 0.9fr)' styles.css || fail "hero editorial desktop layout is missing"
grep -q 'min-height: calc(100vh - var(--header-height))' styles.css || fail "hero first viewport sizing is missing"
grep -q '.hero__media img' styles.css || fail "hero visual styling is missing"

services_block="$(sed -n '/<section class="section section--lined" id="services"/,/<\/section>/p' index.html)"
[ -n "$services_block" ] || fail "services section block is missing"
service_cards="$(printf '%s\n' "$services_block" | grep -c '<article class="service-card')"
[ "$service_cards" -eq 6 ] || fail "services section should show six service cards"
for service in \
  'On board cleaning' \
  'Below deck cleaning' \
  'Post-sail packdown' \
  'Laundry runs' \
  'Essentials pickup' \
  'Sail pack-away'; do
  printf '%s\n' "$services_block" | grep -q "$service" || fail "services section is missing: $service"
done
printf '%s\n' "$services_block" | grep -q 'Clothing, sheets, towels' || fail "laundry service should mention clothing and sheets"
printf '%s\n' "$services_block" | grep -q 'Premium add-on' || fail "sail pack-away should be marked as premium"
printf '%s\n' "$services_block" | grep -q 'Optional sail pack-away' || fail "sail pack-away should be clearly optional"
grep -q '.service-card__type' styles.css || fail "service category labels are not styled"

why_block="$(sed -n '/<section class="section why" id="why"/,/<\/section>/p' index.html)"
[ -n "$why_block" ] || fail "why section block is missing"
why_points="$(printf '%s\n' "$why_block" | grep -c '<article class="why-point')"
[ "$why_points" -eq 5 ] || fail "why section should show five proof points"
printf '%s\n' "$why_block" | grep -q 'aria-label="Why Call the Deckhand proof points"' || fail "why proof points need an accessible group label"
for proof_point in \
  'Boat-savvy' \
  'Fast' \
  'Thorough' \
  'Smooth' \
  'Local'; do
  printf '%s\n' "$why_block" | grep -q "$proof_point" || fail "why section is missing proof point: $proof_point"
done
for required_copy in \
  'Sailing basics are already understood' \
  'Built for the tired post-sail window' \
  'The obvious bits and the sneaky bits' \
  'Reset for the next time aboard' \
  'Eastern Suburbs now. Harbour habits understood' \
  'No briefing on winches' \
  'second drink' \
  'tiny jobs everyone saw but quietly ignored' \
  'what the boat needs before anyone makes a speech'; do
  printf '%s\n' "$why_block" | grep -q "$required_copy" || fail "why section is missing required copy: $required_copy"
done
grep -q '.why-grid' styles.css || fail "why proof point grid is not styled"
grep -q '.why-point__label' styles.css || fail "why proof point labels are not styled"
grep -q '.why-point--accent' styles.css || fail "why local accent proof point is not styled"
grep -q '<header class="site-header">' index.html || fail "responsive header is missing"
grep -q '<nav class="nav" aria-label="Primary navigation">' index.html || fail "primary navigation landmark is missing"
grep -q '<button class="nav-toggle" type="button" aria-expanded="false" aria-controls="nav-links" aria-label="Toggle navigation">' index.html || fail "mobile navigation toggle is not accessible"
grep -q '<div class="nav-links" id="nav-links">' index.html || fail "anchored navigation container is missing"
grep -q '<a class="nav-cta" href="mailto:hello@callthedeckhand.com.au">Enquire</a>' index.html || fail "persistent enquiry CTA is missing from header"
grep -q 'position: sticky' styles.css || fail "header is not sticky"
grep -q '.nav-cta' styles.css || fail "header enquiry CTA is not styled"
grep -q 'flex: 0 0 auto' styles.css || fail "persistent header controls can shrink on mobile"
grep -q 'white-space: nowrap' styles.css || fail "brand can wrap into header controls"
grep -q 'max-height: calc(100dvh - var(--header-height))' styles.css || fail "mobile navigation panel is not viewport constrained"
grep -q 'display: inline-flex' styles.css || fail "header enquiry CTA touch target style is missing"
grep -q '@media (max-width: 1040px)' styles.css || fail "mobile navigation breakpoint is missing"
grep -q 'navLinks.classList.toggle("is-open", isOpen)' script.js || fail "mobile navigation open state is not wired"
grep -q 'document.body.classList.toggle("nav-open", isOpen)' script.js || fail "mobile navigation body state is not wired"
grep -q 'event.key === "Escape"' script.js || fail "mobile navigation does not close on Escape"
grep -q 'window.matchMedia("(min-width: 1041px)")' script.js || fail "mobile navigation does not reset at desktop widths"
grep -q 'window.matchMedia("(prefers-reduced-motion: reduce)")' script.js || fail "anchor scrolling does not check reduced motion preference"
grep -q 'document.querySelectorAll('\''a\[href\^="#"\]'\'')' script.js || fail "anchored links are not enhanced"
grep -q 'target.scrollIntoView' script.js || fail "smooth anchor scrolling is not wired"
grep -q 'behavior: prefersReducedMotion() ? "auto" : "smooth"' script.js || fail "anchor scrolling does not respect reduced motion"
grep -q 'target.focus({ preventScroll: true })' script.js || fail "anchor targets are not focused safely"
grep -q 'window.history.pushState' script.js || fail "anchor URL state is not preserved"

how_block="$(sed -n '/<section class="section section--compact" id="how"/,/<\/section>/p' index.html)"
[ -n "$how_block" ] || fail "how it works section block is missing"
how_steps="$(printf '%s\n' "$how_block" | grep -c '<li>')"
[ "$how_steps" -eq 4 ] || fail "how it works should have four steps"
for required_step in \
  'Send a quick enquiry with the boat, location, timing, and job list' \
  'meets the boat or arrives after docking' \
  'The boat is cleaned, reset, and packed down' \
  'Laundry or essentials are handled if requested'; do
  printf '%s\n' "$how_block" | grep -q "$required_step" || fail "how it works is missing required step: $required_step"
done

service_area_block="$(sed -n '/<section class="section section--muted area-section" id="service-area"/,/<\/section>/p' index.html)"
[ -n "$service_area_block" ] || fail "service area section block is missing"
printf '%s\n' "$service_area_block" | grep -q 'Eastern Suburbs now. Sydney Harbour next.' || fail "service area headline should follow the PRD direction"
printf '%s\n' "$service_area_block" | grep -q 'one-woman reset service' || fail "service area should carry the product overview positioning"
printf '%s\n' "$service_area_block" | grep -q 'currently operating from Sydney' || fail "service area should state the current operating area"
printf '%s\n' "$service_area_block" | grep -q 'Eastern Suburbs marina, club, and berth handovers at launch' || fail "service area launch patch is missing"
printf '%s\n' "$service_area_block" | grep -q 'Post-sail resets for local owners, race crews, and regular sailors' || fail "service area audience cue is missing"
printf '%s\n' "$service_area_block" | grep -q 'expand naturally across Sydney Harbour' || fail "service area Sydney Harbour expansion cue is missing"
printf '%s\n' "$service_area_block" | grep -q 'aria-label="Current operating base"' || fail "service area callout needs an accessible label"
printf '%s\n' "$service_area_block" | grep -q 'Eastern Suburbs, Sydney' || fail "service area current base is missing"
printf '%s\n' "$service_area_block" | grep -q 'href="mailto:hello@callthedeckhand.com.au">Check availability</a>' || fail "service area availability CTA is missing"
grep -q '.area-section' styles.css || fail "service area layout is not styled"
grep -q '.area-list' styles.css || fail "service area note list is not styled"
grep -q '.area-callout' styles.css || fail "service area callout is not styled"

pricing_block="$(sed -n '/<section class="section pricing-section" id="pricing"/,/<\/section>/p' index.html)"
[ -n "$pricing_block" ] || fail "pricing cue section block is missing"
printf '%s\n' "$pricing_block" | grep -q 'Simple resets, useful extras, and a fancy option for sails' || fail "pricing cue headline should match the PRD direction"
printf '%s\n' "$pricing_block" | grep -q 'Exact prices are not published yet' || fail "pricing cue should avoid publishing exact prices"
printf '%s\n' "$pricing_block" | grep -q 'Standard resets stay practical' || fail "pricing cue should communicate practical standard resets"
printf '%s\n' "$pricing_block" | grep -q 'Enquire with the boat size, location, timing, and job list' || fail "pricing cue enquiry inputs are missing"
if printf '%s\n' "$pricing_block" | grep -Eq '\$[0-9]|[0-9]+ ?(AUD|aud|dollars?)'; then
  fail "pricing cue should not publish exact prices"
fi
pricing_cards="$(printf '%s\n' "$pricing_block" | grep -c '<article class="pricing-card')"
[ "$pricing_cards" -eq 3 ] || fail "pricing cue should show three pricing cards"
for pricing_cue in \
  'Standard reset' \
  'Useful extras' \
  'Luxury add-on' \
  'On board cleaning, below deck cleaning, and post-sail packdown' \
  'Laundry runs for clothing and sheets' \
  'essentials pickup' \
  'Sail pack-away is available at a luxury price'; do
  printf '%s\n' "$pricing_block" | grep -q "$pricing_cue" || fail "pricing cue is missing required copy: $pricing_cue"
done
grep -q '.pricing-section' styles.css || fail "pricing cue layout is not styled"
grep -q '.pricing-grid' styles.css || fail "pricing cue grid is not styled"
grep -q '.pricing-card--accent' styles.css || fail "premium pricing cue is not styled"

about_block="$(sed -n '/<section class="section section--muted split about-section" id="about"/,/<\/section>/p' index.html)"
[ -n "$about_block" ] || fail "about section block is missing"
printf '%s\n' "$about_block" | grep -q 'One-woman, practical, and built for sailors' || fail "about headline should emphasize the one-woman launch"
printf '%s\n' "$about_block" | grep -q 'understands the rhythm of a sailing day' || fail "about section should be credible to sailors"
for about_cue in \
  'direct communication' \
  'consistent hands on the boat' \
  'proper care' \
  'clear accountability'; do
  printf '%s\n' "$about_block" | grep -q "$about_cue" || fail "about section is missing required cue: $about_cue"
done
grep -q '.about-copy' styles.css || fail "about copy is not styled"

contact_block="$(sed -n '/<section class="section contact" id="contact"/,/<\/section>/p' index.html)"
[ -n "$contact_block" ] || fail "contact section block is missing"
printf '%s\n' "$contact_block" | grep -q 'Step off. We&rsquo;ll take it from here.' || fail "contact section headline is missing"
printf '%s\n' "$contact_block" | grep -q 'Send the boat, location, timing, and reset list' || fail "contact short enquiry prompt is missing"
printf '%s\n' "$contact_block" | grep -q 'Editable contact placeholders' || fail "contact placeholders should be easy to locate in HTML"
printf '%s\n' "$contact_block" | grep -q 'href="mailto:hello@callthedeckhand.com.au"' || fail "contact email link is missing"
printf '%s\n' "$contact_block" | grep -q 'href="tel:+61400000000"' || fail "contact phone link is missing"
printf '%s\n' "$contact_block" | grep -q 'href="https://www.instagram.com/callthedeckhand/"' || fail "contact Instagram link is missing"
printf '%s\n' "$contact_block" | grep -q 'aria-label="Email Call the Deckhand"' || fail "contact email link needs an accessible label"
printf '%s\n' "$contact_block" | grep -q 'aria-label="Call the Deckhand by phone"' || fail "contact phone link needs an accessible label"
printf '%s\n' "$contact_block" | grep -q 'aria-label="Message Call the Deckhand on Instagram"' || fail "contact Instagram link needs an accessible label"
grep -q '.contact__prompt' styles.css || fail "contact enquiry prompt is not styled"
grep -q '.contact-links' styles.css || fail "contact links are not styled"

todo_marker='TO''DO'
filler_marker='lor''em'
insert_marker='INSERT ''HERE'
if grep -R "$todo_marker\|$filler_marker\|$insert_marker" index.html styles.css script.js README.md assets >/dev/null; then
  fail "launch placeholder marker text remains"
fi

printf 'PASS: static GitHub Pages scaffold is valid\n'
