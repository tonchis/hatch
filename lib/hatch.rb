module Hatch
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def errors
    []
  end

  def valid?
    true
  end

  module ClassMethods
    @@validations = {}

    def self.extended(klass)
      klass_symbol = klass.to_s.to_sym
      @@validations[klass_symbol] = {}

      invalid_class = Class.new do
        include InvalidInstanceMethods
      end

      klass.const_set("Invalid#{klass}", invalid_class)
    end

    def certify(attribute, error, &block)
      @@validations[self.to_s.to_sym][attribute] = Validation.new(error, &block)
    end

    def certifies(attribute, validation, error = nil)
      @@validations[self.to_s.to_sym][attribute] = Validation.send(validation, error)
    end

    def hatch(args = {})
      validated_attributes = []
      @@validations[self.to_s.to_sym].each_pair do |attribute, validation|
        validated_attributes << ValidatedAttribute.validate(attribute,
                                                            args[attribute],
                                                            validation.error,
                                                            &validation.block)
      end

      build(validated_attributes)
    end

    def build(validated_attributes)
      if validated_attributes.all? {|validated_attribute| validated_attribute.valid?}
        set_instance_variables(new, *validated_attributes)
      else
        const_get("Invalid#{self}").new(*validated_attributes)
      end
    end
    private :build

    def set_instance_variables(instance, *args)
      @@validations[instance.class.name.to_sym].keys.each_with_index do |attribute, index|
        instance.instance_variable_set("@#{attribute}", args[index].value)
      end
      instance
    end
    private :set_instance_variables

    module InvalidInstanceMethods
      attr :errors

      def initialize(*validated_attributes)
        @validated_attributes = validated_attributes
        @errors = Errors.build(@validated_attributes)
        respond_to_readable_attributes
      end

      def valid?
        false
      end

      def respond_to_readable_attributes
        readable_attributes.each do |readable_attribute|
          self.class.send(:define_method,
                          readable_attribute.attribute,
                          -> {readable_attribute.value})
        end
      end
      private :respond_to_readable_attributes

      def readable_attributes
        extended_class = Kernel.const_get(self.class.name.split("Invalid").last)
        instance_methods = extended_class.instance_methods(false)

        @validated_attributes.select do |validated_attribute|
          instance_methods.include?(validated_attribute.attribute)
        end
      end
      private :readable_attributes
    end
  end

  class ValidatedAttribute
    attr :attribute, :value, :error

    def self.validate(attribute, value, error, &block)
      if yield(value)
        ValidAttribute.new(attribute, value)
      else
        InvalidAttribute.new(attribute, value, error)
      end
    end

    def initialize(attribute, value, error = [])
      @attribute, @value, @error = attribute, value, error
    end
  end

  class ValidAttribute < ValidatedAttribute
    def valid?
      true
    end

    def invalid?
      false
    end
  end

  class InvalidAttribute < ValidatedAttribute
    def valid?
      false
    end

    def invalid?
      true
    end
  end

  class Validation
    attr :error, :block

    def initialize(error, &block)
      @error, @block = error, block
    end

    def self.not_nil(error)
      new(error || 'must not be nil') {|value| !value.nil?}
    end

    def self.positive_number(error)
      new(error || 'must be a positive number') {|value| !value.nil? && value > 0}
    end

    def self.not_empty(error)
      new(error || 'must not be empty') {|value| !value.nil? && !value.empty?}
    end
  end

  class Errors < Hash
    def self.build(validated_attributes)
      self[attributes_and_errors(validated_attributes)]
    end

    def on(attr)
      self[attr]
    end

    def full_messages
      values.reject {|value| value.empty?}
    end

    def empty?
      full_messages.empty?
    end

    def self.attributes_and_errors(validated_attributes)
      validated_attributes.map do |validated_attribute|
        [validated_attribute.attribute, validated_attribute.error]
      end
    end
    private_class_method :attributes_and_errors
  end
end

