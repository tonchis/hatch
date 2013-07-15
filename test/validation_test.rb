require 'test/unit'
require_relative 'support/address'

class ValidationTest < Test::Unit::TestCase
  def test_valid
    address = Address.hatch(street: 'Fake St', city: 'Buenos Aires', number: 1234)
    assert address.instance_of?(Address)
    assert address.respond_to?(:valid?)
    assert address.valid?
  end

  def test_invalid
    address = Address.hatch(city: 'Buenos Aires', street: '', number: 1234)
    assert address.instance_of?(Address::InvalidAddress)
    assert address.respond_to?(:valid?)
    assert !address.valid?
  end

  def test_ignore_attributes
    address = Address.hatch(street: 'Fake St', city: 'Buenos Aires', number: 1234, sorry: :oops)
    assert address.instance_of?(Address)
    assert address.valid?
  end
end

