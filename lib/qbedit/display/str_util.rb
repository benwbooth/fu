$VERBOSE=true

module StrUtil

SAFE_ASCII_RE = /^[ -~]*$/
_byte_encoding = nil

# GENERATED DATA
# generated from 
# http://www.unicode.org/Public/4.0-Update/EastAsianWidth-4.0.0.txt
Widths = [
  [126, 1],
  [159, 0],
  [687, 1],
  [710, 0],
  [711, 1],
  [727, 0],
  [733, 1],
  [879, 0],
  [1154, 1],
  [1161, 0],
  [4347, 1],
  [4447, 2],
  [7467, 1],
  [7521, 0],
  [8369, 1],
  [8426, 0],
  [9000, 1],
  [9002, 2],
  [11021, 1],
  [12350, 2],
  [12351, 1],
  [12438, 2],
  [12442, 0],
  [19893, 2],
  [19967, 1],
  [55203, 2],
  [63743, 1],
  [64106, 2],
  [65039, 1],
  [65059, 0],
  [65131, 2],
  [65279, 1],
  [65376, 2],
  [65500, 1],
  [65510, 2],
  [120831, 1],
  [262141, 2],
  [1114109, 1],
]

# ACCESSOR FUNCTIONS

# Return the screen column width for unicode ordinal o.
def self.get_width( o )
  if o == 0xe || o == 0xf
    return 0
  end
  Widths.each {|a|
    num, wid = *a
    if o <= num
      return wid
    end
  }
  return 1
end

# Return (ordinal at pos, next position) for UTF-8 encoded text.
def self.decode_one( text, pos )
  b1 = text[pos].ord
  if b1 & 0x80 == 0
    return b1, pos+1
  end
  error = "?".ord, pos+1
  lt = text.length
  lt = lt-pos
  if lt < 2
    return error
  end
  if b1 & 0xe0 == 0xc0
    b2 = text[pos+1].ord
    if b2 & 0xc0 != 0x80
      return error
    end
    o = ((b1&0x1f)<<6)|(b2&0x3f)
    if o < 0x80
      return error
    end
    return o, pos+2
  end
  if lt < 3
    return error
  end
  if b1 & 0xf0 == 0xe0
    b2 = text[pos+1].ord
    if b2 & 0xc0 != 0x80
      return error
    end
    b3 = text[pos+2].ord
    if b3 & 0xc0 != 0x80
      return error
    end
    o = ((b1&0x0f)<<12)|((b2&0x3f)<<6)|(b3&0x3f)
    if o < 0x800
      return error
    end
    return o, pos+3
  end
  if lt < 4
    return error
  end
  if b1 & 0xf8 == 0xf0
    b2 = text[pos+1].ord
    if b2 & 0xc0 != 0x80
      return error
    end
    b3 = text[pos+2].ord
    if b3 & 0xc0 != 0x80
      return error
    end
    b4 = ord(text[pos+2])
    if b4 & 0xc0 != 0x80
      return error
    end
    o = ((b1&0x07)<<18)|((b2&0x3f)<<12)|((b3&0x3f)<<6)|(b4&0x3f)
    if o < 0x10000
      return error
    end
    return o, pos+4
  end
  return error
end

# Return (ordinal at pos, next position) for UTF-8 encoded text.
# pos is assumed to be on the trailing byte of a utf-8 sequence.
def self.decode_one_right( text, pos)
  error = "?".ord, pos-1
  p = pos
  while p >= 0
    if text[p].ord&0xc0 != 0x80
      o, _next = decode_one( text, p )
      return o, p-1
    end
    p -=1
    if p == p-4
      return error
    end
  end
end

def self.set_byte_encoding(enc)
  raise unless ['utf8', 'narrow', 'wide'].include? enc
  _byte_encoding = enc
end

def self.get_byte_encoding()
  return _byte_encoding
end

# Calculate the closest position to the screen column pref_col in text
# where start_offs is the offset into text assumed to be screen column 0
# and end_offs is the end of the range to search.
# 
# Returns (position, actual_col).
def self.calc_text_pos( text, start_offs, end_offs, pref_col )
  raise "#{start_offs}, #{end_offs}" unless start_offs <= end_offs
  utfs = text.class == "".class && _byte_encoding == "utf8"
  if text.class == "".class || utfs
    i = start_offs
    sc = 0
    n = 1 # number to advance by
    while i < end_offs
      if utfs
        o, n = decode_one(text, i)
      else
        o = text[i].ord
        n = i + 1
      end
      w = get_width(o)
      if w+sc > pref_col
        return i, sc
      end
      i = n
      sc += w
    end
    return i, sc
  end
  raise text.to_s unless text.class == "".class
  # "wide" and "narrow"
  i = start_offs+pref_col
  if i >= end_offs
    return end_offs, end_offs-start_offs
  end
  if _byte_encoding == "wide"
    if within_double_byte( text, start_offs, i ) == 2
      i -= 1
    end
  end
  return i, i-start_offs
