require 'test_helper'

class CampaignsControllerTest < ActionController::TestCase
  setup do
    # distintos roles de usuarios
    @user = FactoryGirl.create(:user)
    @user.confirm!
    @admin = users(:admin)
    @admin.role = :admin
    @admin.confirm!
  end

  test "should get index" do
    @campaign = FactoryGirl.build(:campaign)

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
    post :create, campaign: @campaign.attributes.slice("name", "intro", "body")
    assert_response :redirect
  end

  test "should create campaign as user" do
    assert_difference('Campaign.count') do
      sign_in @user
      post :create, campaign: @campaign.attributes.slice("name", "intro", "body")
    end
    assert_redirected_to campaign_path(assigns(:campaign))
  end

  test "should show campaign" do
    campaign = FactoryGirl.create(:campaign)
    get :show, id: campaign.slug
    assert_response :success
  end

  test "should redirect on edit as anon" do
    campaign = FactoryGirl.create(:campaign)
    get :edit, id: campaign.slug
    assert_response :redirect
  end

  test "should update campaign" do
    put :update, id: @campaign.to_param, campaign: @campaign.attributes.slice("name", "intro", "body")
    assert_redirected_to campaign_path(assigns(:campaign))
  end

  test "should destroy campaign" do
    assert_difference('Campaign.count', 0) do
      campaign = FactoryGirl.create(:campaign)
      sign_in @admin
      delete :destroy, id: campaign.slug
    end

    assert_redirected_to campaigns_path
  end
end
