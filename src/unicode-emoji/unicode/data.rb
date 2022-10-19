require_relative 'url'

module Unicode
  module Data
    URL = "#{Unicode::Url::UCD}/UnicodeData.txt"

    @@cached = nil

    module_function
    def get_cached
      @@cached = get_and_parse unless @@cached
      @@cached
    end

    def get_data(&block)
      Unicode::Url::get(URL) do |f|
        block.call f
      end
    end

    def parse_data(f)
      data = []
      self.get_data do |f|
        for line in f.each_line
          fields = line.split(';')
          fields[-1] = fields[-1].chomp   # remove ending "\n" first

          # convert to numbers (if possible) or nil
          # [0] Code value (hex)
          fields[0] = fields[0].hex
          # [3] Canonical combining classes (dec)
          fields[3] = fields[3].empty? ? nil : fields[3].to_i
          # [6] Decimal digit value (dec)
          fields[6] = fields[6].empty? ? nil : fields[6].to_i
          # [7] Digit value (dec)
          fields[7] = fields[7].empty? ? nil : fields[7].to_i
          # [12] Uppercase mapping (hex)
          fields[12] = fields[12].empty? ? nil : fields[12].hex
          # [13] Lowercase mapping (hex)
          fields[13] = fields[13].empty? ? nil : fields[13].hex
          # [14] Titlecase mapping (hex)
          fields[14] = fields[14].empty? ? nil : fields[14].hex

          data << fields
        end
      end
      data
    end

    def get_and_parse
      get_data do |f|
        parse_data f
      end
    end

  end
end

require_relative 'data/map'
require_relative 'data/info'

__END__

Unicode Character Databaseのマスターテキストデータを取得する。

https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt

データの中身は次の通り(部分)。
最後の`;`の後にもフィールドが存在することに注意(アルファベット小文字の場合に値を持つ)。

```
0000;<control>;Cc;0;BN;;;;;N;NULL;;;;
...
0041;LATIN CAPITAL LETTER A;Lu;0;L;;;;;N;;;;0061;
...
0061;LATIN SMALL LETTER A;Ll;0;L;;;;;N;;;0041;;0041
...
10FFFD;<Plane 16 Private Use, Last>;Co;0;L;;;;;N;;;;;
```

データ形式の概要は次を参照。

https://www.unicode.org/L2/L1999/UnicodeData.html

正規リファレンス(ただし内容が膨大なのでかいつまんで読むこと)。

http://www.unicode.org/reports/tr44/

## フィールドの切り分け

各行を`;`でsplitし、最終フィールドの改行を除去して登録する。エントリーが空の場合は`""`とする。
中間状態は次の通り(最初と最後のみ)。具体的には先頭の文字名と次のカテゴリを用いる。

```
[
["0000", "<control>", "Cc", "0", "BN", "", "", "", "", "N", "NULL", "", "", "", ""],
["0001", "<control>", "Cc", "0", "BN", "", "", "", "", "N", "START OF HEADING", "", "", "", ""],
["0002", "<control>", "Cc", "0", "BN", "", "", "", "", "N", "START OF TEXT", "", "", "", ""],
...
["10FFFD", "<Plane 16 Private Use, Last>", "Co", "0", "L", "", "", "", "", "N", "", "", "", "", ""]
]
```

(補足) String#splitの細かい動作に注意(こういうのはリファレンスに書かれていない)。

* split後に末尾が空文字列で終わる場合は次のように全部カットされる
* 末尾に空ではない文字列があれば途中の空文字列は全て保存される

```
irb(main):001:0> 'AxBxxx'.split 'x'
=> ["A", "B"]
irb(main):002:0> 'AxBxxxC'.split 'x'
=> ["A", "B", "", "", "C"]
```

このため後半部が空文字列で終わらないように最後の`"\n"`を残したままsplitする。
そして空文字列を全て残した状態で最後に末尾エントリーの`"\n"`を除去して登録する。

* 先にchompした場合 → 末尾の空文字列が全て削られる(失敗)
* chompしない場合 → 末尾に改行があるため空文字列は全て残る

```
"0000;<control>;Cc;0;BN;;;;;N;NULL;;;;\n".chomp.split ';'
=> ["0000", "<control>", "Cc", "0", "BN", "", "", "", "", "N", "NULL"]
irb(main):004:0> "0000;<control>;Cc;0;BN;;;;;N;NULL;;;;\n".split ';'
=> ["0000", "<control>", "Cc", "0", "BN", "", "", "", "", "N", "NULL", "", "", "", "\n"]

## フィールドの追加処理

さらにフィールドの値が数値の場合は次のように処理する。

* hex値の場合は`.hex`で整数に変換、値が空の場合はnilとする
* dec値の場合は`.to_i`で整数に変換、値が空の場合はnilとする

次のフィールドが該当する。

* [0] Code value (hex)
* [3] Canonical combining classes (dec or nil)
* [6] Decimal digit value (dec or nil)
* [7] Digit value (dec or nil)
* [12] Uppercase mapping (hex or nil)
* [13] Lowercase mapping (hex or nil)
* [14] Titlecase mapping (hex or nil)

> [8] Numeric value には分数表現もある(e.g. U2155 `⅕` では"1/5"になる)。そのためあえて数値変換はせず文字列のままとしている。

### 各フィールドのリファレンス

Field #2: General Category Values

http://www.unicode.org/reports/tr44/#General_Category_Values

Field #3: Canonical combining class

http://www.unicode.org/reports/tr44/#Canonical_Combining_Class_Values

Field #4: Bidirectional Class Values

http://www.unicode.org/reports/tr44/#Bidi_Class_Values

Field #5: Character Decomposition Mapping

http://www.unicode.org/reports/tr44/#Character_Decomposition_Mappings

### 参考サイト

次がよくまとまっている。

https://www.compart.com/en/unicode
