---
title: Installing
nav_order: 3
has_children: true
permalink: /installing/
---

# Installing
{: .no_toc }

These pages walk you through installing Liferay Forums 1.0.0, from an empty Liferay to a working forum site. Plan for about an hour the first time, most of it waiting for Liferay to start.

1. TOC
{:toc}

## Before You Begin

Check that you have:

- **Liferay DXP 2026.Q1 LTS**, on a server from a Tomcat bundle, in Docker, on Liferay PaaS, or on Liferay SaaS, with the [Liferay fixes](#required-liferay-fixes) below installed, or their workarounds.
- **A database Liferay supports**, such as PostgreSQL. The forum doesn't work on Hypersonic, the demo database Liferay starts with when none is set up.
- **Java 17 or later** on the machine where the forum's microservice runs, on Liferay Self-Hosted (Tomcat), and to build the site initializers for [several forum sites](creating-sites.html#several-sites).

### Required Liferay Fixes

Ask Liferay Support for a hotfix for your 2026.Q1 release that includes the required fixes, and install it before the forum. On Liferay SaaS, Liferay installs hotfixes for a whole cluster, not for one environment, so use the workarounds for any fix your environment's release doesn't include; see [On Liferay SaaS](saas.html#step-1-check-the-liferay-version-and-fixes).

| Fix | Without It | Needed |
| --- | --- | --- |
| LPD-90465 (on 2026.Q1.4, its backport LPD-112124) | Bans have no effect, and moderators don't see **Lock Topic**. | Yes |
| LPD-85594 | Each time a site initializer zip is deployed again on an existing site, the site's address is reset, and the forum's links show not found pages. It doesn't cover Liferay PaaS and SaaS, where the install steps avoid running a site initializer again. | Yes, until 2026.Q1.12, which includes it |
| LPD-102310 | Liferay logs an `Invalid asset category` error when a topic is updated. Nothing else is affected. | No, recommended |

Liferay Forums 1.0.0 was tested on 2026.Q1.1 and 2026.Q1.4.

#### Without a Hotfix

- **Instead of LPD-90465:** after the first forum site is created, give the **Forum Banned** role its external reference code by hand, as described in [Bans Have No Effect](checking.html#bans-have-no-effect-or-moderators-dont-see-lock-topic).
- **Instead of LPD-85594:** after each deployment of a site initializer zip on an existing site, check the site's friendly URL in *Site Settings*, and set it back if it changed.

## What You'll Install

Each [release](https://github.com/Liferay-Community-APAC/liferay-forums/releases) has these files:

| File | What It Is |
| --- | --- |
| `liferay-forums-batch.zip` | The forum's data: topics, replies, votes, reports, and follows, plus its notification templates and search settings. |
| `liferay-forums-etc-spring-boot.zip` | The forum's **microservice**, a small program that runs next to Liferay. It checks every post for bans and locked topics, and sends notifications. Liferay needs its zip, and the microservice itself runs as its own process or container. |
| `liferay-forums-site-initializer.zip` | The forum site itself: its pages, roles, and permissions. Deploying it creates one forum site. |
| `generate-site-initializer-zips.sh` | On Liferay Self-Hosted, makes one copy of the site initializer zip per site, to run several forum sites. |
| `liferay-forums-1.0.0-source.zip` | The source of the three zips, as a Liferay Workspace. You need it on Liferay PaaS, to build a site initializer for each additional forum site, or to add the forum to your own Liferay Workspace. |
| `SHA256SUMS` | Checksums of the files above. |

## Choose Where Liferay Runs

<div class="doc-cards">
  <a class="card doc" href="tomcat.html"><strong>Liferay Self-Hosted (Tomcat)</strong><span>Liferay installed from a Tomcat bundle. The microservice runs on the same machine or another one.</span></a>
  <a class="card doc" href="docker.html"><strong>Liferay Self-Hosted (Docker)</strong><span>Liferay and PostgreSQL in containers, and the microservice in a container next to Liferay's.</span></a>
  <a class="card doc" href="paas.html"><strong>On Liferay PaaS</strong><span>The forum's projects in your PaaS project's repository, deployed with the rest of it.</span></a>
  <a class="card doc" href="saas.html"><strong>On Liferay SaaS</strong><span>The forum's zips deployed one at a time with Liferay Cloud's command line tool.</span></a>
</div>

On Liferay Self-Hosted, you then follow [Creating Forum Sites](creating-sites.html), then [Checking the Installation](checking.html). On Liferay PaaS and Liferay SaaS, the forum site is created during the install. [Creating Forum Sites](creating-sites.html#several-sites) covers more forum sites for every install type.

If you build your own Liferay code with a Liferay Workspace, see [Developing With a Liferay Workspace](workspace.html) to add the forum's projects to it.

## Why the Order Matters

The forum is installed in a fixed order: the batch, then the microservice, then the sites. Each step needs the one before it.

- **The batch comes first.** When the microservice's zip is deployed, Liferay gives the microservice access to the forum's data, but only to the parts that already exist. Deployed before the batch has finished, the microservice gets no access, and every post is rejected.
- **The sites come last, once Liferay has fully started.** A forum site created while Liferay is still starting is missing its topic pages. That happens when a site initializer zip is copied in while Liferay is stopped, so always deploy it into a running Liferay.

## Related Information

- [Getting Started](../getting-started.html)
- [Deleting a Forum Site](deleting.html)
