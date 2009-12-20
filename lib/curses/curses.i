%module curses
%{
#include <curses.h>
%}

%ignore vwprintw;
%ignore vw_printw;
%ignore vwscanw;
%ignore vw_scanw;
%include </usr/include/ncurses_dll.h>
%include </usr/include/curses.h>
