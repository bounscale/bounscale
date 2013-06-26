# -*- encoding: utf-8 -*-
require 'spec_helper'

describe "文字列化が正常にできることの確認" do
  before :each do
    fake_now = Time.parse("2013/01/01 00:00:00")
    Time.stub!(:now).and_return(fake_now)
  end

  it "ひきわたされたcollectorの情報が全て書き込み文字列に含まれていること" do
    collectors = [
      double(:name => "collector1", :value => 10),
      double(:name => "collector2", :value => 20)
    ]
    writer = Bounscale::Writer::Base.new
    str = writer.write(collectors)

    str.include?("b74e646e-7e55-448f-814d-e36eedc44ea9").should be_true
    str.include?("\"datetime\":\"Tue Jan 01 00:00:00 +0000 2013\"").should be_true
    str.include?("\"framework_ver\":\"Not Support\"").should be_true
    str.include?("\"data\":[{\"value\":10,\"name\":\"collector1\"},{\"value\":20,\"name\":\"collector2\"}]").should be_true
    str.include?("\"format_ver\":0").should be_true
    str.include?("4a061908-db52-4224-ad4b-9850a47c7edf").should be_true
  end

  it "フレームワークバージョンが書きこまれていること" do
    class Rails
      class VERSION
        STRING = "9.9.9"
      end
    end

    writer = Bounscale::Writer::Base.new
    str = writer.write([])
    str.include?("\"framework_ver\":\"Not Support\"").should be_false
    str.include?("\"framework_ver\":\"Rails 9.9.9\"").should be_true
  end

  it "想定しないフレームワークではフレームワークバージョンが書きこまれないこと" do
    Object.class_eval do
      remove_const :Rails
    end

    writer = Bounscale::Writer::Base.new
    str = writer.write([])

    str.include?("\"framework_ver\":\"Not Support\"").should be_true
  end

  it "フォーマットバージョンが書きこまれていること" do
    writer = Bounscale::Writer::Base.new
    str = writer.write([])

    str.include?("\"format_ver\":0").should be_true
  end

  it "識別用UUIDに囲まれた領域をくくりだせること" do
    before_str = "b74e646e-7e55-448f-814d-e36eedc44ea9DUMMYSTRING4a061908-db52-4224-ad4b-9850a47c7edf"
    after_str = Bounscale::Writer::Base.strip_uuid(before_str)
    after_str.should == "DUMMYSTRING"
  end

  it "取得したデータがJSON形式でパースできること" do 
    writer = Bounscale::Writer::HerokuWriter.new
    str = writer.write([])
    str = Bounscale::Writer::Base.strip_uuid(str)
    result = JSON.parse(str)
    result["format_ver"].should eq 0
    (Time.now.to_i - Time.parse(result["datetime"]).to_i).should < 10
  end
end