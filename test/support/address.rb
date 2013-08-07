require_relative '../../lib/hatch'

class Address
  attr_reader :city, :street, :number

  include Hatch

  certify(:city, 'Address must have a city') do |city|
    !city.nil? && !city.empty?
  end

  certify(:street, 'Address must have a street') do |street|
    !street.nil? && !street.empty?
  end

  certify(:number, 'Address must have a positive number') do |number|
    !number.nil? && number > 0
  end
end

