# 
# The mother of all applications.
# 
# TApplication is a shell around @ref TProgram and differs from it mainly in
# constructor and destructor. TApplication provides the application with a
# standard menu bar, a standard desktop and a standard status line.
# 
# In any real application, you usually need to inherit TApplication and
# redefine some of its methods. For example to add custom menus you must
# redefine @ref TProgram::initMenuBar(). To add a custom status line, you
# need to redefine @ref TProgram::initStatusLine(). In the same way, to add
# a custom desktop you need to redefine @ref TProgram::initDeskTop().
# 
# TVision's subsystems (the memory, video, event, system error, and history
# list managers) are all static objects, so they are constructed before
# entering into main, and are all destroyed on exit from main.
# 
# Should you require a different sequence of subsystem initialization and
# shut down, however, you can derive your application from TProgram, and
# manually initialize and shut down the TVision subsystems along with your
# own.
# @short The mother of all applications
# 
class TApplication < TProgram
  include TScreen
protected
    # 
    # Constructor.
    # 
    # Initializes the basics of the library.
    # 
    # This creates a default TApplication object by passing the three init
    # function pointers to the @ref TProgInit constructor.
    # 
    # TApplication objects get a full-screen view,
    # @ref TProgram::initScreen() is called to set up various
    # screen-mode-dependent variables, and a screen buffer is allocated.
    # 
    # @ref initDeskTop(), @ref initStatusLine(), and @ref initMenuBar() are
    # then called to create the three basic TVision views for your
    # application. Then the desk top, status line, and menu bar objects are
    # inserted in the application group.
    # 
    # The @ref state data member is set to (@ref sfVisible | @ref sfSelected |
    # @ref sfFocused | @ref sfModal | @ref sfExposed).
    # 
    # The @ref options data member is set to zero.
    # 
    # Finally, the @ref application pointer is set (to this object) and
    # @ref initHistory() is called to initialize an associated
    # @ref THistory object.
    # 
    def initialize
    end

public
    # 
    # Stops the execution of the application.
    # 
    # Suspends the program, used usually before temporary exit.
    # In my port, by default, this function is called just after the user
    # presses Ctrl-Z to suspend the program.
    # @see TScreen::suspend
    # 
    def suspend
    end

    # 
    # Restores the execution of the application.
    # 
    # Resumes the normal program execution.
    # In my port, by default, it is called after the user recovers the
    # execution of the program with `fg'.
    # @see TScreen::resume
    # 
    def resume
    end

    # 
    # Gets the next event from the event queue.
    # 
    # Simply calls @ref TProgram::getEvent().
    # 
    def getEvent(event) 
      getEvent(event)
    end
end

