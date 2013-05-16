require_relative 'support/helper'
require_relative 'support/address'

class ValidTest < Test::Unit::TestCase
  def test_valid
    address = Address.hatch(street: "Fake St", city: "Buenos Aires", number: 1234)
    assert address.is_a?(Address)
    assert_equal address.instance_variable_get("@street"), "Fake St"
    assert_equal address.instance_variable_get("@number"), 1234
    assert_equal address.instance_variable_get("@city"), "Buenos Aires"

    assert address.respond_to?(:errors)
    assert address.errors.empty?
    assert address.respond_to?(:valid?)
    assert address.valid?
  end

  def test_invalid
    address = Address.hatch(city: "Buenos Aires", street: "", number: 1234)
    assert address.is_a?(Address::InvalidAddress)
    assert address.errors.include?("Address must have a street")
    assert !address.errors.include?("Address must have a positive number")
    assert !address.errors.include?("Address must have a city")

    address = Address.hatch(street: "", number: -4)
    assert address.is_a?(Address::InvalidAddress)
    assert address.errors.include?("Address must have a street")
    assert address.errors.include?("Address must have a positive number")
    assert address.errors.include?("Address must have a city")

    assert address.respond_to?(:valid?)
    assert !address.valid?
  end
end

