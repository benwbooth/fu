module TVRuby::Msgbox
  @buttonName = [
    TVRuby::MsgBoxText::yesText,
    TVRuby::MsgBoxText::noText,
    TVRuby::MsgBoxText::okText,
    TVRuby::MsgBoxText::cancelText
  ]

  @commands = [
    CmYes,
    CmNo,
    CmOK,
    CmCancel
  ]

  @titles = [
    TVRuby::MsgBoxText::warningText,
    TVRuby::MsgBoxText::errorText,
    TVRuby::MsgBoxText::informationText,
    TVRuby::MsgBoxText::confirmText
  ]

  class << self
    attr_accessor :buttonName
    attr_accessor :commands
    attr_accessor :titles
  end

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
    return messageBoxRect(TRect.makeRect(), msg, aOptions)
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
    buttonList = []

    dialog = TDialog.new( r, titles[aOptions & 0x3] )
    dialog.insert(
        TStaticText.new(
          TRect.new(3, 2, dialog.size.x - 2, dialog.size.y - 3), msg))

    i = 0
    x = -2
    buttonCount = 0
    while i < 4
      if (aOptions & (0x0100 << i)) != 0
        buttonList[buttonCount] =
          TButton.new(TRect.new(0, 0, 10, 2), buttonName[i], commands[i], bfNormal )
        x += buttonList[buttonCount++].size.x + 2
      end
      i += 1
    end

    x = (dialog.size.x - x) / 2

    0.upto(buttonCount-1) do |i|
      dialog.insert(buttonList[i])
      buttonList[i].moveTo(x, dialog.size.y - 3)
      x += buttonList[i].size.x + 2
    end

    dialog.selectNext(false)
    ccode = TProgram.application.execView(dialog)
    return ccode
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
    r = TRect.new(0, 0, 60, 8)
    r.move((TProgram.deskTop.size.x - r.b.x) / 2,
           (TProgram.deskTop.size.y - r.b.y) / 2)
    return inputBoxRect(r, title, aLabel, s, limit)
  end

  # \fn inputBoxRect( const TRect &bounds, const char *title, const char *aLabel, char *s, uchar limit )
  # Displays an input box with the given bounds `bounds', title `title' and
  # label `aLabel'. Accepts input to string `s' with a maximum of `limit'
  # characters.
  # 
  def self.inputBoxRect( bounds, title, aLabel, s, limit )
    dialog = TDialog.new(bounds, title)

    r = TRect.new( 4 + aLabel.length, 2, dialog.size.x - 3, 3 )
    control = TInputLine.new( r, limit )
    dialog.insert( control )

    r = TRect.new(2, 2, 3 + aLabel.length, 3)
    dialog.insert( TLabel.new( r, aLabel, control ) )

    r = TRect.new( dialog.size.x - 24, dialog.size.y - 4,
                   dialog.size.x - 14, dialog.size.y - 2)
    dialog.insert(TButton.new(r, MsgBoxText.okText, CmOK, BfDefault))

    r.a.x += 12
    r.b.x += 12
    dialog.insert( TButton.new(r, MsgBoxText.cancelText, CmCancel, BfNormal))

    r.a.x += 12
    r.b.x += 12
    dialog.selectNext(false)
    dialog.setData(s)
    c = TProgram.application.execView(dialog)
    if c != CmCancel
      dialog.getData(s)
    end
    return c
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

