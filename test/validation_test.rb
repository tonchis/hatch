require_relative 'helper'

class ValidTest < Test::Unit::TestCase
  def test_valid
    address = Address.create(street: "Fake St", city: "Buenos Aires", number: 1234)
    assert address.is_a?(Address)
    assert_equal address.instance_variable_get("@street"), "Fake St"
    assert_equal address.instance_variable_get("@number"), 1234
    assert_equal address.instance_variable_get("@city"), "Buenos Aires"
  end

  def test_invalid
    address = Address.create(city: "Buenos Aires", street: "", number: 1234)
    assert address.is_a?(Address::InvalidAddress)
    assert address.errors.include?("Address must have a street")
    assert !address.errors.include?("Address must have a positive number")
    assert !address.errors.include?("Address must have a city")

    address = Address.create(street: "", number: -4)
    assert address.is_a?(Address::InvalidAddress)
    assert address.errors.include?("Address must have a street")
    assert address.errors.include?("Address must have a positive number")
    assert address.errors.include?("Address must have a city")
  end
end

