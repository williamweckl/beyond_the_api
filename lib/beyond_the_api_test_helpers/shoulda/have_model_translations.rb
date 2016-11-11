module Shoulda
  module Matchers
    module ActiveModel
      def have_model_translations(options = {})
        HaveModelTranslationsMatcher.new(options)
      end

      # @private
      class HaveModelTranslationsMatcher
        def initialize(options = {})
          @options = options
        end

        def matches?(subject)
          @subject = subject
          matches_model_name? && matches_attributes?
        end

        def matches_model_name?
          I18n.available_locales.each do |locale|
            I18n.locale = locale
            return false unless model_name.human == I18n.t("#{i18n_path}.one")
            return false unless model_name.human(count: 2) == I18n.t("#{i18n_path}.other")
          end
        end

        def matches_attributes?
          attributes = @options[:attributes]
          return true unless attributes
          attributes.each do |attribute|
            return false unless assert_translated_attribute(attribute)
          end
          true
        end

        def assert_translated_attribute(attribute)
          begin
            translated_attr = I18n.t('activerecord.attributes.' \
                                     "#{model_class.to_s.underscore}.#{attribute}")
          rescue
            translated_attr = I18n.t("attributes.#{attribute}")
          end
          model_class.human_attribute_name(attribute) == translated_attr
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
          'have model translations'
        end

        private

        def expectation
          "#{model_class.name} to #{description}"
        end

        def model_class
          @subject.class
        end

        def model_name
          model_class.model_name
        end

        def i18n_path
          "activerecord.models.#{model_class.name.underscore}"
        end
      end
    end
  end
end
