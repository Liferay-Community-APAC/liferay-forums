---
title: Liferay SaaS の場合
parent: インストール
nav_order: 3.5
---

# Liferay SaaS へのインストール {#installing-on-liferay-saas}
{: .no_toc }

Liferay SaaS では、Liferay Cloud のコマンドラインツールを使って、フォーラムの 3 つの zip を 1 つずつ順番にデプロイします。Liferay Cloud は、batch とフォーラムサイトをジョブとして、マイクロサービスを常時稼働するサービスとして実行します。

{: .warning }
これらの手順は、必要な修正を適用したクリーンな Liferay DXP 2026.Q1.4 LTS で、Liferay Cloud が client extension を実行する方法をローカルで再現した環境でテストされたものです。Liferay SaaS の環境ではまだテストされていません。

1. TOC
{:toc}

## 手順 1: Liferay のバージョンと修正を確認する {#step-1-check-the-liferay-version-and-fixes}

Liferay SaaS では、Liferay のバージョンと hotfix は Liferay が管理し、同じクラスター上のすべての環境に一度に適用されます。hotfix をお使いの環境だけにインストールすることはできません。そのため、お使いの環境で動作しているリリースを前提に作業します。

1. お使いの環境で動作しているリリースと hotfix を Liferay サポートに問い合わせ、2026.Q1 LTS リリースであることを確認します。

1. それを[必要な Liferay の修正](./#required-liferay-fixes)と比較します。含まれていない修正については、インストール後に[回避策](./#without-a-hotfix)を使用します。LPD-85594 は Liferay SaaS では関係ありません。以下の手順では、site initializer を 2 回実行することはないためです。

## 手順 2: デプロイの準備をする {#step-2-get-ready-to-deploy}

1. Liferay Cloud の[コマンドラインツール](https://learn.liferay.com/w/dxp/cloud/reference/command-line-tool)をインストールし、`lcp login` でサインインします。

1. デプロイ先の拡張環境の ID を `<project>-<environment>` の形式で確認します。Liferay Cloud コンソールに表示されています。

1. [最新リリース](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest)から、次のファイルをダウンロードします。

    - [`liferay-forums-batch.zip`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest/download/liferay-forums-batch.zip)
    - [`liferay-forums-etc-spring-boot.zip`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest/download/liferay-forums-etc-spring-boot.zip)
    - [`liferay-forums-site-initializer.zip`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest/download/liferay-forums-site-initializer.zip)

## 手順 3: batch をデプロイする {#step-3-deploy-the-batch}

1. batch をデプロイします。

    ```bash
    lcp deploy -p <project>-<environment> --extension liferay-forums-batch.zip
    ```

1. ジョブが完了するまで待ちます。*Applications* → *Notification Templates* に、batch が最後に作成する **C2M0 Notification Email Reply** と **C2M0 Notification Email Mention** が表示されれば完了です。その後、*Control Panel* → *Objects* に **C2M0 Forums** フォルダーが表示され、7 つのオブジェクト（C2M0 Attachment、C2M0 Message、C2M0 Subscription、C2M0 Suspicious Activity、C2M0 Thread、C2M0 User、C2M0 Vote）が含まれています。

{: .warning }
batch が完了するまで先に進まないでください。次の手順でデプロイするマイクロサービスは、その時点で存在するフォーラムの部分にしかアクセス権を得られません。早すぎるタイミングでデプロイすると、アクセス権を得られず、すべての投稿が **Your account has been banned from participating in the forums.** というメッセージで拒否されます。

## 手順 4: マイクロサービスをデプロイする {#step-4-deploy-the-microservice}

```bash
lcp deploy -p <project>-<environment> --extension liferay-forums-etc-spring-boot.zip
```

Liferay がマイクロサービスを登録し、Liferay Cloud がその認証情報を使ってマイクロサービスを起動します。その後、*Control Panel* → *Security* → *OAuth 2 Administration* に **Liferay Forums Etc Spring Boot OAuth Application Headless Server** と **Liferay Forums Etc Spring Boot OAuth Application User Agent** が表示されます。

## 手順 5: site initializer をデプロイする {#step-5-deploy-the-site-initializer}

```bash
lcp deploy -p <project>-<environment> --extension liferay-forums-site-initializer.zip
```

そのジョブによって、`/web/forums` にフォーラムサイトが作成されます。

## 手順 6: メール通知を設定する {#step-6-set-up-email-notifications}

batch によって、仮の送信元アドレスを持つメールテンプレートが 2 つ作成されています。メンバーにメールが届く前に、実際のアドレスを設定し、Liferay Cloud コンソールからマイクロサービスのサービス `liferayforumsetcspringboot` を再起動してください。[メール通知](../administering/email-notifications.html)を参照してください。

## 手順 7: インストールを確認する {#step-7-check-the-installation}

`/web/forums` のフォーラムサイトについて、[インストールの確認](checking.html)に進みます。

返信が拒否される場合は、[æç¨¿ãæå¦ããã](checking.html#posts-are-rejected) を参照してください。

## API 呼び出しの上限 {#api-call-limit}

Liferay SaaS では、ユーザーごと、1 時間あたりの API 呼び出し数に上限があります。マイクロサービスは、投稿のたびに単一のユーザーとして、すべてのフォーラムサイトの分をまとめて Liferay を呼び出します。利用の多いフォーラムや、利用の多いフォーラムサイトが複数ある場合は上限に達することがあり、その場合はその 1 時間が終わるまで投稿が拒否されます。大量の利用が見込まれる場合は、現在の上限を Liferay サポートに確認してください。

## 以降のデプロイ {#later-deploys}

- **batch を再度デプロイしないでください。** デプロイのたびにそのジョブが再実行され、メールテンプレートがすでに存在するため、失敗した項目が報告されます。データとテンプレートへの変更は保持されますが、ジョブは失敗として表示されます。
- **site initializer を再度デプロイしないでください。** そのジョブが再実行され、フォーラムサイトのアドレスが `/web/group-<number>` にリセットされて、フォーラムのリンクが壊れます。LPD-85594 では、Liferay SaaS でこれを防げません。これが起きた場合は、*Site Settings* でフレンドリー URL を元に戻してください。
- **マイクロサービスを再度デプロイする**のは、その新しいバージョンがある場合だけにし、デプロイ後に返信を確認してください。

## フォーラムサイトの追加 {#adding-more-forum-sites}

フォーラムサイトごとに、リリースのソースコードからビルドした専用の site initializer の zip を用意し、1 回だけデプロイします。マイクロサービスの再起動は不要です。[複数のサイト](creating-sites.html#several-sites)を参照してください。

## 関連情報 {#related-information}

- [Liferay PaaS の場合](paas.html)
- [インストール](./)
