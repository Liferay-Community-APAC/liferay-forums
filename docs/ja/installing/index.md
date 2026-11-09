---
title: インストール
nav_order: 3
has_children: true
permalink: /ja/installing/
---

# インストール {#installing}
{: .no_toc }

これらのページでは、空の Liferay から動作するフォーラムサイトまで、Liferay Forums 1.0.0 のインストール手順を説明します。初回は 1 時間ほどを見込んでください。そのほとんどは Liferay の起動待ちの時間です。

1. TOC
{:toc}

## 始める前に {#before-you-begin}

次のものがそろっていることを確認してください。

- **Liferay DXP 2026.Q1 LTS**。Tomcat バンドルからインストールしたサーバー、Docker、Liferay PaaS、または Liferay SaaS 上で動作し、下記の [Liferay の修正](#required-liferay-fixes)、またはその回避策が適用されていること。
- **Liferay がサポートするデータベース**（PostgreSQL など）。フォーラムは Hypersonic では動作しません。Hypersonic は、データベースが設定されていない場合に Liferay が使用するデモ用のデータベースです。
- **Java 17 以降**。Liferay Self-Hosted (Tomcat)でフォーラムのマイクロサービスを実行するマシンと、[複数のフォーラムサイト](creating-sites.html#several-sites)用の site initializer をビルドする場合に必要です。

### 必要な Liferay の修正 {#required-liferay-fixes}

必要な修正を含む、お使いの 2026.Q1 リリース用の hotfix を Liferay サポートに依頼し、フォーラムより先にインストールしてください。Liferay SaaS では、Liferay は hotfix を 1 つの環境ではなくクラスター全体にインストールします。そのため、お使いの環境のリリースに含まれていない修正については回避策を使用してください。[Liferay SaaS の場合](saas.html#step-1-check-the-liferay-version-and-fixes)を参照してください。

| 修正 | 適用しない場合 | 必要か |
| --- | --- | --- |
| LPD-90465（2026.Q1.4 ではバックポートの LPD-112124） | 利用禁止（ban）が機能せず、モデレーターに **Lock Topic** が表示されません。 | はい |
| LPD-85594 | 既存のサイトに site initializer の zip を再度デプロイするたびに、サイトのアドレスがリセットされ、フォーラムのリンクが「見つかりません」ページを表示します。Liferay PaaS と SaaS は対象外ですが、これらではインストール手順で site initializer を再実行しないようにしています。 | はい（この修正を含む 2026.Q1.12 より前） |
| LPD-102310 | トピックの更新時に、Liferay が `Invalid asset category` エラーをログに出力します。それ以外の影響はありません。 | いいえ（推奨） |

Liferay Forums 1.0.0 は 2026.Q1.1 と 2026.Q1.4 でテストされています。

#### hotfix を使用しない場合 {#without-a-hotfix}

- **LPD-90465 の代わりに:** 最初のフォーラムサイトを作成した後、[å©ç¨ç¦æ­¢ãæ©è½ããªã](checking.html#bans-have-no-effect-or-moderators-dont-see-lock-topic) の説明に従って、**Forum Banned** ロールに外部参照コードを手動で設定します。
- **LPD-85594 の代わりに:** 既存のサイトに site initializer の zip をデプロイするたびに、*Site Settings* でサイトのフレンドリー URL を確認し、変わっていたら元に戻します。

## インストールするもの {#what-youll-install}

各[リリース](https://github.com/Liferay-Community-APAC/liferay-forums/releases)には、次のファイルが含まれています。

| ファイル | 内容 |
| --- | --- |
| `liferay-forums-batch.zip` | フォーラムのデータ（トピック、返信、投票、報告、フォロー）と、通知テンプレートおよび検索設定です。 |
| `liferay-forums-etc-spring-boot.zip` | フォーラムの**マイクロサービス**です。Liferay の横で動作する小さなプログラムで、すべての投稿について利用禁止とロックされたトピックを確認し、通知を送信します。Liferay にはこの zip が必要で、マイクロサービス自体は独立したプロセスまたはコンテナーとして実行されます。 |
| `liferay-forums-site-initializer.zip` | フォーラムサイト本体（ページ、ロール、権限）です。これをデプロイすると、フォーラムサイトが 1 つ作成されます。 |
| `generate-site-initializer-zips.sh` | Liferay Self-Hosted で、複数のフォーラムサイトを運用するために、site initializer の zip をサイトごとに 1 つずつ作成します。 |
| [`liferay-forums-<version>-source.zip`](https://github.com/Liferay-Community-APAC/liferay-forums/releases/latest){: data-release-asset="-source.zip"} | 3 つの zip のソースで、Liferay Workspace の形式です。Liferay PaaS の場合、追加のフォーラムサイトごとに site initializer をビルドする場合、またはご自身の Liferay Workspace にフォーラムを追加する場合に必要です。 |
| `SHA256SUMS` | 上記ファイルのチェックサムです。 |

## Liferay の実行環境を選ぶ {#choose-where-liferay-runs}

<div class="doc-cards">
  <a class="card doc" href="tomcat.html"><strong>Liferay Self-Hosted (Tomcat)</strong><span>Tomcat バンドルからインストールした Liferay。マイクロサービスは同じマシンまたは別のマシンで実行します。</span></a>
  <a class="card doc" href="docker.html"><strong>Liferay Self-Hosted (Docker)</strong><span>コンテナーで動作する Liferay と PostgreSQL。マイクロサービスは Liferay のコンテナーの横のコンテナーで実行します。</span></a>
  <a class="card doc" href="paas.html"><strong>Liferay PaaS の場合</strong><span>フォーラムのプロジェクトを PaaS プロジェクトのリポジトリに追加し、プロジェクトの他の部分と一緒にデプロイします。</span></a>
  <a class="card doc" href="saas.html"><strong>Liferay SaaS の場合</strong><span>フォーラムの zip を Liferay Cloud のコマンドラインツールで 1 つずつデプロイします。</span></a>
</div>

Liferay Self-Hosted では、その後に[フォーラムサイトの作成](creating-sites.html)、続いて[インストールの確認](checking.html)を行います。Liferay PaaS と Liferay SaaS では、フォーラムサイトはインストール中に作成されます。すべてのインストール方法で、さらにフォーラムサイトを追加する方法については[フォーラムサイトの作成](creating-sites.html#several-sites)を参照してください。

ご自身の Liferay のコードを Liferay Workspace でビルドしている場合は、[Liferay Workspace を使った開発](workspace.html)を参照して、フォーラムのプロジェクトを追加してください。

## 順序が重要な理由 {#why-the-order-matters}

フォーラムは決まった順序でインストールします。batch、マイクロサービス、サイトの順です。各手順には、その前の手順が必要です。

- **batch が最初です。** マイクロサービスの zip がデプロイされると、Liferay はマイクロサービスにフォーラムのデータへのアクセス権を与えますが、その時点で存在する部分に対してだけです。batch の完了前にデプロイされると、マイクロサービスはアクセス権を得られず、すべての投稿が拒否されます。
- **サイトは最後に、Liferay が完全に起動してから作成します。** Liferay の起動中に作成されたフォーラムサイトには、トピックのページがありません。これは、Liferay の停止中に site initializer の zip をコピーした場合に起こります。そのため、site initializer は必ず実行中の Liferay にデプロイしてください。

## 関連情報 {#related-information}

- [はじめに](../getting-started.html)
- [フォーラムサイトの削除](deleting.html)
