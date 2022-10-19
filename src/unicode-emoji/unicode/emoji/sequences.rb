require_relative 'url'

module Unicode
  module Emoji
    module Sequences
      RE_ENTRY = /^([^#].*\S) *; *(.*\S) *; (.*\S) *# *(E\d+\.\d+)/
      RE_ESCAPE = /\\x{(\h+)}/

      @@data_map = Unicode::Data::Map.new
      @@cached = nil

      module_function
      def get_cached
        @@cached = get_and_parse unless @@cached
        @@cached
      end

      def get_data(&block)
        Unicode::Url::get(Unicode::Emoji::Url::SEQUENCES) do |f|
          block.call f
        end
      end

      def parse(f)
        types = {}
        for line in f.each_line
          if line =~ RE_ENTRY
            types[$2] = [] unless types[$2]
            range = $1.split('..')
            if range.size == 2
              for code in range[0].hex .. range[1].hex
                types[$2] << [[code], @@data_map.name(code), $4]
              end
            else
              types[$2] << [$1.split(' ').map{|c| c.hex }, resolve_escape($3), $4]
            end
          end
        end
        types
      end

      def get_and_parse
        get_data do |f|
          parse f
        end
      end

      def resolve_escape(line)
        while line =~ RE_ESCAPE
          line.sub! "\\x{#{$1}}", $1.hex.chr(Encoding::UTF_8)
        end
        line
      end
    end
  end
end
