---
title: Liferay Workspace を使った開発
parent: インストール
nav_order: 8
---

# Liferay Workspace を使った開発 {#developing-with-a-liferay-workspace}
{: .no_toc }

ご自身の Liferay のコードを [Liferay Workspace](https://learn.liferay.com/w/dxp/liferay-development/tooling/liferay-workspace) でビルドしている場合は、フォーラムのプロジェクトを Workspace に追加し、ご自身のコードと一緒にビルドして、開発用に Workspace 自体の Liferay バンドルにデプロイできます。

これはフォーラムをインストールする別の方法ではありません。サーバー、Docker、または Liferay SaaS にインストールするには、ここで zip をビルドしてから、その zip を使って[インストール](./)の手順に従ってください。Liferay PaaS プロジェクトの `liferay` フォルダーはすでに Workspace です。[Liferay PaaS の場合](paas.html)の手順に従ってください。

{: .important }
Liferay Workspace Gradle プラグイン 15.0.0 と Liferay DXP 2026.Q1.4 でテストされています。[Blade](https://learn.liferay.com/w/dxp/liferay-development/tooling/blade-cli) が必要です。または、`blade gw` の代わりに Workspace の `./gradlew` を実行してください。

1. TOC
{:toc}

## 手順 1: フォーラムのプロジェクトを追加する {#step-1-add-the-forums-projects}

1. [最新リリース](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest)から、フォーラムのソースコード `liferay-forums-<version>-source.zip` をダウンロードして展開します。`liferay-forums-1.0.0` のように、`liferay-forums-<version>` という名前のフォルダーに展開されます。

1. 次の 3 つのフォルダーを、Workspace の `client-extensions` フォルダーにコピーします。

    - `client-extensions/liferay-forums-batch`
    - `client-extensions/liferay-forums-etc-spring-boot`
    - `client-extensions/liferay-forums-site-initializer`

Workspace は、ほかに何も変更しなくても、これらをご自身のプロジェクトと並ぶ client extension プロジェクトとして認識します。

## 手順 2: ビルドする {#step-2-build-them}

Workspace のルートフォルダーから実行します。

```bash
blade gw build
```

各 zip は、そのプロジェクトの `dist` フォルダーに書き込まれます。たとえば `client-extensions/liferay-forums-batch/dist/liferay-forums-batch.zip` です。これらはリリースの zip と同じものです。

## 手順 3: Workspace のバンドルにデプロイする {#step-3-deploy-them-to-the-workspaces-bundle}

`blade server init` で設定した Workspace の Liferay バンドルが対象です。バンドルを起動し、起動が完了するまで待ちます。各プロジェクトの `deploy` タスクは、そのプロジェクトの zip だけをバンドル（デフォルトでは `bundles/osgi/client-extensions`）にコピーします。

{: .warning }
**`blade gw deploy` でインストールしないでください。** Workspace 全体のデプロイでは、すべてのプロジェクトが一度にデプロイされるため、batch の完了前にマイクロサービスの zip が届くことがあり、その場合はすべての投稿が拒否されます。

プロジェクトを `client-extensions/forums` などのサブフォルダーに置いた場合は、タスクのパスもそれに従います: `:client-extensions:forums:liferay-forums-batch:deploy`。

1. **batch。** その後、Liferay のログに `Finished batch engine import task` を含む行が 5 行表示されるまで待ちます。

    ```bash
    blade gw :client-extensions:liferay-forums-batch:deploy
    ```

1. **マイクロサービスの zip:**

    ```bash
    blade gw :client-extensions:liferay-forums-etc-spring-boot:deploy
    ```

1. **マイクロサービスを起動します。** [Liferay Self-Hosted (Tomcat) の手順 4](tomcat.html#step-4-start-the-microservice) と同様に、`client-extensions/liferay-forums-etc-spring-boot/dist/liferay-forums-etc-spring-boot.zip` をフォルダーに展開し、`LIFERAY_HOME` にバンドルのフルパスを設定して起動します。`start.sh` は自身のフォルダーから実行されるため、フルパスを使用してください。

    ```bash
    LIFERAY_HOME=/home/me/my-workspace/bundles ./start.sh
    ```

1. [メール通知](../administering/email-notifications.html)のとおり**メール通知を設定し、** その後、マイクロサービスを再起動します。

1. **フォーラムサイト。** サイトが作成されたら、`bundles/osgi/client-extensions` から `liferay-forums-site-initializer.zip` を削除します。

    ```bash
    blade gw :client-extensions:liferay-forums-site-initializer:deploy
    ```

さらにフォーラムサイトを追加するには、[複数のサイト](creating-sites.html#several-sites)のとおり、サイトごとに site initializer プロジェクトのコピーを追加し、それぞれ専用の `deploy` タスクでデプロイします。

## 手順 4: インストールを確認する {#step-4-check-the-installation}

[インストールの確認](checking.html)に進みます。

## 避けるべきこと {#things-to-avoid}

- **以降の Workspace 全体のデプロイ**では、変更されていないプロジェクトはスキップされるため、ご自身のコードのための `blade gw deploy` でフォーラムが再度デプロイされることはありません。`blade gw clean` の後や、フォーラムのプロジェクトを変更した後は、フォーラムの zip がすべて一度に再デプロイされます。その場合は、新しい認証情報を得たマイクロサービスを再起動し、[batch ã®åããã­ã¤](../reference/known-issues.html#deploying-the-batch-again) を参照してください。
- **Workspace の Docker タスク**（`buildDockerImage` や `startDockerContainer` など）は、すべてのプロジェクトを Liferay のイメージに含めます。Liferay はそれらを起動中にデプロイしますが、これはマイクロサービスと site initializer にとっては早すぎます。Docker の場合は、ここで zip をビルドしてから、[Liferay Self-Hosted (Docker)](docker.html) の手順に従ってください。

## 関連情報 {#related-information}

- [Liferay Self-Hosted (Tomcat)](tomcat.html)
- [フォーラムサイトの作成](creating-sites.html)
