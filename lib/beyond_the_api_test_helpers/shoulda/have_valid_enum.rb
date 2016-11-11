module Shoulda
  module Matchers
    module ActiveRecord
      def have_valid_enum(field, enum_klass)
        HaveValidEnumMatcher.new(field, enum_klass)
      end

      # @private
      class HaveValidEnumMatcher
        def initialize(field, enum_klass)
          @field = field
          @enum_klass = enum_klass
        end

        def matches?(subject)
          @subject = subject
          @expected_message ||= :inclusion

          matches_positive? && matches_negative?
        end

        def matches_positive?
          @subject.send("#{@field}=", 999)
          @subject.valid?
          @subject.errors[@field].include? I18n.t("errors.messages.#{@expected_message}")
        end

        def matches_negative?
          @subject.send("#{@field}=", @enum_klass.list.sample)
          @subject.valid?
          !@subject.errors[@field].include? I18n.t("errors.messages.#{@expected_message}")
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
          "have a valid enum #{@enum_klass} called #{@field}"
        end

        private

        def expectation
          "#{model_class.name} to #{description}"
        end

        def model_class
          @subject.class
        end
      end
    end
  end
end
