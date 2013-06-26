# -*- encoding: utf-8 -*-
require 'spec_helper'

describe "Collectorの枠組みを確認する" do
  it "枠組みとなるメソッドを実行できること" do
    base = Bounscale::Collector::Base.new
    base.pre.should == nil
    base.post.should == nil
  end
end