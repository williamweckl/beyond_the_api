module BeyondTheApiTestHelpers
  module Request
    module CommonAssertions
      def assert_request_needs_to_be_logged(url, http_method)
        assert_i18n_for_all_locales do
          send(http_method, url, params: @params, headers: @headers)
          response_assertions(status: 403)
          assert_equal true, json['redirect_to_login']
          assert_equal I18n.t('api.errors.messages.require_user_authentication'), json['error']
        end
      end

      def meta
        json['meta']
      end

      def json_response_name
        json[@response_name]
      end

      def request_instance_variables_set(params = {})
        params.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
        @headers ||= {}
        @params ||= {}
        @response_name ||= (@klass || subject.class).to_s.underscore
      end

      def request_instance_variables_set_pluralize(params = {})
        request_instance_variables_set(params)
        @response_name = @response_name.pluralize
      end

      def assert_not_found_request
        response_assertions(status: 404)
        not_found_obj = @not_found_name ? I18n.t(@not_found_name) : subject.class.model_name.human
        not_found_message = I18n.t('api.errors.messages.not_found',
                                   obj: not_found_obj)
        assert_equal not_found_message, json['error']
      end

      def assert_parameter_missing_request
        response_assertions(status: 400)
        parameter_missing_message = I18n.t('api.errors.messages.parameter_missing',
                                           parameter: subject.class.to_s.underscore)
        assert_equal parameter_missing_message, json['error']
      end
    end
  end
end
