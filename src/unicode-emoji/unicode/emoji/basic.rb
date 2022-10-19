require_relative 'sequences'

module Unicode
  module Emoji
    module Basic
      @@cached = nil

      module_function
      def get_list
        @@cached = initialize_list unless @@cached
        @@cached
      end

      def initialize_list
        Unicode::Emoji::Sequences.get_cached['Basic_Emoji'].sort {|a, b| a[0] <=> b[0] }
      end
    end
  end
end
