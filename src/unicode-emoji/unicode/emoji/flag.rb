require_relative 'sequences'

module Unicode
  module Emoji
    module Flag
      module_function
      def get_list
        Unicode::Emoji::Sequences.get_cached['RGI_Emoji_Flag_Sequence']
      end
    end
  end
end
