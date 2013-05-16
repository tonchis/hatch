require_relative 'support/helper'
require_relative '../lib/hatch'

class CommonStuff
  include Hatch

  attributes :present, :positive

  certifies :present, :presence
  certifies :positive, :positive_number
end

class CommonValidationsTest < Test::Unit::TestCase
  def test_presence
    common_stuff = CommonStuff.hatch(present: nil, positive: 1)
    assert common_stuff.is_a?(CommonStuff::InvalidCommonStuff)
    assert common_stuff.errors.include?("must be present")
  end

  def test_positive_number
    common_stuff = CommonStuff.hatch(present: "here", positive: -1)
    assert common_stuff.is_a?(CommonStuff::InvalidCommonStuff)
    assert common_stuff.errors.include?("must be a positive number")
  end
end
