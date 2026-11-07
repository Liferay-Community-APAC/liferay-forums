---
title: Liferay Self-Hosted (Docker)
parent: Installing
nav_order: 2
---

# Installing on Liferay Self-Hosted (Docker)
{: .no_toc }

Liferay and PostgreSQL run in containers, and the forum's microservice runs in a third container that shares Liferay's network, so Liferay reaches it at `localhost:58081` as on a server. You copy the forum's zips into the running Liferay container, in the same order as on a server. These steps were tested with the `liferay/dxp:2026.q1.4-lts` image.

{: .important }
You need Docker. Run the commands from a folder that holds the release's three zips, downloaded from the [release](https://github.com/Liferay-Community-APAC/liferay-forums/releases/tag/v1.0.0).

1. TOC
{:toc}

## Step 1: Add the Liferay Fixes

Create a folder named `patching` next to the zips, and put the hotfix from Liferay Support in it. Liferay installs it each time its container starts. Without a hotfix, leave the folder empty, and use the [workarounds](./#without-a-hotfix).

## Step 2: Start PostgreSQL and Liferay

1. Create a network for the containers, and start PostgreSQL. Replace `change-me` with a password of your own, here and in the next command:

    ```bash
    docker network create forums
    docker run -d --name forums-postgres --network forums --restart unless-stopped \
      -e POSTGRES_DB=lportal -e POSTGRES_USER=liferay -e POSTGRES_PASSWORD=change-me \
      -v forums-postgres-data:/var/lib/postgresql/data \
      postgres:16.15
    ```

1. Start Liferay. The `forums-liferay-routes` volume holds the credentials Liferay writes for the microservice:

    ```bash
    docker run -d --name forums-liferay --network forums -p 8080:8080 --restart unless-stopped \
      -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_DRIVER_UPPERCASEC_LASS_UPPERCASEN_AME=org.postgresql.Driver \
      -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_URL=jdbc:postgresql://forums-postgres:5432/lportal \
      -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_USERNAME=liferay \
      -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_PASSWORD=change-me \
      -v forums-liferay-data:/opt/liferay/data \
      -v forums-liferay-routes:/opt/liferay/routes \
      -v "$PWD/patching:/mnt/liferay/patching" \
      liferay/dxp:2026.q1.4-lts
    ```

1. Wait until Liferay has started: `docker logs forums-liferay` shows `Server startup in`. This takes a few minutes. Liferay is then at `http://localhost:8080`.

## Step 3: Deploy the Batch

1. Copy the batch into the running container:

    ```bash
    docker cp liferay-forums-batch.zip forums-liferay:/opt/liferay/osgi/client-extensions/
    ```

1. Follow the log, and wait until it shows five lines containing `Finished batch engine import task` after the copy, then press **Ctrl+C**:

    ```bash
    docker logs -f --since 2m forums-liferay | grep "Finished batch engine import task"
    ```

{: .warning }
Liferay also logs a few of these lines while it starts. Only count the ones after the copy, and don't continue until all five have finished.

## Step 4: Deploy the Microservice's Zip

```bash
docker cp liferay-forums-etc-spring-boot.zip forums-liferay:/opt/liferay/osgi/client-extensions/
```

Wait until `docker logs forums-liferay` shows `STARTED liferayforumsetcspringboot`.

## Step 5: Start the Microservice

1. Build the microservice's image from the `Dockerfile` in its zip:

    ```bash
    mkdir microservice
    unzip liferay-forums-etc-spring-boot.zip -d microservice
    docker build -t liferay-forums-microservice microservice
    ```

1. Start it in Liferay's network, with Liferay's credentials volume:

    ```bash
    docker run -d --name forums-microservice --network container:forums-liferay --restart unless-stopped \
      -v forums-liferay-routes:/opt/liferay/routes:ro \
      -e LIFERAY_ROUTES_CLIENT_EXTENSION=/opt/liferay/routes/default/liferay-forums-etc-spring-boot \
      -e LIFERAY_ROUTES_DXP=/opt/liferay/routes/default/dxp \
      liferay-forums-microservice
    ```

1. Check that Liferay reaches it. This prints `READY`:

    ```bash
    docker exec forums-liferay curl -s http://localhost:58081/ready
    ```

## Step 6: Set Up Email Notifications

The batch created two email templates with a placeholder sender address. Set real addresses, then restart the microservice with `docker restart forums-microservice`, before members get email. See [Email Notifications](../administering/email-notifications.html).

## Step 7: Create the Forum Sites

Continue with [Creating Forum Sites](creating-sites.html).

## Day to Day

- **After Liferay's container restarts,** restart the microservice's container too, since it shares Liferay's network: `docker restart forums-microservice`.
- **The zips live in Liferay's container.** If you remove the container and start a new one, for example to change a setting or the image, the new container has none of the forum's zips. Copy in the batch, then the microservice's zip, as in Steps 3 and 4. Then remove the microservice's container and start it again with the `docker run` command of Step 5: it was tied to the old Liferay container, so restarting it fails.

    ```bash
    docker rm -f forums-microservice
    ```
- **Logs:** `docker logs forums-liferay` and `docker logs forums-microservice`.

## Related Information

- [Checking the Installation](checking.html)
- [Installing](./)
