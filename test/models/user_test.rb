require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup 
    @user = User.new(name: "Example Name", email: "ExampleEmail@example.com", 
                                      password: "sample_password", password_confirmation: "sample_password")
  end

  test "should be valid" do 
    assert @user.valid?
  end

  test "name cant be blank" do 
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email cant be blank" do 
    @user.email = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do 
    @user.name = "a" * 30
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = ("a" * 244) + "@email.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid email addresses" do 
    @valid_emails = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    @valid_emails. each do |valid_email|
      @user.email = valid_email
      assert @user.valid?, "#{valid_email}, should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[foo@bar..com user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address} should be invalid"
    end
  end

  test "email address should be unique" do 
    duplicate_user = @user.dup
    duplicate_user.email.upcase!
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be downcased before saving to db" do 
    @user.email = "ExAmPlE@eMaIL.CoM"
    @user.save
    assert_equal @user.reload.email, "example@email.com"
  end

  test "user must enter password" do
    @user.password_digest = ''
    @user.password_confirmation = ''
    assert_not @user.valid?
  end

  test "password should not be blank" do 
    @user.password = '       '
    @user.password_confirmation = '       '
    assert_not @user.valid?
  end

  test "password must be at least 6 chars long" do 
    @user.password = "foo"
    @user.password_confirmation = "foo"
    assert_not @user.valid?
  end
end
