require 'spec_helper'

describe "文字列化が正常にできることの確認" do
  before :each do
    fake_now = Time.parse("2013/01/01 00:00:00")
    Time.stub!(:now).and_return(fake_now)
  end

  it "データが標準出力に書き込まれていること" do
    collectors = [
      double(:name => "collector1", :value => 10),
      double(:name => "collector2", :value => 20)
    ]

    str = capture(:stdout) {
      writer = Bounscale::Writer::HerokuWriter.new
      str = writer.write(collectors)
    }

    str.include?("b74e646e-7e55-448f-814d-e36eedc44ea9").should be_true
    str.include?("\"datetime\":\"Tue Jan 01 00:00:00 +0000 2013\"").should be_true
    str.include?("\"framework_ver\":\"Not Support\"").should be_true
    str.include?("\"data\":[{\"value\":10,\"name\":\"collector1\"},{\"value\":20,\"name\":\"collector2\"}]").should be_true
    str.include?("\"format_ver\":0").should be_true
    str.include?("4a061908-db52-4224-ad4b-9850a47c7edf").should be_true
  end
end