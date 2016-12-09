require 'will_paginate/array'
module BeyondTheApi
  module IndexRenderHelpers
    API_DEFAULT_PAGE_SIZE = 10

    protected

    ## Index ##

    def render_json_list(list, options = {})
      @list = list
      @list = paginate(options[:default_page_size] || API_DEFAULT_PAGE_SIZE)
      @meta[:total_pages] = (options[:total_pages] || @list.total_pages) if total_pages?
      @meta[:total_count] ||= (options[:total_count] || @list.count) if total_count?

      render index_params_to_render(options)
    end

    def index_params_to_render(options)
      params_to_render = { json: @list, meta: @meta, current_user: current_user }
      serializer = options[:serializer]
      params_to_render[:each_serializer] = serializer if serializer
      params_to_render
    end

    def render_json_list_enum(list, name, options = {})
      @list = list
      @list = paginate_array(options[:default_page_size] || API_DEFAULT_PAGE_SIZE)
      @meta[:total_count] = @list.count if total_count?
      @meta[:total_pages] = @list.total_pages if total_pages?
      render json: {
        name => @list,
        meta: @meta
      }
    end

    def paginate(default)
      return @list unless paginate?(default)
      @list.page(page).per_page(params[:per_page] || default)
    end

    def paginate_array(default)
      return @list unless paginate?(default)
      @list.paginate(page: page, per_page: params[:per_page] || default)
    end

    def apply_filters(list, *scopes)
      scopes.each do |scope|
        param_name = scope.to_s.sub('by_', '')
        param = params[param_name]
        list = list.send(scope, param) if param.present? && list.respond_to?(scope)
      end
      list
    end

    def enum_list_to_array_hashes(list)
      array = []
      list.each do |name, id|
        array << {
          id: id,
          name: name
        }
      end
      array
    end

    private

    def total_pages?
      @list.respond_to?(:total_pages) && params[:total_pages].to_s == 'true'
    end

    def total_count?
      params[:total_count].to_s == 'true'
    end

    def page
      params[:page] || 1
    end

    def paginate?(default)
      params[:per_page] || !default == :unlimited
    end
  end
end
