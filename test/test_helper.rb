require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  ENV["RAILS_ENV"] = "test"
  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'

  require 'database_cleaner'
  DatabaseCleaner.strategy = :truncation

end

Spork.each_run do
  # This code will be run each time you run your specs.
  FactoryGirl.reload
  DatabaseCleaner.clean

end

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers
end

# Para el problema de: Can't mass-assign protected attributes
def unprotected_attributes(obj)
  attributes = {}
  obj._accessible_attributes[:default].each do |attribute|
    attributes[attribute] = obj.send(attribute) unless attribute.blank?
  end
  attributes
end

