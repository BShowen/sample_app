require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup 
    @user = users(:michael)
    @other_user = users(:archer)
    @non_admin = users(:lana)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when logged in as wrong user" do 
    log_in_as @user
    follow_redirect!
    get edit_user_path @other_user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do 
    log_in_as @user
    follow_redirect!
    patch user_path @other_user, params:{user:{ name: 'foo bar', 
                                                                                email: 'exmaple@example.com' }}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect to login page" do 
    get users_path
    assert_redirected_to login_url
  end

  test "shouldnt allow admin attribute to be edited via the web" do 
    log_in_as @other_user
    get edit_user_path @other_user
    assert_template 'users/edit'
    assert_not @other_user.admin?
    patch user_path @other_user, params: { user:{  password: "123123123", 
                                                                          password_confirmation: '123123123', 
                                                                          admin: 'true' }}
    @other_user.reload
    assert_not @other_user.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "User.count" do 
      delete user_path @user
    end
    assert_redirected_to login_url
  end

  test "the destroy action should redirect when logged in as a non-admin" do 
    log_in_as @non_admin
    get edit_user_path @non_admin
    assert_template 'users/edit'
    assert_no_difference 'User.count' do 
      delete user_path @user
    end
    assert_redirected_to root_url
  end

end