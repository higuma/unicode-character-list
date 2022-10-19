require_relative 'map'

module Unicode
  module Data
    class Info
      @@map = Unicode::Data::Map.new

      def initialize(code)
        @code = code
      end

      def chr
        @code.chr Encoding::UTF_8
      end

      def code
        @code
      end

      def name
        @@map.name @code
      end

      def category
        @@map.category @code
      end

      def canonical_combining_class
        @@map.canonical_combining_class @code
      end

      def bidi_class
        @@map.bidi_class @code
      end

      def decomposition_mapping
        @@map.decomposition_mapping @code
      end

      def decimal_digit_value
        @@map.decimal_digit_value @code
      end

      def digit_value
        @@map.digit_value @code
      end

      def numeric_value
        @@map.numeric_value @code
      end

      def mirrored
        @@map.mirrored @code
      end

      def unicode_1_name
        @@map.unicode_1_name @code
      end

      def iso_comment
        @@map.iso_comment @code
      end

      def uppercase_mapping
        @@map.uppercase_mapping @code
      end

      def lowercase_mapping
        @@map.lowercase_mapping @code
      end

      def titlecase_mapping
        @@map.titlecase_mapping @code
      end
    end

    class Map
      def info(code)
        Unicode::Data::Info.new code
      end
    end
  end
end
