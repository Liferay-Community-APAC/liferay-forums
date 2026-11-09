---
title: インストールの確認
parent: インストール
nav_order: 6
---

# インストールの確認 {#checking-the-installation}
{: .no_toc }

4 つの簡単な確認で、フォーラムが動作していることがわかります。いずれかが失敗した場合は、以下の対処方法で一般的な原因を解決できます。

1. TOC
{:toc}

## 確認 1: マイクロサービス {#check-1-the-microservice}

Liferay のマシンで、次のコマンドを実行すると `READY` と出力されます。

```bash
curl http://localhost:58081/ready
```

Liferay Self-Hosted (Docker)では、`docker exec forums-liferay curl -s http://localhost:58081/ready` を実行します。

Liferay PaaS と Liferay SaaS では、Liferay Cloud コンソールで `liferayforumsetcspringboot` サービスが動作していることを確認します。

## 確認 2: Forum Banned ロール {#check-2-the-forum-banned-role}

管理者として Liferay にサインインした状態で、`<liferay-url>` をお使いの Liferay のアドレスに置き換えて、次のアドレスを開きます。最初のフォーラムサイトが作成されていれば、「見つかりません」エラーではなく、**Forum Banned** ロールが表示されます。

```
<liferay-url>/o/headless-admin-user/v1.0/roles/by-external-reference-code/FORUM_BANNED
```

「見つかりません」と表示される場合は、[å©ç¨ç¦æ­¢ãæ©è½ããªã](#bans-have-no-effect-or-moderators-dont-see-lock-topic) を参照してください。

## 確認 3: 投稿 {#check-3-post}

1. 管理者として、[初回のセットアップ](../getting-started.html#first-time-setup)を完了します。投稿するには、カテゴリーが少なくとも 1 つ存在する必要があります。
1. メンバーとしてサインインし、フォーラムサイト（たとえば `/web/forums`）を開いて、トピックを作成します。
1. そのトピックに返信します。

## 確認 4: メールを受信する {#check-4-get-an-email}

1. あるメンバーとして、トピックをフォローします。
1. 別のメンバーとして、そのトピックに返信します。
1. 最初のメンバーに、[メール通知](../administering/email-notifications.html)で設定したアドレスからメールが届くことを確認します。

## 問題がある場合 {#if-somethings-wrong}

### 投稿が拒否される {#posts-are-rejected}

メンバーが利用禁止されておらず、トピックもロックされていないのに、**Your account has been banned from participating in the forums.** またはロックのエラーが表示されます。

1. マイクロサービスが動作していること、および Liferay からマイクロサービスに接続できることを確認します（[確認 1](#check-1-the-microservice)）。Liferay Self-Hosted (Docker)では、Liferay のコンテナーを再起動した後に、マイクロサービスのコンテナーを再起動してください。
1. 動作しているのに、そのログに Liferay からの `403` エラーが表示される場合は、batch の完了前にその zip がデプロイされたため、Liferay がフォーラムのデータへのアクセス権を与えていません。同じ zip を再度デプロイしても解決しません。新たにデプロイし直してください。
    1. Liferay の `osgi/client-extensions` フォルダーから `liferay-forums-etc-spring-boot.zip` を削除します。
    1. Liferay のログにそのバンドルの `STOPPED` が表示されるまで待ちます。
    1. zip を再びコピーします。
    1. マイクロサービスを再起動します。
1. Liferay PaaS では、[Liferay PaaS へのインストール](paas.html#step-5-deploy-a-second-build)のとおり、2 回目のビルドをデプロイしてマイクロサービスを再起動します。Liferay SaaS では、マイクロサービスの client extension の削除を Liferay サポートに依頼してから、再度デプロイします。

### トピックのリンクで「見つかりません」ページが表示される {#topic-links-show-a-not-found-page}

Liferay の起動中にサイトが作成されたため、トピックのページがありません。誰かがそのサイトに投稿する前に、*Control Panel* → *Sites* でサイトを削除し、[フォーラムサイトの作成](creating-sites.html)のとおり、実行中の Liferay にそのサイトの site initializer の zip を再度デプロイします。

### 利用禁止が機能しない、またはモデレーターに Lock Topic が表示されない {#bans-have-no-effect-or-moderators-dont-see-lock-topic}

**Forum Banned** ロールに外部参照コード `FORUM_BANNED` が設定されていません。これは、Liferay の修正 LPD-90465 がない場合に起こります。管理者としてサインインし、たとえば `<liferay-url>/o/api` にある Liferay の API エクスプローラーを使って、手動で設定します。

1. ロールの ID を調べます: `GET /o/headless-admin-user/v1.0/roles?search=Forum%20Banned`。
1. コードを設定します: `PATCH /o/headless-admin-user/v1.0/roles/<role ID>`、本文は `{"externalReferenceCode": "FORUM_BANNED"}` です。
1. [確認 2](#check-2-the-forum-banned-role) でロールが表示されるようになったことを確認します。

### メールが届かない {#no-email-arrives}

[メール通知](../administering/email-notifications.html)で、テンプレートの **From** アドレスと Liferay のメール送信者を確認し、Liferay のメールサーバーが設定されていることを確認してください。テンプレートを変更した後は、マイクロサービスを再起動してください。マイクロサービスは起動時にだけテンプレートを読み込みます。

## 関連情報 {#related-information}

- [はじめに](../getting-started.html)
- [既知の問題](../reference/known-issues.html)
