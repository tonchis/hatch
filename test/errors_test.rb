require 'test/unit'
require_relative 'support/address'

class ErrorsTest < Test::Unit::TestCase
  def initialize(*args)
    @address = Address.hatch(city: 'Buenos Aires', street: '', number: -1)
    super
  end

  def test_errors_on
    assert @address.errors.on(:city).empty?
    assert_equal 'Address must have a street', @address.errors.on(:street)
    assert_equal 'Address must have a positive number', @address.errors.on(:number)
  end

  def test_hash_accessor
    assert @address.errors[:city].empty?
    assert_equal 'Address must have a street', @address.errors[:street]
    assert_equal 'Address must have a positive number', @address.errors[:number]
  end

  def test_errors_full_messages
    assert @address.errors.full_messages.include?('Address must have a street')
    assert @address.errors.full_messages.include?('Address must have a positive number')
  end
end

