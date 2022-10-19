require_relative '../data'

module Unicode
  module Data
    class Map
      RE_BLOCK_NAME_FIRST = /^<(.+), First>$/
      RE_BLOCK_NAME_LAST = /^<(.+), Last>$/

      Range = Struct.new :range, :fields

      @@chars = nil
      @@ranges = nil
      @@codes = nil

      def initialize
        self.initialize_chars unless @@chars && @@ranges && @@codes
      end

      def each_range
        return self.to_enum(:each_range) unless block_given?
        for range in @@codes
          yield range.range, range.fields
        end
      end

      def each_code
        return self.to_enum(:each_code) unless block_given?
        for range in @@codes
          for code in range.range
            yield code, range.fields
          end
        end
      end

      def exist?(code)
        for range in @@ranges
          return true if range.range.cover? code
        end
        @@chars.has_key? code
      end

      def is_char?(code)
        case self.category code
        when nil
          nil
        when 'Cn','Co','Cs'
          false
        else
          true
        end
      end

      def fields(code)
        for range in @@ranges
          return range.fields if range.range.cover? code
        end
        @@chars[code]
      end

      def name(code)
        fields = self.fields code
        fields ? fields[1] : nil
      end

      def category(code)
        fields = self.fields code
        fields ? fields[2] : nil
      end

      def canonical_combining_class(code)
        fields = self.fields code
        fields ? fields[3] : nil
      end

      def bidi_class(code)
        fields = self.fields code
        fields ? fields[4] : nil
      end

      def decomposition_mapping(code)
        fields = self.fields code
        fields ? fields[5] : nil
      end

      def decimal_digit_value(code)
        fields = self.fields code
        fields ? fields[6] : nil
      end

      def digit_value(code)
        fields = self.fields code
        fields ? fields[7] : nil
      end

      def numeric_value(code)
        fields = self.fields code
        fields ? fields[8] : nil
      end

      def mirrored(code)
        fields = self.fields code
        fields ? fields[9] : nil
      end

      def unicode_1_name(code)
        fields = self.fields code
        fields ? fields[10] : nil
      end

      def iso_comment(code)
        fields = self.fields code
        fields ? fields[11] : nil
      end

      def uppercase_mapping(code)
        fields = self.fields code
        fields ? fields[12] : nil
      end

      def lowercase_mapping(code)
        fields = self.fields code
        fields ? fields[13] : nil
      end

      def titlecase_mapping(code)
        fields = self.fields code
        fields ? fields[14] : nil
      end

      # private
      def initialize_chars
        @@chars = {}
        @@ranges = []
        @@codes = []
        first = nil
        block_name = nil
        for fields in Unicode::Data::get_cached
          case fields[1]
          when RE_BLOCK_NAME_FIRST
            first = fields[0]
            block_name = $1
          when RE_BLOCK_NAME_LAST
            if $1 != block_name
              raise RuntimeError.new "Unicode::Data::Map::initialize: block name unmatched: [U+#{sprintf "%04X", first}] <#{block_name}, First> <=> [U+#{sprintf "%04X", fields[0]}] <#{$1}, Last>"
            end
            fields[1] = "<#{block_name}>"
            range = Range.new(first..fields[0], fields)
            @@ranges << range
            @@codes << range
          else
            @@chars[fields[0]] = fields
            @@codes << Range.new(fields[0]..fields[0], fields)
          end
        end
      end
    end
  end
end

__END__

エントリには2種類ある。

* 単独の場合
* 範囲の場合

単独の場合の例を示す。

```
03A1: ["GREEK CAPITAL LETTER RHO", "Lu", "0", "L", "", "", "", "", "N", "", "", "", "03C1"]
03A3: ["GREEK CAPITAL LETTER SIGMA", "Lu", "0", "L", "", "", "", "", "N", "", "", "", "03C3"]
```

これらはカテゴリ(`Lu`は「アルファベット大文字」の意味)を見れば文字種を判定できる。また中間の`03A2`には文字が割り当てれらていない(実はこういう場所はたくさんある)。

次に範囲の場合の例を示す。次のように必ず2行組で記述される。

```
3400: ["<CJK Ideograph Extension A, First>", "Lo", "0", "L", "", "", "", "", "N", "", "", "", ""]
4DBF: ["<CJK Ideograph Extension A, Last>", "Lo", "0", "L", "", "", "", "", "N", "", "", "", ""]
```

* 1行目は名前が`<{BLOCK NAME} First>`
* 2行目は名前が`<{BLOCK NAME} Last>`

これらは範囲の認識が必要で、中間のコード領域にも全て同じ設定が割り当てられている。

> なおこれらは全部で18組しかないので、最初に領域を全て抽出して別扱いにする。

次にコードが実際に文字として用いられているかどうかの判定基準(`is_char?`)。

* 単独でも範囲中でもない → 文字が割り当てられていない
* 上記以外 → カテゴリで判定する

カテゴリは次の通り。[参照サイト](http://www.sput.nl/unicode/unicodedata.html)の方がよくまとまっているのでそこから借用する。

* `L` Letter
    * `Ll` Lower case
    * `Lm` Modifier
    * `Lo` Other
    * `Lt` Title
    * `Lu` Upper case
* `M` Mark
    * `Mc` Spacing combining
    * `Me` Enclosing
    * `Mn` Nonspacing
* `N` Number
    * `Nd` Decimal
    * `Nl` Letter
    * `No` Other
* `P` Punctuation
    * `Pc` Connector
    * `Pd` Dash
    * `Pe` Close
    * `Pf` Final quote
    * `Pi` Initial quote
    * `Po` Other
    * `Ps` Open
* `S` Symbol
    * `Sc` Currency
    * `Sk` Modifier
    * `Sm` Math
    * `So` Other
* `Z` Separator
    * `Zl` Line
    * `Zp` Paragraph
    * `Zs` Space
* `C` Other
    * `Cc` Control
    * `Cf` Format
    * `Cn` Not assigned
    * `Co` Private
    * `Cs` Surrogate

使われていない領域は`Cn`,`Co`,`Cs`のいずれかになるので、それで検出すればよい。
とりあえず次の仕様としておく(暫定だがこれで十分だろう)。

* 未登録(単独あるいは範囲指定に含まれていない) → nil (falsy)
* `Cn`,`Co`,`Cs` → false
* それ以外 → true

> Wikipediaの一覧の「凡例」も参照。なおサロゲート(`Cs`)は表から除外され、欄外に説明がある。
> 
> https://ja.wikipedia.org/wiki/Unicode一覧_0000-0FFF
> 
> * 私用領域(`Co`) - 背景色が「白」
> * 未使用(`Cn`) - 背景色が「灰色」
> * 不使用(登録なし) - 背景色が「黒」
