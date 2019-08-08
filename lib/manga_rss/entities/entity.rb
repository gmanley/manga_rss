module MangaRSS
  module Entities
    class Entity < Dry::Struct
      transform_keys(&:to_sym)

      # Error out on extraneous keys passed
      schema(schema.strict)

      # If a nil value is passed, define the value as Dry::Types::Undefined so
      # the configured attribute default will be used.
      transform_types do |type|
        if type.default?
          type.constructor do |value|
            value.nil? ? Dry::Types::Undefined : value
          end
        else
          type
        end
      end

      module Types
        include Dry.Types
      end
    end
  end
end
