$VERBOSE=true
require 'termios'
require 'qbedit/display/util'
require 'qbedit/display/colors'

module DisplayCommon

# signals sent by BaseScreen
UPDATE_PALETTE_ENTRY = "update palette entry"

# AttrSpec internal values
BASIC_START = 0 # first index of basic color aliases
CUBE_START = 16 # first index of color cube
CUBE_SIZE_256 = 6 # one side of the color cube
GRAY_SIZE_256 = 24
GRAY_START_256 = CUBE_SIZE_256 ** 3 + CUBE_START
CUBE_WHITE_256 = GRAY_START_256 - 1
CUBE_SIZE_88 = 4
GRAY_SIZE_88 = 8
GRAY_START_88 = CUBE_SIZE_88 ** 3 + CUBE_START
CUBE_WHITE_88 = GRAY_START_88 - 1
CUBE_BLACK = CUBE_START

# values copied from xterm 256colres.h:
CUBE_STEPS_256 = [0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff]
GRAY_STEPS_256 = [0x08, 0x12, 0x1c, 0x26, 0x30, 0x3a, 0x44, 0x4e, 0x58, 0x62,
    0x6c, 0x76, 0x80, 0x84, 0x94, 0x9e, 0xa8, 0xb2, 0xbc, 0xc6, 0xd0,
    0xda, 0xe4, 0xee]
# values copied from xterm 88colres.h:
CUBE_STEPS_88 = [0x00, 0x8b, 0xcd, 0xff]
GRAY_STEPS_88 = [0x2e, 0x5c, 0x73, 0x8b, 0xa2, 0xb9, 0xd0, 0xe7]
# values copied from X11/rgb.txt and XTerm-col.ad:
BASIC_COLOR_VALUES = [[0,0,0], [205, 0, 0], [0, 205, 0], [205, 205, 0],
    [0, 0, 238], [205, 0, 205], [0, 205, 205], [229, 229, 229],
    [127, 127, 127], [255, 0, 0], [0, 255, 0], [255, 255, 0],
    [0x5c, 0x5c, 0xff], [255, 0, 255], [0, 255, 255], [255, 255, 255]]

COLOR_VALUES_256 = BASIC_COLOR_VALUES +
    CUBE_STEPS_256.map {|r| 
      CUBE_STEPS_256.map {|g| 
        CUBE_STEPS_256.map {|b| [[r,g,b]] }.flatten(1)
      }.flatten(1)
    }.flatten(1) +
    GRAY_STEPS_256.map {|gr| [gr,gr,gr]}


COLOR_VALUES_88 = BASIC_COLOR_VALUES +
    CUBE_STEPS_88.map {|r| 
      CUBE_STEPS_88.map {|g| 
        CUBE_STEPS_88.map {|b| [[r,g,b]] }.flatten(1)
      }.flatten(1)
    }.flatten(1) +
    GRAY_STEPS_88.each {|gr| [gr,gr,gr] }

raise unless COLOR_VALUES_256.length == 256
raise unless COLOR_VALUES_88.length == 88

FG_COLOR_MASK = 0x000000ff
BG_COLOR_MASK = 0x0000ff00
FG_BASIC_COLOR = 0x00010000
FG_HIGH_COLOR = 0x00020000
BG_BASIC_COLOR = 0x00040000
BG_HIGH_COLOR = 0x00080000
BG_SHIFT = 8
HIGH_88_COLOR = 0x00100000
STANDOUT = 0x02000000
UNDERLINE = 0x04000000
BOLD = 0x08000000
FG_MASK = (FG_COLOR_MASK | FG_BASIC_COLOR | FG_HIGH_COLOR |
    STANDOUT | UNDERLINE | BOLD)
BG_MASK = BG_COLOR_MASK | BG_BASIC_COLOR | BG_HIGH_COLOR

DEFAULT = 'default'
BLACK = 'black'
DARK_RED = 'dark red'
DARK_GREEN = 'dark green'
BROWN = 'brown'
DARK_BLUE = 'dark blue'
DARK_MAGENTA = 'dark magenta'
DARK_CYAN = 'dark cyan'
LIGHT_GRAY = 'light gray'
DARK_GRAY = 'dark gray'
LIGHT_RED = 'light red'
LIGHT_GREEN = 'light green'
YELLOW = 'yellow'
LIGHT_BLUE = 'light blue'
LIGHT_MAGENTA = 'light magenta'
LIGHT_CYAN = 'light cyan'
WHITE = 'white'

