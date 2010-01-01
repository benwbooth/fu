require 'qbedit/display/canvas'

class Widget
end

class WindowSystem < Widget
  def initialize
    @c = Canvas.new
  end

  def mouse_event(size, event, button, x, y, focus)
    @c.draw {'mouse event: '+[size,event,button,x,y,focus].inspect+"\n"}
  end

  def keypress(size, key)
    @c.draw {'keyboard event: '+[size,key].inspect+"\n"}
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

