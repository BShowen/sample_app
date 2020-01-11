ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper #I added this so now in my integration test I can use the application helpers that ive defined in app/helpers/application_helper.rb
  
  # Add more helper methods to be used by all tests here...
  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest # We defined this class here so we could add methods to it that would only be called from IntegrationTest. Look at "log_in_as", youll see its defined here in this class and also in the class above (ActiveSupport::TestCase). When we run IntegrationTests, this log_in_as (the one defiend inside ActionDispatch) gets called. 
  
  # Login as a particular user
  def log_in_as(user, password: 'password', remember_me: nil)
    post login_path, params:{session:{email: user.email, 
                                                              password: password,
                                                              remember_me: "#{remember_me}"}}
  end 
end