---
title: Liferay Self-Hosted (Docker)
parent: インストール
nav_order: 2
---

# Liferay Self-Hosted (Docker) へのインストール {#installing-on-liferay-self-hosted-docker}
{: .no_toc }

Liferay と PostgreSQL はコンテナーで動作し、フォーラムのマイクロサービスは Liferay のネットワークを共有する 3 つ目のコンテナーで動作します。そのため、サーバーの場合と同様に、Liferay は `localhost:58081` でマイクロサービスに接続します。フォーラムの zip は、サーバーの場合と同じ順序で、実行中の Liferay コンテナーにコピーします。これらの手順は `liferay/dxp:2026.q1.4-lts` イメージでテストされています。

{: .important }
Docker が必要です。コマンドは、[最新リリース](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest)からダウンロードしたリリースの 3 つの zip があるフォルダーから実行してください。

1. TOC
{:toc}

## 手順 1: Liferay の修正を追加する {#step-1-add-the-liferay-fixes}

zip と同じ場所に `patching` という名前のフォルダーを作成し、Liferay サポートから入手した hotfix をそこに置きます。Liferay は、コンテナーが起動するたびにその hotfix をインストールします。hotfix を使用しない場合は、フォルダーを空のままにして、[回避策](./#without-a-hotfix)を使用してください。

## 手順 2: PostgreSQL と Liferay を起動する {#step-2-start-postgresql-and-liferay}

1. コンテナー用のネットワークを作成し、PostgreSQL を起動します。ここと次のコマンドで、`change-me` をご自身のパスワードに置き換えてください。

    ```bash
    docker network create forums
    docker run -d --name forums-postgres --network forums --restart unless-stopped \
      -e POSTGRES_DB=lportal -e POSTGRES_USER=liferay -e POSTGRES_PASSWORD=change-me \
      -v forums-postgres-data:/var/lib/postgresql/data \
      postgres:16.15
    ```

1. Liferay を起動します。`forums-liferay-routes` ボリュームには、Liferay がマイクロサービス用に書き込む認証情報が保存されます。

    ```bash
    docker run -d --name forums-liferay --network forums -p 8080:8080 --restart unless-stopped \
      -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_DRIVER_UPPERCASEC_LASS_UPPERCASEN_AME=org.postgresql.Driver \
      -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_URL=jdbc:postgresql://forums-postgres:5432/lportal \
      -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_USERNAME=liferay \
      -e LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_PASSWORD=change-me \
      -v forums-liferay-data:/opt/liferay/data \
      -v forums-liferay-routes:/opt/liferay/routes \
      -v "$PWD/patching:/mnt/liferay/patching" \
      liferay/dxp:2026.q1.4-lts
    ```

1. Liferay が起動するまで待ちます。`docker logs forums-liferay` に `Server startup in` と表示されれば起動しています。これには数分かかります。起動後、Liferay は `http://localhost:8080` で利用できます。

## 手順 3: batch をデプロイする {#step-3-deploy-the-batch}

1. batch を実行中のコンテナーにコピーします。

    ```bash
    docker cp liferay-forums-batch.zip forums-liferay:/opt/liferay/osgi/client-extensions/
    ```

1. ログを追跡し、コピーした後に `Finished batch engine import task` を含む行が 5 行表示されるまで待ってから、**Ctrl+C** を押します。

    ```bash
    docker logs -f --since 2m forums-liferay | grep "Finished batch engine import task"
    ```

{: .warning }
Liferay は起動中にもこの行をいくつかログに出力します。コピーした後の行だけを数え、5 つすべてが完了するまで先に進まないでください。

## 手順 4: マイクロサービスの zip をデプロイする {#step-4-deploy-the-microservices-zip}

```bash
docker cp liferay-forums-etc-spring-boot.zip forums-liferay:/opt/liferay/osgi/client-extensions/
```

`docker logs forums-liferay` に `STARTED liferayforumsetcspringboot` と表示されるまで待ちます。

## 手順 5: マイクロサービスを起動する {#step-5-start-the-microservice}

1. zip に含まれる `Dockerfile` から、マイクロサービスのイメージをビルドします。

    ```bash
    mkdir microservice
    unzip liferay-forums-etc-spring-boot.zip -d microservice
    docker build -t liferay-forums-microservice microservice
    ```

1. Liferay のネットワークで、Liferay の認証情報のボリュームを使って起動します。

    ```bash
    docker run -d --name forums-microservice --network container:forums-liferay --restart unless-stopped \
      -v forums-liferay-routes:/opt/liferay/routes:ro \
      -e LIFERAY_ROUTES_CLIENT_EXTENSION=/opt/liferay/routes/default/liferay-forums-etc-spring-boot \
      -e LIFERAY_ROUTES_DXP=/opt/liferay/routes/default/dxp \
      liferay-forums-microservice
    ```

1. Liferay からマイクロサービスに接続できることを確認します。次のコマンドで `READY` と出力されます。

    ```bash
    docker exec forums-liferay curl -s http://localhost:58081/ready
    ```

## 手順 6: メール通知を設定する {#step-6-set-up-email-notifications}

batch によって、仮の送信元アドレスを持つメールテンプレートが 2 つ作成されています。メンバーにメールが届く前に、実際のアドレスを設定し、`docker restart forums-microservice` でマイクロサービスを再起動してください。[メール通知](../administering/email-notifications.html)を参照してください。

## 手順 7: フォーラムサイトを作成する {#step-7-create-the-forum-sites}

[フォーラムサイトの作成](creating-sites.html)に進みます。

## 日常の運用 {#day-to-day}

- **Liferay のコンテナーを再起動した後は、** マイクロサービスのコンテナーも再起動してください。マイクロサービスは Liferay のネットワークを共有しているためです: `docker restart forums-microservice`。
- **zip は Liferay のコンテナー内にあります。** 設定やイメージを変更するためなどにコンテナーを削除して新しいコンテナーを起動すると、新しいコンテナーにはフォーラムの zip が 1 つもありません。手順 3 と手順 4 のとおり、batch をコピーしてから、マイクロサービスの zip をコピーしてください。その後、マイクロサービスのコンテナーを削除し、手順 5 の `docker run` コマンドで再度起動します。マイクロサービスのコンテナーは古い Liferay コンテナーに結び付いているため、再起動では失敗します。

    ```bash
    docker rm -f forums-microservice
    ```
- **ログ:** `docker logs forums-liferay` と `docker logs forums-microservice` です。

## 関連情報 {#related-information}

- [インストールの確認](checking.html)
- [インストール](./)
