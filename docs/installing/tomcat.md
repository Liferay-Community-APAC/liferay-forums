---
title: Liferay Self-Hosted (Tomcat)
parent: Installing
nav_order: 1
---

# Installing on Liferay Self-Hosted (Tomcat)
{: .no_toc }

Follow these steps when Liferay is installed from a Tomcat bundle on a server you manage.

{: .important }
You need file access to the Liferay server, the [required Liferay fixes](./#required-liferay-fixes) installed with Liferay's [patching tool](https://learn.liferay.com/w/dxp/self-hosted-installation-and-upgrades/maintaining-a-liferay-installation/patching-liferay) or their workarounds, and Liferay must have finished starting before you begin. In the steps below, `<liferay-home>` is the Liferay installation folder, the one that contains the `osgi` and `routes` folders.

1. TOC
{:toc}

## Step 1: Download the Release

From the [release](https://github.com/Liferay-Community-APAC/liferay-forums/releases/tag/v1.0.0), download:

- `liferay-forums-batch.zip`
- `liferay-forums-etc-spring-boot.zip`
- `liferay-forums-site-initializer.zip`
- `generate-site-initializer-zips.sh`, only to run several forum sites with the script; see [Creating Forum Sites](creating-sites.html#a-shortcut-on-liferay-self-hosted).

## Step 2: Deploy the Batch

1. Copy `liferay-forums-batch.zip` into `<liferay-home>/osgi/client-extensions`.

1. Wait until the Liferay log shows five lines containing `Finished batch engine import task` after the copy. This takes about a minute.

{: .warning }
Don't continue until all five have finished. The microservice deployed in the next step only gets access to the parts of the forum that exist by then. Liferay also logs a few of these lines while it starts, so only count the ones after the copy.

## Step 3: Deploy the Microservice's Zip

Copy `liferay-forums-etc-spring-boot.zip` into `<liferay-home>/osgi/client-extensions`.

Liferay registers the microservice and writes its credentials to `<liferay-home>/routes/default`. Liferay doesn't run the microservice itself; the next step starts it.

## Step 4: Start the Microservice

The microservice must run whenever Liferay runs: posting, notifications, and moderation all depend on it. Run it on the Liferay machine if you can; it's simpler.

### On the Liferay Machine

1. Unzip `liferay-forums-etc-spring-boot.zip` into a folder of your choice, such as `/opt/liferay-forums`.

1. From that folder, start it, with `LIFERAY_HOME` set to the Liferay installation folder. It finds Liferay's address and its credentials there, so there's nothing to configure.

    On Linux:

    ```bash
    LIFERAY_HOME=/opt/liferay ./start.sh
    ```

    On Windows:

    ```bat
    set LIFERAY_HOME=C:\liferay
    start.bat
    ```

    If it stops with a message that the routes don't exist, its zip isn't deployed to that Liferay yet, or `LIFERAY_HOME` points to the wrong folder.

1. Check that it's running. This prints `READY`:

    ```bash
    curl http://localhost:58081/ready
    ```

{: .tip }
To keep it running across reboots on Linux, run it as a system service. For example, a systemd unit at `/etc/systemd/system/liferay-forums.service`:

```ini
[Unit]
Description=Liferay Forums microservice
After=network.target

[Service]
User=liferay
Environment=LIFERAY_HOME=/opt/liferay
WorkingDirectory=/opt/liferay-forums
ExecStart=/opt/liferay-forums/start.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Then run `sudo systemctl enable --now liferay-forums`.

### On Another Machine

Liferay always calls the microservice at `localhost:58081`, so port `58081` on the Liferay machine must be forwarded to the microservice's machine.

1. On the microservice's machine, unzip `liferay-forums-etc-spring-boot.zip` into a folder of your choice.

1. In `application.properties`, next to the jar, uncomment and fill in these four settings:

    ```properties
    com.liferay.lxc.dxp.mainDomain=liferay.example.com
    com.liferay.lxc.dxp.server.protocol=https
    liferay-forums-etc-spring-boot-oahs.oauth2.headless.server.client.id=<client ID>
    liferay-forums-etc-spring-boot-oahs.oauth2.headless.server.client.secret=<client secret>
    ```

    `mainDomain` and `server.protocol` are how the microservice reaches Liferay; include the port in `mainDomain` unless it's 80 or 443. The client ID and secret are those of **Liferay Forums Etc Spring Boot OAuth Application Headless Server**, in *Control Panel* → *Security* → *OAuth 2 Administration*.

1. Start it without `LIFERAY_HOME`: `./start.sh` on Linux, or `start.bat` on Windows.

1. On the Liferay machine, forward port `58081` to the microservice's machine, and keep the forward running as long as the microservice runs. Allow port `58081` through any firewall between the machines. Either run `socat` on the Liferay machine:

    ```bash
    socat TCP-LISTEN:58081,bind=127.0.0.1,fork,reuseaddr TCP:<microservice-host>:58081
    ```

    Or open an SSH tunnel from the microservice's machine:

    ```bash
    ssh -N -R 58081:localhost:58081 <user>@<liferay-host>
    ```

1. On the Liferay machine, check that the forward reaches the microservice. This prints `READY`:

    ```bash
    curl http://localhost:58081/ready
    ```

## Step 5: Set Up Email Notifications

The batch created two email templates with a placeholder sender address. Set real addresses, then restart the microservice, before members get email. See [Email Notifications](../administering/email-notifications.html).

## Step 6: Create the Forum Sites

Continue with [Creating Forum Sites](creating-sites.html).

## Related Information

- [Checking the Installation](checking.html)
- [Installing](./)
