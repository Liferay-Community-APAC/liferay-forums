---
title: Creating Forum Sites
parent: Installing
nav_order: 5
---

# Creating Forum Sites
{: .no_toc }

Each forum is a Liferay site, created by a site initializer when it's deployed into a running Liferay. A site initializer creates exactly one site, so each forum site needs its own. The batch and the microservice are shared by all forum sites, and deployed once.

{: .note }
The forum can't be added to a site that already exists, because Liferay sets up a site's pages only when it creates the site. Create a forum site instead, and link to it from your existing site.

1. TOC
{:toc}

## One Site

`liferay-forums-site-initializer.zip` creates the site **FORUMS**, at `/web/forums`.

- **Liferay Self-Hosted (Tomcat):** copy the zip into `<liferay-home>/osgi/client-extensions`. Liferay creates the site in about a minute. Once it exists, remove the zip again.
- **Liferay Self-Hosted (Docker):** copy the zip into the container, wait for the site, then remove the zip:

    ```bash
    docker cp liferay-forums-site-initializer.zip forums-liferay:/opt/liferay/osgi/client-extensions/
    docker exec forums-liferay rm /opt/liferay/osgi/client-extensions/liferay-forums-site-initializer.zip
    ```

- **Liferay PaaS and Liferay SaaS:** the install creates it; see [On Liferay PaaS](paas.html) or [On Liferay SaaS](saas.html).

Removing the zip doesn't change the site. It keeps the site initializer from creating the site again, empty, if the site is ever deleted.

## Several Sites

Before you add sites, see [Running Several Forum Sites](../administering/several-sites.html), in particular about moderators.

### Step 1: Make a Site Initializer for Each Site

You copy the forum's site initializer project once for each site, and give each copy names of its own.

1. Download the forum's source code, [liferay-forums-1.0.0-source.zip](https://github.com/Liferay-Community-APAC/liferay-forums/releases/download/v1.0.0/liferay-forums-1.0.0-source.zip), from the [release](https://github.com/Liferay-Community-APAC/liferay-forums/releases/tag/v1.0.0), and unzip it. It unzips to a folder named `liferay-forums-1.0.0`; run the commands below from there.

1. Copy the whole `client-extensions/liferay-forums-site-initializer` folder, with everything in it, to a new folder next to it, named for the site. For a site named *Acme*:

    ```bash
    cp -r client-extensions/liferay-forums-site-initializer client-extensions/liferay-forums-site-initializer-acme
    ```

    On Liferay PaaS, copy it into `liferay/client-extensions` in your PaaS project's repository instead, as `liferay/client-extensions/liferay-forums-site-initializer-acme`.

    You then have two folders side by side. Leave the original as it is; only the copy changes:

    ```
    client-extensions/
    ├── liferay-forums-site-initializer/
    └── liferay-forums-site-initializer-acme/
        ├── build.gradle
        ├── client-extension.yaml    ← the only file you change
        └── site-initializer/
    ```

1. In the copy, open `client-extension.yaml`, and replace all of its contents with names for the new site. Every name in it must be unique to the copy: the two keys, the OAuth application, and the site's external reference code. For a site named *Acme*:

    ```yaml
    liferay-forums-site-initializer-acme:
        name: Liferay Forums Site Initializer Acme
        oAuthApplicationHeadlessServer: liferay-forums-site-initializer-acme-oahs
        siteExternalReferenceCode: LIFERAY_ACME
        siteName: Acme
        type: siteInitializer
    liferay-forums-site-initializer-acme-oahs:
        .serviceAddress: localhost:8080
        .serviceScheme: http
        name: Liferay Forums Site Initializer Acme OAuth Application Headless Server
        scopes:
            -   Liferay.Headless.Site.everything
        type: oAuthApplicationHeadlessServer
    ```

    Liferay builds the site's address from `siteName`: this site is served at `/web/acme`.

1. Except on Liferay PaaS, which builds the project itself, build the copy from the unzipped folder. You need Java 17 or later:

    ```bash
    ./gradlew :client-extensions:liferay-forums-site-initializer-acme:build
    ```

    The zip is `client-extensions/liferay-forums-site-initializer-acme/dist/liferay-forums-site-initializer-acme.zip`.

### Step 2: Deploy It Once

- **Liferay Self-Hosted (Tomcat or Docker):** deploy each zip as in [One Site](#one-site), then remove it once its site exists.
- **Liferay PaaS:** push, and deploy the build. Restart the `liferayforumsetcspringboot` service, and check the site. Then delete the copy's folder from your repository, push, deploy that build, and restart the service again. Its job would otherwise run again at every deploy, and reset the site's address. See [Later Deploys](paas.html#later-deploys).
- **Liferay SaaS:** deploy the zip, and never deploy it again: its job would reset the site's address.

    ```bash
    lcp deploy -p <project>-<environment> --extension client-extensions/liferay-forums-site-initializer-acme/dist/liferay-forums-site-initializer-acme.zip
    ```

Then check each new site at its address, and post a reply there.

### A Shortcut on Liferay Self-Hosted

On Liferay Self-Hosted (Tomcat or Docker), the `generate-site-initializer-zips.sh` script, attached to the [release](https://github.com/Liferay-Community-APAC/liferay-forums/releases/tag/v1.0.0), makes the copies from `liferay-forums-site-initializer.zip` without building them. It runs on Linux, with Bash, `unzip`, and `zip`. Don't use its zips on Liferay PaaS or SaaS: they all share one OAuth application, which works only when they're deployed to Liferay itself.

1. Put the script in a folder with `liferay-forums-site-initializer.zip`.

1. Edit the `SITES` list near the top of the script. Each entry maps the site's external reference code to its name:

    ```bash
    declare -A SITES=(
    	[LIFERAY_ACME]="Acme, Inc. site"
    	[LIFERAY_NORTHWIND]="Northwind site"
    )
    ```

1. Run it. It writes one zip per site to the `out` folder. For its options, run it with `--help`:

    ```bash
    bash generate-site-initializer-zips.sh
    ```

1. Deploy the generated zips as in [One Site](#one-site), then remove them once the sites exist.

A site named *Acme, Inc. site* is served at `/web/acme-inc.-site`. To use another address, choose a different name, or change the site's friendly URL in *Site Settings* after it's created.

## Related Information

- [Checking the Installation](checking.html)
- [Running Several Forum Sites](../administering/several-sites.html)
