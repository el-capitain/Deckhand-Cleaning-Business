# Call the Deckhand Website PRD

## Product Overview

Call the Deckhand is a one-woman on board and below deck cleaning business launching in Sydney's Eastern Suburbs. The business helps sailors, boat owners, race crews, and old-school Sydney sailing people finish the day properly: come back tired from a sail, step off the boat, and let someone capable take over the clean, packdown, laundry, essentials run, and optional sail pack-away.

The website must feel premium but not stiff: modern, fun, simple, and a bit cheeky. It should sit somewhere between a relaxed sailing influencer energy and a polished Sydney hospitality/editorial sensibility. The owner knows boats, understands the rhythm of sailing, and can move quickly without needing everything explained.

## Hosting And Deployment Context

The site will be hosted on GitHub Pages free hosting with a custom domain. Build the site as static files with no server-side runtime requirement. The first version should work from a GitHub Pages deployment immediately after the repository is published and Pages is enabled.

Assume the intended canonical custom domain is `callthedeckhand.com.au` for metadata and `CNAME`. If the real domain differs, this value should be easy to change in one place before deployment.

## Business Positioning

### Core Promise

You sail. We reset the boat.

Call the Deckhand provides quick, thorough, boat-literate cleaning and packdown support for owners and crews who want the boat handled properly after a sail.

### Service Area

Initial operating area: Eastern Suburbs, Sydney, with copy that can later expand to broader Sydney Harbour coverage.

### Audience

- Boat owners in Sydney's Eastern Suburbs and Sydney Harbour sailing circles
- Race crews and regular sailors coming back tired from an afternoon or evening sail
- Older, established sailing cohort who value reliability, competence, discretion, and someone who understands the boat
- Time-poor owners who want the boat reset quickly without supervising every detail
- Luxury or higher-end customers who may pay extra for sail pack-away and concierge-style add-ons

### Brand Traits

- Reliable
- Boat-savvy
- Quick and thorough
- Warm, cheeky, and confident
- Premium without being precious
- Practical and unfussy
- Sydney harbour fluent

## Goals

### Primary Goals

- Explain the service clearly within the first viewport.
- Make the business feel trustworthy despite being new and one-woman.
- Convert visitors to enquiries through phone, email, or a simple booking enquiry link.
- Communicate that Call the Deckhand understands sailing-specific cleaning and packdown needs.
- Present the business as premium, capable, and local to Sydney's Eastern Suburbs.

### Success Metrics

- Lighthouse performance score of 90+ on mobile.
- Lighthouse accessibility score of 95+.
- Primary CTA visible in the first viewport on desktop and mobile.
- Contact details reachable from every page section within one scroll or via sticky/mobile nav.
- Site deploys successfully to GitHub Pages with static files only.

## Non-Goals

- Do not build a booking system, calendar, account system, payment flow, or admin dashboard.
- Do not depend on a backend or paid hosting.
- Do not create a generic marine services site that feels corporate or stock-heavy.
- Do not over-explain sailing basics to sailors.
- Do not use gimmicky nautical clip art, anchors everywhere, rope borders, or cartoon boat motifs.

## Technical Architecture

Use a lightweight static website architecture that can be deployed to GitHub Pages.

Preferred implementation:

- `index.html`
- `styles.css`
- `script.js`
- `assets/` for optimized images and any generated visual assets
- `CNAME` containing the custom domain assumption
- `README.md` with deployment instructions

No framework is required unless the existing project already has one before implementation begins. Keep dependencies to zero for the first version.

## Content Architecture

The first version is a one-page website with anchored sections:

1. Hero
2. Services
3. Why Call the Deckhand
4. How It Works
5. Service Area
6. Pricing Cue
7. About
8. Contact

Use clean, short copy. The site should sound like a capable deckhand talking to boat people, not like a marketing agency explaining a cleaning company.

## Brand Voice

### Voice Principles

- Confident, direct, and local
- A little cheeky without becoming unserious
- Practical before poetic
- Speaks to sailors as insiders
- Uses short lines and memorable phrases

### Copy Examples

Use these as inspiration, not necessarily exact final copy:

- "You sail. We reset the boat."
- "Step off. We'll take it from here."
- "Below deck, on deck, and all the tiny jobs everyone pretends not to see."
- "For sailors who want the boat sorted before the second drink."
- "Quick cleans, proper resets, laundry runs, essentials picked up, sails packed away if you're feeling fancy."
- "Eastern Suburbs now. Sydney Harbour next."

### Tone Boundaries

- Cheeky, not flippant.
- Premium, not snobby.
- Nautical, not kitsch.
- Friendly, not overly casual.

## Visual Direction

The visual direction should combine:

