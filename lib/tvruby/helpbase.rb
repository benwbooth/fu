module TVRuby::Helpbase

  MagicHeader = 0x46484246

  CHelpViewer = "\x06\x07\x08"
  CHelpWindow = "\x80\x81\x82\x83\x84\x85\x86\x87"

  #
  # Part of the help system.
  # @short Part of the help system
  # 
  class TParagraph
  public
    def initialize
    end

    attr_accessor :next
    attr_accessor :wrap
    attr_accessor :size
    attr_accessor :text
  end

  # 
  # Part of the help system.
  # @short Part of the help system
  # 
  class TCrossRef
  public
      def initialize
      end
      attr_accessor :ref
      attr_accessor :offset
      attr_accessor :length
  end

  #
  # Part of the help system.
  # @short Part of the help system
  # 
  class THelpTopic < TObject
  public
      def initialize
        @paragraphs = nil
        @crossRefs = []
        @width = 0
        @lastOffset = 0
        @lastLine = nil
        @lastParagraph = 0
      end

      def addCrossRef( ref )
        @crossRefs << ref
      end

      def addParagraph( p )
        pp = nil
        back = nil

        if @paragraphs == 0
            @paragraphs = p
        else
          pp = @paragraphs
          back = pp
          while !pp.nil?
              back = pp
              pp = pp.next
          end
          back.next = p
        end
        p.next = nil
      end

      def getCrossRef(i, loc)
        oldOffset=0
        curOffset=0
        paraOffset=0
        line=0
        crossRefPtr = @crossRefs + i
        offset = crossRefPtr.offset
        p = @paragraphs

        while paraOffset + curOffset < offset
          lbuf = ' '*256
          oldOffset = paraOffset + curOffset
          wrapText(p.text, p.size, curOffset, p.>wrap, lbuf, lbuf.length)
          line += 1
          if curOffset >= p.size
            paraOffset += p->size
            p = p.next
            curOffset = 0
          end
        end
        loc.x = offset - oldOffset - 1
        loc.y = line
        return {
          length: crossRefPtr.length,
          ref: crossRefPtr->ref,
        }
      end

      def getLine( line, buffer)
        offset = 0
        i = 0
        p = nil

        if lastLine < line
          i = line
          line -= lastLine
          lastLine = i
          offset = lastOffset
          p = lastParagraph;
        else
          p = paragraphs
          offset = 0
          lastLine = line
        end
        buffer = ''
        while p != 0
          while (offset < p.size)
            lbuf = ' '*256

            line -= 1
            buffer = String.new(wrapText(p.text, p.size, offset, p.wrap, lbuf, lbuf.length))
            if line == 0
              lastOffset = offset
              lastParagraph = p
              return buffer
            end
            p = p.next
            offset = 0;
          end
        end
        buffer = ''
        return buffer
      end

      def getNumCrossRefs
        @crossRefs.length
      end

      def numLines
        offset = 0
        lines = 0
        p = @paragraphs

        while !p.nil?
          offset = 0
          while offset < p.size
            lbuf = ' '*256
            lines += 1
            wrapText(p.text, p.size, offset, p.wrap, lbuf, lbuf.length)
          end
          p = p.next
        end
        return lines
      end

      def setCrossRef( i, ref )
        if i < @crossRefs.length
          crossRefs[i] = ref
        end
      end

      def setNumCrossRefs( i )
        @crossRefs.slice!(i..-1)
      end

      def setWidth( aWidth )
        @width = aWidth
      end

      attr_accessor :paragraphs
      attr_accessor :numRefs
      attr_accessor :crossRefs

  private
      def wrapText( text, size, offset, wrap, lineBuf, lineBufLen )
        i = text.index("\n", offset)
        if i + offset > size 
          i = size - offset
        end
        if i >= width && wrap == true
          i = offset + width
          if i > size
              i = size
          else
            while i > offset && text[i] != ' '
              i -= 1
            end

            if i == offset
              i = offset + width;
              while i < size && text[i] != ' '
                i += 1
              end
              if i < size
                i += 1
              end
            else
                i += 1
            end
          end
          if i == offset
            i = offset + width
          end
          i -= offset
        end

        textToLine(text, offset, [i,lineBufLen].min, lineBuf)
        if lineBuf[[lineBuf.length - 1, lineBufLen].min] == "\n"
          lineBuf.slice!([lineBuf.length - 1, lineBufLen].min)
        end
        offset += [i,lineBufLen].min
        return lineBuf
      end
  end

  #
  # Part of the help system.
  # @short Part of the help system
  # 
  class THelpIndex < TObject
  public
      def initialize
        @index = []
      end

      def position(i)
        if i < @index.length
          return @index[i]
        else
          return -1
        end
      end

      def add( i, val )
        @index[i] = val
      end

      attr_accessor :size
      attr_accessor :index
  end

  #
  # Part of the help system.
  # @short Part of the help system
  # 
  class THelpFile < public TObject
    @invalidContext
    class << self; attr_accessor :invalidContext; end

    def initialize( s )
      magic = 0
      s.seek(0, IO::SEEK_SET)
      size = s.stat.size
      s.seek(0, IO::SEEK_SET)
      if size > MagicHeader.length
        magic = s.read(4).unpack('V')
      end
      if magic != MagicHeader
        @indexPos = 12
        s.seek(@indexPos, IO::SEEK_SET)
        @index =  THelpIndex.new
        @modified = true
      else
        s.seek(8, IO::SEEK_SET)
        @indexPos = s.read(4).unpack('V')
        s.seek(@indexPos, IO::SEEK_SET)
        @index = s.read(4).unpack('V')
        @modified = false
      end
      @stream = s
    end

    def close
      if @modified == true
        @stream.seek(@indexPos, IO::SEEK_SET)
        stream << index.pack('V')
        stream.seek(0, IO::SEEK_SET)
        magic = MagicHeader
        sp = @stream.tell
        size = s.stat.size - 8
        @stream.seek(sp, IO::SEEK_SET)
        @stream << magic.pack('V')
        @stream << size.pack('V')
        @stream << @indexPos.pack('V')
        @stream.close
      end
    end

    def marshal_dump
      [@modified, @index, @indexPos]
    end

    def marshal_load(vars)
      @modified = vars[0]
      @index = vars[1]
      @indexPos = vars[2]
    end

    def getTopic( i )
      pos = @index.position(i)
      if pos > 0 
        @stream.seek(pos, IO::SEEK_SET)
        topic = Marshal.load(@stream)
        return topic
      end

      return invalidTopic()
    end

    def invalidTopic
      topic = THelpTopic.new
      para = TParagraph.new
      para.text = String.new(invalidContext)
      para.size = invalidContext.length
      para.wrap = false
      para.next = 0
      topic.addParagraph(para)
      return topic
    end

    def recordPositionInIndex( int )
      @index.add(i, @indexPos)
      @modified = true
    end

    def putTopic(topic)
      @stream.seek(@indexPos, IO::SEEK_SET)
      Marshal.dump(topic, @stream)
      @indexPos = @stream.tell
      @modified = true
    end

    attr_accessor :stream
    attr_accessor :modified
    attr_accessor :index
    attr_accessor :indexPos
  end

end