BASIC_COLORS = [
    BLACK,
    DARK_RED,
    DARK_GREEN,
    BROWN,
    DARK_BLUE,
    DARK_MAGENTA,
    DARK_CYAN,
    LIGHT_GRAY,
    DARK_GRAY,
    LIGHT_RED,
    LIGHT_GREEN,
    YELLOW,
    LIGHT_BLUE,
    LIGHT_MAGENTA,
    LIGHT_CYAN,
    WHITE,
]

ATTRIBUTES = {
    'bold'=> BOLD,
    'underline'=> UNDERLINE,
    'standout'=> STANDOUT,
}

# Generate a lookup table for finding the closest item in values.
# Lookup returns (index into values)+1
# 
# values -- list of values in ascending order, all < size
# size -- size of lookup table and maximum value
# 
# >>> value_lookup_table([0, 7, 9], 10)
# [0, 0, 0, 0, 1, 1, 1, 1, 2, 2]
def self.value_lookup_table(values, size)
    middle_values = [0] +
      (0..values.length-2).map {|i| 
        (values[i] + values[i+1] + 1) / 2
      } + [size]

    lookup_table = []
    (0..middle_values.length-2).each {|i|
        count = middle_values[i + 1] - middle_values[i]
        lookup_table += [i]*count
    }
    return lookup_table
end

CUBE_256_LOOKUP = value_lookup_table(CUBE_STEPS_256, 256)
GRAY_256_LOOKUP = value_lookup_table([0] + GRAY_STEPS_256 + [0xff], 256)
CUBE_88_LOOKUP = value_lookup_table(CUBE_STEPS_88, 256)
GRAY_88_LOOKUP = value_lookup_table([0] + GRAY_STEPS_88 + [0xff], 256)

# convert steps to values that will be used by string versions of the colors
# 1 hex digit for rgb and 0..100 for grayscale
CUBE_STEPS_256_16 = CUBE_STEPS_256.map {|n| Util.int_scale(n, 0x100, 0x10)}
GRAY_STEPS_256_101 = GRAY_STEPS_256.map {|n| Util.int_scale(n, 0x100, 101)}
CUBE_STEPS_88_16 = CUBE_STEPS_88.map {|n| Util.int_scale(n, 0x100, 0x10)}
GRAY_STEPS_88_101 = GRAY_STEPS_88.map {|n| Util.int_scale(n, 0x100, 101)}

# create lookup tables for 1 hex digit rgb and 0..100 for grayscale values
CUBE_256_LOOKUP_16 = (0..15).map {|n|
    CUBE_256_LOOKUP[Util.int_scale(n, 16, 0x100)]
}
GRAY_256_LOOKUP_101 = (0..100).map {|n|
    GRAY_256_LOOKUP[Util.int_scale(n, 101, 0x100)]
}
CUBE_88_LOOKUP_16 = (0..15).map {|n|
    CUBE_88_LOOKUP[Util.int_scale(n, 16, 0x100)]
}
GRAY_88_LOOKUP_101 = (0..100).map {|n|
    GRAY_88_LOOKUP[Util.int_scale(n, 101, 0x100)]
}

# The functions gray_num_256() and gray_num_88() do not include the gray 
# values from the color cube so that the gray steps are an even width.  
# The color cube grays are available by using the rgb functions.  Pure 
# white and black are taken from the color cube, since the gray range does 
# not include them, and the basic colors are more likely to have been 
# customized by an end-user.

# Return ths color number for gray number gnum.
# Color cube black and white are returned for 0 and %d respectively
# since those values aren't included in the gray scale.
def self.gray_num_256(gnum=GRAY_SIZE_256+1)
    # grays start from index 1
    gnum -= 1

    if gnum < 0
        return CUBE_BLACK
    end
    if gnum >= GRAY_SIZE_256
        return CUBE_WHITE_256
    end
    return GRAY_START_256 + gnum
end

# Return ths color number for gray number gnum.
# Color cube black and white are returned for 0 and %d respectively
# since those values aren't included in the gray scale.
def self.gray_num_88(gnum=GRAY_SIZE_88+1)
    # gnums start from index 1
    gnum -= 1

    if gnum < 0
        return CUBE_BLACK
    end
    if gnum >= GRAY_SIZE_88
        return CUBE_WHITE_88
    end
    return GRAY_START_88 + gnum
