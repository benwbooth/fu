# Ncurses-based UI implementation

$VERBOSE=true
require 'ncurses'
require 'qbedit/display/util'
require 'qbedit/display/escape'
require 'qbedit/display/display_common'

module CursesDisplay

RealTerminal = DisplayCommon::RealTerminal

KEY_RESIZE = 410 # curses.KEY_RESIZE (sometimes not defined)
KEY_MOUSE = 409 # curses.KEY_MOUSE

CURSES_COLORS = {
  'default'=>		[-1,			0],
  'black'=>		[Ncurses::COLOR_BLACK,	0],
  'dark red'=>		[Ncurses::COLOR_RED,	0],
  'dark green'=>		[Ncurses::COLOR_GREEN,	0],
  'brown'=>		[Ncurses::COLOR_YELLOW,	0],
  'dark blue'=>		[Ncurses::COLOR_BLUE,	0],
  'dark magenta'=>		[Ncurses::COLOR_MAGENTA,	0],
  'dark cyan'=>		[Ncurses::COLOR_CYAN,	0],
  'light gray'=>		[Ncurses::COLOR_WHITE,	0],
  'dark gray'=>		[Ncurses::COLOR_BLACK,    1],
  'light red'=>		[Ncurses::COLOR_RED,      1],
  'light green'=>		[Ncurses::COLOR_GREEN,    1],
  'yellow'=>		[Ncurses::COLOR_YELLOW,   1],
  'light blue'=>		[Ncurses::COLOR_BLUE,     1],
  'light magenta'=>	[Ncurses::COLOR_MAGENTA,  1],
  'light cyan'=>		[Ncurses::COLOR_CYAN,     1],
  'white'=>		[Ncurses::COLOR_WHITE,	1],
}

# replace control characters with ?'s
_trans_table = [
  (0..255).map {|_| _.chr}.join(''), 
  ('?'*32)+(32..255).map {|_| _.chr}.join('')
]

class Screen < RealTerminal
  def initialize
    super
    @curses_pairs = [
      [nil,nil], # Can't be sure what pair 0 will default to
    ]
    @palette = {}
    @has_color = false
    @s = nil
    @cursor_state = nil
    @_keyqueue = []
    @prev_input_resize = 0
    set_input_timeouts
    @last_bstate = 0
    @started = false
  end

  attr_reader :started

  # Register a list of palette entries.
  #
  # l -- list of (name, foreground, background, mono),
  #      (name, foreground, background) or
  #      (name, same_as_other_name) palette entries.
  #
  # calls self.register_palette_entry for each item in l
  def register_palette(l)
    l.each {|item| 
      if [3,4].include? item.length
        register_palette_entry( *item )
        next
      end
      raise "Invalid register_palette usage" unless item.length == 2
      name, like_name = *item
      if !palette.has_key? like_name
        raise Exception, "palette entry '%s' doesn't exist"%like_name
      end
      @palette[name] = @palette[like_name]
    }
  end

  # Register a single palette entry.
  #
  # name -- new entry/attribute name
  # foreground -- foreground color, one of: 'black', 'dark red',
  # 	'dark green', 'brown', 'dark blue', 'dark magenta',
  # 	'dark cyan', 'light gray', 'dark gray', 'light red',
  # 	'light green', 'yellow', 'light blue', 'light magenta',
  # 	'light cyan', 'white', 'default' (black if unable to
  # 	use terminal's default)
  # background -- background color, one of: 'black', 'dark red',
  # 	'dark green', 'brown', 'dark blue', 'dark magenta',
  # 	'dark cyan', 'light gray', 'default' (light gray if
  # 	unable to use terminal's default)
  # mono -- monochrome terminal attribute, one of: None (default),
  # 	'bold',	'underline', 'standout', or a tuple containing
  # 	a combination eg. ('bold','underline')
  def register_palette_entry(name, foreground, background, mono=nil)
    raise if @started

    fg_a, fg_b = *CURSES_COLORS[foreground]
    bg_a, bg_b = *CURSES_COLORS[background]
    if bg_b && bg_b != 0 # can't do bold backgrounds
      raise Exception.new("%s is not a supported background color"%background )
    end
    raise unless (mono.nil? ||
      [nil, 'bold', 'underline', 'standout'].include?(mono) ||
      mono.class==[].class)
  
    pair = []
    (0..@curses_pairs.length-1).each {|i|
      pair = @curses_pairs[i]
      break if pair == [fg_a, bg_a]
    }
    if pair != [fg_a, bg_a]
      i = @curses_pairs.length
      @curses_pairs << [fg_a, bg_a]
    end
    
    @palette[name] = [i, fg_b, mono]
  end
    
  # Enable mouse tracking.  
  # 
  # After calling this function get_input will include mouse
  # click events along with keystrokes.
  def set_mouse_tracking
    rval = Ncurses.mousemask( 0 |
      Ncurses::BUTTON1_PRESSED | Ncurses::BUTTON1_RELEASED |
      Ncurses::BUTTON2_PRESSED | Ncurses::BUTTON2_RELEASED |
      Ncurses::BUTTON3_PRESSED | Ncurses::BUTTON3_RELEASED |
      Ncurses::BUTTON4_PRESSED | Ncurses::BUTTON4_RELEASED |
      Ncurses::BUTTON_SHIFT | Ncurses::BUTTON_ALT |
      Ncurses::BUTTON_CTRL, [])
  end

  # Initialize the screen and input mode.
  def start
    raise unless @started == false

    @s = Ncurses.initscr()
    @started = true
    @has_color = Ncurses.has_colors?
    if @has_color
      Ncurses.start_color()
      if Ncurses.COLORS() < 8
        # not color enough
        @has_color = false
      end
    end
    if @has_color
      begin
        Ncurses.use_default_colors()
        @has_default_colors=true
      rescue
        @has_default_colors=false
      end
    end
    setup_color_pairs()
    Ncurses.noecho()
    Ncurses.meta(@s, 1)
    Ncurses.halfdelay(10) # use set_input_timeouts to adjust
    Ncurses.keypad(@s, 0)
    
    if !@_signal_keys_set
      @_old_signal_keys = tty_signal_keys()
    end
  end
  
  # Restore the screen.
  def stop
    if @started == false
      return
    end

    Ncurses.echo()
    _curs_set(1)
    begin
      curses.endwin()
    rescue
      # don't block original error with curses error
    end
    
    @started = false
    
    if @_old_signal_keys
      tty_signal_keys(*@_old_signal_keys)
    end
  end
  
  # Call fn in fullscreen mode.  Return to normal on exit.
  # 
  # This function should be called to wrap your main program loop.
  # Exception tracebacks will be displayed in normal mode.
  def run_wrapper(fn)
    begin
      start()
      return fn.call
    ensure
      stop()
    end
  end

  def setup_color_pairs
    k = 1
    if @has_color
      if @curses_pairs.length > Ncurses.COLOR_PAIRS()
        raise Exception.new("Too many color pairs!  Use fewer combinations.")
      end
    
      @curses_pairs[1..-1].each {|a|
        fg,bg = *a
        if !@has_default_colors && fg == -1
          fg = CURSES_COLORS["black"][0]
        end
        if !@has_default_colors && bg == -1
          bg = CURSES_COLORS["light gray"][0]
        end
        Ncurses.init_pair(k,fg,bg)
        k+=1
      }
    end
    wh, bl = Ncurses::COLOR_WHITE, Ncurses::COLOR_BLACK
    
    @attrconv = {}
    @palette.items.each {|name, b|
      cp, a, mono = *b
      if @has_color
        @attrconv[name] = (cp << 8)
        @attrconv[name] |= Ncurses::A_BOLD if a
      elsif mono.class == [].class
        _attr = 0
        mono.each{ |m|
          _attr |= _curses_attr(m)
        }
        @attrconv[name] = _attr
      else
        _attr = _curses_attr(mono)
        @attrconv[name] = _attr
      end
    }
  end
  
  def _curses_attr(a)
    if a == 'bold'
      return Ncurses::A_BOLD
    elsif a == 'standout'
      return Ncurses::A_STANDOUT
    elsif a == 'underline'
      return Ncurses::A_UNDERLINE
    else
      return 0
    end
  end

  def _curs_set(x)
    if @cursor_state== "fixed" || x == @cursor_state
      return
    end
    begin
      curses.curs_set(x)
      @cursor_state = x
    rescue
      @cursor_state = "fixed"
    end
  end
  
  def _clear
    @s.clear()
    @s.refresh()
  end
  
  def _getch(wait_tenths)
    if wait_tenths==0
      return self._getch_nodelay()
    end
    if wait_tenths.nil?
      curses.cbreak()
    else
      curses.halfdelay(wait_tenths)
    end
    @s.nodelay(0)
    return @s.getch()
  end
  
  def _getch_nodelay
    @s.nodelay(1)
    while true
      # this call fails sometimes, but seems to work when I try again
      begin
        Ncurses.cbreak()
        break
      rescue
      end
    end
      
    return @s.getch()
  end

  # Set the get_input timeout values.  All values have a granularity
  # of 0.1s, ie. any value between 0.15 and 0.05 will be treated as
  # 0.1 and any value less than 0.05 will be treated as 0.  The
  # maximum timeout value for this module is 25.5 seconds.
  # 
  # max_wait -- amount of time in seconds to wait for input when
  # 	there is no input pending, wait forever if None
  # complete_wait -- amount of time in seconds to wait when
  # 	get_input detects an incomplete escape sequence at the
  # 	end of the available input
  # resize_wait -- amount of time in seconds to wait for more input
  # 	after receiving two screen resize requests in a row to
  # 	stop urwid from consuming 100% cpu during a gradual
  # 	window resize operation
  def set_input_timeouts(max_wait=nil, complete_wait=0.1, resize_wait=0.1)
    
    def convert_to_tenths(s)
      if s.nil?
        return nil
      end
      return ((s+0.05)*10).to_i
    end

    @max_tenths = convert_to_tenths(max_wait)
    @complete_tenths = convert_to_tenths(complete_wait)
    @resize_tenths = convert_to_tenths(resize_wait)
  end
  
  # Return pending input as a list.
  #
  # raw_keys -- return raw keycodes as well as translated versions
  #
  # This function will immediately return all the input since the
  # last time it was called.  If there is no input pending it will
  # wait before returning an empty list.  The wait time may be
  # configured with the set_input_timeouts function.
  #
  # If raw_keys is False (default) this function will return a list
  # of keys pressed.  If raw_keys is True this function will return
  # a ( keys pressed, raw keycodes ) tuple instead.
  # 
  # Examples of keys returned
  # -------------------------
  # ASCII printable characters:  " ", "a", "0", "A", "-", "/" 
  # ASCII control characters:  "tab", "enter"
  # Escape sequences:  "up", "page up", "home", "insert", "f1"
  # Key combinations:  "shift f1", "meta a", "ctrl b"
  # Window events:  "window resize"
  # 
  # When a narrow encoding is not enabled
  # "Extended ASCII" characters:  "\\xa1", "\\xb2", "\\xfe"
  #
  # When a wide encoding is enabled
  # Double-byte characters:  "\\xa1\\xea", "\\xb2\\xd4"
  #
  # When utf8 encoding is enabled
  # Unicode characters: u"\\u00a5", u'\\u253c"
  #
  # Examples of mouse events returned
  # ---------------------------------
  # Mouse button press: ('mouse press', 1, 15, 13), 
  #                     ('meta mouse press', 2, 17, 23)
  # Mouse button release: ('mouse release', 0, 18, 13),
  #                       ('ctrl mouse release', 0, 17, 23)
  def get_input(raw_keys=false)
    raise unless @started
    
    keys, raw = _get_input( @max_tenths )
    
    # Avoid pegging CPU at 100% when slowly resizing, and work
    # around a bug with some braindead curses implementations that 
    # return "no key" between "window resize" commands 
    if keys==['window resize'] && @prev_input_resize
      while true
        keys, raw2 = _get_input(@resize_tenths)
        raw += raw2
        if !keys
          keys, raw2 = _get_input(@resize_tenths)
          raw += raw2
        end
        if keys!=['window resize']
          break
        end
      end
      if keys[-1]!='window resize'
        keys << 'window resize'
      end
    end
        
    if keys==['window resize']
      @prev_input_resize = 2
    elsif @prev_input_resize == 2 && !keys
      @prev_input_resize = 1
    else
      @prev_input_resize = 0
    end
    
    if raw_keys
      return keys, raw
    end
    return keys
  end
    
  # this works around a strange curses bug with window resizing 
  # not being reported correctly with repeated calls to this
  # function without a doupdate call in between
  def _get_input(wait_tenths)
    Ncurses.doupdate() 
    
    key = _getch(wait_tenths)
    resize = false
    raw = []
    keys = []
    
    while key >= 0
      raw << key
      if key==KEY_RESIZE
        resize = true
      elsif key==KEY_MOUSE
        keys += _encode_mouse_event()
      else
        keys << key
      end
      key = _getch_nodelay()
    end

    processed = []
    
    begin
      while keys
        run, keys = Escape.process_keyqueue(keys, true)
        processed += run
      end
    rescue Escape.MoreInputRequired
      key = _getch(@complete_tenths)
      while key >= 0
        raw << key
        if key==KEY_RESIZE
          resize = true
        elsif key==KEY_MOUSE
          keys += _encode_mouse_event()
        else
          keys.append(key)
        end
        key = _getch_nodelay()
      end
      while keys
        run, keys = Escape.process_keyqueue(keys, false)
        processed += run
      end
    end

    if resize
      processed << 'window resize'
    end

    return processed, raw
  end
    
  # convert to escape sequence
  def _encode_mouse_event
    last = _next = @last_bstate
    mevent = Ncurses::MEVENT.new
    Ncurses.getmouse(bstate)
    id,x,y,z,bstate = mevent.id, mevent.x, mevent.y, mevent.z, mevent.bstate
    
    mod = 0
    mod |= 4 if bstate & Ncurses::BUTTON_SHIFT
    mod |= 8 if bstate & Ncurses::BUTTON_ALT
    mod |= 16 if bstate & Ncurses::BUTTON_CTRL
    
    l = []
    def append_button( b )
      b |= mod
      l += [ 27, '['.ord, 'M'.ord, b+32, x+33, y+33 ]
    end
    
    if bstate & Ncurses::BUTTON1_PRESSED && last & 1 == 0
      append_button( 0 )
      _next |= 1
    end
    if bstate & Ncurses::BUTTON2_PRESSED && last & 2 == 0
      append_button( 1 )
      _next |= 2
    end
    if bstate & Ncurses::BUTTON3_PRESSED && last & 4 == 0
      append_button( 2 )
      _next |= 4
    end
    if bstate & Ncurses::BUTTON4_PRESSED && last & 8 == 0
      append_button( 64 )
      _next |= 8
    end
    if bstate & Ncurses::BUTTON1_RELEASED && last & 1
      append_button( 0 + escape.MOUSE_RELEASE_FLAG )
      _next &= ~ 1
    end
    if bstate & Ncurses::BUTTON2_RELEASED && last & 2
      append_button( 1 + escape.MOUSE_RELEASE_FLAG )
      _next &= ~ 2
    end
    if bstate & Ncurses::BUTTON3_RELEASED && last & 4
      append_button( 2 + escape.MOUSE_RELEASE_FLAG )
      _next &= ~ 4
    end
    if bstate & Ncurses::BUTTON4_RELEASED && last & 8
      append_button( 64 + escape.MOUSE_RELEASE_FLAG )
      _next &= ~ 8
    end
    
    @last_bstate = _next
    return l
  end

  # messy input string (intended for debugging)
  def _dbg_instr 
    Ncurses.echo()
    @s.nodelay(0)
    Ncurses.halfdelay(100)
    str = ""
    @s.getstr(str)
    Ncurses.noecho()
    return str
  end

  # messy output function (intended for debugging)
  def _dbg_out(str) 
    @s.clrtoeol()
    @s.addstr(str)
    @s.refresh()
    _curs_set(1)
  end

  # messy query (intended for debugging)
  def _dbg_query(question) 
    _dbg_out(question)
    return _dbg_instr()
  end
  
  def _dbg_refresh
    @s.refresh()
  end

  # Return the terminal dimensions (num columns, num rows).
  def get_cols_rows
    Ncurses.getmaxyx(@s, cols, rows)
    rows = rows[0]
    cols = cols[0]
    return cols,rows
  end

  def _setattr(a)
    if a.nil?
      @s.attrset( 0 )
      return
    end
    if !@attrconv.has_key?(a)
      raise Exception, "Attribute %s not registered!"%a.to_s
    end
    @s.attrset( @attrconv[a] )
  end
      
  # Paint screen with rendered canvas.
  def draw_screen(cr, r )
    cols, rows = *cr
    raise unless @started
    
    raise  "canvas size and passed size don't match" unless r.rows() == rows
  
    y = -1
    r.content().each{ |row|
      y += 1
      begin
        @s.move( y, 0 )
      rescue
        # terminal shrunk? 
        # move failed so stop rendering.
        return
      end
      
      first = true
      lasta = nil
      nr = 0
      row.each{ |b|
        a, cs, seg = *b
        seg.tr!( *_trans_table )
        if first || lasta != a
          _setattr(a)
          lasta = a
        end
        begin
          if cs == "0"
            (0..seg.length-1).each{ |i|
              @s.addch( 0x400000 + seg[i].ord )
            }
          else
            raise unless cs.nil?
            @s.addstr( seg )
          end
        rescue
          # it's ok to get out of the
          # screen on the lower right
          if (y == rows-1 && nr == row.length-1)
          else
            # perhaps screen size changed
            # quietly abort.
            return
          end
        end
        nr += 1
      }
    }
    if !r.cursor.nil?
      x,y = *r.cursor
      _curs_set(1)
      begin
        @s.move(y,x)
      rescue
      end
    else
      _curs_set(0)
      @s.move(0,0)
    end
    
    @s.refresh()
    @keep_cache_alive_link = r
  end

  # Force the screen to be completely repainted on the next
  # call to draw_screen().
  def clear
    @s.clear()
  end
end

class Test
  class FakeRender < DisplayCommon::Render
  end

  def initialize
    @ui = Screen.new
    @l = CURSES_COLORS.keys()
    @l.sort!
    @l.each{ |c|
      @ui.register_palette( [
        [c+" on black", c, 'black', 'underline'],
        [c+" on dark blue",c, 'dark blue', 'bold'],
        [c+" on light gray",c,'light gray', 'standout'],
      ])
    }
    @ui.run_wrapper(method(:run))
  end
    
  def run
    r = FakeRender.new
    text = ["  has_color = "+@ui.has_color.to_s,""]
    attr = [[],[]]
    
    @l.each{ |c|
      t = ""
      a = []
      [c+" on black",c+" on dark blue",c+" on light gray"].each{ |p|
        a << [p,27]
        t=t+ (p+27*" ")[0..26]
      }
      text.append( t )
      attr.append( a )
    }

    text += ["","return values from get_input(): (q exits)", ""]
    attr += [[],[],[]]
    cols,rows = @ui.get_cols_rows()
    keys = nil
    while keys!=['q']
      r.text=(text.map {|t| t.ljust(cols)}+[""]*rows)[0..rows-1]
      r.attr=(attr+[[]]*rows)[0..rows-1]
      @ui.draw_screen([cols,rows],r)
      keys, raw = @ui.get_input( raw_keys = true )
      if keys.include? 'window resize'
        cols, rows = @ui.get_cols_rows()
      end
      if !keys
        next
      end
      t = ""
      a = []
      keys.each{ |k|
        if k.class == ''.class 
          k = k.encode("utf-8")
        end
        t += "'"+k+"' "
        a += [[nil,1], ['yellow on dark blue',k.length], [nil,2]]
      }
      
      text << (t + ": "+ raw.to_s)
      _attr << a
      text = text[-rows..-1]
      attr = attr[-rows..-1]
    end
  end
end

end
          
