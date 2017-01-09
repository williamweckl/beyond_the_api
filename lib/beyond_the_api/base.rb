module BeyondTheApi
  module Base
    def add_fields_and_include_to_render_options(options)
      options[:fields] = params[:fields]&.split(',')&.map(&:to_sym)
      options[:include] = params[:include]&.split(',')&.map(&:to_sym)
      options
    end
  end
end
