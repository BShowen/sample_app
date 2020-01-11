require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup 
    @user = users(:michael)  
  end

  test "to ensure properly working flash" do 
    get login_path
    assert_template "sessions/new"
    post login_path, params: {session: { email: " ", 
                                                                  password: " " } }  
    assert_template "sessions/new"
    assert_not flash.empty? 
    get root_path
    assert flash.empty?
  end

  test "to login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email, 
                                                                  password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    
    # Simulate user clicking log out in second window
    delete logout_path
    
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]',  logout_path,          count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end

  test "to ensure signup checkbox is wokring properly" do 
    log_in_as @user, remember_me: '1'
    assert_equal assigns(:user).remember_token, cookies[:remember_token]
    # The reason we use the 'assigns()' method is becuase we can to compare the virtual attribute (remember_token) of the user to the actual cookie value on the browser. In tests we dont have access to virtual attrs nor do we have access to the object created in any of the methods in the controller. The only way we have access to the objects created in the controllers is if the controller created the object on an instance variable, which we can then access by using the assigns() method. It works like this - assigns(:object) - and then you can call attributes like this - assigns(:object).attributes - and its as simple as that. 
  end

  test 'to login with remembering' do 
    log_in_as @user, remember_me: '1'
    assert_equal assigns(:user).remember_token, cookies[:remember_token]
  end

  test 'to login without remembering' do 
    log_in_as @user, remember_me: '0' 
    assert_equal assigns(:user).remember_token, cookies[:remember_token]
  end

end