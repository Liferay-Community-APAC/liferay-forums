---
title: Deleting a Forum Site
parent: Installing
nav_order: 7
---

# Deleting a Forum Site

Deleting a forum site deletes its pages and all its forum content: topics, replies, follows, votes, and reports. Other forum sites aren't affected.

{: .warning }
Deleting a site can't be undone. Back up Liferay's database first if you might need its content.

1. Check that the site's site initializer zip isn't in Liferay's `osgi/client-extensions` folder; [Creating Forum Sites](creating-sites.html) has you remove it once the site exists. Deployed again later, it would create the site again, empty. On Liferay PaaS, check the same for its site initializer project in `liferay/client-extensions`.

1. In *Control Panel* → *Sites*, open the site's **Actions** menu, click **Delete**, and confirm.

The forum's shared parts stay, since other forum sites use them: its data model from the batch, the microservice, and the **Forum Moderator**, **Forum Category Admin**, and **Forum Banned** roles.

## Related Information

- [Running Several Forum Sites](../administering/several-sites.html)
- [Installing](./)
