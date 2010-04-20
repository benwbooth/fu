module TVRuby::Dialogs
  # \var bfNormal
  # Button is a normal, non-default button.
  # @see TButton::flag
  # 
  BfNormal    = 0x00

  # \var bfDefault
  # Button is the default button: if this bit is set this button will be
  # highlighted as the default button.
  # @see TButton::flag
  # 
  BfDefault   = 0x01

  # \var bfLeftJust
  # Button label is left-justified; if this bit is clear the title will be
  # centered.
  # @see TButton::flag
  # 
  BfLeftJust  = 0x02

  # \var bfBroadcast
  # Sends a broadcast message when pressed.
  # @see TButton::flag
  # 
  BfBroadcast = 0x04

  # \var bfGrabFocus
  # The button grabs the focus when pressed.
  # @see TButton::flag
  # 
  BfGrabFocus = 0x08
  CmRecordHistory = 60

  # ---------------------------------------------------------------------- 
  #      class TDialog                                                     
  #                                                                        
  #      Palette layout                                                    
  #        1 = Frame passive                                               
  #        2 = Frame active                                                
  #        3 = Frame icon                                                  
  #        4 = ScrollBar page area                                         
  #        5 = ScrollBar controls                                          
  #        6 = StaticText                                                  
  #        7 = Label normal                                                
  #        8 = Label selected                                              
  #        9 = Label shortcut                                              
  #       10 = Button normal                                               
  #       11 = Button default                                              
  #       12 = Button selected                                             
  #       13 = Button disabled                                             
  #       14 = Button shortcut                                             
  #       15 = Button shadow                                               
  #       16 = Cluster normal                                              
  #       17 = Cluster selected                                            
  #       18 = Cluster shortcut                                            
  #       19 = InputLine normal text                                       
  #       20 = InputLine selected text                                     
  #       21 = InputLine arrows                                            
  #       22 = History arrow                                               
  #       23 = History sides                                               
  #       24 = HistoryWindow scrollbar page area                           
  #       25 = HistoryWindow scrollbar controls                            
  #       26 = ListViewer normal                                           
  #       27 = ListViewer focused                                          
  #       28 = ListViewer selected                                         
  #       29 = ListViewer divider                                          
  #       30 = InfoPane                                                    
  #       31 = Cluster Disabled                                            
  #       32 = Reserved                                                    
  # ---------------------------------------------------------------------- 

  CpGrayDialog = \
      "\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2A\x2B\x2C\x2D\x2E\x2F"\
      "\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3A\x3B\x3C\x3D\x3E\x3F"

  CpBlueDialog = \
      "\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f"\
      "\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f"

  CpCyanDialog = \
      "\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f"\
      "\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e\x7f"

  CpDialog = CpGrayDialog

  DpBlueDialog = 0
  DpCyanDialog = 1
  DpGrayDialog = 2

  #
  # TDialog is a simple child of @ref TWindow.
  # 
  # Data member @ref growMode is set to zero; that is, dialog boxes are not
  # growable. The @ref flags data member is set for @ref wfMove and
  # @ref wfClose; that is, dialog boxes are moveable and closable (a close
  # icon is provided).
  # 
  # The TDialog event handler calls @ref TWindow::handleEvent() but additionally
  # handles the special cases of Esc and Enter key responses.
  # The Esc key generates a cmCancel command, while Enter generates the
  # cmDefault command.
  # @see TDialog::handleEvent
  # 
  # The @ref TDialog::valid() member function returns True on cmCancel;
  # otherwise, it calls its @ref TGroup::valid().
  # @short A non-growable child of TWindow, usually used as a modal view
  # 
  class TDialog < TWindow
  public
      #
      # Creates a dialog box with the given size and title by calling
      # TWindow::TWindow(bounds, aTitle, wnNoNumber) and
      # TWindowInit::TWindowInit(&TDialog::initFrame).
      # @see TWindow::TWindow
      # @see TWindowInit::TWindowInit
      # 
      # @ref growMode is set to 0, and @ref flags is set to @ref wfMove |
      # @ref wfClose.
      # 
      # By default, dialog boxes can move and close (via the close icon) but
      # cannot grow (resize).
      # 
      # Note that TDialog does not define its own destructor, but uses
      # @ref TWindow::close() and the destructors inherited from @ref TWindow,
      # @ref TGroup, and @ref TView.
      # @see TWindow::~TWindow
      # 
      def initialize( bounds, aTitle )
      end

      #
      # Returns the default palette string.
      # 
      def getPalette
      end

      #
      # Calls TWindow::handleEvent(event), then handles Enter and Esc key
      # events specially.
      # @see TWindow::handleEvent
      # 
      # In particular, Esc generates a cmCancel command, and Enter broadcasts a
      # cmDefault command.
      # 
      # This member function also handles cmOK, cmCancel, cmYes, and cmNo
      # command events by ending the modal state of the dialog box.
      # 
      # For each of the above events handled successfully, this member function
      # calls @ref clearEvent().
      # 
      def handleEvent( event )
      end

      #
      # Returns True if the command argument is cmCancel. This is the command
      # generated by @ref handleEvent() when the Esc key is detected.
      # 
      # If the command argument is not cmCancel, valid calls
      # TGroup::valid(command) and returns the result of this call.
      # @see TGroup::valid()
      # 
      # TGroup's valid() calls the valid() member functions of each of its
      # subviews.
      # @see TView::valid()
      # 
      # The net result is that valid() returns True only if the group controls
      # all return True; otherwise, it returns False. A modal state cannot
      # terminate until all subviews return True when polled with valid().
      # 
      def valid( command )
      end
  end

  # ---------------------------------------------------------------------- 
  #      class TInputLine                                                  
  #                                                                        
  #      Palette layout                                                    
  #        1 = Passive                                                     
  #        2 = Active                                                      
  #        3 = Selected                                                    
  #        4 = Arrows                                                      
  # ---------------------------------------------------------------------- 

  #
  # A TInputLine object provides a basic input line string editor. It handles
  # keyboard input and mouse clicks and drags for block marking and a variety
  # of line editing functions.
  # @short Provides a basic input line string editor
  # 
  class TInputLine < TView
  public
      #
      # Creates an input box control with the given values by calling
      # TView::TView(bounds).
      # @see TView::TView
      # 
      # Variable @ref state is then set to @ref sfCursorVis, @ref options is
      # set to (@ref ofSelectable | @ref ofFirstClick), and @ref maxLen is set
      # to `aMaxLen'.
      # 
      # Memory is allocated and cleared for `aMaxlen' + 1 bytes and the
      # @ref data data member set to point at this allocation.
      # 
      # An input line is sometimes used with a validator. Data validators are
      # objects that detect when the user has entered valid or invalid
      # information. In case of invalid data, the validator will provide
      # appropriate feedback to the user.
      # @see TValidator
      # 
      def initialize( bounds, aMaxLen, aValid )
      end

      #
      # Returns the size of the record for @ref getData() and @ref setData()
      # calls.
      # By default, it returns @ref maxLen + 1.
      # 
      # Override this member function if you define descendants to handle other
      # data types.
      # 
      def dataSize
      end

      #
      # Draws the input box and its data.
      # 
      # The box is drawn with the appropriate colors depending on whether the
      # box is @ref sfFocused (that is, whether the box view owns the cursor),
      # and arrows are drawn if the input string exceeds the size of the view
      # (in either or both directions).
      # @see TView::state
      # 
      # Any selected (block-marked) characters are drawn with the appropriate
      # palette.
      # 
      def draw
      end

      #
      # Writes the number of bytes (obtained from a call to @ref dataSize())
      # from the data string to the array given by `rec'. Used with
      # @ref setData() for a variety of applications; for example, temporary
      # storage, or passing on the input string to other views.
      # 
      # Override getData() if you define TInputLine descendants to
      # handle non-string data types. You can also use getData() to
      # convert from a string to other data types after editing by TInputLine.
      # 
      def getData( rec )
      end

      #
      # Returns the default palette string.
      # 
      def getPalette
      end

      #
      # Calls @ref TView::handleEvent(), then handles all mouse and keyboard
      # events if the input box is selected.
      # 
      # This member function implements the standard editing capability of the
      # input box. Editing features include:
      # 
      # -# block marking with mouse click and drag
      # -# block deletion
      # -# insert or overwrite control with automatic cursor shape change
      # -# automatic and manual scrolling as required (depending on relative
      #    sizes of the @ref data string and size.x); see @ref size
      # -# manual horizontal scrolling via mouse clicks on the arrow icons
      # -# manual cursor movement by arrow, Home, and End keys (and their
      #    standard control-key equivalents)
      # -# character and block deletion with Del and Ctrl-G
      # 
      # The view is redrawn as required and the TInputLine data members are
      # adjusted appropriately.
      # 
      def handleEvent( event )
      end

      #
      # Sets @ref curPos, @ref firstPos and @ref selStart data members to 0.
      # 
      # If `enable' is set to True, @ref selEnd is set to the length of the
      # @ref data string, thereby selecting the whole input line; if `enable'
      # is set to False, @ref selEnd is set to 0, thereby deselecting the
      # whole line.
      # 
      # Finally, the view is redrawn by calling @ref TView::drawView().
      # 
      def selectAll( enable )
      end

      #
      # By default, copies the number of bytes (as returned by
      # @ref dataSize()) from the `rec' array to the @ref data string, and
      # then calls selectAll(True). This zeros @ref curPos, @ref firstPos and
      # @ref selStart.
      # @see TInputLine::selectAll
      # 
      # Finally, @ref TView::drawView() is called to redraw the input box.
      # 
      # Override setData() if you define descendants to handle non-string
      # data types. You also use setData() to convert other data types to
      # a string for editing by TInputLine.
      # 
      def setData( rec )
      end

      # 
      # Called when the input box needs redrawing (for example, if the palette
      # is changed) following a change of state.
      # 
      # Calls @ref TView::setState() to set or clear the view's @ref state with
      # the given `aState' bit(s).
      # 
      # Then if `aState' is @ref sfSelected (or @ref sfActive and the input
      # box is @ref sfSelected), selectAll(enable) is called (which, in turn,
      # calls @ref TView::drawView()).
      # @see TInputLine::selectAll
      # 
      def setState( aState, enable )
      end

      #
      # Undocumented.
      # 
      def valid( ushort cmd )
      end

      #
      # Undocumented.
      # 
      def setValidator( aValid )
      end

      # 
      # The string containing the edited information.
      # 
      attr_accessor :data

      #
      # Maximum length allowed for string to grow (excluding the final 0).
      # 
      attr_accessor :maxLen

      #
      # Index to insertion point (that is, to the current cursor position).
      # 
      attr_accessor :curPos

      #
      # Index to the first displayed character.
      # 
      attr_accessor :firstPos

      #
      # Index to the beginning of the selection area (that is, to the first
      # character block marked).
      # 
      attr_accessor :selStart

      # 
      # Index to the end of the selection area (that is, to the last character
      # block marked).
      # 
      attr_accessor :selEnd
  end

  # ---------------------------------------------------------------------- 
  #      TButton object                                                    
  #                                                                        
  #      Palette layout                                                    
  #        1 = Normal text                                                 
  #        2 = Default text                                                
  #        3 = Selected text                                               
  #        4 = Disabled text                                               
  #        5 = Normal shortcut                                             
  #        6 = Default shortcut                                            
  #        7 = Selected shortcut                                           
  #        8 = Shadow                                                      
  # ---------------------------------------------------------------------- 

  #
  # One of the most used and easy to use views. A TButton object is a box with
  # a title and a shadow that generates a command when pressed. A button can
  # be selected by:
  # 
  # -# typing the highlighted letter
  # -# tabbing to the button and pressing Spacebar
  # -# pressing Enter when the button is the default
  # -# clicking on the button with a mouse
  # 
  # With color and black-and-white palettes, a button has a three-dimensional
  # look that moves when selected. On monochrome systems, a button is bordered
  # by brackets, and other ASCII characters are used to indicate whether the
  # button is default, selected, and so on.
  # 
  # There can only be one default button in a window or dialog at any given
  # time. Buttons that are peers in a group grab and release the default state
  # via @ref evBroadcast messages.
  # @short The button view
  # 
  class TButton < TView
  public
      # 
      # Constructor.
      # 
      # Creates a TButton class with the given size by calling the TView
      # constructor.
      # 
      # -# `bounds' is the bounding rectangle of the button
      # -# `aTitle' is a pointer to a string which will be the title of the
      #    button
      # -# `aCommand' is the command generated when the user presses the button.
      #    If the given `aCommand' is not enabled, @ref sfDisabled is set in the
      #    @ref state data member.
      # -# `aFlags' is a combination of the following values:
      # 
      # <pre>
      # Constant    Value Meaning
      # 
      # @ref bfNormal    0x00  Button is a normal, non-default button
      # 
      # @ref bfDefault   0x01  Button is the default button: if this bit is set this
      #                   button will be highlighted as the default button
      # 
      # @ref bfLeftJust  0x02  Button label is left-justified; if this bit is clear
      #                   the title will be centered
      # 
      # @ref bfBroadcast 0x04  Sends a broadcast message when pressed
      # 
      # @ref bfGrabFocus 0x08  The button grabs the focus when pressed
      # </pre>
      # 
      # It is the responsibility of the programmer to ensure that there is only
      # one default button in a TGroup. However the default property can be
      # passed to normal buttons by calling @ref makeDefault().
      # @see TButton::amDefault
      # 
      # The @ref bfLeftJust value can be added to @ref bfNormal or
      # @ref bfDefault and affects the position of the text displayed within
      # the button: if clear, the label is centered; if set, the label is
      # left-justified.
      # 
      # The @ref options data member is set to (@ref ofSelectable |
      # @ref ofFirstClick | @ref ofPreProcess | @ref ofPostProcess) so that
      # by default TButton responds to these events.
      # 
      # @ref eventMask is set to @ref evBroadcast.
      # 
      def initialize( bounds, aTitle, aCommand, aFlags)
      end

      # 
      # Draws the button by calling TButton::drawState(False).
      # @see TButton::drawState
      # 
      def draw
      end

      #
      # Called by @ref draw().
      # 
      # Draws the button in the "down" state (no shadow) if down is True;
      # otherwise, it draws the button in the "up" state if down is False.
      # 
      # The appropriate palettes are used to reflect the current state (normal,
      # default, disabled). The button label is positioned according to the
      # @ref bfLeftJust bit in the @ref flags data member.
      # 
      def drawState( down )
      end

      #
      # Returns a reference to the standard TButton palette string.
      # 
      def getPalette
      end

      # 
      # Handles TButton events.
      # 
      # Responds to being pressed in any of three ways: mouse clicks on the
      # button, its hot key being pressed, or being the default button when a
      # cmDefault broadcast arrives.
      # 
      # When the button is pressed, a command event is generated with
      # @ref putEvent(), with the @ref command data member assigned to
      # command and infoPtr set to this.
      # 
      # Buttons also recognize the broadcast commands cmGrabDefault and
      # cmReleaseDefault, to become or "unbecome" the default button, as
      # appropriate, and cmCommandSetChanged, which causes them to check
      # whether their commands have been enabled or disabled.
      # 
      def handleEvent( event )
      end

      #
      # Changes the default property of this button. Used to make this button
      # the default with `enable' set to True, or to release the default with
      # `enable' set to False. Three notes:
      # 
      # -# If `enable' is True, the button grabs the default property from
      #    the default button (if exists) with a cmGrabDefault broadcast
      #    command, so the default button losts the default property.
      # -# If `enable' is False, the button releases the default property to
      #    the default button (if exists) with a cmReleaseDefault broadcast
      #    command, so the default button gains the default property.
      #    These changes are usually the result of tabbing within a dialog box.
      #    The status is changed without actually operating the button. The
      #    default button can be subsequently "pressed" by using the Enter key.
      #    This mechanism allows a normal button (without the @ref bfDefault
      #    bit set) to behave like a default button. The button is redrawn if
      #    necessary to show the new status.
      # -# This method does nothing if the button is a default button (i.e. it
      #    has the @ref bfDefault bit set).
      # 
      # @see TButton::flags
      # 
      def makeDefault( enable )
      end

      #
      # This method is called whenever the button is pressed.
      # 
      # Its task is to send a message. The message is a broadcast message to
      # the owner of the view if the button has the @ref bfBroadcast bit set,
      # otherwise the message is a command message.
      # @see TButton::flags
      # 
      # Used internally by @ref handleEvent() when a mouse click "press" is
      # detected or when the default button is "pressed" with the Enter key.
      # 
      def press
      end

      #
      # Changes the state of the button.
      # 
      # Calls @ref setState(), then calls @ref drawView() to redraw the button
      # if it has been made @ref sfSelected or @ref sfActive.
      # @see TView::state
      # 
      # If focus is received (that is, if `aState' is @ref sfFocused), the
      # button grabs or releases default from the default button by calling
      # @ref makeDefault().
      # 
      def setState( aState, enable )
      end

      #
      # This is a pointer to the label text of the button.
      # 
      attr_accessor :title

      # 
      # A pointer to the shadow characters.
      # 
      # These characters are used to draw the button shadow.
      # 
      attr_accessor :shadows

      #
      # This is the command word of the event generated when this button is
      # pressed.
      # 
      attr_accessor :command
      protected :command

      # 
      # This variabile is a bitmapped data member used to indicate whether
      # button text is left-justified or centered.
      # 
      # The individual flags are the various bfXXXX constants.
      # @see TButton::TButton
      # 
      attr_accessor :flags
      protected :flags

      #
      # If True the button has the default property.
      # 
      # The default button is automatically selected when the user presses the
      # Enter key. If this variable is False, the button is a normal button.
      # 
      attr_accessor :amDefault
      protected :amDefault

  private:
      def drawTitle( int, int, ushort, Boolean )
      end

      def pressButton( event )
      end

      def getActiveRect
      end
  end

  #
  # TSItem is a simple, non-view class providing a singly-linked list of
  # character strings.
  # This class is useful where the full flexibility of string collections are
  # not needed.
  # @short Non-view class providing a singly-linked list of character strings
  # 
  class TSItem
  public
      #
      # Creates a TSItem object with the given values.
      # 
      def initialize( aValue, aNext )
          @value = newStr(aValue)
          @next = aNext
      end

      #
      # The string for this TSItem object.
      # 
      attr_accessor :value

      #
      # Pointer to the next TSItem object in the linked list.
      # 
      attr_accessor :next
  end

  # ---------------------------------------------------------------------- 
  #      class TCluster                                                    
  #                                                                        
  #      Palette layout                                                    
  #        1 = Normal text                                                 
  #        2 = Selected text                                               
  #        3 = Normal shortcut                                             
  #        4 = Selected shortcut                                           
  #        5 = Disabled text                                               
  # ---------------------------------------------------------------------- 

  #
  # The base class used both by @ref TCheckBoxes and @ref TRadioButtons.
  # 
  # A cluster is a group of controls that all respond in the same way.
  # TCluster is an abstract class from which the useful group controls such as
  # @ref TRadioButtons, @ref TCheckBoxes, and @ref TMonoSelector are derived.
  # 
  # Cluster controls are often associated with @ref TLabel objects, letting you
  # select the control by selecting on the adjacent explanatory label.
  # Clusters are used to toggle bit values in the @ref value data member, which
  # is of type unsigned long.
  # 
  # The two standard descendants of TCluster use different algorithms when
  # changing value: @ref TCheckBoxes simply toggles a bit, while
  # @ref TRadioButtons toggles the enabled one and clears the previously
  # selected bit.
  # Both inherit most of their behavior from TCluster.
  # @short The base class of TCheckBoxes and TRadioButtons
  # 
  class TCluster < TView
  public
      #
      # Constructor.
      # 
      # Calls TView::TView(bounds) to create a TCluster object with the given
      # `bounds', where `bounds' is the desired bounding rectangle of the view.
      # The @ref strings data member is set to `aStrings', a pointer to a
      # linked list of @ref TSItem objects, one for each cluster item.
      # Every @ref TSItem object stores the caption of the related item.
      # @see TView::TView
      # 
      # TCluster handles a maximum of 32 items.
      # The constructor clears the @ref value and @ref sel data members.
      # 
      def initialize( bounds, aStrings )
      end

      #
      # Returns the size of the data record of this view (composed by the
      # @ref value data member).
      # Must be overridden in derived classes that change value or add other
      # data members, in order to work with @ref getData() and @ref setData().
      # 
      # It returns `sizeof(short)' for compatibility with earlier TV, even if
      # @ref value data member is now an unsigned long; @ref TMultiCheckBoxes
      # returns sizeof(long).
      # 
      def dataSize
      end

      #
      # Redraws the view.
      # 
      # Called within the @ref draw() method of derived classes to draw the
      # box in front of the string for each item in the cluster.
      # @see TCheckBoxes::draw
      # @see TRadioButtons::draw
      # @see TView::draw
      # 
      # Parameter `icon' is a five-character string that points to a string
      # which will be written at the left side of every item (" [ ] " for check
      # boxes, " () " for radio buttons).
      # 
      # Parameter `marker' is the character to use to indicate the box has been
      # marked ("X" for check boxes, "." for radio buttons).
      # A space character will be used if the box is unmarked.
      # @see TCluster::drawMultiBox
      # 
      def drawBox( icon, marker )
      end

      #
      # Redraws the view.
      # 
      # Called within the @ref draw() method of derived classes.
      # @see TCheckBoxes::draw
      # @see TRadioButtons::draw
      # @see TView::draw
      # 
      # Parameter `icon' points to a string which will be written at the left
      # side of every item. For example @ref TCheckBoxes::draw() calls this
      # method with string " [ ] " as `icon' parameter.
      # @ref TRadioButton::draw() calls this method with string " ( ) " as
      # parameter `icon'.
      # 
      # Parameter `marker' is a pointer to an array of 2 characters. If the
      # item is not checked the first character will be written. Otherwise the
      # second character will be used.
      # @see TCluster::drawBox
      # 
      def drawMultiBox(icon, marker)
      end

      #
      # Reads the data record of this view.
      # 
      # Writes the @ref value data member to the given `rec' address and calls
      # @ref drawView().
      # 
      # Must be overridden in derived classes that change the value data member
      # in order to work with @ref dataSize() and @ref setData().
      # 
      def getData( rec )
      end

      #
      # Returns the help context of the selected item.
      # 
      # The help context is calculated by summing view variable @ref helpCtx
      # and the number of the currently selected item (0 for the first item,
      # 1 for the second item, etc). Redefines @ref TView::getHelpCtx().
      # 
      # Enables you to have separate help contexts for each item in the
      # cluster. Use it to reserve a range of help contexts equal to
      # @ref helpCtx plus the number of cluster items minus one.
      # 
      def getHelpCtx
      end

      #
      # Returns a reference to the standard TCluster palette.
      # 
      def getPalette
      end

      #
      # Calls @ref TView::handleEvent(), then handles all mouse and keyboard
      # events appropriate to this cluster.
      # 
      # Controls are selected by mouse click or cursor movement keys (including
      # Spacebar).
      # The cluster is redrawn to show the selected controls.
      # 
      def handleEvent( event )
      end

      #
      # Called by the @ref draw() method redefined both in @ref TCheckBoxes and
      # @ref TRadioButtons classes to determine which items are marked. mark()
      # should be overridden to return True if the item'th control in the
      # cluster is marked; otherwise, it should return False.
      # @see TCheckBoxes::draw
      # @see TRadioButton::draw
      # 
      # The default mark() returns False. Redefined in @ref TCheckBoxes and
      # in @ref TRadioButtons.
      # @see TCheckBoxes::mark
      # @see TRadioButtons::mark
      # 
      def mark( item )
      end

      #
      # It just returns `(uchar)(mark(item) == True)'.
      # 
      def multiMark( item )
      end

      #
      # Called by @ref handleEvent() when the item'th control in the cluster is
      # pressed either by mouse click or keyboard event.
      # 
      # This member function does nothing and must be overridden. Redefined in
      # @ref TCheckBoxes and in @ref TRadioButtons.
      # @see TCheckBoxes::press
      # @see TRadioButtons::press
      # 
      def press( item )
      end

      # 
      # Called by @ref handleEvent() to move the selection bar to the item'th
      # control of the cluster.
      # 
      # This member function does nothing and must be overridden. Redefined in
      # @ref TRadioButtons.
      # @see TRadioButtons::movedTo
      # 
      def movedTo( item )
      end

      # 
      # Writes the data record of this view.
      # Reads the @ref value data member from the given `rec' address and calls
      # @ref drawView().
      # 
      # Must be overridden in derived cluster types that require other data
      # members to work with @ref dataSize() and @ref getData().
      # 
      def setData( rec )
      end

      # 
      # Changes the state of the view.
      # Calls TView::setState(aState), then calls @ref drawView() if `aState'
      # is @ref sfSelected.
      # @see TView::setState
      # @see TView::state
      # 
      def setState( aState, enable )
      end

      #
      # Sets the state of one or more items.
      # 
      # `aMask` is a bitmap which specifies what items to enable or disable.
      # `enable' is the action to perform: False to disable, True to enable.
      # 
      def setButtonState(aMask, enable)
      end

      # 
      # This variable stores the item status bitmap (current value of the
      # control). Its initial value is 0.
      # 
      # The actual meaning of this data member is determined by the member
      # functions developed in the classes derived from TCluster.
      # 
      # For example, @ref TCheckBoxes interprets each of the 32 bits of value
      # as the state (on or off) of 32 distinct check boxes.
      # If bit 0 is set the first box is checked, if bit 1 is set the second
      # box is checked, etc. If a bit is cleared the related box is
      # unchecked.
      # 
      # In @ref TRadioButtons, value can represent the state of a cluster of
      # up to 2^32 buttons, since only one radio button can be "on" at any one
      # time.
      # 
      # Note: unsigned long is currently a 32-bit unsigned integer giving a
      # range of 0 to 2^32-1.
      # 
      attr_accessor :value
      protected :value

      #
      # This variable stores a bitmap which selectively enables cluster items.
      # 
      # If bit 0 is set the first item is enabled, if bit 1 is set the second
      # item is enabled, etc. If a bit is cleared the related item is
      # disabled. Its initial value is 0xffffffff.
      # 
      attr_accessor :enableMask
      protected :enableMask
      
      #
      # This integer contains the current selected item.
      # 
      # If its value is 0 the first item is selected, if its value is 1 the
      # second item is selected, etc. Its initial value is 0.
      # 
      attr_accessor :sel
      protected :sel

      #
      # This object contains all the item captions.
      # 
      attr_accessor :strings
      protected :strings

  private
      def column( item )
      end

      def findSel( p )
      end

      def row( item )
      end

      def moveSel(int, int)
      end

  public
      # 
      # Returns True if the specified item is enabled.
      # 
      # Parameter `item' specifies which item to check. 0 is the first item,
      # 1 is the second item, etc.
      # @see TCluster::enableMask
      # 
      def buttonState(int item)
      end
  end

  # ---------------------------------------------------------------------- 
  #      class TRadioButtons                                               
  #                                                                        
  #      Palette layout                                                    
  #        1 = Normal text                                                 
  #        2 = Selected text                                               
  #        3 = Normal shortcut                                             
  #        4 = Selected shortcut                                           
  # ---------------------------------------------------------------------- 

  #
  # This view implements a cluster of radio buttons.
  # 
  # TRadioButtons objects are clusters controls with the special property that
  # only one control button in the cluster can be selected at any moment.
  # Selecting an unselected button will automatically deselect (restore) the
  # previously selected button.
  # 
  # The user can select a button with mouse clicks, cursor movements, and
  # Alt-letter shortcuts. Each radio button can be highlighted and selected
  # (with the Spacebar). An "." appears in the radio button when it is
  # selected.
  # 
  # Other parts of your application typically examine the state of the radio
  # buttons to determine which option has been chosen by the user.
  # 
  # Radio button clusters often have associated @ref TLabel objects to give
  # the user an overview of the clustered options.
  # 
  # TRadioButtons interprets @ref value as the number of the "pressed" button,
  # with the first button in the cluster being number 0.
  # @see TCheckBoxes
  # @short Cluster of radio buttons
  # 
  class TRadioButtons < TCluster
  public
      #
      # Constructor.
      # 
      # `bounds' is the bounding rectangle of the view. `aStrings' points to
      # a linked list of @ref TSItem objects, one for each radio button, and is
      # assigned to @ref strings data member.
      # 
      # Every @ref TSItem object stores the caption of the related radio button.
      # TRadioButtons handles a maximum of 2^32 radio buttons.
      # 
      # The @ref sel and @ref value data members are set to zero; @ref options
      # is set to (@ref ofSelectable | @ref ofFirstClick | @ref ofPreProcess |
      # @ref ofPostProcess).
      # 
      def initialize( bounds, aStrings )
      end

      # 
      # Draws the TRadioButtons object by calling the inherited
      # @ref TCluster::drawBox() member function.
      # 
      # The default radio button is " ( ) " when unselected and " (.) " when
      # selected. Note that if the boundaries of the view are sufficiently
      # wide, radio buttons can be displayed in multiple columns.
      # 
      def draw
      end

      #
      # Returns True if the specified radio button is pressed; that is, if
      # `item' is equal to @ref value data member.
      # 
      # Integer `item' specifies which radio button to check. 0 is the first
      # radio button, 1 is the second radio button, etc.
      # 
      def mark( item )
      end

      #
      # Called whenever the user moves the selection to another radio button.
      # 
      # Sets @ref value data member to `item'. This will press `item' radio
      # button and release the previously pressed radio button.
      # @see TCluster::movedTo
      # @see TCluster::value
      # 
      def movedTo( item )
      end

      #
      # Called to press another radio button.
      # 
      # Integer `item' specifies which radio button to press. The previous
      # radio button is released. 0 is the first radio button, 1 the second
      # radio button, etc.
      # @see TCluster::press
      # 
      def press( item )
      end

      #
      # Writes the data record of this view.
      # 
      # This method calls @ref TCluster::setData() and after sets @ref sel data
      # member to @ref value data member. This will move the selection on the
      # currently pressed radio button.
      # 
      def setData( rec )
      end
  end

  # ---------------------------------------------------------------------- 
  #      TCheckBoxes                                                       
  #                                                                        
  #      Palette layout                                                    
  #        1 = Normal text                                                 
  #        2 = Selected text                                               
  #        3 = Normal shortcut                                             
  #        4 = Selected shortcut                                           
  # ---------------------------------------------------------------------- 

  #
  # This view implements a cluster of check boxes.
  # 
  # TCheckBoxes is a specialized cluster of one to 32 controls. Unlike radio
  # buttons, any number of check boxes can be marked independently, so the
  # cluster may have one or more boxes checked by default.
  # 
  # The user can mark check boxes with mouse clicks, cursor movements, and
  # Alt-letter shortcuts. Each check box can be highlighted and toggled on/off
  # (with the Spacebar). An "X" appears in the box when it is selected.
  # 
  # Other parts of your application typically examine the state of the check
  # boxes to determine which options have been chosen by the user.
  # 
  # Check box clusters often have associated @ref TLabel objects to give the
  # user an overview of the clustered options.
  # @see TRadioButtons
  # @short Cluster of check boxes
  # 
  class TCheckBoxes < TCluster
  public
      #
      # Constructor.
      # 
      # `bounds' is the bounding rectangle of the view. `aStrings' points to
      # a linked list of @ref TSItem objects, one for each check box, and is
      # assigned to @ref strings data member.
      # 
      # Every @ref TSItem object stores the caption of the related check box.
      # TCheckBoxes handles a maximum of 32 check boxes.
      # 
      # The @ref sel and @ref value data members are set to zero; @ref options
      # is set to (@ref ofSelectable | @ref ofFirstClick | @ref ofPreProcess |
      # @ref ofPostProcess).
      # 
      def initialize( bounds, aStrings)
      end

      #
      # Draws the TCheckBoxes object by calling the inherited
      # @ref TCluster::drawBox() member function.
      # 
      # The default check box is " [ ] " when unselected and " [X] " when
      # selected. Note that if the boundaries of the view are sufficiently
      # wide, check boxes can be displayed in multiple columns.
      # 
      def draw
      end

      #
      # Returns True if the item'th bit of the @ref value data member is set;
      # that is, if the item'th check box is marked.
      # 
      # These bits have no instrinsic meaning. You are free to override mark(),
      # @ref press(), and other check box member functions to give the
      # @ref value data member your own interpretation.
      # 
      # By default, the items are numbered 0 through 31 and each bit of
      # @ref value data member represents the state (on or off) of a check box.
      # 
      def mark( item )
      end

      #
      # Called to toggle the state of a check box: toggles the item'th bit of
      # @ref value data member.
      # 
      # These bits have no instrinsic meaning. You are free to override
      # @ref mark(), press(), and other check box member functions to give
      # the @ref value data member your own interpretation.
      # 
      def press( item )
      end
  end

  CfOneBit       = 0x0101
  CfTwoBits      = 0x0203
  CfFourBits     = 0x040F
  CfEightBits    = 0x08FF

  # ---------------------------------------------------------------------- 
  #      TMultiCheckBoxes                                                  
  #                                                                        
  #      Palette layout                                                    
  #        1 = Normal text                                                 
  #        2 = Selected text                                               
  #        3 = Normal shortcut                                             
  #        4 = Selected shortcut                                           
  # ---------------------------------------------------------------------- 

  # 
  # A cluster of multistate check boxes.
  # @short Implements a cluster of multistate check boxes
  # 
  class TMultiCheckBoxes < TCluster
  public
      # 
      # Constructs a cluster of multistate check boxes by first calling the
      # constructor inherited from @ref TCluster, then setting the private data
      # members selRange and flags to the values passed in `aSelRange' and
      # `aFlags', respectively, and allocating a dynamic copy of `aStates' and
      # assigning it to private data member states.
      # 
      def initialize(bounds, aStrings, aSelRange, aFlags, aStates)
      end

      # 
      # Returns the size of the data transferred by @ref getData() and
      # @ref setData(), which is sizeof(long int).
      # 
      def dataSize
      end

      #
      # Draws the cluster of multistate check boxes by drawing each check box
      # in turn, using the same box as a regular check box, but using the
      # characters in states data member to represent the state of each box
      # instead of the standard blank and "X".
      # 
      def draw
      end

      #
      # Typecasts `rec' into a long int and copies value into it, then calls
      # @ref drawView() to redraw the cluster to reflect the current state of
      # the check boxes.
      # @see TMultiCheckBoxes::dataSize
      # @see TMultiCheckBoxes::setData
      # 
      def getData(rec)
      end

      # 
      # Returns the state of the item'th check box in the cluster.
      # 
      def multiMark(item)
      end

      #
      # Changes the state of the item'th check box in the cluster. Unlike
      # regular check boxes that simply toggle on and off, multistate check
      # boxes cycle through all the states available to them.
      # 
      def press( item )
      end

      # 
      # Typecasts `rec' into a long int, and copies its value into value, then
      # calls @ref drawView() to redraw the checkboxes to reflect their new
      # states.
      # @see TMultiCheckBoxes::dataSize
      # @see TMultiCheckBoxes::getData
      # 
      def setData(void*)
      end

      # 
      # The flags data member is a bitmapped field that holds a combination of
      # the cfXXXX constants, defined in `dialogs.h'.
      # 
      # <pre>
      # Constant    Value  Meaning
      # 
      # cfOneBit    0x0101 1 bit per checkbox
      # cfTwoBits   0x0203 2 bits per check box
      # cfFourBits  0x040f 4 bits per check box
      # cfEightBits 0x08ff 8 bits per check box
      # </pre>
      # 
      # Multistate check boxes use the cfXXXX constants to specify how many
      # bits in the value field represent the state of each check box.
      # 
      # The high-order word of the constant indicates the number of bits used
      # for each check box, and the low-order word holds a bit mask used to
      # read those bits.
      # 
      # For example, cfTwoBits indicates that value uses two bits for each
      # check box (making a maximum of 16 check boxes in the cluster), and
      # masks each check box's values with the mask 0x03.
      # 
  end

  #
  # Data record used by TListBox.
  # @see TListBox
  # @see TListBox::dataSize
  # @see TListBox::getData
  # @see TListBox::setData
  # 
  class TListBoxRec
    public
      # 
      # Undocumented.
      # 
      attr_accessor :items
      #
      # Undocumented.
      # 
      attr_accessor :selection
  end

  #
  # TListBox is derived from @ref TListViewer to help you set up the most
  # commonly used list boxes, namely those displaying collections of strings,
  # such as file names.
  # 
  # TListBox objects represent displayed lists of such items in one or more
  # columns with an optional vertical scroll bar.
  # @short Displays a list of items, in one or more columns, with an optional
  # vertical scroll bar
  # 
  class TListBox < TListViewer
  public
      # 
      # Creates a list box control with the given size, number of columns, and
      # a vertical scroll bar referenced by the `aScrollBar' pointer.
      # 
      # This constructor calls TListViewer::TListViewer(bounds, aNumCols, 0,
      # aScrollBar), thereby supressing the horizontal scroll bar.
      # @see TListViewer::TListViewer
      # 
      # The @ref items data member is initially empty collection, and the
      # inherited @ref range data member is set to zero.
      # 
      # Your application must provide a suitable @ref TCollection holding the
      # strings (or other objects) to be listed. The @ref items data member
      # must be set to point to this collection using @ref newList().
      # 
      def initialize( bounds, aNumCols, aScrollBar )
      end

      #
      # Returns the size of the data read and written to the records passed to
      # @ref getData() and @ref setData(). These three member functions are
      # useful for initializing groups.
      # 
      # By default, dataSize() returns the size of @ref TCollection plus the
      # size of ushort (for items and the selected item). You may need to
      # override this member function for your own applications.
      # @see TListBox::items
      # @see TListBoxRec
      # 
      def dataSize
      end

      #
      # Writes TListBox object data to the target record. By default, getData()
      # writes the current @ref items and @ref focused data members to `rec'.
      # You may need to override this member function for your own applications.
      # @see TListBox::dataSize
      # @see TListBox::setData
      # 
      def getData( rec )
      end

      #
      # Sets a string in `dest' from the calling TListBox object. By default,
      # the returned string is obtained from the item'th item in the
      # @ref TCollection using (char *) ((list())->at(item)).
      # @see TCollection::at
      # @see TListBox::list
      # 
      # If @ref list() returns a collection containing non-string objects, you
      # will need to override this member function. If @ref list() returns 0,
      # getText() sets `dest' to " ".
      # 
      def getText( dest, item, maxLen )
      end

      #
      # Creates a new list by deleting the current one and replacing it with
      # the given `aList'.
      # 
      def newList( aList )
      end

      #
      # Replaces the current list with @ref items and @ref focused values read
      # from the given `rec' array. setData() calls @ref newList() so that the
      # new list is displayed with the correct focused item. As with
      # @ref getData() and @ref dataSize(), you may need to override this
      # member function for your own applications.
      # 
      def setData( rec )
      end

      #
      # Returns the private items pointer.
      # 
      def list
        @items
      end

      #
      # Points at the collection of items to scroll through.
      # 
      # Typically, this might be a collection of strings representing the item
      # texts. User can access this private member only by calling the function
      # @ref list().
      # 
      attr_accessor :items
      protected :items
  end

  # ---------------------------------------------------------------------- 
  #      class TStaticText                                                 
  #                                                                        
  #      Palette layout                                                    
  #        1 = Text                                                        
  # ---------------------------------------------------------------------- 

  #
  # Used to show fixed text in a window.
  # 
  # TStaticText objects represent the simplest possible views: they contain
  # fixed text and they ignore all events passed to them. They are generally
  # used as messages or passive labels.
  # 
  # Descendants of TStaticText, such as @ref TLabel or @ref TParamText
  # objects, usually perform more active roles. Use @ref TParamText if you
  # want to show dynamic text also, where dynamic means user-selectable at
  # run-time.
  # @short Used to show fixed text in a window
  # 
  class TStaticText < TView
  public
      #
      # Constructor.
      # 
      # Creates a TStaticText object of the given size by calling
      # TView::TView(bounds), then sets @ref text data member to newStr(aText).
      # `bounds' is the bounding rectangle of the view. `aText' is a pointer
      # to the string to show.
      # @see TView::TView
      # @see newStr
      # 
      def initialize( bounds, aText )
      end

      # 
      # Draws the @ref text string inside the view, word wrapped if necessary.
      # A '\\n' in the text indicates the beginning of a new line. A line of
      # text is centered in the view if the string begins with 0x03 (Ctrl-C).
      # 
      def draw
      end

      #
      # Returns a reference to the default palette.
      # 
      def getPalette
      end

      #
      # Writes the string at address `s'.
      # 
      def getText( s )
      end

      #
      # A pointer to the (constant) text string to be displayed in the view.
      # 
      attr_accessor :text
      protected :text
  end

  # ---------------------------------------------------------------------- 
  #      class TParamText                                                  
  #                                                                        
  #      Palette layout                                                    
  #        1 = Text                                                        
  # ---------------------------------------------------------------------- 

  #
  # Used to show dynamic, parameterized text in a window.
  # 
  # TParamText is derived from @ref TStaticText. It handles parameterized text
  # strings for formatted output. Check @ref TStaticText if you want to show
  # only fixed text (non run-time selectable).
  # @short Shows dynamic, parameterized text in a window
  # 
  class TParamText < TStaticText
  public
      #
      # Constructor.
      # 
      # `bounds' is the bounding rectangle of the view. Creates and initializes
      # a static text object by calling TStaticText::TStaticText(bounds, 0).
      # The string is initially empty. Use @ref setText() to assign the text.
      # @see TStaticText::TStaticText
      # 
      def initialize( bounds )
      end

      #
      # Writes a formatted text string at address `s'. If the text string is
      # empty, *s is set to @ref EOS.
      # 
      def getText( s )
      end

      # 
      # Sets a new value for the string.
      # 
      # Since this method calls vsprintf(), you can use a printf-like style for
      # its arguments.
      # 
      def setText( fmt)
      end

      #
      # Returns the length of the string, expressed in characters.
      # 
      def getTextLen
      end

      #
      # Stores the pointer to the string.
      # 
      attr_accessor :str
      protected :str
  end

  # ---------------------------------------------------------------------- 
  #      class TLabel                                                      
  #                                                                        
  #      Palette layout                                                    
  #        1 = Normal text                                                 
  #        2 = Selected text                                               
  #        3 = Normal shortcut                                             
  #        4 = Selected shortcut                                           
  # ---------------------------------------------------------------------- 

  # 
  # Used to attach a label to a given view.
  # 
  # A TLabel object is a piece of text in a view that can be selected
  # (highlighted) by a mouse click, cursor keys, or Alt-letter hot key.
  # The label is usually "attached" via a pointer (called @ref link) to some
  # other control view such as an input line, cluster, or list viewer to guide
  # the user.
  # @see TCluster
  # @see TInputLine
  # @see TListViewer
  # 
  # Useful mainly with input lines, list boxes, check boxes and radio buttons,
  # since they don't have a default caption.
  # @see TCheckBoxes
  # @see TListBox
  # @see TRadioButtons
  # @short Used to attach a label to a view
  # 
  class TLabel < TStaticText
  public
      # 
      # Constructor.
      # 
      # Creates a TLabel object of the given size and text by calling
      # TStaticText::TStaticText(bounds, aText), then setting the @ref link
      # data member to `aLink' for the associated control (make `aLink' 0 if
      # no control is needed).
      # @see TStaticText::TStaticText
      # 
      # `bounds' is the bounding rectangle of the view while `aText' is the
      # caption to show.
      # @see text
      # 
      # The @ref options data member is set to @ref ofPreProcess and
      # @ref ofPostProcess. The @ref eventMask is set to @ref evBroadcast.
      # `aText' can designate a hot key letter for the label by surrounding
      # the letter with tildes, like "~F~ile".
      # 
      def initialize( bounds, aText, aLink )
      end

      # 
      # Draws the label with the appropriate colors from the default palette.
      # 
      def draw
      end

      #
      # Returns a reference to the label palette.
      # 
      def getPalette
      end

      #
      # Handles TLabel events.
      # 
      # Handles all events by calling @ref TView::handleEvent(). If an
      # @ref evMouseDown or hot key event is received, the appropriate linked
      # control (if any) is selected with link->select().
      # @see select
      # 
      # handleEvent() also handles cmReceivedFocus and cmReleasedFocus
      # broadcast events from the linked control in order to adjust the
      # value of the @ref light data member and redraw the label as necessary.
      # 
      def handleEvent( event )
      end

      #
      # Releases TLabel resources.
      # 
      # Used internally by @ref TObject::destroy() to ensure correct
      # destruction of derived and related objects. shutDown() is overridden
      # in many classes to ensure the proper setting of related data members
      # when @ref destroy() is called.
      # 
      # This method releases all the resources allocated by the TLabel. It sets
      # pointer @ref link to 0 and then calls @ref TStaticText::shutDown().
      # Since @ref TStaticText::shutDown() is not implemented,
      # @ref TView::shutDown() will be called instead.
      # 
      def shutDown
      end

      #
      # This is a pointer to the view to focus when the user selects this
      # label.
      # 
      attr_accessor :link
      protected :link

      #
      # If True, the label and its linked control has been selected and will
      # be highlighted. Otherwise, light is set to False.
      # 
      attr_accessor :light
      protected :light

  private
      def focusLink(event)
      end
  end

  # ---------------------------------------------------------------------- 
  #      class THistoryViewer                                              
  #                                                                        
  #      Palette layout                                                    
  #        1 = Active                                                      
  #        2 = Inactive                                                    
  #        3 = Focused                                                     
  #        4 = Selected                                                    
  #        5 = Divider                                                     
  # ---------------------------------------------------------------------- 

  #
  # THistoryViewer is a rather straightforward descendant of @ref TListViewer.
  # It is used by the history list system, and appears inside the history
  # window set up by clicking on the history icon.
  # @short Part of the history list system
  # 
  class THistoryViewer < TListViewer
  public
      #
      # Initializes the viewer list by first calling the TListViewer constructor
      # to set up the boundaries, a single column, and the two scroll bar
      # pointers passed in `aHScrollBar' and `aVScrollBar'.
      # 
      # The view is then linked to a history list, with the @ref historyId data
      # member set to the value passed in `aHistory'. That list is then checked
      # for length, so the range of the list is set to the number of items in
      # the list.
      # 
      # The first item in the history list is given the focus, and the
      # horizontal scrolling range is set to accommodate the widest item in the
      # list.
      # 
      def initialize( bounds, aHScrollBar, aVScrollBar, aHistoryId)
      end

      #
      # Returns the default palette string.
      # 
      def getPalette
      end

      #
      # Set `dest' to the item'th string in the associated history list.
      # getText() is called by the @ref TListViewer::draw() member function for
      # each visible item in the list.
      # 
      def getText( dest, item, maxLen )
      end

      #
      # The history viewer handles two kinds of events itself; all others are
      # passed to @ref TListViewer::handleEvent().
      # 
      # -# Double clicking or pressing the Enter key terminates the modal state
      #    of the history window with a cmOK command.
      # -# Pressing the Esc key, or any cmCancel command event, cancels the
      #    history list selection.
      # 
      def handleEvent( event )
      end

      # 
      # Returns the length of the longest string in the history list associated
      # with @ref historyId.
      # 
      def historyWidth
      end

      #
      # historyId is the ID number of the history list to be displayed in the
      # view.
      # 
      attr_accessor :historyId
      protected :historyId
  end

  #
  # @ref THistoryWindow inherits multiply from @ref TWindow and the virtual
  # base class THistInit.
  # 
  # THistInit provides a constructor and
  # @ref THistoryWindow::createListViewer() member function used in creating
  # and inserting a list viewer into a history window. A similar technique is
  # used for @ref TProgram, @ref TWindow and @ref TDeskTop.
  # @short Virtual base class for THistoryWindow
  # 
  class THistInit
  public
      #
      # This constructor takes a function address argument `cListViewer',
      # usually &THistoryWindow::initViewer.
      # @see THistoryWindow::initViewer
      # 
      # This creates and inserts a list viewer into the given history window
      # with the given size `bounds' and history list `histID'.
      # 
      def initialize(cListViewer)
      end

      #
      # Called by the THistInit constructor to create a list viewer for the
      # window `w' with size `r' and history list given by `histId' and return
      # a pointer to it. A 0 pointer indicates lack of success in this
      # endeavor.
      # 
      attr_accessor :createListViewer
      protected :createListViewer
  end

  # ---------------------------------------------------------------------- 
  #      THistoryWindow                                                    
  #                                                                        
  #      Palette layout                                                    
  #        1 = Frame passive                                               
  #        2 = Frame active                                                
  #        3 = Frame icon                                                  
  #        4 = ScrollBar page area                                         
  #        5 = ScrollBar controls                                          
  #        6 = HistoryViewer normal text                                   
  #        7 = HistoryViewer selected text                                 
  # ---------------------------------------------------------------------- 

  #
  # THistoryWindow is a specialized descendant of @ref TWindow and
  # @ref THistInit (multiple inheritance) used for holding a history list
  # viewer when the user clicks on the history icon next to an input line.
  # 
  # By default, the window has no title and no number. The history window's
  # frame has only a close icon: the window can be closed, but not resized or
  # zoomed.
  # @short Holds a history list viewer
  # 
  class THistoryWindow < TWindow
    include THistInit
  public
      #
      # Calls the THistInit constructor with the argument
      # &THistoryWindow::initViewer. This creates the list viewer.
      # @see THistInit::THistInit
      # @see THistoryWindow::initViewer
      # 
      # Next, the @ref TWindow constructor is called to set up a window with the
      # given bounds, a null title string, and no window number
      # (@ref wnNoNumber).
      # @see TWindow::TWindow
      # 
      # Then the @ref TWindowInit constructor is called with the argument
      # &THistoryWindow::initFrame to create a frame for the history window.
      # @see THistoryWindow::initFrame
      # @see TWindowInit::TWindowInit
      # 
      # Finally, the @ref flags data member is set to @ref wfClose to provide a
      # close icon, and a history viewer object is created and inserted in the
      # history window to show the items in the history list given by
      # `historyId'.
      # 
      def initialize( bounds, historyId )
      end

      #
      # Returns the default palette string.
      # 
      def getPalette
      end

      #
      # Returns in `dest' the string value of the @ref THistoryViewer::focused
      # item in the associated history viewer.
      # 
      def getSelection( dest )
      end

      #
      # Instantiates and inserts a @ref THistoryViewer object inside the
      # boundaries of the history window for the list associated with the
      # ID `aHistoryId'.
      # 
      # Standard scroll bars are placed on the frame of the window to scroll
      # the list.
      # 
      def self.initViewer(bounds, w, aHistoryId)
      end

      #
      # Points to the list viewer to be contained in this history window.
      # 
      TListViewer *viewer;
      attr_accessor :viewer
      protected :viewer
  end

  #
  # A THistory object implements a pick list of previous entries, actions, or
  # choices from which the user can select a "rerun". THistory objects are
  # linked to a @ref TInputLine object and to a history list.
  # @see THistoryWindow
  # 
  # History list information is stored in a block of memory on the heap. When
  # the block fills up, the oldest history items are deleted as new ones are
  # added.
  # 
  # Different input lines can share the same history list by using the same ID
  # number.
  # @short Implements a pick list of previous entries, actions, or choices from
  # which the user can select a "rerun"
  # 
  class THistory < TView
  public
      #
      # Creates a THistory object of the given size by calling
      # TView::TView(bounds), then setting the @ref link and @ref historyId
      # data members with the given argument values `aLink' and `aHistoryId'.
      # @see TView::TView
      # 
      # The @ref options member is set to @ref ofPostProcess. The
      # @ref evBroadcast bit is set in @ref eventMask in addition to the
      # @ref evMouseDown, @ref evKeyDown, and @ref evCommand bits set by
      # TView(bounds).
      # 
      def initialize( bounds, aLink, aHistoryId )
      end

      #
      # Draws the THistory icon in the default palette.
      # 
      def draw
      end

      #
      # Returns a reference to the default palette.
      # 
      def getPalette
      end

      # 
      # Calls TView::handleEvent(event), then handles relevant mouse and key
      # events to select the linked input line and create a history window.
      # @see TView::handleEvent
      # 
      def handleEvent( event )
      end

      # 
      # Creates a THistoryWindow object and returns a pointer to it. The new
      # object has the given bounds and the same @ref historyId as the calling
      # THistory object.
      # @see THistoryWindow
      # 
      # The new object gets its @ref helpCtx from the calling object's linked
      # @ref TInputLine.
      # @see THistory::link
      # 
      def initHistoryWindow( bounds )
      end

      #
      # Undocumented.
      # 
      def recordHistory(s)
      end

      #
      # Used internally by @ref TObject::destroy() to ensure correct
      # destruction of derived and related objects.
      # 
      # shutDown() is overridden in many classes to ensure the proper setting
      # of related data members when @ref destroy() is called.
      # 
      def shutDown
      end

      #
      # Undocumented.
      # 
      @icon
      class << self; attr_accessor :icon; end

      #
      # A pointer to the linked TInputLine object.
      # 
      attr_accessor :link
      protected :link

      #
      # Each history list has a unique ID number, assigned by the programmer.
      # 
      # Different history objects in different windows may share a history list
      # by using the same history ID.
      # 
      attr_accessor :historyId
      protected :historyId
  end
end

