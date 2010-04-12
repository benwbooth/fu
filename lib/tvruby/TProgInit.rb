# 
# TProgInit is a virtual base class for TProgram.
# 
# The @ref TProgram constructor calls the TProgInit base constructor,
# passing to it the addresses of three initialization functions that
# create the status line, menu bar, and desk top.
# @short Virtual base class for TProgram
# 
class TProgInit
public
    # 
    # The @ref TProgram constructor calls the TProgInit constructor, passing
    # to it the addresses of three init functions. The TProgInit constructor
    # creates a status line, menu bar, and desk top. If these calls are
    # successful, the three objects are inserted into the TProgram group.
    # Variables @ref TProgram::statusLine, @ref TProgram::menuBar and
    # @ref TProgram::deskTop are set to point at these new objects.
    # 
    # The @ref TGroup constructor is also invoked to create a full screen
    # view: the video @ref TGroup::buffer and default palettes are
    # initialized and the following @ref TView::state flags are set:
    # 
    # <pre>
    # state = @ref sfVisible | @ref sfSelected | @ref sfFocused |
    #         @ref sfModal | @ref sfExposed;
    # </pre>
    # 
    def initialize( cStatusLine, cMenuBar, cDeskTop)
    end
    # 
    # Creates the status line with the given size.
    # 
    protected :createStatusLine
    # 
    # Creates the menu bar with the given size.
    # 
    protected :createMenuBar
    # 
    # Creates the desk top with the given size.
    # 
    protected :createDeskTop
end

