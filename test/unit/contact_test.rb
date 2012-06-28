# encoding: utf-8
require 'test_helper'

class ContactTest < ActiveSupport::TestCase

  test "algunas propiedades protegidas" do
    begin
      contact = Cotact.new(:created_at => Time.now)
    rescue
      assert contact.nil?
    end
  end

  test "es necesario un nombre" do
    contact = Contact.new
    contact.save
    assert contact.errors[:name]
  end

  test "hay que introducir un mail válido" do
    contact = Contact.new
    contact.email = 'asda'
    contact.save
    assert contact.errors[:email]
  end

  test "hay que introducir un body" do
    contact = Contact.new
    contact.save
    assert contact.errors[:body]
  end
end
