module TVRuby::Colorsel
  include TVRuby::System

  CmColorForegroundChanged = 71
  CmColorBackgroundChanged = 72
  CmColorSet               = 73
  CmNewColorItem           = 74
  CmNewColorIndex          = 75
  CmSaveColorIndex         = 76

  @colorIndexes = 0
  class << self; attr_accessor :colorIndexes; end

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
        @index = idx
        @next = nxt
        @name = String.new(nm)
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
        cur = i1
        while !cur.next.nil?
          cur = cur.next
        end
        cur.next = i2
        return i1
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
      def initialize(nm, itm = nil, nxt )
        @items = itm
        @next = nxt
        @name = String.new(nm)
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
        if g2.is_a? TColorItem
          grp = g1
          while !grp.next.nil?
            grp  grp.next
          end
          if grp.items == 0
            grp.items = g2
          else
            cur = grp.items
            while !cur.next.nil?
              cur = cur.next
            end
            cur.next = i
          end
          return g
        elsif g2.is_a? TColorGroup
          cur = g1
          while !cur.next.nil?
            cur = cur.next
          end
          cur.next = g2
          return g1
        else
          raise ArgumentError
        end
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
        super(bounds)
        @options |= OfSelectable | OfFirstClick | OfFramed
        @eventMask |= EvBroadcast
        @selType = aSelType
        @color = 0
      end

      #
      # Draws the color selector.
      # 
      def draw
        b = TDrawBuffer.new
        b.moveChar(0, ' ', 0x70, size.x )
        0.upto(size.y) do |i|
            if i < 4
              0.upto(3) do |j|
                c = i*4+j
                b.moveChar(j*3, icon, c, 3 )
                if c == color 
                  b.putChar(j*3+1, 8)
                  if c == 0
                    b.putAttribute(j*3+1, 0x70)
                  end
                end
              end
            end
            writeLine( 0, i, size.x, 1, b)
        end
      end

      #
      # Handles mouse and key events: you can click on a given color indicator
      # to select that color, or you can select colors by positioning the
      # cursor with the arrow keys.
      # 
      # Changes invoke @ref drawView() when appropriate.
      # 
      def handleEvent( event )
        Width = 4

        TView.handleEvent(event)
        oldColor = color
        maxCol = (@selType == CsBackground) ? 7 : 15
        case event.what
        when EvMouseDown
          begin
            if mouseInView(event.mouse.where)
              mouse = makeLocal(event.mouse.where)
              color = mouse.y*4 + mouse.x/3
            else
                color = oldColor
            end
            colorChanged
            drawView
          end while mouseEvent(event, EvMouseMove )
        when EvKeyDown
          case ctrlToArrow(event.keyDown.keyCode)
          when kbLeft
            if color > 0
                color-=1
            else
                color = maxCol
            end
          when KbRight
              if color < maxCol
                  color+=1
              else
                  color = 0
              end
          when KbUp
            if color > width-1
                color -= width
            elsif color == 0
                color = maxCol
            else
                color += maxCol - width
            end
          when KbDown
              if color < maxCol - (width-1)
                  color += width
              elsif color == maxCol
                  color = 0
              else
                  color -= maxCol - width
              end
          else
            return
          end
        when EvBroadcast
          if event.message.command == CmColorSet
              if selType == CsBackground
                  color = event.message.infoPtr >> 4
              else
                  color = event.message.infoPtr & 0x0F
              end
              drawView
              return
          else
              return
          end
        else
          return 
        end

        drawView
        colorChanged
        clearEvent(event)
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

    private
      def colorChanged
        msg = nil
        if @selType == CsForeground
          msg = CmColorForegroundChanged
        else
          msg = CmColorBackgroundChanged
        end
        message(owner, EvBroadcast, msg, @color)
      end
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

      @monoColors = [0x07, 0x0F, 0x01, 0x70, 0x09]
      class << self; attr_accessor :monoColors; end

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
        super(bounds, TSItem.new(normal, 
                      TSItem.new(highlight, 
                      TSItem.new(underline, 
                      TSItem.new(inverse, nil)))))
        @eventMask |= EvBroadcast
      end

      #
      # Draws the selector cluster.
      # 
      def draw
        drawBox(button, 0x07)
      end

      # 
      # Calls @ref TCluster::handleEvent() and responds to cmColorSet events by
      # changing the data member value accordingly. The view is redrawn if
      # necessary. @ref value holds a video attribute corresponding to the
      # selected attribute.
      # 
      def handleEvent( event )
        TCluster.handleEvent(event)
        if (event.what == EvBroadcast && 
            event.message.command == CmColorSet)
          value = event.message.infoPtr
          drawView
        end
      end

      #
      # Returns True if the item'th button has been selected; otherwise returns
      # False.
      # 
      def mark( item )
        monoColors[item] == value
      end

      #
      # Informs the owning group if the attribute has changed.
      # 
      def newColor
        message(owner, EvBroadcast, CmColorForegroundChanged, value & 0x0F)
        message(owner, EvBroadcast, CmColorBackgroundChanged, (value >> 4) & 0x0F)
      end

      #
      # "Presses" the item'th button and calls @ref newColor().
      # 
      def press( item )
        value = monoColors[item]
        newColor
      end

      #
      # Sets value to the item'th attribute (same effect as @ref press()).
      # 
      def movedTo( item )
        value = monoColors[item]
        newColor
      end

      class << self
        attr_accessor :button
        private :button
        attr_accessor :normal
        private :normal
        attr_accessor :highlight
        private :highlight
        attr_accessor :underline
        private :underline
        attr_accessor :inverse
        private :inverse
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
        super(bounds)
        @color = 0
        @text = String.new(aText)
      end

      #
      # Draws the view with given text and current color.
      # 
      def draw
        c = color
        if c == 0
            c = @errorAttr
        end
        len = @text.length
        b = TDrawBuffer.new
        0.upto(size.x/len) do |i|
            b.moveStr( i*len, text, c )
        end
        writeLine( 0, 0, size.x, size.y, b )
      end

      #
      # Calls @ref TView::handleEvent() and redraws the view as appropriate in
      # response to the cmColorBackgroundChanged and cmColorForegroundChanged
      # broadcast events.
      # 
      def handleEvent( event )
        TView.handleEvent( event )
        if event.what == EvBroadcast
          case event.message.command 
          when CmColorBackgroundChanged
            @color = (@color & 0x0F) | ((event.message.infoPtr << 4) & 0xF0)
            drawView
          when CmColorForegroundChanged
            @color = (@color & 0xF0) | (event.message.infoPtr & 0x0F)
            drawView
          end
        end
      end

      #
      # Change the currently displayed color. Sets color to `aColor',
      # broadcasts the change to the owning group, then calls
      # @ref drawView().
      # 
      def setColor( aColor )
        @color = aColor
        message( owner, EvBroadcast, CmColorSet, @color )
        drawView
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
      #
      # Constructor.
      # 
      # Calls TListViewer(bounds, 1, 0, aScrollBar) to create a single-column
      # list viewer a single vertical scroll bar. Then, sets @ref groups data
      # member to `aGroups'.
      # @see TListViewer::TListViewer
      # 
      def initialize( bounds, aScrollBar, aGroups)
        super(bounds, 1, 0, aScrollBar)
        @group = aGroups

        i = 0
        while aGroups != 0
          aGroups = aGroups.next
          i+=1
        end
        setRange(i)
      end

      #
      # Selects the given item by calling TListViewer::focusItem(item) and then
      # broadcasts a cmNewColorItem event.
      # @see TListViewer::focusItem
      # 
      def focusItem( item )
        TListViewer.focusItem( item )
        curGroup = groups

        while( item > 0 )
          item -= 1
          curGroup = curGroup.next
        end
        message( owner, EvBroadcast, CmNewColorItem, curGroup)
      end

      #
      # Copies the group name corresponding to `item' to the `dest' string.
      # 
      def getText( dest, item, maxLen )
        curGroup = groups
        while( item > 0 )
          item -= 1 
          curGroup = curGroup.next
        end
        dest = String.new(curGroup.name)
      end

      def handleEvent(event)
        TListViewer.handleEvent(ev)
        if ((ev.what == EvBroadcast) &&
            (ev.message.command == CmSaveColorIndex))
          setGroupIndex(focused, ev.message.infoPtr)
        end
      end

      def setGroupIndex(groupNum, itemNum)
        g = getGroup(groupNum)
        if !g.nil?
          g.index = itemNum
        end
      end

      def getGroupIndex(groupNum)
        g = getGroup(groupNum)
        if g
          return g.index
        end
        return nil
      end

      def getGroup(groupNum)
        g = groups

        while (groupNum != 0)
          groupNum -= 1
          g = g.next
        end
        return g
      end

      def getNumGroups
        g = groups;

        n=0
        while !g.nil?
          g = g.next
          n += 1 
        end
        return n
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
  class TColorItemList < TListViewer
      #
      # Calls TListViewer constructor TListViewer(bounds, 1, 0, aScrollBar) to
      # create a single-column list viewer with a single vertical scroll bar.
      # 
      # Then, the constructor sets @ref items data member to `aItems' and
      # @ref range to the number of items.
      # 
      def initialize( bounds, aScrollBar, aItems)
        super(bounds, 1, 0, aScrollBar)
        @items = aItems
        @eventMask |= EvBroadcast
        i = 0
        while aItems != 0
          aItems = aItems.next
          i += 1
        end
        setRange(i)
      end

      #
      # Selects the given item by calling TListViewer::focusItem(item), then
      # broadcasts a cmNewColorIndex event.
      # @see TListViewer::focusItem
      # 
      def focusItem( item )
        TListViewer.focusItem( item )
        message(owner, EvBroadcast, CmSaveColorIndex, item)

        curItem = items
        while( item > 0 )
          item -= 1
          curItem = curItem.next
        end
        message( owner, EvBroadcast, CmNewColorIndex, curItem.index)
      end

      #
      # Copies the item name corresponding to `item' to the `dest' string.
      # 
      def getText( dest, item, maxChars )
        curItem = items
        while item > 0 
          item -= 1
          curItem = curItem.next
        end
        curItem.name = String.new(dest)
      end

      #
      # Calls @ref TListViewer::handleEvent(). Then, if the event is
      # cmNewColorItem, the appropriate item is focused and the viewer is
      # redrawn.
      # 
      def handleEvent( event )
        TListViewer.handleEvent( event )
        if event.what == EvBroadcast 
           g = event.message.infoPtr
          curItem = nil
          i = 0

          case event.message.command
          when CmNewColorItem
            curItem = items = g.items
              while curItem != 0
                curItem = curItem.next
                i++
              end
              setRange( i )
              focusItem( g.index)
              drawView
          end
        end
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
        super(TRect.new(0,0,79,18), @colors, TColorDialog.initFrame)
        @options |= OfCentered

        if !aPalette.nil?
          @pal = TPalette.new(aPalette)
        else
          @pal = nil
        end

        @sb = TScrollBar.new(TRect.new( 27, 3, 28, 14 ))
        insert( @sb )

        @groups = TColorGroupList.new(TRect.new( 3, 3, 27, 14 ), @sb, aGroups)
        insert( @groups )
        insert( TLabel.new( TRect.new( 3, 2, 10, 3 ), @groupText, @groups ) )

        @sb = TScrollBar.new( TRect.new( 59, 3, 60, 14 ) )
        insert( @sb )

        p = TColorItemList.new( TRect.new( 30, 3, 59, 14 ), @sb, aGroups.items )
        insert( p )
        insert( TLabel.new( TRect.new( 30, 2, 36, 3 ), @itemText, p ) )

        @forSel = TColorSelector.new( TRect.new( 63, 3, 75, 7 ),
            TColorSelector::CsForeground )
        insert( @forSel )
        @forLabel = TLabel.new( TRect.new( 63, 2, 75, 3 ), @forText, @forSel )
        insert( forLabel )

        @bakSel = TColorSelector.new( TRect.new( 63, 9, 75, 11 ),
            TColorSelector::CsBackground )
        insert( @bakSel )
        @bakLabel = TLabel.new( TRect.new( 63, 8, 75, 9 ), @bakText, @bakSel )
        insert( @bakLabel )

        @display = TColorDisplay.new( TRect.new( 62, 12, 76, 14 ), @textText )
        insert( @display )

        @monoSel = TMonoSelector.new( TRect.new( 62, 3, 77, 7 ) )
        @monoSel.hide
        insert( @monoSel )
        @monoLabel = TLabel.new( TRect.new( 62, 2, 69, 3 ), @colorText, @monoSel )
        @monoLabel.hide
        insert( @monoLabel )

        insert( TButton.new( TRect.new( 51, 15, 61, 17 ), okText, CmOK, BfDefault ) )
        insert( TButton.new( TRect.new( 63, 15, 73, 17 ), cancelText, CmCancel, BfNormal ) )
        selectNext( false )

        if @pal != 0 
            setData( @pal )
        end
      end

      #
      # By default, dataSize() returns the size of the current palette,
      # expressed in bytes.
      # 
      def dataSize
        @pal.data + 1
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
        getIndexes(@colorIndexes)
        rec = @pal.dup
      end

      #
      # Calls @ref TDialog::handleEvent() and redisplays if the broadcast event
      # generated is cmNewColorIndex.
      #  
      def handleEvent( event )
        if event.what==EvBroadcast && event.message.command==CmNewColorItem 
          @groupIndex = @groups.focused
        end
        TDialog.handleEvent( event )
        if event.what==EvBroadcast && event.message.command==CmNewColorIndex 
          display.setColor( @pal.data[event.message.infoPtr] )
        end
      end

      #
      # Writes the data record of this view.
      # 
      # The reverse of @ref getData(): copies from `rec' to @ref pal,
      # restoring the saved color selections. `rec' should point to a
      # @ref TPalette object.
      # 
      def setData(rec)
        @pal = rec.dup

        setIndexes(colorIndexes)
        display.setColor(pal.data[@groups.getGroupIndex(@groupIndex)])
        @groups.focusItem( @groupIndex)
        if showMarkers 
            forLabel.hide
            forSel.hide
            bakLabel.hide
            bakSel.hide
            monoLabel.show
            monoSel.show
        end
        @groups.select
      end

      def getIndexes ( colIdx )
        n = @groups.getNumGroups
        if (!colIdx || colIdx == 0)
          colIdx = TColorIndex.new
          colIdx.colorSize = n
        end
        colIdx.groupIndex = groupIndex
        0.upto(n-1) do |index|
          colIdx.colorIndex[index] = @groups.getGroupIndex(index)
        end
      end

      def setIndexes
        numGroups = @groups.getNumGroups
        if @colIdx && @colIdx.colorSize != numGroups
          @colIdx = nil
        end
        if !@colIdx
            @colIdx =  TColorIndex.new
            @colIdx.colorSize = numGroups
        end
        0.upto(numGroups-1) do |index|
          @groups.setGroupIndex(index, colIdx.colorIndex[index])
        end

        groupIndex = colIdx.groupIndex
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