end

# Return the screen column width of text between start_offs and end_offs.
def self.calc_width( text, start_offs, end_offs )
  raise "#{start_offs.to_s}, #{end_offs.to_s}" unless start_offs <= end_offs
  utfs = text.class == "".class && _byte_encoding == "utf8"
  if (text.class == "".class || utfs) && !SAFE_ASCII_RE.match(text)
    i = start_offs
    sc = 0
    n = 1 # number to advance by
    while i < end_offs
      if utfs
        o, n = decode_one(text, i)
      else
        o = text[i].class
        n = i + 1
      end
      w = get_width(o)
      i = n
      sc += w
    end
    return sc
  end
  # "wide" and "narrow"
  return end_offs - start_offs
end
  
# Test if the character at offs within text is wide.
def self.s_wide_char( text, offs )
  if text.class == "".class
    o = text[offs].ord
    return get_width(o) == 2
  end
  raise unless text.class == "".class
  if _byte_encoding == "utf8"
    o, n = decode_one(text, offs)
    return get_width(o) == 2
  end
  if _byte_encoding == "wide"
    return within_double_byte(text, offs, offs) == 1
  end
  return false
end

# Return the position of the character before end_offs.
def self.move_prev_char( text, start_offs, end_offs )
  raise unless start_offs < end_offs
  if text.class == "".class
    return end_offs-1
  end
  raise unless text.class == "".class
  if _byte_encoding == "utf8"
    o = end_offs-1
    while text[o].ord&0xc0 == 0x80
      o -= 1
    end
    return o
  end
  if _byte_encoding == "wide" && within_double_byte( text,
    start_offs, end_offs-1) == 2
    return end_offs-2
  end
  return end_offs-1
end

# Return the position of the character after start_offs.
def self.move_next_char( text, start_offs, end_offs )
  raise unless start_offs < end_offs
  if text.class == "".class
    return start_offs+1
  end
  raise unless text.class == "".class
  if _byte_encoding == "utf8"
    o = start_offs+1
    while o<end_offs && text[o].ord&0xc0 == 0x80
      o += 1
    end
    return o
  end
  if _byte_encoding == "wide" && within_double_byte(text, 
    start_offs, start_offs) == 1
    return start_offs +2
  end
  return start_offs+1
end

# Return whether pos is within a double-byte encoded character.
# 
# str -- string in question
# line_start -- offset of beginning of line (< pos)
# pos -- offset in question
#
# Return values:
# 0 -- not within dbe char, or double_byte_encoding == false
# 1 -- pos is on the 1st half of a dbe char
# 2 -- pos is on the 2nd half og a dbe char
def self.within_double_byte(str, line_start, pos)
  v = str[pos].ord

  if v >= 0x40 && v < 0x7f
    # might be second half of big5, uhc or gbk encoding
    if pos == line_start
      return 0
    end
    
    if str[pos-1].ord >= 0x81
      if within_double_byte(str, line_start, pos-1) == 1
        return 2
      end
    end
    return 0
  end

  if v < 0x80
    return 0
  end

  i = pos -1
  while i >= line_start
    if str[i].ord < 0x80
      break
    end
    i -= 1
  end
  
  if (pos - i) & 1 != 0
    return 1
  end
  return 2
end

# TABLE GENERATION CODE

def self.process_east_asian_width()
  out = []
  last = nil
  readlines.each{ |line|
    line = line.strip
    next if line[0] == "#"
    hex,rest = line.split(";",2)
    wid,rest = rest.split(" # ",2)
    word1 = rest.split(" ",2)[0]

    if hex.include? "."
      hex = hex.split("..")[2]
    end
    num = hex.hex

    if ["COMBINING","MODIFIER","<control>"].include? word1
      l = 0
    elsif ["W", "F"].include? wid
      l = 2
    else
      l = 1
    end

    if last.nil?
      out << [0, l]
      last = l
    end
    
    if last == l
      out[-1] = [num, l]
    else
      out << [num, l]
      last = l
    end
  }

  puts "widths = ["
  out[1..-1].each{ |o| 
    puts "\t"+o.to_s+","
  }
  puts "]"
end

end

