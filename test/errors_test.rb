require 'minitest/autorun'
require_relative 'support/address'

class ErrorsTest < MiniTest::Unit::TestCase
  def setup
    @address = Address.hatch(city: 'Buenos Aires', street: '', number: -1)
  end

  def test_errors_on
    assert_empty @address.errors.on(:city)
    assert_equal 'Address must have a street', @address.errors.on(:street)
    assert_equal 'Address must have a positive number', @address.errors.on(:number)
  end

  def test_hash_accessor
    assert_empty @address.errors[:city]
    assert_equal 'Address must have a street', @address.errors[:street]
    assert_equal 'Address must have a positive number', @address.errors[:number]
  end

  def test_errors_full_messages
    assert_includes @address.errors.full_messages, 'Address must have a street'
    assert_includes @address.errors.full_messages, 'Address must have a positive number'
  end
end

