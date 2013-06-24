require 'spec_helper'

class Bounscale::MockApp
  attr_accessor :called
  
  def initialize
    self.called = false
  end
  
  def call(env)
    self.called = true
  end
end

describe "情報を収集し、書きこめていることを確認する" do
  before do
    Bounscale::Collector::Busyness.clear_history!
  end

  it "情報を収集できていること" do
    $stdout = StringIO.new

    mock_app = Bounscale::MockApp.new
    middleware = Bounscale::Middleware.new(mock_app)
    result = middleware.call(ENV)    

    out = $stdout.string
    $stdout = STDOUT
    
    out = Bounscale::Writer::Base.strip_uuid(out)
    result_json = JSON.parse(out)
    result_json["format_ver"].should eq 0
    result_json["data"][0]["name"].should eq "cpu"
    result_json["data"][0]["value"].should eq 0
    result_json["data"][1]["name"].should eq "memory"
    result_json["data"][1]["value"].should > 0
    result_json["data"][2]["name"].should eq "busyness"
    result_json["data"][2]["value"].should eq 0
    result_json["data"][3]["name"].should eq "throughput"
    result_json["data"][3]["value"].should eq 0
  end
end