require 'test_helper'
require 'ar_helper'
require 'active_record/mass_assignment_security'
require 'models/person'

class AfterInitializeTest < ActiveSupport::TestCase
  def setup
    @callback_log = []
    test_instance = self
    LoosePerson.after_initialize do
      test_instance.instance_variable_get(:@callback_log) << {
        callback: :after_initialize,
        attributes: attributes.dup,
        first_name: first_name,
        gender: gender
      }
    end
  end
  
  def teardown
    LoosePerson.reset_callbacks(:initialize)
  end
  
  def test_after_initialize_fires_after_attributes_are_set
    person = LoosePerson.new(first_name: 'John', gender: 'm', comments: 'test')
    
    assert_equal 1, @callback_log.size
    callback_data = @callback_log.first
    
    assert_equal :after_initialize, callback_data[:callback]
    assert_equal 'John', callback_data[:first_name]
    assert_equal 'm', callback_data[:gender]
    assert_nil callback_data[:attributes]['comments'], "Comments should not be set without proper role"
  end
  
  def test_after_initialize_fires_after_attributes_with_role
    person = LoosePerson.new({first_name: 'John', gender: 'm', comments: 'test'}, as: :admin)
    
    assert_equal 1, @callback_log.size
    callback_data = @callback_log.first
    
    assert_equal :after_initialize, callback_data[:callback]
    assert_equal 'John', callback_data[:first_name]
    assert_equal 'm', callback_data[:gender]
    assert_equal 'test', callback_data[:attributes]['comments'], "Comments should be set with admin role"
  end
  
  def test_after_initialize_fires_after_attributes_without_protection
    person = LoosePerson.new({first_name: 'John', gender: 'm', comments: 'test'}, without_protection: true)
    
    assert_equal 1, @callback_log.size
    callback_data = @callback_log.first
    
    assert_equal :after_initialize, callback_data[:callback]
    assert_equal 'John', callback_data[:first_name]
    assert_equal 'm', callback_data[:gender]
    assert_equal 'test', callback_data[:attributes]['comments'], "Comments should be set without protection"
  end
end