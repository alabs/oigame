require 'rubygems'

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

