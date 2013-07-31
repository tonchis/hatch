require 'minitest/autorun'
require_relative 'support/address'

class PolymorphismTest < MiniTest::Unit::TestCase
  def test_polymorphism
    address = Address.hatch(street: 'Fake St', number: 1234, city: 'Buenos Aires')
    assert_instance_of Address, address
    assert_equal 'Fake St', address.street
    assert_equal 1234, address.number
    assert_equal 'Buenos Aires', address.city

    address = Address.hatch(street: 'Fake St', number: -1, city: 'Buenos Aires')
    assert_instance_of Address::InvalidAddress, address
    assert_equal 'Fake St', address.street
    assert_equal -1, address.number
    assert_equal 'Buenos Aires', address.city
  end
end

