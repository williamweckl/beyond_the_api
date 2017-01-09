module BeyondTheApi
  module ShowRenderHelpers
    def render_json_serializer(object, options = {})
      render_params = { json: object, current_user: current_user, meta: @meta,
                        status: (options[:status] || :ok) }
      add_fields_and_include_to_render_options(render_params)

      render render_params.merge(render_json_serializer_aditional_params(options))
    end

    def render_json_serializer_aditional_params(options)
      render_params = {}
      render_params[:root] = options[:root].presence
      render_params[:serializer] = options[:serializer].presence
      render_params.delete_if { |_key, value| !value }
    end

    def render_json_object(object, name)
      render json: {
        name => object,
        meta: @meta
      }
    end
  end
end
