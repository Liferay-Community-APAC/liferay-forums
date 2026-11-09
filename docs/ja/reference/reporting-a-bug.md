---
title: バグの報告
parent: リファレンス
nav_order: 5
---

# バグの報告 {#reporting-a-bug}
{: .no_toc }

Liferay Forums の問題の報告や改善の提案は、[GitHub の liferay-forums リポジトリ](https://github.com/Liferay-Community-APAC/liferay-forums/issues)の issue として行います。GitHub アカウントが必要です。

1. TOC
{:toc}

## TAM パッケージをお持ちの場合 {#if-you-have-a-tam-package}

ご利用の Liferay サブスクリプションに Technical Account Manager（TAM）パッケージが含まれている場合は、GitHub の issue を作成する代わりに、問題を Liferay サポートに直接登録してください。チケットであればログや環境の詳細は非公開のまま保たれ、TAM がフォローアップできます。

1. liferay.com アカウントで [Liferay Help Center](https://support.liferay.com/) にサインインします。
1. [Help Center Ticket Creation Process](https://learn.liferay.com/kb-article/help-center-ticket-creation-process) の説明に従って、チケットを作成します。
1. チケットには、問題が **Liferay Forums** で発生していることをそのバージョンとともに記載し、[バグレポート](#report-a-bug)と同じ詳細（Liferay DXP のバージョン、インストール方法、再現手順、ログの該当行）を含めます。
1. チケットについて TAM に知らせます。

## 報告する前に {#before-you-report}

- ご利用のリリースについて、[既知の問題](known-issues.html)を確認してください。
- 投稿が拒否される、トピックのリンクで Not Found ページが表示される、メールが届かないといった場合は、[問題がある場合](../installing/checking.html#if-somethings-wrong)の手順に従ってください。
- [オープンな issue](https://github.com/Liferay-Community-APAC/liferay-forums/issues) で同じ問題を検索してください。見つかった場合は、別の issue を作成する代わりに、わかっている情報をその issue に追加するか、👍 を付けてください。

## バグを報告する {#report-a-bug}

1. [New issue](https://github.com/Liferay-Community-APAC/liferay-forums/issues/new/choose) を開き、**Bug report** を選択します。
1. フォームに次の内容を記入します。
    - Liferay Forums のバージョンと Liferay DXP のバージョン
    - インストール方法：Liferay Self-Hosted（Tomcat または Docker）、Liferay PaaS、Liferay SaaS、または Liferay Workspace
    - [必要な Liferay の修正](../installing/#required-liferay-fixes)がインストールされているかどうか
    - 何が起きたか、何を期待していたか、および再現手順（各手順を実行するメンバーのロールを含む）
    - Liferay のログとマイクロサービスのログに記録されたエラー
1. **Create** をクリックします。

{: .warning }
issue は公開されます。ログやスクリーンショットを貼り付ける前に、メールアドレス、ユーザー名、ホスト名、内部アドレス、トークン、および顧客データをすべて削除してください。

改善を提案するには、代わりに **Feature request** を選択し、実現したいことを説明してください。

## セキュリティ上の問題 {#security-problems}

セキュリティ上の問題は、公開の issue で報告しないでください。リポジトリの **Security** タブ → [**Report a vulnerability**](https://github.com/Liferay-Community-APAC/liferay-forums/security/advisories/new) から非公開で報告してください。報告はメンテナーだけが閲覧できます。リポジトリの[セキュリティポリシー](https://github.com/Liferay-Community-APAC/liferay-forums/security/policy)を参照してください。

## 質問 {#questions}

フォーラムのインストール、設定、使い方に関する質問は、issue ではなく [discussion](https://github.com/Liferay-Community-APAC/liferay-forums/discussions) を開始してください。

## 報告後の流れ {#what-happens-next}

メンテナーは新しい issue を確認し、必要に応じて詳細を尋ねます。確認されたバグはリリースに向けて計画されます。通常は最新リリースラインの次のパッチで、どのリリースかは issue に記載されます。そのリリースが公開されると、リリースへのリンクを添えて issue がクローズされます。インストール方法は、そのリリースのリリースノートに記載されています。

Liferay Forums はコミュニティプロジェクトのため、issue への対応はベストエフォートで行われます。

## 関連情報 {#related-information}

- [既知の問題](known-issues.html)
- [インストールの確認](../installing/checking.html)