- Merivale-inspired simplicity: sparse layouts, restrained graphics, confident typography, strong editorial whitespace, and simple visual marks rather than complicated illustrations.
- Architectural Digest style cues: refined spacing, tasteful photography, interior/detail-led composition, and premium restraint.
- Sailing lifestyle energy: sun, salt, motion, timber, stainless steel, canvas, harbour light, deck details, and relaxed competence.

### Visual Must-Haves

- Strong first-viewport signal that the business is Call the Deckhand and boat-related.
- Use real or realistic boat/deck/below-deck imagery, not generic cleaning stock imagery.
- Keep graphics simple and iconic: linework, small symbols, tidy separators, and restrained badges.
- Use editorial composition: generous spacing, asymmetry where tasteful, and refined section rhythm.
- Add small moments of wit in headings, labels, and microcopy.

### Visual Must-Avoids

- No gradient orb backgrounds.
- No decorative bokeh blobs.
- No cartoon anchors, ship wheels, pirate styling, or novelty nautical motifs.
- No generic stock-photo cleaners in gloves smiling at kitchens.
- No corporate blue-and-white marine template look.
- No cluttered service cards packed with text.

## Colour Direction

Use a restrained, premium harbour palette with enough contrast and warmth to avoid a generic navy marine site.

Recommended palette:

- Chalk: `#F7F3EA`
- Salt White: `#FFFDF8`
- Ink Navy: `#111827`
- Harbour Green: `#254C45`
- Brass: `#B88A44`
- Signal Coral: `#F26D5B`
- Weathered Blue: `#6F93A5`
- Stainless Grey: `#D7D2C8`

Usage:

- Use Chalk or Salt White as the main background.
- Use Ink Navy and Harbour Green for text and deep contrast.
- Use Brass sparingly for premium detail.
- Use Signal Coral for cheeky highlights and primary CTA accents.
- Avoid making the page overwhelmingly blue, beige, or brown.

## Typography Direction

Use system fonts or locally available web-safe font stacks unless the implementation deliberately includes a lightweight hosted font.

Recommended pairing:

- Display/headlines: elegant editorial serif stack such as `Georgia`, `Times New Roman`, serif.
- Body/UI: clean sans stack such as `Inter`, `Avenir Next`, `Helvetica Neue`, Arial, sans-serif.

Do not use oversized hero text inside compact panels. Keep line lengths comfortable and ensure all text fits on mobile.

## Imagery Direction

Use one or more visual assets that clearly indicate boats and harbour sailing. Suitable imagery:

- Close deck detail after sailing
- Tidy below-deck cabin detail
- Harbour light on boat surfaces
- Sheets, canvas, stainless fittings, timber, cushions, sail bags
- A clean, editorial boat detail image as hero background or hero-side image

If no suitable source images exist in the repo, create lightweight placeholder assets with tasteful abstract deck/cabin shapes, then document where final photography should replace them.

## Functional Requirements

### FR-01: Static GitHub Pages Site

The website must run as static files and be deployable through GitHub Pages without a build step.

### FR-02: Hero Section

The hero must include:

- Business name: Call the Deckhand
- Clear positioning line
- Primary CTA to enquire
- Secondary CTA to view services
- A strong boat-related visual
- Service area cue: Eastern Suburbs, Sydney

### FR-03: Services Section

Show the core service set:

- On board cleaning
- Below deck cleaning
- Post-sail packdown
- Laundry runs for clothing and sheets
- Essentials pickup
- Luxury add-on: sail pack-away

Make sail pack-away feel premium and optional.

### FR-04: Why Call the Deckhand Section

Communicate:

- The owner understands sailing
- The service is fast and thorough
- Customers do not need to explain boat basics
- The work helps the boat run smoothly
- The tone is capable and cheeky

### FR-05: How It Works Section

Describe a simple flow:

1. Send the boat, location, timing, and job list.
2. Call the Deckhand meets the boat or arrives after docking.
3. The boat is cleaned, reset, and packed down.
4. Laundry or essentials are handled if requested.

### FR-06: Contact Section

Provide clear enquiry actions:

- Email link
- Phone link placeholder
- Instagram placeholder
- Short enquiry prompt

Use placeholders if final contact details are not available:

- Email: `hello@callthedeckhand.com.au`
- Phone: `0400 000 000`
- Instagram: `@callthedeckhand`

Keep all contact details easy to update in the HTML.

### FR-07: Responsive Navigation

Provide simple anchored navigation that works on mobile and desktop. Include a sticky or highly accessible contact CTA.

### FR-08: Accessibility

The site must:

