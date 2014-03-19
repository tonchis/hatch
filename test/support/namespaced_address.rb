require_relative '../../lib/hatch'
require_relative 'address'

module SomeApp; end
SomeApp.const_set('Address', Address)
