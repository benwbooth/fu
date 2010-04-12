# 
# The desktop of the application.
# @see TApplication
# 
# TDeskTop inherits multiply from @ref TGroup and the virtual base class
# @ref TDeskInit. @ref TDeskInit provides a constructor and a create
# background member function used in creating and inserting a background
# object. TDeskTop is a simple group that owns the @ref TBackground view
# upon which the application's windows and other views appear.
# 
# TDeskTop represents the desk top area of the screen between the top menu
# bar and bottom status line (but only when the bar and line exist). By
# default, TDeskTop has a @ref TBackground object inside which paints its
# background.
# 
# TDeskTop objects can be written to and read from streams using the
# overloaded >> and << operators.
# @short The desktop of the application
# 
class TDeskTop < TGroup
  include TDeskInit
public
    # 
    # Constructor.
    # 
    # Creates a TDeskTop group with size `bounds' by calling its base
    # constructors TGroup::TGroup and TDeskInit::TDeskInit(&initBackground).
    # The resulting @ref TBackground object created by @ref initBackground is
    # then inserted into the desk top.
    # @see TDeskInit:TDeskInit
    # @see TGroup::TGroup
    #      
    # @ref growMode is set to @ref gfGrowHiX | @ref gfGrowHiY.
    # 
    def initialize(bounds)
    end

    # 
    # Moves all the windows in a cascade-like fashion.
    # 
    # Redisplays all tileable windows owned by the desk top in cascaded
    # format. The first tileable window in Z-order (the window "in back") is
    # zoomed to fill the desk top, and each succeeding window fills a region
    # beginning one line lower and one space further to the right than the
    # one before. The active window appears "on top" as the smallest window.
    # 
    def cascade( TRect& )
    end

    # 
    # Standard TDeskTop event handler.
    # 
    # Calls @ref TGroup::handleEvent() and takes care of the commands cmNext
    # (usually the hot key F6) and cmPrev by cycling through the windows
    # owned by the desk top, starting with the currently selected view.
    # 
    def handleEvent(TEvent)
    end

    # 
    # Creates a new background.
    # 
    # Returns a pointer to a newly-allocated @ref TBackground object. The
    # address of this member function is passed as an argument to the
    # @ref TDeskInit constructor. The latter invokes @ref initBackground()
    # to create a new @ref TBackground object with the same bounds as the
    # calling TDeskTop object.
    # The @ref background data member is set to point at the new
    # @ref TBackground object.
    # 
    # Redefine this method if you want a custom background.
    # 
    def initBackground(TRect)
    end

    # 
    # Moves all the windows in a tile-like fashion.
    # 
    def tile(TRect)
    end
    
    # 
    # Called on tiling error.
    # 
    # This method is called whenever @ref cascade() or @ref tile() run into
    # troubles in moving the windows. You can redefine it if you want to
    # give an error message to the user. By default, it does nothing.
    # 
    def tileError
    end

    # 
    # Releases TDeskTop resources.
    # 
    # This function is derived from @ref TObject. Used internally by
    # @ref TObject::destroy() to ensure correct destruction of derived and
    # related objects. shutDown() is overridden in many classes to ensure
    # the proper setting of related data members when destroy() is called.
    # 
    # This method releases all the resources allocated by the TDeskTop. It
    # sets pointer @ref background to 0 and then calls
    # @ref TGroup::shutDown().
    # 
    def shutDown
    end

    # 
    # The default pattern which will be used for painting the background.
    # 
    public :defaultBkgrnd

    # This variable stores a pointer to the background object associated with
    # this desk top.
    protected :background

    # True if method @ref tile() should favour columns first. Set to False in
    # TDeskTop constructor.
    # @see TDeskTop::TDeskTop
    protected :tileColumnsFirst
end
