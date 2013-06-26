# Bounscale
Bounscaleは、HerokuへデプロイされたRailsアプリケーションをオートスケールする環境を提供するアドオンです。

Bounscaleを追加することによって次のような利点を得ることができます。

1. レスポンスの低下を抑えます。

2. アプリケーションへの負荷に合わせて最適なDyno数の調整を行うことによりコストをより抑えることができます。

Bounscaleはgemのbounscaleにより、RackMiddlewareからアプリケーションの状態を取得してオートスケールを実現しています。

## サポート環境
__Application__

 * Rails2.0以降(RackMiddlewareが入っているもの)

__Heroku Stack__

 * Ceder Stack

## はじめに

 プロジェクトのGemfileに以下を追加します。

```Gemfile
gem 'bounscale'
```

## アドオンのインストール

 アドオンを追加するために以下のコマンドを入力します。

```
 $ heroku addons:add bounscale
```

## Bounscale初期設定

 Herokuのアプリ画面へ移動し、AddonsにBounscaleが追加されていることを確認します。

 確認を行った後に、Bounscaleアドオンをクリックします。

 ![sample01](https://s3.amazonaws.com/bounscale/sample01.png)

 Bounscaleボタンをクリック後、以下のような画面が表示されます。
 次に、3つの入力を行なってください。

 1. API Key

 HerokuアカウントのAPIキーを入力してください。

 APIキーの取得については、heroku dashbord画面でアカウント設定を選択します。
 APIKeyの欄でShow API Keyボタンを押します。
 Herokuアカウントのパスワードを求められるので、パスワードを入力するとAPIキーを取得することができます。

 2. Web URL

 アプリの監視するURLを入力してください。

 3. Time Zone

 現在地のタイムゾーンを選択してください。

入力後、Saveボタンを押してください。

 ![sample02](https://s3.amazonaws.com/bounscale/sample02.png)

BounscaleのTop画面が表示されれば完了となります。

 ![sample03](https://s3.amazonaws.com/bounscale/sample03.png)

## サポート

 もし、バグなどを発見された場合、issuesまでご連絡をお願い致します。
 
 それではあなたのアプリケーションがストレスから開放されることを。

 DTS Corporation.
