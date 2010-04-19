module Stddlg
  # Commands
  CmFileOpen    = 1001   # Returned from TFileDialog when Open pressed
  CmFileReplace = 1002   # Returned from TFileDialog when Replace pressed
  CmFileClear   = 1003   # Returned from TFileDialog when Clear pressed
  CmFileInit    = 1004   # Used by TFileDialog internally
  CmChangeDir   = 1005   #
  CmRevert      = 1006   # Used by TChDirDialog internally
  CmDirSelection= 1007   #!! New event - Used by TChDirDialog internally

  #  Messages
  CmFileFocused = 102    # A new file was focused in the TFileList
  CmFileDoubleClicked = 103    # A file was selected in the TFileList

  #
  # TFileInputLine implements a specialized @ref TInputLine allowing the input
  # and editing of file names, including optional paths and wild cards.
  # 
  # A TFileInputLine object is associated with a file dialog box.
  # @short Allows the input and editing of file names, including optional paths
  # and wild cards
  # 
  class TFileInputLine < TInputLine
  public
      # 
      # Calls TInputLine constructor TInputLine(bounds, aMaxLen) to create a
      # file input line with the given bounds and maximum length `aMaxLen'.
      # 
      # @ref evBroadcast flag is set in the @ref eventMask.
      # 
      def initialize( bounds, aMaxLen )
      end

      #
      # Calls @ref TInputLine::handleEvent(), then handles broadcast
      # cmFileFocused events by copying the entered file name into the input
      # line's @ref TInputLine::data member and redrawing the view.
      # 
      # If the edited name is a directory, the current file name in the owning
      # @ref TFileDialog object is appended first.
      # 
      def handleEvent( event )
      end
  end

  # 
  # TSortedListBox is a specialized @ref TListBox derivative that maintains its
  # items in a sorted sequence. It is intended as a base for other list box
  # classes.
  # @short A base for other list box classes
  # 
  class TSortedListBox < TListBox
  public
      # 
      # Calls @ref TListBox constructor to create a list box with the given
      # size `bounds', number of columns `aNumCols', and vertical scroll bar
      # `aScrollBar'.
      # @see TListBox::TListBox
      # 
      # Data member @ref shiftState is set to 0 and the cursor is set at the
      # first item.
      # 
      def initialize( bounds, aNumCols, aScrollBar)
      end

      # 
      # Calls @ref TListBox::handleEvent(), then handles the special key and
      # mouse events used to select items from the list.
      # 
      def handleEvent( event )
      end

      #
      # Calls @ref TListBox::newList() to delete the existing
      # @ref TSortedCollection object associated with this list box and
      # replace it with the collection given by `aList'.
      # 
      # The first item of the new collection will receive the focus.
      # 
      def newList( aList )
      end

      # 
      # Returns a pointer to the @ref TSortedCollection object currently
      # associated with this sorted list box. This gives access the the
      # private @ref items data member, a pointer to the items to be listed
      # and selected.
      # @see TListBox::list
      # 
      # Derived sorted list box classes will typically override list() to
      # provide a pointer to objects of a class derived from
      # @ref TSortedCollection.
      # 
      def list
      end

      attr_accessor :shiftState
      protected :shiftState

  private
      # 
      # You must define this private member function in all derived classes to
      # provide a means of returning the key for the given string `s'. This
      # will depend on the sorting strategy adopted in your derived class. By
      # default, getKey() returns `s'.
      # 
      def getKey( s )
      end

      attr_accessor :searchPos
      private :searchPos
  end

  #
  # TFileList implements a sorted two-column list box of file names (held in a
  # @ref TFileCollection object). You can select (highlight) a file name by
  # mouse or keyboard cursor actions.
  # 
  # TFileList inherits most of its functionality from @ref TSortedListBox.
  # The following commands are broadcast by TFileList:
  # 
  # <pre>
  # Constant            Value Meaning
  # 
  # cmFileFocused       102   A new file was focused in object
  # cmFileDoubleClicked 103   A file was selected in the TFileList object
  # </pre>
  # @short Implements a sorted two-column list box of file names; you can
  # select a file name by mouse or keyboard cursor actions
  # 
  class TFileList < TSortedListBox
  public
      # 
      # Calls the @ref TSortedListBox constructor to create a two-column
      # TFileList object with the given bounds and, if `aScrollBar' is
      # non-zero, a vertical scrollbar.
      # @see TSortedListBox::TSortedListBox
      # 
      def initialize( bounds, aScrollBar)
      end

      #
      # Focuses the given item in the list. Calls
      # @ref TSortedListBox::focusItem() and broadcasts a cmFileFocused event.
      # 
      def focusItem( item )
      end
      
      def selectItem( item )
      end

      # 
      # Grabs the @ref TSearchRec object at `item' and sets the file name in
      # `dest'.
      # "\\" is appended if the name is a directory.
      # 
      def getText( dest, item, maxLen )
      end

      # 
      # Calls @ref TSortedListBox::newList() to delete the existing
      # @ref TFileCollection object associated with this list box and replace
      # it with the file collection given by `aList'.
      # 
      # The first item of the new collection will receive the focus.
      # 
      def newList( aList )
        super.newList(aList)
      end

      # 
      # Allows the separate submission of a relative or absolute path in the
      # `dir' argument. Either "/" or "\\" can be used as subdirectory
      # separators (but "\\" is converted to "/" for output).
      # 
      def readDirectory( dir, wildCard )
      end

      # 
      # Expands the `wildCard' string to generate the file collection
      # associated with this file list. The resulting @ref TFileCollection
      # object (a sorted set of @ref TSearchRec objects) is assigned to the
      # private @ref items data member (accessible via the @ref list() member
      # function).
      # 
      # If too many files are generated, a warning message box appears.
      # readDirectory() knows about file attributes and will not generate
      # hidden file names.
      # 
      def readDirectory( wildCard )
      end

      def dataSize
      end

      def getData( rec )
      end

      def setData( rec )
      end

      # 
      # Returns the private @ref items data member, a pointer to the
      # @ref TFileCollection object currently associated with this file list
      # box.
      # 
      def list
        super.list
      end
  private
      def getKey( s )
      end

      @tooManyFiles
      class << self; attr_accessor :tooManyFiles; end
  end

  # 
  # TFileInfoPane implements a simple, streamable view for displaying file
  # information in the owning file dialog box.
  # @short Implements a simple, streamable view for displaying file information
  # in the owning file dialog box
  # 
  class TFileInfoPane < TView
  public
      # 
      # Calls TView constructor TView(bounds) to create a file information pane
      # with the given bounds.
      # @see TView::TView
      # 
      # @ref evBroadcast flag is set in @ref TView::eventMask.
      # 
      def initialize( bounds )
      end

      #
      # Draws the file info pane in the default palette. The block size and
      # date/time stamp are displayed.
      # 
      def draw
      end

      #
      # Returns the default palette.
      # 
      def getPalette
      end

      #
      # Calls @ref TView::handleEvent(), then handles broadcast cmFileFocused
      # events (triggered when a new file is focused in a file list) by
      # displaying the file information pane.
      # 
      def handleEvent( event )
      end

      #
      # The file name and attributes for this info pane. @ref TSearchRec is
      # defined as follows:
      # 
      # <pre>
      # struct TSearchRec
      # {
      #     uchar attr;
      #     long time;
      #     long size;
      #     char name[MAXFILE+MAXEXT-1];
      # };
      # </pre>
      # 
      # where the fields have their obvious DOS file meanings.
      # 
      class << self
        attr_accessor :months
        private :months
        attr_accessor :pmText
        private :pmText
        attr_accessor :amText
        private :amText
      end
  end

  FdOKButton      = 0x0001       # Put an OK button in the dialog
  FdOpenButton    = 0x0002       # Put an Open button in the dialog
  FdReplaceButton = 0x0004       # Put a Replace button in the dialog
  FdClearButton   = 0x0008       # Put a Clear button in the dialog
  FdHelpButton    = 0x0010       # Put a Help button in the dialog
  FdNoLoadDir     = 0x0100       # Do not load the current directory
                                 # contents into the dialog at Init.
                                 # This means you intend to change the
                                 # WildCard by using SetData or store
                                 # the dialog on a stream.
  #
  # TFileDialog implements a file dialog box, history pick list, and input line
  # from which file names (including wildcards) can be input, edited, selected,
  # and opened for editing.
  # 
  # The following commands are returned by TFileDialog when executed with a
  # call to @ref TGroup::execView():
  # 
  # <pre>
  # Constant       Value Meaning
  # 
  # cmFileOpen     1001  Returned when Open pressed
  # cmFileReplace  1002  Returned when Replace pressed
  # cmFileClear    1003  Returned when Clear pressed
  # cmFileInit     1004  Used by @ref valid()
  # </pre>
  # @short Implements a file dialog box, history pick list, and input line from
  # which file names (including wildcards) can be input, edited, selected, and
  # opened for editing
  # 
  class TFileDialog < TDialog
      # 
      # Creates a fixed-size, framed dialog box with the given title `aTitle'.
      # 
      # A @ref TFileInputLine object (referenced by the @ref fileName data
      # member) is created and inserted, labeled with `inputName' and with its
      # @ref TFileInputLine::data field set to `aWildCard'.
      # 
      # The `aWildCard' argument is expanded (if necessary) to provide a
      # @ref TFileList object, referenced by the @ref fileList data member.
      # 
      # A @ref THistory object is created and inserted with the given history
      # ID `histID'.
      # 
      # A vertical scroll bar is created and inserted. Depending on the
      # `aOptions' flags, the appropriate buttons are set up. These options
      # perform the specified operations:
      # 
      # <pre>
      # Constant        Value  Meaning
      # 
      # fdOKButton      0x0001 Put an OK button in the dialog
      # 
      # fdOpenButton    0x0002 Put an Open button in the dialog
      # 
      # fdReplaceButton 0x0004 Put a Replace button in the dialog
      # 
      # fdClearButton   0x0008 Put a Clear button in the dialog
      # 
      # fdHelpButton    0x0010 Put a Help button in the dialog
      # 
      # fdNoLoadDir     0x0100 Do not load the current directory contents into
      #                        the dialog when intialized. This means you
      #                        intend to change the wildcard by using
      #                        @ref setData() or intend to store the dialog on
      #                        a stream.
      # </pre>
      # 
      # A @ref TFileInfoPane object is created and inserted. If the
      # fdNoLoadDir flag is not set, the files in the current directory are
      # loaded into the file list.
      # 
      def initialize( aWildCard, aTitle, inputName, aOptions, histId )
      end

      def getData( rec )
      end

      #
      # Takes the fileName->data field and expands it to a full path format.
      # The result is set in `s'.
      # @see TFileDialog::fileName
      # @see TFileInputLine::data
      # 
      def getFileName( s )
      end

      # 
      # Calls @ref TDialog::handleEvent(), then handles cmFileOpen,
      # cmFileReplace and cmFileClear events.
      # 
      # These all call @ref TView::endModal() and pass their commands to the
      # view that opened the file dialog.
      # 
      def handleEvent( event )
      end

      def setData( rec )
      end

      # 
      # Returns True if `command' is cmValid, indicating a successful
      # construction. Otherwise calls @ref TDialog::valid().
      # 
      # If this returns True, the current @ref fileName is checked for
      # validity.
      # 
      # Valid names will return True. Invalid names invoke an
      # "Invalid file name" message box and return False.
      # 
      def valid( command )
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
      # Pointer to the associated input line.
      # 
      attr_accessor :fileName

      # 
      # Pointer to the associated file list.
      # 
      attr_accessor :fileList

      #
      # The current path and file name.
      # 
      attr_accessor :wildCard

      # 
      # The current directory.
      # 
      attr_accessor :directory

  private
      def readDirectory
      end

      def checkDirectory( const char * )
      end

      class << self
        attr_accessor :filesText
        private :filesText
        attr_accessor :openText
        private :openText
        attr_accessor :okText
        private :okText
        attr_accessor :replaceText
        private :replaceText
        attr_accessor :clearText
        private :clearText
        attr_accessor :cancelText
        private :cancelText
        attr_accessor :helpText
        private :helpText
        attr_accessor :invalidDriveText
        private :invalidDriveText
        attr_accessor :invalidDriveText
        private :invalidFileText
      end
  end

  # 
  # TDirEntry is a simple class providing directory paths and descriptions.
  # 
  # TDirEntry objects are stored in @ref TDirCollection objects.
  # @short Simple class providing directory paths and descriptions
  # 
  class TDirEntry
      def initialize(txt, dir)
        @displayText = String.new(txt)
        @directory = String.new(dir)
      end

      # 
      # Returns the current directory (the value of the private member
      # directory).
      # 
      def dir 
        @directory
      end

      # 
      # Returns the current display text (the value of the private member
      # displayText).
      # 
      def text
        @displayText
      end
  end

  # 
  # TDirListBox is a specialized derivative of @ref TListBox for displaying and
  # selecting directories stored in a @ref TDirCollection object.
  # 
  # By default, these are displayed in a single column with an optional
  # vertical scroll bar.
  # @short Specialized derivative of TListBox for displaying and selecting
  # directories stored in a TDirCollection object
  # 
  class TDirListBox < TListBox
      #
      # Calls TListBox::TListBox(bounds, 1, aScrollBar) to create a
      # single-column list box with the given bounds and vertical scroll bar.
      # @see TListBox::TListBox
      # 
      def initialize( bounds, aScrollBar )
      end

      #
      # Grabs the text string at index `item' and copies it to `dest'.
      # 
      def getText( dest, item, maxLen )
      end

      #
      # Handles double-click mouse events with putEvent(cmChangeDir).
      # @see putEvent
      # 
      # This allows a double click to change to the selected directory. Other
      # events are handled by @ref TListBox::handleEvent().
      # 
      def handleEvent(event)
      end

      #
      # Returns True if `item' is selected, otherwise returns False.
      # 
      def isSelected( item )
      end

      def selectItem( item )
      end

      #
      # Deletes the existing @ref TDirEntry object associated with this list
      # box and replaces it with the file collection given by `aList'.
      # 
      # The first item of the new collection will receive the focus.
      # 
      def newDirectory( aList )
      end

      # *
      # By default, calls the ancestral @ref TListBox::setState().
      # 
      def setState( aState, enable )
      end

      # 
      # Returns a pointer to the @ref TDirCollection object currently
      # associated with this directory list box.
      # 
      def list
        super.list
      end

      class << self
        attr_accessor :pathDir
        attr_accessor :firstDir
        attr_accessor :middleDir
        attr_accessor :lastDir
        attr_accessor :graphics
      end
  private
      def showDrives( TDirCollection * )
      end

      def showDirs( TDirCollection * )
      end

      class << self
        attr_accessor :drives
        private :drives
      end
  end

  CdNormal = 0x0000, # Option to use dialog immediately
  CdNoLoadDir  = 0x0001, # Option to init the dialog to store on a stream
  CdHelpButton = 0x0002; # Put a help button in the dialog

  # 
  # TChDirDialog implements a dialog box labeled "Change Directory", used to
  # change the current working directory.
  # @see TDialog
  # 
  # An input line is provided to accept a directory name from the user. A
  # history window and directory list box with vertical scroll bar are
  # available to show recent directory selections and a tree of all available
  # directories.
  # @see TDirListBox
  # @see THistoryWindow
  # @see TInputLine
  # 
  # Mouse and keyboard selections can be made in the usual way by highlighting
  # and clicking. The displayed options are:
  # 
  # -# Directory name
  # -# Directory tree
  # -# OK (the default)
  # -# Chdir
  # -# Revert
  # -# Help
  # 
  # Method @ref TChDirDialog::handleEvent() generates the appropriate commands
  # for these selections.
  # 
  # Note: @ref TDirListBox is a friend of TChDirDialog, so that the member
  # functions of @ref TDirListBox can access the private members of
  # TChDirDialog.
  # @short Dialog box used to change the current working directory
  # 
  class TChDirDialog < TDialog
      # 
      # Constructor.
      # 
      # Creates a change directory dialog object with the given history
      # identifier `histId'. The `aOptions' argument is a bitmap of the
      # following flags:
      # 
      # <pre>
      # Constant     Value Meaning
      # 
      # cdNormal     0x00  Option to use the dialog immediately.
      # 
      # cdNoLoadDir  0x01  Option to initialize the dialog without loading the
      #                    current directory into the dialog. Used if you
      #                    intend using @ref setData() to reset the directory
      #                    or prior to storage on a stream.
      # 
      # cdHelpButton 0x02  Option to put a help button in the dialog.
      # </pre>
      # 
      # The constructor creates and inserts:
      # 
      # -# a @ref TInputLine object (labeled "Directory ~n~ame")
      # -# a @ref THistory object
      # -# a vertical scroll bar, see @ref TScrollBar
      # -# a TDirListBox object (labeled "Directory ~t~ree")
      # -# three buttons "O~K~", "~C~hdir" and "~R~evert", see @ref TButton
      # 
      # If `aOptions' has the cdHelpButton flag set, a fourth help button is
      # created. Unless the cdNoLoadDir option is set, the dialog box is loaded
      # with the current directory.
      # 
      # Unsigned short `histId' is an arbitrary positive integer used to
      # identify which history set to use. The library can use multiple history
      # sets and all views with the same history identifier will share the same
      # history set.
      # 
      def initialize( aOptions, histId )
      end

      #
      # Returns the size of the data record of this dialog.
      # 
      # By default, dataSize() returns 0. Override to return the size (in
      # bytes) of the data used by @ref getData() and @ref setData() to store
      # and retrieve dialog box input data.
      # @see TGroup::dataSize
      # 
      def dataSize
      end

      #
      # Reads the data record of this dialog.
      # 
      # By default, getData() does nothing. Override to copy @ref dataSize()
      # bytes from the view to `rec'. Used in combination with @ref dataSize()
      # and @ref setData() to store and retrieve dialog box input data.
      # @see TGroup::getData
      # 
      def getData( rec )
      end

      #
      # Standard TChDirDialog event handler.
      # 
      # Calls @ref TDialog::handleEvent() then processes cmRevert (restore
      # previously current directory) and cmChangeDir (switch to selected
      # directory) events. The dialog is redrawn if necessary.
      # 
      def handleEvent(event)
      end

      # 
      # Writes the data record of this dialog.
      # 
      # By default, setData() does nothing. Override to copy @ref dataSize()
      # bytes from `rec' to the view. Used in combination with @ref dataSize()
      # and @ref getData() to store and retrieve dialog box input data.
      # @see TGroup::setData
      # 
      def setData( rec )
      end

      #
      # Checks if the command `command' is valid.
      # 
      # The return value is True if `command' is not cmOK.  Otherwise (the OK
      # button was pressed) the return value depends on path existence. The
      # function returns True if the path exists. An invalid directory invokes
      # the "Invalid directory" message box and returns False.
      # @see TDialog::valid
      # 
      def valid( command )
      end

  private
      def setUpDialog
      end

      class << self
        attr_accessor :changeDirTitle
        private :changeDirTitle
        attr_accessor :dirNameText
        private :dirNameText
        attr_accessor :dirTreeText
        private :dirTreeText
        attr_accessor :okText
        private :okText
        attr_accessor :chdirText
        private :chdirText
        attr_accessor :revertText
        private :revertText
        attr_accessor :helpText
        private :helpText
        attr_accessor :drivesText
        private :drivesText
        attr_accessor :invalidText
        private :invalidText
      end
  end
end
