require_relative 'support/helper'
require_relative 'support/address'

class ValidationTest < Test::Unit::TestCase
  def test_valid
    address = Address.hatch(street: 'Fake St', city: 'Buenos Aires', number: 1234)
    assert address.is_a?(Address)
    assert address.respond_to?(:valid?)
    assert address.valid?
  end

  def test_invalid
    address = Address.hatch(city: 'Buenos Aires', street: '', number: 1234)
    assert address.is_a?(Address::InvalidAddress)
    assert address.respond_to?(:valid?)
    assert !address.valid?
  end
end

