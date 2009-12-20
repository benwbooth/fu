#!/bin/bash
swig -ruby curses.i
gcc -fPIC -I/usr/include/ruby-1.9.1/x86_64-linux -I/usr/include/ruby-1.9.1 -c curses_wrap.c
gcc -shared -o curses.so curses_wrap.o
