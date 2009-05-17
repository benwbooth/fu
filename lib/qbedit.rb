#!/usr/bin/ruby

require 'ncurses'
require 'getoptlong'
require 'rdoc/usage'

require 'qbedit/event'

class Qbedit
  def initialize()
  end
  def command_line()
    opts = GetoptLong.new(
      ['--help', '-h', GetoptLong::NO_ARGUMENT],
    )
  end
end

begin

  # instantiate main object
  qbedit = Qbedit.new()
  qbedit.command_line();

  # perform screen initialization
  scr = Ncurses.initscr()
  Ncurses.raw()
  Ncurses.noecho()
  Ncurses.keypad(scr, true)

  # load configuration files
  require '/etc/qbeditrc' if File.exist?('/etc/qbeditrc')
  require '~/.qbeditrc' if File.exist?('~/.qbeditrc')

  # start main event loop
  qbedit.event_loop()

ensure
  # restore screen
  Ncurses.echo()
  Ncurses.noraw()
  Ncurses.nl()
  Ncurses.endwin()
end

