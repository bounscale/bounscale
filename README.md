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

## オートスケール設定

_Auto Scale_ではオートスケールのオンオフを設定することができます。初期値では、オートスケールが無効(disable)となっています。そのため今回は、有効(enable)へ変更します。

 ![sample04](https://s3.amazonaws.com/bounscale/sample04.png)

_Dyno limit_ではオートスケールにより変更されるDyno数の範囲を設定することができます。初期値は1から2までの範囲です。今回は、1から5までの範囲へ変更します。また、current dynoは現在のDyno数を表しており、現在は1dynoになっています。

 ![sample05](https://s3.amazonaws.com/bounscale/sample05.png)

_Response Time_は、オートスケールする上でメインの指標値となっています。_Response Time_をクリックすると、レスポンスタイムを監視しているURLの設定を行うことができます。初期値がInitConfigのWebURLで設定した値となっています。
今回はそのままのURLです。変更する場合はテキストボックスにURLを入力します。

 ![sample06](https://s3.amazonaws.com/bounscale/sample06.png)

_セレクトボックス_では、メイン指標値であるレスポンスタイムとは別に、サブ指標値を設定することができます。サブ指標値には以下のものがあります。

 * Busyness

 リクエストとレスポンスの間隔をある一定時間計測し、その利用比率を0%から100%で表す指標値です。

 * CPU

 CPUの使用時間を表す指標値です。

 * Memory

 メモリの使用率を表す指標値です。

 * Throughput

 単位時間あたりに返すレスポンス数を表す指標値です。

初期値では、Busynessとなっています。今回はCPUを選択します。

![sample07](https://s3.amazonaws.com/bounscale/sample07.png)

先ほどCPUを選択したので、グラフのサブ指標値がCPUへ変更されています。

![sample08](https://s3.amazonaws.com/bounscale/sample08.png)

_Interval_では、データを取得するスパンを設定することができます。初期値は5分となっています。今回は10分へ設定します。

![sample09](https://s3.amazonaws.com/bounscale/sample09.png)

_ScaleIn_では、スケールインするResponseTimeを設定することができます。初期値は1000ミリ秒となっています。今回は2000ミリ秒へ設定します。

![sample10](https://s3.amazonaws.com/bounscale/sample10.png)

_グラフ_では、スケールアウトする閾値を選択することができます。メイン指標値であるレスポンスタイム閾値は左のつまみで設定することができます。レスポンスタイムの初期値は10000ミリ秒です。今回は5000ミリ秒へ設定します。
また、サブ指標値であるCPU閾値は右のつまみで設定することができます。CPUの初期値は10000ミリ秒です。今回は15000ミリ秒へ設定します。設定した閾値を超えるとスケールアウトしてアプリケーションへの負荷を低減させます。

![sample11](https://s3.amazonaws.com/bounscale/sample11.png)

設定完了後にSaveボタンを押します。

![sample12](https://s3.amazonaws.com/bounscale/sample12.png)

以上を設定することによりアプリケーションに最適なオートスケール環境を提供することができます。

## サポート

 もし、バグなどを発見された場合、issuesまでご連絡をお願い致します。
 
 それではあなたのアプリケーションがストレスから開放されることを。

 DTS Corporation.
