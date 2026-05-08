# AGENTS.md

This file provides guidance to coding agents when working with the Call the Deckhand website repository.

## IMPORTANT GUIDELINES

### 1. File Structure & Modularity
- Prefer many small, focused files over large monolithic ones
- Each file must have a single clear responsibility
- Keep files ideally under ~200-300 lines, and nearly always under 800 lines
- Split logic early rather than refactoring large files later

### 2. Readability Over Cleverness
- Write simple, obvious code over complex or “clever” solutions
- Optimise for human readability, not brevity
- Use clear, descriptive naming (avoid unnecessary abbreviations)
- Avoid deeply nested logic where possible

### 3. Separation of Concerns
- Do not mix business logic, UI, and data handling
- Keep concerns separated:
  - Logic (services / core functions)
  - Data access (APIs / database)
  - Presentation (UI / templates)

### 4. Reusability
- Extract repeated logic into reusable functions or modules
- Avoid copy-pasting code across files
- Build components that can be reused in other parts of the system

### 5. Consistency
- Follow consistent naming conventions across the project
- Use the same patterns for similar problems
- Do not introduce new patterns unless clearly justified

### 6. Error Handling
- Always handle edge cases and failures explicitly
- Never allow silent failures
- Return clear, useful error messages for debugging

### 7. Incremental Development
- Build in small, testable steps
- Avoid large, multi-system changes in a single iteration
- Ensure each step works before progressing

### 8. Minimal Dependencies
- Avoid adding new libraries unless clearly necessary
- Prefer native or simple solutions first
- Each dependency must justify its complexity cost

### 9. Debuggability
- Write code that is easy to trace and debug
- Use logging where helpful
- Avoid overly abstracted or “magic” behaviour

### 10. Performance Awareness (Without Premature Optimisation)
- Do not over-optimise early
- Avoid obviously inefficient patterns
- Optimise only when a real bottleneck is identified

### 11. Agent-Friendly Code
- Write code that can be easily understood and modified by other agents
- Prefer explicit behaviour over implicit or hidden logic
- Include short comments explaining *why*, not just *what*
- Avoid hidden side effects and unclear state changes

### 12. Success Metrics & Validation
- Before building, define what success looks like (clear, measurable outcome)
- Prefer quantitative metrics where possible (e.g. conversion rate, load time, error rate)
- If no metric exists, create a simple proxy metric

- After implementation:
  - Validate that the feature works as intended
  - Measure impact against the defined metric
  - Compare before vs after where possible

- Do not assume improvements without evidence
- If results are unclear, add lightweight tracking or logging
- Every meaningful change should either improve a defined metric or create a new measurable capability.

## Project Overview

Call the Deckhand is a one-woman on board and below deck cleaning business launching from Sydney's Eastern Suburbs. The business helps sailors, boat owners, race crews, and established Sydney sailing people come back from a sail, step off the boat, and hand over the clean, reset, packdown, laundry run, essentials pickup, and optional sail pack-away.

The website is the first public presence for the business. It needs to communicate that Call the Deckhand understands sailing, understands boats, and understands the quick, thorough clean sailors want when they are exhausted and coming back in. The business is practical, boat-literate, reliable, cheeky, premium without being precious, and savvy to an old-school Sydney sailing cohort.

Core promise: "You sail. We reset the boat."

Initial operating area: Eastern Suburbs, Sydney, with room for copy to expand naturally toward broader Sydney Harbour service later.

Primary audience:
- Boat owners in Sydney's Eastern Suburbs and Sydney Harbour sailing circles
- Race crews and regular sailors coming back tired from a sail
- Older, established sailors who value competence, discretion, speed, and reliability
- Time-poor owners who want the boat reset without supervising every detail
- Higher-end customers who may pay extra for sail pack-away and concierge-style add-ons

Core services:
- On board cleaning
- Below deck cleaning
- Post-sail packdown
- Laundry runs for clothing and sheets
- Essentials pickup
- Luxury add-on: sail pack-away

The site must feel modern, fun, simple, editorial, and a bit cheeky. It should blend relaxed sailing lifestyle energy with Merivale-inspired graphic simplicity and Architectural Digest-style restraint.

The full PRD is in `PRD.md` — it is the authoritative source for all requirements, data models, API contracts, and UI specifications.

## Tech Stack

This is a lightweight static website intended for GitHub Pages free hosting with a custom domain.

Preferred first-version stack:
- Static HTML, CSS, and JavaScript
- `index.html` for the one-page website
- `styles.css` for the design system and responsive layout
- `script.js` for lightweight progressive enhancement only
- `assets/` for optimized images and visual assets
- `CNAME` for the custom domain
- `README.md` for local preview, deployment, and placeholder replacement notes

Do not introduce a framework, bundler, backend, database, booking system, payment system, or paid hosting dependency unless the PRD is explicitly changed. The first version should run by opening `index.html` directly and should deploy to GitHub Pages without a build step.

Current domain assumption for metadata and `CNAME`: `callthedeckhand.com.au`. Keep this easy to change.

## Common Commands

Run Ralphy against the PRD:

```bash
cd "/Users/miamacmahon/Desktop/Development/Deckhand Cleaning"
ralphy --codex --prd PRD.md
```

Preview locally:

```bash
open index.html
```

If browser testing is needed and a local server is preferable:

```bash
python3 -m http.server 8000
```

Then open:

```text
http://localhost:8000
```

Static checks after implementation:

```bash
find . -maxdepth 2 -type f
grep -R "TODO\\|lorem\\|INSERT HERE" .
```

