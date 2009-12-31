# Urwid main loop code
#    Copyright (C) 2004-2009  Ian Ward
#    Copyright (C) 2008 Walter Mundt
#    Copyright (C) 2009 Andrew Psaltis
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

require 'qbedit/display/util'

$VERBOSE=true
module MainLoop

class ExitMainLoop < Exception
end

# Simple main loop implementation with a single screen.
# 
# widget -- topmost widget used for painting the screen, 
#     stored as widget, may be modified
# palette -- initial palette for screen
# screen -- screen object or nil to use raw_display.Screen,
#     stored as screen
# handle_mouse -- true to process mouse events, passed to
#     screen
# input_filter -- a function to filter input before sending
#     it to widget, called from input_filter
# unhandled_input -- a function called when input is not
#     handled by widget, called from unhandled_input
# event_loop -- if screen supports external an event loop it
#     may be given here, or leave as nil to use 
#     SelectEventLoop, stored as event_loop
# 
# This is a standard main loop implementation with a single
# screen.  
# 
# The widget passed must be a selectable box widget.  It will
# be sent input with keypress() and mouse_event() and is
# expected to be able to handle it.
# 
# raw_display.Screen is the only screen type that currently
# supports external event loops.  Other screen types include
# curses_display.Screen, web_display.Screen and
# html_fragment.HtmlGenerator.
class MainLoop
    def initialize(widget, palette=[], screen=nil, 
              handle_mouse=true, _input_filter=nil, _unhandled_input=nil,
              event_loop=nil)
        @widget = widget
        @handle_mouse = handle_mouse
        
        if !screen
            require 'qbedit/display/raw_display'
            screen = RawDisplay::Screen.new
            screen.start
        end

        if palette && palette.length>0
            screen.register_palette(palette)
        end

        @screen = screen
        @screen_size = nil

        @unhandled_input = _unhandled_input
        @input_filter = _input_filter

        if !screen.respond_to?('get_input_descriptors') && !event_loop.nil?
            raise NotImplementedError.new("screen object passed "+
                "%r does not support external event loops" % [screen])
        end
        if event_loop.nil?
            event_loop = SelectEventLoop.new
        end
        @event_loop = event_loop

        @input_timeout = nil
    end

    # Schedule an alarm in sec seconds that will call
    # callback(main_loop, user_data) from the within the run()
    # function.
    #
    # sec -- floating point seconds until alarm
    # callback -- callback(main_loop, user_data) callback function
    # user_data -- object to pass to callback
    def set_alarm_in(sec, callback, user_data=nil)
        def cb
            callback.call(user_data)
            draw_screen()
        end
        return @event_loop.alarm(sec, cb)
    end

    # Schedule at tm time that will call 
    # callback(main_loop, user_data) from the within the run()
    # function.
    #
    # Returns a handle that may be passed to remove_alarm()
    #
    # tm -- floating point local time of alarm
    # callback -- callback(main_loop, user_data) callback function
    # user_data -- object to pass to callback
    def set_alarm_at(tm, callback, user_data=nil)
        def cb
            callback.call(user_data)
            draw_screen()
        end
        return @event_loop.alarm(tm - Time.now.to_f, cb)
    end

    # Remove an alarm. 
    # 
    # Return true if the handle was found, false otherwise.
    def remove_alarm(handle)
        return @event_loop.remove_alarm(handle)
    end
    
    # Start the main loop handling input events and updating 
    # the screen.  The loop will continue until an ExitMainLoop 
    # exception is raised.  
    # 
    # This function will call screen.run_wrapper() if screen.start() 
    # has not already been called.
    #
    # >>> w = _refl("widget")   # _refl prints out function calls
    # >>> w.render_rval = "fake canvas"  # *_rval is used for return values
    # >>> scr = _refl("screen")
    # >>> scr.get_input_descriptors_rval = [42]
    # >>> scr.get_cols_rows_rval = (20, 10)
    # >>> scr.started = true
    # >>> evl = _refl("event_loop")
    # >>> ml = MainLoop.new(w, [], scr, event_loop=evl)
    # >>> ml.run()    # doctest:+ELLIPSIS
    #
    # screen.set_mouse_tracking()
    # screen.get_cols_rows()
    # widget.render((20, 10), focus=true)
    # screen.draw_screen((20, 10), 'fake canvas')
    # screen.get_input_descriptors()
    # event_loop.watch_file(42, <bound method ...>)
    # event_loop.run()
    # >>> scr.started = false
    # >>> ml.run()    # doctest:+ELLIPSIS
    # screen.run_wrapper(<bound method ...>)
    def run
        begin
            if @screen.started
                _run()
            else
                @screen.run_wrapper(_run)
            end
        rescue ExitMainLoop
        end
    end
    
    def _run
        if @handle_mouse
            @screen.set_mouse_tracking()
        end

        draw_screen()

        if !@screen.respond_to? 'get_input_descriptors'
            return run_screen_event_loop()
        end

        # insert our input descriptors
        fds = @screen.get_input_descriptors()
        fds.each do |fd|
            @event_loop.watch_file(fd, lambda {update})
        end

        @event_loop.run()
    end

    # >>> w = _refl("widget")
    # >>> w.render_rval = "fake canvas"
    # >>> scr = _refl("screen")
    # >>> scr.get_cols_rows_rval = (15, 5)
    # >>> scr.get_input_nonblocking_rval = 1, ['y'], [121]
    # >>> evl = _refl("event_loop")
    # >>> ml = MainLoop(w, [], scr, event_loop=evl)
    # >>> ml._input_timeout = "old timeout"
    # >>> ml._update()    # doctest:+ELLIPSIS
    # event_loop.remove_alarm('old timeout')
    # screen.get_input_nonblocking()
    # event_loop.alarm(1, <function ...>)
    # screen.get_cols_rows()
    # widget.keypress((15, 5), 'y')
    # widget.render((15, 5), focus=true)
    # screen.draw_screen((15, 5), 'fake canvas')
    # >>> scr.get_input_nonblocking_rval = nil, [("mouse press", 1, 5, 4)
    # ... ], []
    # >>> ml._update()
    # screen.get_input_nonblocking()
    # widget.mouse_event((15, 5), 'mouse press', 1, 5, 4, focus=true)
    # widget.render((15, 5), focus=true)
    # screen.draw_screen((15, 5), 'fake canvas')
    def update(timeout=false)
        if !@input_timeout.nil? && !timeout
            # cancel the timeout, something else triggered the update
            @event_loop.remove_alarm(@input_timeout)
        end
        @input_timeout = nil

        max_wait, keys, raw = @screen.get_input_nonblocking()
        
        if !max_wait.nil?
            # if get_input_nonblocking wants to be called back
            # make sure it happens with an alarm
            @input_timeout = @event_loop.alarm(max_wait, 
                lambda {update(true)} ) 
        end

        keys = input_filter(keys, raw)

        if keys && keys.length>0
            process_input(keys)
            if keys.include? 'window resize'
                @screen_size = nil
            end
        end

        draw_screen()
    end

    # This method is used when the screen does not support using
    # external event loops.

    # The alarms stored in the SelectEventLoop in event_loop 
    # are modified by this method.
    def run_screen_event_loop
        next_alarm = nil

        while true
            draw_screen()

            if !next_alarm && @event_loop.alarms
                next_alarm = @alarms.shift
            end

            keys = nil
            while !keys
                if next_alarm
                    sec = [0, next_alarm[0] - Time.now.to_f].max
                    @screen.set_input_timeouts(sec)
                else
                    @screen.set_input_timeouts(nil)
                end
                keys, raw = screen.get_input(true)
                if !keys && next_alarm
                    sec = next_alarm[0] - Time.now.to_f
                    if sec <= 0
                        break
                    end
                end
            end

            keys = input_filter(keys, raw)
            
            if keys
                process_input(keys)
            end
            
            while next_alarm
                sec = next_alarm[0] - Time.now.to_f
                if sec > 0
                    break
                end
                tm, callback, user_data = next_alarm
                callback.call(user_data)
                
                if @alarms
                    next_alarm = @event_loop.alarms.shift
                else
                    next_alarm = nil
                end
            end
            
            if keys.include? 'window resize'
                @screen_size = nil
            end
        end
    end

    # This function will pass keyboard input and mouse events
    # to widget.  This function is called automatically
    # from the run() method when there is input, but may also be
    # called to simulate input from the user.

    # keys -- list of input returned from screen.get_input()
    # 
    # >>> w = _refl("widget")
    # >>> scr = _refl("screen")
    # >>> scr.get_cols_rows_rval = (10, 5)
    # >>> ml = MainLoop(w, [], scr)
    # >>> ml.process_input(['enter', ('mouse drag', 1, 14, 20)])
    # screen.get_cols_rows()
    # widget.keypress((10, 5), 'enter')
    # widget.mouse_event((10, 5), 'mouse drag', 1, 14, 20, focus=true)
    def process_input(keys)
        if !@screen_size
            @screen_size = screen.get_cols_rows()
        end

        keys.each do |k|
            if Util.is_mouse_event(k)
                event, button, col, row = k
                if @widget.mouse_event(@screen_size, 
                    event, button, col, row, true )
                    k = nil
                end
            else
                k = @widget.keypress(@screen_size, k)
            end
            if k
                unhandled_input(k)
            end
        end
    end

    # This function is passed each all the input events and raw
    # keystroke values.  These values are passed to the
    # input_filter function passed to the constructor.  That
    # function must return a list of keys to be passed to the
    # widgets to handle.  If no input_filter was defined this
    # implementation will return all the input events.
    #
    # input -- keyboard or mouse input
    def input_filter(keys, raw)
        if @input_filter
            return @input_filter.call(keys, raw)
        end
        return keys
    end

    # This function is called with any input that was not handled
    # by the widgets, and calls the unhandled_input function passed
    # to the constructor.  If no unhandled_input was defined then
    # the input will be ignored.
    #
    # input -- keyboard or mouse input
    def unhandled_input(input)
        if @unhandled_input
            return @unhandled_input.call(input)
        end
    end

    # Renter the widgets and paint the screen.  This function is
    # called automatically from run() but may be called additional 
    # times if repainting is required without also processing input.
    def draw_screen
        if !@screen_size
            @screen_size = @screen.get_cols_rows()
        end

        canvas = @widget.render(@screen_size, true)
        @screen.draw_screen(@screen_size, canvas)
    end
