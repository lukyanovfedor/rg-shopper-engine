module Shopper
  REQUIRED = %w(active_record)
  PRODUCT_CLASSES = []

  mattr_accessor :parent_controller
  @@parent_controller = 'ApplicationController'

  mattr_accessor :customer_class
  @@customer_class = 'User'

  mattr_accessor :set_order_on_each_request
  @@set_order_on_each_request = false

  def self.setup
    yield self
  end

  def self.active_record_missing
    puts <<-WARN
      Warning: no ActiveRecord detected

      ActiveRecord is required for this engine.

      Your Gemfile might not be configured properly.
      ---- try ----
      gem 'active_record''
    WARN
  end

  REQUIRED.each do |r|
    begin
      require r
    rescue LoadError => ex
      self.send "#{r}_missing".to_sym
      raise ex
    end
  end
end

require 'aasm'
require 'wicked'
require 'shopper/model_methods'
require 'shopper/controller_methods'
require 'shopper/engine'
