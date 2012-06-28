# encoding: utf-8
require 'test_helper'

class PetitionTest < ActiveSupport::TestCase

  test "que una petición pertenece a una campaña" do
    petition = Petition.new
    assert petition.campaign == nil
  end

  test "algunas propiedades protedigas" do
    begin
      petition = Petition.new(:validated => true)
    rescue
      assert petition.nil?
    end
  end

  test "el scope validated tiene que funcionar" do
    Petition.validated.each do |petition|
      assert petition.validated == true
    end
  end
end
