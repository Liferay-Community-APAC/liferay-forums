---
title: Known Issues
parent: Reference
nav_order: 4
---

# Known Issues

Known limitations in Liferay Forums 1.0.0.

## A Question's Author Can't Mark an Answer

The author of a question sees **Mark as Answer**, but marking a reply fails, because members aren't allowed to change other members' replies. Moderators can mark the answer.

## Deploying the Batch Again

Deploy `liferay-forums-batch.zip` once. Each time it's deployed again:

- Custom fields and relationships that an administrator added to Liferay's **User** object are deleted. Add them again afterwards.
- Liferay logs an error that the email templates already exist. The batch keeps your changes to them.
- On Liferay PaaS, where the batch job runs at every deploy, the job shows as failed for the same reason. The forum's data is imported before that, so nothing is lost. [Step 5 of On Liferay PaaS](../installing/paas.html#step-5-deploy-a-second-build) prevents it, by removing the email templates file after the first deploy.

## An Error Is Logged When a Topic Is Updated

Without the Liferay fix LPD-102310, when the forum's microservice updates a topic that has a category, Liferay logs `ERROR ... Invalid asset category with external reference code ...`. The topic keeps its category, and nothing else is affected.

## On Liferay PaaS and SaaS, a Site Initializer Job Run Again Resets the Site's Address

Each time a site initializer's job runs again on an existing site, the site's friendly URL is reset to `/group-<number>`, and the forum's links show not found pages. LPD-85594 fixes this for site initializer zips deployed to Liferay itself, but not for the job that Liferay Cloud runs. Remove each site initializer project once its site exists, as in [Installing on Liferay PaaS](../installing/paas.html#step-5-deploy-a-second-build), and on Liferay SaaS don't deploy a site initializer again. If an address was reset, set it back in *Site Settings*.

## Deleting a Reply Doesn't Change a Topic's Activity Date

A topic keeps its place in **Recent Activity** after its latest reply is deleted.

## Related Information

- [Release notes](https://github.com/Liferay-Community-APAC/liferay-forums/tree/downloads/1.0.0)
