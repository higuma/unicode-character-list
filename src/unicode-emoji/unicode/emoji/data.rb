require_relative 'url'

module Unicode
  module Emoji
    module Data
      RE_CODE = /(\h{4,6})/
      RE_PROP = /([A-Z_a-z]+)/
      RE_VER = /(E\d+\.\d+)/
      RE_SINGLE = /^#{RE_CODE} *; #{RE_PROP} *# #{RE_VER}/
      RE_RANGE = /^#{RE_CODE}\.\.#{RE_CODE} *; #{RE_PROP} *# #{RE_VER}/

      @@cached = nil

      module_function
      def get_cached
        @@cached = get_and_parse unless @@cached
        @@cached
      end

      def get_data(&block)
        Unicode::Url::get(Unicode::Emoji::Url::DATA) do |f|
          block.call f
        end
      end

      def parse(f)
        props = {}
        for line in f.each_line
          case line
          when RE_SINGLE
            register_entry props, $2, $3, $1.hex
          when RE_RANGE
            register_entry props, $3, $4, $1.hex .. $2.hex
          end
        end
        props
      end

      def get_and_parse
        get_data do |f|
          parse f
        end
      end

      def register_entry(props, prop, ver, code)
        props[prop] = {} unless props[prop]
        props[prop][ver] = [] unless props[prop][ver]
        props[prop][ver] << code unless props[prop][ver].find_index(code)
      end
    end
  end
end

require_relative './data/map'
require_relative './data/info'

__END__

エントリーは単独と範囲の2種類ある。それぞれの例を示す。

```
23F0          ; Emoji                # E0.6   [1] (⏰)       alarm clock
...
23F8..23FA    ; Emoji                # E0.7   [3] (⏸️..⏺️)    pause button..record button
```

この中で固有の情報は先頭のコード(範囲)、プロパティ、バージョンの3つしかない。
後はUnicodeData.txtなど他のデータと照合して取得できる(ここでは取得しない)。

結果は次の形式の2重Hashで出力する。

```
result[property][version] = [code or code-range, ...]
```

ただしこれらの中には多くの重複や予備領域(実際はまだ使われていない)が含まれる。
これらの処理はその先のMap及びInfoで行う。
