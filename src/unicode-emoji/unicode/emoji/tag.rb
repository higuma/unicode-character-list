require_relative 'sequences'

module Unicode
  module Emoji
    module Tag
      # See: https://unicode.org/reports/tr51/#flag-emoji-tag-sequences

      module_function
      def get_list
        Unicode::Emoji::Sequences.get_cached['RGI_Emoji_Tag_Sequence']
      end
    end
  end
end
