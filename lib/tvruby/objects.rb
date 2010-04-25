module TVRuby::Objects

  #
  # A screen coordinate. TPoint implements points on the screen with several
  # overloaded operators for point manipulation.
  # 
  # TPoint is a simple object that can be used to record a coordinate on the
  # screen. For this, two public variables are available: `x' and `y'.
  # @see TRect
  # @short Two-point screen coordinate
  # 
  class TPoint
  public
      #
      # Adds the coordinate of another point to this point.
      # Returns *this.
      # 
      def += (  adder )
        @x += adder.x
        @y += adder.y
        return self
      end

      #
      # Subtracts the coordinate of another point from this point.
      # Returns *this.
      # 
      def -= ( subber )
        @x -= subber.x
        @y -= subber.y
        return self
      end

      #
      # Calculates the distance between two points.
      # Returns a point with the resulting difference.
      # 
      def - (two)
      end

      #
      # Calculates the sum of two points.
      # Returns a point with the resulting sum.
      # 
      def + (two)
      end

      #
      # Returns True if two points are equal (have the same coordinate),
      # returns False otherwise.
      # 
      def == (two)
      end

      #
      # Returns True if two points are not equal (have different coordinate),
      # returns False otherwise.
      # 
      def != ( one, two)
      end

      #
      # Is the screen column of the point.
      # 
      attr_accessor :x

      #
      # Is the screen row of the point.
      # 
      attr_accessor :y
  end

  #
  # A screen rectangular area.
  # 
  # TRect is used to hold two coordinates on the screen, which usually specify
  # the upper left corner and the lower right corner of views. Sometimes the
  # second coordinate speficy the size (extension) of the view. The two
  # coordinates are named @ref a and @ref b.
  # 
  # TRect has several inline member functions for manipulating rectangles.
  # The operators == and != are overloaded to provide the comparison of two
  # rectangles in a natural way.
  # @see TPoint
  # @see TRect::operator==
  # @see TRect::operator!=
  # @short Screen rectangular area
  # 
  class TRect
      def self.makeRect
        r = TRect.new( 0, 0, 40, 9 )
        r.move((TProgram.deskTop.size.x - r.b.x) / 2,
               (TProgram.deskTop.size.y - r.b.y) / 2)
        return r
      end

      #
      # Constructor.
      # 
      # Initializes the rectangle coordinates using the four integer
      # parameters.
      # 
      # 
      # Constructor.
      # 
      # Initializes the rectangle coordinates using two points.
      # @see TPoint
      # 
      def initialize( int ax=nil, int ay=nil, int bx=nil, int by=nil)
        if ax.is_a? TPoint && ay.is_a? TPoint
          p1, p2 = ax, ay
          @a = p1
          @b = p2
        else
          @a.x = ax
          @a.y = ay
          @b.x = bx
          @b.y = by
        end
      end

      #
      # Moves the rectangle to a new position.
      # 
      # The two parameters are added to the two old coordinates as delta
      # values. Both parameters can be negative or positive.
      # 
      def move( aDX, aDY )
        @a.x += aDX
        @a.y += aDY
        @b.x += aDX
        @b.y += aDY
      end

      #
      # Enlarges the rectangle by a specified value.
      # 
      # Changes the size of the calling rectangle by subtracting `aDX' from
      # a.x, adding `aDX' to b.x, subtracting `aDY' from a.y, and adding `aDY'
      # to b.y.
      # 
      # The left side is left-moved by `aDX' units and the right side is
      # right-moved by `aDX' units. In a similar way the upper side is
      # upper-moved by `aDY' units and the bottom side is bottom-moved by `aDY'
      # units.
      # 
      def grow( aDX, aDY )
        @a.x -= aDX
        @a.y -= aDY
        @b.x += aDX
        @b.y += aDY
      end

      #
      # Calculates the intersection between this rectangle and the parameter
      # rectangle.
      # 
      # The resulting rectangle is the largest rectangle which contains both
      # part of this rectangle and part of the parameter rectangle.
      # 
      def intersect( r )
        @a.x = [ @a.x, @r.a.x ].max
        @a.y = [ @a.y, @r.a.y ].max
        @b.x = [ @b.x, @r.b.x ].min
        @b.y = [ @b.y, @r.b.y ].min
      end

      #
      # Calculates the union between this rectangle and the `r' parameter
      # rectangle.
      # 
      # The resulting rectangle is the smallest rectangle which contains both
      # this rectangle and the `r' rectangle.
      # 
      def Union( r )
        @a.x = [ a.x, r.a.x ].min
        @a.y = [ a.y, r.a.y ].min
        @b.x = [ b.x, r.b.x ].max
        @b.y = [ b.y, r.b.y ].max
      end

      #
      # Returns True if the calling rectangle (including its boundary) contains
      # the point `p', returns False otherwise.
      # @see TPoint
      # 
      def contains( p )
        p.x >= @a.x && p.x < @b.x && p.y >= @a.y && p.y < @b.y
      end

      #
      # Returns True if `r' is the same as the calling rectangle; otherwise,
      # returns False.
      # 
      def == ( r )
        @a == r.a && @b == r.b
      end

      #
      # Returns True if `r' is not the same as the calling rectangle;
      # otherwise, returns False.
      # 
      def != ( r )
        !(self == r)
      end

      #
      # Checks if the rectangle is empty, i.e. if the first coordinate is
      # greater than the second one.
      # 
      # Empty means that (a.x >=  b.x || a.y >= b.y).
      # 
      def isEmpty
        @a.x >= @b.x || @a.y >= @b.y
      end

      #
      # Is the point defining the top-left corner of a rectangle on the screen.
      # 
      attr_accessor :a

      #
      # Is the point defining the bottom-right corner of a rectangle on the
      # screen.
      # 
      attr_accessor :b
  end
end

