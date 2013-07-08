# -*- encoding: utf-8 -*-
require "rubygems"

require "bounscale/version"

require "bounscale/collector/base"
require "bounscale/collector/cpu"
require "bounscale/collector/memory"
require "bounscale/collector/busyness"
require "bounscale/collector/throughput"

require "bounscale/writer/base"
require "bounscale/writer/heroku_writer"

require "bounscale/middlerware"

if defined?(Rails::Railtie)
 require "bounscale/railtie"
else
 config = Rails.configuration
 config.middleware.use Bounscale::Middleware
end
