module BeyondTheApiTestHelpers
  module Request
    module Helpers

      def api_url
        '/'
      end

      def json
        @json = JSON.parse(response.body)
      end

      def logged_in_headers
        {
          client: 'client_id_test',
          'access-token': 'token_test',
          uid: user_authorizations(:logged).uid,
          'HTTP_USER_AGENT': 'Rails Testing'
        }
      end

      def not_logged_in_headers
        { 'HTTP_USER_AGENT': 'Rails Testing' }
      end

      def response_assertions(options)
        assert_equal response.content_type, Mime[:json]
        assert_meta_now
        assert_meta_version
        assert_response options[:status]
      end

      # rubocop:disable Rails/Date
      def assert_meta_now
        assert_kind_of Time, json['meta']['now'].to_time
      end
      # rubocop:enable Rails/Date

      def assert_meta_version
        assert_equal json['meta']['version'], api_version
      end

    end
  end
end
