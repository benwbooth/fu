module TVRuby::Validate
  # TValidator Status constants

  VsOk     =  0
  VsSyntax =  1       # Error in the syntax of either a TPXPictureValidator
                      # or a TDBPictureValidator

  # Validator option flags
  VoFill     =  0x0001
  VoTransfer =  0x0002
  VoReserved =  0x00FC

  # TVTransfer constants

  VtDataSize = 0
  VtSetData = 1 
  VtGetData = 2

  # Abstract TValidator object

  #
  # TValidator defines an abstract data validation object. You will never
  # actually create an instance of TValidator, but it provides much of the
  # abstract functions for the other data validation objects.
  # @see TObject
  # @see TStreamable
  # @short Implements an abstract data validation object
  # 
  class TValidator
      def initialize
      end

      #
      # This is an abstract method called by @ref validate() when it detects
      # that the user has entered invalid information. By default, error() does
      # nothing, but descendant types can override it to provide feedback to
      # the user.
      # 
      def error
      end

      #
      # If an input line has an associated validator object, it calls
      # isValidInput() after processing each keyboard event. This gives
      # validators such as filter validators an opportunity to catch errors
      # before the user fills the entire item or screen.
      # 
      # By default, isValidInput() returns True. Descendant data validators can
      # override isValidInput() to validate data as the user types it,
      # returning True if `s' holds valid data and False otherwise.
      # 
      # `s' is the current input string. `suppressFill' determines whether the
      # validator should automatically format the string before validating it.
      # 
      # If `suppressFill' is True, validation takes place on the unmodified
      # string `s'. If `suppressFill' is False, the validator should apply any
      # filling or padding before validating data.
      # 
      # Of the standard validator objects, only @ref TPXPictureValidator checks
      # `suppressFill'. Because `s' is passed by pointer, isValidInput() can
      # modify the contents of the input string, such as forcing characters to
      # uppercase or inserting literal characters from a format picture.
      # 
      # isValidInput() should not, however, delete invalid characters from the
      # string. By returning False, isValidInput() indicates that the input
      # line should erase the offending characters.
      # 
      def isValidInput(s, suppressFill)
      end

      #
      # By default, isValid() returns True. Descendant validator types can
      # override isValid() to validate data for a completed input line.
      # 
      # If an input line has an associated validator object, its
      # @ref TInputLine::valid() method calls the validator object's
      # @ref validate()
      # method, which in turn calls @ref isValid() to determine whether the
      # contents of the input line are valid.
      # 
      def isValid(s)
      end

      #
      # transfer() allows a validator to take over setting and reading the
      # values of its associated input line, which is mostly useful for
      # validators that check non-string data, such as numeric values.
      # 
      # For example, @ref TRangeValidator uses transfer() to read and write
      # long int type values to a data record, rather than transferring an
      # entire string.
      # 
      # By default, input lines with validators give the validator the first
      # chance to respond to @ref TInputLine::dataSize(),
      # @ref TInputLine::getData(), and @TInputLine::setData() by calling the
      # validator's transfer() method.
      # 
      # If transfer() returns anything other than 0, it indicates to the input
      # line that it has handled the appropriate transfer.
      # The default action of transfer() is to return 0 always. If you want the
      # validator to transfer data, you need to override its transfer() method.
      # 
      # transfer()'s first two parameters are the associated input line's text
      # string and the @ref getData() or @ref setData() data record.
      # Depending on the value of `flag', transfer() can set `s' from `buffer'
      # or read the data from `s' into `buffer'. The return value is always the
      # number of bytes transferred.
      # 
      # If `flag' is vtDataSize, transfer() doesn't change either `s' or
      # `buffer', but just returns the data size. If `flag' is vtSetData,
      # Transfer reads the appropriate number of bytes from `buffer', converts
      # them into the proper string form, and sets them into `s', returning the
      # number of bytes read.
      # 
      # If `flag' is vtGetData, transfer() converts `s' into the appropriate
      # data type and writes the value into `buffer', returning the number of
      # bytes written.
      # 
      # <pre>
      # enum TVTransfer {vtDataSize, vtSetData, vtGetData};
      # </pre>
      # 
      # Validator objects use parameters of type TVTransfer in their transfer()
      # methods to control data transfer when setting or reading the value of
      # the associated input line.
      # 
      def transfer(s, buffer, flag)
      end

      #
      # Returns True if @ref isValid(s) returns True. Otherwise calls
      # @ref error() and returns False. A validator's validate() method is
      # called by the @ref TInputLine::valid() method of its associated
      # input line.
      # 
      # Input lines with associated validator objects call the validator's
      # validate() method under two conditions: either the input line has its
      # @ref ofValidate option set, in which case it calls validate() when it
      # loses focus, or the dialog box that contains the input line calls
      # validate() for all its controls, usually because the user requested to
      # close the dialog box or accept an entry screen.
      # 
      def validate(s)
      end

      #
      # Indicates the status of the validator object. If status is vsOK, the
      # validator object constructed correctly. Any value other than vsOK
      # indicates that an error occurred.
      # 
      # Input line objects use vsOK to check that their associated validator
      # objects were constructed properly. When called with a command parameter
      # of cmValid, an input line object's @ref TInputLine::valid() method
      # checks its validator's status field.
      # 
      # If status data member is vsOK, the input line's valid() returns True,
      # indicating that the validator object is ready to use. The only value
      # defined for status other than vsOK is vsSyntax, used by
      # @ref TPXPictureValidator to indicate that it could not interpret the
      # picture string passed to it. If you create your own validator objects,
      # you can define error codes and pass them in the status field.
      # 
      # <pre>
      # Constant Value Meaning
      # 
      # vsOK     0     Validator constructed properly
      # vsSyntax 1     Error in the syntax of a picture validator's picture
      # </pre>
      # 
      attr_accessor :status

      #
      # This is a bitmapped field used to control options for various
      # descendants of TValidator. By default, TValidator constructor clears
      # all the bits in options.
      # 
      # Constants voXXXX represent the bits in the bitmapped options word in
      # validator objects.
      # 
      # <pre>
      # Constant   Value  Meaning
      # 
      # voFill     0x0001 Used by picture validators to indicate whether to fill
      #                   in literal characters as the user types
      # 
      # voTransfer 0x0002 The validator handles data transfer for the input
      #                   line; currently only used by range validators
      # 
      # voReserved 0x00fc The bits in this mask are reserved by Borland
      # </pre>
      # 
      attr_accessor :options
  end

  # TPXPictureValidator result type

  PrComplete = 0
  PrIncomplete = 1
  PrEmpty = 2
  PrError = 3
  PrSyntax = 4
  PrAmbiguous = 5
  PrIncompNoFill = 6

  # TPXPictureValidator

  #
  # Picture validator objects compare user input with a picture of a data
  # format to determine the validity of entered data. The pictures are
  # compatible with the pictures Borland's Paradox relational database uses to
  # control data entry.
  # 
  # For a complete description of picture specifiers see method
  # @ref TPXPictureValidator::picture()
  # @short Compare user input with a picture of a data format to determine the
  # validity of entered data
  # 
  class TPXPictureValidator < TValidator
      class << self; attr_accessor :errorMsg; private :errorMsg; end
  public
      #
      # Constructs a picture validator object by first calling the constructor
      # inherited from TValidator, then allocating a copy of `aPic' on the heap
      # and setting @ref pic data member to point to it, then setting the
      # voFill bit in @ref TValidator::options data member if `autoFill' is
      # True.
      # 
      def initialize(aPic, autoFill)
      end

      #
      # Displays a message box indicating an error in the picture format,
      # displaying the string pointed to by @ref pic data member.
      # 
      def error
      end

      #
      # Checks the string passed in `s' against the format picture specified in
      # @ref pic data member and returns True if @ref pic is null or
      # @ref picture() does not return prError for `s'; otherwise returns
      # False.
      # 
      # The `suppressFill' parameter overrides the value in voFill for the
      # duration of the call to isValidInput().
      # 
      # `s' is a pointer to string, so isValidInput() can modify its value. For
      # example, if `suppressFill' is False and voFill is set, the call to
      # @ref picture() returns a filled string based on `s', so the image in
      # the input line automatically reflects the format specified in pic.
      # 
      def isValidInput(s, suppressFill)
      end

      #
      # Compares the string passed in `s' with the format picture specified in
      # @ref pic data member and returns True if @ref pic is null or if
      # @ref picture() returns prComplete for `s', indicating that `s' needs
      # no further input to meet the specified format.
      # 
      def isValid(s)
      end

      #
      # Formats the string passed in `input' according to the format specified
      # by the picture string pointed to by @ref pic data member. Returns
      # prError if there is an error in the picture string or if `input'
      # contains data that cannot fit the specified picture.
      # 
      # Returns prComplete if `input' can fully satisfy the specifed picture.
      # Returns prIncomplete if `input' contains data that fits the specified
      # picture but not completely.
      # 
      # The following table shows the characters used in creating format
      # pictures.
      # 
      # <pre>
      # Type of character Character Description
      # 
      # Special           #         Accept only a digit
      #                   ?         Accept only a letter (case-insensitive)
      #                   &         Accept only a letter, force to  uppercase
      #                   @         Accept any character
      #                   !         Accept any character, force to uppercase
      # 
      # Match             ;         Take next character literally
      #                   *         Repetition count
      #                   []        Option
      #                   {}        Grouping operators
      #                   ,         Set of alternatives
      # 
      # All others                  Taken literally
      # </pre>
      # 
      # Here are some advanced pictures, which show the power of TPXPictureValidator;
      # these examples come from an old Pascal FAQ written by Berend de Boer,
      # <berend@beard.nest.nl>.
      # 
      # <pre>
      # Name           Value                Description
      # 
      # UnsignedPic1   #[#][#]*{[;,]###}    unsigned int with optional commas
      # UnsignedPic2   #[#][#]*{;,###}      unsigned int with commas
      # SignedPic1     [-]#[#][#]*{[;,]###} signed int with optional commas
      # SignedPic2     [-]#[#][#]*{;,###}   signed int with commas
      # MoneyPic1      [$]*#.{##,00}        dollars, with comma and optinal dollar sign
      # MoneyPic2      $*#{.##,.00}         dollars, with comma and dollar sign
      # DatePic1       #[#]/#[#]/##         date with 2 digit year (dd/mm/yy or mm/dd/yy)
      # DatePic2       #[#]/#[#]/##[##]     date with 2 or 4 digit year (mm/dd/yy or mm/dd/yyyy)
      # DatePic3       #[#]/#[#]/####       date with 4 digit year (mm/dd/yyyy)
      # TimePic1       {##}:{##}[:{##}]     HH:MM:SS with optional seconds
      # TimePic2       {##}:{##}:{##}       HH:MM:SS
      # PhonePic1      [(###) ]###-####     phone number with optional area code
      # PhonePic2      (###) ###-####       phone number with area code
      # SSNPic         ###-##-####
      # FirstCharUpPic *{&*? }              uppercase the first char of every word
      # FilenamePic    {&*7[&]}.{*3[&]}     filename (no path) with extension
      # </pre>
      # 
      # Note the *7 and *3 in this last example. A number after a `*' says
      # how many times the next sequence should be repeated; uncovered in
      # the manuals. But this example is not completely correct (is this a
      # bug?), because the `*' is interpreted as that there should be exactly 8
      # characters! No more, no less. Correct is:
      # 
      # <pre>
      # FilenamePic    {&[&][&][&][&][&][&][&]}.{[&][&][&]}
      # </pre>
      # 
      # The following examples were given by Sean Wenzel in the Borland Turbo Vision forum
      # on CompuServe:
      # 
      # - US Phone with optional area code: [(*3{#})]*3{#}-*4{#}
      # 
      # - Colors with autofill-in: {Red,Gr{ay,een},B{l{ack,ue},rown},White,Yellow}
      # 
      # - A date in the format "Jan, 31, 1999" with auto fill-in:
      # {J{AN ,U{N ,L }},FEB ,MA{R ,Y },A{PR ,UG },SEP ,OCT ,NOV ,DEC} {1[#],2[#],30,31,#};, 19##
      # 
      # Finally, here my solution for a real validator, for the format "1.234E-6" or "3.14159":
      # 
      # [-]#[*#][[.]#[*#]][E[-]#[#]]
      # 
      def picture(input, autoFill)
      end

      #
      # Points to a string containing the picture that specifies the format for
      # data in the associated input line. The constructor sets pic to the
      # string passed as one of its parameters.
      # 
      attr_accessor :pic
      protected :pic
  private
      def consume(ch, input)
      end

      def toGroupEnd(i, termCh)
      end

      def skipToComma(termCh)
      end

      def calcTerm(int)
      end

      def iteration( input, termCh)
      end

      def group(input, termCh)
      end

      def checkComplete(rslt, termCh)
      end

      def scan(input, termCh)
      end

      def process(input, termCh)
      end

      def syntaxCheck
      end
  end

  # TFilterValidator

  #
  # Filter validator objects check an input field as the user types into it.
  # The validator holds a set of allowed characters. If the user types one of
  # the legal characters, the filter validator indicates that the character is
  # valid.
  # 
  # If the user types any other character, the validator indicates that the
  # input is invalid.
  # @short Check an input field as the user types into it
  # 
  class TFilterValidator < TValidator
    class << self; attr_accessor :errorMsg; private :errorMsg; end
  public
      #
      # Constructs a filter validator object by first calling the constructor
      # inherited from @ref TValidator, then setting @ref validChars data
      # member to `aValidChars'.
      # 
      def initialize(aValidChars)
      end

      def error
      end

      #
      # Checks each character in the string `s' to make sure it is in the set
      # of allowed characters, @ref validChars. Returns True if all characters
      # in `s' are valid; otherwise returns False.
      # 
      def isValidInput(s, suppressFill)
      end

      #
      # Checks each character in the string `s' to make sure it is in the set
      # of allowed characters, @ref validChars. Returns True if all characters
      # in `s' are valid; otherwise returns False.
      # 
      def isValid(s)
      end

      #
      # Contains the set of all characters the user can type. For example, to
      # allow only numeric digits, set validChars to ['0'..'9']. validChars is
      # set by the `aValidChars' parameter passed to the constructor.
      # 
      attr_accessor :validChars
      protected :validChars
  end

  # TRangeValidator

  #
  # A range validator object determines whether the data typed by a user falls
  # within a designated range of integers.
  # @short Determines whether the data typed by a user falls within a
  # designated range of integers
  # 
  class TRangeValidator < TFilterValidator
    class << self
      attr_accessor :validUnsignedChars
      attr_accessor :validSignedChars
      attr_accessor :errorMsg
  public
      #
      # Constructs a range validator object by first calling the constructor
      # inherited from @ref TFilterValidator, passing a set of characters
      # containing the digits '0'..'9' and the characters '+' and '-'.
      # 
      # Sets @ref min to `aMin' and @ref max to `aMax', establishing the range
      # of acceptable long integer values.
      # 
      def initialize(aMin, aMax)
      end

      # 
      # Displays a message box indicating that the entered value did not fall
      # in the specified range.
      # 
      def error
      end

      #
      # Converts the string `s' into an integer number and returns True if the
      # result meets all three of these conditions:
      # 
      # -# it is a valid integer number
      # -# it value is greater than or equal to @ref min
      # -# it value is less than or equal to @ref max
      # 
      # If any of those tests fails, isValid() returns False.
      # 
      def isValid(s)
      end

      #
      # Incorporates the three functions @ref TInputLine::dataSize(),
      # @ref TInputLine::getData(), and @ref TInputLine::setData() that a
      # range validator can handle for its associated input line.
      # 
      # Instead of setting and reading the value of the numeric input line by
      # passing a string representation of the number, transfer() can use a
      # long int as its data record, which keeps your application from having
      # to handle the conversion.
      # 
      # `s' is the input line's string value, and `buffer' is the data record
      # passed to the input line.
      # 
      # Depending on the value of `flag', transfer either sets `s' from the
      # number in `buffer' or sets the number at `buffer' to the value of the
      # string `s'. If `flag' is vtSetData, transfer() sets `s' from `buffer'.
      # 
      # If `flag' is vtGetData, transfer() sets `buffer' from `s'. If `flag' is
      # vtDataSize, transfer() neither sets nor reads data.
      # 
      # transfer() always returns the size of the data transferred, in this
      # case the size of a long int.
      # @see TValidator::transfer
      # 
      def transfer(s, buffer, flag)
      end

      #
      # min is the lowest valid long integer value for the input line.
      # 
      attr_accessor :min
      protected :min
      #
      # max is the highest valid long integer value for the input line.
      # 
      attr_accessor :max
      protected :max
  end

  # TLookupValidator

  #
  # A lookup validator compares the string typed by a user with a list of
  # acceptable values. TLookupValidator is an abstract validator type from
  # which you can derive useful lookup validators. You will never create an
  # instance of TLookupValidator.
  # 
  # When you create a lookup validator type, you need to specify a list of
  # valid items and override the @ref lookup() method to return True only if
  # the user input matches an item in that list. One example of a working
  # descendant of TLookupValidator is @ref TStringLookupValidator.
  # @short Compares the string typed by a user with a list of acceptable values
  # 
  class TLookupValidator < TValidator
      def initialize
      end

      #
      # Calls @ref lookup() to find the string `s' in the list of valid input
      # items. Returns True if @ref lookup() returns True, meaning
      # @ref lookup() found `s' in its list; otherwise returns False.
      # 
      def isValid(s)
      end

      #
      # Searches for the string `s' in the list of valid entries and returns
      # True if it finds `s'; otherwise returns False. TLookupValidator's
      # lookup() is an abstract method that always returns False.
      # 
      # Descendant lookup validator types must override lookup() to perform a
      # search based on the actual list of acceptable items.
      # 
      def lookup(s)
      end
  end

  # TStringLookupValidator

  #
  # A string lookup validator object verifies the data in its associated input
  # line by searching through a collection of valid strings. Use string lookup
  # validators when your input line needs to accept only members of a certain
  # set of strings.
  # @short Verifies the data in its associated input line by searching through
  # a collection of valid strings
  # 
  class TStringLookupValidator < TLookupValidator
      class << self; attr_accessor :errorMsg; end

      # *
      # Constructs a string lookup validator object by first calling the
      # constructor inherited from @ref TLookupValidator, then setting
      # @ref strings data member to `aStrings'.
      # 
      def initialize(aStrings)
      end

      #
      # Displays a message box indicating that the typed string does not match
      # an entry in the string list.
      # 
      def error
      end

      #
      # Returns True if the string passed in `s' matches any of the strings in
      # strings data member. Uses the strcmp() function to determine if `s' is
      # present.
      # 
      def lookup(s)
      end

      #
      # Sets the list of valid input strings for the string lookup validator.
      # Disposes of any existing string list, then sets @ref strings data
      # member to `aStrings'.
      # 
      # Passing 0 in `aStrings' disposes of the existing list without assigning
      # a new one.
      # 
      def newStringList(aStrings)
      end
  end
end
