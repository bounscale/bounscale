require 'spec_helper'

describe "CPU時間を取得できていることを確認する" do
  it "CPU時間が取得できることを確認" do 
    cpu = Bounscale::Collector::Cpu.new
    cpu.name.should eq "cpu"
    cpu.pre
    1000000.times{}
    cpu.post
    cpu.value.should > 0
  end

  it "collector名がcpuであること" do
    cpu = Bounscale::Collector::Cpu.new
    cpu.name.should == "cpu"
  end

  it "user/system timeを足したCPU時間がミリ秒で返却されること" do
    cpu = Bounscale::Collector::Cpu.new

    times = double(:utime => 0.001, :stime => 0.002)
    Process.stub!(:times).and_return(times)

    cpu.pre

    times = double(:utime => 0.005, :stime => 0.008)
    Process.stub!(:times).and_return(times)

    cpu.post
    cpu.value.should == 10
  end
end