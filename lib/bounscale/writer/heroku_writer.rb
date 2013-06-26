# -*- encoding: utf-8 -*-
class Bounscale::Writer::HerokuWriter < Bounscale::Writer::Base
  def output(str)
    puts str
  end
end