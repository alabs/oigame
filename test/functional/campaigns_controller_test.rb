require 'test_helper'

class CampaignsControllerTest < ActionController::TestCase
  setup do
    @campaign = FactoryGirl.build(:campaign)

    # distintos roles de usuarios
    @user = users(:normal)
    @user.confirm!
    @admin = users(:admin)
    @admin.role = :admin
    @admin.confirm!
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(@campaigns)
  end

  test "should get new as user" do
    sign_in @user
    get :new
    assert_response :success
  end

  test "should redirect on new as anon" do
    get :new
    assert_response :redirect
  end

  test "should redirect on create campaign as anon" do
    post :create, campaign: @campaign.attributes
    assert_response :redirect
  end

  test "should create campaign as user" do
    assert_difference('Campaign.count') do
      sign_in @user
      post :create, campaign: @campaign.attributes
    end
    assert_redirected_to campaign_path(assigns(:campaign))
  end

  test "should show campaign" do
    debugger
    get :show, id: @campaign.to_param
    assert_response :success
  end

  test "should redirect on edit as anon" do
    get :edit, id: @campaign.to_param
    assert_response :redirect
  end

  test "should update campaign" do
    put :update, id: @campaign.to_param, campaign: @campaign.attributes
    assert_redirected_to campaign_path(assigns(:campaign))
  end

  test "should destroy campaign" do
    assert_difference('Campaign.count', -1) do
      sign_in @admin
      delete :destroy, id: @campaign.id
    end

    assert_redirected_to campaigns_path
  end
end
