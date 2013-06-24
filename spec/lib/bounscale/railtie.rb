module Bounscale
  class Railtie < ::Rails::Railtie
    initializer "bounscale.add_middleware" do |app|
      app.middleware.use Bounscale::Middleware
    end
  end
end
