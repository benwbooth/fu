require 'ncursesw'

module Test
  def self.mytest()
    puts "Running Ncurses test..."

    @s = Ncurses.initscr() # instead of init_screen
    Ncurses.start_color() # instead of init_screen

    #new test
    Ncurses.curs_set(1)
    Ncurses.endwin()


    puts Ncurses.COLOR_PAIRS()
    puts Ncurses.COLORS()
    Ncurses.use_default_colors()
    Ncurses.halfdelay(100)
   
    Ncurses.meta(@s, 1) # add the window
    @s.nodelay(0) # does not exist - non-blocking getch - might need this
    puts Ncurses.getmaxyx(@s, [], []) #does not exist - use maxx() and maxy()

    # @s.clear()
    @s.refresh()
    Ncurses.keypad(@s, 0)
    @s.getch()
    puts Ncurses.getstr("")
    @s.clrtoeol()
    @s.addstr("hello")
    @s.refresh()
    @s.attrset( 0 )
    @s.move( 0, 0 )
    @s.addch( 0x400000)

    puts Ncurses::COLOR_BLACK
    puts Ncurses::COLOR_RED
    puts Ncurses::COLOR_GREEN
    puts Ncurses::COLOR_YELLOW
    puts Ncurses::COLOR_BLUE
    puts Ncurses::COLOR_MAGENTA
    puts Ncurses::COLOR_CYAN
    puts Ncurses::COLOR_WHITE

    Ncurses.init_pair(1,0,0)
    Ncurses.mousemask(0, [])
    puts Ncurses.has_colors?
    Ncurses.noecho()
    Ncurses.echo()
    puts Ncurses::A_BOLD
    puts Ncurses::A_STANDOUT
    puts Ncurses::A_UNDERLINE
    Ncurses.cbreak()
    Ncurses.doupdate()
    Ncurses.getmouse(Ncurses::MEVENT.new)
    puts Ncurses::BUTTON_SHIFT
    puts Ncurses::BUTTON_ALT
    puts Ncurses::BUTTON_CTRL
    puts Ncurses::BUTTON1_PRESSED
    puts Ncurses::BUTTON2_PRESSED
    puts Ncurses::BUTTON3_PRESSED
    puts Ncurses::BUTTON4_PRESSED
    puts Ncurses::BUTTON1_RELEASED
    puts Ncurses::BUTTON2_RELEASED
    puts Ncurses::BUTTON3_RELEASED
    puts Ncurses::BUTTON4_RELEASED


  end

  mytest()
end
