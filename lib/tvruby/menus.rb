module Menus

  TSubMenu& operator + ( TSubMenu& s, TMenuItem& i );
  TSubMenu& operator + ( TSubMenu& s1, TSubMenu& s2 );
  TStatusDef& operator + ( TStatusDef& s1, TStatusItem& s2 );
  TStatusDef& operator + ( TStatusDef& s1, TStatusDef& s2 );

  # *
  # Instances of TMenuItem serve as elements of a menu.
  # 
  # They can be individual menu items that cause a command to be generated or
  # a @ref TSubMenu pull-down menu that contains other TMenuItem instances.
  # TMenuItem's different constructors set the data members appropriately.
  # TMenuItem also serves as a base class for @ref TSubMenu.
  # @short Instances of TMenuItem serve as elements of a menu
  # 
  class TMenuItem
  public
      #
      # Creates an individual menu item with the given values. Data member
      # @ref disabled is set if `aCommand' is disabled.
      # 
      def initialize(aName, aCommand, aKeyCode, aHelpCtx = HcNoContext, p, aNext)
      end

      #
      # Creates a pull-down submenu object with the given values. Data member
      # @ref command is set to zero.
      # 
      def submenu(aName, aKeyCode, aSubMenu, aHelpCtx = HcNoContext, aNext)
      end

      #
      # Appends the given TMenuItem to the list of TMenuItems by setting
      # @ref next data member to `aNext'.
      # 
      def append( aNext )
        @next = aNext
      end

      #
      # A non-zero @ref next points to the next TMenuItem object in the
      # linked list associated with a menu. If @ref next = 0, this is the
      # last item in the list.
      # 
      attr_accessor :next

      # *
      # The name of the item that appears in the menu box.
      # 
      attr_accessor :name

      #
      # The command word of the event generated when this menu item is selected
      # if there isn't a submenu item.
      # 
      attr_accessor :command

      #
      # True if the menu item is disabled. The menu item will be drawn using
      # the appropriate palette entry.
      # 
      attr_accessor :disabled

      #
      # The scan code for the associated hot key.
      # 
      attr_accessor :keyCode

      #
      # The menu item's help context. When the menu item is selected, this
      # data member represents the help context of the application, unless the
      # context number is @ref hcNoContext, in which case there is no help
      # context.
      # @see TView::getHelpCtx
      # @see TView::helpCtx
      # 
      attr_accessor :helpCtx

      #
      # @ref param is used to display the hot key associated with this menu
      # item.
      # 
      attr_accessor :param

      # 
      # @ref subMenu points to the submenu to be created when this menu
      # item is selected, if a command is not generated.
      # 
      attr_accessor :subMenu
  end

  def self.newLine
    TMenuItem.new(0, 0, 0, HcNoContext, 0, 0 )
  end

  #
  # TSubMenu is a class used to differentiate between different types of
  # @ref TMenuItem: individual menu items and submenus.
  # 
  # TVision supplies the overloaded operator + so you can easily construct
  # complete menus without dozens of nested parentheses. When you use
  # TSubMenu, the compiler can distinguish between attempts to use operator +
  # on individual menu items and their submenus.
  # @short Used to differentiate between different types of TMenuItem:
  # individual menu items and submenus
  # 
  class TSubMenu < TMenuItem
  public
      #
      # Calls constructor TMenuItem(nm, 0, key, helpCtx).
      # @see TMenuItem::TMenuItem
      # 
      def initialize(nm, key, helpCtx = HcNoContext )
      end
  end

  #
  # TMenu serves as a "wrapper" for the various other menu classes, such as
  # @ref TMenuItem, @ref TSubMenu and @ref TMenuView.
  # @short A "wrapper" for the various other menu classes, such as TMenuItem,
  # TSubMenu and TMenuView
  # 
  class TMenu
  public
      #
      # Creates a TMenu object; sets data members @ref items and @ref deflt
      # to `itemList' and `TheDefault', respectively.
      # 
      def initialize(itemList, theDefault)
          items = itemList
          deflt = theDefault
      end

      #
      # Points to the list of menu items. Used by various draw member
      # functions when parts of the menu structure need to be redrawn.
      # 
      attr_accessor :items

      #
      # Points to the default (highlighted) menu item. Determines how to react
      # when the user presses Enter.
      # 
      attr_accessor :deflt
  end

  # ---------------------------------------------------------------------- 
  #      class TMenuView                                                   
  #                                                                        
  #      Palette layout                                                    
  #        1 = Normal text                                                 
  #        2 = Disabled text                                               
  #        3 = Shortcut text                                               
  #        4 = Normal selection                                            
  #        5 = Disabled selection                                          
  #        6 = Shortcut selection                                          
  # ---------------------------------------------------------------------- 

  #
  # TMenuView provides an abstract base from which menu bar and menu box
  # classes (either pull down or pop up) are derived. You cannot instantiate a
  # TMenuView itself.
  # @short An abstract base from which menu bar and menu box classes (either
  # pull down or pop up) are derived
  # 
  class TMenuView < TView
  public
      #
      # Calls TView constructor to create a TMenuView object of size `bounds'.
      # @see TView::TView
      # 
      # 
      def initialize(bounds, aMenu=nil, aParent=nil)
        super(bounds)
        @parentMenu = aParent
        @menu = aMenu
        @current = 0
        @eventMask |= EvBroadcast
      end

      def setBounds( bounds )
      end

      #
      # Executes a menu view until the user selects a menu item or cancels the
      # process. Returns the command assigned to the selected menu item, or
      # zero if the menu was canceled.
      # 
      # Should never be called except by @ref TGroup::execView().
      # 
      def execute
      end

      #
      # Returns a pointer to the menu item that has toupper(ch) as its hot key
      # (the highlighted character). Returns 0 if no such menu item is found or
      # if the menu item is disabled. Note that findItem() is case insensitive.
      # 
      def findItem( ch )
      end

      #
      # Classes derived from TMenuView must override this member function in
      # order to respond to mouse events. Your overriding functions in derived
      # classes must return the rectangle occupied by the given menu item.
      # 
      def getItemRect( item )
      end

      #
      # By default, this member function returns the help context of the
      # current menu selection. If this is @ref hcNoContext, the parent menu's
      # current context is checked. If there is no parent menu, getHelpCtx()
      # returns @ref hcNoContext.
      # @see helpCtx
      # 
      def getHelpCtx
      end

      #
      # Returns the default palette string.
      # 
      def getPalette
      end

      #
      # Called whenever a menu event needs to be handled. Determines which menu
      # item has been mouse or keyboard selected (including hot keys) and
      # generates the appropriate command event with @ref putEvent().
      # 
      def handleEvent( event )
      end

      # 
      # Returns a pointer to the menu item associated with the hot key given
      # by `keyCode'. Returns 0 if no such menu item exists, or if the item is
      # disabled. hotKey() is used by @ref handleEvent() to determine whether a
      # keystroke event selects an item in the menu.
      # 
      def hotKey( keyCode )
      end

      def newSubView( bounds, aMenu, aParentMenu)
      end

      #
      # A pointer to the TMenuView object (or any class derived from TMenuView)
      # that owns this menu.
      # 
      attr_accessor :parentMenu
      protected :parentMenu

      # 
      # A pointer to the @ref TMenu object for this menu, which provides a
      # linked list of menu items. The menu pointer allows access to all the
      # data members of the menu items in this menu view.
      # 
      attr_accessor :menu
      protected :menu

      # 
      # A pointer to the currently selected menu item.
      # 
      attr_accessor :current
      protected :current

  private
      def nextItem
      end

      def prevItem
      end

      def trackKey( findNext )
      end

      def mouseInOwner( e )
      end

      def mouseInMenus( e )
      end

      def trackMouse( e , mouseActive)
      end

      def topMenu
      end

      def updateMenu( menu )
      end

      def do_a_select(event)
      end

      def findHotKey( p, keyCode )
      end
  end

  # ---------------------------------------------------------------------- 
  #      class TMenuBar                                                    
  #                                                                        
  #      Palette layout                                                    
  #        1 = Normal text                                                 
  #        2 = Disabled text                                               
  #        3 = Shortcut text                                               
  #        4 = Normal selection                                            
  #        5 = Disabled selection                                          
  #        6 = Shortcut selection                                          
  # ---------------------------------------------------------------------- 

  #
  # TMenuBar objects represent the horizontal menu bars from which menu
  # selections can be made by:
  # 
  # -# direct clicking
  # -# F10 selection and hot keys
  # -# selection (highlighting) and pressing Enter
  # -# hot keys
  # 
  # The main menu selections are displayed in the top menu bar. This is
  # represented by an object of type TMenuBar, usually owned by your
  # @ref TApplication object.
  # 
  # Submenus are displayed in objects of type @ref TMenuBox. Both TMenuBar
  # and @ref TMenuBox are derived from @ref TMenuView (which is in turn derived
  # from @ref TView).
  # 
  # For most TVision applications, you will not be involved directly with menu
  # objects. By overriding @ref TApplication::initMenuBar() with a suitable
  # set of nested new @ref TMenuItem and new @ref TMenu calls, TVision takes
  # care of all the standard menu mechanisms.
  # @short The horizontal menu bar from which you make menu selections
  # 
  class TMenuBar < TMenuView
  public
      #
      # Creates a menu bar by calling TMenuView::TMenuView(bounds). The
      # @ref growMode data member is set to @ref gfGrowHiX. The @ref options
      # data member is set to @ref ofPreProcess to allow hot keys to operate.
      # @see TMenuView::TMenuView
      # 
      # The @ref menu data member is set to `aMenu', providing the menu
      # selections.
      # 
      def initialize( bounds, aMenu )
      end

      #
      # Draws the menu bar with the default palette. The @ref TMenuItem::name
      # and @ref TMenuItem::disabled data members of each @ref TMenuItem
      # object in the menu linked list are read to give the menu legends in
      # the correct colors.
      # The current (selected) item is highlighted.
      # 
      def draw
      end

      #
      # Returns the rectangle occupied by the given menu item. It can be used
      # with @ref mouseInView() to determine if a mouse click has occurred on
      # a given menu selection.
      # 
      def getItemRect( item )
      end
  end

  # ---------------------------------------------------------------------- 
  #      class TMenuBox                                                    
  #                                                                        
  #      Palette layout                                                    
  #        1 = Normal text                                                 
  #        2 = Disabled text                                               
  #        3 = Shortcut text                                               
  #        4 = Normal selection                                            
  #        5 = Disabled selection                                          
  #        6 = Shortcut selection                                          
  # ---------------------------------------------------------------------- 

  # 
  # TMenuBox objects represent vertical menu boxes. Color coding is used to
  # indicate disabled items. Menu boxes can be instantiated as submenus of the
  # menu bar or other menu boxes, or can be used alone as pop-up menus.
  # @short These objects represent vertical menu boxes
  # 
  class TMenuBox < TMenuView
  public
      #
      # Creates a TMenuBox object by calling TMenuView::TMenuView(bounds). The
      # `bounds' parameter is then adjusted to accommodate the width and length
      # of the items in `aMenu'.
      # @see TMenuView::TMenuView
      # 
      # The @ref ofPreProcess bit in the @ref options data member is set so
      # that hot keys will operate. Data member @ref state is set to include
      # @ref sfShadow.
      # 
      # The @ref menu data member is set to `aMenu', which provides the menu
      # selections. Allows an explicit `aParentMenu' which is set to
      # @ref parentMenu.
      # 
      def initialize( bounds, aMenu, aParentMenu)
      end

      #
      # Draws the framed menu box and associated menu items in the default
      # colors.
      # 
      def draw
      end

      #
      # Returns the rectangle occupied by the given menu item. It can be used
      # to determine if a mouse click has occurred on a given menu selection.
      # 
      def getItemRect( item )
      end

      @frameChars
      class << self; attr_accessor :frameChars; end
  private
      def frameLine( TDrawBuffer&, n )
      end

      def drawLine( TDrawBuffer& )
      end
  end

  # ---------------------------------------------------------------------- 
  #      class TMenuPopup                                                  
  #                                                                        
  #      Palette layout                                                    
  #        1 = Normal text                                                 
  #        2 = Disabled text                                               
  #        3 = Shortcut text                                               
  #        4 = Normal selection                                            
  #        5 = Disabled selection                                          
  #        6 = Shortcut selection                                          
  # ---------------------------------------------------------------------- 

  #
  # Part of the menu system.
  # @short Part of the menu system
  # 
  class TMenuPopup < TMenuBox
      def initialize(TRect, TMenu)
      end

      def handleEvent(TEvent)
      end
  end

  # 
  # A TStatusItem object is not a view but represents a component (status item)
  # of a linked list associated with a @ref TStatusLine view.
  # 
  # TStatusItem serves two purposes: it controls the visual appearance of the
  # status line, and it defines hot keys by mapping key codes to commands.
  # @short Represents a component of a linked list associated with a
  # TStatusLine view
  # 
  class TStatusItem
  public
      # 
      # Creates a TStatusItem object with the given values.
      # 
      def initialize( aText, key, cmd, aNext = nil)
        @next = aNext
        @text = String.new(aText)
        @keyCode = key
        @command = cmd
      end

      #
      # A nonzero next points to the next TStatusItem object in the linked list
      # associated with a status line. A 0 value indicates that this is the
      # last item in the list.
      # 
      attr_accessor :next

      #
      # The text string to be displayed for this status item. If 0, no legend
      # will display, meaning that the status item is intended only to define a
      # hot key using the @ref keyCode member.
      # 
      attr_accessor :text

      #
      # This is the scan code for the associated hot key.
      # 
      attr_accessor :keyCode

      # 
      # The value of the command associated with this status item.
      # 
      attr_accessor :command
  end

  #
  # A TStatusDef object represents a status line definition used by a
  # @ref TStatusLine view to display context-sensitive status lines.
  # @short Represents a status line definition used by a TStatusLine view to
  # display context-sensitive status lines
  # 
  class TStatusDef
  public
      #
      # Creates a TStatusDef object with the given values.
      # 
      def initialize( aMin, aMax, someItems = nil, aNext = nil)
        @next = aNext
        @min = aMin
        @max = aMax
        @items = someItems
      end

      #
      # A nonzero @ref next points to the next TStatusDef object in a list of
      # status definitions. A 0 value indicates that this TStatusDef object is
      # the last such in the list.
      # 
      attr_accessor :next

      #
      # The minimum help context value for which this status definition is
      # associated. @ref TStatusLine always displays the first status item for
      # which the current help context value is within @ref min and @ref max.
      # 
      attr_accessor :min

      #
      # The maximum help context value for which this status definition is
      # associated. @ref TStatusLine always displays the first status item for
      # which the current help context value is within @ref min and @ref max.
      # 
      attr_accessor :max

      # 
      # Points to a list of status items that make up the status line. A value
      # of 0 indicates that there are no status items.
      # 
      attr_accessor :items
  end

  # ---------------------------------------------------------------------- 
  #      class TStatusLine                                                 
  #                                                                        
  #      Palette layout                                                    
  #        1 = Normal text                                                 
  #        2 = Disabled text                                               
  #        3 = Shortcut text                                               
  #        4 = Normal selection                                            
  #        5 = Disabled selection                                          
  #        6 = Shortcut selection                                          
  # ---------------------------------------------------------------------- 

  #
  # The TStatusLine object is a specialized view, usually displayed at the
  # bottom of the screen. Typical status line displays are lists of available
  # hot keys, displays of available memory, time of day, current edit modes,
  # and hints for users.
  # 
  # Status line items are @ref TStatusItem objects which contain data members
  # for a text string to be displayed on the status line, a key code to bind
  # a hot key, and a command to be generated if the displayed text is clicked
  # on with the mouse or the hot key is pressed.
  # @short A specialized view, usually displayed at the bottom of the screen
  # 
  class TStatusLine < TView
  public
      # 
      # Creates a TStatusLine object with the given bounds by calling
      # TView::TView(bounds).
      # @see TView::TView
      # 
      # The @ref ofPreProcess bit in @ref options is set, @ref eventMask is
      # set to include @ref evBroadcast, and @ref growMode is set to
      # @ref gfGrowLoY | @ref gfGrowHiX | @ref gfGrowHiY.
      # 
      # The @ref defs data member is set to `aDefs'. If `aDefs' is 0,
      # @ref items is set to 0; otherwise, @ref items is set to aDefs->items.
      # 
      def initialize( bounds, aDefs )
      end

      #
      # Draws the status line by writing the text string for each status item
      # that has one, then any hints defined for the current help context,
      # following a divider bar. Uses the appropriate palettes depending on
      # each item's status.
      # 
      def draw
      end

      # 
      # Returns the default palette string.
      # 
      def getPalette
      end

      #
      # Handles events sent to the status line by calling
      # @ref TView::handleEvent(), then checking for three kinds of special
      # events.
      # 
      # -# Mouse clicks that fall within the rectangle occupied by any status
      #    item generate a command event, with event.what set to the command in
      #    that status item.
      # -# Key events are checked against the keyCode data member in each
      #    item; a match causes a command event with that item's command.
      # -# Broadcast events with the command cmCommandSetChanged cause the
      #    status line to redraw itself to reflect any hot keys that might have
      #    been enabled or disabled.
      # 
      def handleEvent( event )
      end

      # 
      # By default, hint() returns a 0 string. Override it to provide a
      # context-sensitive hint string for the `aHelpCtx' argument. A nonzero
      # string will be drawn on the status line after a divider bar.
      # @see getHelpCtx
      # @see helpCtx
      # 
      def hint( aHelpCtx )
      end

      #
      # Updates the status line by selecting the correct items from the lists
      # in @ref defs data member, depending on the current help context.
      # 
      # Then calls @ref drawView() to redraw the status line if the items have
      # changed.
      # 
      def update
      end

      @hintSeparator
      class << self; attr_accessor :hintSeparator; end

      # 
      # A pointer to the current linked list of @ref TStatusItem records.
      # 
      attr_accessor :items
      protected :items

      # 
      # A pointer to the current linked list of @ref TStatusDef objects. The
      # list to use is determined by the current help context.
      # 
      TStatusDef *defs;
      attr_accessor :defs
      protected :defs

  private
      def drawSelect( selected )
      end

      def findItems
      end

      def itemMouseIsIn( TPoint )
      end

      def disposeItems( item )
      end
  end

end
