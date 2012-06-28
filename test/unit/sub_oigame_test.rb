# encoding: utf-8
require 'test_helper'

class SubOigameTest < ActiveSupport::TestCase

  test "que pertenece a un usuario" do
    so = SubOigame.new
    assert so.user == nil
  end

  test "que puede tener n campañas" do
    so = SubOigame.new
    assert so.campaigns == []
  end

  test "que el slug funcione" do
    so = SubOigame.new(:name => 'Hola mundo')
    assert so.generate_slug == 'hola-mundo'
  end

  test "obligatorio name y user" do
    so = SubOigame.new
    so.save
    assert so.errors[:name]
    assert so.errors[:user]
  end

  test "comprobar que el paso a base64 funciona" do
    so = SubOigame.new
    file = "#{Rails.root}/app/assets/images/logo.png"
    assert so.generate_base64_logo(file)
  end

  test "que to_param funcione" do
    so = SubOigame.new(:name => 'Hola mundo')
    so.generate_slug
    assert so.to_param == 'hola-mundo'
  end
end
