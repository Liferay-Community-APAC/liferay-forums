---
title: Getting Started
nav_order: 2
---

# Getting Started
{: .no_toc }

Liferay Forums adds a complete forum site to Liferay DXP. This page gets you from installing it to a forum members can use.

1. TOC
{:toc}

## Install

Liferay Forums 1.0.0 runs on Liferay DXP 2026.Q1 LTS with the [required Liferay fixes](installing/#required-liferay-fixes). [Installing](installing/) lists what it includes, and walks you through installing it on Liferay Self-Hosted (Tomcat or Docker), on Liferay PaaS, or on Liferay SaaS. When it finishes, the forum is available at `/web/forums`.

## First-Time Setup

After installing, complete these steps as an administrator:

1. **Create categories.** Open **Forum Categories Admin** and click **Seed Default Categories**, or add your own. Members can't post until at least one category exists. See [Managing Categories](administering/categories.html).

1. **Set up email notifications.** Set the sender address of the forum's email templates and of your Liferay instance, then restart the microservice, which reads the templates only when it starts. See [Email Notifications](administering/email-notifications.html).

1. **Assign moderators.** Give the **Forum Moderator** role to the people who will moderate, and **Forum Category Admin** to the people who will manage categories. See [Roles and Permissions](reference/roles-and-permissions.html).

1. **Post a welcome topic.** Use **New Discussion** to post community guidelines, and give it the **Announcement** priority so it stays at the top.

## Related Topics

- [Installing](installing/)
- [Starting a Discussion](using/starting-a-discussion.html)
- [Roles and Permissions](reference/roles-and-permissions.html)
- [Running Several Forum Sites](administering/several-sites.html)