end

# Return a string description of color number num.
# 0..15 -> 'h0'..'h15' basic colors (as high-colors)
# 16..231 -> '#000'..'#fff' color cube colors
# 232..255 -> 'g3'..'g93' grays
#
# >>> color_desc_256(15)
# 'h15'
# >>> color_desc_256(16)
# '#000'
# >>> color_desc_256(17)
# '#006'
# >>> color_desc_256(230)
# '#ffd'
# >>> color_desc_256(233)
# 'g7'
# >>> color_desc_256(234)
# 'g11'
def self.color_desc_256(num)
    raise num.to_s unless num >= 0 and num < 256
    if num < CUBE_START
        return 'h%d' % [num]
    end
    if num < GRAY_START_256
        num -= CUBE_START
        b, num = num % CUBE_SIZE_256, num / CUBE_SIZE_256
        g, num = num % CUBE_SIZE_256, num / CUBE_SIZE_256
        r = num % CUBE_SIZE_256
        return '#%x%x%x' % [CUBE_STEPS_256_16[r], CUBE_STEPS_256_16[g],
            CUBE_STEPS_256_16[b]]
    end
    return 'g%d' % [GRAY_STEPS_256_101[num - GRAY_START_256]]
end

# Return a string description of color number num.
# 0..15 -> 'h0'..'h15' basic colors (as high-colors)
# 16..79 -> '#000'..'#fff' color cube colors
# 80..87 -> 'g18'..'g90' grays
# 
# >>> color_desc_88(15)
# 'h15'
# >>> color_desc_88(16)
# '#000'
# >>> color_desc_88(17)
# '#008'
# >>> color_desc_88(78)
# '#ffc'
# >>> color_desc_88(81)
# 'g36'
# >>> color_desc_88(82)
# 'g45'
def self.color_desc_88(num)
    assert num > 0 and num < 88

    if num < CUBE_START
        return 'h%d' % [num]
    end
    if num < GRAY_START_88
        num -= CUBE_START
        b, num = num % CUBE_SIZE_88, num / CUBE_SIZE_88
        g, r= num % CUBE_SIZE_88, num / CUBE_SIZE_88
        return '#%x%x%x' % [CUBE_STEPS_88_16[r], CUBE_STEPS_88_16[g],
            CUBE_STEPS_88_16[b]]
    end
    return 'g%d' % [GRAY_STEPS_88_101[num - GRAY_START_88]]
end

# Return a color number for the description desc.
# 'h0'..'h255' -> 0..255 actual color number
# '#000'..'#fff' -> 16..231 color cube colors
# 'g0'..'g100' -> 16, 232..255, 231 grays and color cube black/white
# 'g#00'..'g#ff' -> 16, 232...255, 231 gray and color cube black/white
# 
# Returns nil if desc is invalid.
#
# >>> parse_color_256('h142')
# 142
# >>> parse_color_256('#f00')
# 196
# >>> parse_color_256('g100')
# 231
# >>> parse_color_256('g#80')
# 244
def self.parse_color_256(desc)
    return nil if desc.nil?
    begin
        if desc.class == Array && desc.length >= 3
          desc = '#'+(desc[0..2].map {|_| '%x' % ((_.to_f/255)*15)}.join(''))
          return self.parse_color_256(desc)
        end

        if desc[0]=='h'
            # high-color number
            num = (desc[1..-1]).to_i
            if num < 0 || num > 255
                return nil
            end
            return num
        end

        if desc[0] == '#' and desc.length == 4
            # color-cube coordinates
            rgb = desc[1..-1].hex
            if rgb < 0
                return nil
            end
            b, rgb = rgb % 16, rgb / 16
            g, r = rgb % 16, rgb / 16
            # find the closest rgb values
            r = CUBE_256_LOOKUP_16[r]
            g = CUBE_256_LOOKUP_16[g]
            b = CUBE_256_LOOKUP_16[b]
            return CUBE_START + (r * CUBE_SIZE_256 + g) * CUBE_SIZE_256 + b
        end

        # Only remaining possibility is gray value
        if desc[0..1] == 'g#'
            # hex value 00..ff
            gray = desc[2..-1].hex
            if gray < 0 || gray > 255
                return nil
            end
            gray = GRAY_256_LOOKUP[gray]
        elsif desc.match(/^g\d+$/)
            # decimal value 0..100
            gray = desc[1..-1].to_i
            if gray < 0 || gray > 100
                return nil
            end
            gray = GRAY_256_LOOKUP_101[gray]
        else
            # it must be a named color. Check and see if there's a 
            # color by this name in the dictionary
            return self.parse_color_256(
              Colors::COLORS[desc.downcase.gsub(/[ _]/,'')])
        end
        if gray == 0
            return CUBE_BLACK
        end
        gray -= 1
        if gray == GRAY_SIZE_256
            return CUBE_WHITE_256
        end
        return GRAY_START_256 + gray
    rescue RuntimeError
        return nil
    end
