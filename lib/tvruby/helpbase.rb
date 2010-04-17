module Helpbase

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
      end

      def addCrossRef( ref )
      end

      def addParagraph( p )
      end

      def getCrossRef( i, loc, length, ref )
      end

      def getLine( line, buffer, buflen )
      end

      def getNumCrossRefs
      end

      def numLines
      end

      def setCrossRef( i, ref )
      end

      def setNumCrossRefs( i )
      end

      def setWidth( aWidth )
      end

      attr_accessor :paragraphs
      attr_accessor :numRefs
      attr_accessor :crossRefs

  private
      def wrapText( text, size, offset, wrap, lineBuf, lineBufLen )
      end

      def readParagraphs( s )
      end

      def readCrossRefs( s )
      end

      def writeParagraphs(s)
      end

      def writeCrossRefs( s )
      end

      def disposeParagraphs
      end
  end

  #
  # Part of the help system.
  # @short Part of the help system
  # 
  class THelpIndex < TObject
  public
      def initialize
      end
      def position( int )
      end
      def add( int, long )
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
  public
      def initialize( s )
      end

      def getTopic( int )
      end

      def invalidTopic
      end

      def recordPositionInIndex( int )
      end

      def putTopic( THelpTopic* )
      end

      attr_accessor :stream
      attr_accessor :modified
      attr_accessor :index
      attr_accessor :indexPos
  end

end
