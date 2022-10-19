require 'open-uri'

module Unicode
  module Url
    # See: https://www.unicode.org/reports/tr44/

    PUBLIC = 'https://www.unicode.org/Public'
    UCD = "#{PUBLIC}/UCD/latest/ucd"

    module_function
    def get(url)
      URI.open url do |f|
        yield f
      end
    end
  end
end
