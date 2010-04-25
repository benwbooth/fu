module TVRuby::Help
  MagicHeader = 0x46484246 #"FBHF"
  CHelpViewer = "\x06\x07\x08"
  CHelpWindow = "\x80\x81\x82\x83\x84\x85\x86\x87"

  @crossRefHandler = NotAssigned
  class << self; attr_accessor :crossRefHandler; end

  # 
  # Part of the help system.
  # 
  class THelpViewer < TScroller
      def initialize(bounds, aHScrollBar, aVScrollBar, aHelpFile, context)
        super(bounds, aHScrollBar, aVScrollBar)
        @options |= OfSelectable
        @growMode = GfGrowHiX | GfGrowHiY
        @hFile = aHelpFile
        @topic = aHelpFile.getTopic(context)
        @topic.setWidth(@size.x)
        setLimit(78, @topic.numLines)
        @selected = 1
      end

      def changeBounds( bounds )
        TScroller.changeBounds(bounds)
        @topic.setWidth(@size.x)
        setLimit(@limit.x, @topic.numLines)
      end

      def draw
        b = TDrawBuffer.new
        buffer = ''
        c = 0

        normal = getColor(1)
        keyword = getColor(2)
        selKeyword = getColor(3)

        keyPoint = TPoint.new
        keyPoint.x = 0
        keyPoint.y = 0

        keyLength = 0
        keyRef = 0
        keyCount = 0

        @topic.setWidth(@size.x)

        if (@topic->getNumCrossRefs() > 0)
          begin do
            @topic.getCrossRef(keyCount, keyPoint, keyLength, keyRef)
            keyCount += 1
          end while keyCount < @topic.getNumCrossRefs && keyPoint.y <= @delta.y
        end
        1.upto(@size.y) do |i|
          b.moveChar(0, ' ', normal, @size.x)
          line = String.new(@topic.getLine(i + @delta.y, buffer, buffer.length))
          if line.length > @delta.x
            bufPtr = @delta.x
            buffer = line[bufPtr..bufPtr+@size.x-1]
            b.moveStr(0, buffer, normal)
          else
              b.moveStr(0, "", normal)
          end
          while i + @delta.y == keyPoint.y
            l = keyLength
            if keyPoint.x < delta.x
              l -= delta.x - keyPoint.x
              keyPoint.x = delta.x
            end
            if keyCount == selected
                c = selKeyword
            else
                c = keyword
            end
            0.upto(l-1) do |j|
              b.putAttribute(keyPoint.x - @delta.x + j, c)
            end
            if keyCount < @topic.getNumCrossRefs
                topic->getCrossRef(keyCount, keyPoint, keyLength, keyRef);
                keyCount+=1
            else
                keyPoint.y = 0
            end
          end
          writeLine(0, i-1, @size.x, 1, b)
        end
      end

      @palette = TPalette.new( CHelpViewer, CHelpViewer.length )
      class << self; attr_accessor :palette; end

      def getPalette
        return self.palette
      end

      def handleEvent( TEvent )
        keyPoint = TPoint.new
        mouse = TPoint.new
        keyLength = 0
        keyRef = 0
        keyCount = 0

        TScroller.handleEvent(event)
        case event.what
        when EvKeyDown
          case event.keyDown.keyCode
          when KbTab
            selected += 1
            if selected > topic.getNumCrossRefs
              selected = 1
            end
            if topic.getNumCrossRefs != 0 )
              makeSelectVisible(selected-1,keyPoint,keyLength,keyRef)
            end
          when KbShiftTab
            selected -= 1
            if selected == 0
              selected = topic->getNumCrossRefs();
            end
            if topic.getNumCrossRefs != 0
              makeSelectVisible(selected-1,keyPoint,keyLength,keyRef);
            end
          when KbEnter
            if selected <= topic.getNumCrossRefs
              topic.getCrossRef(selected-1, keyPoint, keyLength, keyRef)
              switchToTopic(keyRef)
            end
          when KbEsc
            event.what = EvCommand;
            event.message.command = CmClose
            putEvent(event)
          else
            return
          end
          drawView
          clearEvent(event)
        when EvMouseDown
          mouse = makeLocal(event.mouse.where)
          mouse.x += @delta.x
          mouse.y += @delta.y
          keyCount = 0

          begin
              keyCount += 1
              if keyCount > topic.getNumCrossRefs
                return
              end
              topic.getCrossRef(keyCount-1, keyPoint, keyLength, keyRef)
          end while !(
            (keyPoint.y == mouse.y+1) && 
            (mouse.x >= keyPoint.x) &&
            (mouse.x < keyPoint.x + keyLength))

          selected = keyCount
          drawView
          if event.mouse.eventFlags & MeDoubleClick
            switchToTopic(keyRef)
          end
          clearEvent(event)
        when EvCommand
          if (event.message.command == CmClose) && ((owner.state & SfModal) != 0)
              endModal(CmClose)
              clearEvent(event)
          end
        end
      end

      def makeSelectVisible( selected, keyPoint, keyLength, keyRef )
          @topic.getCrossRef(selected, keyPoint, keyLength, keyRef)
          d = @delta
          if keyPoint.x < d.x
            d.x = keyPoint.x
          end
          if keyPoint.x > d.x + @size.x
            d.x = keyPoint.x - @size.x
          end
          if keyPoint.y <= d.y
            d.y = keyPoint.y-1
          end
          if keyPoint.y > d.y + @size.y
            d.y = keyPoint.y - @size.y
          end
          if (d.x != @delta.x) || (d.y != @delta.y)
            scrollTo(d.x, d.y)
          end
      end

      def switchToTopic( keyRef )
        @topic = @hFile.getTopic(keyRef)
        topic.setWidth(@size.x)
        scrollTo(0, 0)
        setLimit(@limit.x, @topic.numLines)
        selected = 1
        drawView
      end

      attr_accessor :hFile
      attr_accessor :topic
      attr_accessor :selected
  end

  #
  # Part of the help system.
  # 
  class THelpWindow < TWindow
    @helpWinTitle
    class << self; attr_accessor :helpWinTitle; end

    def initialize( hFile, context )
      r = TRect.new(0, 0, 50, 18)
      @options |= OfCentered
      r.grow(-2,-1)

      insert(THelpViewer.new(r,
        standardScrollBar(SbHorizontal | SbHandleKeyboard),
        standardScrollBar(SbVertical | SbHandleKeyboard), @hFile, @context))
    end

    @palette = TPalette.new(CHelpWindow, CHelpWindow.length)
    class << self; attr_accessor :palette; end

    def getPalette
      return self.palette
    end
  end
end

