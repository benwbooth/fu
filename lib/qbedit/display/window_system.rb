require 'qbedit/display/canvas'

class Widget
end

class WindowSystem < Widget
  def initialize
    @c = Canvas.new
  end

  def mouse_event(size, event, button, x, y, focus)
    @c.draw("mouse event!\n")
    puts "mouse event!\n"
  end

  def keypress(size, key)
    @c.draw("keyboard event!\n")
    puts "keyboard event!\n"
  end

  def render(size, focus=false)
    @c
  end
end

if __FILE__ == $0
  require 'qbedit/display/main_loop'
  w=WindowSystem.new
  m=MainLoop::MainLoop.new(w)
  m.run
end

