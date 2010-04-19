module Msgbox

  #  \fn messageBox( const char *msg, ushort aOptions )
  # Displays a message box with the given string in `msg'. `aOptions' is a
  # combination of one or more of the following message box constants:
  # 
  # <pre>
  # Constant       Value  Meaning
  # 
  # mfWarning      0x0000 Display a Warning box
  # mfError        0x0001 Display a Error box
  # mfInformation  0x0002 Display an Information Box
  # mfConfirmation 0x0003 Display a Confirmation Box
  # mfYesButton    0x0100 Put a Yes button into the dialog
  # mfNoButton     0x0200 Put a No button into the dialog
  # mfOKButton     0x0400 Put an OK button into the dialog
  # mfCancelButton 0x0800 Put a Cancel button into the dialog
  # </pre>
  # 
  # The standard "Yes, No, Cancel" dialog box is defined as:
  # 
  # <pre>
  # mfYesNoCancel = mfYesButton | mfNoButton | mfCancelButton;
  # </pre>
  # 
  # The standard "OK, Cancel" dialog box is defined as:
  # 
  # <pre>
  # mfOKCancel = mfOKButton | mfCancelButton;
  # </pre>
  # 
  def self.messageBox( msg, aOptions )
  end

  # \fn messageBox( unsigned aOptions, const char *msg, ... )
  # Displays a message box. This form uses `msg' as a format string using the
  # additional parameters that follow it. `aOptions' is set to one of the
  # message box constants defined for @ref messageBox().
  # 
  def self.messageBox(aOptions, msg, *format)
  end

  # \fn messageBoxRect( const TRect &r, const char *msg, ushort aOptions )
  # Displays a message box with the given string in `msg' in the given
  # rectangle `r'. `aOptions' is set to one of the message box constants
  # defined for @ref messageBox().
  # 
  def self.messageBoxRect( r, msg, aOptions )
  end

  # \fn messageBoxRect( const TRect &r, ushort aOptions, const char *msg, ... )
  # Displays a message box in the given rectangle `r'. This form uses `msg' as
  # a format string using the additional parameters that follow it. `aOptions'
  # is set to one of the message box constants defined for @ref messageBox().
  # 
  def self.messageBoxRect( r, aOptions, msg, *format )
  end

  # \fn inputBox( const char *Title, const char *aLabel, char *s, uchar limit )
  # Displays an input box with the given title `title' and label `aLabel'.
  # Accepts input to string `s' with a maximum of `limit' characters.
  # 
  def self.inputBox( title, aLabel, s, limit )
  end

  # \fn inputBoxRect( const TRect &bounds, const char *title, const char *aLabel, char *s, uchar limit )
  # Displays an input box with the given bounds `bounds', title `title' and
  # label `aLabel'. Accepts input to string `s' with a maximum of `limit'
  # characters.
  # 
  def self.inputBoxRect( bounds, title, aLabel, s, limit )
  end

  #  Message box classes

  MfWarning      = 0x0000       # Display a Warning box
  MfError        = 0x0001       # Display a Error box
  MfInformation  = 0x0002       # Display an Information Box
  MfConfirmation = 0x0003       # Display a Confirmation Box

  # Message box button flags

  MfYesButton    = 0x0100       # Put a Yes button into the dialog
  MfNoButton     = 0x0200       # Put a No button into the dialog
  MfOKButton     = 0x0400       # Put an OK button into the dialog
  MfCancelButton = 0x0800       # Put a Cancel button into the dialog

  MfYesNoCancel  = MfYesButton | MfNoButton | MfCancelButton
                                  # Standard Yes, No, Cancel dialog
  MfOKCancel     = MfOKButton | MfCancelButton
                                  # Standard OK, Cancel dialog

  # 
  # This class stores a set of standard strings used in message boxes.
  # 
  # If you need to change them, see file `tvtext.cc'.
  # @see messageBox
  # @short Contains a set of standard message strings
  # 
  class MsgBoxText
  public
    class << self
      #
      # Standard value is "~Y~es".
      # 
      attr_accessor :yesText

      #
      # Standard value is "~N~o".
      # 
      attr_accessor :noText

      # 
      # Standard value is "O~K~".
      # 
      attr_accessor :okText

      # 
      # Standard value is "Cancel".
      # 
      attr_accessor :cancelText

      # 
      # Standard value is "Warning".
      # 
      attr_accessor :warningText

      # 
      # Standard value is "Error".
      # 
      attr_accessor :errorText

      # 
      # Standard value is "Information".
      # 
      attr_accessor :informationText

      # 
      # Standard value is "Confirm".
      # 
      attr_accessor :confirmText
    end
  end
end

