---
title: フォーラムサイトの削除
parent: インストール
nav_order: 7
---

# フォーラムサイトの削除 {#deleting-a-forum-site}

フォーラムサイトを削除すると、そのページとすべてのフォーラムコンテンツ（トピック、返信、フォロー、投票、報告）が削除されます。他のフォーラムサイトには影響しません。

{: .warning }
サイトの削除は元に戻せません。コンテンツが必要になる可能性がある場合は、先に Liferay のデータベースをバックアップしてください。

1. そのサイトの site initializer の zip が、Liferay の `osgi/client-extensions` フォルダーにないことを確認します。[フォーラムサイトの作成](creating-sites.html)では、サイトが作成されたら zip を削除するよう説明しています。後で再度デプロイされると、サイトが空の状態で再作成されます。Liferay PaaS では、`liferay/client-extensions` にあるその site initializer プロジェクトについても同様に確認します。

1. *Control Panel* → *Sites* で、サイトの **Actions** メニューを開き、**Delete** をクリックして確定します。

フォーラムの共有部分は、他のフォーラムサイトが使用するため残ります。batch によるデータモデル、マイクロサービス、および **Forum Moderator**、**Forum Category Admin**、**Forum Banned** の各ロールです。

## 関連情報 {#related-information}

- [複数のフォーラムサイトの運用](../administering/several-sites.html)
- [インストール](./)
