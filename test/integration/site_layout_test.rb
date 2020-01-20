require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  def setup 
    @user = users(:michael)
  end
  
  test 'layout links' do 
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', signup_path 
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
  end

  test 'layout links of logged in user' do 
    log_in_as(@user)
    get root_path
    assert_select 'a[href=?]', "#", text: 'Account'
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', edit_user_path(@user)
    assert_select 'a[href=?]', logout_path
  end

  test "page titles" do 
    get root_path
    assert_select "title", full_title

    get help_path
    assert_select "title", full_title("Help")

    get login_path
    assert_select "title", full_title("Log in")

    get signup_path
    assert_select "title", full_title("Signup")
    
    get about_path
    assert_select "title", full_title("About")

    get contact_path
    assert_select "title", full_title("Contact")
  end

end
