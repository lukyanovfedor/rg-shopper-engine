module Shopper
  class Engine < ::Rails::Engine
    isolate_namespace Shopper

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    initializer 'shopper' do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.include Shopper::ModelMethods
      end

      ActiveSupport.on_load :action_controller do
        ActionController::Base.include Shopper::ControllerMethods
        ActionController::Base.helper Shopper::ApplicationHelper
      end
    end
  end
end
