require_relative 'url'

module Unicode
  module Emoji
    module ZwjSequences

      RE_GROUP = /^# RGI_Emoji_ZWJ_Sequence: (.+)$/
      RE_ENTRY = /^([^#].*\S) *; *RGI_Emoji_ZWJ_Sequence *; *(.*\S) *# *(E\d+\.\d+)/
      RE_ESCAPE = /\\x{(\h+)}/

      @@data_map = Unicode::Data::Map.new
      @@cached = nil

      module_function
      def get_cached
        @@cached = get_and_parse unless @@cached
        @@cached
      end

      def get_data(&block)
        Unicode::Url::get(Unicode::Emoji::Url::ZWJ_SEQUENCES) do |f|
          block.call f
        end
      end

      def parse(f)
        groups = {}
        group = ''
        for line in f.each_line
          case line
          when RE_GROUP
            group = $1
            groups[group] = [] unless groups[group]
          when RE_ENTRY
            groups[group] << [$1.split(' ').map{|c| c.hex }, resolve_escape($2), $3]
          end
        end
        groups
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
