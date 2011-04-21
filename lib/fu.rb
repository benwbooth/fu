#!/usr/bin/ruby1.9.1

require 'rubygems'
require 'ncursesw'
require 'optparse'

require 'fu/display/raw_display'

class Fu
  def initialize
  end
  def command_line
  end
  def demo
  end
  def event_loop
  end
end

begin
  # instantiate main object
  fu = Fu.new
  fu.command_line

  # perform screen initialization
  scr = Ncurses.initscr
  Ncurses.raw
  Ncurses.noecho
  Ncurses.keypad(scr, true)
  fu.demo
  # start main event loop
  fu.event_loop
ensure
  # restore screen
  Ncurses.echo
  Ncurses.noraw
  Ncurses.nl
  Ncurses.endwin
end

