---
title: Running Several Forum Sites
parent: Administering
nav_order: 4
---

# Running Several Forum Sites

One Liferay instance can host several forum sites, for example one per product or region. Each site has its own categories, topics, search, and bans.

A site initializer creates one site, so each site needs its own. [Several Sites](../installing/creating-sites.html#several-sites) has the steps, for every install type. The batch and the microservice are shared by all forum sites and deployed once.

Liferay builds each site's address from its name: a site named *Acme* is served at `/web/acme`. To use another address, choose a different name, or change the site's friendly URL in *Site Settings* after it's created.

## Moderators and Category Admins

Bans apply to one site, but the **Forum Moderator** and **Forum Category Admin** roles apply to every forum site: a moderator of one forum site moderates them all. See [Roles and Permissions](../reference/roles-and-permissions.html).

## An Existing Site

The forum can't be added to a site that already exists, because Liferay sets up a site's forum pages only when it creates the site. Create a forum site instead, and link to it from the existing site, for example with a link page in its navigation.

## Deleting a Forum Site

See [Deleting a Forum Site](../installing/deleting.html). Other forum sites aren't affected.

## Related Information

- [Getting Started](../getting-started.html)
- [Banning Members](../moderating/banning.html)
