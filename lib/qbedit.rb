#!/usr/bin/ruby1.9.1

require 'rubygems'
require 'ncurses'
require 'getoptlong'
require 'rdoc/usage'

require 'qbedit/display/raw_display'

class Qbedit
  def initialize
  end
  def command_line
    opts = GetoptLong.new(
      ['--help', '-h', GetoptLong::NO_ARGUMENT],
    )
  end
  def demo
    
  end
end

begin
  # instantiate main object
  qbedit = Qbedit.new
  qbedit.command_line

  # perform screen initialization
  scr = Ncurses.initscr
  Ncurses.raw
  Ncurses.noecho
  Ncurses.keypad(scr, true)
  qbedit.demo
  # start main event loop
  qbedit.event_loop
ensure
  # restore screen
  Ncurses.echo
  Ncurses.noraw
  Ncurses.nl
  Ncurses.endwin
end

exit 0

