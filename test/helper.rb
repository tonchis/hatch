require 'test/unit'
require 'pry'
require_relative '../lib/val'

class Address
  attr_reader :city, :street, :number

  include Val
  attributes :city, :street, :number

  validate(:street, "Address must have a street") do |street|
    !street.nil? && !street.empty?
  end

  validate(:number, "Address must have a positive number") do |number|
    !number.nil? && number > 0
  end

  validate(:city, "Address must have a city") do |city|
    !city.nil? && !city.empty?
  end
end

