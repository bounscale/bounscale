require "bounscale/collector/base"

module Bounscale
  class Middleware
    COLLECTOR_CLASSES = [
      Bounscale::Collector::Cpu,
      Bounscale::Collector::Memory,
      Bounscale::Collector::Busyness,
      Bounscale::Collector::Throughput
    ]
    def initialize(app)
      @app = app
    end

    def call(env)
      collector_instances = COLLECTOR_CLASSES.map do |klass|
        collector = klass.new
        collector.pre
        collector
      end
      
      app_response = @app.call(env)

      collector_instances.each do |collector|
        collector.post
      end
      
      Bounscale::Writer::HerokuWriter.new.write(collector_instances)
      return app_response
    end
  end
end
