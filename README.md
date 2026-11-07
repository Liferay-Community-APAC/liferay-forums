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
