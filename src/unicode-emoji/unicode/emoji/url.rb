require_relative '../url'

module Unicode
  module Emoji
    module Url
      # See: https://unicode.org/reports/tr51/#emoji_data

      EMOJI = "#{Unicode::Url::PUBLIC}/emoji/latest"
      UCD_EMOJI = "#{Unicode::Url::UCD}/emoji"

      DATA = "#{UCD_EMOJI}/emoji-data.txt"
      VARIATION_SEQUENCES = "#{UCD_EMOJI}/emoji-variation-sequences.txt"
      SEQUENCES = "#{EMOJI}/emoji-sequences.txt"
      ZWJ_SEQUENCES = "#{EMOJI}/emoji-zwj-sequences.txt"
      TEST = "#{EMOJI}/emoji-test.txt"
    end
  end
end
