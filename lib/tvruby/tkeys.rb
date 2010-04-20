module TVRuby::Tkeys

#   Control keys
# 
#   NOTE: these Control key definitions are intended only to provide
#   mnemonic names for the ASCII control codes.  They cannot be used
#   to define menu hotkeys, etc., which require scan codes.

    KbCtrlA     = 0x0001;   KbCtrlB     = 0x0002;   KbCtrlC     = 0x0003;
    KbCtrlD     = 0x0004;   KbCtrlE     = 0x0005;   KbCtrlF     = 0x0006;
    KbCtrlG     = 0x0007;   KbCtrlH     = 0x0008;   KbCtrlI     = 0x0009;
    KbCtrlJ     = 0x000a;   KbCtrlK     = 0x000b;   KbCtrlL     = 0x000c;
    KbCtrlM     = 0x000d;   KbCtrlN     = 0x000e;   KbCtrlO     = 0x000f;
    KbCtrlP     = 0x0010;   KbCtrlQ     = 0x0011;   KbCtrlR     = 0x0012;
    KbCtrlS     = 0x0013;   KbCtrlT     = 0x0014;   KbCtrlU     = 0x0015;
    KbCtrlV     = 0x0016;   KbCtrlW     = 0x0017;   KbCtrlX     = 0x0018;
    KbCtrlY     = 0x0019;   KbCtrlZ     = 0x001a;

# Extended key codes

    KbEsc       = 0x011b;   KbAltSpace  = 0x0200;   KbCtrlIns   = 0x0400;
    KbShiftIns  = 0x0500;   KbCtrlDel   = 0x0600;   KbShiftDel  = 0x0700;
    KbBack      = 0x0e08;   KbCtrlBack  = 0x0e7f;   KbShiftTab  = 0x0f00;
    KbTab       = 0x0f09;   KbAltQ      = 0x1000;   KbAltW      = 0x1100;
    KbAltE      = 0x1200;   KbAltR      = 0x1300;   KbAltT      = 0x1400;
    KbAltY      = 0x1500;   KbAltU      = 0x1600;   KbAltI      = 0x1700;
    KbAltO      = 0x1800;   KbAltP      = 0x1900;   KbCtrlEnter = 0x1c0a;
    KbEnter     = 0x1c0d;   KbAltA      = 0x1e00;   KbAltS      = 0x1f00;
    KbAltD      = 0x2000;   KbAltF      = 0x2100;   KbAltG      = 0x2200;
    KbAltH      = 0x2300;   KbAltJ      = 0x2400;   KbAltK      = 0x2500;
    KbAltL      = 0x2600;   KbAltZ      = 0x2c00;   KbAltX      = 0x2d00;
    KbAltC      = 0x2e00;   KbAltV      = 0x2f00;   KbAltB      = 0x3000;
    KbAltN      = 0x3100;   KbAltM      = 0x3200;   KbF1        = 0x3b00;
    KbF2        = 0x3c00;   KbF3        = 0x3d00;   KbF4        = 0x3e00;
    KbF5        = 0x3f00;   KbF6        = 0x4000;   KbF7        = 0x4100;
    KbF8        = 0x4200;   KbF9        = 0x4300;   KbF10       = 0x4400;
    KbHome      = 0x4700;   KbUp        = 0x4800;   KbPgUp      = 0x4900;
    KbGrayMinus = 0x4a2d;   KbLeft      = 0x4b00;   KbRight     = 0x4d00;
    KbGrayPlus  = 0x4e2b;   KbEnd       = 0x4f00;   KbDown      = 0x5000;
    KbPgDn      = 0x5100;   KbIns       = 0x5200;   KbDel       = 0x5300;
    KbShiftF1   = 0x5400;   KbShiftF2   = 0x5500;   KbShiftF3   = 0x5600;
    KbShiftF4   = 0x5700;   KbShiftF5   = 0x5800;   KbShiftF6   = 0x5900;
    KbShiftF7   = 0x5a00;   KbShiftF8   = 0x5b00;   KbShiftF9   = 0x5c00;
    KbShiftF10  = 0x5d00;   KbCtrlF1    = 0x5e00;   KbCtrlF2    = 0x5f00;
    KbCtrlF3    = 0x6000;   KbCtrlF4    = 0x6100;   KbCtrlF5    = 0x6200;
    KbCtrlF6    = 0x6300;   KbCtrlF7    = 0x6400;   KbCtrlF8    = 0x6500;
    KbCtrlF9    = 0x6600;   KbCtrlF10   = 0x6700;   KbAltF1     = 0x6800;
    KbAltF2     = 0x6900;   KbAltF3     = 0x6a00;   KbAltF4     = 0x6b00;
    KbAltF5     = 0x6c00;   KbAltF6     = 0x6d00;   KbAltF7     = 0x6e00;
    KbAltF8     = 0x6f00;   KbAltF9     = 0x7000;   KbAltF10    = 0x7100;
    KbCtrlPrtSc = 0x7200;   KbCtrlLeft  = 0x7300;   KbCtrlRight = 0x7400;
    KbCtrlEnd   = 0x7500;   KbCtrlPgDn  = 0x7600;   KbCtrlHome  = 0x7700;
    KbAlt1      = 0x7800;   KbAlt2      = 0x7900;   KbAlt3      = 0x7a00;
    KbAlt4      = 0x7b00;   KbAlt5      = 0x7c00;   KbAlt6      = 0x7d00;
    KbAlt7      = 0x7e00;   KbAlt8      = 0x7f00;   KbAlt9      = 0x8000;
    KbAlt0      = 0x8100;   KbAltMinus  = 0x8200;   KbAltEqual  = 0x8300;
    KbCtrlPgUp  = 0x8400;   KbAltBack   = 0x0800;   KbNoKey     = 0x0000;

#  Keyboard state and shift masks

    KbLeftShift   = 0x0001;
    KbRightShift  = 0x0002;
    KbShift       = KbLeftShift | KbRightShift;
    KbLeftCtrl    = 0x0004;
    KbRightCtrl   = 0x0004;
    KbCtrlShift   = KbLeftCtrl | KbRightCtrl;
    KbLeftAlt     = 0x0008;
    KbRightAlt    = 0x0008;
    KbAltShift    = KbLeftAlt | KbRightAlt;
    KbScrollState = 0x0010;
    KbNumState    = 0x0020;
    KbCapsState   = 0x0040;
    KbInsState    = 0x0080;

end
