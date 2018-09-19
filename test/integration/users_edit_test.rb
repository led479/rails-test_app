require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "uncusseful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "", email: "foo@invalid", password: "foo", password_confirmation: "bar"}}
    assert_template 'users/edit'
    assert_select 'div.alert', "The form contains 4 errors."
  end

  test "succeful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "aaaaaaaa"
    email = "foo@valid.com"
    patch user_path(@user), params: { user: { name: name, email: email, password: "", password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "can't edit if not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "can't update if not logged in" do
    patch user_path(@user), params: {user: { name: @user.name, email: @user.email}}
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end
