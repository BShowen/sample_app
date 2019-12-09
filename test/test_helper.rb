ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper #I added this so now in my integration test I can use the application helpers that ive defined in app/helpers/application_helper.rb

  # Add more helper methods to be used by all tests here...
end