- Use semantic HTML landmarks.
- Provide descriptive alt text for meaningful images.
- Maintain sufficient color contrast.
- Support keyboard navigation.
- Avoid text overlap at mobile and desktop widths.
- Respect reduced motion preferences if animations are used.

### FR-09: SEO And Social Metadata

Include:

- Page title
- Meta description
- Open Graph title, description, type, and image placeholder
- Canonical URL using `https://callthedeckhand.com.au/`
- Local business-focused copy for Sydney Eastern Suburbs and Sydney Harbour

### FR-10: Deployment Documentation

Add documentation explaining:

- How to preview locally by opening `index.html`
- How to publish via GitHub Pages
- How to update the custom domain
- Which placeholders must be replaced before launch

## UI/UX Specification

### Hero

The first viewport should feel editorial and confident, not like a generic landing page. The business name must be the main signal. Use a short headline and a compact paragraph. Do not put hero content in a card.

### Services

Use a tight, scannable layout. Services can be shown as a numbered list, editorial rows, or compact tiles. Cards are acceptable only if they are restrained and not nested.

### Pricing Cue

Do not publish exact prices yet. Communicate that standard resets are practical and sail pack-away is a luxury add-on. Suggested copy: "Simple resets, useful extras, and a fancy option for sails."

### About

Keep it human and credible. Emphasize that the business is one woman at launch and that this is a strength: direct communication, care, consistency, and accountability.

### Contact

The final section should make enquiry feel easy. It should not require a form backend. Use direct links first.

## Content Requirements

Write final website copy during implementation using this PRD as source material. Keep copy concise. Avoid lorem ipsum except for contact placeholders where specifically allowed.

Include these exact ideas somewhere on the page:

- Call the Deckhand is currently operating from Sydney's Eastern Suburbs.
- The service is for on board and below deck cleaning.
- The service helps sailors when they are exhausted and coming back in from a sail.
- The business can handle laundry runs for clothing and sheets.
- The business can pick up essentials.
- Sail pack-away is available at a luxury price.
- The business understands sailing and what boats need to run smoothly.

## Launch Placeholder Policy

The first implementation may use placeholder contact details, placeholder social links, and placeholder domain assumptions. All placeholders must be clearly grouped in the HTML and documented in `README.md`.

Do not leave visible "coming soon" text on the live page unless it is intentionally styled as part of the launch story.

## Tasks

### Phase 1: Static Site Foundation

- [x] Create the static GitHub Pages file structure per FR-01 with `index.html`, `styles.css`, `script.js`, `assets/`, `CNAME`, and launch-focused `README.md`
- [x] Build the semantic `index.html` page structure with anchored sections for Hero, Services, Why, How It Works, Service Area, Pricing Cue, About, and Contact per the Content Architecture
- [x] Add SEO, Open Graph, canonical URL, favicon placeholder references, and launch placeholders per FR-09 and the Launch Placeholder Policy

### Phase 2: Brand System And Visual Foundation

- [x] Implement the global CSS design system in `styles.css` per the Colour Direction, Typography Direction, responsive spacing rules, and accessibility requirements
- [x] Build the responsive header and anchored navigation per FR-07 with a persistent enquiry CTA that works on mobile and desktop
- [x] Create or add tasteful static visual assets in `assets/` per the Imagery Direction, avoiding all Visual Must-Avoids

### Phase 3: Homepage Sections

- [x] Build the editorial hero section per FR-02 with the business name, Eastern Suburbs cue, primary CTA, secondary CTA, and boat-related visual
- [x] Build the services section per FR-03 with on board cleaning, below deck cleaning, post-sail packdown, laundry, essentials pickup, and premium sail pack-away
- [x] Build the Why Call the Deckhand section per FR-04 with boat-savvy, fast, thorough, local, and cheeky proof points
- [x] Build the How It Works section per FR-05 with a four-step post-sail enquiry-to-reset flow
- [x] Build the Service Area and Pricing Cue sections using the Product Overview, Service Area, and UI/UX Specification
- [x] Build the About and Contact sections per FR-06, including editable contact placeholders and direct email/phone/social links

### Phase 4: Interaction, Polish, And Deployment Readiness

- [x] Add lightweight `script.js` enhancements for mobile navigation, smooth anchor behavior, and reduced-motion-safe interaction states
- [x] Polish responsive layouts across mobile, tablet, and desktop so text never overlaps and all fixed-format UI elements have stable dimensions
- [x] Verify accessibility basics per FR-08, including semantic landmarks, alt text, keyboard navigation, color contrast, and reduced motion behavior
- [x] Update `README.md` with GitHub Pages publishing steps, custom domain instructions, placeholder replacement notes, and local preview instructions per FR-10
- [x] Run a final static-site QA pass and mark any launch blockers in `README.md` before completing the PRD
