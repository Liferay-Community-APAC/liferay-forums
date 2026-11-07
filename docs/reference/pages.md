---
title: Pages
parent: Reference
nav_order: 2
---

# Pages

The site initializer creates these pages. Addresses are relative to the site, for example `/web/forums`.

| Page | Address | What It Shows | Who Can See It |
| --- | --- | --- | --- |
| **Forums** | `/forums` | Home page: statistics, search, promoted discussions, categories | Everyone |
| **Forums Messages** | `/forums-messages` | The discussions list, filtered by category or tag | Everyone |
| **New Discussion** | `/new-discussion` | The form to start a topic | Signed-in members |
| **Search** | `/search` | Search results with facets | Everyone |
| **Forums Moderation** | `/forums-moderation` | The moderation queue | Forum Moderators |
| **Forum Categories Admin** | `/forum-categories-admin` | Category management | Forum Category Admins |
| **Liferay Learn**, **Help Center** | | Links to Liferay's documentation and help center | Everyone |

Each topic has its own page at `/c_c2m0thread/<topic-title>`, built from the **Forum Thread** display page template.

Pages open to everyone show topics only to signed-in members, unless an administrator [lets guests read the forum](roles-and-permissions.html#let-guests-read-the-forum).

## Related Information

- [Roles and Permissions](roles-and-permissions.html)
- [Customizing the Forum](../administering/customizing.html)