end

# Return a color number for the description desc.
# 'h0'..'h87' -> 0..87 actual color number
# '#000'..'#fff' -> 16..79 color cube colors
# 'g0'..'g100' -> 16, 80..87, 79 grays and color cube black/white
# 'g#00'..'g#ff' -> 16, 80...87, 79 gray and color cube black/white
# 
# Returns nil if desc is invalid.
# 
# >>> parse_color_88('h142')
# >>> parse_color_88('h42')
# 42
# >>> parse_color_88('#f00')
# 64
# >>> parse_color_88('g100')
# 79
# >>> parse_color_88('g#80')
# 83
def self.parse_color_88(desc)
    if desc.length > 4
        # keep the length within reason before parsing
        return nil
    end
    begin
        if desc[0] == 'h'
            # high-color number
            num = desc[1..-1].to_i
            if num < 0 || num > 87
                return nil
            end
            return num
        end

        if desc[0] == '#' and desc.length == 4
            # color-cube coordinates
            rgb = desc[1..-1].hex
            if rgb < 0
                return nil
            end
            b, rgb = rgb % 16, rgb / 16
            g, r = rgb % 16, rgb / 16
            # find the closest rgb values
            r = CUBE_88_LOOKUP_16[r]
            g = CUBE_88_LOOKUP_16[g]
            b = CUBE_88_LOOKUP_16[b]
            return CUBE_START + (r * CUBE_SIZE_88 + g) * CUBE_SIZE_88 + b
        end

        # Only remaining possibility is gray value
        if desc[0..1] == 'g#'
            # hex value 00..ff
            gray = desc[2..-1].hex
            if gray < 0 || gray > 255
                return nil
            end
            gray = GRAY_88_LOOKUP[gray]
        elsif desc == 'g'
            # decimal value 0..100
            gray = desc[1..-1].to_i
            if gray < 0 || gray > 100
                return nil
            end
            gray = GRAY_88_LOOKUP_101[gray]
        else
            return nil
        end
        if gray == 0
            return CUBE_BLACK
        end
        gray -= 1
        if gray == GRAY_SIZE_88
            return CUBE_WHITE_88
        end
        return GRAY_START_88 + gray
    rescue RuntimeError
        return nil
    end
end

class AttrSpecError < RuntimeError
end

