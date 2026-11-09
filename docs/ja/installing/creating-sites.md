---
title: フォーラムサイトの作成
parent: インストール
nav_order: 5
---

# フォーラムサイトの作成 {#creating-forum-sites}
{: .no_toc }

各フォーラムは Liferay のサイトで、実行中の Liferay に site initializer をデプロイしたときに、site initializer によって作成されます。site initializer が作成するサイトはちょうど 1 つなので、フォーラムサイトごとに専用の site initializer が必要です。batch とマイクロサービスはすべてのフォーラムサイトで共有され、1 回だけデプロイします。

{: .note }
既存のサイトにフォーラムを追加することはできません。Liferay がサイトのページを設定するのは、サイトを作成するときだけだからです。代わりにフォーラムサイトを作成し、既存のサイトからそのサイトにリンクしてください。

1. TOC
{:toc}

## 1 つのサイト {#one-site}

`liferay-forums-site-initializer.zip` は、`/web/forums` にサイト **FORUMS** を作成します。

- **Liferay Self-Hosted (Tomcat):** zip を `<liferay-home>/osgi/client-extensions` にコピーします。Liferay は 1 分ほどでサイトを作成します。サイトが作成されたら、zip を再び削除します。
- **Liferay Self-Hosted (Docker):** zip をコンテナーにコピーし、サイトが作成されるのを待ってから、zip を削除します。

    ```bash
    docker cp liferay-forums-site-initializer.zip forums-liferay:/opt/liferay/osgi/client-extensions/
    docker exec forums-liferay rm /opt/liferay/osgi/client-extensions/liferay-forums-site-initializer.zip
    ```

- **Liferay PaaS と Liferay SaaS:** インストールの過程で作成されます。[Liferay PaaS の場合](paas.html)または [Liferay SaaS の場合](saas.html)を参照してください。

zip を削除しても、サイトは変わりません。zip を削除しておくと、サイトが削除された場合に、site initializer がそのサイトを空の状態で再作成することを防げます。

## 複数のサイト {#several-sites}

サイトを追加する前に、[複数のフォーラムサイトの運用](../administering/several-sites.html)、特にモデレーターについての説明を参照してください。

### 手順 1: サイトごとに site initializer を作成する {#step-1-make-a-site-initializer-for-each-site}

フォーラムの site initializer プロジェクトをサイトごとに 1 回コピーし、各コピーに固有の名前を付けます。

1. [最新リリース](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest)から、フォーラムのソースコード `liferay-forums-<version>-source.zip` をダウンロードして展開します。`liferay-forums-1.0.0` のように、`liferay-forums-<version>` という名前のフォルダーに展開されます。以下のコマンドはそのフォルダーから実行します。

1. `client-extensions/liferay-forums-site-initializer` フォルダー全体を、その中身ごと、隣にサイト名を付けた新しいフォルダーとしてコピーします。*Acme* という名前のサイトの場合:

    ```bash
    cp -r client-extensions/liferay-forums-site-initializer client-extensions/liferay-forums-site-initializer-acme
    ```

    Liferay PaaS では、代わりに PaaS プロジェクトのリポジトリの `liferay/client-extensions` に、`liferay/client-extensions/liferay-forums-site-initializer-acme` としてコピーします。

    これで 2 つのフォルダーが並びます。元のフォルダーはそのままにし、コピーだけを変更します。

    ```
    client-extensions/
    ├── liferay-forums-site-initializer/
    └── liferay-forums-site-initializer-acme/
        ├── build.gradle
        ├── client-extension.yaml    ← the only file you change
        └── site-initializer/
    ```

