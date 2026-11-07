---
title: Roles and Permissions
parent: Reference
nav_order: 1
---

# Roles and Permissions

The site initializer creates three roles and sets the forum's permissions. Assign roles in *Control Panel* → *Users* → *Roles*, or, for **Forum Banned**, through [moderation](../moderating/banning.html).

| Role | Type | Purpose |
| --- | --- | --- |
| **Forum Moderator** | Regular | Moderates topics and reports, and bans members |
| **Forum Category Admin** | Regular | Manages the forum's categories |
| **Forum Banned** | Site | Stops a member from posting on that site |

{: .important }
**Forum Moderator** and **Forum Category Admin** are regular roles, so they apply to the whole Liferay instance, not to one site. A Forum Moderator moderates every forum site, and a Forum Category Admin can add, change, and delete categories on every site, not only forum sites. Only bans apply to one site. Give these two roles only to people you trust with every forum site.

## What Each Group Can Do

| Action | Guest | Signed-in member | Forum Moderator | Forum Category Admin |
| --- | :---: | :---: | :---: | :---: |
| Read topics and search | | ✓ | ✓ | ✓ |
| Start topics, reply, vote, attach files | | ✓ | ✓ | ✓ |
| Follow topics and get notifications | | ✓ | ✓ | ✓ |
| Report a topic | | ✓ | ✓ | ✓ |
| Edit or delete any topic or reply | | | ✓ | |
| Set a topic's priority | | | ✓ | |
| Lock and unlock topics | | | ✓ | |
| Mark an answer on any question | | | ✓ | |
| Review reports, ban and unban members | | | ✓ | |
| Create, edit, and delete categories | | | | ✓ |

Only signed-in members can read the forum. Signed-out visitors see the forum's pages, but no topics, and a topic's address shows a not found page. To open the forum to them, see [Let Guests Read the Forum](#let-guests-read-the-forum).

Members can edit and delete their own topics and replies. In 1.0.0, a question's author can't mark its answer yet; see [Known Issues](known-issues.html). Liferay's **Administrator** role can do everything.

{: .note }
A banned member keeps the permissions to read, but every new topic or reply is rejected on the site where they are banned.

## Let Guests Read the Forum

Signed-out visitors have Liferay's **Guest** role. To let them read topics, replies, and categories, and search, give the **Guest** role view permissions and let it call the two category APIs the forum's pages use. Guests still can't start topics, reply, vote, follow topics, or report content.

{: .important }
These permissions apply to every forum site on the Liferay instance, and to the forum's APIs as well as its pages: anyone can then read every topic and reply through `/o/c/c2m0threads` and `/o/c/c2m0messages`.

### Grant the Permissions

1. Open *Control Panel* → *Users* → *Roles*, click **Guest**, and open the **Define Permissions** tab.

1. Search for `C2M0`. Under *Objects*, open each of these, select **View** in its entry permissions (for example, **C2M0 Thread** → **View**), and click **Save**:

    - **C2M0 Thread**
    - **C2M0 Message**
    - **C2M0 Vote**
    - **C2M0 User**
    - **C2M0 Attachment**

    Leave **C2M0 Subscription** and **C2M0 Suspicious Activity** as they are.

1. Search for `Categories`, and open *Site and Asset Library Administration* → *Categorization* → **Categories**. Under *Resource Permissions*, select **View** for **Category Vocabulary** and for **Category**, and click **Save**.

1. Open *Control Panel* → *Security* → *Service Access Policy*, and click **FORUM_GUEST_ACCESS**. Under **Allowed Service Signatures**, click **Switch to Advanced Mode**, add these two lines below the existing ones, and click **Save**:

    ```
    com.liferay.headless.admin.taxonomy.internal.resource.v1_0.BaseTaxonomyCategoryResourceImpl#getTaxonomyVocabularyTaxonomyCategoriesPage
    com.liferay.headless.admin.taxonomy.internal.resource.v1_0.BaseTaxonomyVocabularyResourceImpl#getSiteTaxonomyVocabulariesPage
    ```

    Without them, guests can read topics, but the discussions list shows no categories in its breadcrumb and **All Categories** menu.

Sign out and open the forum to check: the home page, the discussions list, topic pages, and search results now show topics.

### Undo It

1. In the **Guest** role's **Define Permissions** tab, open *Summary*, and click **Remove** next to each permission you added: the five **C2M0** view permissions, and **Category Vocabulary** and **Category** view.

1. In **FORUM_GUEST_ACCESS**, delete the two lines you added from **Allowed Service Signatures**, and click **Save**. Keep the two `ObjectEntryResourceImpl` lines that were there before.

Signed-out visitors can then no longer read topics.

## Related Information

- [Moderating](../moderating/)
- [Pages](pages.html)