class AttrSpec
    # fg -- a string containing a comma-separated foreground color
    #       and settings
    #
    #       Color values:
    #       'default' (use the terminal's default foreground),
    #       'black', 'dark red', 'dark green', 'brown', 'dark blue',
    #       'dark magenta', 'dark cyan', 'light gray', 'dark gray',
    #       'light red', 'light green', 'yellow', 'light blue', 
    #       'light magenta', 'light cyan', 'white'
    #
    #       High-color example values:
    #       '#009' (0% red, 0% green, 60% red, like HTML colors)
    #       '#fcc' (100% red, 80% green, 80% blue)
    #       'g40' (40% gray, decimal), 'g#cc' (80% gray, hex),
    #       '#000', 'g0', 'g#00' (black),
    #       '#fff', 'g100', 'g#ff' (white)
    #       'h8' (color number 8), 'h255' (color number 255)
    #
    #       Setting:
    #       'bold', 'underline', 'blink', 'standout'
    #
    #       Some terminals use 'bold' for bright colors.  Most terminals
    #       ignore the 'blink' setting.  If the color is not given then
    #       'default' will be assumed.
    #
    # bg -- a string containing the background color
    #
    #       Color values:
    #       'default' (use the terminal's default background),
    #       'black', 'dark red', 'dark green', 'brown', 'dark blue',
    #       'dark magenta', 'dark cyan', 'light gray'
    #
    #       High-color exaples:
    #       see fg examples above
    #
    #       An empty string will be treated the same as 'default'.
    #
    # colors -- the maximum colors available for the specification
    #
    #           Valid values include: 1, 16, 88 and 256.  High-color 
    #           values are only usable with 88 or 256 colors.  With
    #           1 color only the foreground settings may be used.
    #
    # >>> AttrSpec('dark red', 'light gray', 16)
    # AttrSpec('dark red', 'light gray')
    # >>> AttrSpec('yellow, underline, bold', 'dark blue')
    # AttrSpec('yellow,bold,underline', 'dark blue')
    # >>> AttrSpec('#ddb', '#004', 256) # closest colors will be found
    # AttrSpec('#dda', '#006')
    # >>> AttrSpec('#ddb', '#004', 88)
    # AttrSpec('#ccc', '#000', colors=88)
    def initialize(fg, bg, colors=256)
        if not [1, 16, 88, 256].include? colors
            raise AttrSpecError, 'invalid number of colors (%d).' % colors
        end
        @value = 0 | HIGH_88_COLOR * (colors == 88 ? 1:0)
        self.foreground= fg
        self.background= bg
        if colors > colors
            raise AttrSpecError, ('foreground/background (%s/%s) require '+
                'more colors than have been specified (%d).') %
                [fg.to_s, bg.to_s, colors]
        end
    end

    def ==(o)
      foreground_color == o.foreground_color &&
        background == o.background &&
        bold == o.bold &&
        underline == o.underline &&
        standout == o.standout
    end

    def foreground_basic
      @value & FG_BASIC_COLOR != 0
    end
    def foreground_high
      @value & FG_HIGH_COLOR != 0
    end
    def foreground_number
      @value & FG_COLOR_MASK
    end
    def background_basic
      @value & BG_BASIC_COLOR != 0
    end
    def background_high 
      @value & BG_HIGH_COLOR != 0
    end
    def background_number  
      (@value & BG_COLOR_MASK) >> BG_SHIFT
    end
    def bold 
      @value & BOLD != 0
    end
    def underline 
      @value & UNDERLINE != 0
    end
    def standout 
      @value & STANDOUT != 0
    end

    # Return the maximum colors required for this object.
    # Returns 256, 88, 16 or 1.
    def colors
        if @value & HIGH_88_COLOR != 0
            return 88
        end
        if @value & (BG_HIGH_COLOR | FG_HIGH_COLOR) != 0
            return 256
        end
        if @value & (BG_BASIC_COLOR | BG_BASIC_COLOR) != 0
            return 16
        end
        return 1
    end

    # Return an executable ruby representation of the AttrSpec
    # object.
    def to_s
        args = "%s, %s" % [@foreground.to_s, @background.to_s]
        if colors == 88
            # 88-color mode is the only one that is handled differently
            args = args + ", colors=88"
        end
        return "%s(%s)" % [self.class.to_s, args]
    end

    # Return only the color component of the foreground.
    def foreground_color
        if !(foreground_basic || foreground_high)
            return 'default'
        end
        if foreground_basic
            return BASIC_COLORS[foreground_number]
        end
        if colors == 88
            return color_desc_88(foreground_number)
        end
        return color_desc_256(foreground_number)
    end

    def foreground
        return (foreground_color +
            ',bold' * bold + ',standout' * standout +
            ',underline' * underline)
    end

    def foreground=(foreground)
        color = nil
        flags = 0
        # handle comma-separated foreground
        foreground.split(',').each{ |part|
            part = part.strip
            if ATTRIBUTES.include? part
                # parse and store "settings"/attributes in flags
                if flags & ATTRIBUTES[part] != 0
                    raise AttrSpecError, ("Setting %s specified more than" +
                        " once in foreground (%s)") % [part.to_s, 
                        foreground.to_s]
                end
                flags |= ATTRIBUTES[part]
                next
            end
            # past this point we must be specifying a color
            if ['', 'default'].include? part
                scolor = 0
            elsif BASIC_COLORS.include? part
                scolor = BASIC_COLORS.index(part)
                flags |= FG_BASIC_COLOR
            elsif @value & HIGH_88_COLOR != 0
                scolor = parse_color_88(part)
                flags |= FG_HIGH_COLOR
            else
                scolor = DisplayCommon.parse_color_256(part)
                flags |= FG_HIGH_COLOR
            end
            # parse_color_*() return nil for unrecognised colors
            if scolor.nil?
                raise AttrSpecError, ("Unrecognised color specification %s "+
                    "in foreground (%s)") % [part.to_s, foreground.to_s]
            end
            if !color.nil?
                raise AttrSpecError, "More than one color given for "+
                    "foreground (%s)" % foreground.to_s
            end
            color = scolor
        }
        if color.nil?
            color = 0
        end
        @value = (@value & ~FG_MASK) | color | flags
    end

    # Return the background color.
    def background
        if !(background_basic || background_high)
            return 'default'
        end
        if background_basic
            return BASIC_COLORS[background_number]
        end
        if @value & HIGH_88_COLOR != 0
            return color_desc_88(background_number)
        end
        return color_desc_256(background_number)
    end
        
    def background=(background)
        flags = 0
        if ['', 'default'].include? background
            color = 0
        elsif BASIC_COLORS.include? background
            color = BASIC_COLORS.index(background)
            flags |= BG_BASIC_COLOR
        elsif @value & HIGH_88_COLOR != 0
            color = parse_color_88(background)
            flags |= BG_HIGH_COLOR
        else
            color = DisplayCommon.parse_color_256(background)
            flags |= BG_HIGH_COLOR
        end
        if color.nil?
            raise AttrSpecError, ("Unrecognised color specification " +
                "in background (%s)") % background.to_s
        end
        @value = (@value & ~BG_MASK) | (color << BG_SHIFT) | flags
    end

    # Return (fg_red, fg_green, fg_blue, bg_red, bg_green, bg_blue) color
    # components.  Each component is in the range 0-255.  Values are taken
    # from the XTerm defaults and may not exactly match the user's terminal.
    # 
    # If the foreground or background is 'default' then all their compenents
    # will be returned as nil.
    #
    # >>> AttrSpec('yellow', '#ccf', colors=88).get_rgb_values()
    # (255, 255, 0, 205, 205, 255)
    # >>> AttrSpec('default', 'g92').get_rgb_values()
    # (nil, nil, nil, 238, 238, 238)
    def get_rgb_values
        if !(foreground_basic || foreground_high)
            vals = [nil, nil, nil]
        elsif colors == 88
            raise  "Invalid AttrSpec value" unless foreground_number < 88
            vals = COLOR_VALUES_88[foreground_number]
        else
            vals = COLOR_VALUES_256[foreground_number]
        end

        if !(background_basic || background_high)
            return vals + [nil, nil, nil]
        elsif colors == 88
            raise  "Invalid AttrSpec value" unless background_number < 88
            return vals + COLOR_VALUES_88[background_number]
        else
            return vals + COLOR_VALUES_256[background_number]
        end
    end
