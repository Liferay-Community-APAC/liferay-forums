---
title: 既知の問題
parent: リファレンス
nav_order: 4
---

# 既知の問題 {#known-issues}

Liferay Forums 1.0.0 の既知の制限事項です。

## 質問の作成者が回答をマークできない {#a-questions-author-cant-mark-an-answer}

質問の作成者には **Mark as Answer** が表示されますが、返信をマークしようとすると失敗します。これは、メンバーが他のメンバーの返信を変更することが許可されていないためです。モデレーターは回答をマークできます。

## batch の再デプロイ {#deploying-the-batch-again}

`liferay-forums-batch.zip` のデプロイは 1 回だけにしてください。再度デプロイするたびに、次のことが起こります。

- 管理者が Liferay の **User** オブジェクトに追加したカスタムフィールドとリレーションシップが削除されます。デプロイ後に、再度追加してください。
- メールテンプレートがすでに存在するというエラーが Liferay のログに記録されます。テンプレートへの変更は batch によって保持されます。
- batch ジョブがデプロイのたびに実行される Liferay PaaS では、同じ理由でジョブが失敗と表示されます。フォーラムのデータはその前にインポートされるため、失われるものはありません。[Liferay PaaS へのインストールの手順 5](../installing/paas.html#step-5-deploy-a-second-build) では、最初のデプロイ後にメールテンプレートのファイルを削除することで、これを防ぎます。

## トピックの更新時にエラーがログに記録される {#an-error-is-logged-when-a-topic-is-updated}

Liferay の修正 LPD-102310 がない場合、フォーラムのマイクロサービスがカテゴリーを持つトピックを更新すると、Liferay は `ERROR ... Invalid asset category with external reference code ...` をログに記録します。トピックのカテゴリーは保持され、ほかに影響はありません。

## Liferay PaaS と SaaS で site initializer のジョブを再実行するとサイトのアドレスがリセットされる {#on-liferay-paas-and-saas-a-site-initializer-job-run-again-resets-the-sites-address}

既存のサイトに対して site initializer のジョブが再実行されるたびに、サイトのフレンドリー URL が `/group-<number>` にリセットされ、フォーラムのリンクで Not Found ページが表示されます。LPD-85594 は、Liferay 自体にデプロイされた site initializer の zip についてはこれを修正しますが、Liferay Cloud が実行するジョブについては修正しません。[Liferay PaaS へのインストール](../installing/paas.html#step-5-deploy-a-second-build)のように、各 site initializer プロジェクトはそのサイトが作成された後に削除し、Liferay SaaS では site initializer を再度デプロイしないでください。アドレスがリセットされた場合は、*Site Settings* で元に戻してください。

## 返信を削除してもトピックのアクティビティ日時が変わらない {#deleting-a-reply-doesnt-change-a-topics-activity-date}

トピックの最新の返信が削除されても、そのトピックは **Recent Activity** での位置を維持します。

## 関連情報 {#related-information}

- [バグの報告](reporting-a-bug.html)
- [リリースノート](https://github.com/Liferay-Community-APAC/liferay-forums/releases)
