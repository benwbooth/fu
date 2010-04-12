# 
# The mother of @ref TApplication.
# 
# TProgram provides the basic template for all standard TVision
# applications. All programs must be derived from TProgram or its immediate
# derived class, @ref TApplication. @ref TApplication differs from TProgram
# only for its constructor and destructor. However most applications will
# be derived from @ref TApplication.
# @short The mother of TApplication
# 
class TProgram < TGroup
  include TProgInit
public
    # 
    # Constructor.
    # 
    # The TProgram constructor calls the @ref TProgInit constructor, passing
    # to it the addresses of three init functions. The @ref TProgInit
    # constructor creates a status line, menu bar, and desk top.
    # 
    # If these calls are successful, the three objects are inserted into the
    # TProgram group. Variables @ref statusLine, @ref menuBar and
    # @ref deskTop are set to point at these new objects.
    # 
    # The @ref TGroup constructor is also invoked to create a full screen
    # view; the video buffer and default palettes are initialized; and the
    # following state flags are set:
    # 
    # <pre>
    # state = @ref sfVisible | @ref sfSelected | @ref sfFocused |
    #         @ref sfModal | @ref sfExposed;
    # </pre>
    # 
    def initialize
    end

    # 
    # Returns True if the focus can be moved from one desktop view to another
    # one.
    # 
    # It just returns `deskTop->valid(cmReleasedFocus)'.
    # @see TGroup::valid
    # 
    def canMoveFocus
    end

    # 
    # Executes a dialog.
    # 
    # `pD' points to the dialog. The dialog is executed only if it is valid.
    # @see TDialog::valid
    # 
    # `data' is a pointer to the memory area where the dialog data will be
    # read before executing the dialog and where the dialog data will be
    # written after executing the dialog. If `data' is 0 no data area is
    # used.
    # @see TGroup::getData
    # @see TGroup::setData
    # 
    # This method calls @ref TGroup::execView() to execute the dialog. The
    # dialog is destroyed before returning from the function, so a call to
    # delete is not necessary. executeDialog() returns cmCancel if the view
    # is not valid, otherwise it returns the return value of
    # @ref TGroup::execView().
    # 
    def executeDialog(pD, data)
    end

    # 
    # Gets an event.
    # 
    # This method collects events from the system like key events, mouse
    # events and timer events and returns them in the `event' structure.
    # 
    # getEvent() first checks if @ref TProgram::putEvent() has generated a
    # pending event. If so, getEvent() returns that event. If there is no
    # pending event, getEvent() calls @ref TScreen::getEvent(). 
    # 
    # If both calls return @ref evNothing, indicating that no user input is
    # available, getEvent() calls @ref TProgram::idle() to allow "background"
    # tasks to be performed while the application is waiting for user input.
    # @see @ref TProgram::idle()
    # 
    # Before returning, getEvent() passes any @ref evKeyDown and
    # @ref evMouseDown events to the @ref statusLine for it to map into
    # associated @ref evCommand hot key events.
    # 
    def getEvent(event)
    end

    # 
    # Returns a reference to the standard TProgram palette.
    # 
    # Returns the palette string given by the palette index in
    # @ref appPalette. TProgram supports three palettes. @ref appPalette is
    # initialized by @ref TProgram::initScreen().
    # 
    def getPalette
    end

    # 
    # Standard TProgram event handler.
    # 
    # This method first checks for keyboard events. When it catches keys from
    # Alt-1 to Alt-9 it generates an @ref evBroadcast event with the `command'
    # field equal to cmSelectWindowNum and the `infoPtr' field in the range 1
    # to 9.
    # 
    # Then it calls @ref TGroup::handleEvent().
    # 
    # Last it checks for a cmQuit command in a @ref evCommand event. On
    # success it calls TGroup::endModal(cmQuit) to end the modal state. This
    # causes @ref TProgram::run() method to return. In most applications
    # this will result in program termination.
    # @see TGroup::endModal
    # 
    # Method handleEvent() is almost always overridden to introduce handling
    # of commands that are specific to your own application.
    # 
    def handleEvent(event)
    end

    # 
    # Called when in idle state.
    # 
    # This method is called whenever the library is in idle state, i.e. there
    # is not any event to serve. It allows the application to perform
    # background tasks while waiting for user input.
    # 
    # The default idle() calls statusLine->update() to allow the status line
    # to update itself according to the current help context. Then, if the
    # command set has changed since the last call to idle(), an
    # @ref evBroadcast with a command value of cmCommandSetChanged is
    # generated to allow views that depend on the command set to enable or
    # disable themselves.
    # @see TStatusLine::update
    # 
    # Note: in the original DOS version this method was called continously.
    # In my port this method is called about 10 times in a second. This
    # result in less CPU load.
    # 
    # The user may redefine this method, for example, to update a clock in
    # the upper right corner of the screen, like the `demo' program does.
    # 
    def idle
    end

    # 
    # Initializes the screen.
    # 
    # This method is called by the TProgram constructor and
    # @ref setScreenMode() every time the screen mode is initialized or
    # changed.
    # @see TProgram::TProgram
    # 
    # Performs the updating and adjustment of screen mode-dependent variables
    # for shadow size, markers and application palette (color, monochrome or
    # black & white). The shadows are usually painted in the right and bottom
    # sides of menus and windows.
    # 
    def initScreen
    end

    # 
    # Called on out of memory condition.
    # 
    # It is called from @ref validView() whenever @ref lowMemory() returns
    # True.
    # 
    # This happens when there is few free memory. Of course this should
    # rarely happen. This method may be redefined to tell the user (by
    # calling @ref messageBox() for example) that there is not free memory
    # to end the current task.
    # 
    def outOfMemory
    end

    # 
    # Sets a pending event.
    # 
    # Puts an event in the pending state, by storing a copy of the `event'
    # structure in the @ref pending variable, a static member of TProgram.
    # 
    # Only one event is allowed to be pending. The next call to
    # @ref getEvent() will return this pending event even if there are
    # other events in the system queue to be handled.
    # 
    def putEvent( event )
    end

    # 
    # Runs TProgram.
    # 
    # Executes TProgram by calling its method @ref execute(), which TProgram
    # inherits from TGroup.
    # 
    def run
    end

    # 
    # Inserts a window in the TProgram.
    # 
    def insertWindow(TWindow)
    end

    # 
    # Sets a new screen mode.
    # 
    # The `mode' parameter can by one of the constants smCO80, smBW80 or
    # smMono, defined in `system.h' as follows. Optionally the value may be
    # or-ed with smFont8x8.
    # 
    # <pre>
    # Constant  Value  Meaning
    # 
    # smBW80    0x0002 Requires black & white screen, 80 columns
    # smCO80    0x0003 Requires color screen, 80 columns
    # smMono    0x0007 Requires monochrome screen
    # smFont8x8 0x0100 Requires small size font
    # </pre>
    # 
    # Note: in my port this method only redraws the screen.
    # 
    def setScreenMode( mode )
    end

    # 
    # Checks if a view is valid.
    # 
    # Returns `p' if the view pointed by `p' is valid. Otherwise returns a
    # null pointer.
    # 
    # First, if `p' is 0 the call returns 0.
    # 
    # Next, if @ref lowMemory() returns True the view pointed by `p' is
    # released by calling @ref TObject::destroy() followed by
    # @ref outOfMemory() and the function returns 0.
    # 
    # Last if a call to `p->valid(cmValid)' returns False the view pointed by
    # `p' is released and the function returns 0.
    # @see TView::valid
    # 
    # Otherwise, the view is considered valid, and pointer `p' is returned.
    # 
    def validView( p )
    end

    # 
    # Releases TProgram resources.
    # 
    # Used internally by @ref TObject::destroy() to ensure correct
    # destruction of derived and related objects.
    # @see TObject::shutDown
    # 
    # This method releases all the resources allocated by TProgram. It sets
    # pointers @ref statusLine, @ref menuBar and @ref deskTop to 0 and then
    # calls @ref TGroup::shutDown() and @ref TVMemMgr::clearSafetyPool().
    # 
    def shutDown
    end

    # 
    # Stops the execution of the application.
    # 
    # This method is empty. Will be redefined in TApplication which is a
    # child of TProgram.
    # @see TApplication::suspend
    # 
    def suspend
    end

    # 
    # Restores the execution of the application.
    # 
    # This method is empty. Will be redefined in TApplication which is a
    # child of TProgram.
    # @see TApplication::resume
    # 
    def resume
    end

    # 
    # Creates a new status line.
    # 
    # This method creates a standard @ref TStatusLine view and returns its
    # address.
    # 
    # The address of this function is passed to the @ref TProgInit
    # constructor, which creates a @ref TStatusLine object for the
    # application and stores a pointer to it in the @ref statusLine static
    # member.
    # 
    # initStatusLine() should never be called directly. initStatusLine() is
    # almost always overridden to instantiate a user defined @ref TStatusLine
    # instead of the default empty @ref TStatusLine.
    # 
    def initStatusLine( TRect )
    end

    # 
    # Creates a new menu bar.
    # 
    # This method creates a standard @ref TMenuBar view and returns its
    # address.
    # 
    # The address of this function is passed to the @ref TProgInit
    # constructor, which creates a @ref TMenuBar object for the
    # application and stores a pointer to it in the @ref menuBar static
    # member.
    # 
    # initMenuBar() should never be called directly. initMenuBar() is almost
    # always overridden to instantiate a user defined @ref TMenuBar
    # instead of the default empty @ref TMenuBar.
    # 
    def initMenuBar( TRect )
    end

    # 
    # Creates a new desktop.
    # 
    # This method creates a standard @ref TDeskTop view and returns its
    # address.
    # 
    # The address of this function is passed to the @ref TProgInit
    # constructor, which creates a @ref TDeskTop object for the
    # application and stores a pointer to it in the @ref deskTop static
    # member.
    # 
    # initDeskTop() should never be called directly. Few applications need to
    # redefine it to have a custom desktop, instead of the default empty
    # @ref TDeskTop.
    # 
    def initDeskTop( TRect )
    end

    # 
    # A pointer to the current application, direct istance of TProgram or
    # istance of another class derived from TProgram, usually
    # @ref TApplication.
    # Set to this by the @ref TProgInit constructor.
    # 
    # Only one TProgram object can exist at any time. In this way every
    # object can call TProgram methods even if it does't know its name.
    # 
    @application
    class << self 
      attr_accessor :application 
    end

    # 
    # A pointer to the current status line object, set by a call to
    # @ref TProgInit::createStatusLine() in the TProgram constructor. The
    # resulting status line is inserted into the TProgram group.
    # 
    # May be 0 if no status line exist.
    # 
    @statusLine
    class << self 
      attr_accessor :statusLine
    end

    # 
    # A pointer to the current menu bar object, set by a call to
    # @ref TProgInit::createMenuBar() in the TProgram constructor. The
    # resulting menu bar is inserted into the TProgram group.
    # 
    # May be 0 if no menu bar exist.
    # 
    @menuBar
    class << self 
      attr_accessor :menuBar
    end

    # 
    # A pointer to the current desk top object, set by a call to
    # @ref TProgInit::createDeskTop() in the TProgram constructor. The
    # resulting desk top is inserted into the TProgram group.
    # 
    # May be 0 if no desk top exist.
    # 
    @deskTop
    class << self 
      attr_accessor :deskTop
    end

    # 
    # The current application palette. Indexes the default palette for this
    # application. The @ref TPalette object corresponding to appPalette is
    # returned by @ref getPalette().
    # This value is set automatically at startup by @ref initScreen().
    # 
    # The following application palette constants are defined:
    # 
    # <pre>
    # Constant     Value Meaning
    # 
    # @ref apColor      0     Use palette for color screen
    # @ref apBlackWhite 1     Use palette for LCD screen
    # @ref apMonochrome 2     Use palette for monochrome screen
    # </pre>
    # 
    @appPalette
    class << self 
      attr_accessor :appPalette
    end

    # The current pending event.
    # 
    # This structure contains the current pending event, if any exists. A
    # maximum of one pending event may be set by calling @ref putEvent().
    # 
    @pending
    class << self 
      attr_accessor :pending
    end

    static const char * exitText;
    @exitText
    class << self 
      attr_accessor :exitText
    end
end

