require 'fileutils'
require_relative 'unicode-emoji/unicode'

def each_code
  return self.to_enum(:each_code) unless block_given?
  for range in Unicode::Data::Map::new.each_range
    # skip Cs(surrogate), Co(private), Cn(not assigned)
    case Unicode::Data::Info.new(range.first).category
    when 'Cs','Co','Cn'
      next
    else
      for code in range
        yield code
      end
    end
  end
end

PLANE_SKIPPED = [0x0E, 0x15, 0x19]

def output_header(f, plane)
  plane = plane.first / 0x1000
  f.puts '| [README](README.md) |\\'
  for p in 0..0x32
    hex = sprintf '%02X', p
    if p == plane || PLANE_SKIPPED.index(p)
      f.print "| #{hex}\\*\\*\\* "
    else
      f.print "| [#{hex}\\*\\*\\*](#{hex}xxx.md) "
    end
    f.puts '|\\' if p % 16 == 15
  end
  f.puts '|\\'
  # E0***
  if plane == 0xE0
    f.puts '| E0\\*\\*\\* |'
  else
    f.puts '| [E0\\*\\*\\*](E0xxx.md) |'
  end
end

def resolve_name(info)
  if info.category == 'Cc' && info.unicode_1_name != ''
    info.unicode_1_name
  else
    info.name
  end
end

CONTROL_NAME = Proc.new {
  x00_1F = %w(NUL SOH STX ETX EOT ENQ ACK BEL BS HT LF VT FF CR SO SI DLE DC1 DC2 DC3 DC4 NAK SYN ETB CAN EM SUB ESC FS GS RS US)
  x7F_9F = %w(DEL PAD HOP BPH NBH IND NEL SSA ESA HTS HTJ VTS PLD PLU RI SS2 SS3 DCS PU1 PU2 STS CCH MW SPA EPA SOS SGCI SCI CSI ST OSC PM APC)
  name_map = {}
  for c in 0x00..0x1f
    name_map[c] = x00_1F[c]
  end
  for c in 0x7F..0x9F
    name_map[c] = x7F_9F[c - 0x7F]
  end
  name_map
}.call

def format_char(info)
  if info.category == 'Cc'
    "<kbd>#{CONTROL_NAME[info.code]}</kbd>"
  else
    case info.chr
    when ' '
      "` `<br> <br>"
    when '\\'
      "`\\`<br>\\\\"
    when '`'
      "`` ` ``<br>\`"
    when '|'
      "`\\|`<br>\\|"
    else
      "`#{info.chr}`<br>#{info.chr}"
    end
  end
end

def output_line(f, base, items)
  return if items.empty?
  f.print "| #{sprintf "%03X\\*", base / 16} |"
  for i in 0..15
    code = base + i
    hex = sprintf "%04X", code
    chr = code.chr Encoding::UTF_8
    info = Unicode::Data::Info.new code
    if items[code]
      f.print " <span id=\"#{hex}\" title=\"U+#{hex} #{resolve_name(info)}, #{info.category}\">#{
        format_char info
      }</span> |"
    else
      f.print " <span id=\"#{hex}\" title=\"U+#{hex} (not assigned)\">-</span> |"
    end
  end
  f.puts
end

def output_plane(dir, plane, chars)
  open "#{dir}/#{sprintf "%02X", plane.first / 4096}xxx.md", 'w' do |f|
    f.printf "# Unicode characters: U+%04X..U+%04X\n", plane.first, plane.last
    f.puts
    output_header f, plane
    f.puts
    f.puts '| U+ |' + (0..0x0F).map {|c| sprintf " %X |", c }.join('')
    f.puts '| - |' + ' :-: |' * 16
    base = 0
    items = {}
    for code in chars
      if code >= base + 16
        output_line f, base, items
        base = code & 0xFFFFF0
        items = {}
      end
      items[code] = true
    end
    output_line f, base, items
  end
end

def output_all(dir)
  FileUtils.makedirs dir
  plane = 0..0xFFF
  chars = []
  for code in each_code
    if plane.include? code
      chars << code
    else
      output_plane dir, plane, chars
      base = code & 0x1FF000
      plane = base .. base + 0xFFF
      chars = [code]
    end
  end
  output_plane dir, plane, chars
end

# main
output_all '..'

