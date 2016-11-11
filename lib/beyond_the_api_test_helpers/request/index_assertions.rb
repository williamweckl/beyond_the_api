module BeyondTheApiTestHelpers
  module Request
    module IndexAssertions
      def assert_request_index_valid(url, options = {})
        request_instance_variables_set_pluralize options

        if required_login
          assert_request_needs_to_be_logged(url, :get)
          @headers.merge!(logged_in_headers)
        end

        get(url, params: @params, headers: @headers)
        response_assertions(status: 200)
        assert_kind_of Array, json_response_name
        assert_request_index_should_include if @should_include || @should_not_include
      end

      def assert_request_index_total_count(url, options = {})
        request_instance_variables_set_pluralize options
        @headers.merge!(logged_in_headers) if required_login
        get(url, params: @params.merge(total_count: true), headers: @headers)
        assert_kind_of Integer, meta['total_count']
      end

      def assert_request_index_paginated(url, params = {})
        request_instance_variables_set_pluralize params
        @headers.merge!(logged_in_headers) if required_login

        get(url, params: @params.merge(page: 1, per_page: 1, total_pages: true), headers: @headers)
        assert_equal 1, json_response_name.size
        assert_kind_of Integer, meta['total_pages']
      end

      def assert_request_index_with_filters(url, filters, params = {})
        request_instance_variables_set_pluralize params
        @headers.merge!(logged_in_headers) if required_login

        filters.each do |key, options|
          assert_request_index_filter(url, key, options)
        end
      end

      def assert_request_index_not_found(urls_not_found, options = {})
        request_instance_variables_set options
        @headers.merge!(logged_in_headers) if required_login

        urls_not_found.each do |url_not_found|
          assert_request_index_not_found_i18n_all(url_not_found)
        end
      end

      private

      def assert_request_index_should_include
        @should_include&.each do |object|
          assert_request_includes_should_include(object)
        end
        @should_not_include&.each do |object|
          assert_request_not_includes_should_not_include(object)
        end
      end

      def assert_request_includes_should_include(object)
        serialized = object.serialize_to_json(current_user: users(:logged))
        assert_includes json_response_name, serialized
      end

      def assert_request_not_includes_should_not_include(object)
        serialized = object.serialize_to_json(current_user: users(:logged))
        assert_not_includes json_response_name, serialized
      end

      def assert_request_index_filter(url, key, options)
        options.each do |option|
          get(url, params: { key => option[:value] }, headers: @headers)
          assert_request_include_filter(option[:include])
          assert_request_exclude_filter(option[:exclude])
        end
      end

      def assert_request_include_filter(objects)
        objects.each do |object|
          serialized = object.serialize_to_json(current_user: users(:logged))
          assert_includes json_response_name, serialized
        end
      end

      def assert_request_exclude_filter(objects)
        objects.each do |object|
          serialized = object.serialize_to_json(current_user: users(:logged))
          assert_not_includes json_response_name, serialized
        end
      end

      def assert_request_index_not_found_i18n_all(url_not_found)
        assert_i18n_for_all_locales do
          get(url_not_found, params: @params, headers: @headers)
          assert_not_found_request
        end
      end
    end
  end
end
