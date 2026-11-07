---
title: On Liferay PaaS
parent: Installing
nav_order: 3
---

# Installing on Liferay PaaS
{: .no_toc }

On Liferay PaaS, you add the forum's three projects to your PaaS project's repository, and deploy them with the rest of the project. Each runs as its own PaaS service: the batch and the forum site as jobs, and the microservice as a service that stays up.

{: .warning }
These steps were tested on a clean Liferay DXP 2026.Q1.4 LTS with the required fixes, in a local copy of how Liferay PaaS runs client extensions, not yet on a Liferay PaaS environment. Client extensions are a beta feature on Liferay PaaS.

1. TOC
{:toc}

## Step 1: Prepare the Project

Follow Liferay's [Configuring Liferay PaaS for Client Extensions](https://learn.liferay.com/w/dxp/cloud/customizing-liferay-dxp-in-the-cloud/configuring-liferay-paas-for-client-extensions). In particular:

1. If your `infra` environment doesn't have the client extension build pipeline, ask Liferay Cloud Support to enable it.

1. If an environment uses basic authentication on its web server, let the `/o` path through without it. Liferay and the microservice call each other under `/o`.

1. Remove `virtual.hosts.valid.hosts` and `web.server.protocol` from the Liferay service's settings, if they're set. Client extensions don't work with them.

## Step 2: Install the Liferay Fixes

Install the hotfix with the [required Liferay fixes](./#required-liferay-fixes) before you add the forum's projects.

1. Add the hotfix to your project in one of these ways:

    - **For every environment:** in `ci/LCP.json`, set the environment variable `LCP_CI_LIFERAY_DXP_HOTFIXES_COMMON` to the hotfix's name without `.zip`:

        ```json
        "env": {
          "LCP_CI_LIFERAY_DXP_HOTFIXES_COMMON": "<hotfix-name>"
        }
        ```

    - **For one environment:** use `LCP_CI_LIFERAY_DXP_HOTFIXES_<ENVIRONMENT>` instead, for example `LCP_CI_LIFERAY_DXP_HOTFIXES_PRD`.
    - **In the repository:** put the hotfix zip in `liferay/configs/<environment>/patching/`, for example `liferay/configs/prd/patching/`, once for each environment.

1. Push the change, and deploy its build to your environment, as in [Step 4](#step-4-deploy-the-first-build).

1. Once the Liferay service has restarted, check that its log shows `The following patches are installed:` with the hotfix.

See Liferay's [Deploying to the Liferay Service](https://learn.liferay.com/w/dxp/cloud/customizing-liferay-dxp-in-the-cloud/using-the-liferay-dxp-service/deploying-to-the-liferay-service) for more about installing hotfixes.

## Step 3: Add the Forum's Projects

1. Download the release's source code, [lfrgs-liferay-forums-1.0.0.zip](https://github.com/LGSAPAC/lfrgs-liferay-forums/archive/refs/tags/v1.0.0.zip), and unzip it. On the [release page](https://github.com/LGSAPAC/lfrgs-liferay-forums/releases/tag/v1.0.0), it's **Source code (zip)**, the last of the **Assets**. It unzips to a folder named `lfrgs-liferay-forums-1.0.0`.

1. Copy these three folders into `liferay/client-extensions` in your PaaS project's repository:

    - `client-extensions/liferay-forums-batch`
    - `client-extensions/liferay-forums-etc-spring-boot`
    - `client-extensions/liferay-forums-site-initializer`

## Step 4: Deploy the First Build

1. Push the project. Liferay Cloud builds it; a build of client extensions is a **Custom Services** build.

1. In the Liferay Cloud console, open **Builds**, and on that build, choose **Deploy Build to...**, then your environment.

When the deploy finishes, the jobs have created the forum's data and the forum site at `/web/forums`, and the microservice has started. Check that:

- The Liferay service's log shows five lines containing `Finished batch engine import task`, one for each of the batch's files.
- *Control Panel* → *Objects* shows the **C2M0 Forums** folder, with seven objects: C2M0 Attachment, C2M0 Message, C2M0 Subscription, C2M0 Suspicious Activity, C2M0 Thread, C2M0 User, and C2M0 Vote.
- *Control Panel* → *Security* → *OAuth 2 Administration* shows four forum applications: one each for the batch and the site initializer, and two for the microservice, **Liferay Forums Etc Spring Boot OAuth Application Headless Server** and **User Agent**.

At this point, every reply is rejected with **Your account has been banned from participating in the forums.** That's expected: Liferay registered the microservice before the forum's data existed, so it has no access to it yet. The next two steps fix that.

## Step 5: Deploy a Second Build

The forum's jobs run again at every deploy, which they shouldn't, now that the forum's data and site exist:

- From the second deploy on, the batch job would report a failed item for the forum's two email templates, because they already exist.
- Each time the site initializer's job runs again, the forum site's address is reset to `/web/group-<number>`, which breaks the forum's links. LPD-85594 doesn't prevent this on Liferay PaaS.

So the second build leaves out the email templates file and the site initializer:

1. Delete this file and this folder from your repository:

    ```
    liferay/client-extensions/liferay-forums-batch/batch/05-notification-email-template.batch-engine-data.json
    liferay/client-extensions/liferay-forums-site-initializer
    ```

1. Push, and deploy the new build to your environment, as in Step 4.

Liferay registers the microservice again, this time with access to the forum's data, and gives it new credentials. The batch job passes, at this deploy and every later one, and the email templates, with your changes to them, stay as they are. The forum site stays at `/web/forums`, with its pages and content: removing a site initializer doesn't remove its site.

## Step 6: Restart the Microservice

In the Liferay Cloud console, restart the `liferayforumsetcspringboot` service, so it uses the new credentials. Replies are now accepted.

{: .note }
If replies are still rejected after the restart, Liferay may not reach the microservice at `localhost:58081`. In `liferay/client-extensions/liferay-forums-etc-spring-boot/client-extension.yaml`, change both `.serviceAddress: localhost:58081` lines to `liferayforumsetcspringboot:58081`, the address of the microservice's service, and deploy again. This hasn't been verified on Liferay PaaS yet.

## Step 7: Set Up Email Notifications

The batch created two email templates with a placeholder sender address. Set real addresses, then restart the `liferayforumsetcspringboot` service, before members get email. See [Email Notifications](../administering/email-notifications.html).

## Step 8: Check the Installation

Continue with [Checking the Installation](checking.html), for the forum site at `/web/forums`.

## Adding More Forum Sites

Each forum site gets its own site initializer project in your repository, deployed once, then removed again, as with the first site. See [Several Sites](creating-sites.html#several-sites).

## Later Deploys

Liferay gives the microservice new credentials at every deploy of your project, even one that doesn't change the forum. Until the microservice restarts with them, replies are rejected with **Your account has been banned from participating in the forums.** After every deploy, restart the `liferayforumsetcspringboot` service, as in [Step 6](#step-6-restart-the-microservice), and check that a reply is accepted.

## Related Information

- [On Liferay SaaS](saas.html)
- [Installing](./)
