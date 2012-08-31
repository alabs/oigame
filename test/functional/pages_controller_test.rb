require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get help" do
    get :help
    assert_response :success
  end

  test "should get privacy policy" do
    get :privacy_policy
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

  test "should get contact - received" do
    get :contact_received
    assert_response :success
  end


end
