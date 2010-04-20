module TVRuby::Colorsel
  CmColorForegroundChanged = 71
  CmColorBackgroundChanged = 72
  CmColorSet               = 73
  CmNewColorItem           = 74
  CmNewColorIndex          = 75
  CmSaveColorIndex         = 76

  # 
  # Stores information about a color item. TColorItem defines a linked list of
  # color names and indexes.
  # 
  # The interrelated classes TColorItem, @ref TColorGroup, @ref TColorSelector,
  # @ref TMonoSelector, @ref TColorDisplay, @ref TColorGroupList,
  # @ref TColorItemList and @ref TColorDialog provide viewers and dialog boxes
  # from which the user can select and change the color assignments from
  # available palettes with immediate effect on the screen.
  # @short Information about a color item
  # 
  class TColorItem
  public
      # 
      # Constructor.
      # 
      # Creates a color item object with @ref name set to `nm', @ref index set
      # to `idx' and, by default, @ref next set to 0.
      # 
      # `nm' is a pointer to the name of the color item.  A local copy of the
      # string is created. `idx' is the color index. `nxt' is a pointer to the
      # next color item (its default value is 0).
      # 
      # See file `demo/tvdemo2.cc' for an example. 
      # 
      def initialize(nm, idx, nxt)
      end

      # 
      # The name of the color item.
      # 
      attr_accessor :name
      # 
      # The color index of the item.
      # 
      attr_accessor :index

      #
      # Link to the next color item, or 0 if there is no next item.
      # 
      attr_accessor :next

      #
      # Inserts another color item after this one by changing the
      # @ref TColorItem::next pointer.
      # 
      def + ( i1, i2 )
      end
  end

  #
  # The interrelated classes @ref TColorItem, TColorGroup, @ref TColorSelector,
  # @ref TMonoSelector, @ref TColorDisplay, @ref TColorGroupList,
  # @ref TColorItemList and @ref TColorDialog provide viewers and dialog boxes
  # from which the user can select and change the color assignments from
  # available palettes with immediate effect on the screen.
  # 
  # The TColorGroup class defines a group of linked lists of @ref TColorItem
  # objects. Each member of a color group consists of a set of color names and
  # their associated color codes.
  # @short Stores a set of color items
  # 
  class TColorGroup
  public
      #
      # Constructor.
      # 
      # Creates a color group with the given argument values.
      # 
      # `nm' is a pointer to the name of the color group.  A local copy of the
      # string is created. `itm' is a pointer to the first color item of the
      # color group (its default value is 0). `nxt' is a pointer to the next
      # color group (its default value is 0).
      # 
      # See file `demo/tvdemo2.cc' for an example. 
      # 
      def initialize(nm, itm = 0, nxt )
      end

      #
      # The name of the color group.
      # 
      attr_accessor :name

      #
      # The start index of the color group.
      # 
      attr_accessor :index

      #
      # Pointer to the associated list of color items associated with this
      # color group.
      # 
      attr_accessor :items

      #
      # Pointer to next color group, or 0 if no next.
      # 
      attr_accessor :next

      # 
      # Inserts color item `i' in color group `g'.
      # @see TColorItem
      # 
      #
      # Inserts another color group after this one by changing the
      # @ref TColorGroup::next pointer. 
      # @see TColorItem
      # 
      def operator + ( g1, g2 )
      end
  end

  #
  # Data structure used by @ref TColorDialog::getIndexes() and
  # @ref TColorDialog::setIndexes().
  # 
  class TColorIndex
  public
      #
      # Undocumented.
      # 
      attr_accessor :groupIndex

      #
      # Undocumented.
      # 
      attr_accessor :colorSize

      #
      # Undocumented.
      # 
      attr_accessor :colorIndex
  end

  #
  # The interrelated classes @ref TColorItem, @ref TColorGroup,
  # TColorSelector, @ref TMonoSelector, @ref TColorDisplay,
  # @ref TColorGroupList, @ref TColorItemList and @ref TColorDialog provide
  # viewers and dialog boxes from which the user can select and change the
  # color assignments from available palettes with immediate effect on the
  # screen.
  # 
  # TColorSelector is a view for displaying the color selections available.
  # @short Color viewer used to display available color selections
  # 
  class TColorSelector < TView
  public
      #
      # This view can handle two sets of colors: the 8 background colors or the
      # 16 foreground colors.
      # 
      CsBackground = 0
      CsForeground = 1

      #
      # Constructor.
      # 
      # Calls TView constructor TView(bounds) to create a view with the given
      # `bounds'. Sets @ref options data member with @ref ofSelectable,
      # @ref ofFirstClick, and @ref ofFramed. Sets @ref eventMask to
      # @ref evBroadcast, @ref selType to `aSelType', and @ref color to 0.
      # 
      # `aSelType' may be one of the following values:
      # 
      # <pre>
      # Constant     Value Meaning
      # 
      # csBackground 0     show the 8 background colors
      # csForeground 1     show the 16 foreground colors
      # </pre>
      # 
      def initialize ( bounds, aSelType )
      end

      #
      # Draws the color selector.
      # 
      def draw
      end

      #
      # Handles mouse and key events: you can click on a given color indicator
      # to select that color, or you can select colors by positioning the
      # cursor with the arrow keys.
      # 
      # Changes invoke @ref drawView() when appropriate.
      # 
      def handleEvent( event )
      end

      #
      # This character is used to mark the current color.
      # 
      attr_accessor :icon

      #
      # Holds the currently selected color.
      # 
      attr_accessor :color
      protected :color

      #
      # Specifies if the view shows the 8 background colors or the 16
      # foreground colors.
      # 
      # Gives attribute (foreground or background) of the currently selected
      # color. @ref ColorSel is an enum defined as follows:
      # 
      # <pre>
      # enum ColorSel { csBackground = 0, csForeground }
      # </pre>
      # 
      attr_accessor :selType
      protected :color
  end

  #
  # The interrelated classes @ref TColorItem, @ref TColorGroup,
  # @ref TColorSelector, TMonoSelector, @ref TColorDisplay,
  # @ref TColorGroupList, @ref TColorItemList and @ref TColorDialog are used
  # to provide viewers and dialog boxes from which the user can select and
  # change the color assignments from available palettes with immediate effect
  # on the screen.
  # 
  # TMonoSelector implements a cluster from which you can select normal,
  # highlight, underline, or inverse video attributes on monochrome screens.
  # @short Monochrome color selector
  # 
  class TMonoSelector < TCluster
  public
      #
      # Constructor.
      # 
      # Creates a cluster by calling the TCluster constructor with four
      # buttons labeled: "Normal", "Highlight", "Underline", and "Inverse".
      # The @ref evBroadcast flag is set in @ref eventMask. `bounds' is the
      # bounding rectangle of the view.
      # @see TCluster::TCluster
      # 
      def initialize( bounds )
      #
      # Draws the selector cluster.
      # 
      def draw
      end

      # 
      # Calls @ref TCluster::handleEvent() and responds to cmColorSet events by
      # changing the data member value accordingly. The view is redrawn if
      # necessary. @ref value holds a video attribute corresponding to the
      # selected attribute.
      # 
      def handleEvent( event )
      end

      #
      # Returns True if the item'th button has been selected; otherwise returns
      # False.
      # 
      def mark( item )
      end

      #
      # Informs the owning group if the attribute has changed.
      # 
      def newColor

      #
      # "Presses" the item'th button and calls @ref newColor().
      # 
      def press( item )
      end

      #
      # Sets value to the item'th attribute (same effect as @ref press()).
      # 
      def movedTo( item )
      end
  end

  #
  # TColorDisplay and these interrelated classes provide viewers and dialog
  # boxes from which the user can select and change the screen attributes and
  # color assignments from available palettes with immediate effect on the
  # screen:
  # 
  # @ref TColorItem, @ref TColorGroup, @ref TColorSelector, @ref TMonoSelector,
  # @ref TColorGroupList, @ref TColorItemList and @ref TColorDialog.
  # 
  # TColorDisplay is a view for displaying text so that the user can select a
  # suitable palette.
  # @short Viewer used to display and select colors
  # 
  class TColorDisplay < TView
  public
      #
      # Constructor.
      # 
      # Creates a view of the given size with TView constructors TView(bounds),
      # then sets text to the `aText' argument.
      # 
      # `bounds' is the bounding rectangle of the view. `aText' is the string
      # printed in the view.
      # 
      def initialize( bounds, aText )
      end

      #
      # Draws the view with given text and current color.
      # 
      def draw
      end

      #
      # Calls @ref TView::handleEvent() and redraws the view as appropriate in
      # response to the cmColorBackgroundChanged and cmColorForegroundChanged
      # broadcast events.
      # 
      def handleEvent( event )
      end

      #
      # Change the currently displayed color. Sets color to `aColor',
      # broadcasts the change to the owning group, then calls
      # @ref drawView().
      # 
      def setColor( aColor )
      end

      #
      # Stores the current color for this display.
      # 
      attr_accessor :color
      protected :color

      #
      # Stores a pointer to the text string to be displayed.
      # 
      attr_accessor :text
      protected :text
  end

  #
  # The interrelated classes @ref TColorItem, @ref TColorGroup,
  # @ref TColorSelector, @ref TMonoSelector, @ref TColorDisplay,
  # TColorGroupList, @ref TColorItemList and @ref TColorDialog provide
  # viewers and dialog boxes from which the user can select and change the
  # color assignments from available palettes with immediate effect on the
  # screen.
  # 
  # TColorGroupList is a specialized derivative of @ref TListViewer providing a
  # scrollable list of named color groups. Groups can be selected in any of the
  # usual ways (by mouse or keyboard).
  # 
  # TColorGroupList uses the @ref TListViewer event handler without
  # modification.
  # @short Implements a scrollable list of named color groups
  # 
  class TColorGroupList < TListViewer
  public
      #
      # Constructor.
      # 
      # Calls TListViewer(bounds, 1, 0, aScrollBar) to create a single-column
      # list viewer a single vertical scroll bar. Then, sets @ref groups data
      # member to `aGroups'.
      # @see TListViewer::TListViewer
      # 
      def initialize( bounds, aScrollBar, aGroups)
      end

      #
      # Selects the given item by calling TListViewer::focusItem(item) and then
      # broadcasts a cmNewColorItem event.
      # @see TListViewer::focusItem
      # 
      def focusItem( item )
      end

      #
      # Copies the group name corresponding to `item' to the `dest' string.
      # 
      def getText( dest, item, maxLen )
      end

      #
      # Undocumented.
      # 
      def handleEvent(event)
      end

      #
      # The color group for this list viewer.
      # 
      attr_accessor :groups
      protected :groups
  end

  #
  # The interrelated classes @ref TColorItem, @ref TColorGroup,
  # @ref TColorSelector, @ref TMonoSelector, @ref TColorDisplay,
  # @ref TColorGroupList, TColorItemList, and @ref TColorDialog provide
  # viewers and dialog boxes from which the user can select and change the
  # color assignments from available palettes with immediate effect on the
  # screen.
  # 
  # TColorItemList is a simpler variant of @ref TColorGroupList for viewing and
  # selecting single color items rather than groups of colors.
  # 
  # Like @ref TColorGroupList, TColorItemList is specialized derivative of
  # @ref TListViewer. Color items can be selected in any of the usual ways (by
  # mouse or keyboard).
  # 
  # Unlike @ref TColorGroupList, TColorItemList overrides the @ref TListViewer
  # event handler.
  # @short Used to view and select single color items
  # 
  class TColorItemList < public TListViewer
  public
      #
      # Calls TListViewer constructor TListViewer(bounds, 1, 0, aScrollBar) to
      # create a single-column list viewer with a single vertical scroll bar.
      # 
      # Then, the constructor sets @ref items data member to `aItems' and
      # @ref range to the number of items.
      # 
      def initialize( bounds, aScrollBar, aItems)
      end

      #
      # Selects the given item by calling TListViewer::focusItem(item), then
      # broadcasts a cmNewColorIndex event.
      # @see TListViewer::focusItem
      # 
      def focusItem( item )
      end

      #
      # Copies the item name corresponding to `item' to the `dest' string.
      # 
      def getText( dest, item, maxLen )
      end

      #
      # Calls @ref TListViewer::handleEvent(). Then, if the event is
      # cmNewColorItem, the appropriate item is focused and the viewer is
      # redrawn.
      # 
      def handleEvent( event )
      end

      #
      # The color item list for this viewer.
      # 
      attr_accessor :items
      protected :items
  end

  #
  # These interrelated classes provide viewers and dialog boxes from which the
  # user can select and change the color assignments from available palettes
  # with immediate effect on the screen:
  # 
  # @ref TColorDisplay, @ref TColorGroup, @ref TColorGroupList,
  # @ref TColorItem, @ref TColorItemList, @ref TColorSelector,
  # @ref TMonoSelector and TColorDialog.
  # 
  # TColorDialog is a specialized scrollable dialog box called "Colors" from
  # which the user can examine various palette selections before making a
  # selection.
  # @short Viewer used to examine and change the standard palette
  # 
  class TColorDialog < TDialog
  public
      #
      # Constructor.
      # 
      # Calls the @ref TDialog and @ref TScrollBar constructors to create a
      # fixed size, framed window titled "Colors" with two scroll bars. The
      # @ref pal data member is set to `aPalette'. The given `aGroups'
      # argument creates and inserts a @ref TColorGroup object with an
      # associated label: "~G~roup". The items in `aGroups' initialize a
      # @ref TColorItemList object, which is also inserted in the dialog,
      # labeled as "~I~tem".
      # 
      # `aPalette' is a pointer to the initial palette to be modified. This
      # class creates a local copy of the initial palette, so the initial
      # palette is never modified. You may safely leave this field to 0 and set
      # the palette with a subsequent call to @ref setData(). `aGroups' is a
      # pointer to a cluster of objects which specifies all the items in the
      # palette.
      # 
      # See file `demo/tvdemo2.cc' for an example.
      # 
      def initialize( aPalette, aGroups )
      end

      #
      # By default, dataSize() returns the size of the current palette,
      # expressed in bytes.
      # 
      def dataSiz
      end

      #
      # Reads the data record of this dialog.
      # 
      # Copies @ref dataSize() bytes from @ref pal to `rec'. `rec' should
      # point to a @ref TPalette object. Its contents will be overwritten by
      # the contents of this object.
      # @see setData
      # 
      def getData( rec )
      end

      #
      # Calls @ref TDialog::handleEvent() and redisplays if the broadcast event
      # generated is cmNewColorIndex.
      #  
      def handleEvent( event )
      end

      #
      # Writes the data record of this view.
      # 
      # The reverse of @ref getData(): copies from `rec' to @ref pal,
      # restoring the saved color selections. `rec' should point to a
      # @ref TPalette object.
      # 
      def setData(rec)
      end

      #
      # Is a pointer to the current palette selection.
      # 
      attr_accessor :pal
  protected
      # 
      # The color display object for this dialog box.
      # 
      attr_accessor :display
      protected :display

      #
      # The color group for this dialog box.
      # 
      attr_accessor :groups
      protected :groups

      #
      # The foreground color label.
      # 
      attr_accessor :forLabel
      protected :forLabel

      # 
      # The foreground color selector.
      # 
      attr_accessor :forSel
      protected :forSel

      #
      # The background color label.
      # 
      attr_accessor :bakLabel
      protected :bakLabel

      #
      # The background color selector.
      # 
      attr_accessor :bakSel
      protected :bakSel

      #
      # The monochrome label.
      # 
      attr_accessor :monoLabel
      protected :monoLabel

      #
      # The selector for monochrome attributes.
      # 
      attr_accessor :monoSel
      protected :monoSel

      #
      # Undocumented.
      # 
      attr_accessor :groupIndex
      protected :groupIndex
  end
end

