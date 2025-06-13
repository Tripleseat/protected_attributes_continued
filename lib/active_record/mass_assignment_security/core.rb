module ActiveRecord
  module MassAssignmentSecurity
    module Core

      def initialize(attributes = nil, options = {})
        # Store mass assignment options early so they're available during initialization
        @mass_assignment_options = options
        
        # For Rails 8+, we need to carefully handle the initialization process
        # to ensure callbacks fire at the right time
        if ActiveRecord::VERSION::MAJOR >= 8
          # In Rails 8, we let the parent handle most of the initialization
          # but we need to ensure mass assignment protection is applied
          super(nil) do |record|
            # Apply mass assignment with protection after basic initialization
            record.assign_attributes(attributes, options) if attributes
            yield record if block_given?
          end
        else
          # Rails 7 and earlier - maintain original behavior
          @new_record = true
          self.class.define_attribute_methods
          @attributes = self.class._default_attributes.deep_dup

          init_internals
          initialize_internals_callback

          # Apply mass assignment protection before assigning attributes
          assign_attributes(attributes, options) if attributes

          yield self if block_given?
          _run_initialize_callbacks
        end
      end

      private

      def init_internals
        super
        @mass_assignment_options = nil
      end

    end
  end
end
