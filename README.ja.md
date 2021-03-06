# Bounscale
Bounscaleは、HerokuへデプロイされたRails/node.jsアプリケーションをオートスケールする環境を提供するアドオンです。

https://addons.heroku.com/bounscale

Bounscaleを追加することによって次のような利点を得ることができます。

1. レスポンスの低下を抑えます。

2. アプリケーションへの負荷に合わせて最適なDyno数の調整を行うことによりコストを抑えることができます。

Bounscaleはgemのbounscaleにより、RackMiddlewareからアプリケーションの状態を取得してオートスケールを実現しています。

## サポート環境
__Application__

 * 動作確認済
   * Rails 2.3 or 3.0 or 3.2
   * Ruby 1.9.2 or 1.9.3
 * 仕組み上はRackに対応していれば利用可能です
 * [EXPERIMENTAL] node.js v0.10.15 / Express 3.3.5

__Heroku Stack__

 * Ceder Stack

## はじめに
### Ruby/Rails

 プロジェクトのGemfileに以下を追加します。

```Gemfile
config.after_initialize do
  require 'bounscale'
end
```

 Rails2の場合はconfig/environment.rbに以下を追加します。
 (Rails3の場合は不要)

```config/environment.rb
config.gem 'bounscale'
```

### [EXPERIMENTAL] node.js / Express
 プロジェクトのpackage.jsonに以下を追加します。
 
```package.json
{
...
  "dependencies": {
...
    "bounscale": "*"
  },
...
}
```

 プロジェクトのapp.jsに以下を追加します。
 「app.use」の一番頭の部分に追加してください。

```app.js
...
app.set(.....);
app.set(.....);
app.use(require('bounscale')); // <-- insert here
app.use(.....);
app.use(.....);
...
```

## アドオンのインストール

 アドオンを追加するために以下のコマンドを入力します。

```
 $ heroku addons:add bounscale
```

## Bounscale初期設定

 Herokuのアプリケーション画面へ移動し、AddonsにBounscaleが追加されていることを確認します。

 確認を行った後に、Bounscaleアドオンをクリックします。

 ![sample01](https://s3.amazonaws.com/bounscale/sample01.png)

 Bounscaleボタンをクリック後、以下のような画面が表示されます。
 次に、3つの入力を行なってください。

 1. API Key

 HerokuアカウントのAPIキーを入力してください。

 APIキーの取得については、heroku dashboard画面で
 `Account > API Key > Show API Keyボタン`
 を押すことで入手できます。

 2. Web URL

 アプリケーションの監視するURLを入力してください。

 3. Time Zone

 現在地のタイムゾーンを選択してください。

入力後、Saveボタンを押してください。

 ![sample02](https://s3.amazonaws.com/bounscale/sample02.png)

BounscaleのTop画面が表示されれば完了となります。

設定完了後の初期状態はデータがないため、グラフが表示されません。
5～10分程度待つとアプリケーションのデータを取得してグラフが表示され始めます。

 ![sample03](https://s3.amazonaws.com/bounscale/sample03.png)

## オートスケール設定

 オートスケール設定画面は、オートスケールに関する各種設定値を指定することで、適切にオートスケールが行われるように制御する画面です。

 ![sample04](https://s3.amazonaws.com/bounscale/sample04.png)

### (a)Auto Scale
  _Auto Scale_ではオートスケールのオンオフを設定することができます。有効(enable)の場合、グラフのデータを取得し、高負荷の条件を満たすとオートスケールが実施されます。無効(disable)の場合、グラフのデータを取得しますが、オートスケールは一切実施されません。

  使い始めはひとまず無効を指定し、収集されたグラフに基づき、適切な閾値を指定できた後で、有効に設定する事をお勧めします。

### (b)Dyno Limit
 _Dyno limit_ではオートスケールにより変更されるDyno数の範囲を設定することができます。Dynoの最小値は、どれだけ負荷が小さくても、指定値よりもDynoが少なくなることはありません。Dynoの最大値は、どれだけ負荷が大きくても、指定値よりもDynoが大きくなる事はありません。

 最小値は最低限の性能を確保するための数値を指定してください。また、最大値はコストに合わせて数値を指定してください。また、current dynoは今現在のDyno数を表しています。

### (c)Response Time
 Bounscaleのスケールアウトは2つの指標値が両方高負荷状態になった場合に実行されます。

 指標値"ResponseTime"はBounscaleから該当のURLに実際にHTTPリクエストを発行したレスポンスタイムです。この指標値はアプリケーションの負荷を測定するために最重要な項目であるため、必ず利用する指標値となります。*Response Time*をクリックすると、レスポンスタイムを監視しているURLの設定を行うことができます。

 アプリケーションの中で平均的なレスポンスタイムを返却するURLを指定する事をお勧めします。

### (d)オプショナル指標値
 セレクトボックスで2つ目のオプショナル指標値を選択します。オプショナル指標値には以下のものがあります。

 * Busyness[%]

 一定時間あたりのDynoが処理するリクエスト処理時間、待ち時間を計測し、その比率を0%から100%で表す指標値です。

 例えば、10秒間に6秒間リクエスト処理を行い、4秒間リクエスト待ちのとき、出力は60[%]となります。

 * CPU[ms]

 CPUの使用時間を表す指標値です。

 * Memory[MB]

 メモリの使用量を表す指標値です。

 * Throughput[response/min]

 1分間あたりに返すレスポンス数を表す指標値です。

### (e)(f)グラフ
 _グラフ_では、スケールアウトする閾値を選択することができます。固定の指標値であるResponseTimeの閾値は左のつまみで設定することができます。
また、オプショナルの指標値であるCPUの閾値は右のつまみで設定することができます。2つの指標値の設定した閾値の両方が超えるとスケールアウトしてアプリケーションへの負荷を低減させます。

### (g)Interval
 _Interval_では、データを取得するスパンを設定することができます。短いほど急激にDynoの数が増減します。

### (h)ScaleIn
 Bounscaleのスケールインはレスポンスタイム単体が一定の閾値を下回った場合に実行されます。_ScaleIn_で、スケールインするレスポンスタイムを設定することができます。この値はできるだけ小さく指定する事をお勧めします。アプリケーションへの負荷が十分に収まっていない状態でスケールインする事を防ぐためです。

### (i)Saveボタン
 設定完了後Saveボタンを押します。

## 運用開始後

実際の運用を始めた後は _Dyno History_ 画面を参照し、定常的に下記のガイドラインを参考にしてオートスケールの設定を最適化していってください。

 ![sample04](https://s3.amazonaws.com/bounscale/sample07.png)

* 十分なレスポンスタイムが維持されているか確認します。
* レスポンスタイムが不十分な場合、そのタイミングでDynoの数が増加しているか確認します。
  * 増加していない場合は閾値及びオプショナル指標値を適切に調整します。
* Dynoが増えているにも関わらずレスポンスタイムが改善しない場合は、Bounscaleでは対応できません。
  * アプリケーション以外（DBサーバなど）がボトルネックになっている可能性を調査します。
* 負荷が高くない状況でオートスケールが実行されている場合も、閾値及びオプショナル指標値を適切に調整してください。

## サポート

 不明点、動作不良などを発見された場合、issuesに登録をお願い致します。
 
 それではあなたのアプリケーションがストレスから開放されることを。

 DTS Corporation.
