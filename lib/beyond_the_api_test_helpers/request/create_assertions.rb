module BeyondTheApiTestHelpers
  module Request
    module CreateAssertions
      def assert_request_create_valid(url, options = {})
        request_instance_variables_set options
        if required_login
          assert_request_needs_to_be_logged(url, :post)
          @headers.merge!(logged_in_headers)
        end

        assert_i18n_for_all_locales do
          do_create_request_with_transaction(url)
        end
      end

      def assert_request_create_missing_param(url, options = {})
        request_instance_variables_set options
        @headers.merge!(logged_in_headers) if required_login
        post(url, params: {}, headers: @headers)
        assert_parameter_missing_request
      end

      def assert_request_create_with_errors(url, invalid_params, options = {})
        request_instance_variables_set options
        @headers.merge!(logged_in_headers) if required_login

        ActiveRecord::Base.transaction do
          do_create_request_and_assert_invalid(url, invalid_params)
          raise ActiveRecord::Rollback
        end
      end

      def assert_request_create_not_found(urls_not_found, options = {})
        request_instance_variables_set options
        @headers.merge!(logged_in_headers) if required_login

        urls_not_found.each do |url_not_found|
          assert_request_create_not_found_i18n_all(url_not_found)
        end
      end

      private

      def do_create_request_with_transaction(url)
        ActiveRecord::Base.transaction do
          do_create_request_and_assert(url)
          Redis.current.flushdb if @flush_redis_db_between_i18n_tests
          raise ActiveRecord::Rollback
        end
      end

      # :reek:DuplicateMethodCall: { max_calls: 2 }
      def do_create_request_and_assert(url)
        klass = @klass || subject.class
        old_count = klass.count
        post(url, params: @params, headers: @headers)
        response_assertions(status: 201)
        assert_equal old_count + 1, klass.count unless @skip_count
        assert_equal I18n.t(*@message), json['success']
        assert_kind_of Hash, json_response_name unless @skip_json_response_name
      end

      # :reek:DuplicateMethodCall: { max_calls: 2 }
      def do_create_request_and_assert_invalid(url, invalid_params)
        klass = @klass || subject.class
        old_count = klass.count
        post(url, params: invalid_params, headers: @headers)
        response_assertions(status: 422)
        assert_equal old_count, klass.count
        assert_kind_of Hash, json['errors']
        assert_kind_of Array, json['full_error_messages']
      end

      def assert_request_create_not_found_i18n_all(url_not_found)
        assert_i18n_for_all_locales do
          post(url_not_found, params: @params, headers: @headers)
          assert_not_found_request
        end
      end
    end
  end
end
