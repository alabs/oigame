# encoding: utf-8
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "algunas propiedades protegidas" do
    begin
      user = User.new(:role => 'admin')
    rescue
      assert user.nil?
    end
  end

  test "un usuario puede tener una campaña" do
    user = User.new
    assert user.campaigns == []
  end

  test "un usuario puede tener un suboigame" do
    user = User.new
    assert user.sub_oigame == nil
  end

  test "solo traerse los usuarios de mailing" do
    User.get_mailing_users.each do |user|
      assert user.mailing == true
    end
  end

  test "que los roles funcionen" do
    user = User.new
    user.role = 'admin'
    assert user.role?('user')
  end

  test "que está listo para donar" do
    user = User.new
    assert user.ready_for_donation == false
  end
end
