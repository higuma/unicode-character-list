require_relative '../data'

module Unicode
  module Emoji
    module Data
      class Map
        @@code_map = Unicode::Data::Map.new
        @@map = nil

        def initialize
          self.initialize_map unless @@map
        end

        def exist?(code)
          @@map.has_key? code
        end

        def properties(code)
          entry = @@map[code]
          entry ? entry[0] : nil
        end

        def has_property(prop)
          props = self.properties code
          props ? props.find_index(prop) != nil : false
        end

        def version(code)
          entry = @@map[code]
          entry ? entry[1] : nil
        end

        def name(code)
          @@code_map.name code
        end

        # acquisition methods
        def codes
          @@map.keys
        end

        def select_by_property(*props)
          codes = self.codes
          for prop in props
            codes.select! {|code| @@map[code][0].find_index prop }
          end
          codes
        end

        # private
        def initialize_map
          @@map = {}
          for prop, vers in Unicode::Emoji::Data::get_and_parse
            for ver, codes in vers
              for code in codes
                if code.is_a? Range
                  for c in code
                    self.register_map c, prop, ver
                  end
                else
                  self.register_map code, prop, ver
                end
              end
            end
          end
        end

        def register_map(code, prop, ver)
          return unless @@code_map.is_char? code
          unless @@map[code]
            @@map[code] = [[prop], ver]
          else
            unless @@map[code][0].find_index prop
              @@map[code][0].push prop
            end
            if @@map[code][1] != ver
              raise RuntimeError.new "Unicode::Emoji::Data::Map::initialize: version unmatched: [U+#{sprintf "%04X", code}] #{@@map[code][1]} != #{ver}"
            end
          end
        end
      end
    end
  end
end
