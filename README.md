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

 Ruby 1.9.2 or 1.9.3

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
設定完了後、初期はグラフが表示されていません。
そのため、しばらく待つとアプリケーションのデータを取得してグラフが表示されます。

 ![sample03](https://s3.amazonaws.com/bounscale/sample03.png)

## オートスケール設定

 チュートリアル形式でオートスケールの設定について説明します。

 ![sample_01](https://s3.amazonaws.com/bounscale/sample_01.png)

 (a) _Auto Scale_ではオートスケールのオンオフを設定することができます。有効(enable)の場合、オートスケールを実施し、グラフのデータを取得します。また、無効(disable)の場合、オートスケールを実施しませんが、グラフのデータを取得します。今回は、オートスケールさせたいので、有効(enable)へ変更します。

 (b) _Dyno limit_ではオートスケールにより変更されるDyno数の範囲を設定することができます。Dynoの最小値は、アクセスが低い時間帯でもレスポンスの低下が気にならないほどのDyno数を設定します。また、Dynoの最大値は、想定しているコストにあったDyno数を設定します。今回は、1dynoで処理できることができる想定かつ、5dynoまでコストが許容出来ることから、1から5までの範囲へ変更します。また、current dynoは現在のDyno数を表しており、現在は1dynoになっています。

 (c) オートスケールは2つの指標値によって実施されます。1つは固定であるResponseTimeです。2つ目はオプショナルでユーザが設定します。*Response Time*をクリックすると、レスポンスタイムを監視しているURLの設定を行うことができます。
このWebURLはアプリケーションで多くのアクセスがあるURL、またアプリケーションで重い処理を行なっているURLなどを設定します。今回はそのままのURLです。変更する場合はテキストボックスにURLを入力します。

 ![sample_02](https://s3.amazonaws.com/bounscale/sample_02.png)

 (d) _セレクトボックス_では、オプショナル指標値を選択します。オプショナル指標値には以下のものがあります。

 * Busyness[%]

 一定時間あたりのDynoが処理するリクエスト処理時間、待ち時間を計測し、その比率を0%から100%で表す指標値です。例えば、10秒間に6秒間リクエスト処理を行い、4秒間リクエスト待ちのとき、出力は60[%]となります。

 * CPU[ms]

 CPUの使用時間を表す指標値です。

 * Memory[%]

 メモリの使用率を表す指標値です。

 * Throughput[response/min]

 単位時間あたりに返すレスポンス数を表す指標値です。

今回は、Busynessを選択します。

 ![sample_03](https://s3.amazonaws.com/bounscale/sample_03.png)

 (e)(f) _グラフ_では、スケールアウトする閾値を選択することができます。固定の指標値であるResponseTimeの閾値は左のつまみで設定することができます。今回は5000ミリ秒へ設定します。
また、オプショナルの指標値であるCPUの閾値は右のつまみで設定することができます。今回は15000ミリ秒へ設定します。2つの指標値の設定した閾値をどちらかが超えるとスケールアウトしてアプリケーションへの負荷を低減させます。

 (g) _Interval_では、データを取得するスパンを設定することができます。今回は10分へ設定します。

 (h) _ScaleIn_では、スケールインするResponseTimeを設定することができます。今回は2000ミリ秒へ設定します。
 
 (i) 設定完了後Saveボタンを押します。


設定完了後以下の確認を行なってください。

 (1) オートスケール設定が完了後、実際にオートスケールするか確認をしてください。

 (2) オートスケールによって負荷が軽減されていることを確認してください。

 (3) 実際にアプリケーションを運用していき、閾値、設定値を調整してください。

 (4) オートスケール、レスポンスタイムの履歴をDynoHistoryから確認してください。

 (5) APIKey、TimeZone,オートスケール通知メールの変更はUserSettingから変更を行なってください。


## サポート

 もし、バグなどを発見された場合、issuesまでご連絡をお願い致します。
 
 それではあなたのアプリケーションがストレスから開放されることを。

 DTS Corporation.
