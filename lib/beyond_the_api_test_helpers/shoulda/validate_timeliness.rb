module Shoulda
  module Matchers
    module ActiveModel
      def validate_timeliness(attribute, date_type)
        ValidateTimelinessMatcher.new(attribute, date_type)
      end

      # @private
      class ValidateTimelinessMatcher
        def initialize(attribute, date_type)
          @attribute = attribute
          @date_type = date_type
          @options = {}
        end

        [:on_or_before, :before,
         :on_or_after, :after,
         :between].each do |method_name|
          define_method(method_name) do |value|
            @options[method_name] = value
            self
          end
        end

        def matches?(subject)
          @subject = subject
          valid_date_according_to_type? && valid_date_according_to_options?
        end

        def failure_message
          "Expected #{expectation} (#{@missing})"
        end
        alias failure_message_for_should failure_message

        def failure_message_when_negated
          "Did not expect #{expectation}"
        end
        alias failure_message_for_should_not failure_message_when_negated

        def description
          description = "ensure #{@attribute} has a valid #{@date_type} "
          %w(before on_or_before after on_or_after between).each do |validator|
            symbolized_validator = validator.to_sym
            if @options.key?(symbolized_validator)
              description << "#{validator.tr('_', ' ')} #{@options[symbolized_validator]}"
            end
          end
          description
        end

        private

        def expectation
          "#{model_class.name} to #{description}"
        end

        def model_class
          @subject.class
        end

        def valid_date_according_to_type?
          @subject.send("#{@attribute}=", 'string')
          @subject.valid?
          return false if @subject.send(@attribute)
          return false unless valid_datetime?
          true
        end

        def valid_datetime?
          message = message_base("invalid_#{@date_type}")

          valid_datetime_by_value?(9999, message)

          correct_date = Date.new(1990, 2, 1)
          valid_datetime_by_value?('1990-02-01', message, correct_date)
          valid_datetime_by_value?('1990/02/01', message, correct_date)
          valid_datetime_by_value?('01/02/1990', message, correct_date)

          true
        end

        def valid_datetime_by_value?(value, message, correct_date = nil)
          @subject.send("#{@attribute}=", value)
          @subject.valid?
          return false if @subject.errors[@attribute].include? message
          return false unless valid_correct_date?(correct_date)
          true
        end

        def valid_correct_date?(correct_date)
          return true unless correct_date
          @subject.send(@attribute) == correct_date
        end

        def valid_date_according_to_options?
          assertions = [true]

          [:on_or_before, :before,
           :on_or_after, :after,
           :between].each do |method_name|
            assertions << send("#{method_name}?") if @options[method_name]
          end
          assertions.all? { |assertion| assertion }
        end

        [:on_or_before, :before,
         :on_or_after, :after].each do |method_name|
          define_method("#{method_name}?") do
            message = message_base(method_name).gsub('%{restriction}', '')
            date_value = @options[method_name]

            # Validate for before as informed
            before_assertion = assertion_date_options(add_datetime(date_value), message)
            before_assertion = !before_assertion unless method_name.to_s.include?('before')
            return false unless before_assertion

            # Validate for same date as informed
            same_date_assertion = assertion_date_options(date_value, message)
            same_date_assertion = !same_date_assertion if method_name.to_s.starts_with?('on')
            return false unless same_date_assertion

            # Validate for after as informed
            after_assertion = assertion_date_options(subtract_datetime(date_value), message)
            after_assertion = !after_assertion unless method_name.to_s.include?('after')
            return false unless after_assertion

            true
          end
        end

        def convert_to_date(object)
          converted = Time.zone.parse(object)
          converted = converted.to_date if @date_type == :date
          converted
        end

        def add_datetime(object)
          converted_to_date = convert_to_date(object)
          if is_time?
            converted_to_date + 1.second
          else
            converted_to_date + 1.day
          end
        end

        def subtract_datetime(object)
          converted_to_date = convert_to_date(object)
          if is_time?
            converted_to_date - 1.second
          else
            converted_to_date - 1.day
          end
        end

        def is_time?
          @date_type == :datetime || @date_type == :time
        end

        def assertion_date_options(date_manipulated, message)
          @subject.send("#{@attribute}=", date_manipulated)
          @subject.valid?
          @subject.errors[@attribute].join(' ').include? message
        end

        def message_base(message_id)
          underscored_klass = @subject.class.name.underscore
          begin
            I18n.t("activerecord.errors.models.#{underscored_klass}.attributes." \
            "#{@attribute}.#{message_id}")
          rescue RuntimeError
            I18n.t("activerecord.errors.models.#{underscored_klass}.#{message_id}")
          end
        rescue RuntimeError
          I18n.t("errors.messages.#{message_id}")
        end
      end
    end
  end
end
