# Call the Deckhand

Static launch site for Call the Deckhand, a one-woman on board and below deck cleaning service launching from Sydney's Eastern Suburbs.

## Local Preview

The site is static and has no install or build step. For a quick preview, open the file directly:

```bash
open index.html
```

If you want browser URLs to behave more like GitHub Pages, run a local server from the repository root:

```bash
python3 -m http.server 8000
```

Then visit `http://localhost:8000`.

## File Structure

- `index.html`: one-page site structure, metadata, section anchors, and launch copy
- `styles.css`: visual system, layout, responsive behavior, and accessibility states
- `script.js`: lightweight mobile navigation behavior
- `assets/`: optimized launch imagery, visual placeholders, and future brand assets
- `CNAME`: GitHub Pages custom domain
- `tests/static-site.test.sh`: dependency-free static validation
- `tests/responsive-layout.test.js`: dependency-free responsive layout contract checks

## GitHub Pages Publishing

1. Push the repository to GitHub.
2. In GitHub, open the repository and go to `Settings` -> `Pages`.
3. Under `Build and deployment`, set `Source` to `Deploy from a branch`.
4. Select the default branch and `/ (root)` as the publishing source, then save.
5. Wait for the Pages deployment to finish, then check the published URL from the Pages settings screen.
6. After the custom domain resolves, enable `Enforce HTTPS`.

This project should publish from the repository root because `index.html`, `styles.css`, `script.js`, `assets/`, and `CNAME` all live at the top level. Do not add a build workflow unless the PRD changes.

## Custom Domain

The current domain assumption is `callthedeckhand.com.au`.

To keep or update it before launch:

1. Confirm `CNAME` contains the exact domain GitHub Pages should serve.
2. Update every matching canonical, Open Graph, and visible domain reference in `index.html`.
3. In GitHub, go to `Settings` -> `Pages` -> `Custom domain`, enter the same domain, and save.
4. At the DNS provider, point the apex domain at GitHub Pages using the provider's supported GitHub Pages records. If using `www`, add a `CNAME` for `www` pointing to the GitHub Pages default domain for the account or organisation.
5. Verify DNS with `dig callthedeckhand.com.au +noall +answer` or the DNS checker supplied by the domain provider.
6. Enable `Enforce HTTPS` once GitHub makes it available.

GitHub recommends verifying the custom domain before adding DNS records and warns that DNS changes can take up to 24 hours to propagate. Avoid wildcard DNS records for this site.

## Placeholder Replacement

Replace or confirm these editable placeholders in `index.html`:

- Domain/canonical URL: `https://callthedeckhand.com.au/`
- Email: `hello@callthedeckhand.com.au`
- Phone: `0400 000 000`
- Instagram: `@callthedeckhand`
- Favicon: `assets/favicon-placeholder.svg`
- Hero/Open Graph image: `assets/deck-reset-hero.jpg`
- Supporting images: `assets/below-deck-reset.jpg`, `assets/sail-packaway-detail.jpg`, `assets/laundry-essentials-detail.jpg`

Current imagery is tasteful static placeholder photography generated for the launch site: deck reset, below-deck reset, sail pack-away detail, and laundry or essentials detail. Final photography can replace the `.jpg` files, and final brand artwork can replace `assets/favicon-placeholder.svg`. Keep file names, alt text, and metadata aligned if any asset path changes.

## Final Static QA

Last checked: 2026-05-08.

Code QA passed for the static GitHub Pages build: required files are present, metadata is wired, service sections and anchor navigation are in order, contact links are reachable, assets are optimized for the launch site, and the no-build architecture is intact.

Launch blockers to clear before public launch:

- Confirm or replace the placeholder phone number `0400 000 000`.
- Confirm GitHub Pages custom domain setup, DNS propagation, and `Enforce HTTPS`.
- Confirm the placeholder favicon and generated launch imagery are acceptable for launch, or replace them with final brand/photography assets.

## Validation

Run the static test:

```bash
sh tests/static-site.test.sh
```

Run the JavaScript behavior and responsive layout tests:

```bash
node tests/script.behavior.test.js
node tests/responsive-layout.test.js
```

No build step, package install, backend, database, booking engine, or payment system is required.
