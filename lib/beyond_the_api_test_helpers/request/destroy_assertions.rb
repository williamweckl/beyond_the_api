module BeyondTheApiTestHelpers
  module Request
    module DestroyAssertions
      def assert_request_destroy_valid(url, options = {})
        request_instance_variables_set options
        if required_login
          assert_request_needs_to_be_logged(url, :delete)
          @headers.merge!(logged_in_headers)
        end

        assert_i18n_for_all_locales do
          do_destroy_request_with_transaction(url)
        end
      end

      def assert_request_destroy_not_found(urls_not_found, options = {})
        request_instance_variables_set options
        @headers.merge!(logged_in_headers) if required_login

        urls_not_found.each do |url_not_found|
          assert_request_destroy_not_found_i18n_all(url_not_found)
        end
      end

      private

      def do_destroy_request_with_transaction(url)
        ActiveRecord::Base.transaction do
          do_destroy_request_and_assert(url)
          Redis.current.flushdb if @flush_redis_db_between_i18n_tests
          raise ActiveRecord::Rollback
        end
      end

      # :reek:DuplicateMethodCall: { max_calls: 2 }
      def do_destroy_request_and_assert(url)
        subject_id = subject.id unless @skip_destroyed_validate
        delete(url, params: @params, headers: @headers)
        response_assertions(status: 200)
        assert_destroyed(subject_id) unless @skip_destroyed_validate
        assert_equal I18n.t(*@message), json['success']
      end

      def assert_destroyed(subject_id)
        if subject.respond_to? :deleted_at
          assert_not_nil subject.reload.deleted_at
        elsif subject.respond_to? :active
          assert_active_destroyed
        else
          klass = @klass || subject.class
          assert_equal false, klass.exists?(subject_id)
        end
      end

      def assert_active_destroyed
        assert_equal false, subject.reload.active?
      end

      def assert_request_destroy_not_found_i18n_all(url_not_found)
        assert_i18n_for_all_locales do
          delete(url_not_found, params: @params, headers: @headers)
          assert_not_found_request
        end
      end
    end
  end
end
