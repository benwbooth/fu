# 
# The base of all visible objects.
# 
# Most programs make use of the TView derivatives: @ref TFrame,
# @ref TScrollBar, @ref TScroller, @ref TListViewer, @ref TGroup, and
# @ref TWindow objects.
# 
# TView objects are rarely instantiated in TVision programs. The TView
# class exists to provide basic data and functionality for its derived
# classes. You'll probably never need to construct an instance of TView
# itself, but most of the common behavior of visible elements in TVision
# applications comes from TView.
# @short The base of all visible objects
# 
class TView < TObject
public

    @lockRefresh = 0
    class << self; attr_accessor :lockRefresh; end
    @vcsFd = 0
    class << self; attr_accessor :vcsFd; end

    def self.doRefresh(p)
      return if vcsFd >= 0
      return if lockRefresh != 0
      return if !p.owner.nil? && p.owner.lockFlag != 0
      refresh
    end

    class StaticVars1
      attr_accessor :buf
    end

    class StaticVars2
      attr_accessor :target
      attr_accessor :offset
      attr_accessor :y
    end

    @staticVars2 = StaticVars2.new
    class << self; attr_accessor :staticVars2; end

    # 
    # @see TGroup::handleEvent
    # @see TGroup::phase
    # 
    @phaseType = Set.new [:phFocused, :phPreProcess, :phPostProcess]

    # 
    # Used internally by TVision.
    # 
    @selectMode = Set.new [:normalSelect, :enterSelect, :leaveSelect]

    # 
    # Creates a TView object with the given `bounds' rectangle. TView
    # constructor calls the TObject constructor and then sets the data
    # members of the new TView to the following values:
    # 
    # <pre>
    # Data member Value
    # 
    # cursor      (0, 0)
    # dragMode    @ref dmLimitLoY
    # eventMask   @ref evMouseDown | @ref evKeyDown | @ref evCommand
    # growMode    0
    # helpCtx     @ref hcNoContext
    # next        0
    # options     0
    # origin      (bounds.A.x, bounds.A.y)
    # owner       0
    # size        (bounds.B.x - bounds.A.x, bounds.B.y - bounds.A.y)
    # state       @ref sfVisible
    # </pre>
    # 
    def initialize(bounds)
    end

    # 
    # Hides the view and then, if it has an owner, removes it from the group.
    # 
    def delete
    end

    # 
    # Sets, in the `min' and `max' arguments, the minimum and maximum values
    # that @ref size data member may assume.
    # 
    # The default TView::sizeLimits returns (0, 0) in `min' and owner->size
    # in `max'. If @ref owner data member is 0, `max.x' and `max.y' are both
    # set to INT_MAX.
    # 
    def sizeLimits( min, max )
    end

    # 
    # Returns the current value of size, the bounding rectangle of the view
    # in its owner's coordinate system.
    # 
    # -# `a' is set to @ref origin
    # -# `b' is set to @ref origin + @ref size
    # 
    def getBounds
    end

    # 
    # Returns the extent rectangle of the view.
    # 
    # -# `a' is set to (0, 0)
    # -# `b' is set to @ref size
    # 
    def getExtent
    end

    # 
    # Returns the clipping rectangle: the smallest rectangle which needs
    # to be redrawn in a @ref draw() call.
    # 
    # For complicated views, draw() can use getClipRect() to improve
    # performance noticeably.
    # 
    def getClipRect
    end

    # 
    # Returns True if the `mouse' argument (given in global coordinates) is
    # within the calling view. Call @ref makeGlobal and @ref makeLocal to
    # convert one point between different coordinate systems.
    # 
    def mouseInView( mouse )
    end

    # 
    # Returns True if a mouse event occurs inside the calling view, otherwise
    # returns False. Returns True if the view is visible and the mouse
    # coordinates (defined in `event.mouse.where') are within this view.
    # 
    # The coordinate is defined in the global coordinate system.
    # @see TView::makeGlobal
    # @see TView::makeLocal
    # 
    def containsMouse( event )
    end

    # 
    # Changes the bounds of the view to those of the `bounds' argument.
    # The view is redrawn in its new location.
    # 
    # locate() calls @ref sizeLimits() to verify that the given bounds are
    # valid, and then calls @ref changeBounds() to change the bounds and
    # redraw the view.
    # 
    def locate( bounds )
    end

    # 
    # Drags the view in the ways specified by the `mode' argument, that is
    # interpreted like the @ref growMode data member.
    # 
    # `limits' specifies the rectangle (in the owner's coordinate system)
    # within which the view can be moved, and `min' and `max' specify the
    # minimum and maximum sizes the view can shrink or grow to.
    # 
    # The event leading to the dragging operation is needed in `event' to
    # distinguish mouse dragging from use of the cursor keys.
    # 
    def dragView( event, mode,  #  temporary fix
      limits, minSize, maxSize ) #  for Miller's stuff
    end

    # 
    # When a view's owner changes size, the owner repeatedly calls
    # calcBounds() and @ref changeBounds() for all its subviews.
    # 
    # calcBounds() must calculate the new bounds of the view given that its
    # owner's size has changed by `delta', and return the new bounds in
    # `bounds'.
    # 
    # calcBounds() calculates the new bounds using the flags specified
    # in @ref growMode data member.
    # 
    def calcBounds( bounds, delta )
    end

    # 
    # changeBounds() must change the view's bounds (@ref origin and @ref size
    # data members) to the rectangle given by the `bounds' parameter.
    # Having changed the bounds, changeBounds() must then redraw the view.
    # 
    # changeBounds() is called by various TView member functions, but should
    # never be called directly.
    # 
    # changeBounds() first calls @ref setBounds(bounds) and then calls
    # @ref drawView().
    # 
    def changeBounds( bounds )
    end

    # 
    # Grows or shrinks the view to the given size using a call to
    # @ref locate().
    # 
    def growTo(x, y )
    end

    # 
    # Moves the origin to the point (x,y) relative to the owner's view. The
    # view's size is unchanged.
    # 
    def moveTo( x, y )
    end

    # 
    # Sets the bounding rectangle of the view to the value given by the
    # `bounds' parameter. The @ref origin data member is set to `bounds.a',
    # and the @ref size data member is set to the difference between
    # `bounds.b' and `bounds.a'.
    # 
    # The setBounds() member function is intended to be called only from
    # within an overridden @ref changeBounds() member function. You should
    # never call setBounds() directly.
    # 
    def setBounds( bounds )
    end

    # 
    # getHelpCtx() returns the view's help context. The default getHelpCtx()
    # returns the value in the @ref helpCtx data member, or returns
    # @ref hcDragging if the view is being dragged (see @ref sfDragging).
    # 
    def getHelpCtx
    end

    # 
    # Use this member function to check the validity of a view after it has
    # been constructed or at the point in time when a modal state ends (due
    # to a call to @ref endModal()).
    # 
    # A `command' argument of cmValid (zero) indicates that the view should
    # check the result of its constructor: valid(cmValid) should return True
    # if the view was successfully constructed and is now ready to be used,
    # False otherwise.
    # 
    # Any other (nonzero) `command' argument indicates that the current modal
    # state (such as a modal dialog box) is about to end with a resulting
    # value of `command'. In this case, valid() should check the validity of
    # the view.
    # 
    # It is the responsibility of valid() to alert the user in case the view
    # is invalid. The default TView::valid() simply returns True.
    # 
    def valid( command )
    end

    # 
    # Hides the view by calling @ref setState() to clear the @ref sfVisible
    # flag in the @ref state data member.
    # 
    def hide
    end

    # 
    # If the view is @ref sfVisible, nothing happens. Otherwise, show()
    # displays the view by calling @ref setState() to set the @ref sfVisible
    # flag in @ref state data member.
    # 
    def show
    end

    # 
    # Draws the view on the screen.
    # 
    # Called whenever the view must draw (display) itself. draw() must cover
    # the entire area of the view.
    # 
    # This member function must be overridden appropriately for each derived
    # class. draw() is seldom called directly, since it is more efficient to
    # use @ref drawView(), which draws only views that are exposed; that is,
    # some or all of the view is visible on the screen.
    # 
    # If required, draw can call @ref getClipRect() to obtain the rectangle
    # that needs redrawing, and then only draw that area. For complicated
    # views, this can improve performance noticeably.
    # 
    # To perform its task, draw() usually uses a @ref TDrawBuffer object.
    # 
    def draw
    end

    # 
    # Draws the view on the screen.
    # 
    # Calls @ref draw() if @ref exposed() returns True, indicating that the
    # view is exposed (see @ref sfExposed). If @ref exposed() returns False,
    # drawView() does nothing.
    # 
    # You should call drawView() (not draw()) whenever you need to redraw a
    # view after making a change that affects its visual appearance.
    # 
    def drawView
    end

    # 
    # Checks if the view is exposed.
    # 
    # Returns True if any part of the view is visible on the screen. The view
    # is exposed if:
    # 
    # -# it has the @ref sfExposed bit set in @ref state data member
    # -# it has the @ref sfVisible bit set in @ref state data member
    # -# its coordinates make it fully or partially visible on the screen.
    # 
    def exposed
    end

    # 
    # Tries to grab the focus.
    # 
    # The view can grab the focus if:
    # 
    # -# the view is not selected (bit @ref sfSelected cleared in @ref state)
    # -# the view is not modal (bit @ref sfModal cleared in @ref state)
    # -# the owner exists and it is focused
    # 
    # If all the above conditions are True, the focus() method calls
    # @ref select() to get the focus.
    # 
    def focus
    end

    # 
    # Hides the cursor by calling @ref setState() to clear the
    # @ref sfCursorVis flag in the @ref state data member.
    # 
    def hideCursor
    end

    # 
    # Calls @ref drawCursor() followed by @ref drawUnderView(). The latter
    # redraws all subviews (with shadows if required) until the given
    # `lastView' is reached.
    # 
    def drawHide( lastView )
    end

    # 
    # Calls @ref drawView(), then if @ref state data member has the
    # @ref sfShadow bit set, @ref drawUnderView() is called to draw the
    # shadow.
    # 
    def drawShow( lastView )
    end

    # 
    # Calls owner->clip.intersect(r) to set the area that needs drawing.
    # Then, all the subviews from the next view to the given `lastView' are
    # drawn using @ref drawSubViews(). Finally, owner->clip is reset to
    # owner->getExtent().
    # @see TGroup::clip
    # @see TRect::intersect
    # @see TView::getExtent
    # 
    def drawUnderRect( r, lastView )
    end

    # 
    # Calls drawUnderRect(r, lastView), where `r' is the calling view's
    # current bounds. If `doShadow' is True, the view's bounds are first
    # increased by shadowSize (see `TView.cc' for more).
    # @see drawUnderRect
    # 
    def drawUnderView( doShadow, lastView )
    end

    # 
    # dataSize() must be used to return the size of the data read from and
    # written to data records by @ref setData() and @ref getData(). The data
    # record mechanism is typically used only in views that implement
    # controls for dialog boxes.
    # 
    # TView::dataSize() returns zero to indicate that no data was
    # transferred.
    # 
    def dataSize
    end

    # 
    # getData() must copy @ref dataSize() bytes from the view to the data
    # record given by the `rec' pointer. The data record mechanism is
    # typically used only in views that implement controls for dialog boxes.
    # @see TView::setData
    # 
    # The default TView::getData() does nothing.
    # 
    def getData( rec )
    end

    # 
    # setData() must copy @ref dataSize() bytes from the data record given by
    # `rec' to the view. The data record mechanism is typically used
    # only in views that implement controls for dialog boxes.
    # @see TView::getData
    # 
    # The default TView::setData() does nothing.
    # 
    def setData( rec )
    end

    # 
    # The default awaken() does nothing. When a group is loaded from a
    # stream, the last thing the @ref TGroup::read() function does is call
    # the awaken() methods of all subviews, giving those views a chance to
    # initialize themselves once all subviews have loaded.
    # 
    # If you create objects that depend on other subviews to initialize
    # themselves after being read from a stream, you can override awaken()
    # to perform that initialization.
    # 
    def awaken
    end

    # 
    # Sets @ref sfCursorIns in @ref state data member to change the cursor
    # to a solid block. The cursor will only be visible if @ref sfCursorVis
    # is also set (and the view is visible).
    # 
    def blockCursor
    end

    # 
    # Clears the @ref sfCursorIns bit in @ref state data member, thereby
    # making the cursor into an underline. If @ref sfCursorVis is set, the
    # new cursor will be displayed.
    # 
    def normalCursor
    end

    # 
    # Resets the cursor.
    # 
    def resetCursor
    end

    # 
    # Moves the hardware cursor to the point (x, y) using view-relative
    # (local) coordinates. (0, 0) is the top-left corner.
    # 
    def setCursor( x, y )
    end

    # 
    # Turns on the hardware cursor by setting the @ref sfCursorVis bit in
    # @ref state data member. Note that the cursor is invisible by default.
    # 
    def showCursor
    end

    # 
    # If the view is @ref sfFocused, the cursor is reset with a call to
    # @ref resetCursor().
    # @see TView::state
    # 
    def drawCursor
    end

    # 
    # Standard member function used in @ref handleEvent() to signal that the
    # view has successfully handled the event.
    # 
    # Sets `event.what' to @ref evNothing and `event.message.infoPtr' to this.
    # 
    def clearEvent( event )
    end

    # 
    # Calls @ref getEvent() and returns True if an event is available. Calls
    # @ref putEvent() to set the event as pending.
    # @see TProgram::pending
    # 
    def eventAvail
    end

    # 
    # Returns the next available event in the `event' argument. Returns
    # @ref evNothing if no event is available. By default, it calls the
    # view's owner's getEvent().
    # @see TGroup::getEvent
    # @see Program::getEvent
    # 
    def getEvent( event )
    end

    # 
    # handleEvent() is the central member function through which all
    # TVision event handling is implemented. The `what' data member of the
    # `event' parameter contains the event class (evXXXX), and the remaining
    # `event' data members further describe the event.
    # 
    # To indicate that it has handled an event, handleEvent() should call
    # @ref clearEvent(). handleEvent() is almost always overridden in derived
    # classes.
    # 
    # The default TView::handleEvent() handles @ref evMouseDown events as
    # follows:
    # 
    # If the view is:
    # 
    # -# not selected (see @ref sfSelected in @ref TView::state)
    # -# and not disabled (see @ref sfDisabled in @ref TView::state)
    # -# and if the view is selectable (see @ref ofSelectable in
    #    @ref TView::options)
    # 
    # then the view selects itself by calling @ref select(). No other events
    # are handled by TView::handleEvent().
    # 
    def handleEvent( event )
    end

    # 
    # Puts the event given by `event' into the event queue, causing it to be
    # the next event returned by @ref getEvent(). Only one event can be pushed
    # onto the event queue in this fashion.
    # 
    # Often used by views to generate command events; for example,
    # 
    # <pre>
    # event.what = @ref evCommand;
    # event.command = cmSaveAll;
    # event.infoPtr = 0;
    # putEvent(event);
    # </pre>
    # 
    # The default TView::putEvent() calls the view's owner's putEvent().
    # @see TGroup::putEvent
    # @see TProgram::pending
    # @see TProgram::putEvent
    # 
    def putEvent( event )
    end

    # 
    # Returns True if the given command is currently enabled; otherwise it
    # returns False.
    # 
    # Note that when you change a modal state, you can then disable and
    # enable commands as you wish; when you return to the previous modal
    # state, however, the original command set will be restored.
    # 
    def self.commandEnabled( command )
    end

    # 
    # Disables the commands specified in the `commands' argument. If the
    # command set is changed by this call, @ref commandSetChanged is set True.
    # 
    def self.disableCommands( commands )
    end

    # 
    # Enables all the commands in the `commands' argument. If the
    # command set is changed by this call, @ref commandSetChanged is set True.
    # 
    def self.enableCommands( commands )
    end

    # 
    # Disables the given command. If the
    # command set is changed by the call, @ref commandSetChanged is set True.
    # 
    def self.disableCommand( ushort command )
    end

    # 
    # Enables the given command. If the
    # command set is changed by this call, @ref commandSetChanged is set True.
    # 
    def self.enableCommand( ushort command )
    end

    # 
    # Returns, in the `commands' argument, the current command set.
    # 
    def self.getCommands( commands )
    end

    # 
    # Changes the current command set to the given `commands' argument.
    # 
    def self.setCommands( commands )
    end

    # 
    # Undocumented.
    # 
    def self.setCmdState( commands, enable)
    end

    # 
    # Calls @ref TopView() to seek the top most modal view. If there is none
    # such (that is, if TopView() returns 0) no further action is taken. If
    # there is a modal view, that view calls endModal(), and so on.
    # 
    # The net result is that endModal() terminates the current modal state.
    # The `command' argument is passed to the @ref TGroup::execView() that
    # created the modal state in the first place.
    # 
    def endModal( command )
    end

    # 
    # Is called from @ref TGroup::execView() whenever a view becomes modal.
    # If a view is to allow modal execution, it must override execute() to
    # provide an event loop. The value returned by execute() will be the
    # value returned by @ref TGroup::execView().
    # 
    # The default TView::execute() simply returns cmCancel.
    # 
    def execute
    end

    # 
    # Maps the palette indices in the low and high bytes of `color' into
    # physical character attributes by tracing through the palette of the
    # view and the palettes of all its owners.
    # 
    def getColor( color )
    end

    # 
    # getPalette() must return a string representing the view's palette.
    # 
    # This can be 0 (empty string) if the view has no palette. getPalette()
    # is called by @ref writeChar() and @ref writeStr() when converting
    # palette indices to physical character attributes.
    # 
    # The default return value of 0 causes no color translation to be
    # performed by this view. getPalette() is almost always overridden in
    # derived classes.
    # 
    def getPalette
    end

    # 
    # Maps the given color to an offset into the current palette. mapColor()
    # works by calling @ref getPalette() for each owning group in the chain.
    # 
    # It succesively maps the offset in each palette until the ultimate
    # owning palette is reached.
    # 
    # If `color' is invalid (for example, out of range) for any of the
    # palettes encountered in the chain, mapColor() returns @ref errorAttr.
    # 
    def mapColor( uchar )
    end

    # 
    # Returns True if the state given in `aState' is set in the data member
    # @ref state.
    # 
    def getState( aState )
    end

    # 
    # Selects the view (see @ref sfSelected). If the view's owner is focused,
    # then the view also becomes focused (see @ref sfFocused).
    # @see TView::state
    # 
    # If the view has the ofTopSelect flag set in its @ref options data
    # member, then the view is moved to the top of its owner's subview list
    # (using a call to @ref makeFirst()).
    # 
    def select
    end

    # 
    # Sets or clears a state flag in the @ref state data member.
    # The `aState' parameter specifies the state flag to modify, and the
    # `enable' parameter specifies whether to turn the flag off (False) or
    # on (True).
    # 
    # setState() then carries out any appropriate action to reflect the new
    # state, such as redrawing views that become exposed when the view is
    # hidden (@ref sfVisible), or reprogramming the hardware when the cursor
    # shape is changed (@ref sfCursorVis and @ref sfCursorIns).
    # 
    # setState() is sometimes overridden to trigger additional actions that
    # are based on state flags. Another common reason to override setState()
    # is to enable or disable commands that are handled by a particular view.
    # 
    def setState( aState, enable )
    end

    # 
    # Returns, in the `event' variable, the next @ref evKeyDown event.
    # It waits, ignoring all other events, until a keyboard event becomes
    # available.
    # 
    def keyEvent( event )
    end

    # 
    # Sets the next mouse event in the `event' argument.
    # Returns True if this event is in the `mask' argument. Also returns
    # False if an @ref evMouseUp event occurs.
    # 
    # This member function lets you track a mouse while its button is down;
    # for example, in drag block-marking operations for text editors.
    # 
    # Here's an extract of a @ref handleEvent() routine that tracks the
    # mouse with the view's cursor:
    # 
    # <pre>
    # void TMyView::handleEvent(TEvent& event)
    # {
    #     TView::handleEvent(event);
    #     switch (event.what)
    #     {
    #     case @ref evMouseDown:
    #         do
    #         {
    #             makeLocal(event.where, mouse);
    #             setCursor(mouse.x, mouse.y);
    #         }
    #         while (mouseEvent(event, evmouseMove));
    #         clearEvent(event);
    #     ...
    #     }
    #     ...
    # }
    # </pre>
    # @see TView::clearEvent
    # @see TView::makeLocal
    # @see TView::setCursor
    # 
    def mouseEvent( event, mask )
    end

    # 
    # Converts the `source' point coordinates from local (view) to global
    # (screen) and returns the result.
    # 
    def makeGlobal( source )
    end

    # 
    # Converts the `source' point coordinates from global (screen) to local
    # (view) and returns the result.
    # 
    # Useful for converting the event.where data member of an evMouse event
    # from global coordinates to local coordinates.
    # 
    # For example:
    # <pre>
    # mouseLoc = makeLocal(eventWhere);
    # </pre>
    # 
    def makeLocal( source )
    end

    # 
    # Returns a pointer to the next subview in the owner's subview list.
    # A 0 is returned if the calling view is the last one in its owner's
    # list.
    # 
    def nextView
    end

    # 
    # Returns a pointer to the previous subview in the owner's subview list.
    # A 0 is returned if the calling view is the first one in its owner's
    # list.
    # 
    # Note that @ref prev() treats the list as circular, whereas prevView()
    # treats the list linearly.
    # 
    def prevView
    end

    # 
    # Returns a pointer to the previous subview in the owner's subview list.
    # If the calling view is the first one in its owner's list, prev()
    # returns the last view in the list.
    # 
    # Note that @ref prev() treats the list as circular, whereas prevView()
    # treats the list linearly.
    # 
    def prev
    end

    # 
    # Pointer to next peer view in Z-order. If this is the last subview, next
    # points to owner's first subview.
    # 
    public :next

    # 
    # Moves the view to the top of its owner's subview list. A call to
    # makeFirst() corresponds to putInFrontOf(owner->first()).
    # @see TGroup::first
    # @see TView::putInFrontOf
    # 
    def makeFirst()
    end

    # 
    # Moves the calling view in front of the `Target' view in the owner's
    # subview list. The call
    # 
    # <pre>
    # MyView.putInFrontOf(owner->first);
    # </pre>
    # 
    # is equivalent to MyView.makeFirst(). This member function works by
    # changing pointers in the subview list.
    # @see TView::makeFirst
    # 
    # Depending on the position of the other views and their visibility
    # states, putInFrontOf() may obscure (clip) underlying views.
    # 
    # If the view is selectable (see @ref ofSelectable) and is put in front
    # of all other subviews, then the view becomes selected.
    # @see TView::options
    # 
    def putInFrontOf( target )
    end

    # 
    # Returns a pointer to the current modal view, or 0 if none such.
    # 
    def TopView
    end

    # 
    # Writes the given buffer to the screen starting at the coordinates
    # (x, y), and filling the region of width `w' and height `h'. Should only
    # be used in @ref draw() member functions.
    # @see TDrawBuffer
    # 
    def writeBuf( x, y, w, h, b )
    end

    # 
    # Beginning at the point (x, y), writes `count' copies of the character
    # `c' in the color determined by the color'th entry in the current view's
    # palette. Should only be used in @ref draw() functions.
    # 
    def writeChar( x, y, c, color, count )
    end

    # 
    # Writes the line contained in the buffer `b' to the screen, beginning at
    # the point (x, y) within the rectangle defined by the width `w' and the
    # height `h'. If `h' is greater than 1, the line will be repeated `h'
    # times. Should only be used in @ref draw() member functions.
    # @see TDrawBuffer
    # 
    def writeLine( x, y, w, h, b )
    end
    
    # 
    # Writes the string `str' with the color attributes of the color'th entry
    # in the view's palette, beginning at the point (x, y). Should only be
    # used in @ref draw() member functions.
    # 
    def writeStr( x, y, str, color )
    end

    # 
    # The size of the view.
    # 
    attr_accessor :size
    
    # 
    # The options word flags determine various behaviors of the view. The
    # following mnemonics are used to refer to the bit positions of the
    # options data member. Setting a bit position to 1 indicates that the
    # view has that particular attribute; clearing the bit position means
    # that the attribute is off or disabled.
    # 
    # <pre>
    # Constant      Value  Meaning
    # 
    # @ref ofSelectable  0x0001 Set if the view should select itself automatically
    #                      (see @ref sfSelected); for example, by a mouse
    #                      click in the view, or a Tab in a dialog box.
    # 
    # @ref ofTopSelect   0x0002 Set if the view should move in front of all other
    #                      peer views when selected. When the
    #                      @ref ofTopSelect bit is set, a call to
    #                      @ref select() corresponds to a call to
    #                      @ref makeFirst(). @ref TWindow and descendants by
    #                      default have the @ref ofTopSelect bit set, which
    #                      causes them to move in front of all other windows
    #                      on the desktop when selected.
    # 
    # @ref ofFirstClick  0x0004 If clear, a mouse click that selects a view will
    #                      have no further effect. If set, such a mouse click
    #                      is processed as a normal mouse click after
    #                      selecting the view. Has no effect unless
    #                      @ref ofSelectable is also set. See also
    #                      @ref handleEvent(), @ref sfSelected and
    #                      @ref ofSelectable.
    # 
    # @ref ofFramed      0x0008 Set if the view should have a frame drawn around
    #                      it. A @ref TWindow and any class derived from
    #                      @ref TWindow, has a @ref TFrame as its last
    #                      subview. When drawing itself, the @ref TFrame
    #                      will also draw a frame around any other subviews
    #                      that have the @ref ofFramed bit set.
    # 
    # @ref ofPreProcess  0x0010 Set if the view should receive focused events
    #                      before they are sent to the focused view.
    #                      Otherwise clear. See also @ref sfFocused,
    #                      @ref ofPostProcess, and @ref TGroup::phase.
    # 
    # @ref ofPostProcess 0x0020 Set if the view should receive focused events
    #                      whenever the focused view fails to handle them.
    #                      Otherwise clear. See also @ref sfFocused,
    #                      @ref ofPreProcess and @ref TGroup::phase.
    # 
    # @ref ofBuffered    0x0040 Used for @ref TGroup objects and classes derived
    #                      from @ref TGroup only. Set if a cache buffer
    #                      should be allocated if sufficient memory is
    #                      available. The group buffer holds a screen image
    #                      of the whole group so that group redraws can be
    #                      speeded up. In the absence of a buffer,
    #                      @ref TGroup::draw() calls on each subview's
    #                      @ref drawView() method. If subsequent memory
    #                      allocation calls fail, group buffers will be
    #                      deallocated to make memory available.
    # 
    # @ref ofTileable    0x0080 Set if the desktop can tile (or cascade) this
    #                      view. Usually used only with @ref TWindow objects.
    # 
    # @ref ofCenterX     0x0100 Set if the view should be centered on the x-axis
    #                      of its owner when inserted in a group using
    #                      @ref TGroup::insert().
    # 
    # @ref ofCenterY     0x0200 Set if the view should be centered on the y-axis
    #                      of its owner when inserted in a group using
    #                      @ref TGroup::insert().
    # 
    # @ref ofCentered    0x0300 Set if the view should be centered on both axes of
    #                      its owner when inserted in a group using
    #                      @ref TGroup::insert().
    # </pre>
    # 
    attr_accessor :options
     
    # 
    # eventMask is a bit mask that determines which event classes will be
    # recognized by the view.
    # 
    # The default eventMask enables @ref evMouseDown, @ref evKeyDown, and
    # @ref evCommand. Assigning 0xFFFF to eventMask causes the view to react
    # to all event classes; conversely, a value of zero causes the view to
    # not react to any events.
    # 
    attr_accessor :eventMask

    # 
    # The state of the view is represented by bits set or clear in the state
    # data member. The bits are represented mnemonically by constants as
    # follows.
    # 
    # <pre>
    # Constant    Value Meaning
    # 
    # @ref sfVisible   0x001 Set if the view is visible on its owner. Views are by
    #                   default @ref sfVisible. Use @ref show() and
    #                   @ref hide() to modify @ref sfVisible. An
    #                   @ref sfVisible view is not necessarily visible on the
    #                   screen, since its owner might not be visible. To test
    #                   for visibility on the screen, examine the
    #                   @ref sfExposed bit or call @ref exposed().
    # 
    # @ref sfCursorVis 0x002 Set if a view's cursor is visible. Clear is the
    #                   default. You can use @ref showCursor() and
    #                   @ref hideCursor() to modify @ref sfCursorVis.
    # 
    # @ref sfCursorIns 0x004 Set if the view's cursor is a solid block; clear if
    #                   the view's cursor is an underline (the default). Use
    #                   @ref blockCursor() and @ref normalCursor() to modify
    #                   this bit.
    # 
    # @ref sfShadow    0x008 Set if the view has a shadow.
    # 
    # @ref sfActive    0x010 Set if the view is the active window or a subview in
    #                   the active window.
    # 
    # @ref sfSelected  0x020 Set if the view is the currently selected subview
    #                   within its owner. Each @ref TGroup object has a
    #                   @ref TGroup::current data member that points to the
    #                   currently selected subview (or is 0 if no subview is
    #                   selected). There can be only one currently selected
    #                   subview in a @ref TGroup.
    # 
    # @ref sfFocused   0x040 Set if the view is focused. A view is focused if it
    #                   is selected and all owners above it are also
    #                   selected. The last view on the focused chain is the
    #                   final target of all focused events.
    # 
    # @ref sfDragging  0x080 Set if the view is being dragged.
    # 
    # @ref sfDisabled  0x100 Set if the view is disabled. A disabled view will
    #                   ignore all events sent to it.
    # 
    # @ref sfModal     0x200 Set if the view is modal. There is always exactly one
    #                   modal view in a running TVision application, usually
    #                   a @ref TApplication or @ref TDialog object. When a
    #                   view starts executing (through an
    #                   @ref TGroup::execView() call), that view becomes
    #                   modal. The modal view represents the apex (root) of
    #                   the active event tree, getting and handling events
    #                   until its @ref endModal() method is called. During
    #                   this "local" event loop, events are passed down to
    #                   lower subviews in the view tree. Events from these
    #                   lower views pass back up the tree, but go no further
    #                   than the modal view. See also @ref setState(),
    #                   @ref handleEvent() and @ref TGroup::execView().
    # 
    # @ref sfDefault   0x400 This is a spare flag, available to specify some
    #                   user-defined default state.
    # 
    # @ref sfExposed   0x800 Set if the view is owned directly or indirectly by
    #                   the application object, and therefore possibly
    #                   visible on the. @ref exposed() uses this flag in
    #                   combination with further clipping calculations to
    #                   determine whether any part of the view is actually
    #                   visible on the screen.
    # </pre>
    # 
    # Many TView member functions test and/or alter the state data member by
    # calling @ref getState() and/or @ref setState().
    # 
    attr_accessor :state

    # 
    # The (x, y) coordinates, relative to the owner's origin, of the top-left
    # corner of the view.
    # 
    attr_accessor :origin

    # 
    # The location of the hardware cursor within the view. The cursor is
    # visible only if the view is focused (@ref sfFocused) and the cursor
    # turned on (@ref sfCursorVis).
    # @see TView::state
    # 
    # The shape of the cursor is either an underline or block (determined by
    # @ref sfCursorIns).
    # 
    attr_accessor :cursor

    # 
    # Determines how the view will grow when its owner view is resized.
    # To growMode is assigned one or more of the following growMode masks:
    # 
    # <pre>
    # Constant  Value Meaning
    # 
    # @ref gfGrowLoX 0x01  If set, the left-hand side of the view will maintain a
    #                 constant distance from its owner's right-hand side. If
    #                 not set, the movement indicated won't occur.
    # 
    # @ref gfGrowLoY 0x02  If set, the top of the view will maintain a constant
    #                 distance from the bottom of its owner.
    # 
    # @ref gfGrowHiX 0x04  If set, the right-hand side of the view will maintain a
    #                  constant distance from its owner's right side.
    # 
    # @ref gfGrowHiY 0x08  If set, the bottom of the view will maintain a
    #                 constant distance from the bottom of its owner's.
    # 
    # @ref gfGrowRel 0x10  For use with @ref TWindow objects that are in the
    #                 desktop. The view will change size relative to the
    #                 owner's size, maintaining that relative size with
    #                 respect to the owner even when screen is resized.
    # 
    # @ref gfGrowAll 0x0F  If set, the view will move with the lower-right corner
    #                 of its owner.
    # </pre>
    # 
    # Note that LoX = left side; LoY = top side; HiX = right side and
    # HiY = bottom side.
    # 
    # Example:
    # <pre>
    # growMode = @ref gfGrowLoX | @ref gfGrowLoY;
    # </pre>
    # 
    attr_accessor :growMode

    # 
    # Determines how the view should behave when mouse-dragged. The dragMode
    # bits are defined as follows:
    # 
    # <pre>
    # Constant   Value Meaning
    # 
    # @ref dmDragMove 0x01  Allow the view to move
    # @ref dmDragGrow 0x02  Allow the view to change size
    # @ref dmLimitLoX 0x10  The view's left-hand side cannot move outside limits
    # @ref dmLimitLoY 0x20  The view's top side cannot move outside limits
    # @ref dmLimitHiX 0x40  The view's right-hand side cannot move outside limits
    # @ref dmLimitHiY 0x80  The view's bottom side cannot move outside limits
    # @ref dmLimitAll 0xF0  No part of the view can move outside limits
    # </pre>
    # 
    # By default, the TView constructor sets the dragMode data member to
    # @ref dmLimitLoY. Currently, these constants and dragMode are only used
    # to compose the `mode' argument of @ref TView::dragView() calls when a
    # view is moved or resized.
    # 
    attr_accessor :dragMode

    # 
    # The help context of the view. When the view is focused, this data
    # member will represent the help context of the application, unless the
    # context number is @ref hcNoContext, in which case there is no help
    # context for the view.
    # 
    # The following default help context constants are defined:
    # 
    # <pre>
    # Constant    Value Meaning
    # 
    # @ref hcNoContext 0     No context specified
    # @ref hcDragging  1     Object is being dragged
    # </pre>
    # 
    # The default value of helpCtx is @ref hcNoContext. @ref getHelpCtx()
    # returns @ref hcDragging whenever the view is being dragged (as
    # indicated by the @ref sfDragging @ref state flag).
    # 
    # TVision reserves help context values 0 through 999 for its own use.
    # Programmers may define their own constants in the range 1,000 to
    # 65,535.
    # 
    attr_accessor :helpCtx

    # 
    # Set to True whenever the view's command set is changed via an enable or
    # disable command call.
    # @see TView::disableCommand
    # @see TView::disableCommands
    # @see TView::enableCommand
    # @see TView::enableCommands
    # @see TView::setCommands
    # 
    @commandSetChanged
    class << self
      attr_accessor :commandSetChanged
    end

    # 
    # Holds the set of commands currently enabled for this view. Initially,
    # the following commands are disabled: cmZoom, cmClose, cmResize, cmNext,
    # cmPrev.
    # 
    # This data member is constantly monitored by @ref handleEvent() to
    # determine which of the received command events needs to be serviced.
    # 
    # curCommandSet should not be altered directly: use the appropriate set,
    # enable, or disable calls.
    # @see TView::disableCommand
    # @see TView::disableCommands
    # @see TView::enableCommand
    # @see TView::enableCommands
    # @see TView::setCommands
    # 
    @curCommandSet
    class << self
      attr_accessor :curCommandSet
    end

    # 
    # Points to the TGroup object that owns this view. If 0, the view has
    # no owner. The view is displayed within its owner's view and will be
    # clipped by the owner's bounding rectangle.
    # 
    attr_accessor :owner

    # 
    # Used to indicate whether indicators should be placed around focused
    # controls. @ref TProgram::initScreen() sets showMarkers to True if the
    # video mode is monochrome; otherwise it is False. The value may,
    # however, be set on in color and black and white modes if desired.
    # 
    attr_accessor :showMarkers

    # 
    # Attribute used to signal an invalid palette selection. For example,
    # @ref mapColor() returns errorAttr if it is called with an invalid color
    # argument.
    # 
    # By default, errorAttr is set to 0xCF, which shows as flashing red on
    # white.
    # 
    attr_accessor :errorAttr

    # 
    # Used internally by @ref TObject::destroy() to ensure correct
    # destruction of derived and related objects. shutDown() is overridden
    # in many classes to ensure the proper setting of related data members
    # when destroy() is called.
    # 
    def shutDown
    end

private
    # 
    # Undocumented.
    # 
    def moveGrow( p, s, limits, minSize, maxSize, mode)
    end

    # 
    # Undocumented.
    # 
    def change( uchar, delta, p, s, ctrlState )
    end

    # 
    # Undocumented.
    # 
    def exposedRec1(int, int, TView)
    end

    # 
    # Undocumented.
    # 
    def exposedRec2(int, int, TView)
    end

    # 
    # Undocumented.
    # 
    def writeView(int, int, int, void)
    end

    # 
    # Undocumented.
    # 
    def writeViewRec1(int, int, TView, int)
    end

    # 
    # Undocumented.
    # 
    def writeViewRec2(int, int, TView, int)
    end
end
