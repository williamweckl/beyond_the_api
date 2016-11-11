module BeyondTheApiTestHelpers
  module Request
    module ShowAssertions
      def assert_request_show_valid(url, options = {})
        request_instance_variables_set options

        if required_login
          assert_request_needs_to_be_logged(url, :get)
          @headers.merge!(logged_in_headers)
        end

        get(url, params: @params, headers: @headers)
        response_assertions(status: 200)
        assert_kind_of Hash, json_response_name
      end

      def assert_request_show_not_found(urls_not_found, options = {})
        request_instance_variables_set options
        @headers.merge!(logged_in_headers) if required_login

        urls_not_found.each do |url_not_found|
          assert_request_show_not_found_i18n_all(url_not_found)
        end
      end

      private

      def assert_request_show_not_found_i18n_all(url_not_found)
        assert_i18n_for_all_locales do
          get(url_not_found, params: @params, headers: @headers)
          assert_not_found_request
        end
      end
    end
  end
end
