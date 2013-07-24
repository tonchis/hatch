require 'minitest/autorun'
require_relative '../lib/hatch'

class CommonStuff
  include Hatch

  certifies :present, :presence
  certifies :positive, :positive_number
end

class CommonValidationsTest < MiniTest::Unit::TestCase
  def test_presence
    common_stuff = CommonStuff.hatch(present: nil, positive: 1)
    assert_equal 'must be present', common_stuff.errors.on(:present)
  end

  def test_positive_number
    common_stuff = CommonStuff.hatch(present: 'here', positive: -1)
    assert_equal 'must be a positive number', common_stuff.errors.on(:positive)
  end
end
