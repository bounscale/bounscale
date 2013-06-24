require 'json'

module Bounscale
  module Writer
    class Base
      FORMAT_VERSION = 0
      BOUNSCALE_OPEN_UUID  = "b74e646e-7e55-448f-814d-e36eedc44ea9"
      BOUNSCALE_CLOSE_UUID = "4a061908-db52-4224-ad4b-9850a47c7edf"

      class << self
        def strip_uuid(str)
          str.gsub(BOUNSCALE_OPEN_UUID, "").gsub(BOUNSCALE_CLOSE_UUID, "")
        end
      end
      
      def write(collector_instances)
        result = {:format_ver => FORMAT_VERSION, :datetime => Time.now.to_s, :data => []}
        result[:framework_ver] = defined?(Rails) ? "Rails " + Rails::VERSION::STRING : "Not Support"
        collector_instances.each do |collector|
          result[:data] << {:name => collector.name, :value => collector.value}
        end
        str = "#{BOUNSCALE_OPEN_UUID}#{result.to_json}#{BOUNSCALE_CLOSE_UUID}"
        self.output(str)
        str
      end
      
      def output(str)
      end
    end
  end
end
