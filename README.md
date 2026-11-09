# Liferay Forums documentation

The user documentation for [Liferay Forums](https://github.com/LGSAPAC/lfrgs-liferay-forums),
published at <https://liferay-community-apac.github.io/liferay-forums/>.

The docs are Markdown pages in `docs/`, built with Jekyll and published by the shared Liferay Community APAC
workflow whenever `docs/` changes on `main`. The page layout loads the main site's header, footer, styles and
search, so these docs look and work like the rest of
[liferay-community-apac.github.io](https://github.com/Liferay-Community-APAC/liferay-community-apac.github.io).

## Edit the docs

Each page starts with front matter that places it in the sidebar:

```yaml
---
title: Banning Members   # the page's name in the sidebar
parent: Moderating       # its section
nav_order: 4             # its position, lower first
---
```

Pages can use a table of contents (`1. TOC` then `{:toc}`), callouts (`{: .note }`, `{: .tip }`, `{: .important }`
or `{: .warning }` on the line before a paragraph) and screenshots (`{: .screenshot }` after an image). Images go in
`docs/assets/images/`.

### Downloadable Files

Every code block gets a **Copy** button. A file readers save or paste whole, and that isn't in the release, can also
get a **Download** button. Keep a single copy of it in `docs/_includes/snippets/`, and add a page for it in
`docs/assets/downloads/` that includes it:

```liquid
---
layout: null
sitemap: false
---
{% include snippets/liferay-forums.service %}
```

Then show it and offer it for download where the docs need it. In a numbered list, indent both lines by three spaces
and pass `indent="   "`:

````markdown
```ini
{% include snippet.md file="liferay-forums.service" indent="" %}
```

{% include download.html file="liferay-forums.service" %}
````

The code block and the download then always match. Files in the release stay in the release.

### Translations

The docs are also in Japanese (`docs/ja/`) and Bahasa Indonesia (`docs/id/`). Each translated page has the same file
name and folder as its English page, and its headings keep the English anchors, such as
`## 手順 1: リリースをダウンロードする {#step-1-download-the-release}`. The `parent` of a translated page is the
translated title of its section. When you change an English page, change its translations too. Interface text, such as
**Previous** and **Next** and the note at the top of translated pages, is in `docs/_data/i18n.yml`.

The layout in `docs/_layouts/default.html` comes from the
[app docs template](https://github.com/Liferay-Community-APAC/app-docs-template). Improve it there, then copy it here.

## Preview locally

Set `main_site: https://liferay-community-apac.github.io` in `docs/_config.yml` (don't commit it), then:

```bash
cd docs && jekyll serve --baseurl /liferay-forums
```

Search only works on the published site.

## Publishing

In **Settings → Pages**, **Source** must be **GitHub Actions**.

## Releasing

Releases are built from the private source repository,
[LGSAPAC/lfrgs-liferay-forums](https://github.com/LGSAPAC/lfrgs-liferay-forums), and published here as GitHub
releases by the **Release** workflow (`.github/workflows/release.yml`). Each release holds the three client extension
zips, `generate-site-initializer-zips.sh`, a source zip with the three projects as a Liferay Workspace, and
`SHA256SUMS`.

### One-Time Setup

The workflow reads the source repository with a read-only deploy key.

1. Make a key pair, without a passphrase:

    ```bash
    ssh-keygen -t ed25519 -N "" -C "liferay-forums release" -f liferay-forums-release
    ```

1. In the source repository, **Settings → Deploy keys → Add deploy key**: title *liferay-forums release*, key: the
   contents of `liferay-forums-release.pub`. Leave **Allow write access** cleared.
1. In this repository, **Settings → Secrets and variables → Actions → New repository secret**: name
   `SOURCE_DEPLOY_KEY`, secret: the contents of `liferay-forums-release`, the private key.
1. Delete both key files.

### Each Release

1. In the source repository, tag the release on its branch, as described in its README.
1. Here, add the release notes as `release-notes/<version>.md` on `main`, for example `release-notes/1.0.1.md`. They
   become the release's description.
1. In **Actions → Release → Run workflow**, enter the tag, for example `v1.0.1`, and click **Run workflow**.

The workflow checks out the tag, builds it, checks that the build changed no files, and creates the release. Run it
again for the same tag to rebuild its files and update its notes. A tag with a suffix, such as `v1.1.0-rc1`, is
published as a pre-release.

Then link the docs to the new release's files.
