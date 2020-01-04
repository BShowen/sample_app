require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "form errors result in no database creations" do 
    get signup_path
    assert_no_difference 'User.count' do 
      post signup_path, params: { user: {name: 'Example User', 
                                                        email: 'invalid.email', 
                                                        password: 'valid_password', 
                                                        password_confirmation: 'valid_password'} }
    end
    assert_template 'users/new'
    # assert_select "div.field_with_errors", 2
    # assert_select "div#error_explanation ul", 1
  end

  test "valid form data creates a user in the databse" do 
    get signup_path
    assert_difference "User.count", 1 do
      post signup_path, params: { user: { name: "Bradley Showen",
                                                                  email: "BShowen@me.com", 
                                                                  password: "valid_password",
                                                                  password_confirmation: "valid_password"} }
    end
    follow_redirect!
    assert_template 'users/show'
    # assert_equal flash[:success], "Welcome to the sample app!"
    assert flash[:success]
  end
  
  test "testing form" do 
    get signup_path
    assert_select 'form[action="/signup"]'
  end
end
