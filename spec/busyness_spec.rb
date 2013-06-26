# -*- encoding: utf-8 -*-
require 'spec_helper'

describe "ビジー率を取得できていることを確認する" do
  before do
    Bounscale::Collector::Busyness.clear_history!
  end

  it "collection名がbusynessであること" do
    busy = Bounscale::Collector::Busyness.new
    busy.name.should == "busyness"
  end

  it "ビジー率は%であること" do
    base_time = Time.parse("2013/1/1 00:00:00")
    busy = Bounscale::Collector::Busyness.new
    Thread.current[:bounscale_busyness_history] = [
      [base_time, base_time + 3],
      [base_time + 8, base_time + 9]
    ]
    #%なので100をかける
    busy.value.should == (4.0/9.0) * 100
  end

  it "2つ以上の履歴がない場合は0を返す事" do
    base_time = Time.parse("2013/1/1 00:00:00")
    busy = Bounscale::Collector::Busyness.new

    Thread.current[:bounscale_busyness_history] = []
    busy.value.should == 0

    Thread.current[:bounscale_busyness_history] = [
      [base_time, base_time + 3]
    ]
    busy.value.should == 0

    Thread.current[:bounscale_busyness_history] = [
      [base_time, base_time + 3],
      [base_time + 8, base_time + 9]
    ]
    busy.value.should_not == 0

  end

  it "ビジー率が取得できることを確認（モック）" do
    #1秒→(2秒)→3秒→(4秒)→5秒の場合
    fake_now = Time.parse("2013/1/1 00:00:00")

    busy = Bounscale::Collector::Busyness.new
    #[]サンプルが1つもないと0を返す
    busy.value.should == 0

    Time.stub!(:now).and_return(fake_now)
    busy.pre
    Time.stub!(:now).and_return(fake_now + 1)
    busy.post

    #[1]サンプルが一つしかないと0を返す
    busy.value.should == 0

    busy = Bounscale::Collector::Busyness.new
    Time.stub!(:now).and_return(fake_now + 1 + 2)
    busy.pre
    Time.stub!(:now).and_return(fake_now + 1 + 2 + 3)
    busy.post

    #[1, (2), 3]なので4/6がビジー率
    busy.value.should == (4.0 / 6.0) * 100

    busy = Bounscale::Collector::Busyness.new
    Time.stub!(:now).and_return(fake_now + 1 + 2 + 3 + 4)
    busy.pre
    Time.stub!(:now).and_return(fake_now + 1 + 2 + 3 + 4 + 5)
    busy.post

    #[1, (2), 3, (4), 5]だが、処理終端が10秒前以前は消えるので
    #[3, (4), 5]で、8/12がビジー率
    busy.value.should == (8.0 / 12.0) * 100
  end
  
  it "ビジー率がモックなしで大体取得できることを確認" do 
    busy = nil
    10.times do
      busy = Bounscale::Collector::Busyness.new
      busy.name.should eq "busyness"
      busy.pre
      sleep(0.01)
      busy.post
      sleep(0.04)
    end
    busy.value.should > 20
    busy.value.should < 40
  end

end