module BeyondTheApiTestHelpers
  module Request
    module UpdateAssertions
      def assert_request_update_valid(url, options = {})
        request_instance_variables_set options
        if required_login
          assert_request_needs_to_be_logged(url, :put)
          assert_request_needs_to_be_logged(url, :patch)
          @headers.merge!(logged_in_headers)
        end

        assert_i18n_for_all_locales do
          do_update_request_with_transaction(url)
        end
      end

      def assert_request_update_missing_param(url, options = {})
        request_instance_variables_set options
        @headers.merge!(logged_in_headers) if required_login
        patch(url, params: {}, headers: @headers)
        assert_parameter_missing_request
        put(url, params: {}, headers: @headers)
        assert_parameter_missing_request
      end

      def assert_request_update_with_errors(url, invalid_params, params = {})
        request_instance_variables_set params
        # pp @headers
        # pp user_authorizations(:logged)
        # abort
        @headers.merge!(logged_in_headers) if required_login

        ActiveRecord::Base.transaction do
          do_update_request_and_assert_invalid(url, invalid_params)
          raise ActiveRecord::Rollback
        end
      end

      def assert_request_update_not_found(urls_not_found, options = {})
        request_instance_variables_set options
        @headers.merge!(logged_in_headers) if required_login

        urls_not_found.each do |url_not_found|
          assert_request_update_not_found_i18n_all(url_not_found)
        end
      end

      private

      def do_update_request_with_transaction(url)
        ActiveRecord::Base.transaction do
          do_update_request_and_assert(url)
          raise ActiveRecord::Rollback
        end
      end

      def do_update_request_and_assert(url)
        patch(url, params: @params, headers: @headers)
        subject.reload
        changes.each do |key, value|
          assert_equal subject.send(key), value
        end
        update_assertions_status_and_message
      end

      def update_assertions_status_and_message
        response_assertions(status: 200)
        assert_equal I18n.t(*@message), json['success']
        assert_kind_of Hash, json_response_name unless @skip_json_response_name
      end

      def do_update_request_and_assert_invalid(url, invalid_params)
        patch(url, params: invalid_params, headers: @headers)
        subject.reload
        changes.each do |key, value|
          assert_not_equal subject.send(key), value
        end
        response_assertions(status: 422)
        assert_kind_of Hash, json['errors']
        assert_kind_of Array, json['full_error_messages']
      end

      def assert_request_update_not_found_i18n_all(url_not_found)
        assert_i18n_for_all_locales do
          patch(url_not_found, params: @params, headers: @headers)
          assert_not_found_request
        end
      end
    end
  end
end
