---
title: On Liferay SaaS
parent: Installing
nav_order: 3.5
---

# Installing on Liferay SaaS
{: .no_toc }

On Liferay SaaS, you deploy the forum's three zips with Liferay Cloud's command line tool, one at a time, in order. Liferay Cloud runs the batch and the forum site as jobs, and the microservice as a service that stays up.

{: .warning }
These steps were tested on a clean Liferay DXP 2026.Q1.4 LTS with the required fixes, in a local copy of how Liferay Cloud runs client extensions, not yet on a Liferay SaaS environment.

1. TOC
{:toc}

## Step 1: Check the Liferay Version and Fixes

On Liferay SaaS, Liferay manages the Liferay version and its hotfixes, for every environment on the same cluster at once: a hotfix can't be installed for your environment alone. So you work with the release your environment runs:

1. Ask Liferay Support which release and hotfix your environment runs, and check that it's a 2026.Q1 LTS release.

1. Compare it with the [required Liferay fixes](./#required-liferay-fixes). For each fix it doesn't include, use the [workaround](./#without-a-hotfix) after the install. LPD-85594 doesn't matter on Liferay SaaS: the steps below never run a site initializer twice.

## Step 2: Get Ready to Deploy

1. Install Liferay Cloud's [command line tool](https://learn.liferay.com/w/dxp/cloud/reference/command-line-tool), and sign in with `lcp login`.

1. Find the ID of the extension environment to deploy to, in the form `<project>-<environment>`. The Liferay Cloud console shows it.

1. From the [release](https://github.com/LGSAPAC/lfrgs-liferay-forums/releases/tag/v1.0.0), download:

    - `liferay-forums-batch.zip`
    - `liferay-forums-etc-spring-boot.zip`
    - `liferay-forums-site-initializer.zip`

## Step 3: Deploy the Batch

1. Deploy the batch:

    ```bash
    lcp deploy -p <project>-<environment> --extension liferay-forums-batch.zip
    ```

1. Wait for its job to finish. It's finished when *Applications* → *Notification Templates* shows **C2M0 Notification Email Reply** and **C2M0 Notification Email Mention**, which the batch creates last. *Control Panel* → *Objects* then shows the **C2M0 Forums** folder, with seven objects: C2M0 Attachment, C2M0 Message, C2M0 Subscription, C2M0 Suspicious Activity, C2M0 Thread, C2M0 User, and C2M0 Vote.

{: .warning }
Don't continue until the batch has finished. The microservice deployed in the next step only gets access to the parts of the forum that exist by then. Deployed too early, it gets no access, and every post is rejected with **Your account has been banned from participating in the forums.**

## Step 4: Deploy the Microservice

```bash
lcp deploy -p <project>-<environment> --extension liferay-forums-etc-spring-boot.zip
```

Liferay registers the microservice, and Liferay Cloud starts it with its credentials. *Control Panel* → *Security* → *OAuth 2 Administration* then shows **Liferay Forums Etc Spring Boot OAuth Application Headless Server** and **Liferay Forums Etc Spring Boot OAuth Application User Agent**.

## Step 5: Deploy the Site Initializer

```bash
lcp deploy -p <project>-<environment> --extension liferay-forums-site-initializer.zip
```

Its job creates the forum site at `/web/forums`.

## Step 6: Set Up Email Notifications

The batch created two email templates with a placeholder sender address. Set real addresses, then restart the microservice's service, `liferayforumsetcspringboot`, from the Liferay Cloud console, before members get email. See [Email Notifications](../administering/email-notifications.html).

## Step 7: Check the Installation

Continue with [Checking the Installation](checking.html), for the forum site at `/web/forums`.

If replies are rejected, see [Posts Are Rejected](checking.html#posts-are-rejected).

## API Call Limit

Liferay SaaS limits API calls per user and hour. The microservice calls Liferay for every post, as a single user, for all forum sites together. A busy forum, or several busy forum sites, may reach the limit, and posts are then rejected until the hour is over. Confirm the current limit with Liferay Support if you expect heavy use.

## Later Deploys

- **Don't deploy the batch again.** Each deploy runs its job again, which reports a failed item for the email templates, because they already exist. Your data and your changes to the templates are kept, but the job shows as failed.
- **Don't deploy the site initializer again.** Its job would run again, and reset the forum site's address to `/web/group-<number>`, which breaks the forum's links. LPD-85594 doesn't prevent this on Liferay SaaS. If it happens, set the friendly URL back in *Site Settings*.
- **Deploy the microservice again** only for a new version of it, and check replies afterwards.

## Adding More Forum Sites

Each forum site gets its own site initializer zip, built from the release's source code and deployed once. The microservice doesn't need a restart. See [Several Sites](creating-sites.html#several-sites).

## Related Information

- [On Liferay PaaS](paas.html)
- [Installing](./)
