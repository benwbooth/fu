# 
# TDeskInit is used as a virtual base class for a number of classes,
# providing a constructor and a create background member function used in
# creating and inserting a background object.
# @see TDeskTop
# @short Virtual base class for TDeskTop
# 
class TDeskInit
public
    # 
    # This constructor takes a function address argument, usually
    # &TDeskTop::initBackground.
    # @see TDeskTop::initBackground
    # 
    # Note: the @ref TDeskTop constructor invokes @ref TGroup constructor and
    # TDeskInit(&initBackground) to create a desk top object of size `bounds'
    # and associated background. The latter is inserted in the desk top group
    # object.
    # @see TDeskTop::TDeskTop
    # 
    def initialize(&cBackground)
    end
    # 
    # Called by the TDeskInit constructor to create a TBackground object
    # with the given bounds and return a pointer to it. A 0 pointer
    # indicates lack of success in this endeavor.
    # 
  protected :createBackground
end

