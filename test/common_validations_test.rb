require 'minitest/autorun'
require_relative '../lib/hatch'

class CommonStuff
  include Hatch

  certifies :present, :presence
  certifies :positive, :positive_number
  certifies :not_empty, :not_empty
end

class CommonValidationsTest < MiniTest::Unit::TestCase
  def test_presence
    common_stuff = CommonStuff.hatch(present: nil)
    assert_equal 'must be present', common_stuff.errors.on(:present)
  end

  def test_positive_number
    common_stuff = CommonStuff.hatch(positive: -1)
    assert_equal 'must be a positive number', common_stuff.errors.on(:positive)
  end

  def test_not_empty
    common_stuff = CommonStuff.hatch(not_empty: [])
    assert_equal 'must not be empty', common_stuff.errors.on(:not_empty)
  end
end
