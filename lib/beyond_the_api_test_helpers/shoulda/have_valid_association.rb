module Shoulda
  module Matchers
    module ActiveRecord
      def have_valid_association(association)
        HaveValidAssociationMatcher.new(association)
      end

      # @private
      class HaveValidAssociationMatcher
        def initialize(association)
          @association = association
          @options = {}
        end

        def matches?(subject)
          @subject = subject

          @expected_message ||= :required

          @subject.send("#{@association}_id=", 999_967)
          @subject.valid?
          @subject.errors[@association].include? I18n.t("errors.messages.#{@expected_message}")
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
          "have a valid association called #{@association}"
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
