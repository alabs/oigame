require 'test_helper'

class SubOigamesControllerTest < ActionController::TestCase
  setup do
    @sub_oigame = sub_oigames(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sub_oigames)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sub_oigame" do
    assert_difference('SubOigame.count') do
      post :create, sub_oigame: @sub_oigame.attributes
    end

    assert_redirected_to sub_oigame_path(assigns(:sub_oigame))
  end

  test "should show sub_oigame" do
    get :show, id: @sub_oigame.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sub_oigame.to_param
    assert_response :success
  end

  test "should update sub_oigame" do
    put :update, id: @sub_oigame.to_param, sub_oigame: @sub_oigame.attributes
    assert_redirected_to sub_oigame_path(assigns(:sub_oigame))
  end

  test "should destroy sub_oigame" do
    assert_difference('SubOigame.count', -1) do
      delete :destroy, id: @sub_oigame.to_param
    end

    assert_redirected_to sub_oigames_path
  end
end
