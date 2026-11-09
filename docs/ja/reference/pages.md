---
title: ページ
parent: リファレンス
nav_order: 2
---

# ページ {#pages}

site initializer は次のページを作成します。アドレスはサイト（例：`/web/forums`）からの相対パスです。

| ページ | アドレス | 表示内容 | 表示できるユーザー |
| --- | --- | --- | --- |
| **Forums** | `/forums` | ホームページ：統計情報、検索、注目のディスカッション、カテゴリー | すべてのユーザー |
| **Forums Messages** | `/forums-messages` | カテゴリーまたはタグで絞り込んだディスカッション一覧 | すべてのユーザー |
| **New Discussion** | `/new-discussion` | トピックを開始するためのフォーム | サインインしたメンバー |
| **Search** | `/search` | ファセット付きの検索結果 | すべてのユーザー |
| **Forums Moderation** | `/forums-moderation` | モデレーションキュー | Forum Moderator |
| **Forum Categories Admin** | `/forum-categories-admin` | カテゴリーの管理 | Forum Category Admin |
| **Liferay Learn**、**Help Center** | | Liferay のドキュメントとヘルプセンターへのリンク | すべてのユーザー |

各トピックには、**Forum Thread** 表示ページテンプレートから作成される専用のページが `/c_c2m0thread/<topic-title>` にあります。

すべてのユーザーに公開されているページでも、管理者が[ゲストにフォーラムの閲覧を許可](roles-and-permissions.html#let-guests-read-the-forum)しない限り、トピックはサインインしたメンバーにのみ表示されます。

## 関連情報 {#related-information}

- [ロールと権限](roles-and-permissions.html)
- [フォーラムのカスタマイズ](../administering/customizing.html)
