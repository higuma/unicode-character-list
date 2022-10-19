require_relative '../../data/info'
require_relative 'map'

module Unicode
  module Emoji
    module Data
      class Info < Unicode::Data::Info
        @@emoji_data_map = Unicode::Emoji::Data::Map.new

        def initialize(code)
          super code
        end

        def properties
          @@emoji_data_map.properties @code
        end

        def has_property(prop)
          @@emoji_data_map.has_property prop
        end

        def version
          @@emoji_data_map.version
        end
      end

      class Map
        def info(code)
          Unicode::Emoji::Data::Info.new code
        end
      end
    end
  end
end
