#
# Urwid raw display module
#    Copyright (C) 2004-2009  Ian Ward
#
#    This library is free software; you can redistribute it and/or
#    modify it under the terms of the GNU Lesser General Public
#    License as published by the Free Software Foundation; either
#    version 2.1 of the License, or (at your option) any later version.
#
#    This library is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#    Lesser General Public License for more details.
#
#    You should have received a copy of the GNU Lesser General Public
#    License along with this library; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# Urwid web site: http://excess.org/urwid/

# Direct terminal UI implementation

require 'termios'
require 'pty'
require 'fcntl'
require 'signal'
require 'process'
require 'fiber'

require 'str_util'
require 'util'
require 'escape'
require 'display_common'

module RawDisplay

# Indexes for termios list.
IFLAG = 0
OFLAG = 1
CFLAG = 2
LFLAG = 3
ISPEED = 4
OSPEED = 5
CC = 6

# replace control characters with ?'s
_trans_table = (32..256).map {|_| _.chr}.join("?"*32+"")

class ScreenError < Exception
end

class Screen < BaseScreen
    def initialize
        # Initialize a screen that directly prints escape codes to an output
        # terminal.
        super
        @_pal_escape = {}
        #signals.connect_signal(UPDATE_PALETTE_ENTRY, 
        #    _on_update_palette_entry)
        @colors = 256 # FIXME: detect this
        @has_underline = true # FIXME: detect this
        register_palette_entry( nil, 'default','default')
        @_keyqueue = []
        @prev_input_resize = 0
        set_input_timeouts()
        @screen_buf = nil
        @_resized = false
        @maxrow = nil
        @gpm_mev = nil
        @gpm_event_pending = false
        @last_bstate = 0
        @_setup_G1_done = false
        @_rows_used = nil
        @_cy = 0
        @_started = false
        @bright_is_bold = !ENV['TERM'].include?('xterm')
        @_next_timeout = nil
        @_term_output_file = $stdout
        @_term_input_file = $stdin
        # pipe for signalling external event loops about resize events
        @_resize_pipe_rd, @_resize_pipe_wr = IO.pipe
        @_resize_pipe_rd.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK);
    end

    def started
      @_started
    end

    def _on_update_palette_entry(name, *attrspecs)
        # copy the attribute to a dictionary containing the escape seqences
        @_pal_escape[name] = _attrspec_to_escape(
            attrspecs[{16=>0,1=>1,88=>2,256=>3}[@colors]])
    end

    def set_input_timeouts(max_wait=nil, complete_wait=0.125, 
        resize_wait=0.125)
        # Set the get_input timeout values.  All values are in floating
        # point numbers of seconds.
        # 
        # max_wait -- amount of time in seconds to wait for input when
        #     there is no input pending, wait forever if nil
        # complete_wait -- amount of time in seconds to wait when
        #     get_input detects an incomplete escape sequence at the
        #     end of the available input
        # resize_wait -- amount of time in seconds to wait for more input
        #     after receiving two screen resize requests in a row to
        #     stop Urwid from consuming 100% cpu during a gradual
        #     window resize operation

        @max_wait = max_wait
        if !max_wait.nil?
            if @_next_timeout.nil?
                @_next_timeout = max_wait
            else
                @_next_timeout = min(@_next_timeout, @max_wait)
            end
        end
        @complete_wait = complete_wait
        @resize_wait = resize_wait
    end

    def _sigwinch_handler(signum, frame)
        if !@_resized
            @_resize_pipe_wr.write('R')
        end
        @_resized = true
        @screen_buf = nil
    end
      
    def signal_init
        # Called in the startup of run wrapper to set the SIGWINCH 
        # signal handler to @_sigwinch_handler.

        # Override this function to call from main thread in threaded
        # applications.

        Signal.trap('WINCH') do 
          _sigwinch_handler
        end
    end
    
    def signal_restore
        # Called in the finally block of run wrapper to restore the
        # SIGWINCH handler to the default handler.

        # Override this function to call from main thread in threaded
        # applications.

        Signal.trap('WINCH', 'SIG_DFL')
    end
      
    def set_mouse_tracking
        # Enable mouse tracking.  
        # 
        # After calling this function get_input will include mouse
        # click events along with keystrokes.

        @_term_output_file.write(escape.MOUSE_TRACKING_ON)

        _start_gpm_tracking()
    end
    
    def _start_gpm_tracking
        if !File.exists? "/usr/bin/mev"
            return
        end
        if !(ENV['TERM']||'').downcase().start_with? "linux"
            return
        end
        if !IO.respond_to? 'popen'
            return
        end
        m = IO.popen(["/usr/bin/mev","-e","158"])
        m.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK)
        @gpm_mev = m
    end
    
    def _stop_gpm_tracking
        Process.kill(signal.SIGINT, @gpm_mev.pid)
        Process.waitpid(@gpm_mev.pid, 0)
        @gpm_mev = nil
    end

    def setraw(io, _when=Termios::TCSAFLUSH)
        # Put terminal into a raw mode.
        mode = Termios.tcgetattr(io)
        mode.iflag |= ~(Termios::BRKINT | Termios::ICRNL | Termios::INPCK | 
                        Termios::ISTRIP | Termios::IXON)
        mode.oflag &= ~(Termios::OPOST)
        mode.cflag |= ~(Termios::CSIZE | Termios::PARENB)
        mode.cflag |= Termios::CS8
        mode.lflag &= ~(Termios::ECHO | Termios::ICANON | Termios::IEXTEN | 
                        Termios::ISIG)
        mode.cc.vmin = 1
        mode.cc.vtime = 0
        Termios.tcsetattr(io, _when, mode)
    end

    def setcbreak(io, _when=Termios::TCSAFLUSH)
        # Put terminal into a cbreak mode.
        mode = tcgetattr(io)
        mode.lflag &= ~(Termios::ECHO | Termios::ICANON)
        mode.cc.vmin = 1
        mode.cc.vtime = 0
        Termios.tcsetattr(io, _when, mode)
    end

    def start(alternate_buffer=true)
        # Initialize the screen and input mode.
        # 
        # alternate_buffer -- use alternate screen buffer
      
        raise if @_started
        if alternate_buffer
            @_term_output_file.write(Escape::SWITCH_TO_ALTERNATE_BUFFER)
            @_rows_used = nil
        else
            @_rows_used = 0
        end

        @_old_termios_settings = Termios.tcgetattr(0)
        signal_init()
        setcbreak(@_term_input_file)
        @_alternate_buffer = alternate_buffer
        @_input_iter = @_run_input_iter.resume
        @_next_timeout = @max_wait
        
        if !@_signal_keys_set
            @_old_signal_keys = tty_signal_keys()
        end

        @_started = true
    end
    
    def stop
        # Restore the screen.

        clear()
        if !@_started
            return
        end
        signal_restore()
        Termios.tcsetattr(0, Termios::TCSADRAIN, 
            @_old_termios_settings)
        move_cursor = ""
        if @gpm_mev
            _stop_gpm_tracking()
        end
        if @_alternate_buffer
            move_cursor = Escape::RESTORE_NORMAL_BUFFER
        elsif !@maxrow.nil?
            move_cursor = Escape.set_cursor_position(0, @maxrow)
        end

        @_term_output_file.write(_attrspec_to_escape(AttrSpec('',''))+
            Escape::SI+
            Escape::MOUSE_TRACKING_OFF+
            Escape::SHOW_CURSOR+
            move_cursor + "\n" + Escape::SHOW_CURSOR )
        @_input_iter = @_fake_input_iter.resume

        if @_old_signal_keys
            tty_signal_keys(*@_old_signal_keys)
        end
        
        @_started = false
    end
        
    def run_wrapper(fn, alternate_buffer=true)
        # Call start to initialize screen, then call fn.  
        # When fn exits call stop to restore the screen to normal.

        # alternate_buffer -- use alternate screen buffer and restore
        #     normal screen buffer on exit

        begin
            start(alternate_buffer)
            return fn()
        ensure 
            stop()
        end
    end
            
    def get_input(raw_keys=false)
        # Return pending input as a list.

        # raw_keys -- return raw keycodes as well as translated versions

        # This function will immediately return all the input since the
        # last time it was called.  If there is no input pending it will
        # wait before returning an empty list.  The wait time may be
        # configured with the set_input_timeouts function.

        # If raw_keys is false (default) this function will return a list
        # of keys pressed.  If raw_keys is true this function will return
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

        # When a wide encoding is enabled
        # Double-byte characters:  "\\xa1\\xea", "\\xb2\\xd4"

        # When utf8 encoding is enabled
        # Unicode characters: u"\\u00a5", u'\\u253c"
        # 
        # Examples of mouse events returned
        # ---------------------------------
        # Mouse button press: ('mouse press', 1, 15, 13), 
        #                     ('meta mouse press', 2, 17, 23)
        # Mouse drag: ('mouse drag', 1, 16, 13),
        #             ('mouse drag', 1, 17, 13),
        #         ('ctrl mouse drag', 1, 18, 13)
        # Mouse button release: ('mouse release', 0, 18, 13),
        #                       ('ctrl mouse release', 0, 17, 23)

        raise if !@_started
        
        _wait_for_input_ready(@_next_timeout)
        @_next_timeout, keys, raw = @_input_iter.next
        
        # Avoid pegging CPU at 100% when slowly resizing
        if keys == ['window resize'] && @prev_input_resize
            while true
                _wait_for_input_ready(@resize_wait)
                @_next_timeout, keys, raw2 = @_input_iter.next
                raw += raw2
                #if !keys
                #    keys, raw2 = @_get_input(@resize_wait)
                #    raw += raw2
                #end
                if keys != ['window resize']
                    break
                end
            end
            if keys[-1] != 'window resize'
                keys << 'window resize'
            end
        end
                
        if keys == ['window resize']
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

    def get_input_descriptors
        # Return a list of integer file descriptors that should be
        # polled in external event loops to check for user input.

        # Use this method if you are implementing yout own event loop.

        fd_list = [@_term_input_file, @_resize_pipe_rd]
        if !@gpm_mev.nil?
            fd_list << @gpm_mev.stdout
        end
        return fd_list
    end
        
    def get_input_nonblocking
        # Return a (next_input_timeout, keys_pressed, raw_keycodes) 
        # tuple.

        # Use this method if you are implementing your own event loop.
        # 
        # When there is input waiting on one of the descriptors returned
        # by get_input_descriptors() this method should be called to
        # read and process the input.

        # This method expects to be called in next_input_timeout seconds
        # (a floating point number) if there is no input waiting.

        raise if !@_started
        return @_input_iter.next()
    end

    @_run_input_iter = Fiber.new do
        def empty_resize_pipe
            # clean out the pipe used to signal external event loops
            # that a resize has occured
            while !@_resize_pipe_rd.read(1).nil?
            end
        end

        while true
            processed = []
            codes = _get_gpm_codes() + _get_keyboard_codes()

            original_codes = codes
            begin
                while codes
                    run, codes = Escape.process_keyqueue(codes, true)
                    processed += run
                end
            rescue Escape::MoreInputRequired
                k = original_codes.length - codes.length
                Fiber.yield(@complete_wait, processed, original_codes[0..k-1])
                empty_resize_pipe()
                original_codes = codes
                processed = []

                codes += _get_keyboard_codes() + _get_gpm_codes()
                while codes
                    run, codes = Escape.process_keyqueue(codes, false)
                    processed.extend(run)
                end
            end
            
            if @_resized
                processed.append('window resize')
                @_resized = false
            end

            Fiber.yield(@max_wait, processed, original_codes)
            empty_resize_pipe()
        end
    end

    @_fake_input_iter = Fiber.new do
        # This generator is a placeholder for when the screen is stopped
        # to always return that no input is available.

        while true
            Fiber.yield(@max_wait, [], [])
        end
    end

    def _get_keyboard_codes
        codes = []
        while true
            code = _getch_nodelay()
            if code < 0
                break
            end
            codes << code
        end
        return codes
    end

    def _get_gpm_codes
        codes = []
        if !@gpm_mev.nil?
            begin
                while true
                    codes += _encode_gpm_event()
                end
            rescue IOError, e
                if e.args[0] != 11
                    raise
                end
            end
        end
        return codes
    end

    def _wait_for_input_ready(timeout)
        ready = nil
        fd_list = [@_term_input_file]
        if !@gpm_mev.nil?
            fd_list << @gpm_mev.stdout
        end
        while true
            begin
                if timeout.nil?
                    ready,w,err = *IO.select(fd_list, [], fd_list)
                else
                    ready,w,err = *IO.select(fd_list,[], fd_list, timeout)
                end
                break
            rescue IOError, e
                if e.args[0] != 4
                    raise
                end
                if @_resized
                    ready = []
                    break
                end
            end
        end
        return ready    
    end
        
    def _getch(timeout)
        ready = _wait_for_input_ready(timeout)
        if @gpm_mev.nil?
            if ready.include? @gpm_mev.stdout
                @gpm_event_pending = true
            end
        end
        if ready.include? @_term_input_file
            return @_term_input_file.read(1).ord
        end
        return -1
    end
    
    def _encode_gpm_event
        @gpm_event_pending = false
        s = @gpm_mev.stdout.gets
        l = s.split(",")
        if l.length != 6
            # unexpected output, stop tracking
            _stop_gpm_tracking()
            return []
        end
        ev, x, y, ign, b, m = *s.split(",")
        ev = ev.hex
        x = x.split(" ")[-1].to_i
        y = y.lstrip.split(" ")[0].to_i
        b = b.split(" ")[-1].to_i
        m = m.rstrip.hex

        # convert to xterm-like escape sequence

        last = _next = @last_bstate
        l = []
        
        mod = 0
        if m & 1
          mod |= 4 # shift
        end
        if m & 10
          mod |= 8 # alt
        end
        if m & 4
          mod |= 16 # ctrl
        end

        def append_button( b )
            b |= mod
            l += [ 27, '['.ord, 'M'.ord, b+32, x+32, y+32 ]
        end

        if ev == 20 # press
            if b & 4 && last & 1 == 0
                append_button( 0 )
                _next |= 1
            end
            if b & 2 && last & 2 == 0
                append_button( 1 )
                _next |= 2
            end
            if b & 1 && last & 4 == 0
                append_button( 2 )
                _next |= 4
            end
        elsif ev == 146 # drag
            if b & 4
                append_button( 0 + Escape::MOUSE_DRAG_FLAG )
            elsif b & 2
                append_button( 1 + Escape::MOUSE_DRAG_FLAG )
            elsif b & 1
                append_button( 2 + Escape::MOUSE_DRAG_FLAG )
            end
        else # release
            if b & 4 && last & 1
                append_button( 0 + Escape::MOUSE_RELEASE_FLAG )
                _next &= ~ 1
            end
            if b & 2 && last & 2
                append_button( 1 + Escape::MOUSE_RELEASE_FLAG )
                _next &= ~ 2
            end
            if b & 1 && last & 4
                append_button( 2 + Escape::MOUSE_RELEASE_FLAG )
                _next &= ~ 4
            end
        end
            
        @last_bstate = _next
        return l
    end
    
    def _getch_nodelay()
        return _getch(0)
    end

    def get_cols_rows
      # Return the terminal dimensions (num columns, num rows).
      begin
        tty = File.open('/dev/tty', File::RDWR|File::NOCTTY)
        tty.sync = true
        buf = ' '*4
        tty.ioctl(Termios::TIOCGWINSZ, buf)
        size = [buf[0..1].unpack('v'), buf[2..3].unpack('v')]
        tty.close
      rescue IOError
          size = [0,0]
      end
      if size[0] == 0
          size[0] = ENV['LINES'].to_i
      end
      if size[1] == 0
          size[1] = ENV['COLUMNS'].to_i
      end
      return *size
    end
    
    def _setup_G1
        # Initialize the G1 character set to graphics mode if required.

        if @_setup_G1_done
            return
        end
        
        while true
            begin
                @_term_output_file.write(Escape::DESIGNATE_G1_SPECIAL)
                @_term_output_file.flush
                break
            rescue IOError, e
            end
        end
        @_setup_G1_done = true
    end
    
    def draw_screen(maxrowcol, r)
        maxcol, maxrow = *maxrowcol
        # Paint screen with rendered canvas.
        raise unless @_started
        raise unless maxrow == r.rows

        _setup_G1()
        
        if @_resized
            # handle resize before trying to draw screen
            return
        end
        
        o = [escape.HIDE_CURSOR, _attrspec_to_escape(AttrSpec('',''))]
        
        def partial_display
            # returns true if the screen is in partial display mode
            # ie. only some rows belong to the display
            return !@_rows_used.nil?
        end

        if !partial_display()
            o << Escape::CURSOR_HOME
        end

        if @screen_buf
            osb = @screen_buf
        else
            osb = []
        end
        sb = []
        cy = @_cy
        y = -1

        def set_cursor_home
            if !partial_display()
                return Escape::set_cursor_position(0, 0)
            end
            return (Escape::CURSOR_HOME_COL + Escape::move_cursor_up(cy))
        end
        
        def set_cursor_row(y)
            if !partial_display()
                return Escape::set_cursor_position(0, y)
            end
            return Escape::move_cursor_down(y - cy)
        end

        def set_cursor_position(x, y)
            if !partial_display()
                return Escape::set_cursor_position(x, y)
            end
            if cy > y
                return ("\b" + Escape::CURSOR_HOME_COL +
                    Escape::move_cursor_up(cy - y) +
                    Escape::move_cursor_right(x))
            end
            return ("\b" + escape.CURSOR_HOME_COL +
                escape.move_cursor_down(y - cy) +
                escape.move_cursor_right(x))
        end
        
        def is_blank_row(row)
            if row.length > 1
                return false
            end
            if row[0][2].strip()
                return false
            end
            return true
        end

        def attr_to_escape(a)
            if @_pal_escape.include? a
                return @_pal_escape[a]
            elsif a.class == DisplayCommon::AttrSpec
                return _attrspec_to_escape(a)
            end
            # undefined attributes use default/default
            # TODO: track and report these
            return _attrspec_to_escape(AttrSpec('default','default'))
        end

        ins = nil
        o << set_cursor_home()
        cy = 0
        r.content().each {|row|
            y += 1
            # if osb && osb[y] == row
            #     # this row of the screen buffer matches what is
            #     # currently displayed, so we can skip this line
            #     sb << osb[y]
            #     next
            # end

            sb << row
            
            # leave blank lines off display when we are using
            # the default screen buffer (allows partial screen)
            if partial_display() && y > @_rows_used
                if is_blank_row(row)
                    next
                end
                @_rows_used = y
            end
            
            if y || partial_display()
                o << set_cursor_position(0, y)
            end
            # after updating the line we will be just over the
            # edge, but terminals still treat this as being
            # on the same line
            cy = y 
            
            if y == maxrow-1
                row, back, ins = _last_row(row)
            end

            first = true
            lasta = lastcs = nil
            row.each{|_|
                a, cs, run = *_

                run = run.translate( _trans_table )
                if first || lasta != a
                    o << attr_to_escape(a)
                    lasta = a
                end
                if first || lastcs != cs
                    raise cs.to_s unless [nil, "0"].include? cs
                    if cs.nil?
                        o << Escape::SI
                    else
                        o << Escape::SO
                    end
                    lastcs = cs
                end
                o << run
                first = false
            }
            if ins
                inserta, insertcs, inserttext = *ins
                ias = attr_to_escape(inserta)
                raise unless [[nil, "0"], insertcs.to_s].include? insertcs
                if cs.nil?
                    icss = Escape::SI
                else
                    icss = Escape::SO
                end
                o += ["\x08"*back, 
                    ias, icss,
                    Escape::INSERT_ON, inserttext,
                    Escape::INSERT_OFF ]
            end
        }
        if !r.cursor.nil?
            x,y = r.cursor
            o += [set_cursor_position(x, y), 
                Escape::SHOW_CURSOR  ]
            @_cy = y
        end
        
        if @_resized
            # handle resize before trying to draw screen
            return
        end
        begin
            k = 0
            o.each{ |l|
                @_term_output_file.write( l )
                k += l.length
                if k > 1024
                    @_term_output_file.flush
                    k = 0
                end
            }
            @_term_output_file.flush
        rescue IOError, e
            # ignore interrupted syscall
            if e.args[0] != 4
                raise
            end
        end

        @screen_buf = sb
        @keep_cache_alive_link = r
    end
                
    
    def _last_row(row)
        # On the last row we need to slide the bottom right character
        # into place. Calculate the new line, attr and an insert sequence
        # to do that.
        # 
        # eg. last row:
        # XXXXXXXXXXXXXXXXXXXXYZ
        # 
        # Y will be drawn after Z, shifting Z into position.
        
        new_row = row[0..-2]
        z_attr, z_cs, last_text = *row[-1]
        last_cols = StrUtil::calc_width(last_text, 0, last_text.length)
        last_offs, z_col = StrUtil::calc_text_pos(last_text, 0, 
            last_text.length, last_cols-1)
        if last_offs == 0
            z_text = last_text
            new_row.delete_at(-1)
            # we need another segment
            y_attr, y_cs, nlast_text = *row[-2]
            nlast_cols = StrUtil::calc_width(nlast_text, 0, nlast_text.length)
            z_col += nlast_cols
            nlast_offs, y_col = StrUtil.calc_text_pos(nlast_text, 0,
                nlast_text.length, nlast_cols-1)
            y_text = nlast_text[nlast_offs..-1]
            if nlast_offs
                new_row += [y_attr, y_cs, nlast_text[0..nlast_offs-1]]
            end
        else
            z_text = last_text[last_offs..-1]
            y_attr, y_cs = z_attr, z_cs
            nlast_cols = StrUtil::calc_width(last_text, 0, last_offs)
            nlast_offs, y_col = StrUtil::calc_text_pos(last_text, 0,
                last_offs, nlast_cols-1)
            y_text = last_text[nlast_offs..last_offs-1]
            if nlast_offs
                new_row += [y_attr, y_cs, last_text[0..nlast_offs-1]]
            end
        end
        
        new_row += [z_attr, z_cs, z_text]
        return new_row, z_col-y_col, [y_attr, y_cs, y_text]
    end
    
    def clear()
        # Force the screen to be completely repainted on the next
        # call to draw_screen().
        @screen_buf = nil
        @setup_G1 = true
    end
        
    def _attrspec_to_escape(a)
        # Convert AttrSpec instance a to an escape sequence for the terminal

        # >>> s = Screen()
        # >>> a2e = s._attrspec_to_escape
        # >>> a2e(s.AttrSpec('brown', 'dark green'))
        # '\\x1b[0;33;42m'
        # >>> a2e(s.AttrSpec('#fea,underline', '#d0d'))
        # '\\x1b[0;48;5;229;4;38;5;164m'

        if a.foreground_high
            fg = "38;5;%d" % a.foreground_number
        elsif a.foreground_basic
            if a.foreground_number > 7
                if @bright_is_bold
                    fg = "1;%d" % [a.foreground_number - 8 + 30]
                else
                    fg = "%d" % [a.foreground_number - 8 + 90]
                end
            else
                fg = "%d" % [a.foreground_number + 30]
            end
        else
            fg = "39"
        end
        st = "1;" * a.bold + "4;" * a.underline + "7;" * a.standout
        if a.background_high
            bg = "48;5;%d" % a.background_number
        elsif a.background_basic
            if a.background_number > 7
                # this doesn't work on most terminals
                bg = "%d" % [a.background_number - 8 + 100]
            else
                bg = "%d" % [a.background_number + 40]
            end
        else
            bg = "49"
        end
        return Escape::ESC + "[0;%s;%s%sm" % [fg, st, bg]
    end

    def set_terminal_properties(colors=nil, bright_is_bold=nil,
        has_underline=nil)
        # colors -- number of colors terminal supports (1, 16, 88 or 256)
        #     or nil to leave unchanged
        # bright_is_bold -- set to true if this terminal uses the bold 
        #     setting to create bright colors (numbers 8-15), set to false
        #     if this Terminal can create bright colors without bold or
        #     nil to leave unchanged
        # has_underline -- set to true if this terminal can use the
        #     underline setting, false if it cannot or nil to leave
        #     unchanged
        if colors.nil?
            colors = @colors
        end
        if bright_is_bold.nil?
            bright_is_bold = @bright_is_bold
        end
        if has_underline.nil?
            has_unerline = @has_underline
        end

        if colors == @colors && bright_is_bold == @bright_is_bold \
            && has_underline == @has_underline
            return
        end

        @colors = colors
        @bright_is_bold = bright_is_bold
        @has_underline = has_underline
            
        clear()
        @_pal_escape = {}
        @_palette.items.each_with_index { |p,v|
            _on_update_palette_entry(p, *v)
        }
    end

    def reset_default_terminal_palette
        # Attempt to set the terminal palette to default values as taken
        # from xterm.  Uses number of colors from current 
        # set_terminal_properties() screen setting.
        if @colors == 1
            return
        end

        def rgb_values(n)
            if @colors == 16
                aspec = AttrSpec("h%d" % n, "", 256)
            else
                aspec = AttrSpec("h%d" % n, "", @colors)
            end
            return aspec.get_rgb_values()[0..2]
        end

        entries = [range(@colors).map {|n| [n] + rgb_values(n)}]
        modify_terminal_palette(entries)
    end


    def modify_terminal_palette(entries)
        # entries - list of (index, red, green, blue) tuples.

        # Attempt to set part of the terminal pallette (this does not work
        # on all terminals.)  The changes are sent as a single escape
        # sequence so they should all take effect at the same time.
        # 
        # 0 <= index < 256 (some terminals will only have 16 or 88 colors)
        # 0 <= red, green, blue < 256

        modify = [entries.each{|_|
          index, red, green, blue = *_
          "%d;rgb:%02x/%02x/%02x" % [index, red, green, blue]
        }]

        seq = @_term_output_file.write("\x1b]4;"+modify.join(';')+"\x1b\\")
        @_term_output_file.flush
    end

    # shortcut for creating an AttrSpec with this screen object's
    # number of colors
    def AttrSpec(fg, bg, colors=@colors) 
      DisplayCommon::AttrSpec.new(fg, bg, colors)
    end
end

end
