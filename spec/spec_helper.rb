require 'rubygems'
require 'bundler/setup'
require 'lib/bounscale'

require 'time'

RSpec.configure do |config|
  config.mock_framework = :rspec
end

def capture(stream)
  begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
  ensure
      eval "$#{stream} = #{stream.upcase}"
  end
  result
end
