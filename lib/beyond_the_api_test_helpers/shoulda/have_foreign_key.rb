module Shoulda
  module Matchers
    module ActiveRecord
      def have_foreign_key(table, fk)
        HaveForeignKeyMatcher.new(table, fk)
      end

      # @private
      class HaveForeignKeyMatcher
        def initialize(table, fk)
          @table = table
          @fk = fk
          @options = {}
        end

        def matches?(subject)
          @subject = subject

          foreign_keys = ::ActiveRecord::Base.connection
                                             .foreign_keys(table_name)
                                             .map do |foreign_key|
            { to_table: foreign_key['to_table'].to_sym,
              fk: foreign_key['options'][:column].to_sym }
          end

          foreign_keys.include? to_table: @table, fk: @fk
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
          "have a foreign_key to table #{@table}"
        end

        private

        def expectation
          "#{model_class.name} to #{description}"
        end

        def model_class
          @subject.class
        end

        def table_name
          model_class.table_name
        end
      end
    end
  end
end
