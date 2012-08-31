require 'test_helper'

class AdminTest < ActionDispatch::IntegrationTest

  setup do
    # distintos roles de usuarios
    @user = FactoryGirl.create(:user)
    @user.confirm!
    @admin = FactoryGirl.create(:user, :role => "admin", :name => "admin", :email => "admin@example.com")
    @admin.confirm!
  end

  def login(user)
    # sign_in no funciona para integration test
    post user_session_path, :email => user.email, :password => user.password
  end

  test "no debe llegar a /admin como usuario anonimo" do
    get "/admin"
    assert_response :redirect
  end

  test "no debe llegar a /admin como usuario normal" do
    #sign_in @user
    login(@user)
    get "/admin"
    assert_response :redirect
  end

  test "debe llegar a /admin como usuario admin" do
    #sign_in @admin
    login(@admin)
    get "/admin"
    assert_response :success
  end
end