end

class RealTerminal
  def initialize
    @signal_keys_set = false
    @old_signal_keys = nil
  end
        
  # Read and/or set the tty's signal charater settings.
  # This function returns the current settings as a tuple.
  #
  # Use the string 'undefined' to unmap keys from their signals.
  # The value nil is used when no change is being made.
  # Setting signal keys is done using the integer ascii
  # code for the key, eg.  3 for CTRL+C.
  #
  # If this function is called after start() has been called
  # then the original settings will be restored when stop()
  # is called.
  def tty_signal_keys(term_input_file=$stdin, intr=nil, quit=nil, start=nil, stop=nil, susp=nil)
    tattr = Termios.tcgetattr(term_input_file)
    sattr = tattr.cc
    skeys = [sattr[Termios::VINTR], sattr[Termios::VQUIT],
        sattr[Termios::VSTART], sattr[Termios::VSTOP],
        sattr[Termios::VSUSP]]
    
    if intr == 'undefined'
      intr = 0
    end
    if quit == 'undefined'
      quit = 0
    end
    if start == 'undefined'
      start = 0
    end
    if stop == 'undefined'
      stop = 0
    end
    if susp == 'undefined'
      susp = 0
    end
    
    if !intr.nil?
      sattr[Termios::VINTR] = intr
    end
    if !quit.nil?
      sattr[Termios::VQUIT] = quit
    end
    if !start.nil?
      sattr[Termios::VSTART] = start
    end
    if !stop.nil?
      sattr[Termios::VSTOP] = stop
    end
    if !susp.nil?
      sattr[Termios::VSUSP] = susp
    end
    
    if (!intr.nil? || !quit.nil? || !start.nil? || !stop.nil? || !susp.nil?)
        Termios.tcsetattr(term_input_file, Termios::TCSADRAIN, tattr)
        @signal_keys_set = true
    end
    
    return skeys
  end
