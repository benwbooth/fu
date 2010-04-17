module Help

  # 
  # Part of the help system.
  # 
  class THelpViewer < TScroller
  public
      def initialize( TScrollBar*, TScrollBar*, THelpFile*, ushort )
      end

      def changeBounds( TRect )
      end
      def draw
      end
      def getPalette
      end
      def handleEvent( TEvent )
      end
      def makeSelectVisible( int, TPoint, uchar, int )
      end
      def switchToTopic( int )
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
  public
      def initialize( THelpFile*, ushort )
      end

      def getPalette
      end
  end
end

