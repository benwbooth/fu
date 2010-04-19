module Util

  def self.fexpand( char * )
  end

  def self.hotKey( s )
  end

  # \fn ctrlToArrow( ushort keyCode )
  # Converts a WordStar-compatible control key code to the corresponding cursor
  # key code. If the low byte of `keyCode' matches one of the following key
  # values, the result is the corresponding constant. Otherwise, `keyCode' is
  # returned unchanged.
  # 
  # <pre>
  # Keystroke Lo(keyCode) Result
  # 
  # Ctrl-A    0x01        kbHome
  # Ctrl-C    0x03        kbPgDn
  # Ctrl-D    0x04        kbRight
  # Ctrl-E    0x05        kbUp
  # Ctrl-F    0x06        kbEnd
  # Ctrl-G    0x07        kbDel
  # Ctrl-H    0x08        kbBack
  # Ctrl-R    0x12        kbPgUp
  # Ctrl-S    0x13        kbLeft
  # Ctrl-V    0x16        kbIns
  # Ctrl-X    0x18        kbDown
  # </pre>
  # 
  def self.ctrlToArrow( keyCode )
  end

  # \fn getAltChar( ushort keyCode )
  # Returns the character ch for which Alt-ch produces the 2-byte scan code
  # given by the argument `keyCode'. This function gives the reverse mapping to
  # getAltCode().
  # @see getAltCode
  # 
  def self.getAltChar( keyCode )
  end

  # \fn getAltCode( char ch )
  # Returns the 2-byte scan code (key code) corresponding to Alt-ch. This
  # function gives the reverse mapping to getAltChar().
  # @see getAltChar
  # 
  def self.getAltCode( ch )
  end

  # \fn getCtrlChar( ushort keyCode )
  # Returns the character, ch, for which Ctrl+ch produces the 2-byte scan code
  # given by the argument `keyCode'. Gives the reverse mapping to
  # getCtrlCode().
  # @see getCtrlCode
  # 
  def self.getCtrlChar( keyCode )
  end

  # \fn getCtrlCode( uchar ch )
  # Returns the 2-byte scan code (keycode) corresponding to Ctrl+ch, where `ch'
  # is the argument. This function gives the reverse mapping to getCtrlChar().
  # @see getCtrlChar
  # 
  def self.getCtrlCode( ch )
  end

  # \fn historyCount( uchar id )
  # Returns the number of strings in the history list corresponding to ID
  # number `id'.
  # @see THistInit
  # @see THistory
  # @see THistoryViewer
  # @see THistoryWindow
  # @see historyAdd
  # @see historyStr
  # 
  def self.historyCount( id )
  end

  # \fn historyStr( uchar id, int index )
  # Returns the index'th string in the history list corresponding to ID number
  # `id'.
  # @see THistInit
  # @see THistory
  # @see THistoryViewer
  # @see THistoryWindow
  # @see historyAdd
  # @see historyCount
  # 
  def self.historyStr( id, index )
  end

  # \fn historyAdd( uchar id, const char *str )
  # Adds the string `str' to the history list indicated by `id'.
  # @see THistInit
  # @see THistory
  # @see THistoryViewer
  # @see THistoryWindow
  # @see historyCount
  # @see historyStr
  # 
  def self.historyAdd( id, str )
  end

  # \fn cstrlen( const char *s )
  # Returns the length of string `s', where `s' is a control string using tilde
  # characters (`~') to designate hot keys. The tildes are excluded from the
  # length of the string, as they will not appear on the screen. For example,
  # given the argument "~B~roccoli", cstrlen() returns 8.
  # 
  def self.cstrlen( s )
  end

  # \fn message( TView *receiver, ushort what, ushort command, void *infoPtr )
  # message() sets up a command event with the arguments `event', `command',
  # and `infoPtr', and then, if possible, invokes receiver->handleEvent() to
  # handle this event.
  # @see TView::handleEvent
  # 
  # message() returns 0 if receiver is 0, or if the event is not handled
  # successfully. If the event is handled successfully (that is, if
  # @ref TView::handleEvent() returns event.what as evNothing), the function
  # returns event.infoPtr.
  # 
  # The latter can be used to determine which view actually handled the
  # dispatched event. The event argument is usually set to evBroadcast.
  # 
  # For example, the default @ref TScrollBar::scrollDraw() sends the following
  # message to the scroll bar's owner:
  # 
  # <pre>
  # message(owner, @ref evBroadcast, cmScrollBarChanged, this);
  # </pre>
  # 
  # The above message ensures that the appropriate views are redrawn whenever
  # the scroll bar's value changes.
  # 
  def self.message( receiver, what, command, infoPtr )
  end

  def validFileName( fileName )
  end

  def self.isWild( f )
  end

  def self.expandPath(path, dir, file)
  end
end
