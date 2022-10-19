# Unicode character list (for Markdown)

## Summary

The folowing tables are the Unicode character list for all Unicode code point planes.

## Tables

| [00\*\*\*](00xxx.md) | [01\*\*\*](01xxx.md) | [02\*\*\*](02xxx.md) | [03\*\*\*](03xxx.md) | [04\*\*\*](04xxx.md) | [05\*\*\*](05xxx.md) | [06\*\*\*](06xxx.md) | [07\*\*\*](07xxx.md) | [08\*\*\*](08xxx.md) | [09\*\*\*](09xxx.md) | [0A\*\*\*](0Axxx.md) | [0B\*\*\*](0Bxxx.md) | [0C\*\*\*](0Cxxx.md) | [0D\*\*\*](0Dxxx.md) | 0E\*\*\* | [0F\*\*\*](0Fxxx.md) |\
| [10\*\*\*](10xxx.md) | [11\*\*\*](11xxx.md) | [12\*\*\*](12xxx.md) | [13\*\*\*](13xxx.md) | [14\*\*\*](14xxx.md) | 15\*\*\* | [16\*\*\*](16xxx.md) | [17\*\*\*](17xxx.md) | [18\*\*\*](18xxx.md) | 19\*\*\* | [1A\*\*\*](1Axxx.md) | [1B\*\*\*](1Bxxx.md) | [1C\*\*\*](1Cxxx.md) | [1D\*\*\*](1Dxxx.md) | [1E\*\*\*](1Exxx.md) | [1F\*\*\*](1Fxxx.md) |\
| [20\*\*\*](20xxx.md) | [21\*\*\*](21xxx.md) | [22\*\*\*](22xxx.md) | [23\*\*\*](23xxx.md) | [24\*\*\*](24xxx.md) | [25\*\*\*](25xxx.md) | [26\*\*\*](26xxx.md) | [27\*\*\*](27xxx.md) | [28\*\*\*](28xxx.md) | [29\*\*\*](29xxx.md) | [2A\*\*\*](2Axxx.md) | [2B\*\*\*](2Bxxx.md) | [2C\*\*\*](2Cxxx.md) | [2D\*\*\*](2Dxxx.md) | [2E\*\*\*](2Exxx.md) | [2F\*\*\*](2Fxxx.md) |\
| [30\*\*\*](30xxx.md) | [31\*\*\*](31xxx.md) | [32\*\*\*](32xxx.md) |\
| [E0\*\*\*](E0xxx.md) |

Each table popups a character code, name, and general category on hovering a mouse cursor on a character.

→ General Category Values: https://www.unicode.org/reports/tr44/#General_Category_Values

## Generating tables

Tables are generated with Ruby. The following command accesses [the Unicode Character Database](https://unicode.org/ucd/) and update the whole tables to the newest contents.

```
$ cd src
$ ruby generate-tables.rb
```

## References

Unicode Character Database: https://unicode.org/ucd/

Unicode® Standard Annex #44: https://unicode.org/reports/tr44/

UnicodeData.txt: https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt
