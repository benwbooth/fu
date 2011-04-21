# Ncurses-based UI implementation

$VERBOSE=true
require 'ncurses'
require 'fu/display/str_util'
require 'fu/display/util'
require 'fu/display/escape'
require 'fu/display/display_common'

# TODO: use init_color and can_change_color? to change color palette values
# on supporting terminals
module CursesDisplay

KEY_RESIZE = 410 # curses.KEY_RESIZE (sometimes not defined)
KEY_MOUSE = 409 # curses.KEY_MOUSE

CURSES_COLORS = {
  'default'=>		[-1, 0],
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

class Screen < DisplayCommon::RealTerminal
  def initialize
    super
    @color_pairs = {}
    @has_color = false
    @s = nil
    @cursor_state = nil
    @keyqueue = []
    @prev_input_resize = 0
    set_input_timeouts
    @last_bstate = 0
    @started = false

    # replace control characters with ?'s
    @trans_table = [
      (0..255).map {|_| _.chr}.join(''), 
      ('?'*32)+(32..255).map {|_| _.chr}.join('')
    ]
  end

  attr_reader :started
    
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
    Ncurses.noecho()
    Ncurses.meta(@s, 1)
    Ncurses.halfdelay(10) # use set_input_timeouts to adjust
    Ncurses.keypad(@s, 0)
    
    if !@signal_keys_set
      @old_signal_keys = tty_signal_keys()
    end
  end
  
  # Restore the screen.
  def stop
    if @started == false
      return
    end

    Ncurses.echo()
    curs_set(1)
    begin
      Ncurses.endwin()
    rescue
      # don't block original error with curses error
    end
    
    @started = false
    
    if @old_signal_keys
      tty_signal_keys($stdin,*@old_signal_keys)
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

  def get_color_pair(fg,bg)
    return 0 if !@has_color

    # get the color numbers for fg and bg
    if !@has_default_colors && fg == -1
      fg = CURSES_COLORS["black"][0]
    end
    if !@has_default_colors && bg == -1
      bg = CURSES_COLORS["light gray"][0]
    end

    pair = @color_pairs[[fg,bg]]
    if !pair.nil?
      # re-insert the pair to make sure the least recently used pairs
      # are shifted first
      @color_pairs.delete([[fg,bg]])
      @color_pairs[[fg,bg]] = pair
      return pair 
    end

    # add a new color pair
    if @color_pairs.length > Ncurses.COLOR_PAIRS-1
      # shift the least-recently used pair to make room
      @color_pairs.shift
    end
    Ncurses.init_pair(@color_pairs.length+1,fg,bg)
    @color_pairs[[fg,bg]] = @color_pairs.length+1
    return @color_pairs[[fg,bg]]
  end
  
  def curs_set(x)
    if @cursor_state== "fixed" || x == @cursor_state
      return
    end
    begin
      Ncurses.curs_set(x)
      @cursor_state = x
    rescue
      @cursor_state = "fixed"
    end
  end
  
  def clear
    @s.clear()
    @s.refresh()
  end
  
  def getch(wait_tenths)
    if wait_tenths==0
      return self.getch_nodelay()
    end
    if wait_tenths.nil?
      Ncurses.cbreak()
    else
      Ncurses.halfdelay(wait_tenths)
    end
    @s.nodelay(0)
    return @s.getch()
  end
  
  def getch_nodelay
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
    
    convert_to_tenths = lambda do |s|
      if s.nil?
        return nil
      end
      return ((s+0.05)*10).to_i
    end

    @max_tenths = convert_to_tenths.call(max_wait)
    @complete_tenths = convert_to_tenths.call(complete_wait)
    @resize_tenths = convert_to_tenths.call(resize_wait)
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
    
    key = getch(wait_tenths)
    resize = false
    raw = []
    keys = []
    
    while key >= 0
      raw << key
      if key==KEY_RESIZE
        resize = true
      elsif key==KEY_MOUSE
        keys += encode_mouse_event()
      else
        keys << key
      end
      key = getch_nodelay()
    end

    processed = []
    
    begin
      while keys && keys.length>0
        run, keys = Escape.process_keyqueue(keys, true)
        processed += run
      end
    rescue Escape.MoreInputRequired
      key = getch(@complete_tenths)
      while key >= 0
        raw << key
        if key==KEY_RESIZE
          resize = true
        elsif key==KEY_MOUSE
          keys += encode_mouse_event()
        else
          keys.append(key)
        end
        key = getch_nodelay()
      end
      while keys && keys.length>0
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
  def encode_mouse_event
    last = _next = @last_bstate
    mevent = Ncurses::MEVENT.new
    Ncurses.getmouse(mevent)
    id,x,y,z,bstate = mevent.id, mevent.x, mevent.y, mevent.z, mevent.bstate
    
    mod = 0
    mod |= 4 if bstate & Ncurses::BUTTON_SHIFT != 0
    mod |= 8 if bstate & Ncurses::BUTTON_ALT != 0
    mod |= 16 if bstate & Ncurses::BUTTON_CTRL != 0
    
    l = []
    append_button = lambda do |b|
      b |= mod
      l += [ 27, '['.ord, 'M'.ord, b+32, x+33, y+33 ]
    end
    
    if bstate & Ncurses::BUTTON1_PRESSED != 0 && last & 1 == 0
      append_button.call( 0 )
      _next |= 1
    end
    if bstate & Ncurses::BUTTON2_PRESSED != 0 && last & 2 == 0
      append_button.call( 1 )
      _next |= 2
    end
    if bstate & Ncurses::BUTTON3_PRESSED != 0 && last & 4 == 0
      append_button.call( 2 )
      _next |= 4
    end
    if bstate & Ncurses::BUTTON4_PRESSED != 0 && last & 8 == 0
      append_button.call( 64 )
      _next |= 8
    end
    if bstate & Ncurses::BUTTON1_RELEASED != 0 && last & 1
      append_button.call( 0 + Escape::MOUSE_RELEASE_FLAG )
      _next &= ~ 1
    end
    if bstate & Ncurses::BUTTON2_RELEASED != 0 && last & 2
      append_button.call( 1 + Escape::MOUSE_RELEASE_FLAG )
      _next &= ~ 2
    end
    if bstate & Ncurses::BUTTON3_RELEASED != 0 && last & 4
      append_button.call( 2 + Escape::MOUSE_RELEASE_FLAG )
      _next &= ~ 4
    end
    if bstate & Ncurses::BUTTON4_RELEASED != 0 && last & 8
      append_button.call( 64 + Escape::MOUSE_RELEASE_FLAG )
      _next &= ~ 8
    end
    
    @last_bstate = _next
    return l
  end

  # messy input string (intended for debugging)
  def dbg_instr 
    Ncurses.echo()
    @s.nodelay(0)
    Ncurses.halfdelay(100)
    str = ""
    @s.getstr(str)
    Ncurses.noecho()
    return str
  end

  # messy output function (intended for debugging)
  def dbg_out(str) 
    @s.clrtoeol()
    @s.addstr(str)
    @s.refresh()
    curs_set(1)
  end

  # messy query (intended for debugging)
  def dbg_query(question) 
    dbg_out(question)
    return dbg_instr()
  end
  
  def dbg_refresh
    @s.refresh()
  end

  # Return the terminal dimensions (num columns, num rows).
  def get_cols_rows
    cols = []
    rows = []
    Ncurses.getmaxyx(@s, cols, rows)
    rows = rows[0]
    cols = cols[0]
    return cols,rows
  end

  def setattr(a)
    if a.nil?
      @s.attrset( 0 )
      return
    end
    # if both high and basic are unset, reset to default colors
    if !(a.foreground_high || a.foreground_basic ||
         a.background_high || a.background_basic)
      pair = 0 
    else
      foreground_number = a.foreground_number
      background_number = a.background_number

      if !(a.foreground_high || a.foreground_basic)
        foreground_number = DisplayCommon::BASIC_COLORS.index(DisplayCommon::WHITE)
      end
      if !(a.background_high || a.background_basic)
        background_number = DisplayCommon::BASIC_COLORS.index(DisplayCommon::BLACK)
      end
      pair = get_color_pair(foreground_number, background_number)
    end
    attr = (pair << 8) | 
      (a.bold ? Ncurses::A_BOLD : 0) | 
      (a.standout ? Ncurses::A_STANDOUT : 0) | 
      (a.underline ? Ncurses::A_UNDERLINE : 0)
    @s.attrset(attr)
  end
      
  # Paint screen with rendered canvas.
  def draw_screen(cr, r )
    cols, rows = *cr
    raise unless @started
  
    y = -1
    r.content().each do |row|
      y += 1
      break if y >= rows

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
      move_right = 0
      skip_right = 0
      x = -1
      row.each do |b|
        a, cs, seg = *b
        x += 1
        if skip_right > 0
          skip_right -= 1
          next
        end
        if seg.length == 0
          move_right += 1
          next
        end
        if move_right > 0
          @s.move(y, x)
          move_right = 0
        end

        seg.tr!( *@trans_table )
        if first || lasta != a
          setattr(a)
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
          width = StrUtil.calc_width(seg, 0, seg.length)
          skip_right = [0, width-1].max
        rescue
          # it's ok to get out of the
          # screen on the lower right
          if y == rows-1 && nr == row.length-1
          else
            # perhaps screen size changed
            # quietly abort.
            return
          end
        end
        nr += 1
      end
    end
    if !r.cursor.nil?
      x,y = *r.cursor
      curs_set(1)
      begin
        @s.move(y,x)
      rescue
      end
    else
      curs_set(0)
      @s.move(0,0)
    end
    
    @s.refresh()
    @keep_cache_alive_link = r
  end
end

end
          
