# -*- encoding: utf-8 -*-
require 'spec_helper'

describe "スループットを取得できていることを確認する" do
  before :each do
    Bounscale::Collector::Busyness.clear_history!
  end

  it "collector名がthroughputであること" do
    th = Bounscale::Collector::Throughput.new
    th.name.should == "throughput"
  end

  it "Busynessで収集された履歴を用いてリクエスト数/全体の時間の分辺りの値で算出すること" do
    base_time = Time.parse("2013/1/1 00:00:00")
    throughput = Bounscale::Collector::Throughput.new
    Thread.current[:bounscale_busyness_history] = [
      [base_time, base_time + 3],
      [base_time + 8, base_time + 9]
    ]

    #2リクエストが9秒の間にきている負荷の分辺りの負荷がスループット
    throughput.value.should == ((2 / 9.0) * 60.0)
  end

  it "履歴が2つ以下の場合スループットは0を返す事" do
    base_time = Time.parse("2013/1/1 00:00:00")
    throughput = Bounscale::Collector::Throughput.new
    Thread.current[:bounscale_busyness_history] = []
    throughput.value.should == 0

    Thread.current[:bounscale_busyness_history] = [
      [base_time, base_time + 3]
    ]
    throughput.value.should == 0

    Thread.current[:bounscale_busyness_history] = [
      [base_time, base_time + 3],
      [base_time + 8, base_time + 9]
    ]
    throughput.value.should_not == 0
  end

  it "スループットが取得できる事を確認（モック）" do
    #1秒→(2秒)→3秒→(4秒)→5秒の場合
    fake_now = Time.parse("2013/1/1 00:00:00")

    busy = Bounscale::Collector::Busyness.new
    th = Bounscale::Collector::Throughput.new

    Time.stub!(:now).and_return(fake_now)
    busy.pre
    th.pre
    Time.stub!(:now).and_return(fake_now + 1)
    busy.post
    th.post

    #[1]サンプルが一つしかないと0を返す
    th.value.should == 0

    busy = Bounscale::Collector::Busyness.new
    th = Bounscale::Collector::Throughput.new

    Time.stub!(:now).and_return(fake_now + 1 + 2)
    busy.pre
    th.pre
    Time.stub!(:now).and_return(fake_now + 1 + 2 + 3)
    busy.post
    th.post

    #[1, (2), 3]なので2/6がスループット
    th.value.should == (2 / 6.0) * 60

    busy = Bounscale::Collector::Busyness.new
    th = Bounscale::Collector::Throughput.new
    Time.stub!(:now).and_return(fake_now + 1 + 2 + 3 + 4)
    busy.pre
    th.pre
    Time.stub!(:now).and_return(fake_now + 1 + 2 + 3 + 4 + 5)
    busy.post
    th.post

    #[1, (2), 3, (4), 5]だが、処理終端が10秒前以前は消えるので
    #[3, (4), 5]で、3/12がスループット
    th.value.should == (2 / 12.0) * 60
  end
  
  it "スループットがモックなしで代替の値で取得できることを確認" do 
    throughput = nil
    10.times do
      busyness = Bounscale::Collector::Busyness.new
      throughput = Bounscale::Collector::Throughput.new
      throughput.name.should eq "throughput"
      busyness.pre
      busyness.post
      sleep(0.1)
    end
    throughput.value.should > 500
    throughput.value.should < 700
  end
end