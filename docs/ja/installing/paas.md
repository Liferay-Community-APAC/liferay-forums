---
title: Liferay PaaS の場合
parent: インストール
nav_order: 3
---

# Liferay PaaS へのインストール {#installing-on-liferay-paas}
{: .no_toc }

Liferay PaaS では、フォーラムの 3 つのプロジェクトを PaaS プロジェクトのリポジトリに追加し、プロジェクトの他の部分と一緒にデプロイします。それぞれが独立した PaaS サービスとして動作します。batch とフォーラムサイトはジョブとして、マイクロサービスは常時稼働するサービスとして動作します。

{: .warning }
これらの手順は、必要な修正を適用したクリーンな Liferay DXP 2026.Q1.4 LTS で、Liferay PaaS が client extension を実行する方法をローカルで再現した環境でテストされたものです。Liferay PaaS の環境ではまだテストされていません。client extension は、Liferay PaaS ではベータ機能です。

1. TOC
{:toc}

## 手順 1: プロジェクトを準備する {#step-1-prepare-the-project}

Liferay の [Configuring Liferay PaaS for Client Extensions](https://learn.liferay.com/w/dxp/cloud/customizing-liferay-dxp-in-the-cloud/configuring-liferay-paas-for-client-extensions) に従ってください。特に、次の点に注意してください。

1. `infra` 環境に client extension のビルドパイプラインがない場合は、Liferay Cloud サポートに有効化を依頼します。

1. 環境の Web サーバーで Basic 認証を使用している場合は、`/o` パスを認証なしで通過させます。Liferay とマイクロサービスは、`/o` の下で互いを呼び出します。

1. Liferay サービスの設定に `virtual.hosts.valid.hosts` と `web.server.protocol` が設定されている場合は、削除します。client extension はこれらの設定があると動作しません。

## 手順 2: Liferay の修正をインストールする {#step-2-install-the-liferay-fixes}

フォーラムのプロジェクトを追加する前に、[必要な Liferay の修正](./#required-liferay-fixes)を含む hotfix をインストールします。

1. 次のいずれかの方法で、hotfix をプロジェクトに追加します。

    - **すべての環境に適用する場合:** `ci/LCP.json` で、環境変数 `LCP_CI_LIFERAY_DXP_HOTFIXES_COMMON` に、hotfix の名前を `.zip` なしで設定します。

        ```json
        "env": {
          "LCP_CI_LIFERAY_DXP_HOTFIXES_COMMON": "<hotfix-name>"
        }
        ```

    - **1 つの環境に適用する場合:** 代わりに `LCP_CI_LIFERAY_DXP_HOTFIXES_<ENVIRONMENT>` を使用します。たとえば `LCP_CI_LIFERAY_DXP_HOTFIXES_PRD` です。
    - **リポジトリに置く場合:** hotfix の zip を `liferay/configs/<environment>/patching/`（たとえば `liferay/configs/prd/patching/`）に、環境ごとに 1 回ずつ置きます。

1. 変更をプッシュし、そのビルドを[手順 4](#step-4-deploy-the-first-build) のとおり環境にデプロイします。

1. Liferay サービスが再起動したら、そのログに `The following patches are installed:` と hotfix が表示されていることを確認します。

hotfix のインストールについて詳しくは、Liferay の [Deploying to the Liferay Service](https://learn.liferay.com/w/dxp/cloud/customizing-liferay-dxp-in-the-cloud/using-the-liferay-dxp-service/deploying-to-the-liferay-service) を参照してください。

## 手順 3: フォーラムのプロジェクトを追加する {#step-3-add-the-forums-projects}

1. [最新リリース](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest)から、フォーラムのソースコード `liferay-forums-<version>-source.zip` をダウンロードして展開します。`liferay-forums-1.0.0` のように、`liferay-forums-<version>` という名前のフォルダーに展開されます。

1. 次の 3 つのフォルダーを、PaaS プロジェクトのリポジトリの `liferay/client-extensions` にコピーします。

    - `client-extensions/liferay-forums-batch`
    - `client-extensions/liferay-forums-etc-spring-boot`
    - `client-extensions/liferay-forums-site-initializer`

## 手順 4: 最初のビルドをデプロイする {#step-4-deploy-the-first-build}

1. プロジェクトをプッシュします。Liferay Cloud がビルドします。client extension のビルドは **Custom Services** ビルドです。

1. Liferay Cloud コンソールで **Builds** を開き、そのビルドで **Deploy Build to...** を選択して、環境を選びます。

デプロイが完了すると、ジョブによってフォーラムのデータと `/web/forums` のフォーラムサイトが作成され、マイクロサービスが起動しています。次の点を確認してください。

- Liferay サービスのログに、`Finished batch engine import task` を含む行が、batch のファイルごとに 1 行ずつ、計 5 行表示されている。
- *Control Panel* → *Objects* に **C2M0 Forums** フォルダーがあり、7 つのオブジェクト（C2M0 Attachment、C2M0 Message、C2M0 Subscription、C2M0 Suspicious Activity、C2M0 Thread、C2M0 User、C2M0 Vote）が表示されている。
- *Control Panel* → *Security* → *OAuth 2 Administration* に、フォーラムのアプリケーションが 4 つ表示されている。batch と site initializer に 1 つずつ、マイクロサービスに 2 つ（**Liferay Forums Etc Spring Boot OAuth Application Headless Server** と **User Agent**）です。

この時点では、すべての返信が **Your account has been banned from participating in the forums.** というメッセージで拒否されます。これは想定どおりです。Liferay はフォーラムのデータが存在する前にマイクロサービスを登録したため、マイクロサービスにはまだデータへのアクセス権がありません。次の 2 つの手順でこれを解決します。

## 手順 5: 2 回目のビルドをデプロイする {#step-5-deploy-a-second-build}

フォーラムのジョブはデプロイのたびに再実行されますが、フォーラムのデータとサイトが存在するようになった今、再実行されるべきではありません。

- 2 回目以降のデプロイでは、フォーラムの 2 つのメールテンプレートがすでに存在するため、batch のジョブが失敗した項目を報告します。
- site initializer のジョブが再実行されるたびに、フォーラムサイトのアドレスが `/web/group-<number>` にリセットされ、フォーラムのリンクが壊れます。LPD-85594 では、Liferay PaaS でこれを防げません。

そのため、2 回目のビルドではメールテンプレートのファイルと site initializer を除外します。

1. 次のファイルとフォルダーをリポジトリから削除します。

    ```
    liferay/client-extensions/liferay-forums-batch/batch/05-notification-email-template.batch-engine-data.json
    liferay/client-extensions/liferay-forums-site-initializer
    ```

1. プッシュし、手順 4 のとおり新しいビルドを環境にデプロイします。

Liferay はマイクロサービスを再登録し、今度はフォーラムのデータへのアクセス権を付与して、新しい認証情報を与えます。batch のジョブは、このデプロイ以降のすべてのデプロイで成功し、メールテンプレートは、加えた変更も含めてそのまま残ります。フォーラムサイトは、ページとコンテンツを含めて `/web/forums` に残ります。site initializer を削除しても、そのサイトは削除されません。

## 手順 6: マイクロサービスを再起動する {#step-6-restart-the-microservice}

Liferay Cloud コンソールで `liferayforumsetcspringboot` サービスを再起動し、新しい認証情報を使用させます。これで返信が受け付けられるようになります。

{: .note }
再起動後も返信が拒否される場合は、Liferay が `localhost:58081` でマイクロサービスに接続できていない可能性があります。`liferay/client-extensions/liferay-forums-etc-spring-boot/client-extension.yaml` で、`.serviceAddress: localhost:58081` の 2 行を、マイクロサービスのサービスのアドレスである `liferayforumsetcspringboot:58081` に変更し、再度デプロイしてください。この方法は、Liferay PaaS ではまだ検証されていません。

## 手順 7: メール通知を設定する {#step-7-set-up-email-notifications}

batch によって、仮の送信元アドレスを持つメールテンプレートが 2 つ作成されています。メンバーにメールが届く前に、実際のアドレスを設定し、`liferayforumsetcspringboot` サービスを再起動してください。[メール通知](../administering/email-notifications.html)を参照してください。

## 手順 8: インストールを確認する {#step-8-check-the-installation}

`/web/forums` のフォーラムサイトについて、[インストールの確認](checking.html)に進みます。

## フォーラムサイトの追加 {#adding-more-forum-sites}

フォーラムサイトごとに、リポジトリに専用の site initializer プロジェクトを用意し、最初のサイトと同様に、1 回デプロイしてから再び削除します。[複数のサイト](creating-sites.html#several-sites)を参照してください。

## 以降のデプロイ {#later-deploys}

Liferay は、フォーラムに変更がないデプロイであっても、プロジェクトをデプロイするたびにマイクロサービスに新しい認証情報を与えます。マイクロサービスが新しい認証情報で再起動するまで、返信は **Your account has been banned from participating in the forums.** というメッセージで拒否されます。デプロイのたびに、[手順 6](#step-6-restart-the-microservice) のとおり `liferayforumsetcspringboot` サービスを再起動し、返信が受け付けられることを確認してください。

## 関連情報 {#related-information}

- [Liferay SaaS の場合](saas.html)
- [インストール](./)
