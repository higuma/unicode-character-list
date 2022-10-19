require_relative 'sequences'

module Unicode
  module Emoji
    module Keycap
      module_function
      def get_list
        Unicode::Emoji::Sequences.get_cached['Emoji_Keycap_Sequence']
      end
    end
  end
end
