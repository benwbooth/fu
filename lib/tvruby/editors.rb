module TVRuby::Editors

  UfUpdate = 0x01
  UfLine   = 0x02
  UfView   = 0x04

  SmExtend = 0x01
  SmDouble = 0x02

  SfSearchFailed = UINT_MAX

  CmFind        = 82
  CmReplace     = 83
  CmSearchAgain = 84

  CmCharLeft    = 500
  CmCharRight   = 501
  CmWordLeft    = 502
  CmWordRight   = 503
  CmLineStart   = 504
  CmLineEnd     = 505
  CmLineUp      = 506
  CmLineDown    = 507
  CmPageUp      = 508
  CmPageDown    = 509
  CmTextStart   = 510
  CmTextEnd     = 511
  CmNewLine     = 512
  CmBackSpace   = 513
  CmDelChar     = 514
  CmDelWord     = 515
  CmDelStart    = 516
  CmDelEnd      = 517
  CmDelLine     = 518
  CmInsMode     = 519
  CmStartSelect = 520
  CmHideSelect  = 521
  CmIndentMode  = 522
  CmUpdateTitle = 523

  # \var edOutOfMemory
  # @see TEditor::doSearchReplace
  # 
  EdOutOfMemory   = 0

  # \var edReadError
  # @see TEditor::doSearchReplace
  # 
  EdReadError     = 1

  # \var edWriteError
  # @see TEditor::doSearchReplace
  # 
  EdWriteError    = 2

  # * \var edCreateError
  # @see TEditor::doSearchReplace
  # 
  EdCreateError   = 3

  # \var edSaveModify
  # @see TEditor::doSearchReplace
  # 
  EdSaveModify    = 4

  # * \var edSaveUntitled
  # @see TEditor::doSearchReplace
  # 
  EdSaveUntitled  = 5

  # * \var edSaveAs
  # @see TEditor::doSearchReplace
  # 
  EdSaveAs        = 6

  # * \var edFind
  # @see TEditor::doSearchReplace
  # 
  EdFind          = 7

  # * \var edSearchFailed
  # @see TEditor::doSearchReplace
  # 
  EdSearchFailed  = 8

  # * \var edReplace
  # @see TEditor::doSearchReplace
  # 
  EdReplace       = 9

  # * \var edReplacePrompt
  # @see TEditor::doSearchReplace
  # 
  EdReplacePrompt = 10

  # * \var efCaseSensitive
  # Default to case-sensitive search.
  # @see TEditor::editorFlags
  # 
  EfCaseSensitive   = 0x0001

  # * \var efWholeWordsOnly
  # Default to whole words only search.
  # @see TEditor::editorFlags
  # 
  EfWholeWordsOnly  = 0x0002

  # * \var efPromptOnReplace
  # Prompt on replace.
  # @see TEditor::editorFlags
  # 
  EfPromptOnReplace = 0x0004

  # * \var efReplaceAll
  # Replace all occurrences.
  # @see TEditor::editorFlags
  # 
  EfReplaceAll      = 0x0008

  # * \var efDoReplace
  # Do replace.
  # @see TEditor::editorFlags
  # 
  EfDoReplace       = 0x0010

  # * \var efBackupFiles
  # Create backup files with a trailing ~ on saves.
  # @see TEditor::editorFlags
  # 
  EfBackupFiles     = 0x0100

  # * \var maxLineLength
  # Maximum allowed line length for text in a TEditor view.
  # 
  MaxLineLength = 256

  # * \enum TEditorDialog
  # The TEditorDialog data type is a pointer to function returning ushort
  # and taking one int argument and a variable number of additional
  # arguments.
  # 
  # Since dialog boxes are very application-dependent, a @ref TEditor object
  # does not display its own dialog boxes directly. Instead it controls
  # them through this function pointer.
  # 
  # The various dialog values, passed in the first int argument, are
  # self-explanatory: @ref edOutOfMemory, @ref edReadError, @ref edWriteError,
  # @ref edCreateError, @ref edSaveModify, @ref edSaveUntitled, @ref edSaveAs,
  # @ref edFind, @ref edSearchFailed, @ref edReplace and @ref edReplacePrompt.
  # @see TEditor::editorDialog
  # 

  # * \fn defEditorDialog( int dialog, ... )
  # Since dialog boxes are very application-dependent, a @ref TEditor object
  # does not display its own dialog boxes directly. Instead it controls
  # them through the @ref TEditorDialog function pointer.
  # @see TEditor::editorDialog
  # 
  # This is the default dialog; it simply returns cmCancel.
  # 
  def self.defEditorDialog(dialog)
  end

  #
  # TIndicator is the line and column counter in the lower left corner of the
  # edit window.
  # It is initialized by the @ref TEditWindow constructor and passed as the
  # fourth argument to the @ref TEditor constructor.
  # @short The line and column counter in the lower left corner of the edit
  # window
  # 
  class TIndicator < TView
  public
      # 
      # Creates a TIndicator object.
      # 
      def initialize( const TRect& );

      #
      # Draws the indicator. If variable @ref modified is True, a special
      # character (ASCII value 15, a star on PC graphic adapters) is displayed.
      # 
      def draw
      end

      #
      # Returns the TIndicator default palette.
      # 
      def getPalette
      end

      #
      # Draws the indicator in the frame-dragging color if the view is being
      # dragged.
      # 
      def setState( ushort, Boolean )
      end

      #
      # Method called by @ref TEditor to update and display the values of the
      # data members of the associated TIndicator object.
      # @see TIndicator::location
      # @see TIndicator::modified
      # 
      void setValue( const TPoint& aLocation, Boolean aModified );

      #
      # Undocumented.
      # 
      @dragFrame
      class << self; attr_accessor :dragFrame; end

      #
      # Undocumented.
      # 
      @normalFrame
      class << self; attr_accessor :normalFrame; end

      #
      # Stores the location to display. Updated by a TEditor.
      # 
      attr_accessor :location
      protected :location

      #
      # True if the associated TEditor has been modified.
      # 
      attr_accessor :modified
      protected :modified
  end

  # 
  # This class implements a text editor.
  # 
  # TEditor is the base class for all editors. It implements most of the
  # editor's functionality. If a TEditor object is created, it allocates a
  # buffer of the given size out of the heap. The buffer is initially empty.
  # @short Implements a text editor
  # 
  class TEditor < TView
  public

      def countLines(buf, count)
        num_lines=0
        buf[0, count].lines {|n| num_lines+=1}
        num_lines
      end

      def scan(block, size, str)
        block.index(str)
      end

      def iScan(block, size, str)
        block.index(Regexp.new(Regexp.escape(str), Regexp::IGNORECASE))
      end

      # 
      # Constructor.
      # 
      # Calls TView::TView(bounds) by creating a view with the given bounds.
      # The @ref hScrollBar, @ref vScrollBar, @ref indicator and @ref bufSize
      # data members are set from the given arguments.
      # @see TView::TView
      # 
      # The scroll bar and indicator arguments can be set to 0 if you do not
      # want these objects. The following default values are set:
      # 
      # <pre>
      # Variable   Value                     Description
      # 
      # canUndo    True                      @ref TEditor::canUndo
      # selecting  False                     @ref TEditor::selecting
      # overwrite  False                     @ref TEditor::overwrite
      # autoIndent False                     @ref TEditor::autoIndent
      # lockCount  0                         @ref TEditor::lockCount
      # keyState   0                         @ref TEditor::keyState
      # growMode   @ref gfGrowHiX | @ref gfGrowHiY     @ref TView::growMode
      # options    @ref ofSelectable              @ref TView::options
      # eventMask  @ref evMouseDown | @ref evKeyDown |
      #            @ref evCommand | @ref evBroadcast   @ref TView::eventMask
      # </pre>
      # 
      # `aBufSize' is the buffer initial size; 0 is its common value.
      # The buffer is allocated and cleared. If insufficient memory exists,
      # the @ref edOutOfMemory dialog box is displayed using
      # @ref editorDialog(), and @ref isValid data member is set False.
      # Otherwise @ref isValid is set True.
      # 
      # The data members associated with the editor buffer are initialized in
      # the obvious way: @ref bufLen to 0, @ref gapLen to @ref bufSize,
      # @ref selStart to 0, @ref modified to False, and so on.
      # 
      def initialize( bounds, aHScrollBar, aVScrollBar, aIndicator, aBufSize )
      end

      # 
      # Used internally by @ref TObject::destroy() to ensure correct
      # destruction of derived and related objects. shutDown() is overridden
      # in many classes to ensure the proper setting of related data members
      # when @ref destroy() is called.
      # 
      def shutDown
      end

      # 
      # Returns the p'th character in the file, factoring in the gap.
      # 
      def bufChar( p )
        @buffer[p + ((p >= @curPtr) ? @gapLen : 0)]
      end

      # 
      # Returns the offset into buffer of the p'th character in the file,
      # factoring in the gap.
      # 
      def bufPtr( p )
        (p >= @curPtr) ? p + @gapLen : p
      end

      # 
      # Changes the views bounds, adjusting the @ref delta value and redrawing
      # the scrollbars and view if necessary.
      # 
      # Overridden to ensure the file stays within view if the parent size
      # changes.
      # 
      def changeBounds( bounds )
      end

      # 
      # Used by @ref handleEvent() to provide basic editing operations by
      # converting various key events to command events. You can change or
      # extend these default key bindings by overriding the convertEvent()
      # member function.
      # 
      def convertEvent( event )
      end

      # 
      # Returns True if the @ref cursor (insertion point) is visible within the
      # view.
      # 
      def cursorVisible
      end

      # 
      # Deletes the selection if one exists. For example, after a successful
      # @ref clipCopy(), the selected block is deleted.
      # 
      def deleteSelect
      end

      # 
      # Deletes the buffer.
      # 
      def doneBuffer
      end

      # 
      # Overrides @ref TView::draw() to draw the editor.
      # 
      def draw
      end

      # 
      # Returns the default TEditor palette. Override if you wish to change the
      # palette of the editor.
      # 
      def getPalette
      end

      # 
      # Provides the event handling for the editor. Override if you wish to
      # extend the commands the editor handles.
      # 
      # The default handler calls @ref TView::handleEvent(), then converts all
      # relevant editing key events to command events by calling
      # @ref convertEvent().
      # 
      def handleEvent( event )
      end

      # 
      # Allocates a buffer of size @ref bufSize and sets @ref buffer to point
      # at it.
      # 
      def initBuffer
      end

      # 
      # This is the lowest-level text insertion member function. It inserts
      # `length' bytes of text from the array `p' (starting at p[offset]) into
      # the buffer (starting at the @ref curPtr).
      # 
      # If `allowUndo' is set True, insertBuffer() records undo information. If
      # `selectText' is set True, the inserted text will be selected.
      # insertBuffer() returns True for a successful operation.
      # 
      # Failure invokes a suitable dialog box and returns False. insertBuffer()
      # is used by @ref insertFrom() and @ref insertText(); you will seldom
      # need to call it directly.
      # 
      def insertBuffer( p, offset, length, allowUndo, selectText )
      end

      # 
      # Inserts the current block-marked selection from the argument `editor'
      # into this editor.
      # This member function implements @ref clipCut(), @ref clipCopy(), and
      # @ref clipPaste().
      # 
      # The implementation may help you understand the insertFrom() and
      # @ref insertBuffer() functions:
      # 
      # <pre>
      # Boolean TEditor::insertFrom(TEditor *editor)
      # {
      #     return insertBuffer(editor->buffer,
      #         editor->bufPtr(editor->selStart),
      #         editor->selEnd - editor->selStart, canUndo, isClipboard());
      # }
      # </pre>
      # 
      # Note the the `allowUndo' argument is set to the value of the data
      # member @ref canUndo. The `selectText' argument will be True if there
      # is an active clipboard for this editor.
      # 
      def insertFrom( editor )
      end

      # 
      # Copies `length' bytes from the given text into this object's buffer.
      # 
      # If `selectText' is True, the inserted text will be selected. This is a
      # simplified version of @ref insertBuffer().
      # 
      def insertText( text, length, selectText )
      end

      # 
      # Move column `x' and line `y' to the upper-left corner of the editor.
      # 
      def scrollTo( x, y )
      end

      # 
      # Search for the given string `findStr' in the editor @ref buffer
      # (starting at @ref curPtr) with the given options in `opts'. The valid
      # options are:
      # 
      # <pre>
      # Name              Value  Description
      # 
      # @ref efCaseSensitive   0x0001 Case sensitive search
      # @ref efWholeWordsOnly  0x0002 Whole words only search
      # </pre>
      # 
      # Returns True if a match is found; otherwise returns False. If a match
      # is found, the matching text is selected.
      # 
      def search( findStr, opts )
      end

      # 
      # Should be called before changing the buffer size to `newSize'. It
      # should return True if the the buffer can be of this new size.
      # 
      # By default, it returns True if `newSize' is less than or equal to
      # @ref bufSize.
      # 
      def setBufSize( newSize )
      end

      # 
      # Enables or disables the given command depending on whether `enable' is
      # True or False and whether the editor is @ref sfActive.
      # @see TView::state
      # 
      # The command is always disabled if the editor is not the selected view.
      # Offers a convenient alternative to @ref enableCommands() and
      # @ref disableCommands().
      # 
      def setCmdState( command, enable )
      end

      # 
      # Sets the selection to the given offsets into the file, and redraws the
      # view as needed.
      # 
      # This member function will either place the cursor in front of or behind
      # the selection, depending on the value (True or False, respectively) of
      # `curStart'.
      # 
      def setSelect( newStart, newEnd, curStart )
      end

      # 
      # Overrides @ref TView::setState() to hide and show the indicator and
      # scroll bars.
      # 
      # It first calls @ref TView::setState() to enable and disable commands.
      # If you wish to enable and disable additional commands, override
      # @ref updateCommands() instead. This is called whenever the command
      # states should be updated.
      # 
      def setState( aState, enable )
      end

      # 
      # Forces the cursor to be visible. If `center' is True, the cursor is
      # forced to be in the center of the screen in the y (line) direction.
      # The x (column) position is not changed.
      # 
      def trackCursor(center )
      end

      # 
      # Undoes the changes since the last cursor movement.
      # 
      def undo
      end

      # 
      # Called whenever the commands should be updated. This is used to enable
      # and disable commands such as cmUndo and cmCopy.
      # 
      def updateCommands
      end

      # 
      # Returns whether the view is valid for the given command. By default it
      # returns the value of @ref isValid, which is True if @ref buffer is
      # not 0.
      # 
      def valid( command )
      end

      # 
      # Calculates and returns the actual cursor position by examining the
      # characters in the buffer between `p' and `target'.
      # Any tab codes encountered are counted as spaces modulo the tab setting.
      # @see TEditor::charPtr
      # 
      def charPos( p, target )
      end

      # 
      # The reverse of @ref charPos().
      # Calculates and returns the buffer position corresponding to a cursor
      # position.
      # 
      def charPtr( p, target )
      end

      # 
      # Returns False if this editor has no active clipboard.
      # Otherwise, copies the selected text from the editor to the clipboard
      # using clipboard->insertFrom(this).
      # @see TEditor::insertFrom
      # 
      # The selected text is deselected (highlight removed) and the view
      # redrawn. Returns True if all goes well.
      # 
      def clipCopy
      end

      # 
      # The same as for @ref clipCopy(), but the selected text is deleted after
      # being copied to the clipboard.
      # 
      def clipCut
      end

      # 
      # The reverse of @ref clipCopy(): the contents of the clipboard (if any)
      # are copied to the current position of the editor using
      # insertFrom(clipboard).
      # @see TEditor::insertFrom
      # 
      def clipPaste
      end

      # 
      # If `delSelect' is True and a current selection exists, the current
      # selection is deleted; otherwise, the range `startPtr' to `endPtr' is
      # selected and deleted.
      # 
      def deleteRange( startPtr, endPtr, delSelect )
      end

      # 
      # If @ref updateFlags data member is 0, nothing happens. Otherwise, the
      # view and its scrollbars are updated and redrawn depending on the state
      # of the @ref updateFlags bits.
      # 
      # For example, if ufView is set, the view is redrawn with
      # @ref drawView(). If the view is @ref sfActive, the command set is
      # updated with @ref updateCommands().
      # @see TView::state
      # 
      # After these updates, @ref updateFlags is set to 0.
      # 
      def doUpdate
      end

      # 
      # Can be used in both find and find/replace operations, depending on the
      # state of @ref editorFlags data member bits and user-dialog box
      # interactions.
      # 
      # If @ref efDoReplace is not set, doSearchReplace() acts as a simple
      # search for @ref findStr data member, with no replacement. Otherwise,
      # this function aims at replacing occurrences of @ref findStr with
      # @ref replaceStr data member.
      # 
      # In all cases, if the target string is not found, an
      # editorDialog(@ref edSearchFailed) call is invoked.
      # @see TEditor::editorDialog
      # 
      # If @ref efPromptOnReplace is set in @ref editorFlags, an
      # @ref edReplacePrompt dialog box appears. Replacement then depends on
      # the user response. If @ref efReplaceAll is set, replacement proceeds
      # for all matching strings without prompting until a cmCancel command is
      # detected.
      # 
      def doSearchReplace
      end

      # 
      # Draws `count' copies of the line at `linePtr', starting at line
      # position `y'.
      # 
      def drawLines( y, count, linePtr )
      end

      # 
      # Formats the line at `linePtr' in the given color and sets result in
      # `buff'. Used by @ref drawLines().
      # 
      def formatLine(drawbuf, linePtr, width, color)
        i = 0       # index in the DrawBuf
        p = linePtr # index in the Buffer
        curColor

        # draw the first part of the buffer
        while (p < @curPtr) && (@buffer[p] != "\n") && (i <= width)
          curColor = (p>=@selStart && p<@selEnd) ? 
            (color & 0xFF00) :
            ((color & 0xFF) << 8)

          if @buffer[p] == 0x9
            begin
              drawBuf[i] = ' '.ord + curColor
              i+=1
            end while ((i % 8) && (i <= width))
            p+=1
          else
            drawBuf[i] = curColor | @buffer[p]
            p+=1 
            i+=1
          end
        end

        # draw the second part of the buffer

        if p >= @curPtr
          p += @gapLen
        
          while (p < @bufSize) && (@buffer[p] != "\n") && (i <= width)
            curColor = (p>=@selStart && p<@selEnd) ? 
              (color & 0xFF00) :
              ((color & 0xFF) << 8)

            if @buffer[p] == 0x9
              begin
                drawBuf[i] = ' '.ord + curColor
                i+=1
              end while (i % 8) && (i <= width)
              p+=1
            else
              drawBuf[i] = curColor | @buffer[p]
              p+=1
              i+=1
            end
          end
        end

        while (i < width) 
          curColor = (p>=@selStart && p<@selEnd) ? (color & 0xFF00) : 
            ((color & 0xFF) << 8)
          drawBuf[i] = ' '.ord + curColor
          i+=1
        end
      end

      # 
      # Finds occurrences of the existing @ref findStr or a new user-supplied
      # string. find() displays an editor dialog inviting the input of a find
      # string or the acceptance of the existing @ref findStr.
      # 
      # If a new find string is entered, it will replace the previous
      # @ref findStr (unless the user cancels).
      # find() first creates a @ref TFindDialogRec object defined as follows:
      # 
      # <pre>
      # struct TFindDialogRec
      # {
      #     TFindDialogRec(const char *str, ushort flgs)
      #     {
      #         strcpy(find, str);
      #         options = flgs;
      #     }
      #     char find[80];
      #     ushort options;
      # };
      # </pre>
      # 
      # The constructor is called with `str' set to the current @ref findStr,
      # and `flgs' set to the current @ref editorFlags.
      # 
      # The @ref edFind editor dialog then invites change or acceptance of the
      # @ref findStr. Finally, @ref doSearchReplace() is called for a simple
      # find-no-replace (@ref efDoReplace switched off).
      # 
      def find
      end

      # 
      # Returns the buffer character pointer corresponding to the point `m' on
      # the screen.
      # 
      def getMousePtr( m )
      end

      # 
      # Returns True if a selection has been made; that is, if @ref selStart
      # does not equal @ref selEnd. If these two data members are equal, no
      # selection exists, and False is returned.
      # 
      def hasSelection
      end

      # 
      # Sets selecting to False and hides the current selection with
      # setSelect(curPtr, curPtr, False).
      # @see TEditor::curPtr
      # @see TEditor::setSelect
      # 
      def hideSelect
      end

      # 
      # Returns True if this editor has an attached clipboard; otherwise
      # returns False.
      # 
      def isClipboard
      end

      # 
      # Returns the buffer pointer (offset) of the end of the line containing
      # the given pointer `p'.
      # 
      def lineEnd( p )
        if p < @curPtr
            while p < @curPtr
                if @buffer[p] == "\n"
                    return p
                else
                    p+=1
                end
            end
            if @curPtr == @bufLen
                return @bufLen
            end
        else
            if p == @bufLen
                return @bufLen
            end
        end

        while (p + @gapLen < @bufSize)
            if @buffer[p + @gapLen] == "\n"
                return p
            else
                p+=1
            end
        end

        return p
      end

      # 
      # Moves the line containing the pointer (offset) `p' up or down `count'
      # lines depending on the sign of `count'.
      # 
      def lineMove( p, count )
      end

      # 
      # Returns the buffer pointer (offset) of the start of the line contaning
      # the given pointer `p'.
      # 
      def lineStart( p )
        while p > @curPtr
          p -= 1
          if @buffer[p + @gapLen] == "\n"
            return p+1
          end
        end

        if @curPtr == 0
            return 0
        end

        while p > 0
          p -= 1
          if @buffer[p] == "\n"
            return p+1
          end
        end

        return 0
      end

      # 
      # Increments the semaphore @ref lockCount.
      # 
      def lock
      end

      # 
      # Inserts a newline at the current pointer. If @ref autoIndent is set,
      # appropriate tabs (if needed) are also inserted at the start of the new
      # line.
      # 
      def newLine
      end

      # 
      # Returns the buffer offset for the character following the one at the
      # given offset `p'.
      # 
      def nextChar( p )
        if p == bufLen 
          return p
        end
        return p+1
      end

      # 
      # Returns the buffer offset for the start of the line following the line
      # containing the given offset `p'.
      # 
      def nextLine( p )
      end

      # 
      # Returns the buffer offset for the start of the word following the word
      # containing the given offset `p'.
      # 
      def nextWord( p )
      end

      # 
      # Returns the buffer offset for the character preceding the one at the
      # given offset `p'.
      # 
      def prevChar( p )
        if p == 0
          return p
        end
        return p-1
      end

      # 
      # Returns the buffer offset for the start of the line preceding the line
      # containing the given offset `p'.
      # 
      def prevLine( p )
      end

      # 
      # Returns the buffer offset corresponding to the start of the word
      # preceding the word containing the given offset `p'.
      # 
      def prevWord( p )
      end

      # 
      # Replaces occurrences of the existing @ref findStr (or a new
      # user-supplied find string) with the existing @ref replaceStr (or a
      # new user-supplied replace string).
      # 
      # replace() displays an editor dialog inviting the input of both strings
      # or the acceptance of the existing @ref findStr and @ref replaceStr.
      # If new strings are entered, they will replace the previous values
      # (unless the user cancels).
      # 
      # replace() first creates a @ref TReplaceDialogRec object defined as
      # follows:
      # 
      # <pre>
      # struct TReplaceDialogRec
      # {
      #     TReplaceDialogRec(const char *str, const char *rep, ushort flgs)
      #     {
      #         strcpy(find, str);
      #         strcpy(replace, rep);
      #         options = flgs;
      #     }
      #     char find[80];
      #     char replace[80];
      #     ushort options;
      # };
      # </pre>
      # 
      # The constructor is called with `str' and `rep' set to the current
      # @ref findStr and @ref replaceStr, and with `flg' set to the current
      # @ref editorFlags.
      # 
      # The @ref edReplace editor dialog then invites change or acceptance of
      # the two strings.
      # @see TEditor::editorDialog
      # 
      # Finally, @ref doSearchReplace() is called for a find-replace operation
      # (@ref efDoReplace switched on).
      # 
      def replace
      end

      # 
      # Sets @ref bufLen to `length', then adjusts @ref gapLen and @ref limit
      # accordingly. @ref selStart, @ref selEnd, @ref curPtr, delta.x, delta.y,
      # @ref drawLine, @ref drawPtr, @ref delCount, and @ref insCount are all
      # set to 0.
      # @see TEditor::delta
      # 
      # @ref curPos is set to @ref delta, @ref modified is set to False, and
      # the view is updated and redrawn as needed.
      # 
      # The TEditor constructor calls setBufLen(0). setBufLen() is also used
      # by @ref insertBuffer().
      # @see TEditor::TEditor
      # 
      def setBufLen( length )
      end

      # 
      # Calls @ref setSelect() and repositions @ref curPtr to the offset `p'.
      # Some adjustments may be made, depending on the value of `selectMode',
      # if @ref curPtr is at the beginning or end of a selected text.
      # 
      def setCurPtr( p, selectMode )
      end

      # 
      # Called by @ref handleEvent() when a Ctrl-K Ctrl-B selection is detected.
      # Hides the previous selection and sets @ref selecting to True.
      # 
      def startSelect
      end

      # 
      # Toggles the @ref overwrite data member from True to False and from
      # False to True. Changes the cursor shape by calling @ref setState().
      # 
      def toggleInsMode
      end

      # 
      # Decrements the data member @ref lockCount until it reaches the value
      # 0, at which point a @ref doUpdate() is triggered. The lock/unlock
      # mechanism prevents over-frequent redrawing of the view.
      # 
      def unlock
      end

      # 
      # Sets `aFlags' in the @ref updateFlags data member. If @ref lockCount
      # is 0, calls @ref doUpdate().
      # 
      def update( uchar aFlags )
      end

      # 
      # Called by @ref handleEvent() in response to a cmScrollBarChanged
      # broadcast event. If the scroll bar's current value is different from
      # `d', the scroll bar is redrawn.
      # 
      def checkScrollBar( event, p, d )
      end

      # 
      # Pointer to the horizontal scroll bar; 0 if the scroll bar does not
      # exist.
      # 
      attr_accessor :hScrollBar

      # 
      # Pointer to the vertical scroll bar; 0 if the scroll bar does not exist.
      # 
      attr_accessor :vScrollBar

      # 
      # Pointer to the indicator; 0 if the indicator does not exist.
      # 
      attr_accessor :indicator

      # 
      # Pointer to the buffer used to hold the text.
      # 
      attr_accessor :buffer

      # 
      # Size of the buffer (in bytes).
      # 
      attr_accessor :bufSize

      # 
      # The amount of text stored between the start of the buffer and the
      # current cursor position.
      # 
      attr_accessor :bufLen

      # 
      # The size of the "gap" between the text before the cursor and the text
      # after the cursor.
      # 
      attr_accessor :gapLen

      # 
      # The offset of the start of the text selected by Ctrl-K Ctrl-B.
      # 
      attr_accessor :selStart

      # 
      # The offset of the end of the text selected by Ctrl-K Ctrl-K.
      # 
      attr_accessor :selEnd

      # 
      # Offset of the cursor.
      # 
      attr_accessor :curPtr

      # 
      # The line/column location of the cursor in the file.
      # 
      attr_accessor :curPos

      # 
      # The top line and leftmost column shown in the view.
      # 
      attr_accessor :delta

      # 
      # The maximum number of columns to display, and the number of lines in
      # the file. Records the limits of the scroll bars.
      # 
      attr_accessor :limit

      # 
      # Column position on the screen where inserted characters are drawn.
      # Used internally by @ref draw().
      # 
      attr_accessor :drawLine

      # 
      # Buffer offset corresponding to the current cursor. Used internally by
      # @ref draw().
      # 
      attr_accessor :drawPtr

      # 
      # Number of characters in the end of the gap that were deleted from the
      # text. Used to implement @ref undo().
      # 
      attr_accessor :delCount

      # 
      # Number of characters inserted into the text since the last cursor
      # movement. Used to implement @ref undo().
      # 
      attr_accessor :insCount

      # 
      # True if the view is valid. Used by the @ref valid() function.
      # 
      attr_accessor :isValid

      # 
      # True if the editor is to support undo. Otherwise False.
      # 
      attr_accessor :canUndo

      # 
      # True if the buffer has been modified.
      # 
      attr_accessor :modified

      # 
      # True if the editor is in selecting mode (that is, Ctrl-K Ctrl-B has
      # been pressed).
      # 
      attr_accessor :selecting

      # 
      # True if in overwrite mode; otherwise the editor is in insert mode.
      # 
      attr_accessor :overwrite

      # 
      # True if the editor is in autoindent mode.
      # 
      attr_accessor :autoIndent

      # 
      # The TEditorDialog data type is a pointer to function returning ushort
      # and taking one int argument and a variable number of additional
      # arguments. It is defined in `editors.h' as follows:
      # 
      # <pre>
      # typedef ushort (*TEditorDialog)(int, ...);
      # </pre>
      # 
      # Variable editorDialog is a function pointer used by TEditor objects to
      # display various dialog boxes.
      # 
      # Since dialog boxes are very application-dependent, a TEditor object
      # does not display its own dialog boxes directly. Instead it controls
      # them through this function pointer.
      # 
      # The various dialog values, passed in the first int argument, are
      # self-explanatory: @ref edOutOfMemory, @ref edReadError,
      # @ref edWriteError, @ref edCreateError, @ref edSaveModify,
      # @ref edSaveUntitled, @ref edSaveAs, @ref edFind, @ref edSearchFailed,
      # @ref edReplace and @ref edReplacePrompt.
      # 
      # The default editorDialog, @ref defEditorDialog(), simply returns
      # cmCancel.
      # 
      @editorDialog = Proc.new { CmCancel  }
      class << self; attr_accessor :editorDialog; end

      # 
      # Variable editorFlags contains various flags for use in the editor:
      # 
      # <pre>
      # Name              Value  Description
      # 
      # @ref efCaseSensitive   0x0001 Default to case-sensitive search
      # @ref efWholeWordsOnly  0x0002 Default to whole words only search
      # @ref efPromptOnReplace 0x0004 Prompt on replace
      # @ref efReplaceAll      0x0008 Replace all occurrences
      # @ref efDoReplace       0x0010 Do replace
      # @ref efBackupFiles     0x0100 Create backup files with a trailing ~ on saves
      # </pre>
      # 
      # The default value is @ref efBackupFiles | @ref efPromptOnReplace.
      # 
      @editorFlags = EfBackupFiles | EfPromptOnReplace
      class << self; attr_accessor :editorFlags; end

      # 
      # Stores the last string value used for a find operation.
      # 
      @findStr = ''
      class << self; attr_accessor :findStr; end

      # 
      # Stores the last string value of a replace operation.
      # 
      @replaceStr = ''
      class << self; attr_accessor :replaceStr; end

      # 
      # Pointer to the clipboard.
      # 
      # Any TEditor can be the clipboard; it just needs be assigned to this
      # variable. The clipboard should not support undo (i.e., its @ref canUndo
      # should be false).
      # 
      @clipboard = nil
      class << self; attr_accessor :clipboard; end

      # 
      # Holds the lock count semaphore that controls when a view is redrawn.
      # lockCount is incremented by @ref lock() and decremented by
      # @ref unlock().
      # 
      @lockCount
      class << self; attr_accessor :lockCount; end

      # 
      # A set of flags indicating the state of the editor.
      # @ref doUpdate() and other member functions examine these flags to
      # determine whether the view needs to be redrawn.
      # 
      attr_accessor :updateFlags

      # 
      # Indicates that a special key, such as Ctrl-K, has been pressed. Used
      # by @ref handleEvent() to keep track of "double" control keys such
      # as Ctrl-K-H and Ctrl-K-B.
      # 
      attr_accessor :keyState
  end


  #
  # Data structure used by @ref TMemo.
  # @short Data structure used by TMemo
  # 
  class TMemoData
      #
      # Undocumented.
      # 
      attr_accessor :length

      #
      # Undocumented.
      # 
      attr_accessor :buffer
  end

  #
  # TMemo, which is derived from TEditor, is designed for insertion into a
  # dialog or form.
  # @short Derived from TEditor and designed for insertion into a dialog or
  # form
  # 
  class TMemo < TEditor
  public
      # *
      # Constructor.
      # @see TEditor::TEditor
      # 
      def initialize( bounds, aHScrollBar, aVScrollBar, aIndicator, aBufSize )
      end

      def getData( rec )
      end

      def setData( rec )
      end

      #
      # Used with @ref getData() and @ref setData(), which are inherited from
      # TView and redefined. By default it returns (sizeof(ushort) +
      # @ref bufSize).
      # 
      def dataSize
      end

      #
      # Returns the default memo palette.
      # 
      def getPalette
      end

      #
      # Prevents TMemo from handling kbTab key events; otherwise handles
      # events the same as a @ref TEditor.
      # @see TEditor::handleEvent
      # 
      def handleEvent(event)
      end
  end

  #
  # TFileEditor is a specialized derivative of TEditor for editing the contents
  # of a file.
  # @short Specialized derivative of TEditor for editing the contents of a file
  # 
  class TFileEditor < TEditor
  public
      #
      # The name of the file being edited.
      # 
      attr_accessor :fileName

      #
      # Creates a TFileEditor object with the given scroll bars and indicator
      # and loads the contents of the file given in `aFileName'.
      # 
      # If the file is not found or invalid, an error message will be displayed
      # and the object's @ref valid() member function will return False.
      # 
      # The @ref options variable is set to @ref ofSelectable and the
      # @ref eventMask is set to allow the handling of broadcast events.
      # 
      # Any of `aHScrollBar', `aVScrollBar' or `aIndicator' arguments can be
      # set to 0 if you do not want them.
      # 
      def initialize( bounds, aHScrollBar, aVScrollBar, aIndicator, aFileName)
      end

      # 
      # Deletes the buffer.
      # 
      def doneBuffer
      end

      #
      # Calls @ref TEditor::handleEvent(), then handles cmSave and cmSaveAs
      # commands.
      # 
      # The cmSave command invokes @ref save(); the cmSaveAs command invokes
      # @ref saveAs().
      # 
      def handleEvent(event)
      end

      #
      # Allocates @ref bufSize bytes of memory for the file editor buffer.
      # 
      def initBuffer
      end

      #
      # Reads the @ref fileName file from disk and checks for errors.
      # 
      # Returns True if all is well; otherwise returns False. Depending on the
      # reason for failure, the @ref edOutOfMemory or @ref edReadError dialog
      # box is displayed with a call to @ref editorDialog().
      # 
      def loadFile
      end

      #
      # Calls @ref saveAs() if the file being edited is "Untitled" (that is, no
      # @ref fileName is allocated) and returns the return value from
      # @ref saveAs().
      # 
      # If there is a valid @ref fileName, @ref saveFile() is invoked, and
      # save() returns the return value of @ref saveFile().
      # 
      def save
      end

      #
      # Invokes the @ref edSaveAs dialog, which prompts for a "save as" file
      # name. If a valid file name is supplied, the current text will be saved
      # with this name using the @ref saveFile() member function.
      # @see editorDialog
      # 
      # The file editor's owner is informed of this event via a broadcast
      # cmUpdateTitle message. saveAs() returns True if the @ref saveFile()
      # call is successful, otherwise False is returned.
      # 
      # False is also returned if the @ref edSaveAs dialog is cancelled.
      # 
      def saveAs
      end

      # 
      # Saves the @ref fileName file to disk. Returns False if the save fails;
      # otherwise returns True. If @ref editorFlags has the @ref efBackupFiles
      # bit set, a backup file is created.
      # 
      # The @ref edCreateError or @ref edWriteError dialog box will be
      # displayed to indicate the reason for failure if save fails.
      # @see editorDialog
      # 
      def saveFile
      end

      #
      # Overrides @ref TEditor::setBufSize() to grow and shrink the buffer.
      # 
      # Will grow and shrink the buffer in 4K byte increments. @ref gapLen
      # data member is adjusted appropriately.
      # 
      def setBufSize( newSize )
      end

      #
      # Undocumented.
      # 
      def shutDown
      end

      #
      # Calls @ref TEditor::updateCommands(), then enables the cmSave and
      # cmSaveAs commands. These commands are only valid if the selected view
      # is an editor, otherwise they should be disabled.
      # 
      def updateCommands
      end

      #
      # Overrides @ref TEditor::valid() to warn that the file might need saving
      # before the program exits.
      # 
      # The @ref edSaveUntitled or @ref edSaveModify dialogs are displayed as
      # appropriate.
      # @see editorDialog
      # 
      # Returns False if the user cancels the save.
      # 
      def valid( ushort )
      end

  private
      @backupExt
      class << self; attr_accessor :backupExt; private :backupExt; end
  end

  #
  # TEditWindow is a window designed to hold a @ref TFileEditor or the
  # clipboard.
  # 
  # It will change its title to display the file name being edited and will
  # initialize scroll bars and an indicator for the editor.
  # @see TIndicator
  # @short Designed to hold a TFileEditor or the clipboard
  # 
  class TEditWindow < TWindow
  public
      #
      # Creates a TEditWindow object that will edit the given file name with
      # window number `aNumber'. Initializes a framed, tileable window with
      # scroll bars and an indicator. If `fileName' is 0, it is assumed to be
      # an untitled file.
      # 
      # Note: if @ref editor data member is equal to @ref TEditor::clipboard
      # static data member, the editor is assumed to be the clipboard.
      # 
      def initialize( bounds, fileName, aNumber )
      end

      #
      # Overrides @ref TWindow::close() to hide rather than close the window
      # if the editor is a clipboard.
      # 
      def close
      end

      #
      # Returns the name of the file being edited, or "Clipboard" if the editor
      # is the clipboard.
      # 
      def getTitle( short )
      end

      #
      # Handles cmUpdateTitle to redraw the frame of the window. Used in
      # @ref TFileEditor::saveAs() to change the title of the window if the
      # file being edited changes names.
      # 
      def handleEvent( event )
      end

      #
      # Undocumented.
      # 
      def sizeLimits( min, max )
      end

      # 
      # Pointer to the editor associated with this window.
      # 
      attr_accessor :editor

      class << self; attr_accessor :clipboardTitle; private :clipboardTitle; end
      class << self; attr_accessor :untitled; private :untitled; end
  end

  #
  # Data record used by TEditor.
  # @see TEditor::find
  # @see TReplaceDialogRec
  # @see TView::dataSize
  # @see TView::getData
  # @see TView::setData
  # 
  class TFindDialogRec
    #
    # Undocumented.
    # 
    def initialize( str, flgs )
      find = String.new(str)
      options = flgs
    end

    #
    # Undocumented.
    # 
    attr_accessor :find

    #
    # Undocumented.
    # 
    attr_accessor :options
  end

  #
  # Data record used by TEditor.
  # @see TEditor::replace
  # @see TFindDialogRec
  # @see TView::dataSize
  # @see TView::getData
  # @see TView::setData
  # 
  class TReplaceDialogRec
    #
    # Undocumented.
    # 
    def initialize( str, rep, flgs )
      find = String.new(str)
      replace = String.new(rep)
      options = flgs;
    end

    #
    # Undocumented.
    # 
    attr_accessor :find

    #
    # Undocumented.
    # 
    attr_accessor :replace

    #
    # Undocumented.
    # 
    attr_accessor :options
  end
end
