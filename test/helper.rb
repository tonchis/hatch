require 'test/unit'
require 'pry'
require_relative '../lib/hatch'

class Address
  attr_reader :city, :street, :number

  include Hatch
  attributes :city, :street, :number

  certifies(:city, :presence)

  certifies(:street, :presence, "Address must have a street")

  certify(:number, "Address must have a positive number") do |number|
    !number.nil? && number > 0
  end
end

