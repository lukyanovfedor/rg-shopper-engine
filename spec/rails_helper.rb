ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'

# Add this to load your dummy app's environment file. This file will require
# the application.rb file in the dummy directory, and initialise the dummy app.
# Very simple, now you have your dummy application in memory for your specs.
require File.expand_path('../dummy/config/environment', __FILE__)

require 'rspec/rails'
require 'factory_girl_rails'
require 'capybara/rspec'
require 'database_cleaner'
require 'faker'
require 'shoulda-matchers'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Capybara::RSpecMatchers

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before :each, type: :view do
    view.class.include Shopper::Engine.routes.url_helpers

    config.mock_with :rspec do |mocks|
      mocks.verify_partial_doubles = false
    end
  end

  config.infer_spec_type_from_file_location!
end