end

# Event loop based on select.select()
# 
# >>> import os
# >>> rd, wr = IO.pipe()
# >>> evl = SelectEventLoop.new
# >>> def step1()
# ...     print "writing"
# ...     os.write(wr, "hi")
# >>> def step2()
# ...     print os.read(rd, 2)
# ...     raise ExitMainLoop
# >>> handle = evl.alarm(0, step1)
# >>> handle = evl.watch_file(rd, step2)
# >>> evl.run()
# writing
# hi
class SelectEventLoop
    def initialize
        @alarms = []
        @watch_files = {}
    end

    # Call callback() given time from from now.  No parameters are
    # passed to callback.
    #
    # Returns a handle that may be passed to remove_alarm()
    #
    # seconds -- floating point time to wait before calling callback
    # callback -- function to call from event loop
    def alarm(seconds, callback)
        tm = Time.now.to_f + seconds
        @alarms << [tm, callback]
        @alarms.sort! {|a,b| a[0] <=> b[0]}
        [tm, callback]
    end

    # Remove an alarm.
    #
    # Returns true if the alarm exists, false otherwise
    #
    # >>> evl = SelectEventLoop.new
    # >>> handle = evl.alarm(50, lambda: nil)
    # >>> evl.remove_alarm(handle)
    # true
    # >>> evl.remove_alarm(handle)
    # false
    def remove_alarm(handle)
        begin
            @alarms.delete(handle)
            return true
        rescue ValueError
            return false
        end
    end

    # Call callback() when fd has some data to read.  No parameters
    # are passed to callback.
    #
    # Returns a handle that may be passed to remove_watch_file()
    #
    # fd -- file descriptor to watch for input
    # callback -- function to call when input is available
    def watch_file(fd, callback)
        @watch_files[fd] = callback
        return fd
    end

    # Remove an input file.
    #
    # Returns true if the input file exists, false otherwise
    #
    # >>> evl = SelectEventLoop()
    # >>> handle = evl.watch_file(5, lambda: nil)
    # >>> evl.remove_watch_file(handle)
    # true
    # >>> evl.remove_watch_file(handle)
    # false
    def remove_watch_file(handle)
        if @watch_files.include? handle
            @watch_files.delete(handle)
            return true
        end
        return false
    end

    # Start the event loop.  Exit the loop when any callback raises
    # an exception.  If ExitMainLoop is raised, exit cleanly.
    #
    # >>> import os
    # >>> rd, wr = os.pipe()
    # >>> os.write(wr, "data") # something to read from rd
    # 4
    # >>> evl = SelectEventLoop()
    # >>> def say_hello()
    # ...     print "hello"
    # >>> def exit_clean()
    # ...     print "clean exit"
    # ...     raise ExitMainLoop
    # >>> def exit_error()
    # ...     1/0
    # >>> handle = evl.alarm(0.0625, exit_clean)
    # >>> handle = evl.alarm(0, say_hello)
    # >>> evl.run()
    # hello
    # clean exit
    # >>> handle = evl.watch_file(rd, exit_clean)
    # >>> evl.run()
    # clean exit
    # >>> evl.remove_watch_file(handle)
    # true
    # >>> handle = evl.alarm(0, exit_error)
    # >>> evl.run()
    # Traceback (most recent call last)
    #     ...
    # ZeroDivisionError: integer division or modulo by zero
    # >>> handle = evl.watch_file(rd, exit_error)
    # >>> evl.run()
    # Traceback (most recent call last):
    #     ...
    # ZeroDivisionError: integer division or modulo by zero
    def run
        begin
            while true
                begin
                    _loop()
                rescue
                    raise
                end
            end
        rescue ExitMainLoop
        end
    end

    def _loop
        fds = @watch_files.keys
        if @alarms && @alarms.length>0
            tm = @alarms[0][0]
            timeout = [0, tm - Time.now.to_f].max
            ready, w, err = IO.select(fds, [], fds, timeout)
        else
            tm = nil
            ready, w, err = IO.select(fds, [], fds)
        end
        ready ||= []
        w ||= []
        err ||= []

        if !ready && !tm.nil?
            # must have been a timeout
            tm, alarm_callback = @alarms.shift
            alarm_callback
        end

        ready.each do |fd|
            @watch_files[fd].call
        end
    end
end

end

