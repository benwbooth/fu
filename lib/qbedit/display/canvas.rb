require 'stringio'
require 'qbedit/display/display_common'
require 'qbedit/display/raw_display'

class Canvas
  attr_accessor :content
  attr_accessor :cursor
  attr_reader :rows
  attr_reader :cols
  attr_reader :colors

  def self._instance_exec(&block)
    instance_exec(&block)
  end

  class Op
    attr_accessor :children
    class Pop
      def self.pattern  
        /(?!)/ # this regex always fails
      end
      def self.parse(str,offset=0)
        p = Regexp.new('\\A(?:'+pattern.source+')', pattern.options)
        match = p.match(str[offset..-1])
        match && [self.new(*match.captures), offset+match.end(0)]
      end
      def to_s
        ''
      end
    end
    def self.pattern 
      /(?!)/ # this regex always fails
    end
    def initialize(&block)
      @children = []
      if block_given?
        children = Canvas._instance_exec(&block)
        if children
          @children = children.class == Array ? children : [children]
        end
      end
    end
    def to_s
      ''
    end
    def self.parse(str,offset=0)
      p = Regexp.new('\\A(?:'+pattern.source+')', pattern.options)
      match = p.match(str[offset..-1])
      match && [self.new(*match.captures), offset+match.end(0)]
    end
  end

  class FgColor < Op
    class Pop < Op::Pop
      def self.pattern 
        /\[\s*f(?:g)?\s*\]/i
      end
      def to_s
        '[fg]'
      end
    end
    def self.pattern 
      /\[\s*f(?:g)?\s+([^\s\]]+)\s*\]/i
    end
    def initialize(color)
      super()
      @color = color
    end
    def to_s
      '[fg %s]' % @color.to_s
    end
    def inspect
      @color.to_s
    end
  end
  def self.fg(*args, &block)
    FgColor.new(*args, &block)
  end

  class BgColor < Op
    class Pop < Op::Pop
      def self.pattern 
        /\[\s*b(?:g)?\s*\]/i
      end
      def to_s
        '[bg]'
      end
    end
    def self.pattern
      /\[\s*b(?:g)?\s+([^\s\]]+)\s*\]/i
    end
    def initialize(color)
      super()
      @color = color
    end
    def to_s
      '[bg %s]' % @color.to_s
    end
    def inspect
      @color.to_s
    end
  end
  def self.bg(*args, &block)
    BgColor.new(*args, &block)
  end

  class Color < Op
    attr_accessor :fg
    attr_accessor :bg
    class Pop < Op::Pop
      def self.pattern 
        /\[c(?:o(?:l(?:o(?:r)?)?)?)?\]/
      end
      def to_s
        '[color]'
      end
    end
    def self.pattern 
      /\[\s*c(?:o(?:l(?:o(?:r)?)?)?)?\s+([^\s\]]+)(?:\s+([^\s\]]+))?\s*\]/i
    end
    def initialize(fg=nil, bg=nil)
      super()
      fg, bg = nil, fg if fg == '_'
      bg = nil if bg == '_'
      @fg, @bg = fg, bg
    end
    def to_s
      if @fg.nil? && @bg.nil?
        '[color _]' % [@bg.to_s]
      elsif @bg.nil? && !@fg.nil?
        '[color %s]' % [@fg.to_s]
      elsif @fg.nil? && !@bg.nil?
        '[color _ %s]' % [@bg.to_s]
      else
        '[color %s %s]' % [@fg.to_s, @bg.to_s]
      end
    end
  end
  def self.color(*args, &block)
    Color.new(*args, &block)
  end

  class Pos < Op
    attr_accessor :x
    attr_accessor :y
    class Pop < Op::Pop
      def self.pattern
        /\[\s*p(?:o(?:s)?)?\s*\]/i
      end
      def to_s
        '[pos]'
      end
    end
    def self.pattern
      /\[\s*p(?:o(?:s)?)?\s+([^\s\]]+)(?:\s+([^\s\]]+))?\s*\]/i
    end
    def initialize(x=nil,y=nil)
      super()
      x, y = nil, x if x == '_'
      y = nil if y == '_'
      @x, @y = x, y
    end
    def to_s
      if @x.nil? && @y.nil?
        '[pos _]' % [@y.to_s]
      elsif @y.nil? && !@x.nil?
        '[pos %s]' % [@x.to_s]
      elsif @x.nil? && !@y.nil?
        '[pos _ %s]' % [@y.to_s]
      else
        '[pos %s %s]' % [@x.to_s, @y.to_s]
      end
    end
  end
  def self.pos(*args, &block)
    Pos.new(*args, &block)
  end

  class Bold < Op
    class Pop < Op::Pop
      def self.pattern
        /\*|\[\s*b(?:o(?:l(?:d)?)?)?\s*\]/i
      end
      def to_s
        '*'
      end
    end
    def self.pattern
      /\*|\[\s*b(?:o(?:l(?:d)?)?)?\s*\]/i
    end
    def to_s
      '*'
    end
    def inspect
      'bold'
    end
  end
  def self.bold(*args, &block)
    Bold.new(*args, &block)
  end
  
  class Underline < Op
    class Pop < Op::Pop
      def self.pattern
        /_|\[\s*u(?:n(?:d(?:e(?:r(?:l(?:i(?:n(?:e)?)?)?)?)?)?)?)?\s*\]/i
      end
      def to_s
        '_'
      end
    end
    def self.pattern
      /_|\[\s*u(?:n(?:d(?:e(?:r(?:l(?:i(?:n(?:e)?)?)?)?)?)?)?)?\s*\]/i
    end
    def to_s
      '_'
    end
    def inspect
      'underline'
    end
  end
  def self.underline(*args, &block)
    Underline.new(*args, &block)
  end

  class Standout < Op
    class Pop < Op::Pop
      def self.pattern
        /\+|\[\s*s(?:t(?:a(?:n(?:d(?:o(?:u(?:t)?)?)?)?)?)?)?\s*\]/i
      end
      def to_s
        '+'
      end
    end
    def self.pattern 
      /\+|\[\s*s(?:t(?:a(?:n(?:d(?:o(?:u(?:t)?)?)?)?)?)?)?\s*\]/i
    end
    def to_s
      '+'
    end
    def inspect
      'standout'
    end
  end
  def self.standout(*args, &block)
    Standout.new(*args, &block)
  end

  class Escape < Op
    def self.pattern
      /\\(\\|\[|\]|\*|\+|_)/i
    end
    def self.parse(str,offset=0)
      p = Regexp.new('\\A(?:'+self.pattern.source+')', self.pattern.options)
      match = p.match(str[offset..-1])
      match && [match[1], offset+match.end(0)]
    end
  end
  class Text < Op
    def self.parse(str,offset=0)
      str.length > offset && [str[offset], offset+1]
    end
  end

  def initialize(content=[], cursor=[0,0], colors=256)
    @rows = 0
    @cols = 0
    @colors = colors
    @content = content
    @cursor = cursor
  end

  def rowcol
    [@rows, @cols]
  end

  def parse(text='', offset=[0], parent=Text.new)
    text.join!("\n") if 
      text.class == Array && text[0] && text[0].class == String
    offset = [offset] if offset.class != Array

    children = parent.children
    while offset[0] < text.length
      match = nil

      [ Escape, 
        parent.class::Pop,
        Pos, Standout, Underline, Bold, FgColor, BgColor, Color, 
        Text 
      ].each {|rule| 
        match, new_offset = rule.parse(text, offset[0])
        if match
          offset[0] = new_offset
          case match
            when String
              if children[-1] && children[-1].class == String
                children[-1] += match
              else
                children << match
              end
            when parent.class::Pop
              return parent
            else
              children << parse(text, offset, match)
          end
          break
        end
      }
      if !match
        raise 'ParseError: '+match.to_s
      end
    end
    parent
  end

  def escape(str)
    str.gsub(/\\|\[|\]|\*|\+|_/) { |match| '\\'+match[0] }
  end

  def serialize(tree, str='')
    tree = [tree] if tree.class != Array
    tree.each do |node| 
      case node
        when String
          str += escape(node)
        when Text, Escape
          str += serialize(node.children)
        else
          str += node.to_s + 
            serialize(node.children) + 
            node.class::Pop.new.to_s
      end
    end
    str
  end

  def flatten(tree)
    tree = [tree] if tree.class != Array
    ops = []
    tree.each do |node| 
      case node
        when String
          ops << node 
        when Text, Escape
          ops += flatten(node.children)
        else
          ops += [node, *flatten(node.children), node.class::Pop.new]
      end
    end
    ops
  end

  def draw(text='', &block)
    stacks = {
      fgcolor: [],
      bgcolor: [],
      pos: [],
      bold: [],
      underline: [],
      standout: []
    }

    text.join!("\n") if 
      text.class == Array && text[0] && text[0].class == String
    text = [parse(text)] if text.class == String
    if block_given?
      more = Canvas._instance_exec(&block)
      more = [more] if more.class != Array
      text += more
    end
    text = flatten(text)

    line_start = @cursor*1
    text.each_with_index {|op,i| 
      case op
        when String 
          str=''
          op.chars do |c| 
            str += c
            width = StrUtil.calc_width(str, 0, str.length)
            if  width > 0
              str, cs = Util.apply_target_encoding(str)
              if str == "\n"
                # process newlines
                @cursor = line_start
                @cursor[1] += 1
                line_start = @cursor*1
              else
                # expand the content grid if necessary
                if @cursor[1] >= @rows
                  @content += Array.new(@cursor[1]+1-@rows) {
                    Array.new(@cols) {[nil, nil, '']} 
                  }
                  @rows = @content.length
                  @cols = @content[0].length if @content[0]
                end
                if @cursor[0] >= @cols
                  @content.each_index{ |i| 
                    if @cursor[0] >= @content[i].length
                      @content[i] += Array.new(@cursor[0]+1-@content[i].length) {
                        [nil, nil, '']
                      }
                    end
                  }
                  @cols = @content[0].length if @content[0]
                end

                # draw on the screen
                fg = [stacks[:fgcolor][-1],
                  stacks[:bold][-1],
                  stacks[:underline][-1],
                  stacks[:standout][-1],
                ].grep(lambda {|_| _}) {|_| _.inspect}.join(',')

                bg = stacks[:bgcolor][-1] ? stacks[:bgcolor][-1].inspect : ''

                @content[@cursor[1]][@cursor[0]] = 
                  [DisplayCommon::AttrSpec.new(fg, bg, @colors), cs[0][0], str]
                @cursor[0] += width
              end
              str=''
            end
          end
        when FgColor
          stacks[:fgcolor] << op
        when FgColor::Pop
          stacks[:fgcolor].pop
        when BgColor
          stacks[:bgcolor] << op
        when BgColor::Pop
          stacks[:bgcolor] << op
        when Color
          stacks[:fgcolor] << FgColor.new(op.fg) {op.children}
          stacks[:bgcolor] << BgColor.new(op.bg) {op.children}
        when Color::Pop
          stacks[:fgcolor].pop
          stacks[:bgcolor].pop
        when Pos
          if !op.x.nil?
            @cursor[0] = ['-','+'].include?(op.x.to_s[0]) ? 
              @cursor[0]+op.x.to_i : op.x.to_i
          end
          if !op.y.nil?
            @cursor[1] = ['-','+'].include?(op.y.to_s[0]) ? 
              @cursor[1]+op.y.to_i : op.y.to_i
          end
          stacks[:pos] << @cursor*1
          line_start = @cursor*1
        when Pos::Pop
          @cursor = stacks[:pos].pop
          line_start = @cursor*1
        when Bold
          stacks[:bold] << op
        when Bold::Pop
          stacks[:bold].pop
        when Underline
          stacks[:underline] << op
        when Underline::Pop
          stacks[:underline].pop
        when Standout
          stacks[:standout] << op
        when Standout::Pop
          stacks[:standout].pop
        else
          raise "Could not handle op "+op.to_s+", "+op.class.to_s
      end
    }
  end
end

if __FILE__ == $0
  c=Canvas.new
  #c.draw("[fg green]_*abc*_d[fg]ef  \n\n[color white darkblue]hello[color] there")
  a=Canvas::Text.new {[
     pos(0,'+1') {[
      fg('orange') {[bold {'abc'}, 'd']},"ef  \n\n",color('black','yellow') {'hello'}, " there\n\n", standout {"still here"}
     ]}
  ]}
  s = c.serialize(a)
  c.draw(s)

  out = StringIO.new
  rd = RawDisplay::Screen.new(out)
  rd.start
  rd.draw_screen(c.rowcol, c)
  puts out.string
  rd.stop
end

