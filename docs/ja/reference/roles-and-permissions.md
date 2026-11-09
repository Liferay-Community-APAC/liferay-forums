---
title: ロールと権限
parent: リファレンス
nav_order: 1
---

# ロールと権限 {#roles-and-permissions}

site initializer は 3 つのロールを作成し、フォーラムの権限を設定します。ロールは *Control Panel* → *Users* → *Roles* で割り当てます。**Forum Banned** の場合は、[モデレーション](../moderating/banning.html)を通じて割り当てます。

| ロール | タイプ | 目的 |
| --- | --- | --- |
| **Forum Moderator** | レギュラー | トピックと報告をモデレートし、メンバーを禁止する |
| **Forum Category Admin** | レギュラー | フォーラムのカテゴリーを管理する |
| **Forum Banned** | サイト | そのサイトでメンバーが投稿できないようにする |

{: .important }
**Forum Moderator** と **Forum Category Admin** はレギュラーロールなので、1 つのサイトではなく Liferay インスタンス全体に適用されます。Forum Moderator はすべてのフォーラムサイトをモデレートし、Forum Category Admin はフォーラムサイトに限らず、すべてのサイトでカテゴリーを追加、変更、削除できます。1 つのサイトにのみ適用されるのは禁止だけです。この 2 つのロールは、すべてのフォーラムサイトを任せられる信頼できる人にのみ付与してください。

## 各グループができること {#what-each-group-can-do}

| 操作 | ゲスト | サインインしたメンバー | Forum Moderator | Forum Category Admin |
| --- | :---: | :---: | :---: | :---: |
| トピックの閲覧と検索 | | ✓ | ✓ | ✓ |
| トピックの開始、返信、投票、ファイルの添付 | | ✓ | ✓ | ✓ |
| トピックのフォローと通知の受信 | | ✓ | ✓ | ✓ |
| トピックの報告 | | ✓ | ✓ | ✓ |
| 任意のトピックや返信の編集または削除 | | | ✓ | |
| トピックの優先度の設定 | | | ✓ | |
| トピックのロックとロック解除 | | | ✓ | |
| 任意の質問での回答のマーク | | | ✓ | |
| 報告の確認、メンバーの禁止と禁止解除 | | | ✓ | |
| カテゴリーの作成、編集、削除 | | | | ✓ |

フォーラムを閲覧できるのは、サインインしたメンバーだけです。サインアウトした訪問者にはフォーラムのページは表示されますが、トピックは表示されず、トピックのアドレスでは Not Found ページが表示されます。訪問者にフォーラムを公開するには、[ゲストにフォーラムの閲覧を許可する](#let-guests-read-the-forum)を参照してください。

メンバーは、自分のトピックと返信を編集および削除できます。1.0.0 では、質問の作成者はまだその回答をマークできません。[既知の問題](known-issues.html)を参照してください。Liferay の **Administrator** ロールは、すべての操作を行えます。

{: .note }
禁止されたメンバーは閲覧の権限を保持しますが、禁止されたサイトでは、新しいトピックや返信がすべて拒否されます。

## ゲストにフォーラムの閲覧を許可する {#let-guests-read-the-forum}

サインアウトした訪問者は、Liferay の **Guest** ロールを持ちます。訪問者がトピック、返信、カテゴリーを閲覧し、検索できるようにするには、**Guest** ロールに表示権限を付与し、フォーラムのページが使用する 2 つのカテゴリー API を呼び出せるようにします。それでも、ゲストはトピックの開始、返信、投票、トピックのフォロー、コンテンツの報告はできません。

{: .important }
これらの権限は、Liferay インスタンス上のすべてのフォーラムサイトに適用され、フォーラムのページだけでなく API にも適用されます。つまり、誰でも `/o/c/c2m0threads` と `/o/c/c2m0messages` を通じてすべてのトピックと返信を閲覧できるようになります。

### 権限を付与する {#grant-the-permissions}

1. *Control Panel* → *Users* → *Roles* を開き、**Guest** をクリックして、**Define Permissions** タブを開きます。

1. `C2M0` を検索します。*Objects* で次の各項目を開き、エントリーの権限で **View** を選択して（例：**C2M0 Thread** → **View**）、**Save** をクリックします。

    - **C2M0 Thread**
    - **C2M0 Message**
    - **C2M0 Vote**
    - **C2M0 User**
    - **C2M0 Attachment**

    **C2M0 Subscription** と **C2M0 Suspicious Activity** はそのままにしておきます。

1. `Categories` を検索し、*Site and Asset Library Administration* → *Categorization* → **Categories** を開きます。*Resource Permissions* で、**Category Vocabulary** と **Category** の **View** を選択し、**Save** をクリックします。

1. *Control Panel* → *Security* → *Service Access Policy* を開き、**FORUM_GUEST_ACCESS** をクリックします。**Allowed Service Signatures** で **Switch to Advanced Mode** をクリックし、既存の行の下に次の 2 行を追加して、**Save** をクリックします。

    ```
    com.liferay.headless.admin.taxonomy.internal.resource.v1_0.BaseTaxonomyCategoryResourceImpl#getTaxonomyVocabularyTaxonomyCategoriesPage
    com.liferay.headless.admin.taxonomy.internal.resource.v1_0.BaseTaxonomyVocabularyResourceImpl#getSiteTaxonomyVocabulariesPage
    ```

    これらがないと、ゲストはトピックを閲覧できても、ディスカッション一覧のパンくずリストと **All Categories** メニューにカテゴリーが表示されません。

サインアウトしてフォーラムを開き、確認します。ホームページ、ディスカッション一覧、トピックページ、検索結果にトピックが表示されるようになります。

### 元に戻す {#undo-it}

1. **Guest** ロールの **Define Permissions** タブで *Summary* を開き、追加した各権限（5 つの **C2M0** の表示権限、および **Category Vocabulary** と **Category** の表示権限）の横にある **Remove** をクリックします。

1. **FORUM_GUEST_ACCESS** で、追加した 2 行を **Allowed Service Signatures** から削除し、**Save** をクリックします。以前からあった 2 つの `ObjectEntryResourceImpl` の行は残しておきます。

これで、サインアウトした訪問者はトピックを閲覧できなくなります。

## 関連情報 {#related-information}

- [モデレーション](../moderating/)
- [ページ](pages.html)
