require 'spec_helper'

describe "メモリ使用量を取得できていることを確認する" do
  it "collector名がmemoryであること" do
    mem = Bounscale::Collector::Memory.new
    mem.name.should == "memory"
  end

  it "メモリ使用量が取得できること（モック）" do
    dummy_ps = " RSZ\n2036 \n780"
    mem = Bounscale::Collector::Memory.new
    mem.stub!(:ps_value).and_return(dummy_ps)
    mem.pre
    mem.post
    mem.value.should == 2036.to_f / 1024
  end

  it "メモリ使用量が正常に取得できない場合0が返ること" do
    mem = Bounscale::Collector::Memory.new
    mem.should_receive(:ps_value) do
      raise
    end
    mem.pre
    mem.post
    mem.value.should == 0
  end

  it "モックなしでメモリ使用量が大体取得できることを確認" do 
    mem = Bounscale::Collector::Memory.new
    mem.name.should eq "memory"
    mem.pre
    mem.post
    mem.value.should > 0
  end
end