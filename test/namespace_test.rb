require 'minitest/autorun'
require_relative 'support/namespaced_address'

class NamespaceTest < MiniTest::Unit::TestCase
  def test_namespace
    address = SomeApp::Address.hatch(street: 'Fake St', number: 1234, city: 'Buenos Aires')
    assert_instance_of SomeApp::Address, address

    address = SomeApp::Address.hatch(street: 'Fake St', number: -1, city: 'Buenos Aires')
    assert_instance_of SomeApp::Address::InvalidAddress, address
  end
end