1. コピーで `client-extension.yaml` を開き、その内容全体を新しいサイト用の名前に置き換えます。その中のすべての名前（2 つのキー、OAuth アプリケーション、サイトの外部参照コード）は、そのコピーに固有のものにする必要があります。*Acme* という名前のサイトの場合:

    ```yaml
    liferay-forums-site-initializer-acme:
        name: Liferay Forums Site Initializer Acme
        oAuthApplicationHeadlessServer: liferay-forums-site-initializer-acme-oahs
        siteExternalReferenceCode: LIFERAY_ACME
        siteName: Acme
        type: siteInitializer
    liferay-forums-site-initializer-acme-oahs:
        .serviceAddress: localhost:8080
        .serviceScheme: http
        name: Liferay Forums Site Initializer Acme OAuth Application Headless Server
        scopes:
            -   Liferay.Headless.Site.everything
        type: oAuthApplicationHeadlessServer
    ```

    Liferay は `siteName` からサイトのアドレスを作成します。このサイトは `/web/acme` で公開されます。

1. プロジェクトを自動でビルドする Liferay PaaS 以外では、展開したフォルダーからコピーをビルドします。Java 17 以降が必要です。

    ```bash
    ./gradlew :client-extensions:liferay-forums-site-initializer-acme:build
    ```

    zip は `client-extensions/liferay-forums-site-initializer-acme/dist/liferay-forums-site-initializer-acme.zip` です。

### 手順 2: 1 回だけデプロイする {#step-2-deploy-it-once}

- **Liferay Self-Hosted（Tomcat または Docker）:** 各 zip を [1 つのサイト](#one-site)のとおりデプロイし、サイトが作成されたら削除します。
- **Liferay PaaS:** プッシュしてビルドをデプロイします。`liferayforumsetcspringboot` サービスを再起動し、サイトを確認します。その後、コピーのフォルダーをリポジトリから削除し、プッシュしてそのビルドをデプロイし、再度サービスを再起動します。そうしないと、そのジョブがデプロイのたびに再実行され、サイトのアドレスがリセットされます。[以降のデプロイ](paas.html#later-deploys)を参照してください。
- **Liferay SaaS:** zip をデプロイし、二度とデプロイしないでください。再度デプロイすると、そのジョブがサイトのアドレスをリセットします。

    ```bash
    lcp deploy -p <project>-<environment> --extension client-extensions/liferay-forums-site-initializer-acme/dist/liferay-forums-site-initializer-acme.zip
    ```

その後、新しい各サイトをそのアドレスで確認し、そこで返信を投稿してください。

### Liferay Self-Hosted での近道 {#a-shortcut-on-liferay-self-hosted}

Liferay Self-Hosted（Tomcat または Docker）では、[最新リリース](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest)に添付されている `generate-site-initializer-zips.sh` スクリプトを使うと、ビルドせずに `liferay-forums-site-initializer.zip` からコピーを作成できます。このスクリプトは Linux 上で、Bash、`unzip`、`zip` を使って動作します。このスクリプトで作成した zip は、Liferay PaaS や SaaS では使用しないでください。これらの zip はすべて 1 つの OAuth アプリケーションを共有しており、Liferay 自体にデプロイした場合にのみ動作します。

1. スクリプトを `liferay-forums-site-initializer.zip` と同じフォルダーに置きます。

1. スクリプトの冒頭付近にある `SITES` リストを編集します。各エントリーは、サイトの外部参照コードをサイト名に対応付けます。

    ```bash
    declare -A SITES=(
    	[LIFERAY_ACME]="Acme, Inc. site"
    	[LIFERAY_NORTHWIND]="Northwind site"
    )
    ```

1. スクリプトを実行します。サイトごとに 1 つの zip が `out` フォルダーに書き込まれます。オプションを確認するには、`--help` を付けて実行します。

    ```bash
    bash generate-site-initializer-zips.sh
    ```

1. 生成された zip を [1 つのサイト](#one-site)のとおりデプロイし、サイトが作成されたら削除します。

*Acme, Inc. site* という名前のサイトは、`/web/acme-inc.-site` で公開されます。別のアドレスを使用するには、別の名前を選ぶか、サイトの作成後に *Site Settings* でサイトのフレンドリー URL を変更します。

## 関連情報 {#related-information}

- [インストールの確認](checking.html)
- [複数のフォーラムサイトの運用](../administering/several-sites.html)
