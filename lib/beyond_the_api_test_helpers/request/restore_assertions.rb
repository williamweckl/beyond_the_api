module BeyondTheApiTestHelpers
  module Request
    module RestoreAssertions
      def assert_request_restore_valid(url, options = {})
        request_instance_variables_set options
        if required_login
          assert_request_needs_to_be_logged(url, :patch)
          assert_request_needs_to_be_logged(url, :put)
          @headers.merge!(logged_in_headers)
        end

        assert_i18n_for_all_locales do
          do_restore_request_with_transaction(url)
        end
      end

      def assert_request_restore_not_found(urls_not_found, options = {})
        request_instance_variables_set options
        @headers.merge!(logged_in_headers) if required_login

        urls_not_found.each do |url_not_found|
          assert_request_restore_not_found_i18n_all(url_not_found)
        end
      end

      private

      def do_restore_request_with_transaction(url)
        ActiveRecord::Base.transaction do
          do_restore_request_and_assert(url)
          raise ActiveRecord::Rollback
        end
      end

      # :reek:DuplicateMethodCall: { max_calls: 2 }
      def do_restore_request_and_assert(url)
        patch(url, params: @params, headers: @headers)
        assert_nil subject.reload.deleted_at
        response_assertions(status: 200)
        assert_equal I18n.t(@message), json['success']
      end

      def assert_request_restore_not_found_i18n_all(url_not_found)
        assert_i18n_for_all_locales do
          patch(url_not_found, params: @params, headers: @headers)
          assert_not_found_request
          put(url_not_found, params: @params, headers: @headers)
          assert_not_found_request
        end
      end
    end
  end
end
