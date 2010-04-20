module TVRuby::Views

  #  Standard command codes
  CmValid         = 0
  CmQuit          = 1
  CmError         = 2
  CmMenu          = 3
  CmClose         = 4
  CmZoom          = 5
  CmResize        = 6
  CmNext          = 7
  CmPrev          = 8
  CmHelp          = 9

  #  TDialog standard commands

  CmOK            = 10
  CmCancel        = 11
  CmYes           = 12
  CmNo            = 13
  CmDefault       = 14

  # Standard application commands

  CmNew           = 30
  CmOpen          = 31
  CmSave          = 32
  CmSaveAs        = 33
  CmSaveAll       = 34
  CmChDir         = 35
  CmDosShell      = 36
  CmCloseAll      = 37

  # SS: some new internal commands.

  CmSysRepaint    = 38,
  CmSysResize     = 39,
  CmSysWakeup     = 40,

  #  TView State masks

  # \var sfVisible
  # Set if the view is visible on its owner. Views are by default
  # sfVisible. Use @ref TView::show() and @ref TView::hide() to modify
  # sfVisible. An sfVisible view is not necessarily visible on the screen,
  # since its owner might not be visible. To test for visibility on the
  # screen, examine the @ref sfExposed bit or call @ref TView::exposed().
  # @see TView::state
  # 
  SfVisible       = 0x001

  # \var sfCursorVis
  # Set if a view's cursor is visible. Clear is the default. You can
  # use @ref TView::showCursor() and @ref TView::hideCursor() to modify
  # sfCursorVis.
  # @see TView::state
  # 
  SfCursorVis     = 0x002

  # \var sfCursorIns
  # Set if the view's cursor is a solid block; clear if the view's cursor
  # is an underline (the default). Use @ref TView::blockCursor() and
  # @ref TView::normalCursor() to modify this bit.
  # @see TView::state
  # 
  SfCursorIns     = 0x004

  # \var sfShadow
  # Set if the view has a shadow.
  # @see TView::state
  # 
  SfShadow        = 0x008

  # \var sfActive
  # Set if the view is the active window or a subview in the active window.
  # @see TView::state
  # 
  SfActive        = 0x010

  # \var sfSelected
  # Set if the view is the currently selected subview within its owner.
  # Each @ref TGroup object has a @ref TGroup::current data member that
  # points to the currently selected subview (or is 0 if no subview is
  # selected). There can be only one currently selected subview in a
  # @ref TGroup.
  # @see TView::state
  # 
  SfSelected      = 0x020

  # \var sfFocused
  # Set if the view is focused. A view is focused if it is selected and
  # all owners above it are also selected. The last view on the focused
  # chain is the final target of all focused events.
  # @see TView::state
  # 
  SfFocused       = 0x040

  # \var sfDragging
  # Set if the view is being dragged.
  # @see TView::state
  # 
  SfDragging      = 0x080

  # \var sfDisabled
  # Set if the view is disabled. A disabled view will ignore all events
  # sent to it.
  # @see TView::state
  # 
  SfDisabled      = 0x100

  # \var sfModal
  # Set if the view is modal. There is always exactly one modal view in
  # a running TVision application, usually a @ref TApplication or
  # @ref TDialog object. When a view starts executing (through an
  # @ref TGroup::execView() call), that view becomes modal. The modal
  # view represents the apex (root) of the active event tree, getting
  # and handling events until its @ref TView::endModal() method is called.
  # During this "local" event loop, events are passed down to lower
  # subviews in the view tree. Events from these lower views pass back
  # up the tree, but go no further than the modal view. See also
  # @ref TView::setState(), @ref TView::handleEvent() and
  # @ref TGroup::execView().
  # @see TView::state
  # 
  SfModal         = 0x200

  # \var sfDefault
  # This is a spare flag, available to specify some user-defined default
  # state.
  # @see TView::state
  # 
  SfDefault       = 0x400

  # \var sfExposed
  # Set if the view is owned directly or indirectly by the application
  # object, and therefore possibly visible on the. @ref TView::exposed()
  # uses this flag in combination with further clipping calculations to
  # determine whether any part of the view is actually visible on the
  # screen.
  # @see TView::state
  # 
  SfExposed       = 0x800

  # TView Option masks

  # \var ofSelectable
  # Set if the view should select itself automatically (see
  # @ref sfSelected); for example, by a mouse click in the view, or a Tab
  # in a dialog box.
  # @see TView::options
  # 
  OfSelectable    = 0x001

  # \var ofTopSelect
  # Set if the view should move in front of all other peer views when
  # selected. When the ofTopSelect bit is set, a call to
  # @ref TView::select() corresponds to a call to @ref TView::makeFirst().
  # @ref TWindow and descendants by default have the ofTopSelect bit set,
  # which causes them to move in front of all other windows on the desktop
  # when selected.
  # @see TView::options
  # 
  OfTopSelect     = 0x002

  # \var ofFirstClick
  # If clear, a mouse click that selects a view will have no further
  # effect. If set, such a mouse click is processed as a normal mouse
  # click after selecting the view. Has no effect unless @ref ofSelectable
  # is also set. See also @ref TView::handleEvent(), @ref sfSelected and
  # @ref ofSelectable.
  # @see TView::options
  # 
  OfFirstClick    = 0x004

  # \var ofFramed
  # Set if the view should have a frame drawn around it. A @ref TWindow
  # and any class derived from @ref TWindow, has a @ref TFrame as its last
  # subview. When drawing itself, the @ref TFrame will also draw a frame
  # around any other subviews that have the ofFramed bit set.
  # @see TView::options
  # 
  OfFramed        = 0x008

  # \var ofPreProcess
  # Set if the view should receive focused events before they are sent to
  # the focused view. Otherwise clear. See also @ref sfFocused,
  # @ref ofPostProcess, and @ref TGroup::phase.
  # @see TView::options
  # 
  OfPreProcess    = 0x010

  # \var ofPostProcess
  # Set if the view should receive focused events whenever the focused
  # view fails to handle them. Otherwise clear. See also @ref sfFocused,
  # @ref ofPreProcess and @ref TGroup::phase.
  # @see TView::options
  # 
  OfPostProcess   = 0x020

  # \var ofBuffered
  # Used for @ref TGroup objects and classes derived from @ref TGroup
  # only. Set if a cache buffer should be allocated if sufficient memory
  # is available. The group buffer holds a screen image of the whole
  # group so that group redraws can be speeded up. In the absence of a
  # buffer, @ref TGroup::draw() calls on each subview's
  # @ref TView::drawView() method. If subsequent memory allocation calls
  # fail, group buffers will be deallocated to make memory available.
  # @see TView::options
  # 
  OfBuffered      = 0x040

  # \var ofTileable
  # Set if the desktop can tile (or cascade) this view. Usually used
  # only with @ref TWindow objects.
  # @see TView::options
  # 
  OfTileable      = 0x080

  # \var ofCenterX
  # Set if the view should be centered on the x-axis of its owner when
  # inserted in a group using @ref TGroup::insert().
  # @see TView::options
  # 
  OfCenterX       = 0x100

  # \var ofCenterY
  # Set if the view should be centered on the y-axis of its owner when
  # inserted in a group using @ref TGroup::insert().
  # @see TView::options
  # 
  OfCenterY       = 0x200

  # \var ofCentered
  # Set if the view should be centered on both axes of its owner when
  # inserted in a group using @ref TGroup::insert().
  # @see TView::options
  # 
  OfCentered      = 0x300

  # \var ofValidate
  # Undocumented.
  # @see TView::options
  # 
  OfValidate      = 0x400

  # TView GrowMode masks

  # \var gfGrowLoX
  # If set, the left-hand side of the view will maintain a constant
  # distance from its owner's right-hand side. If not set, the movement
  # indicated won't occur.
  # @see TView::growMode
  # 
  GfGrowLoX       = 0x01

  # \var gfGrowLoY
  # If set, the top of the view will maintain a constant distance from
  # the bottom of its owner.
  # @see TView::growMode
  # 
  GfGrowLoY       = 0x02

  # \var gfGrowHiX
  # If set, the right-hand side of the view will maintain a constant
  # distance from its owner's right side.
  # @see TView::growMode
  # 
  GfGrowHiX       = 0x04

  # \var gfGrowHiY
  # If set, the bottom of the view will maintain a constant distance
  # from the bottom of its owner's.
  # @see TView::growMode
  # 
  GfGrowHiY       = 0x08

  # \var gfGrowAll
  # If set, the view will move with the lower-right corner of its owner.
  # @see TView::growMode
  # 
  GfGrowAll       = 0x0f

  # \var gfGrowRel
  # For use with @ref TWindow objects that are in the desktop. The view
  # will change size relative to the owner's size, maintaining that
  # relative size with respect to the owner even when screen is resized.
  # @see TView::growMode
  # 
  GfgrowRel       = 0x10

  # \var gfFixed
  # Undocumented.
  # @see TView::growMode
  # 
  GfFixed         = 0x20

  # TView DragMode masks

  # \var dmDragMove
  # Allow the view to move.
  # @see TView::dragMode
  # 
  DmDragMove      = 0x01

  # \var dmDragGrow
  # Allow the view to change size.
  # @see TView::dragMode
  # 
  DmDragGrow      = 0x02

  # \var dmLimitLoX
  # The view's left-hand side cannot move outside limits.
  # @see TView::dragMode
  # 
  DmLimitLoX      = 0x10

  # \var dmLimitLoY
  # The view's top side cannot move outside limits.
  # @see TView::dragMode
  # 
  DmlimitLoY      = 0x20

  # \var dmLimitHiX
  # The view's right-hand side cannot move outside limits.
  # @see TView::dragMode
  # 
  DmLimitHiX      = 0x40

  # \var dmLimitHiY
  # The view's bottom side cannot move outside limits.
  # @see TView::dragMode
  # 
  DmLimitHiY      = 0x80

  # \var dmLimitAll
  # No part of the view can move outside limits.
  # @see TView::dragMode
  # 
  DmLimitAll      = DmLimitLoX | DmLimitLoY | DmLimitHiX | DmLimitHiY

  # TView Help context codes

  # \var hcNoContext
  # No context specified.
  # @see TView::helpCtx
  # 
  HcNoContext     = 0

  # \var hcDragging
  # Object is being dragged.
  # @see TView::helpCtx
  # 
  HcDragging      = 1

  # TScrollBar part codes

  # \var sbLeftArrow
  # Left arrow of horizontal scroll bar.
  # @see TScrollBar::scrollStep
  # 
  SbLeftArrow     = 0

  # \var sbRightArrow
  # Right arrow of horizontal scroll bar.
  # @see TScrollBar::scrollStep
  # 
  SbRightArrow    = 1

  # \var sbPageLeft
  # Left paging area of horizontal scroll bar.
  # @see TScrollBar::scrollStep
  # 
  SbPageLeft      = 2

  # \var sbPageRight
  # Right paging area of horizontal scroll bar.
  # @see TScrollBar::scrollStep
  # 
  SbPageRight     = 3

  # \var sbUpArrow
  # Top arrow of vertical scroll bar.
  # @see TScrollBar::scrollStep
  # 
  SbUpArrow       = 4

  # \var sbDownArrow
  # Bottom arrow of vertical scroll bar.
  # @see TScrollBar::scrollStep
  # 
  SbDownArrow     = 5

  # \var sbPageUp
  # Upper paging area of vertical scroll bar.
  # @see TScrollBar::scrollStep
  # 
  SbPageUp        = 6

  # \var sbPageDown
  # Lower paging area of vertical scroll bar.
  # @see TScrollBar::scrollStep
  # 
  SbPageDown      = 7

  # \var sbIndicator
  # Position indicator on scroll bar.
  # @see TScrollBar::scrollStep
  # 
  SbIndicator     = 8

  # TScrollBar options for TWindow.StandardScrollBar

  # \var sbHorizontal
  # The scroll bar is horizontal.
  # @see TWindow::standardScrollBar
  # 
  SbHorizontal    = 0x000

  # \var sbVertical
  # The scroll bar is vertical.
  # @see TWindow::standardScrollBar
  # 
  SbVertical      = 0x001

  # \var sbHandleKeyboard
  # The scroll bar responds to keyboard commands.
  # @see TWindow::standardScrollBar
  # 
  SbHandleKeyboard = 0x002

  # TWindow Flags masks

  # \var wfMove
  # Window can be moved.
  # @see TWindow::flags.
  # 
  WfMove          = 0x01

  # \var wfGrow
  # Window can be resized and has a grow icon in the lower-right corner.
  # @see TWindow::flags.
  # 
  WfGrow          = 0x02

  # \var wfClose
  # Window frame has a close icon that can be mouse-clicked to close the
  # window.
  # @see TWindow::flags.
  # 
  WfClose         = 0x04

  # \var wfZoom
  # Window frame has a zoom icon that can be mouse-clicked.
  # @see TWindow::flags.
  # 
  WfZoom          = 0x08

  #  TView inhibit flags

  NoMenuBar       = 0x0001
  NoDeskTop       = 0x0002
  NoStatusLine    = 0x0004
  NoBackground    = 0x0008
  NoFrame         = 0x0010
  NoViewer        = 0x0020
  NoHistory       = 0x0040

  # TWindow number constants

  /** \var wnNoNumber
  * Use the constant wnNoNumber to indicate that the window is not to be
  * numbered and cannot be selected via the Alt+number key.
  * @see TWindow::TWindow
  */
  WnNoNumber      = 0

  # TWindow palette entries

  # \var wpBlueWindow
  # Window text is yellow on blue.
  # @see TWindow::palette
  # 
  WpBlueWindow    = 0

  # \var wpCyanWindow
  # Window text is blue on cyan.
  # @see TWindow::palette
  # 
  WpCyanWindow    = 1

  # \var wpGrayWindow
  # Window text is black on gray.
  # @see TWindow::palette
  # 
  WpGrayWindow    = 2

  #  Application command codes

  CmCut           = 20
  CmCopy          = 21
  CmPaste         = 22
  CmUndo          = 23
  CmClear         = 24
  CmTile          = 25
  CmCascade       = 26

  # Standard messages

  CmReceivedFocus     = 50
  CmReleasedFocus     = 51
  CmCommandSetChanged = 52

  # TScrollBar messages

  CmScrollBarChanged  = 53
  CmScrollBarClicked  = 54

  # TWindow select messages

  cmSelectWindowNum   = 55,

  #  TListViewer messages

  CmListItemSelected  = 56

  #  Event masks

  # \var positionalEvents
  # Defines the event classes that are positional events.
  # The focusedEvents and positionalEvents masks are used by
  # @ref TGroup::handleEvent() to determine how to dispatch an event to the
  # group's subviews. If an event class isn't contained in
  # @ref focusedEvents or positionalEvents, it is treated as a broadcast
  # event.
  # 
  PositionalEvents    = EvMouse

  # \var focusedEvents
  # Defines the event classes that are focused events.
  # The focusedEvents and positionalEvents values are used by
  # @ref TGroup::handleEvent() to determine how to dispatch an event to the
  # group's subviews. If an event class isn't contained in
  # focusedEvents or @ref positionalEvents, it is treated as a broadcast
  # event.
  # 
  FocusedEvents       = EvKeyboard | EvCommand

  #
  # TCommandSet is a non-view class for handling command sets.
  # 
  # Member functions are provided for enabling and disabling commands and for
  # testing for the presence of a given command.
  # Several operators are overloaded to allow natural testing for equality and
  # so on.
  # 
  # Note: this object can only handle commands whose code is within 0 and 255.
  # Only commands in this range may be disabled.
  # @short Implements a non-view class for handling command sets
  # 
  class TCommandSet
      #
      # Constructor.
      # 
      # This form creates a command set and initializes it from the `tc'
      # argument.
      # 
      def initialize(tc = nil)
      end

      #
      # Returns True if command `cmd' is in the set.
      # 
      def has( cmd )
      end

      #
      # Removes command `cmd' from the set.
      # 
      def disableCmd( cmd )
      end

      # 
      # Adds command `cmd' to the set.
      # 
      def enableCmd( cmd )
      end

      #
      # Adds command `cmd' to the set.
      # 
      def += ( cmd )
      end

      #
      # Removes command `cmd' from the set.
      # 
      def -= ( cmd )
      end

      #
      # Removes all commands in set `tc' from this command set.
      # 
      def disableCmd( tc )
      end

      # 
      # Adds all commands in set `tc' to this command set.
      # 
      def enableCmd( tc )
      end

      #
      # Adds all commands in set `tc' to this command set.
      # 
      def += ( cmd )
        enableCmd( cmd )
      end

      #
      # Removes all commands in set `tc' from this command set.
      # 
      def -= ( cmd )
        disableCmd( cmd )
      end

      #
      # Returns True if the command set is empty.
      # 
      def isEmpty
      end

      #
      # Calculates the intersection of this set and the `tc' set.
      # 
      # The resulting set is the largest set which contains commands present in
      # both sets. Returns a reference to this object.
      # 
      def &= ( tc)
      end

      #
      # Calculates the union of this set and the `tc' set.
      # 
      # The resulting set is the smallest set which contains commands present
      # in either sets. Returns a reference to this object.
      # 
      def |= ( tc)
      end

      #
      # Calculates the intersection of this set and the `tc' set.
      # 
      # The resulting set is the largest set which contains commands present in
      # both sets. Returns the resulting set.
      # 
      def & ( TCommandSet&, TCommandSet& )
      end

      #
      # Calculates the union of this set and the `tc' set.
      # 
      # The resulting set is the smallest set which contains commands present
      # in either sets. Returns the resulting set.
      # 
      def | ( TCommandSet&, TCommandSet& )
      end

      #
      # Returns 1 if the sets `tc1' and `tc2' are equal.
      # 
      # Otherwise returns 0.
      # 
      def == ( tc1, tc2 )
      end

      # 
      # Returns 1 if the sets `tc1' and `tc2' are not equal.
      # 
      # Otherwise returns 0.
      # 
      def != ( tc1, tc2 )
        !(tc1 == tc2)
      end

  private
      def loc( int )
        @cmd / 8
      end

      def mask( int )
        @masks[ @cmd & 0x07 ]
      end

      class << self; attr_accessor :masks; private :masks; end
  end


  #if defined( Uses_TPalette ) && !defined( __TPalette )
  #define __TPalette

  # 
  # TPalette is a simple class used to create and manipulate palette arrays.
  # 
  # Although palettes are arrays of char, and are often referred to as strings,
  # they are not the conventional null-terminated strings found in C. Normal C
  # string functions cannot be used.
  # 
  # The first byte of a palette string holds its length (not counting the first
  # byte itself). Each basic view has a default palette that determines the
  # usual colors assigned to the various parts of a view, such as scroll bars,
  # frames, buttons, text, and so on.
  # @short Simple class used to create and manipulate palette arrays
  # 
  class TPalette
      #
      # Creates a TPalette object with string `d' and length `len'. The private
      # member @ref data is set with `len' in its first byte, following by the
      # array `d'.
      # 
      # *
      # Creates a new palette by copying the palette `tp'.
      # 
      def initialize( d, len )
        tp = d if d.is_a? TPalette
      end

      #
      # The code p = tp; copies the palette `tp' to the palette `p'.
      # 
      def = ( tp )
      end

      #
      # The subscripting operator returns the character at the index'th
      # position.
      # 
      def [] ( index )
      end
  end

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
  class TView
      #
      # @see TGroup::handleEvent
      # @see TGroup::phase
      # 
      PhFocused = 0 
      PhPreProcess = 1 
      PhPostProcess = 2

      #
      # Used internally by TVision.
      # 
      NormalSelect = 0
      EnterSelect = 1
      LeaveSelect = 2

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
      def initialize( bounds )
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
      def dragView( event, mode, limits, minSize, maxSize )
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
      def growTo( x, y )
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
      def self.disableCommand( command )
      end

      #
      # Enables the given command. If the
      # command set is changed by this call, @ref commandSetChanged is set True.
      # 
      def self.enableCommand( command )
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
      attr_accessor :next

      #
      # Moves the view to the top of its owner's subview list. A call to
      # makeFirst() corresponds to putInFrontOf(owner->first()).
      # @see TGroup::first
      # @see TView::putInFrontOf
      # 
      def makeFirst
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
      def writeBuf(  x, y, w, h, b )
        writeBuf( x, y, w, h, b.data )
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
        writeLine( x, y, w, h, b.data )
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
      class << self; attr_accessor :commandSetChanged; end

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
      class << self; attr_accessor :curCommandSet; end

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
      class << self; attr_accessor :showMarkers; end

      #
      # Attribute used to signal an invalid palette selection. For example,
      # @ref mapColor() returns errorAttr if it is called with an invalid color
      # argument.
      # 
      # By default, errorAttr is set to 0xCF, which shows as flashing red on
      # white.
      # 
      class << self; attr_accessor :errorAttr; end

  private
      def moveGrow( p, s, limits, minSize, maxSize, mode)
      end

      def change( uchar, delta, p, s, ctrlState )
      end

      def exposedRec1(int, int, TView)
      end

      def exposedRec2(int, int, TView)
      end

      def writeView(int, int, int, void )
      end

      def writeViewRec1(int, int, TView, int)
      end

      def writeViewRec2(int, int, TView, int)
      end
  end

  # ---------------------------------------------------------------------- 
  #      class TFrame                                                      
  #                                                                        
  #      Palette layout                                                    
  #        1 = Passive frame                                               
  #        2 = Passive title                                               
  #        3 = Active frame                                                
  #        4 = Active title                                                
  #        5 = Icons                                                       
  # ---------------------------------------------------------------------- 

  #
  # TFrame provides the distinctive frames around windows and dialog boxes.
  # Users will probably never need to deal with frame objects directly, as they
  # are added to window objects by default.
  # @short The frame around the windows
  # 
  class TFrame < TView
      #
      # Calls TView constructor TView(bounds), then sets @ref growMode to
      # @ref gfGrowHiX | @ref gfGrowHiY and sets @ref eventMask to
      # @reg eventMask | @ref evBroadcast, so TFrame objects default to
      # handling broadcast events.
      # `bounds' is the bounding rectangle of the frame.
      # 
      def initialize( bounds )
      end

      #
      # Draws the frame with color attributes and icons appropriate to the
      # current state flags: active, inactive, being dragged. Adds zoom, close
      # and resize icons depending on the owner window's flags. Adds the title,
      # if any, from the owning window's title data member.
      # 
      # Active windows are drawn with a double-lined frame and any icons;
      # inactive windows are drawn with a single-lined frame and no icons.
      # @see TView::draw
      #  
      def draw
      end

      #
      # Returns a reference to the default frame palette string.
      # @see TView::getPalette
      # 
      def getPalette
      end

      #
      # Calls @ref TView::handleEvent(), then handles mouse events.
      # 
      # If the mouse is clicked on the close icon, TFrame::handleEvent()
      # generates a cmClose event. Clicking on the zoom icon or double-clicking
      # on the top line of the frame generates a cmZoom event.
      # 
      # Dragging the top line of the frame moves the window, and dragging the
      # resize icon moves the lower right corner of the view and therefore
      # changes its size.
      # 
      def handleEvent( event )
      end

      # 
      # Changes the state of the frame.
      # Calls TView::setState(aState, enable). If the new state is
      # @ref sfActive or @ref sfDragging, calls @ref TView::drawView() to
      # redraw the view.
      # @see TView::setState
      # @see TView::state
      # 
      def setState( aState, enable )
      end

      class << self
        attr_accessor :frameChars
        attr_accessor :closeIcon
        attr_accessor :dragIcon
      end
  private
      def frameLine( frameBuf, y, n, color )
      end

      def dragWindow( event, dragMode )
      end

      class << self
        attr_accessor :initFrame
        private :initFrame
        attr_accessor :zoomIcon
        private :zoomIcon
        attr_accessor :unZoomIcon
        private :unZoomIcon
      end
  end

  # ---------------------------------------------------------------------- 
  #      class TScrollBar                                                  
  #                                                                        
  #      Palette layout                                                    
  #        1 = Page areas                                                  
  #        2 = Arrows                                                      
  #        3 = Indicator                                                   
  # ---------------------------------------------------------------------- 

  #
  # @short Implements a scroll bar
  # 
  class TScrollBar < TView
      #
      # Creates and initializes a scroll bar with the given bounds by calling
      # the TView constructor. Sets @ref value, @ref maxVal and @ref minVal to
      # zero. Sets @ref pgStep and @ref arStep to 1.
      # 
      # The shapes of the scroll bar parts are set to the defaults in
      # @ref chars data member.
      # 
      # If `bounds' produces size.x = 1, scroll bar is vertical; otherwise, it
      # is horizontal. Vertical scroll bars have the @ref growMode data member
      # set to @ref gfGrowLoX | @ref gfGrowHiX | @ref gfGrowHiY; horizontal
      # scroll bars have the @ref growMode data member set to @ref gfGrowLoY |
      # @ref gfGrowHiX | @ref gfGrowHiY.
      # 
      def initialize( bounds )
      end

      #
      # Draws the scroll bar depending on the current bounds, value, and
      # palette.
      # 
      def draw
      end

      #
      # Returns the default palette.
      # 
      def getPalette
      end

      #
      # Handles scroll bar events by calling @ref TView::handleEvent(). Mouse
      # events are broadcast to the scroll bar's owner, which must handle the
      # implications of the scroll bar changes.
      # 
      # handleEvent() also determines which scroll bar part has received a
      # mouse click (or equivalent keystroke). Data member @ref value is
      # adjusted according to the current @ref arStep or @ref pgStep values.
      # The scroll bar indicator is redrawn.
      # 
      def handleEvent( event )
      end

      #
      # Is called whenever @ref value data member changes. This virtual member
      # function defaults by sending a cmScrollBarChanged message to the scroll
      # bar's owner:
      # 
      # <pre>
      # message(owner, @ref evBroadcast, cmScrollBarChanged, this);
      # </pre>
      # @see message
      # 
      def scrollDraw
      end

      # 
      # By default, scrollStep() returns a positive or negative step value,
      # depending on the scroll bar part given by `part', and the current
      # values of @ref arStep and @ref pgStep. Parameter `part' should be one
      # of the following constants:
      # 
      # <pre>
      # Constant     Value Meaning
      # 
      # @ref sbLeftArrow  0     Left arrow of horizontal scroll bar
      # @ref sbRightArrow 1     Right arrow of horizontal scroll bar
      # @ref sbPageLeft   2     Left paging area of horizontal scroll bar
      # @ref sbPageRight  3     Right paging area of horizontal scroll bar
      # @ref sbUpArrow    4     Top arrow of vertical scroll bar
      # @ref sbDownArrow  5     Bottom arrow of vertical scroll bar
      # @ref sbPageUp     6     Upper paging area of vertical scroll bar
      # @ref sbPageDown   7     Lower paging area of vertical scroll bar
      # @ref sbIndicator  8     Position indicator on scroll bar
      # </pre>
      # 
      # These constants define the different areas of a TScrollBar in which the
      # mouse can be clicked. The scrollStep() function converts these
      # constants into actual scroll step values.
      # Although defined, the sbIndicator constant is never passed to
      # scrollStep().
      # 
      def scrollStep( part )
      end

      #
      # Sets the @ref value, @ref minVal, @ref maxVal, @ref pgStep and
      # @ref arStep with the given argument values. Some adjustments are made
      # if your arguments conflict.
      # 
      # The scroll bar is redrawn by calling @ref drawView(). If value is
      # changed, @ref scrollDraw() is also called.
      # 
      def setParams( aValue, aMin, aMax, aPgStep, aArStep )
      end

      #
      # Sets the legal range for value by setting @ref minVal and @ref maxVal
      # to the given arguments `aMin' and `aMax'.
      # 
      # Calls @ref setParams(), so @ref drawView() and @ref scrollDraw() will
      # be called if the changes require the scroll bar to be redrawn.
      # 
      def setRange( aMin, aMax )
      end

      #
      # Sets @ref pgStep and @ref arStep to the given arguments `aPgStep' and
      # `aArStep'.
      # Calls @ref setParams() with the other arguments set to their current
      # values.
      # 
      def setStep( aPgStep, aArStep )
      end

      # 
      # Sets @ref value to `aValue' by calling @ref setParams() with the other
      # arguments set to their current values.
      # Note: @ref drawView() and @ref scrollDraw() will be called if this
      # call changes value.
      # 
      def setValue( aValue )
      end

      def drawPos( pos )
      end

      def getPos
      end

      def getSize
      end

      #
      # This variable represents the current position of the scroll bar
      # indicator. This marker moves along the scroll bar strip to indicate the
      # relative position of the scrollable text being viewed relative to the
      # total text available for scrolling.
      # 
      # The TScrollBar constructor sets value to zero by default.
      # 
      attr_accessor :value

      #
      # TScrollChars is defined as:
      # 
      # <pre>
      # typedef char TScrollChars[5];
      # </pre>
      # 
      # Variable chars is set with the five basic character patterns used to
      # draw the scroll bar parts.
      # 
      attr_accessor :chars

      #
      # Variable minVal represents the minimum value for the @ref value data
      # member. The TScrollBar constructor sets minVal to zero by default.
      # 
      attr_accessor :minVal

      #
      # Variable maxVal represents the maximum value for the @ref value data
      # member. The TScrollBar constructor sets maxVal to zero by default.
      # 
      attr_accessor :maxVal

      #
      # Variable pgStep is the amount added or subtracted to the scroll bar's
      # @ref value data member when a mouse click event occurs in any of the
      # page areas (@ref sbPageLeft, @ref sbPageRight, @ref sbPageUp, or
      # @ref sbPageDown) or an equivalent keystroke is detected (Ctrl-Left,
      # Ctrl-Right, PgUp, or PgDn).
      # 
      # The TScrollBar constructor sets pgStep to 1 by default. You can change
      # pgStep using @ref setParams(), @ref setStep() or
      # @ref TScroller::setLimit().
      # 
      attr_accessor :pgStep

      # 
      # Variable arStep is the amount added or subtracted to the scroll bar's
      # @ref value data member when an arrow area is clicked (@ref sbLeftArrow,
      # @ref sbRightArrow, @ref sbUpArrow, or @ref sbDownArrow) or the
      # equivalent keystroke made.
      # 
      # The TScrollBar constructor sets arStep to 1 by default.
      # 
      int arStep;
      attr_accessor :arStep

      class << self
        attr_accessor :vChars
        attr_accessor :hChars
      end
  private
      def getPartCode
      end
  end

  # ---------------------------------------------------------------------- 
  #      class TScroller                                                   
  #                                                                        
  #      Palette layout                                                    
  #      1 = Normal text                                                   
  #      2 = Selected text                                                 
  # ---------------------------------------------------------------------- 

  #
  # TScroller provides a scrolling virtual window onto a larger view. That is,
  # a scrolling view lets the user scroll a large view within a clipped
  # boundary.
  # 
  # The scroller provides an offset from which the @ref TView::draw() method
  # fills the visible region. All methods needed to provide both scroll bar
  # and keyboard scrolling are built into TScroller.
  # 
  # The basic scrolling view provides a useful starting point for scrolling
  # views such as text views.
  # @short Provides a scrolling virtual window onto a larger view
  # 
  class TScroller <public TView
      # *
      # Creates and initializes a TScroller object with the given size and
      # scroll bars. Calls @ref TView constructor to set the view's size.
      # 
      # `aHScrollBar' should be 0 if you do not want a horizontal scroll bar;
      # `aVScrollBar' should be 0 if you do not want a vertical scroll bar.
      # 
      def initialize( bounds, aHScrollBar, aVScrollBar)
      end

      #
      # Changes the scroller's size by calling @ref TView::setbounds(). If
      # necessary, the scroller and scroll bars are then redrawn by calling
      # @ref setLimit() and @ref drawView().
      # 
      def changeBounds( bounds )
      end

      #
      # Returns the default scroller palette string.
      # 
      def getPalette
      end

      #
      # Handles most events by calling @ref TView::handleEvent().
      # 
      # Broadcast events such as cmScrollBarChanged from either @ref hScrollBar
      # or @ref vScrollBar result in a call to @ref scrollDraw().
      # 
      def handleEvent( event )
      end

      #
      # Checks to see if @ref delta matches the current positions of the scroll
      # bars. If not, @ref delta is set to the correct value and
      # @ref drawView() is called to redraw the scroller.
      # 
      def scrollDraw
      end

      #
      # Sets the scroll bars to (x,y) by calling hScrollBar->setValue(x) and
      # vScrollBar->setValue(y) and redraws the view by calling @ref drawView().
      # @see TScrollBar::hScrollBar
      # @see TScrollBar::vScrollBar
      # @see TScrollBar::setValue
      # 
      def scrollTo( x, y )
      end

      #
      # Sets the @ref limit data member and redraws the scrollbars and
      # scroller if necessary.
      # 
      def setLimit( x, y )
      end

      #
      # This member function is called whenever the scroller's state changes.
      # Calls @ref TView::setState() to set or clear the state flags in
      # `aState'.
      # If the new @ref state is @ref sfSelected and @ref sfActive, setState()
      # displays the scroll bars; otherwise, they are hidden.
      # 
      def setState( aState, enable )
      end

      # 
      # If @ref drawLock is zero and @ref drawFlag is True, @ref drawFlag is set
      # False and @ref drawView() is called.
      # If @ref drawLock is non-zero or @ref drawFlag is False, checkDraw()
      # does nothing.
      # 
      # Methods @ref scrollTo() and @ref setLimit() each call checkDraw() so
      # that @ref drawView() is only called if needed.
      # 
      def checkDraw
      end

      #
      # Holds the x (horizontal) and y (vertical) components of the scroller's
      # position relative to the virtual view being scrolled.
      # 
      # Automatic scrolling is achieved by changing either or both of these
      # components in response to scroll bar events that change the value data
      # member(s).
      # 
      # Manual scrolling changes delta, triggers changes in the scroll bar
      # @ref TScrollBar::value data members, and leads to updating of the
      # scroll bar indicators.
      # 
      attr_accessor :delta

      #
      # A semaphore used to control the redrawing of scrollers.
      # 
      attr_accessor :drawLock
      protected :drawLock

      #
      # Set True if the scroller has to be redrawn.
      # 
      attr_accessor :drawFlag
      protected :drawFlag

      #
      # Points to the horizontal scroll bar object associated with the
      # scroller. If there is no such scroll bar, hScrollBar is 0.
      # 
      attr_accessor :hScrollBar
      protected :hScrollBar

      #
      # Points to the vertical scroll bar object associated with the
      # scroller. If there is no such scroll bar, vScrollBar is 0.
      # 
      attr_accessor :vScrollBar
      protected :vScrollBar

      #
      # Data members limit.x and limit.y are the maximum allowed values for
      # delta.x and delta.y data members.
      # @see TScroller::delta
      # 
      attr_accessor :limit
      protected :limit

  private
      def showSBar( sBar )
      end
  end

  #
  # TListViewer is an abstract class from which you can derive list viewers of
  # various kinds, such as @ref TListBox. TListViewer's members offer the
  # following functionality:
  # 
  # -# A view for displaying linked lists of items (but no list)
  # -# Control over one or two scroll bars
  # -# Basic scrolling of lists in two dimensions
  # -# Reading and writing the view and its scroll bars from and to a stream
  # -# Ability to use a mouse or the keyboard to select (highlight) items on
  #    list
  # -# Draw member function that copes with resizing and scrolling
  # 
  # TListViewer has an abstract @ref getText() method, so you need to supply
  # the mechanism for creating and manipulating the text of the items to be
  # displayed.
  # 
  # TListViewer has no list storage mechanism of its own. Use it to display
  # scrollable lists of arrays, linked lists, or similar data structures. You
  # can also use its descendants, such as @ref TListBox, which associates a
  # collection with a list viewer.
  # @short An abstract class from which you can derive list viewers of various
  # kinds, such as TListBox.
  # 
  class TListViewer < TView
      class << self; attr_accessor :emptyText; end

      #
      # Creates and initializes a TListViewer object with the given size by
      # first calling @ref TView::TView(bounds).
      # 
      # The @ref numCols data member is set to `aNumCols'. @ref TView::options
      # is set to (@ref ofFirstClick | @ref ofSelectable) so that mouse clicks
      # that select this view will be passed first to @ref handleEvent().
      # 
      # The @ref TView::eventMask is set to @ref evBroadcast. The initial
      # values of @ref range and @ref focused are zero.
      # 
      # You can supply pointers to vertical and/or horizontal scroll bars by
      # way of the `aVScrollBar' and `aHScrollBar' arguments. Setting either or
      # both to 0 suppresses one or both scroll bars. These two pointer
      # arguments are assigned to the @ref vScrollBar and @ref hScrollBar data
      # members.
      # 
      def initialize( bounds, aNumCols, aHScrollBar, aVScrollBar)
      end

      #
      # Changes the size of the TListViewer object by calling
      # TView::changeBounds(bounds). If a horizontal scroll bar has been
      # assigned, @ref TScrollBar::pgStep is updated by way of
      # @ref TScrollBar::setStep().
      # @see TView::changeBounds
      # 
      def changeBounds( bounds )
      end

      # 
      # Draws the TListViewer object with the default palette by repeatedly
      # calling @ref getText() for each visible item. Takes into account the
      # @ref focused and selected items and whether the view is @ref sfActive.
      # @see TView::state
      # 
      def draw
      end

      #
      # Makes the given item focused by setting the @ref focused data member to
      # `item'. Also sets the @ref TScrollBar::value data member of the
      # vertical scroll bar (if any) to `item' and adjusts @ref topItem.
      # 
      def focusItem( item )
      end

      # 
      # Returns the default TListViewer palette string.
      # 
      def getPalette
      end

      #
      # Derived classes must override it with a function that writes a string
      # not exceeding `maxLen' at address `dest', given an item index
      # referenced by `item'.
      # 
      # Note that @ref draw() needs to call getText().
      # 
      def getText(dest, item, maxLen )
      end

      #
      # Returns True if the given item is selected (focused), that is, if
      # `item' == @ref focused.
      # 
      def isSelected( item )
      end

      #
      # Handles events by first calling TView::handleEvent(event).
      # @see TView::handleEvent
      # 
      # Mouse clicks and "auto" movements over the list will change the focused
      # item. Items can be selected with double mouse clicks.
      # 
      # Keyboard events are handled as follows: Spacebar selects the currently
      # focused item; the arrow keys, PgUp, PgDn, Ctrl-PgDn, Ctrl-PgUp, Home,
      # and End keys are tracked to set the focused item.
      # 
      # Broadcast events from the scroll bars are handled by changing the
      # @ref focused item and redrawing the view as required.
      # 
      def handleEvent( event )
      end

      #
      # Selects the item'th element of the list, then broadcasts this fact to
      # the owning group by calling:
      # 
      # <pre>
      # message(owner, @ref evBroadcast, cmListItemSelected, this);
      # </pre>
      # @see message
      # 
      def selectItem( item )
      end

      # 
      # Sets the @ref range data member to `aRange'.
      # 
      # If a vertical scroll bar has been assigned, its parameters are adjusted
      # as necessary (and @ref TScrollBar::drawView() is invoked if redrawing is
      # needed).
      # 
      # If the currently focused item falls outside the new range, the
      # @ref focused data member is set to zero.
      # 
      def setRange( aRange )
      end

      # 
      # Calls TView::setState(aState, enable) to change the TListViewer
      # object's state. Depending on the `aState' argument, this can result in
      # displaying or hiding the view.
      # @see TView::setState
      # @see TView::state
      # 
      # Additionally, if `aState' is @ref sfSelected and @ref sfActive, the
      # scroll bars are redrawn; if `aState' is @ref sfSelected but not
      # @ref sfActive, the scroll bars are hidden.
      # 
      def setState( aState, enable )
      end

      # 
      # Used internally by @ref focusItem(). Makes the given item focused by
      # setting the @ref focused data member to `item'.
      # 
      def focusItemNum( item )
      end

      # 
      # Pointer to the horizontal scroll bar associated with this view. If 0,
      # the view does not have such a scroll bar.
      # 
      attr_accessor :hScrollBar

      #
      # Pointer to the vertical scroll bar associated with this view. If 0,
      # the view does not have such a scroll bar.
      # 
      attr_accessor :vScrollBar

      #
      # The number of columns in the list control.
      # 
      attr_accessor :numCols

      #
      # The item number of the top item to be displayed. This value changes
      # during scrolling. Items are numbered from 0 to @ref range - 1. This
      # number depends on the number of columns, the size of the view, and the
      # value of variable @ref range.
      # 
      attr_accessor :topItem

      # 
      # The item number of the focused item. Items are numbered from 0 to
      # @ref range - 1. Initially set to 0, the first item, focused can be
      # changed by mouse click or Spacebar selection.
      # 
      attr_accessor :focused

      #
      # The current total number of items in the list. Items are numbered from
      # 0 to range - 1.
      # 
      attr_accessor :range

      class << self; attr_accessor :separatorChar; end
  end

  #
  # TGroup objects and their derivatives (called groups for short) provide the
  # central driving power to TVision.
  # 
  # A group is a special breed of view. In addition to all the members derived
  # from @ref TView and @ref TStreamable, a group has additional members and
  # many overrides that allow it to control a dynamically linked list of views
  # (including other groups) as though they were a single object.
  # 
  # We often talk about the subviews of a group even when these subviews are
  # often groups in their own right.
  # 
  # Although a group has a rectangular boundary from its @ref TView ancestry, a
  # group is only visible through the displays of its subviews. A group draws
  # itself via the @ref draw() methods of its subviews. A group owns its
  # subviews, and together they must be capable of drawing (filling) the
  # group's entire rectangular bounds.
  # @see TView::draw
  # 
  # During the life of an application, subviews are created, inserted into
  # groups, and displayed as a result of user activity and events generated by
  # the application itself. The subviews can just as easily be hidden, deleted
  # from the group, or disposed of by user actions (such as closing a window or
  # quitting a dialog box).
  # 
  # Three derived object types of TGroup, namely @ref TWindow, @ref TDeskTop,
  # and @ref TApplication (via @ref TProgram) illustrate the group and
  # subgroup concept. The application typically owns a desktop object, a
  # status line object, and a menu view object. @ref TDeskTop is a TGroup
  # derivative, so it, in turn, can own @ref TWindow objects, which in turn own
  # @ref TFrame objects, @ref TScrollBar objects, and so on.
  # 
  # TGroup overrides many of the basic @ref TView methods in a natural way.
  # TGroup objects delegate both drawing and event handling to their subviews.
  # You'll rarely construct an instance of TGroup itself; rather you'll
  # usually use one or more of TGroup's derived object types:
  # @ref TApplication, @ref TDeskTop, and @ref TWindow.
  # 
  # All TGroup objects are streamable, inheriting from @ref TStreamable by way
  # of @ref TView. This means that TGroup objects (including your entire
  # application group) can be written to and read from streams in a type-safe
  # manner using the familiar C++ iostream operators.
  # @short TGroup objects and their derivatives provide the central driving
  # power to TVision
  # 
  class TGroup < TView
      #
      # Calls @ref TView::TView(bounds), sets @ref ofSelectable and
      # @ref ofBuffered in @ref options and sets @ref eventMask to 0xFFFF. The
      # members @ref last, @ref current, @ref buffer, @ref lockFlag and
      # @ref endState are all set to zero.
      # 
      def initialize( bounds )
      end

      #
      # execView() is the "modal" counterpart of the "modeless" @ref insert()
      # and @ref remove() member functions.
      # 
      # Unlike @ref insert(), after inserting a view into the group, execView()
      # waits for the view to execute, then removes the view, and finally
      # returns the result of the execution.
      # 
      # execView() is used in a number of places throughout TVision, most
      # notably to implement @ref TProgram::run() and to execute modal dialog
      # boxes.
      # 
      # execView() saves the current context (the selected view, the modal
      # view, and the command set), makes `p' modal by calling
      # p->setState(sfModal, True), inserts `p' into the group (if it isn't
      # already inserted), and calls p->execute().
      # @see TView::execute
      # @see TView::setState
      # 
      # When p->execute() returns, the group is restored to its previous state,
      # and the result of p->execute() is returned as the result of the
      # execView() call.
      # 
      # If `p' is 0 upon a call to execView(), a value of cmCancel is returned.
      # 
      def execView( p )
      end

      #
      # Overrides @ref TView::execute(). execute() is a group's main event
      # loop: it repeatedly gets events using @ref getEvent() and handles
      # them using @ref handleEvent().
      # 
      # The event loop is terminated by the group or some subview through a
      # call to @ref endModal(). Before returning, however, execute() calls
      # @ref valid() to verify that the modal state can indeed be terminated.
      # 
      def execute
      end

      # 
      # Calls the @ref TView::awaken() methods of each of the group's subviews
      # in Z-order.
      # 
      def awaken
      end

      def insertView( p, target )
      end

      #
      # Removes the subview `p' from the group and redraws the other subviews
      # as required. p's owner and next members are set to 0.
      # 
      def remove( p )
      end

      #
      # Removes the subview `p' from this group. Used internally by
      # @ref remove().
      # 
      def removeView( p )
      end

      #
      # Selects (makes current) the first subview in the chain that is
      # @ref sfVisible and @ref ofSelectable. resetCurrent() works by calling
      # setCurrent(firstMatch(sfVisible, ofSelectable), normalSelect).
      # @see TGroup::firstMatch
      # @see TGroup::setCurrent
      # @see TView::options
      # @see TView::state
      # 
      # The following enum type is useful for select mode arguments:
      # 
      # <pre>
      # enum selectMode { normalSelect, enterSelect, leaveSelect };
      # </pre>
      # 
      def resetCurrent
      end

      #
      # Parameter `selectMode' is an enumeration defined in TGroup as follows:
      # 
      # <pre>
      # enum selectMode {normalSelect, enterSelect, leaveSelect};
      # </pre>
      # 
      # If `p' is the current subview, setCurrent() does nothing. Otherwise,
      # `p' is made current (that is, selected) by a call to @ref setState().
      # @see resetCurrent
      # 
      def setCurrent( p, mode )
      end

      #
      # If `forwards' is True, selectNext() selects (makes current) the next
      # selectable subview (one with its ofSelectable bit set) in the group's
      # Z-order.
      # If `forwards' is False, the member function selects the previous
      # selectable subview.
      # 
      def selectNext( forwards )
      end

      #
      # firstThat() applies a user-supplied @ref Boolean function `func',
      # along with an argument list given by `args' (possibly empty), to each
      # subview in the group (in Z-order) until `func' returns True.
      # 
      # The returned result is the subview pointer for which `func' returns
      # True, or 0 if `func' returns False for all items.
      # 
      # The first pointer argument of `func' scans the subview. The second
      # argument of `func' is set from the `args' pointer of firstThat(), as
      # shown in the following implementation:
      # 
      # <pre>
      # TView *TGroup::firstThat(Boolean (*func)(TView *, void *), void *args)
      # {
      #     TView *temp = last;
      # 
      #     if (temp == 0) return 0;
      #     do {
      #         temp = temp->next;
      #         if (func(temp, args) == True)
      #         return temp;
      #     } while(temp != last);
      #     return 0;
      # }
      # </pre>
      # 
      def firstThat( func, args )
      end

      def focusNext(forwards)
      end

      #
      # forEach() applies an action, given by the function `func', to each
      # subview in the group in Z-order. The `args' argument lets you pass
      # arbitrary arguments to the action function:
      # 
      # <pre>
      # void TGroup::forEach(void (*func)(TView*, void *), void *args)
      # {
      #     TView *term = last;
      #     TView *temp = last;
      # 
      #     if (temp == 0) return;
      # 
      #     TView *next = temp->next;
      #     do  {
      #         temp = next;
      #         next = temp->next;
      #         func(temp, args);
      #     } while(temp != term);
      # }
      # </pre>
      # 
      def forEach( func, args )
      end

      #
      # Inserts the view given by `p' in the group's subview list. The new
      # subview is placed on top of all other subviews. If the subview has the
      # @ref ofCenterX and/or @ref ofCenterY flags set, it is centered
      # accordingly in the group.
      # @see TView::options
      # 
      # If the view has the @ref sfVisible flag set, it will be shown in the
      # group. Otherwise it remains invisible until specifically shown. If the
      # view has the @ref ofSelectable flag set, it becomes the currently
      # selected subview.
      # @see TView::state
      # 
      def insert( p )
      end

      # 
      # Inserts the view given by `p' in front of the view given by `Target'.
      # If `Target' is 0, the view is placed behind all other subviews in the
      # group.
      # 
      def insertBefore( p, target )
      end

      #
      # Points to the subview that is currently selected, or is 0 if no
      # subview is selected.
      # 
      attr_accessor :current

      #
      # Returns a pointer to the subview at `index' position in Z-order.
      # 
      def at( index )
      end

      # 
      # Returns a pointer to the first subview that matches its state with
      # `aState' and its options with `aOptions'.
      # 
      def firstMatch( aState, aOptions )
      end

      #
      # Returns the Z-order position (index) of the subview `p'.
      # 
      def indexOf( p )
      end

      #
      # Returns True if the state and options settings of the view `p' are
      # identical to those of the calling view.
      # 
      def matches( p )
      end

      #
      # Returns a pointer to the first subview (the one closest to the top in
      # Z-order), or 0 if the group has no subviews.
      # 
      def first
      end

      #
      # Overrides @ref TView::setState(). First calls the inherited
      # TView::setState(), then updates the subviews as follows (see
      # @ref state for more):
      # 
      # -# If `aState' is @ref sfActive or @ref sfDragging, then each subview's
      #    setState() is called to update the subview correspondingly.
      # -# If `aState' is @ref sfFocused, then the currently selected subview is
      #    called to focus itself correspondingly.
      # -# If `aState' is @ref sfExposed, @ref TGroup::doExpose() is called for
      #    each subview. Finally, if `enable' is False, @ref freeBuffer() is
      #    called.
      # 
      def setState( aState, enable )
      end

      #
      # Overrides @ref TView::handleEvent(). A group basically handles events by
      # passing them to the handleEvent() member functions of one or more of
      # its subviews. The actual routing, however, depends on the event class.
      # 
      # For focused events (by default, @ref evKeyDown and @ref evCommand),
      # event handling is done in three phases (see @ref phase for more):
      # 
      # -# The group's phase member is set to phPreProcess and the event
      #    is passed to the handleEvent() of all subviews that have the
      #    @ref ofPreProcess flag set in @ref options.
      # -# Phase is set to phFocused and the event is passed to the
      #    handleEvent() of the currently selected view.
      # -# Phase is set to phPostProcess and the event is passed to the
      #    handleEvent() of all subviews that have the @ref ofPostProcess flag
      #    set in @ref options.
      # 
      # For positional events (by default, @ref evMouse), the event is passed
      # to the handleEvent() of the first subview whose bounding rectangle
      # contains the point given by `event.where'.
      # 
      # For broadcast events (events that aren't focused or positional), the
      # event is passed to the handleEvent() of each subview in the group in
      # Z-order.
      # 
      # If a subview's @ref eventMask member masks out an event class,
      # TGroup::handleEvent() will never send events of that class to the
      # subview. For example, the @ref TView::eventMask disables
      # @ref evMouseUp, @ref evMouseMove, and @ref evMouseAuto, so
      # TGroup::handleEvent() will never send such events to a standard TView.
      # 
      def handleEvent( event )
      end

      #
      # Calls @ref TView::drawView() for each subview starting at `p', until
      # the subview `bottom' is reached.
      # 
      def drawSubViews( p, bottom )
      end

      #
      # Overrides @ref TView::changeBounds(). Changes the group's bounds to
      # `bounds' and then calls @ref calcBounds() followed by
      # @ref TView::changeBounds() for each subview in the group.
      # 
      def changeBounds( bounds )
      end

      #
      # Overrides @ref TView::dataSize(). Returns total size of group by
      # calling and accumulating dataSize() for each subview.
      # @see TGroup::getData
      # @see TGroup::setData
      # 
      def dataSize
      end

      # 
      # Overrides @ref TView::getData(). Calls getData() for each subview in
      # reverse order, incrementing the location given by `rec' by the
      # dataSize() of each subview.
      # @see TGroup::dataSize
      # @see TGroup::setData
      # 
      def getData( rec )
      end

      # 
      # Overrides @ref TView::setData(). Calls setData() for each subview in
      # reverse Z-order, incrementing the location given by `rec' by the
      # dataSize() of each subview.
      # @see TGroup::dataSize
      # @see TGroup::getData
      # 
      def setData( rec )
      end

      #
      # Overrides @ref TView::draw(). If a cache buffer exists (see
      # @ref TGroup::buffer data member), then the buffer is written to the
      # screen using @ref TView::writeBuf().
      # 
      # Otherwise, each subview is told to draw itself using a call to
      # @ref TGroup::redraw().
      #  
      def draw
      end

      # 
      # Redraws the group's subviews in Z-order. TGroup::redraw() differs from
      # @ref TGroup::draw() in that redraw() will never draw from the cache
      # buffer.
      # 
      def redraw
      end

      # *
      # Locks the group, delaying any screen writes by subviews until the group
      # is unlocked.
      # 
      # lock() has no effect unless the group has a cache buffer (see
      # @ref ofBuffered flag and @ref buffer data member). lock() works by
      # incrementing the data member @ref lockFlag. This semaphore is likewise
      # decremented by @ref unlock().
      # @see TView::options
      # 
      # When a call to unlock() decrements the count to zero, the entire group
      # is written to the screen using the image constructed in the cache
      # buffer.
      # 
      # By "sandwiching" draw-intensive operations between calls to lock() and
      # @ref unlock(), unpleasant "screen flicker" can be reduced, if not
      # eliminated. lock() and @ref unlock() calls must be balanced;
      # otherwise, a group may end up in a permanently locked state, causing
      # it to not redraw itself properly when so requested.
      # 
      def lock
      end

      #
      # Unlocks the group by decrementing @ref lockFlag. If @ref lockFlag
      # becomes zero, then the entire group is written to the screen using the
      # image constructed in the cache @ref buffer.
      # @see TGroup::lock
      # 
      def unlock
      end

      def resetCursor
      end

      #
      # If this group is the current modal view, endModal() terminates its
      # modal state.
      # 
      # Parameter `command' is passed to @ref TGroup::execView() (which made
      # this view modal in the first place), which returns `command' as its
      # result. If this group is not the current modal view, it calls
      # @ref TView::endModal().
      # 
      def endModal( command )
      end

      #
      # Is called whenever the modal @ref TGroup::execute() event-handling loop
      # encounters an event that cannot be handled.
      # 
      # The default action is: if the group's @ref owner is nonzero,
      # eventError() calls its owner's eventError(). Normally this chains back
      # to @ref TApplication's eventError(). You can override eventError() to
      # trigger appropriate action.
      # @see TProgram::eventError
      # 
      def eventError( event )
      end

      #
      # Returns the help context of the current focused view by calling the
      # selected subviews' @ref TView::getHelpCtx() member function.
      # 
      # If no help context is specified by any subview, getHelpCtx() returns
      # the value of its own @ref helpCtx member, by calling
      # TView::getHelpCtx().
      # 
      def getHelpCtx
      end

      # 
      # Overrides @ref TView::valid(). Returns True if all the subview's
      # valid() calls return True. TGroup::valid() is used at the end of the
      # event-handling loop in @ref execute() to confirm that termination is
      # allowed.
      # 
      # A modal state cannot terminate until all valid() calls return True. A
      # subview can return False if it wants to retain control.
      # 
      def valid( command )
      end

      #
      # Frees the group's draw buffer (if one exists) by calling delete buffer
      # and setting @ref buffer to 0.
      # 
      def freeBuffer
      end

      # 
      # If the group is @ref sfExposed and @ref ofBuffered, a draw buffer is
      # created. The buffer size will be (size.x * size.y) and the
      # @ref buffer data member is set to point at the new buffer.
      # @see TView::options
      # @see TView::state
      # 
      def getBuffer
      end

      #
      # Points to the last subview in the group (the one furthest from the top
      # in Z-order).
      # 
      attr_accessor :last

      #
      # Holds the clip extent of the group, as returned by
      # @ref TView::getExtent() or @ref TView::getClipRect(). The clip extent
      # is defined as the minimum area that needs redrawing when @ref draw() is
      # called.
      # 
      attr_accessor :clip

      #
      # The current phase of processing for a focused event. Subviews that have
      # the @ref ofPreProcess or @ref ofPostProcess flags set can examine
      # owner->phase to determine whether a call to their
      # @ref TView::handleEvent() is happening in the phPreProcess,
      # phFocused, or phPostProcess phase.
      # @see TView::options
      # 
      # phaseType is an enumeration defined as follows in TView:
      # 
      # <pre>
      # enum phaseType {phFocussed, phPreProcess, phPostProcess};
      # </pre>
      # 
      attr_accessor :phase

      #
      # Points to a buffer used to cache redraw operations, or is 0 if the
      # group has no cache buffer. Cache buffers are created and destroyed
      # automatically, unless the ofBuffered flag is cleared in the group's
      # @ref options member.
      # 
      attr_accessor :buffer

      #
      # Acts as a semaphore to control buffered group draw operations. lockFlag
      # keeps a count of the number of locks set during a set of nested draw
      # calls.
      # 
      # @ref lock() and @ref unlock() increment and decrement this value. When
      # it reaches zero, the whole group will draw itself from its buffer.
      # 
      # Intensive @ref TGroup::draw() operations should be sandwiched between
      # calls to @ref lock() and @ref unlock() to prevent excessive CPU load.
      # 
      attr_accessor :lockFlag

      #
      # Holds the state of the group after a call to @ref endModal().
      # 
      attr_accessor :endState
  private
      def invalid( p, command )
      end

      def focusView( p, enable )
      end

      def selectView( p, enable )
      end

      def findNext(forwards)
      end
  end

  # 
  # @ref TWindow inherits multiply from @ref TGroup and the virtual base class
  # TWindowInit.
  # 
  # TWindowInit provides a constructor and @ref TWindowInit::createFrame()
  # member function used in creating and inserting a frame object. A similar
  # technique is used for @ref TProgram, @ref THistoryWindow and @ref TDeskTop.
  # @short Virtual base class for TWindow
  # 
  module TWindowInit
      #
      # This constructor takes a function address argument, usually
      # &TWindow::initFrame.
      # @see TWindow::initFrame
      # 
      # Note: the @ref TWindow constructor invokes @ref TGroup constructor and
      # TWindowInit(&initFrame) to create a window object of size `bounds'
      # and associated frame. The latter is inserted in the window group
      # object.
      # @see TGroup::TGroup
      # @see TWindow::TWindow
      # 
      def initialize(cFrame)
      end

      #
      # Called by the TWindowInit constructor to create a @ref TFrame object
      # with the given bounds and return a pointer to it. A 0 pointer
      # indicates lack of success in this endeavor.
      # 
      attr_accessor :createFrame
      protected :createFrame
  end

  # ---------------------------------------------------------------------- 
  #      class TWindow                                                     
  #                                                                        
  #      Palette layout                                                    
  #        1 = Frame passive                                               
  #        2 = Frame active                                                
  #        3 = Frame icon                                                  
  #        4 = ScrollBar page area                                         
  #        5 = ScrollBar controls                                          
  #        6 = Scroller normal text                                        
  #        7 = Scroller selected text                                      
  #        8 = Reserved                                                    
  # ---------------------------------------------------------------------- 

  #
  # A TWindow object is a specialized group that typically owns a @ref TFrame
  # object, an interior @ref TScroller object, and one or two @ref TScrollBar
  # objects.
  # These attached subviews provide the "visibility" to the TWindow object.
  # 
  # TWindow inherits multiply from @ref TGroup and the virtual base class
  # @ref TWindowInit.
  # @short Implements a window
  # 
  class TWindow < TGroup
    include TWindowInit
      #
      # Calls the @ref TGroup constructor to set window bounds to `bounds'.
      # Sets default @ref state to @ref sfShadow. Sets default @ref options to
      # (@ref ofSelectable | @ref ofTopSelect). Sets default @ref growMode to
      # @ref gfGrowAll | @ref gfGrowRel. Sets default @ref flags to
      # (@ref wfMove | @ref wfGrow | @ref wfClose | @ref wfZoom). Sets the
      # @ref title data member to `aTitle' and the @ref number data member to
      # `aNumber'.
      # 
      # Calls @ref initFrame() by default, and if the resulting frame pointer
      # is nonzero, inserts it in this window's group. Finally, the default
      # @ref zoomRect is set to the given bounds.
      # 
      # `aNumber' is the number assigned to this window. If `aNumber' is
      # between 1 and 9, the number will appear in the frame title, and the
      # window can be selected with the Alt-n keys (n = 1 to 9).
      # 
      # Use the constant @ref wnNoNumber to indicate that the window is not
      # to be numbered and cannot be selected via the Alt+number key.
      # @ref wnNoNumber is defined in `views.h' as:
      # 
      # <pre>
      # const ushort @ref wnNoNumber = 0;
      # </pre>
      # 
      def initialize( bounds, aTitle, aNumber)
      end

      #
      # Calls valid(cmClose); if True is returned, the calling window is
      # deleted.
      # @see TGroup::Valid
      # 
      def close
      end

      #
      # Returns the palette string given by the palette index in the
      # @ref palette data member.
      # 
      def getPalette
      end

      #
      # Returns @ref title data member, the window's title string.
      # 
      def getTitle( maxSize )
      end

      #
      # First calls @ref TGroup::handleEvent(), and then handles events
      # specific to a TWindow as follows:
      # 
      # -# The following @ref evCommand events are handled if the @ref flags
      #    data member permits that operation:
      #    - cmResize (move or resize the window using the @ref dragView()
      #      member function);
      #    - cmClose (close the window by creating a cmCancel event);
      #    - cmZoom (zoom the window using the @ref zoom() member function).
      # -# @ref evKeyDown events with a keyCode value of kbTab or kbShiftTab
      #    are handled by selecting the next or previous selectable subview (if
      #    any).
      # -# An @ref evBroadcast event with a command value of cmSelectWindowNum
      #    is handled by selecting the window if the `event.infoInt' data
      #    member is equal to @ref number data member.
      # 
      def handleEvent( event )
      end

      #
      # Creates a @ref TFrame object for the window and stores a pointer to the
      # frame in the @ref frame data member. TWindow constructor calls
      # initFrame(); it should never be called directly. You can override
      # initFrame() to instantiate a user-defined class derived from
      # @ref TFrame instead of the standard @ref TFrame.
      # 
      def self.initFrame(TRect)
      end

      #
      # First calls TGroup::setState(aState, enable). Then, if `aState' is
      # equal to @ref sfSelected, activates or deactivates the window and all
      # its subviews using a call to setState(sfActive, enable), and calls
      # @ref enableCommands() or @ref disableCommands() for cmNext, cmPrev,
      # cmResize, cmClose and cmZoom.
      # @see TGroup::setState
      # @see TView::state
      # 
      def setState( aState, enable )
      end

      #
      # Overrides TView::sizeLimits(). First calls TView::sizeLimits(min, max)
      # and then changes `min' to the minimum window size, minWinSize, a
      # @ref TPoint constant defined at the head of file `TWindow.cc'.
      # minWinSize is currently set to (16, 6).
      # 
      # minWinSize defines the minimum size of a TWindow or of any class
      # derived from TWindow. Any change to minWinSize affects all windows,
      # unless a window's sizeLimits() member function is overridden.
      # 
      def sizeLimits( min, max )
      end

      #
      # Creates, inserts, and returns a pointer to a "standard" scroll bar for
      # the window. "Standard" means the scroll bar fits onto the frame of the
      # window without covering the corners or the resize icon.
      # 
      # The `aOptions' parameter can be either @ref sbHorizontal to produce a
      # horizontal scroll bar along the bottom of the window or
      # @ref sbVertical to produce a vertical scroll bar along the right side
      # of the window.
      # 
      # Either may be combined with @ref sbHandleKeyboard to allow the scroll
      # bar to respond to arrows and page keys from the keyboard in addition
      # to mouse clicks.
      # 
      # The following values can be passed to standardScrollBar():
      # 
      # <pre>
      # Constant         Value  Meaning
      # 
      # @ref sbHorizontal     0x0000 Scroll bar is horizontal
      # @ref sbVertical       0x0001 Scroll bar is vertical
      # @ref sbHandleKeyboard 0x0002 Scroll bar responds to keyboard commands
      # </pre>
      # 
      def standardScrollBar( aOptions )
      end

      #
      # Zooms the calling window. This member function is usually called in
      # response to a cmZoom command (triggered by a click on the zoom icon).
      # zoom() takes into account the relative sizes of the calling window and
      # its owner, and the value of @ref zoomRect.
      # 
      def zoom
      end

      #
      # The flags data member contains a combination of mnemonics constants
      # that define bits. If the bits are set, the window will have the
      # corresponding attribute: the window can move, grow, close or zoom.
      # 
      # The window flags are defined as follows:
      # 
      # <pre>
      # Constant Value Meaning
      # 
      # @ref wfMove   0x01  Window can be moved
      # 
      # @ref wfGrow   0x02  Window can be resized and has a grow icon in the
      #                lower-right corner
      # 
      # @ref wfClose  0x04  Window frame has a close icon that can be mouse-clicked
      #                to close the window
      # 
      # @ref wfZoom   0x08  Window frame has a zoom icon that can be mouse-clicked
      #                to zoom the window
      # </pre>
      # 
      # If a particular bit is set, the corresponding property is enabled;
      # otherwise that property is disabled.
      # 
      attr_accessor :flags

      #
      # The normal, unzoomed boundary of the window.
      # 
      attr_accessor :zoomRect

      #
      # The number assigned to this window. If number is between 1 and 9,
      # the number will appear in the frame title, and the window can be
      # selected with the Alt-n keys (n = 1 to 9).
      # 
      attr_accessor :number

      #
      # Specifies which palette the window is to use: @ref wpBlueWindow,
      # @ref wpCyanWindow or @ref wpGrayWindow. These constants define the
      # three standard color mapping assignments for windows:
      # 
      # <pre>
      # Constant     Value  Meaning
      # 
      # @ref wpBlueWindow 0      Window text is yellow on blue
      # @ref wpCyanWindow 1      Window text is blue on cyan
      # @ref wpGrayWindow 2      Window text is black on gray
      # </pre>
      # 
      # By default, the TWindow palette is @ref wpBlueWindow. The default for
      # @ref TDialog objects is @ref wpGrayWindow.
      # 
      attr_accessor :palette

      #
      # Pointer to this window's associated TFrame object.
      # 
      attr_accessor :frame

      #
      # A character string giving the (optional) title that appears on the
      # frame.
      # 
      attr_accessor :title
  end

end
