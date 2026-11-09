---
title: Developing With a Liferay Workspace
parent: Installing
nav_order: 8
---

# Developing With a Liferay Workspace
{: .no_toc }

If you build your own Liferay code with a [Liferay Workspace](https://learn.liferay.com/w/dxp/liferay-development/tooling/liferay-workspace), you can add the forum's projects to it, build them with your code, and deploy them to the workspace's own Liferay bundle for development.

This isn't a separate way to install the forum. To install it on a server, in Docker, or on Liferay SaaS, build the zips here, then follow [Installing](./) with them. A Liferay PaaS project's `liferay` folder is already a workspace: follow [On Liferay PaaS](paas.html).

{: .important }
Tested with the Liferay Workspace Gradle plugin 15.0.0 and Liferay DXP 2026.Q1.4. You need [Blade](https://learn.liferay.com/w/dxp/liferay-development/tooling/blade-cli), or run the workspace's `./gradlew` in place of `blade gw`.

1. TOC
{:toc}

## Step 1: Add the Forum's Projects

1. From the [latest release](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest), download the forum's source code, `liferay-forums-<version>-source.zip`, and unzip it. It unzips to a folder named `liferay-forums-<version>`, such as `liferay-forums-1.0.0`.

1. Copy these three folders into your workspace's `client-extensions` folder:

    - `client-extensions/liferay-forums-batch`
    - `client-extensions/liferay-forums-etc-spring-boot`
    - `client-extensions/liferay-forums-site-initializer`

The workspace picks them up as client extension projects, next to your own, with no other change.

## Step 2: Build Them

From the workspace's root folder:

```bash
blade gw build
```

Each zip is written to its project's `dist` folder, for example `client-extensions/liferay-forums-batch/dist/liferay-forums-batch.zip`. They're the same zips as a release's.

## Step 3: Deploy Them to the Workspace's Bundle

For the workspace's Liferay bundle, set up with `blade server init`. Start it, and wait until it has started. Each project's `deploy` task copies only its own zip into the bundle, in `bundles/osgi/client-extensions` by default.

{: .warning }
**Never install with `blade gw deploy`.** The workspace-wide deploy deploys every project at once, so the microservice's zip can arrive before the batch has finished, and every post is then rejected.

If you put the projects in a subfolder, such as `client-extensions/forums`, the task paths follow it: `:client-extensions:forums:liferay-forums-batch:deploy`.

1. **The batch.** Then wait until the Liferay log shows five lines containing `Finished batch engine import task`:

    ```bash
    blade gw :client-extensions:liferay-forums-batch:deploy
    ```

1. **The microservice's zip:**

    ```bash
    blade gw :client-extensions:liferay-forums-etc-spring-boot:deploy
    ```

1. **Start the microservice,** as in [Step 4 of Liferay Self-Hosted (Tomcat)](tomcat.html#step-4-start-the-microservice): unzip `client-extensions/liferay-forums-etc-spring-boot/dist/liferay-forums-etc-spring-boot.zip` into a folder, and start it with `LIFERAY_HOME` set to the full path of the bundle. Use a full path: `start.sh` runs from its own folder.

    ```bash
    LIFERAY_HOME=/home/me/my-workspace/bundles ./start.sh
    ```

1. **Set up email notifications,** as in [Email Notifications](../administering/email-notifications.html), then restart the microservice.

1. **The forum site.** Once the site exists, remove `liferay-forums-site-initializer.zip` from `bundles/osgi/client-extensions`.

    ```bash
    blade gw :client-extensions:liferay-forums-site-initializer:deploy
    ```

For more forum sites, add a copy of the site initializer project per site, as in [Several Sites](creating-sites.html#several-sites), and deploy each with its own `deploy` task.

## Step 4: Check the Installation

Continue with [Checking the Installation](checking.html).

## Things to Avoid

- **Later workspace-wide deploys** skip projects that haven't changed, so `blade gw deploy` for your own code doesn't deploy the forum again. After `blade gw clean`, or a change to a forum project, it deploys the forum's zips again, all at once. Then restart the microservice, which gets new credentials, and see [Deploying the Batch Again](../reference/known-issues.html#deploying-the-batch-again).
- **The workspace's Docker tasks,** such as `buildDockerImage` and `startDockerContainer`, put every project in Liferay's image, and Liferay deploys them while it starts, which is too early for the microservice and the site initializer. For Docker, build the zips here, then follow [Liferay Self-Hosted (Docker)](docker.html).

## Related Information

- [Liferay Self-Hosted (Tomcat)](tomcat.html)
- [Creating Forum Sites](creating-sites.html)
