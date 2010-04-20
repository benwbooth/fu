module TVRuby::System

  # Event codes

  # \var evMouseDown
  # Mouse button pressed.
  # @see TEvent::what
  # 
  EvMouseDown = 0x0001

  # \var evMouseUp
  # Mouse button released.
  # @see TEvent::what
  # 
  EvMouseUp   = 0x0002

  # \var evMouseMove
  # Mouse changed location.
  # @see TEvent::what
  # 
  EvMouseMove = 0x0004

  # \var evMouseAuto
  # Periodic event while mouse button held down.
  # @see TEvent::what
  # 
  EvMouseAuto = 0x0008

  # \var evKeyDown
  # Key pressed.
  # @see TEvent::what
  # 
  EvKeyDown   = 0x0010

  # \var evCommand
  # Command event.
  # @see TEvent::what
  # 
  EvCommand   = 0x0100

  # \var evBroadcast
  # Broadcast event.
  # @see TEvent::what
  # 
  EvBroadcast = 0x0200

  # Event masks

  # \var evNothing
  # Event already handled.
  # @see TEvent::what
  # 
  EvNothing   = 0x0000

  # \var evMouse
  # Mouse event.
  # @see TEvent::what
  # 
  EvMouse     = 0x000f

  # \var evKeyboard
  # Keyboard event.
  # @see TEvent::what
  # 
  EvKeyboard  = 0x0010

  # \var evMessage
  # Message (command, broadcast, or user-defined) event.
  # @see TEvent::what
  # 
  EvMessage   = 0xFF00

  # Mouse button state masks

  MbLeftButton  = 0x01
  MbRightButton = 0x02

  # Mouse event flags

  MeMouseMoved = 0x01
  MeDoubleClick = 0x02

  #
  # Stores mouse events.
  # 
  # This structure holds the data that characterizes a mouse event: button
  # number, whether double-clicked, and the coordinates of the point where the
  # click was detected.
  # @see TEvent
  # @see TEventQueue
  # @short Information about mouse events
  # 
  class MouseEventType
      #
      # This is the position where the event happened.
      # 
      attr_accessor :where

      #
      # Helps to specify the event.
      # 
      # This bitmap variable is set to meDoubleClick if a double-click event
      # happened. If the mouse is simply moved its value is meMouseMoved.
      # Otherwise its value is 0.
      # 
      # <pre>
      # Flag          Value Meaning
      # 
      # meMouseMoved  0x01  Set if mouse is moved
      # meDoubleClick 0x02  Set if a button was double clicked
      # </pre>
      # 
      attr_accessor :eventFlags           # Replacement for doubleClick.

      # 
      # This bitmap variable stores the status of the control keys when the
      # event happened. The following values define keyboard states, and can be
      # used when examining the keyboard shift state:
      # 
      # <pre>
      # Flag          Value  Meaning
      # 
      # kbRightShift  0x0001 Set if the Right Shift key is currently down
      # kbLeftShift   0x0002 Set if the Left Shift key is currently down
      # kbCtrlShift   0x0004 Set if the Ctrl key is currently down
      # kbAltShift    0x0008 Set if the Alt key is currently down
      # kbScrollState 0x0010 Set if the keyboard is in the Scroll Lock state
      # kbNumState    0x0020 Set if the keyboard is in the Num Lock state
      # kbCapsState   0x0040 Set if the keyboard is in the Caps Lock state
      # kbInsState    0x0080 Set if the keyboard is in the Ins Lock state
      # </pre>
      # 
      # Its value is 0 if none of these keys was pressed. Warning: this
      # information is not reliable. Its value depends on your operating system
      # and libraries (gpm, ncurses). Usually only a subset of these flags are
      # detected. See file `system.cc' for details.
      # 
      attr_accessor :controlKeyState

      #
      # This variable reports the status of the mouse buttons when the event
      # happened. It's a combination of the following constants:
      # 
      # <pre>
      # Flag          Value Meaning
      # 
      # mbLeftButton  0x01  Set if left button was pressed
      # mbRightButton 0x02  Set if right button was pressed
      # </pre>
      # 
      # These constants are useful when examining the buttons data member. For
      # example:
      # 
      # <pre>
      # if ((event.what == @ref evMouseDown) && (event.buttons == mbLeftButton))
      #     doLeftButtonDownAction();
      # </pre>
      # 
      # Note: you can swap left and right buttons by setting variable
      # @ref TEventQueue::mouseReverse to True. See the `demo' program for more
      # information.
      # 
      attr_accessor :buttons
  end

  #
  # This structure stores information about a key.
  # @see KeyDownEvent
  # @see TEvent
  # @short Information about a key
  # 
  class CharScanType
  #if (BYTE_ORDER == LITTLE_ENDIAN)
      #
      # This is the character code.
      # 
      # Its value is non-zero if the key has a standard code, like ASCII
      # characters. The value is zero if the key falls in the special key
      # class, like arrows, page up, etc.
      # 
      attr_accessor :charCode

      #
      # This is the scan code.
      # 
      # Its value is non-zero if the key falls in the special key class. The
      # value is zero if the key is an ASCII character.
      # 
      attr_accessor :scanCode
  end

  #
  # This structure stores information about key presses.
  # 
  # The KeyDownEvent structure is a union of keyCode (a ushort) and charScan
  # (of type struct @ref CharScanType). These two members represent two ways of
  # viewing the same data: either as a scan code or as a key code.
  # 
  # Scan codes are what your program receives from the keyboard, while key
  # codes are usually needed in a switch statement.
  # 
  # See file `tkeys.h' for a list of keycodes.
  # @see TEvent
  # @short Information about key presses
  # 
  class KeyDownEvent
      # 
      # This is the key code.
      # 
      # It is the concatenation of the scan code and the character code.
      # @see CharScanType
      # 
      attr_accessor :keyCode

      # 
      # The same as above, but splitted in its two components.
      # @see CharScanType
      # 
      attr_accessor :charScan

      #
      # Stores the status of the control keys when the event happened. The
      # following values define keyboard states, and can be used when
      # examining the keyboard shift state:
      # 
      # <pre>
      # Constant      Value  Meaning
      # 
      # kbRightShift  0x0001 Set if the Right Shift key is currently down
      # kbLeftShift   0x0002 Set if the Left Shift key is currently down
      # kbCtrlShift   0x0004 Set if the Ctrl key is currently down
      # kbAltShift    0x0008 Set if the Alt key is currently down
      # kbScrollState 0x0010 Set if the keyboard is in the Scroll Lock state
      # kbNumState    0x0020 Set if the keyboard is in the Num Lock state
      # kbCapsState   0x0040 Set if the keyboard is in the Caps Lock state
      # kbInsState    0x0080 Set if the keyboard is in the Ins Lock state
      # </pre>
      # 
      # Its value is 0 if none of these keys was pressed. Warning: this
      # information is not reliable. Its value depends on your operating system
      # and libraries (gpm, ncurses). Usually only a subset of these flags are
      # detected. See file `system.cc' for details.
      # 
      attr_accessor :controlKeyState
  end

  #
  # This structure stores information about message events.
  # 
  # A message event is a command, specified by the command field, together with
  # one of several additional pieces of information, ranging from a single byte
  # of data to a generic pointer.
  # 
  # This arrangement allows for great flexibility when TVision objects need to
  # transmit and receive messages to and from other TVision objects.
  # @see TEvent
  # @short Information about message events
  # 
  class MessageEvent
      #
      # Is the code of the command.
      # 
      # See `views.h' for a list of standard commands. Other commands are
      # defined in `colorsel.h', `dialogs.h', `editors.h', `outline.h' and
      # `stddlg.h'.
      # 
      attr_accessor :command

      #
      # A generic pointer.
      # 
      # I suggest you to pay attention to these fields. Use always the same
      # type in the sender and in the receivers of the message. Otherwise
      # you may experiment portability problems.
      # 
      attr_accessor :infoPtr

      #
      # A signed long.
      # 
      attr_accessor :infoLong

      #
      # An unsigned short.
      # 
      attr_accessor :infoWord

      #
      # A signed short.
      # 
      attr_accessor :infoInt

      #
      # An unsigned byte.
      # 
      attr_accessor :infoByte

      # 
      # A signed character.
      # 
      attr_accessor :infoChar
  end

  #
  # TEvent holds a union of objects of type:
  # 
  # @ref KeyDownEvent
  # @ref MessageEvent
  # @ref MouseEventType
  # 
  # keyed by the what field. The @ref TView::handleEvent() member functions and
  # its derived classes take a TEvent object as argument and respond with the
  # appropriate action.
  # @short Information about events
  # 
  class TEvent
      #
      # This field reports the event's type. Some mnemonics are defined to
      # indicate types of events to TVision event handlers. The following
      # evXXXX constants are used in several places: in the what data member
      # of an TEvent structure, in the @ref TView::eventMask data member of a
      # view object, and in the @ref positionalEvents and @ref focusedEvents
      # variables.
      # 
      # The following event values designate standard event types:
      # 
      # <pre>
      # Constant    Value  Meaning
      # 
      # @ref evMouseDown 0x0001 Mouse button pressed
      # @ref evMouseUp   0x0002 Mouse button released
      # @ref evMouseMove 0x0004 Mouse changed location
      # @ref evMouseAuto 0x0008 Periodic event while mouse button held down
      # @ref evKeyDown   0x0010 Key pressed
      # @ref evCommand   0x0100 Command event
      # @ref evBroadcast 0x0200 Broadcast event
      # </pre>
      # 
      # The following constants can be used to mask types of events:
      # 
      # <pre>
      # Constant   Value  Meaning
      # 
      # @ref evNothing  0x0000 Event already handled
      # @ref evMouse    0x000F Mouse event
      # @ref evKeyboard 0x0010 Keyboard event
      # @ref evMessage  0xFF00 Message (command, broadcast, or user-defined) event
      # </pre>
      # 
      # The above standard event masks can be used to determine whether an
      # event belongs to a particular "family" of events. For example:
      # 
      # <pre>
      # if ((event.what & @ref evMouse) != 0) doMouseEvent();
      # </pre>
      # 
      attr_accessor :what
      attr_accessor :mouse
      attr_accessor :keyDown
      attr_accessor :message
  end

  #
  # Stores some information about mouse.
  # 
  # The inner details will seldom be of interest in normal applications. It
  # will usually be sufficient to know how the TEvent structure interacts with
  # @ref TView::handleEvent() and its derivatives.
  # 
  # Some old stuff is removed.
  # @see MouseEventType
  # @short Information about mouse
  # 
  class TEventQueue
      #
      # In this time interval button presses are recognized as double-click
      # events.
      # 
      # Not used in this port. It is still here only for backward compatibility
      # (the `demo' program uses it). See `system.cc' for details.
      # 
      attr_accessor :doubleDelay

      #
      # If set to True left and right mouse buttons are swapped. See the `demo'
      # program for more information.
      # 
      attr_accessor :mouseReverse
  end

  #
  # TDisplay provides low-level video functions for its derived class TScreen.
  # 
  # These, and the other system classes in `system.h', are used internally by
  # TVision and you would not need to use them explicitly for normal
  # applications.
  # 
  # Some old stuff is removed.
  # @short Display information
  # 
  class TDisplay
      #
      # Mnemonics for the video modes used by TDisplay.
      # 
      # This port uses smCO80 and smMono only.
      # 
      SmBW80	  = 0x0002
      SmCO80	  = 0x0003
      SmMono	  = 0x0007
      SmFont8x8 = 0x0100
  end

  #
  # A low-level class used to interface to the system.
  # 
  # TScreen provides low-level video attributes and functions. This class is
  # used internally by TVision. You do not need to use it explicitly for normal
  # applications.
  # 
  # Since this class was rewritten in the porting process, it is not a standard
  # class and you should not use it. Otherwise you may end with a non-portable
  # program.
  # @short The interface to the system
  # 
  class TScreen < TDisplay
      # 
      # Constructor.
      # 
      # Reads enviroment variables, acquires screen size, opens mouse and
      # screen devices, catches some useful signals and starts an interval
      # timer.
      # 
      def initialize
      end

      #
      # Returns the first available event.
      # 
      def self.getEvent(event)
      end

      #
      # Emits a beep.
      # 
      def self.makeBeep
      end

      # 
      # Puts an event in the event queue.
      # 
      # Do not use it, use @ref TProgram::putEvent() if you need.
      # 
      def self.putEvent(event)
      end

      # 
      # Recovers the execution of the application.
      # 
      # Resumes the execution of the process after the user stopped it.
      # Called by @ref TApplication::resume(). You should call the latter
      # method.
      # 
      def self.resume
      end

      # 
      # Stops the execution of the application.
      # 
      # Suspends execution of the process.
      # Called by @ref TApplication::suspend(). You should call the latter
      # method.
      # 
      def self.suspend
      end

      # 
      # Shows or hides the cursor.
      # 
      # Flag `show' specifies the operation to perform.
      # 
      def self.drawCursor(show)
      end

      # 
      # Shows or hides the mouse pointer.
      # 
      # Flag `show' specifies the operation to perform.
      # 
      def self.drawMouse(show)
      end

      #
      # Moves the cursor to another place.
      # 
      # Parameters `x' and `y' are 0-based.
      # 
      def self.moveCursor(x, y)
      end

      #
      # Writes a row of character & attribute pairs on the screen.
      # 
      # `dst' is the destination position, `src' is a pointer to the source
      # buffer and `len' is the size of the buffer expressed as the number
      # of pairs.
      # 
      def self.writeRow(dst, src, len)
      end

      class << self
        #
        # Holds the current screen mode.
        # 
        # It is initialized by the constructor if this class. It is read by
        # @ref TProgram::initScreen().
        # @see TDisplay
        # 
        attr_accessor :screenMode

        # 
        # Holds the current screen width.
        # 
        # It is initialized by the constructor of this class.
        # 
        attr_accessor :screenWidth

        #
        # Holds the current screen height.
        # 
        # It is initialized by the constructor of this class.
        # 
        attr_accessor :screenHeight

        # 
        # Holds the current screen buffer address.
        # 
        # It is initialized by the constructor of this class.
        # 
        attr_accessor :screenBuffer

        # 
        # File descriptor set to watch for read operations.
        # 
        # This set is used to watch for incoming mouse and keyboard data.
        # Do not FD_ZERO() it in your program. However, FD_SET() and FD_CLR()
        # are OK.
        # 
        attr_accessor :fdSetRead

        #
        # File descriptor set to watch for write operations.
        # 
        # This set is used in @ref select() within getEvent(). It is empty by
        # default and can be used freely.
        # 
        attr_accessor :fdSetWrite

        #
        # File descriptor set to watch for I/O exceptions.
        # 
        # This set is used in select() within @ref getEvent(). It is empty by
        # default and can be used freely.
        # 
        attr_accessor :fdSetExcept

        #
        # File descriptor set to indicate read() availability.
        # 
        # This set is returned by select() within @ref getEvent(). It can be
        # tested to handle operations on files mentioned in @ref fdSetRead.
        # 
        attr_accessor :fdActualRead

        # 
        # File descriptor set to indicate write() completion.
        # 
        # This set is returned by select() within @ref getEvent(). It can be
        # tested to handle operations on files mentioned in @ref fdSetWrite.
        # 
        attr_accessor :fdActualWrite

        #
        # File descriptor set to indicate I/O exceptions.
        # 
        # This set is returned by select() within @ref getEvent(). It can be
        # tested to handle exceptions on files mentioned in @ref fdSetExcept.
        # 
        attr_accessor :fdActualExcept
      end
  end
end

