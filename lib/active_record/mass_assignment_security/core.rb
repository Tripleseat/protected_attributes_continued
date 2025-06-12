module ActiveRecord
  module MassAssignmentSecurity
    module Core

      def initialize(attributes = nil, options = {})
        @new_record = true
        self.class.define_attribute_methods
        @attributes = self.class._default_attributes.deep_dup

        init_internals
        initialize_internals_callback

        # Don't pass attributes to super - we'll handle them ourselves
        super()

        # Apply mass assignment protection before assigning attributes
        assign_attributes(attributes, options) if attributes

        yield self if block_given?
        _run_initialize_callbacks
      end

      private

      def init_internals
        super
        @mass_assignment_options = nil
      end

    end
  end
end
