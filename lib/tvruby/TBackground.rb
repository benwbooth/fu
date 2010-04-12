# The default desktop background.
# 
# TBackground is a very simple view which by default is the background of the
# desktop. It is a rectangle painted with an uniform pattern.
# @see TDeskTop
# @short The default desktop background
class TBackground < TView
  public
    # 
    # Constructor.
    # 
    # `bounds' is the bounding rectangle of the background.
    # 
    # @ref growMode is set to @ref gfGrowHiX | @ref gfGrowHiY, and the
    # @ref pattern data member is set to `aPattern'.
    # 
    def initialize(bounds, aPattern)
    end

    # 
    # Fills the background view rectangle with the current pattern in the
    # default color.
    # 
    def draw
    end

    # 
    # Returns a reference to the standard TBackground palette.
    # 
    def getPalette
    end

    # 
    # Is the pattern used to fill the view.
    # 
  protected :pattern

    # 
    # Constructor.
    # 
    # Used to recover the view from a stream.
    # 
    # Each streamable class needs a "builder" to allocate the correct memory
    # for its objects together with the initialized virtual table pointers.
    # This is achieved by calling this constructor with an argument of type
    # @ref StreamableInit.
    # 
    # TBackground( StreamableInit );

    # 
    # Used to store the view in a stream.
    # 
    # Writes to the output stream `os'.
    # 
    def write(os)
    end

    # 
    # Used to recover the view from a stream.
    # 
    # Reads from the input stream `is'.
    # 
    def read(is)
    end
  public
    # 
    # Undocumented.
    # 
    @name
    class << self
      attr_accessor :name
    end
end

