# encoding: utf-8
require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  
  test "que un mensaje pertenece a una campaña" do
    message = Message.new
    assert message.campaign == nil
  end

  test "algunas propiedades protedigas" do
    begin
      message = Message.new(:validated => true)
    rescue
      assert message.nil?
    end
  end

  test "el scope validated tiene que funcionar" do
    Message.validated.each do |message|
      assert message.validated == true
    end
  end
end
