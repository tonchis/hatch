require_relative 'helper'

class PolymorphismTest < Test::Unit::TestCase
  def test_polymorphism
    address = Address.hatch(street: "Fake St", number: 1234, city: "Buenos Aires")
    assert address.is_a?(Address)
    assert_equal address.street, "Fake St"
    assert_equal address.number, 1234
    assert_equal address.city,   "Buenos Aires"

    address = Address.hatch(street: "Fake St", number: -1, city: "Buenos Aires")
    assert address.is_a?(Address::InvalidAddress)
    assert_equal address.street, "Fake St"
    assert_equal address.number, -1
    assert_equal address.city,   "Buenos Aires"
  end
end

