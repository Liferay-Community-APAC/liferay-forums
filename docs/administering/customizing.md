---
title: Customizing the Forum
parent: Administering
nav_order: 3
---

# Customizing the Forum
{: .no_toc }

The forum is an ordinary Liferay site, built with fragments, so you can change it with Liferay's site-building tools.

1. TOC
{:toc}

## Look and Feel

| Part | Where to Change It |
| --- | --- |
| Header and footer colors | *Site Builder* → *Style Books* → **Forums**. **Brand Color 1** and **2** are the header's background and text, **3** and **4** the footer's. |
| Header and footer | *Site Builder* → *Master Pages* → **Forums** |
| Navigation links | *Site Builder* → *Pages*. **Liferay Learn** and **Help Center** are link pages you can edit or delete. |
| Home page title and description | Edit the home page and select the hero fragment. Change **Hero Title** and **Hero Description**. |

## Promoted Discussions

The home page shows up to five **Promoted Discussions**, newest first. To promote a topic, add the tag `promoted` to it. To pick topics by hand instead, create a manual collection in *Site Builder* → *Collections*, and select it in the home page's **Promoted Discussions** collection display.

## Page and List Settings

Each forum fragment has settings, such as the number of topics per page or whether the home page shows statistics. Edit the page, select the fragment, and open its configuration. See the [Configuration Reference](../reference/configuration.html).

## Error Pages

A forum site uses Liferay's default 404 and 500 pages, without the forum's header and footer. To brand them, create a utility page that uses the **Forums** master page in *Site Builder* → *Pages* → *Utility Pages*, and mark it as the default for its error.

{: .note }
Your changes to a forum site are kept: a site initializer only sets up a site when it creates it, and never changes an existing site.

## Related Information

- [Configuration Reference](../reference/configuration.html)
- [Running Several Forum Sites](several-sites.html)
