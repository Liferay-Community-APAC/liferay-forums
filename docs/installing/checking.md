---
title: Checking the Installation
parent: Installing
nav_order: 6
---

# Checking the Installation
{: .no_toc }

Four quick checks tell you the forum works. If one fails, the fixes below cover the usual causes.

1. TOC
{:toc}

## Check 1: The Microservice

On the Liferay machine, this prints `READY`:

```bash
curl http://localhost:58081/ready
```

On Liferay Self-Hosted (Docker), run `docker exec forums-liferay curl -s http://localhost:58081/ready`.

On Liferay PaaS and Liferay SaaS, check in the Liferay Cloud console that the `liferayforumsetcspringboot` service is running.

## Check 2: The Forum Banned Role

Signed in to Liferay as an administrator, open this address, with your Liferay's address in place of `<liferay-url>`. It shows the **Forum Banned** role, not a not found error, once the first forum site exists:

```
<liferay-url>/o/headless-admin-user/v1.0/roles/by-external-reference-code/FORUM_BANNED
```

If it shows not found, see [Bans Have No Effect](#bans-have-no-effect-or-moderators-dont-see-lock-topic).

## Check 3: Post

1. As an administrator, complete the [first-time setup](../getting-started.html#first-time-setup). At least one category must exist before anyone can post.
1. Sign in as a member, open a forum site, for example `/web/forums`, and start a topic.
1. Reply to it.

## Check 4: Get an Email

1. As one member, follow a topic.
1. As another member, reply to it.
1. Check that the first member gets an email, sent from the address you set in [Email Notifications](../administering/email-notifications.html).

## If Something's Wrong

### Posts Are Rejected

Members see **Your account has been banned from participating in the forums.** or a lock error, though they aren't banned and the topic isn't locked.

1. Check that the microservice is running, and that Liferay reaches it ([Check 1](#check-1-the-microservice)). On Liferay Self-Hosted (Docker), restart the microservice's container after Liferay's restarts.
1. If it is, and its log shows `403` errors from Liferay, its zip was deployed before the batch finished, so Liferay didn't give it access to the forum's data. Deploying the same zip again doesn't help; deploy it fresh:
    1. Remove `liferay-forums-etc-spring-boot.zip` from Liferay's `osgi/client-extensions` folder.
    1. Wait until the Liferay log shows its bundle `STOPPED`.
    1. Copy the zip back in.
    1. Restart the microservice.
1. On Liferay PaaS, deploy a second build and restart the microservice, as in [Installing on Liferay PaaS](paas.html#step-5-deploy-a-second-build). On Liferay SaaS, ask Liferay Support to remove the microservice's client extension, then deploy it again.

### Topic Links Show a Not Found Page

The site was created while Liferay was still starting, so it's missing its topic pages. Before anyone posts in it, delete the site in *Control Panel* → *Sites*, and deploy its site initializer zip again into the running Liferay, as in [Creating Forum Sites](creating-sites.html).

### Bans Have No Effect, or Moderators Don't See Lock Topic

The **Forum Banned** role doesn't have the external reference code `FORUM_BANNED`, which happens without the Liferay fix LPD-90465. Set it by hand, signed in as an administrator, for example with Liferay's API explorer at `<liferay-url>/o/api`:

1. Find the role's ID: `GET /o/headless-admin-user/v1.0/roles?search=Forum%20Banned`.
1. Set its code: `PATCH /o/headless-admin-user/v1.0/roles/<role ID>` with the body `{"externalReferenceCode": "FORUM_BANNED"}`.
1. Check that [Check 2](#check-2-the-forum-banned-role) now shows the role.

### No Email Arrives

Check the templates' **From** address and Liferay's email sender in [Email Notifications](../administering/email-notifications.html), and that Liferay's mail server is configured. After changing a template, restart the microservice: it reads the templates only when it starts.

## Related Information

- [Getting Started](../getting-started.html)
- [Known Issues](../reference/known-issues.html)