There is intentionally no `npm install`, build, lint, or test command in the initial static-site architecture.

## Architecture

Build as a one-page static GitHub Pages site with anchored sections:

1. Hero
2. Services
3. Why Call the Deckhand
4. How It Works
5. Service Area
6. Pricing Cue
7. About
8. Contact

Recommended file responsibilities:
- `index.html`: semantic document structure, content, metadata, editable launch placeholders, and section anchors
- `styles.css`: global tokens, layout, responsive behavior, visual treatment, and accessibility states
- `script.js`: mobile navigation, smooth anchor behavior, and reduced-motion-safe interaction polish
- `assets/`: optimized boat/deck/below-deck imagery, favicon/social placeholders, and any tasteful static visual assets
- `CNAME`: custom domain value
- `README.md`: deployment and launch instructions

The site should use semantic HTML landmarks, accessible links/buttons, descriptive alt text for meaningful images, and direct contact links. No contact form backend is required. Contact details can be placeholders but must be easy to update in `index.html` and documented in `README.md`.

Expected placeholder contact details unless replaced:
- Email: `hello@callthedeckhand.com.au`
- Phone: `0400 000 000`
- Instagram: `@callthedeckhand`

## Design System

Brand feel:
- Modern, fun, architectural/editorial, and cheeky
- Premium but not snobby
- Nautical but not kitsch
- Practical, capable, and locally Sydney
- Sparse, confident, and graphic in the spirit of Merivale's simplicity
- Refined spacing and photography/detail treatment in the spirit of Architectural Digest
- Relaxed sailing lifestyle energy without becoming influencer cosplay

Voice:
- Confident, direct, and local
- A little cheeky without being flippant
- Speaks to sailors as insiders
- Short, memorable lines
- No generic cleaning-company marketing tone

Useful copy cues:
- "You sail. We reset the boat."
- "Step off. We'll take it from here."
- "Below deck, on deck, and all the tiny jobs everyone pretends not to see."
- "For sailors who want the boat sorted before the second drink."
- "Quick cleans, proper resets, laundry runs, essentials picked up, sails packed away if you're feeling fancy."
- "Eastern Suburbs now. Sydney Harbour next."

Recommended color palette:
- Chalk: `#F7F3EA`
- Salt White: `#FFFDF8`
- Ink Navy: `#111827`
- Harbour Green: `#254C45`
- Brass: `#B88A44`
- Signal Coral: `#F26D5B`
- Weathered Blue: `#6F93A5`
- Stainless Grey: `#D7D2C8`

Color usage:
- Use Chalk or Salt White as the main background.
- Use Ink Navy and Harbour Green for text and deep contrast.
- Use Brass sparingly for premium detail.
- Use Signal Coral for cheeky highlights and primary CTA accents.
- Avoid a generic navy/white marine look and avoid a page dominated by one hue family.

Typography:
- Display/headlines: editorial serif stack such as `Georgia`, `Times New Roman`, serif
- Body/UI: clean sans stack such as `Inter`, `Avenir Next`, `Helvetica Neue`, Arial, sans-serif
- Do not use oversized hero text inside compact panels.
- Keep line lengths comfortable and ensure all text fits on mobile.

Imagery:
- Use real or realistic boat/deck/below-deck imagery, not generic cleaning stock imagery.
- Suitable imagery includes deck details after sailing, tidy below-deck cabin details, harbour light on boat surfaces, sheets, canvas, stainless fittings, timber, cushions, and sail bags.
- If final photography is unavailable, create tasteful static placeholder assets and document replacement points.

Layout:
- The first viewport must clearly signal Call the Deckhand and boat-related service.
- Hero content must not sit inside a card.
- Use editorial whitespace, restrained section rhythm, and simple linework or small visual marks.
- Service content should be tight and scannable.
- Cards are acceptable only for genuinely repeated items and should be restrained, not nested.

## Constraints

Hosting and technical constraints:
- Must deploy on GitHub Pages free hosting.
- Must work with a custom domain via `CNAME`.
- Must be static: no server runtime, database, paid backend, booking engine, payment flow, or account system.
- First version should have zero dependencies unless the PRD changes.
- Keep all launch placeholders grouped and documented.

Content constraints:
- Include that Call the Deckhand currently operates from Sydney's Eastern Suburbs.
- Include that the service is for on board and below deck cleaning.
- Include that the service helps sailors when they are exhausted and coming back from a sail.
- Include laundry runs for clothing and sheets.
- Include essentials pickup.
- Include sail pack-away as a luxury-priced option.
- Include that the business understands sailing and what boats need to run smoothly.
- Do not publish exact prices yet.

Visual constraints:
- No gradient orb backgrounds.
- No decorative bokeh blobs.
- No cartoon anchors, ship wheels, pirate styling, rope borders, or novelty nautical motifs.
- No generic stock-photo cleaners in gloves smiling at kitchens.
- No cluttered service cards packed with text.
- No corporate blue-and-white marine template look.
- Do not make the palette overwhelmingly blue, beige, brown, or any single hue family.

Accessibility and quality constraints:
- Target Lighthouse performance score: 90+ on mobile.
- Target Lighthouse accessibility score: 95+.
- Primary CTA must be visible in the first viewport on desktop and mobile.
- Contact details must be reachable from every page section within one scroll or via sticky/mobile navigation.
- Use semantic HTML landmarks.
- Maintain sufficient color contrast.
- Support keyboard navigation.
- Respect reduced motion preferences.
- Prevent text overlap at mobile, tablet, and desktop sizes.
