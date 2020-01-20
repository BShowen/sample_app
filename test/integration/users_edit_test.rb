require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test "a successful edit" do 
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    name = "foo bar"
    patch user_path(@user), params:{user:{name: name,
                                                                              email: @user.email, 
                                                                              password: 'password', 
                                                                              password_confirmation: 'password'}}
    assert_redirected_to @user
    assert_equal flash[:success], "Profile updated"
    @user.reload
    assert_equal @user.name, name
  end

  test "an unsuccessful edit" do 
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params:{user:{name: '', 
                                                                              email: '', 
                                                                              password: 'password', 
                                                                              password_confirmation: 'password'}} 
    assert_template "users/edit"
    assert_select "div.alert", "The form contains 3 errors."
    assert_select "div#error_explanation" do 
      assert_select "ul" do 
        assert_select "li", count: 3
      end
    end
  end

  test "successful edit with friendly forwarding" do 
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    assert_not session[:forwarding_url]
    name = "foo bar"
    patch user_path(@user), params:{user:{name: name,
                                                                              email: @user.email, 
                                                                              password: 'password', 
                                                                              password_confirmation: 'password'}}
    assert_redirected_to @user
    assert_equal flash[:success], "Profile updated"
    @user.reload
    assert_equal @user.name, name
  end
end
