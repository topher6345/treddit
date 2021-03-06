ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'simplecov'

SimpleCov.start :rails

TEST_PASSWORD = 'asdfjkl;'
PASSWORD_DIGEST = User.new.send(:password_digest, TEST_PASSWORD)
CONFIRMED_AT = DateTime.now

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
