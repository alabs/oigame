require 'test_helper'

class AdminControllerTest < ActionController::TestCase

  setup do
    # distintos roles de usuarios
    @user = FactoryGirl.create(:user)
    @user.confirm!
    @admin = FactoryGirl.create(:user, :role => "admin", :name => "admin", :email => "admin@example.com")
    @admin.confirm!
  end

  test "no debe llegar a /admin como usuario anonimo" do
    get "/admin"
    assert_response :redirect
  end

  test "no debe llegar a /admin como usuario normal" do
    sign_in @user
    get "/admin"
    assert_response :redirect
  end

  test "debe llegar a /admin como usuario admin" do
    sign_in @admin
    get "/admin"
    assert_response :success
  end

end
