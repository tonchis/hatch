require 'minitest/autorun'
require_relative 'support/address'

class ValidationTest < MiniTest::Unit::TestCase
  def test_valid
    address = Address.hatch(street: 'Fake St', city: 'Buenos Aires', number: 1234)
    assert_instance_of Address, address
    assert_respond_to address, :valid?
    assert address.valid?
  end

  def test_invalid
    address = Address.hatch(city: 'Buenos Aires', street: '', number: 1234)
    assert_instance_of Address::InvalidAddress, address
    assert_respond_to address, :valid?
    refute address.valid?
  end

  def test_ignore_attributes
    address = Address.hatch(street: 'Fake St', city: 'Buenos Aires', number: 1234, sorry: :oops)
    assert_instance_of Address, address
    assert address.valid?
  end
end

