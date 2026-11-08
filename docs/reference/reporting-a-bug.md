---
title: Reporting a Bug
parent: Reference
nav_order: 5
---

# Reporting a Bug
{: .no_toc }

Report problems with Liferay Forums, and suggest improvements, as issues in the
[liferay-forums repository on GitHub](https://github.com/Liferay-Community-APAC/liferay-forums/issues). You need a
GitHub account.

1. TOC
{:toc}

## If You Have a TAM Package

If your Liferay subscription includes a Technical Account Manager (TAM) package, log the problem directly with
Liferay Support instead of opening a GitHub issue. A ticket keeps your logs and environment details private, and
your TAM can follow it up.

1. Sign in to the [Liferay Help Center](https://support.liferay.com/) with your liferay.com account.
1. Create a ticket, as described in
   [Help Center Ticket Creation Process](https://learn.liferay.com/kb-article/help-center-ticket-creation-process).
1. In the ticket, say that the problem is in **Liferay Forums**, with its version, and include the same details as
   a [bug report](#report-a-bug): the Liferay DXP version, the install type, the steps to reproduce, and the log
   lines.
1. Let your TAM know about the ticket.

## Before You Report

- Check [Known Issues](known-issues.html) for your release.
- If posts are rejected, topic links show a not found page, or no email arrives, follow
  [If Something's Wrong](../installing/checking.html#if-somethings-wrong).
- Search the [open issues](https://github.com/Liferay-Community-APAC/liferay-forums/issues) for the same problem. If
  you find it, add what you know to it, or give it a 👍, instead of opening another.

## Report a Bug

1. Open [New issue](https://github.com/Liferay-Community-APAC/liferay-forums/issues/new/choose), and choose
   **Bug report**.
1. Fill in the form:
    - the Liferay Forums version and the Liferay DXP version;
    - how you installed it: Liferay Self-Hosted (Tomcat or Docker), Liferay PaaS, Liferay SaaS, or a Liferay Workspace;
    - whether the [required Liferay fixes](../installing/#required-liferay-fixes) are installed;
    - what happened, what you expected, and the steps to reproduce it, with the role of the member who does each
      step;
    - errors from the Liferay log and the microservice's log.
1. Click **Create**.

{: .warning }
Issues are public. Before you paste logs or screenshots, remove email addresses, user names, hostnames, internal
addresses, tokens, and any customer data.

To suggest an improvement, choose **Feature request** instead, and describe what you're trying to do.

## Security Problems

Don't report a security problem in a public issue. Report it privately, in the repository's **Security** tab →
[**Report a vulnerability**](https://github.com/Liferay-Community-APAC/liferay-forums/security/advisories/new). Only
the maintainers see it. See the repository's
[security policy](https://github.com/Liferay-Community-APAC/liferay-forums/security/policy).

## Questions

For questions about installing, setting up, or using the forum, start a
[discussion](https://github.com/Liferay-Community-APAC/liferay-forums/discussions) instead of an issue.

## What Happens Next

The maintainers review new issues, and ask for more details if they need them. A confirmed bug is planned for a
release, usually the next patch of the latest release line, and the issue says which. When that release is
published, the issue is closed with a link to it. Its release notes say how to install it.

Liferay Forums is a community project, so issues are handled on a best-effort basis.

## Related Information

- [Known Issues](known-issues.html)
- [Checking the Installation](../installing/checking.html)
