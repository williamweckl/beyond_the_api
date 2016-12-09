module BeyondTheApi
  module RenderHelpers
    extend ActiveSupport::Concern

    included do
      include ::BeyondTheApi::IndexRenderHelpers
      include ::BeyondTheApi::ShowRenderHelpers
      before_action :set_meta
    end

    def render_json_message_with_serializer(object, options = {})
      hash = serialized_object_with_root(object, options[:serializer_root])
      hash.merge!(options[:message])
      hash[:meta] = @meta
      render json: hash, status: (options[:status] || :ok)
    end

    def render_json_message(hash, status, optionals = {})
      hash = hash.merge(meta: @meta)
      hash = hash.merge(optionals)
      render json: hash, status: status
    end

    def render_json_errors(object)
      errors = object.errors
      render json: { errors: errors.messages,
                     full_error_messages: errors.full_messages, meta: @meta }, status: 422
    end

    private

    def set_meta
      @meta ||= {}
      @meta[:version] = params[:controller].split('/').first
      @meta[:now] = Time.current
    end

    def serialized_object_with_root(object, root)
      options = {}
      options[:current_user] = current_user if respond_to?(:current_user)

      root ||= object.class.to_s.underscore
      { root => object.serialize_to_json(options) }
    end
  end
end
