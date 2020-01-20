require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user = users(:michael)
    @non_admin_user = users(:archer)
  end

  test "pagination should populate exactly 30 users" do 
    log_in_as(@admin_user)    
    get users_path
    assert_template 'users/index'
    assert_select "ul.users", count: 1 do 
      assert_select "li", count: 30
    end
  end

  test "pagination links should be set to users names" do 
    log_in_as(@admin_user)
    get users_path
    assert_template 'users/index'
    assert_select "div.pagination", count: 2
    User.paginate(page:1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

  test "should allow a logged in admin-user to successfully delete another user" do 
    log_in_as @admin_user
    assert_difference 'User.count', -1 do 
      delete user_path @non_admin_user
    end
  end

  test "index as admin should include pagniation and delete links" do
    log_in_as @admin_user
    get users_path
    assert_template "users/index"
    assert_select "div.pagination", count: 2
    first_page_of_users = User.paginate page: 1
    first_page_of_users.each do |user|
      next if user == @admin_user
      assert_select 'a[href=?]', user_path(user, page: 1)
    end
  end

  test "index as non-admin should not have delete links" do
    log_in_as @non_admin_user
    get users_path
    assert_template "users/index"
    assert_select "div.pagination", count: 2
    first_page_of_users = User.paginate page: 1
    # first_page_of_users.each do |user|
    #   assert_select "a[href=?]", user_path(user, page: 1), false, "This page should not have delete buttons"
    # end
    assert_select 'a', text: 'Delete', count: 0
  end

end
