# encoding: utf-8
$VERBOSE=true

module Escape
  SO = "\x0e"
  SI = "\x0f"
  DEC_TAG="0"
  DEC_SPECIAL_CHARS="◆▒°±┘┐┌└┼⎺⎻─⎼⎽├┤┴┬│≤≥π≠£·"
  ALT_DEC_SPECIAL_CHARS="`afgjklmnopqrstuvwxyz{|}~"
  DEC_SPECIAL_CHARMAP = {}

  raise DEC_SPECIAL_CHARS.to_s+','+ALT_DEC_SPECIAL_CHARS.to_s \
    unless DEC_SPECIAL_CHARS.length == ALT_DEC_SPECIAL_CHARS.length
    
  [1,2].zip(DEC_SPECIAL_CHARS.split(''), 
            ALT_DEC_SPECIAL_CHARS.split('')).each { |a|
     c, alt = *a
     DEC_SPECIAL_CHARMAP[c.ord] = SO+alt+SI
  }
  SAFE_ASCII_DEC_SPECIAL_RE = /^[ -~#{DEC_SPECIAL_CHARS}]*/
  DEC_SPECIAL_RE = /[#{DEC_SPECIAL_CHARS}]/

  class MoreInputRequired < Exception
  end

  def self.escape_modifier(digit)
    mode = digit.ord - "1".ord
    return 'shift '*(mode&1)+'meta '*((mode&2)/2)+'ctrl '*((mode&4)/4)
  end

  input_sequences = [
    ['[A','up'],['[B','down'],['[C','right'],['[D','left'],
    ['[E','5'],['[F','end'],['[G','5'],['[H','home'],

    ['[1~','home'],['[2~','insert'],['[3~','delete'],['[4~','end'],
    ['[5~','page up'],['[6~','page down'],
    ['[7~','home'],['[8~','end'],

    ['[[A','f1'],['[[B','f2'],['[[C','f3'],['[[D','f4'],['[[E','f5'],
    
    ['[11~','f1'],['[12~','f2'],['[13~','f3'],['[14~','f4'],
    ['[15~','f5'],['[17~','f6'],['[18~','f7'],['[19~','f8'],
    ['[20~','f9'],['[21~','f10'],['[23~','f11'],['[24~','f12'],
    ['[25~','f13'],['[26~','f14'],['[28~','f15'],['[29~','f16'],
    ['[31~','f17'],['[32~','f18'],['[33~','f19'],['[34~','f20'],

    ['OA','up'],['OB','down'],['OC','right'],['OD','left'],
    ['OH','home'],['OF','end'],
    ['OP','f1'],['OQ','f2'],['OR','f3'],['OS','f4'],
    ['Oo','/'],['Oj','*'],['Om','-'],['Ok','+'],

    ['[Z','shift tab'],
  ] + [ 
    # modified cursor keys + home, end, 5 -- [#X and [1;#X forms
    [1,2].zip('ABCDEFGH'.split(''),
        ['up','down','right','left','5','end','5','home']).each { |a|
      letter, key = *a
      '12345678'.split('').each { |digit| 
        ['[','[1;'].each { |prefix|
          [prefix+digit+letter.to_s, self.escape_modifier(digit)+key]
        }
      }
    }
  ] + [
    # modified F1-F4 keys -- O#X form
    [1,2].zip('PQRS'.split(''), ['f1','f2','f3','f4']).each {|a|
      letter,key = *a
      '12345678'.split('').each {|digit|
        ['0'+digit+letter.to_s, self.escape_modifier(digit)+key]
      }
    }
  ] + [
    # modified F1-F13 keys -- [XX;#~ form
    [1,2].zip([11,12,13,14,15,17,18,19,20,21,23,24,25,26,28,29,31,32,33,34],
    ['f1','f2','f3','f4','f5','f6','f7','f8','f9','f10','f11',
      'f12','f13','f14','f15','f16','f17','f18','f19','f20']).
      each { |a|
        num,key = *a
        "12345678".split('').each { |digit|
          ['['+num.to_s+';'+digit+'~', escape_modifier(digit)+key.to_s]
      }
    }
  ] + [
    # mouse reporting (special handling done in KeyqueueTrie)
    ['[M', 'mouse'],
    # report status response
    ['[0n', 'status ok']
  ]

  class KeyqueueTrie
    def initialize(sequences)
      @data = {}
      sequences.each { |a| 
        s,result = *a
        raise unless result.class != {}.class
        add(@data, s, result)
      }
    end

    def add(root, s, result)
      raise 'trie confict detected' unless root.class == {}.class
      raise 'trie confict detected' unless s.length > 0

      if root.has_key? s[0].ord
        return add(root[s[0].ord], s[1..s.length-1], result)
      end
      if s.length > 1
        d = {}
        root[s[0].ord] = d
        return add(d, s[1..s.length-1], result)
      end
      root[s[0].ord] = result
    end

    def get(keys, more_available)
      result = get_recurse(@data, keys, more_available)
      if not result
        result = read_cursor_position(keys, more_available)
      end
      return result
    end

    def get_recurse(root, keys, more_available)
      if root.class != {}.class
        if root == 'mouse'
          return read_mouse_info(keys, more_available)
        end
        return root, keys
      end
      if not keys
        if more_available
          raise MoreInputRequired
        end
        return nil
      end
      if not root.has_key? keys[0]
        return nil
      end
      return get_recurse(root[keys[0]], keys[1..keys.length-1], more_available)
    end

    def read_mouse_info(keys, more_available)
      if keys.length < 3
        if more_available
          raise MoreInputRequired
        end
        return nil
      end

      b = keys[0] - 32
      x, y = keys[1] - 33, keys[2] - 33 # start from 0

      prefix = ''
      prefix += 'shift ' if b & 4
      prefix += 'meta ' if b & 8
      prefix += 'ctrl ' if b & 16

      # 0->1, 1->2, 2->3, 64->4, 65->5
      button = ((b&64)/64*3) + (b & 3) + 1

      if b & 3 == 3
        action = 'release'
        button = 0
      elsif b & MOUSE_RELEASE_FLAG
        action = 'release'
      elsif b & MOUSE_DRAG_FLAG
        action = 'drag'
      else
        action = 'press'
      end
      return [[prefix+'mouse '+action, button, x, y], keys[3..keys.length-1]]
    end

    def read_cursor_position(keys, more_available)
		  # Interpret cursor position information being sent by the
		  # user's terminal.  Returned as ('cursor position', x, y)
		  # where (x, y) == (0, 0) is the top left of the screen.
      if not keys
        if more_available
          raise MoreInputRequired
        end
        return nil
      end
      if keys[0] != '['.ord
        return nil
      end
      #read y value
      y = 0
      i = 1
      keys[i..keys.length-1].each { |k|
        i += 1
        if k == ';'.ord
          if not y
            return nil
          end
          break
        end
        if k < '0'.ord or k > '9'.ord
          return nil
        end
        if not y and k == '0'.ord
          return nil
        end
        y = y*10 + k - '0'.ord
      }
      if not keys[i..keys.length-1]
        if more_available
          raise MoreInputRequired
        end
        return nil
      end
      #read x value
      x = 0
      keys[i..keys.length-1].each { |k|
        i += 1
        if k == 'R'.ord
          if not x
            return nil
          end
          return [['cursor position', x-1, y-1], keys[i..keys.length-1]]
        end
        if k < '0'.ord or k > '9'.ord
          return nil
        end
        if not x and k == '0'.ord
          return nil
        end
        x = x*10 + k - '0'.ord
      }
      if not keys[i..keys.length-1]
        if more_available
          raise MoreInputRequired
        end
      end
      return nil
    end
  end

  # This is added to button value to signal mouse release by curses_display
  # and raw_display when we know which button was released.  NON-STANDARD 
  MOUSE_RELEASE_FLAG = 2048

  # xterm adds this to the button value to signal a mouse drag event
  MOUSE_DRAG_FLAG = 32

  # Build the input trie from input_sequences list
  input_trie = KeyqueueTrie.new(input_sequences)

  _keyconv = {
	  -1 => nil,
	  8 => 'backspace',
	  9 => 'tab',
	  10 => 'enter',
	  13 => 'enter',
	  127 => 'backspace',
	  # curses-only keycodes follow..  (XXX =>  are these used anymore?)
	  258 => 'down',
	  259 => 'up',
	  260 => 'left',
	  261 => 'right',
	  262 => 'home',
	  263 => 'backspace',
	  265 => 'f1', 266 => 'f2', 267 => 'f3', 268 => 'f4',
	  269 => 'f5', 270 => 'f6', 271 => 'f7', 272 => 'f8',
	  273 => 'f9', 274 => 'f10', 275 => 'f11', 276 => 'f12',
	  277 => 'shift f1', 278 => 'shift f2', 279 => 'shift f3', 280 => 'shift f4',
	  281 => 'shift f5', 282 => 'shift f6', 283 => 'shift f7', 284 => 'shift f8',
	  285 => 'shift f9', 286 => 'shift f10', 287 => 'shift f11', 288 => 'shift f12',
	  330 => 'delete',
	  331 => 'insert',
	  338 => 'page down',
	  339 => 'page up',
	  343 => 'enter',    # on numpad
	  350 => '5',        # on numpad
	  360 => 'end',
  }

  def process_keyqueue(codes, more_available)
	  # codes -- list of key codes
	  # more_available -- if True then raise MoreInputRequired when in the 
	  # 	middle of a character sequence (escape/utf8/wide) and caller 
	  # 	will attempt to send more key codes on the next call.
	  # 
	  # returns (list of input, list of remaining key codes).
    code = codes[0]
    if code >= 32 and code <= 126
      key = code.chr
      return [key], codes[1..codes.length-1]
    end
    if _keyconv.has_key? code
      return [_keyconv[code]], codes[1..codes.length-1]
    end
    if code > 0 and code < 27
      return ['ctrl '+('a'.ord+code-1).chr], codes[1..codes.length-1]
    end
    if code > 27 and code < 32
      return ['ctrl '+('A'.ord+code-1).chr], codes[1..codes.length-1]
    end

    em = util.get_encoding_mode

    if (em == 'wide' and code < 256 and util.within_double_byte(code.chr, 0, 0))
      if not codes[1..codes.length-1]
        if more_available
          raise MoreInputRequired
        end
      end
      if codes[1..codes.length-1] and codes[1] < 256
        db = code.chr+codes[1].chr
        if util.within_double_byte(db, 0, 1)
          return [db], codes[2..codes.length-1]
        end
      end
    end
    if em == 'utf8' and code > 127 and code < 256
      if code & 0xe0 == 0xc0 # 2-byte form
        need_more = 1
      elsif code & 0xf0 == 0xe0 # 3-byte form
        need_more = 2
      elsif code & 0xf8 == 0xf0 # 4-byte form
        need_more = 3
      else
        return ["<#{code}>"], codes[1..codes.length-1]
      end

      need_more.each_index { |i|
        if codes.length-1 <= i
          if more_available
            raise MoreInputRequired
          else
            return ["<#{code}>"], codes[1..codes.length-1]
          end
        end
        k = codes[i+1]
        if k > 256 or k & 0xc0 != 0x80
          return ["<#{code}>"], codes[1..codes.length-1]
        end
      }

      s = codes[0..need_more].map {|c| c.chr}.join('')
      begin
        return s.encode('utf-8'), codes[need_more+1..codes.length-1]
      rescue Encoding::UndefinedConversionError
        return ["<#{code}>"], codes[1..codes.length-1]
      end
    end

    if code > 127 and code < 256
      key = code.chr
      return [key], codes[1..codes.length-1]
    end
    if code != 27
      return ["<#{code}>"], codes[1..codes.length-1]
    end

    result = input_trie.get(codes[1..codes.length-1], more_available)

    if not result.nil?
      result, remaining_codes = *result
      return [result], remaining_codes
    end

    if codes[1..codes.length-1]
      # Meta keys -- ESC+Key form
      run, remaining_codeds = *process_keyqueue(codes[1..codes.length-1],
                                                more_available)
      if run[0] == 'esc' or run[0].match('meta ')
        return ['esc']+run,  remaining_codes
      end
      return ['meta '+run[0]]+run[1..run.length-1], remaining_codes
    end

    return ['esc'], codes[1..codes.length-1]
  end

  # Output Sequences
  ESC = "\x1b"
  CURSOR_HOME = ESC+"[H"
  CURSOR_HOME_COL = "\r"
  APP_KEYPAD_MODE = ESC+"="
  NUM_KEYPAD_MODE = ESC+">"
  SWITCH_TO_ALTERNATE_BUFFER=ESC+"[?1049h"
  RESTORE_NORMAL_BUFFER=ESC+"[?1049l"

  RESET_SCROLL_REGION=ESC+"[;r"
  RESET = ESC+"c"
  
  REPORT_STATUS = ESC+"[5n"
  REPORT_CURSOR_POSITION=ESC+"[6n"

  INSERT_ON = ESC+"[4h"
  INSERT_OFF = ESC+"[4l"

  def set_cursor_position(x, y)
    raise unless x.class = 0.class
    raise unless y.class = 0.class
    return ESC+"[#{y+1};#{x+1}H]"
  end

  def move_cursor_right(x)
    return '' if x < 1
    return ESC+"[#{x}C"
  end

  def move_cursor_up(x)
    return '' if x < 1
    return ESC+"[#{x}A"
  end
  
  def move_cursor_down(x)
    return '' if x < 1
    return ESC+"[#{x}B"
  end

  HIDE_CURSOR = ESC+"[?25l"
  SHOW_CURSOR = ESC+"[?25h"

  MOUSE_TRACKING_ON = ESC+"[?1000h"+ESC+"[?1002h"
  MOUSE_TRACKING_OFF = ESC+"[?1002l"+ESC+"[?1000l"

  DESIGNATE_G1_SPECIAL = ESC+")0"

end
