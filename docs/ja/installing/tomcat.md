---
title: Liferay Self-Hosted (Tomcat)
parent: インストール
nav_order: 1
---

# Liferay Self-Hosted (Tomcat) へのインストール {#installing-on-liferay-self-hosted-tomcat}
{: .no_toc }

ご自身で管理するサーバーに Tomcat バンドルから Liferay をインストールしている場合は、次の手順に従ってください。

{: .important }
Liferay サーバーのファイルにアクセスできること、Liferay の[パッチングツール](https://learn.liferay.com/w/dxp/self-hosted-installation-and-upgrades/maintaining-a-liferay-installation/patching-liferay)で[必要な Liferay の修正](./#required-liferay-fixes)がインストールされているか、その回避策が適用されていること、そして開始前に Liferay の起動が完了していることが必要です。以下の手順では、`<liferay-home>` は Liferay のインストールフォルダー、つまり `osgi` フォルダーと `routes` フォルダーを含むフォルダーです。

1. TOC
{:toc}

## 手順 1: リリースをダウンロードする {#step-1-download-the-release}

[最新リリース](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest)から、次のファイルをダウンロードします。

- [`liferay-forums-batch.zip`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest/download/liferay-forums-batch.zip)
- [`liferay-forums-etc-spring-boot.zip`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest/download/liferay-forums-etc-spring-boot.zip)
- [`liferay-forums-site-initializer.zip`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest/download/liferay-forums-site-initializer.zip)
- [`generate-site-initializer-zips.sh`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest/download/generate-site-initializer-zips.sh)（スクリプトを使って複数のフォーラムサイトを運用する場合のみ）。[フォーラムサイトの作成](creating-sites.html#a-shortcut-on-liferay-self-hosted)を参照してください。

## 手順 2: batch をデプロイする {#step-2-deploy-the-batch}

1. `liferay-forums-batch.zip` を `<liferay-home>/osgi/client-extensions` にコピーします。

1. コピーした後、Liferay のログに `Finished batch engine import task` を含む行が 5 行表示されるまで待ちます。これには 1 分ほどかかります。

{: .warning }
5 つすべてが完了するまで先に進まないでください。次の手順でデプロイするマイクロサービスは、その時点で存在するフォーラムの部分にしかアクセス権を得られません。また、Liferay は起動中にもこの行をいくつかログに出力するため、コピーした後の行だけを数えてください。

## 手順 3: マイクロサービスの zip をデプロイする {#step-3-deploy-the-microservices-zip}

`liferay-forums-etc-spring-boot.zip` を `<liferay-home>/osgi/client-extensions` にコピーします。

Liferay はマイクロサービスを登録し、その認証情報を `<liferay-home>/routes/default` に書き込みます。Liferay はマイクロサービス自体は実行しません。次の手順でマイクロサービスを起動します。

## 手順 4: マイクロサービスを起動する {#step-4-start-the-microservice}

マイクロサービスは、Liferay が動作しているときは常に動作している必要があります。投稿、通知、モデレーションはすべてマイクロサービスに依存しています。可能であれば、Liferay のマシンで実行してください。そのほうが簡単です。

### Liferay のマシンで実行する場合 {#on-the-liferay-machine}

1. `liferay-forums-etc-spring-boot.zip` を、`/opt/liferay-forums` など任意のフォルダーに展開します。

1. そのフォルダーから、`LIFERAY_HOME` に Liferay のインストールフォルダーを設定して起動します。マイクロサービスはそこから Liferay のアドレスと認証情報を見つけるため、設定は不要です。

    Linux の場合:

    ```bash
    LIFERAY_HOME=/opt/liferay ./start.sh
    ```

    Windows の場合:

    ```bat
    set LIFERAY_HOME=C:\liferay
    start.bat
    ```

    routes が存在しないというメッセージを出して停止した場合は、その zip がまだその Liferay にデプロイされていないか、`LIFERAY_HOME` が誤ったフォルダーを指しています。

1. 動作していることを確認します。次のコマンドで `READY` と出力されます。

    ```bash
    curl http://localhost:58081/ready
    ```

{: .tip }
Linux で再起動後も動作させ続けるには、システムサービスとして実行します。たとえば、`/etc/systemd/system/liferay-forums.service` に次の systemd ユニットを作成します。

```ini
{% include snippet.md file="liferay-forums.service" indent="" %}
```

{% include download.html file="liferay-forums.service" %}

その後、`sudo systemctl enable --now liferay-forums` を実行します。

### 別のマシンで実行する場合 {#on-another-machine}

Liferay は常に `localhost:58081` でマイクロサービスを呼び出します。そのため、Liferay のマシンのポート `58081` をマイクロサービスのマシンに転送する必要があります。

1. マイクロサービスのマシンで、`liferay-forums-etc-spring-boot.zip` を任意のフォルダーに展開します。

1. jar と同じ場所にある `application.properties` で、次の 4 つの設定のコメントを外し、値を入力します。

    ```properties
    com.liferay.lxc.dxp.mainDomain=liferay.example.com
    com.liferay.lxc.dxp.server.protocol=https
    liferay-forums-etc-spring-boot-oahs.oauth2.headless.server.client.id=<client ID>
    liferay-forums-etc-spring-boot-oahs.oauth2.headless.server.client.secret=<client secret>
    ```

    `mainDomain` と `server.protocol` は、マイクロサービスが Liferay に接続する方法です。ポートが 80 または 443 でない場合は、`mainDomain` にポートを含めてください。クライアント ID とシークレットは、*Control Panel* → *Security* → *OAuth 2 Administration* にある **Liferay Forums Etc Spring Boot OAuth Application Headless Server** のものです。

1. `LIFERAY_HOME` を設定せずに起動します。Linux では `./start.sh`、Windows では `start.bat` です。

1. Liferay のマシンで、ポート `58081` をマイクロサービスのマシンに転送し、マイクロサービスが動作している間は転送を維持します。マシン間のファイアウォールでは、ポート `58081` を許可してください。Liferay のマシンで `socat` を実行するか、

    ```bash
    socat TCP-LISTEN:58081,bind=127.0.0.1,fork,reuseaddr TCP:<microservice-host>:58081
    ```

    マイクロサービスのマシンから SSH トンネルを開きます。

    ```bash
    ssh -N -R 58081:localhost:58081 <user>@<liferay-host>
    ```

1. Liferay のマシンで、転送がマイクロサービスに届くことを確認します。次のコマンドで `READY` と出力されます。

    ```bash
    curl http://localhost:58081/ready
    ```

## 手順 5: メール通知を設定する {#step-5-set-up-email-notifications}

batch によって、仮の送信元アドレスを持つメールテンプレートが 2 つ作成されています。メンバーにメールが届く前に、実際のアドレスを設定し、マイクロサービスを再起動してください。[メール通知](../administering/email-notifications.html)を参照してください。

## 手順 6: フォーラムサイトを作成する {#step-6-create-the-forum-sites}

[フォーラムサイトの作成](creating-sites.html)に進みます。

## 関連情報 {#related-information}

- [インストールの確認](checking.html)
- [インストール](./)
