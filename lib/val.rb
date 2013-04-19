module Val
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

      klass.class_eval <<-EOS
        class Invalid#{klass}
          include InvalidInstanceMethods
        end
      EOS
    end

    def attributes(*args)
      @@attributes[self.to_s.to_sym] = args
    end

    def validate(attribute, error, &block)
      @@validations[self.to_s.to_sym][attribute] = {error: error, validation: block}
    end

    def create(args = {})
      validated_attributes = []
      klass_symbol = self.to_s.to_sym
      @@attributes[klass_symbol].each do |attribute|
        validation = @@validations[klass_symbol][attribute]
        validated_attributes << Validator.validate(attribute,
                                                   args[attribute],
                                                   validation[:error],
                                                   &validation[:validation])
      end

      build(validated_attributes)
    end

    module InvalidInstanceMethods
      attr_reader :errors

      def initialize(*validated_attributes)
        @validated_attributes = validated_attributes
        select_errors
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

      def select_errors
        @errors = @validated_attributes.select do |validated_attribute|
          validated_attribute.invalid?
        end.map(&:error)
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
end

