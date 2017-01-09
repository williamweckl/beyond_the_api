require 'active_model_serializers'
require 'will_paginate'
require 'versionist'
require 'beyond_the_api/base'
require 'beyond_the_api/render_helpers'
require 'beyond_the_api/index_render_helpers'
require 'beyond_the_api/show_render_helpers'

ActiveRecord::Base.class_eval do
  def serialize_to_json(serializer_options = {})
    serialization = ActiveModelSerializers::SerializableResource.new(self,
                                                                     serializer_options)
    JSON.parse(serialization.to_json).values[0]
  end
end
