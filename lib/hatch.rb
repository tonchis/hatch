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
    @@attributes = {}

    def self.extended(klass)
      klass_symbol = klass.to_s.to_sym
      @@validations[klass_symbol] = {}
      @@attributes[klass_symbol] = []

      invalid_class = Class.new do
        include InvalidInstanceMethods
      end

      klass.const_set("Invalid#{klass}", invalid_class)
    end

    def attributes(*args)
      @@attributes[self.to_s.to_sym] = args
    end

    def certify(attribute, error, &block)
      @@validations[self.to_s.to_sym][attribute] = Validation.new(error, &block)
    end

    def certifies(attribute, validation, error = nil)
      @@validations[self.to_s.to_sym][attribute] = Validation.send(validation, error)
    end

    def hatch(args = {})
      validated_attributes = []
      klass_symbol = self.to_s.to_sym
      @@attributes[klass_symbol].each do |attribute|
        validation = @@validations[klass_symbol][attribute]
        validated_attributes << Validator.validate(attribute,
                                                   args[attribute],
                                                   validation.error,
                                                   &validation.block)
      end

      build(validated_attributes)
    end

    module InvalidInstanceMethods
      attr_reader :errors

      def initialize(*validated_attributes)
        @validated_attributes = validated_attributes
        @errors = Errors.build(@validated_attributes)
        respond_to_instance_methods
      end

      def valid?
        false
      end

    private

      def respond_to_instance_methods
        extended_klass = Kernel.const_get(self.class.to_s.split("Invalid").last)
        address_instance_methods = extended_klass.instance_methods(false)

        attributes_with_reader = @validated_attributes.select do |validated_attribute|
          address_instance_methods.include?(validated_attribute.attr)
        end

        attributes_with_reader.each do |attribute|
          self.class.send :define_method, attribute.attr, -> {attribute.value}
        end
      end
    end

  private

    def build(validated_attributes)
      validation = -> do
        valid = true
        validated_attributes.each do |validated_attribute|
          valid = valid && validated_attribute.valid?
        end

        valid
      end

      if validation.call
        set_instance_variables(new, *validated_attributes)
      else
        const_get("Invalid#{self}").new(*validated_attributes)
      end
    end

    def set_instance_variables(instance, *args)
      @@attributes[instance.class.to_s.to_sym].each_with_index do |attribute, index|
        instance.instance_variable_set("@#{attribute}", args[index].value)
      end
      instance
    end
  end

  class Validator
    attr_reader :attr, :value, :error

    def self.validate(attr, value, error, &block)
      new(attr, value, error, yield(value))
    end

    def initialize(attr, value, error, valid)
      @attr, @value, @error, @valid = attr, value, error, valid
    end

    def valid?
      @valid
    end

    def invalid?
      !@valid
    end
  end

  class Validation
    attr_reader :error, :block

    def initialize(error, &block)
      @error = error
      @block = block
    end

    def self.presence(error)
      new(error || "must be present") {|value| !value.nil? && !value.empty?}
    end

    def self.positive_number(error)
      new(error || "must be a positive number") {|value| !value.nil? && value > 0}
    end
  end

  class Errors < Hash
    def self.build(validated_attributes)
      errors = new
      validated_attributes.each do |validated_attribute|
        if validated_attribute.invalid?
          errors[validated_attribute.attr] = validated_attribute.error
        else
          errors[validated_attribute.attr] = []
        end
      end

      errors
    end

    def on(attr)
      self[attr]
    end

    def full_messages
      messages = []
      values.each {|value| messages << value unless value.empty?}
      messages
    end

    def empty?
      full_messages.empty?
    end
  end
end

