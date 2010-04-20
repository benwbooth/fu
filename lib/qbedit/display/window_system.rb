require 'qbedit/display/canvas'

class Window
  attr_accessor :pref_dim
  attr_accessor :layout_mgr
  attr_accessor :parent
  attr_accessor :children

  def initialize(parent=nil, 
                 children=[], 
                 layout_mgr=LayoutManager.new)
    @parent = parent
    @children = []
    @children += children || []
    @layout_mgr = layout_mgr
    @pref_dim = [0,0,0,0]
  end

  def add(w)
    @children << w
  end

  def remove(w)
    @children.delete(w)
  end

  def move(w, d)
    @layout_mgr.move(w, d)
  end

  def dim
    @parent.child_dim(self)
  end

  def child_dim(w)
    @layout_mgr.dim(w)
  end

  def redraw(canvas, d)
    #noop
  end

  def drawable_region
    d = dim
    parent_dim = [0,0] + @parent.dim[2..3]
    drawable = intersect(d, parent_dim)
    
    buf = buffer(drawable[2], drawable[3], true)
    sibs = @parent.children
    top_sibs = sibs[sibs.find_index(self)..sibs.length-1]
    top_sibs.each do |sib|
      fill(buf, translate(sib.dim, d), false)
    end

    dr = [0,0,0,0]
    found = false
    [0..drawable[2]].each do |x|
      [0..drawable[3]].each do |y|
        if buf[y][x]
          dr[0] = x
          found = true
          break
        end
      end
      break if found
    end
    found = false
    [0..drawable[3]].each do |y|
      [0..drawable[2]].each do |x|
        if buf[y][x]
          dr[1] = y
          found = true
          break
        end
      end
      break if found
    end
    found = false
    [drawable[2].downto 0].each do |x|
      [0..drawable[3]].each do |y|
        if buf[y][x]
          dr[2] = x-dr[0]+1
          found = true
          break
        end
      end
      break if found
    end
    found = false
    [drawable[3].downto 0].each do |y|
      [0..drawable[2]].each do |x|
        if buf[y][x]
          dr[3] = y-dr[1]+1
          found = true
          break
        end
      end
      break if found
    end
    dr
  end

  # utility methods

  # find the intersected rectangle of two rectangles
  def intersect(dim1=[0,0,0,0], dim2=[0,0,0,0])
    if (dim1[0] <= dim2[0]+dim2[2] && dim2[0] <= dim1[0]+dim1[2] && 
        dim1[1] <= dim2[1]+dim2[3] && dim2[1] <= dim1[1]+dim1[3])
      [[dim1[0], dim2[0]].max, [dim1[1], dim2[1]].max, 
       [dim1[2], dim2[2]].min, [dim1[3], dim2[3]].min]
    else
      nil
    end
  end

  # create a 2d array buffer and fill with a default value
  def buffer(w=0, h=0, val=nil)
    [0..h-1].map {|i| [0..w-1].map {|j| val}}
  end

  # fill a rectangular region of a buffer with a value
  def fill(buf=[], dim=[0,0,0,0], val=nil) 
    [[dim[1],0].max..[dim[1]+dim[3],buf.length-1].min].each do |y|
      [ [dim[0],0].max..
        [dim[0]+dim[2], buf.length>0 ? buf[0].length-1 : dim[0]+dim[2]].min].each do |x|
        buf[y][x] = val
      end
    end
  end

  def translate(dim1=[0,0,0,0], dim2=[0,0,0,0])
    [dim1[0]-dim2[0], dim1[1]-dim2[1], dim1[2], dim1[3]]
  end
end

class RootWindow < Window
  attr_accessor :update_mgr

  def initialize(parent=nil, 
                 children=[], 
                 layout_mgr=LayoutManager.new, 
                 update_mgr=UpdateManager.new(self))
    super
    @update_mgr = update_mgr
  end

  def dim
  end
end

class LayoutManager
  attr_accessor :window

  def initialize(window)
    @window = window
  end

  def dim(child)
    child.pref_dim if @root.children.include? child
  end

  def move(child, dim)
    old_dim = child.dim
    child.pref_dim(dim) if @root.children.include? child
  end
end

class UpdateManager
  attr_accessor :root

  def initialize(root=RootWindow.new)
    @root = root
    @canvas = Canvas.new
  end
end

class WindowSystem
  def initialize
    @c = Canvas.new
    root = Window.new
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
  require 'qbedit/display/curses_display'
  w=WindowSystem.new
  # screen = CursesDisplay::Screen.new
  # screen.start
  # m=MainLoop::MainLoop.new(w, [], screen)

  m=MainLoop::MainLoop.new(w)
  m.run
end

