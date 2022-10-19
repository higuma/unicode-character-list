require_relative 'sequences'

module Unicode
  module Emoji
    module Modifier
      module_function
      def get_list
        Unicode::Emoji::Sequences.get_cached['RGI_Emoji_Modifier_Sequence']
      end
    end
  end
end