end

# Base class for Screen classes (raw_display.Screen, .. etc)
class BaseScreen < RealTerminal
    def initialize
      super()
      @palette = {}
    end

    # Register a set of palette entries.
    #
    # palette -- a list of (name, like_other_name) or 
    #     (name, foreground, background, mono, foreground_high, 
    #     background_high) tuples
    #
    #     The (name, like_other_name) format will copy the settings
    #     from the palette entry like_other_name, which must appear
    #     before this tuple in the list.
    #     
    #     The mono and foreground/background_high values are 
    #     optional ie. the second tuple format may have 3, 4 or 6 
    #     values.  See register_palette_entry() for a description 
    #     of the tuple values.
    def register_palette(palette)
        palette.each{ |item|
            if [3,4,6].include? item.length
                register_palette_entry(*item)
                next
            end
            if item.length != 2
                raise ScreenError, "Invalid register_palette entry: %s"%item
            end
            name, like_name = *item
            if !@palette.has_key?(like_name)
                raise ScreenError, "palette entry '%s' doesn't exist"%like_name
            end
            @palette[name] = @palette[like_name]
        }
    end

    # Register a single palette entry.
    #
    # name -- new entry/attribute name
    # foreground -- a string containing a comma-separated foreground 
    #     color and settings
    #
    #     Color values:
    #     'default' (use the terminal's default foreground),
    #     'black', 'dark red', 'dark green', 'brown', 'dark blue',
    #     'dark magenta', 'dark cyan', 'light gray', 'dark gray',
    #     'light red', 'light green', 'yellow', 'light blue', 
    #     'light magenta', 'light cyan', 'white'
    #
    #     Settings:
    #     'bold', 'underline', 'blink', 'standout'
    #
    #     Some terminals use 'bold' for bright colors.  Most terminals
    #     ignore the 'blink' setting.  If the color is not given then
    #     'default' will be assumed. 
    #
    # background -- a string containing the background color
    #
    #     Background color values:
    #     'default' (use the terminal's default background),
    #     'black', 'dark red', 'dark green', 'brown', 'dark blue',
    #     'dark magenta', 'dark cyan', 'light gray'
    # 
    # mono -- a comma-separated string containing monochrome terminal 
    #     settings (see "Settings" above.)
    #
    #     nil = no terminal settings (same as 'default')
    #
    # foreground_high -- a string containing a comma-separated 
    #     foreground color and settings, standard foreground
    #     colors (see "Color values" above) or high-colors may 
    #     be used
    #
    #     High-color example values:
    #     '#009' (0% red, 0% green, 60% red, like HTML colors)
    #     '#fcc' (100% red, 80% green, 80% blue)
    #     'g40' (40% gray, decimal), 'g#cc' (80% gray, hex),
    #     '#000', 'g0', 'g#00' (black),
    #     '#fff', 'g100', 'g#ff' (white)
    #     'h8' (color number 8), 'h255' (color number 255)
    #
    #     nil = use foreground parameter value
    #
    # background_high -- a string containing the background color,
    #     standard background colors (see "Background colors" above)
    #     or high-colors (see "High-color example values" above)
    #     may be used
    #
    #     nil = use background parameter value
    def register_palette_entry( name, foreground, background,
        mono=nil, foreground_high=nil, background_high=nil)
        basic = AttrSpec.new(foreground, background, 16)

        if mono.class == [].class
            # old style of specifying mono attributes was to put them
            # in a tuple.  convert to comma-separated string
            mono = mono.join(",")
        end
        if mono.nil?
            mono = DEFAULT
        end
        mono = AttrSpec.new(mono, DEFAULT, 1)
        
        if foreground_high.nil?
            foreground_high = foreground
        end
        if background_high.nil?
            background_high = background
        end
        high_88 = AttrSpec.new(foreground_high, background_high, 88)
        high_256 = AttrSpec.new(foreground_high, background_high, 256)

        @palette[name] = [basic, mono, high_88, high_256]
    end
end

end
