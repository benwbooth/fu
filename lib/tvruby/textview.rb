module Textview
  #
  # TTextDevice is a scrollable TTY-type text viewer/device driver.
  # 
  # Apart from the data members and member functions inherited from
  # @ref TScroller, TTextDevice defines virtual member functions for reading
  # and writing strings from and to the device.
  # 
  # TTextDevice exists solely as a base type for deriving real terminal
  # drivers. TTextDevice uses TScroller's destructor.
  # @short Scrollable TTY-type text viewer/device driver
  # 
  class TTextDevice < TScroller
      #
      # Creates a TTextDevice object with the given bounds, horizontal and
      # vertical scroll bars by calling @ref TScroller constructor with the
      # `bounds' and scroller arguments.
      # @see TScroller::TScroller
      # 
      def initialize( bounds, aHScrollBar, aVScrollBar)
      end

      #
      # Overrides the corresponding function in class streambuf.
      # 
      # This is an internal function that is called whenever a character string
      # is to be inserted into the internal buffer.
      # 
      def do_sputn( s, count )
        raise NotImplementedError
      end
  end

  #
  # TTerminal implements a "dumb" terminal with buffered string reads and
  # writes. The default is a cyclic buffer of 64K bytes.
  # @short Implements a "dumb" terminal with buffered string reads and writes
  # 
  class TTerminal < TTextDevice
      # 
      # Creates a TTerminal object with the given bounds, horizontal and
      # vertical scroll bars, and buffer by calling @ref TTextDevice constructor
      # with the bounds and scroller arguments, then creating a buffer
      # (pointed to by buffer) with @ref bufSize equal to `aBufSize'.
      # @see TTextDevice::TTextDevice
      # 
      # @ref growMode is set to @ref gfGrowHiX | @ref gfGrowHiY. @ref queFront
      # and @ref queBack are both initialized to 0, indicating an empty buffer.
      # The cursor is shown at the view's origin, (0,0).
      # 
      def initialize( bounds, aHScrollBar, aVScrollBar, aBufSize)
      end

      #
      # Overrides the corresponding function in class streambuf.
      # 
      # This is an internal function that is called whenever a character string
      # is to be inserted into the internal buffer.
      # 
      def do_sputn( s, count )
      end

      #
      # Used to manipulate a queue offsets with wrap around: increments `val'
      # by 1, then if `val' >= @ref bufSize, `val' is set to zero.
      # 
      def bufInc( val )
      end

      #
      # Returns True if the number of bytes given in amount can be inserted
      # into the terminal buffer without having to discard the top line.
      # Otherwise, returns False.
      # 
      def canInsert( amount )
      end

      def calcWidth
      end

      #
      # Called whenever the TTerminal scroller needs to be redrawn; for
      # example, when the scroll bars are clicked on, the view is unhidden or
      # resized, the delta values are changed, or when added text forces a
      # scroll.
      # 
      def draw
      end

      #
      # Returns the buffer offset of the start of the line that follows the
      # position given by `pos'.
      # 
      def nextLine( pos )
      end

      #
      # Returns the offset of the start of the line that is `lines' lines
      # previous to the position given by `pos'.
      # 
      def prevLines( pos, lines )
      end

      #
      # Returns True if @ref queFront is equal to @ref queBack.
      # 
      def queEmpty
      end

    protected
      #
      # The size of the terminal's buffer in bytes.
      # 
      attr_accessor :bufSize
      protected :bufSize

      #
      # Pointer to the first byte of the terminal's buffer.
      # 
      attr_accessor :buffer
      protected :buffer

      #
      # Offset (in bytes) of the first byte stored in the terminal buffer.
      # 
      attr_accessor :queFront
      protected :queFront

      #
      # Offset (in bytes) of the last byte stored in the terminal buffer.
      # 
      attr_accessor :queBack
      protected :queBack

      #
      # Used to manipulate queue offsets with wrap around: if `val' is zero,
      # `val' is set to (bufSize - 1); otherwise, `val' is decremented.
      # 
      def bufDec(val)
      end

      # Added horizontal cursor tracking
      attr_accessor :curLineWidth 
      protected :curLineWidth
  end

  class TerminalBuf
      attr_accessor :term
      protected :term
  public
      def initialize(tt)
      end

      #
      # Overrides the corresponding function in class streambuf.
      # 
      # When the internal buffer in a streambuf is full and the iostream
      # associated with that streambuf tries to put another character into the
      # buffer, overflow() is called. Its argument `c' is the character that
      # caused the overflow.
      # 
      # In TerminalBuf the underlying streambuf has no buffer, so every
      # character results in an overflow() call.
      # 
      def overflow( c = EOF )
      end

      def sync
      end
  end

end
