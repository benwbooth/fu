module TVRuby::Drawbuf
  #
  # This class implements a video buffer.
  # 
  # TDrawBuffer implements a simple, non-view buffer class with member
  # functions for moving characters, attributes, and strings to and from a draw
  # buffer.
  # 
  # Every view uses at least one istance of this class in its draw() method.
  # The view draws itself using a TDrawBuffer object. Just before returning
  # from draw(), a call to one of the writeXXXX methods will write the video
  # buffer on the screen.
  # @see TView::draw
  # 
  # Each member of the buffer is an attribute & character pair. The attribute
  # is a byte which stores information about foreground and background colors.
  # 
  # The contents of a draw buffer are typically used with
  # @ref TView::writeBuf() or @ref TView::writeLine() to display text.
  # @see TView::writeChar
  # @see TView::writeStr
  # 
  # Note: pay attention to the size of the buffer! It usually stores only a
  # line of the picture. Its default size is @ref maxViewWidth = 132 pairs.
  # @short Implements a video buffer
  # 
  class TDrawBuffer

      # ------------------------------------------------------------------------
      #                                                                         
      #   TDrawBuffer::moveChar                                                 
      #                                                                         
      #   arguments:                                                            
      #                                                                         
      #       indent  - character position within the buffer where the data     
      #                 is to go                                                
      #                                                                         
      #       c       - character to be put into the buffer                     
      #                                                                         
      #       attr    - attribute to be put into the buffer                     
      #                                                                         
      #       count   - number of character/attribute pairs to put into the     
      #                 buffer                                                  
      #                                                                         
      # ------------------------------------------------------------------------
      #
      # Fills the buffer or part of the buffer with an uniform pattern.
      # 
      # `indent' is the character position within the buffer where the data is
      # to go. `c' is the character to be put into the buffer. If `c' is 0 the
      # character is not written and the old character is preserved. `attr' is
      # the attribute to be put into the buffer. If `attr' is 0 the attribute
      # is not written and the old attribute is preserved. `count' is the
      # number of character/attribute pairs to put into the buffer.
      # 
      def moveChar( indent, c, attr, count )
        dest = indent

        if attr != 0
          while count != 0
            if c != 0
              data[dest] = (@data[dest] & 0xff00) | c
            end
            @data[dest] = (@data[dest] & 0x00ff) | ((attr & 0xff) << 8)
            count -= 1
            @dest += 1
          end
        else
          while count != 0
            data[dest] = c
            @dest += 1
            count -= 1
          end
        end
      end

      #------------------------------------------------------------------------
      #                                                                        
      #  TDrawBuffer::moveStr                                                  
      #                                                                        
      #  arguments:                                                            
      #                                                                        
      #      indent  - character position within the buffer where the data     
      #                is to go                                                
      #                                                                        
      #      str     - pointer to a 0-terminated string of characters to       
      #                be moved into the buffer                                
      #                                                                        
      #      attr    - text attribute to be put into the buffer with each      
      #                character in the string.                                
      #                                                                        
      #------------------------------------------------------------------------
      #
      # Writes a string in the buffer.
      # 
      # `indent' is the character position within the buffer where the data is
      # to go. `str' is a pointer to a 0-terminated string of characters to be
      # moved into the buffer. `attr' is the text attribute to be put into the
      # buffer with each character in the string. If `attr' is 0 the attribute
      # is not written and the old attribute is preserved. The characters in
      # `str' are set in the low bytes of each buffer word.
      # 
      def moveStr( indent, str, attrs )
        dest = indent
        c = 0

        if attr != 0
          while (c < str.length)
            @data[dest] = ((attr & 0xff) << 8) | str[c].ord
            c += 1
            dest += 1
          end
        else
          while c < str.length
            @data[dest] = str[c].ord
            dest += 1
            c += 1
          end
        end
      end

      #------------------------------------------------------------------------
      #                                                                        
      #  TDrawBuffer::moveCStr                                                 
      #                                                                        
      #  arguments:                                                            
      #                                                                        
      #      indent  - character position within the buffer where the data     
      #                is to go                                                
      #                                                                        
      #      str     - pointer to a 0-terminated string of characters to       
      #                be moved into the buffer                                
      #                                                                        
      #      attrs   - pair of text attributes to be put into the buffer       
      #                with each character in the string.  Initially the       
      #                low byte is used, and a '~' in the string toggles       
      #                between the low byte and the high byte.                 
      #                                                                        
      #------------------------------------------------------------------------
      #
      # Writes a string in the buffer.
      # 
      # `indent' is the character position within the buffer where the data is
      # to go. `str' is a pointer to a 0-terminated string of characters to be
      # moved into the buffer. `attrs' is a pair of text attributes to be put
      # into the buffer with each character in the string. Initially the low
      # byte is used, and a `~' in the string toggles between the low byte and
      # the high byte.
      # 
      def moveCStr( indent, str, attrs )
        dest = indent
        toggle=1
        curAttr = attrs & 0xff
        c = 0

        while c < str.length
          if str[c] == '~'
            if toggle == 0 
              curAttr = attrs & 0xff
            else 
              curAttr = (attrs & 0xff00) >> 8
            end
            toggle = 1-toggle
          else
            @data[dest] = (curAttr << 8) | str[c].ord
            dest+=1
          end
          c+=1
        end
      end

      # ------------------------------------------------------------------------
      #                                                                         
      #   TDrawBuffer::moveBuf                                                  
      #                                                                         
      #   arguments:                                                            
      #                                                                         
      #       indent - character position within the buffer where the data      
      #                is to go                                                 
      #                                                                         
      #       source - far pointer to an array of character/attribute pairs     
      #                                                                         
      #       attr   - attribute to be used for all characters (0 to retain     
      #                the attribute from 'source')                             
      #                                                                         
      #       count   - number of character/attribute pairs to move             
      #                                                                         
      # ------------------------------------------------------------------------
      # 
      # Writes a text buffer in this video buffer.
      # 
      # `indent' is the character position within the buffer where the data is
      # to go. `source' is a pointer to an array of characters. `attr' is the
      # attribute to be used for all characters (0 to retain the old
      # attribute). `count' is the number of characters to move.
      # 
      def moveBuf( indent, source, attr, count )
        dest = indent
        s = 0

        if attr != 0
          while count != 0
            @data[dest] = source[s].ord | ((attr & 0xff) << 8)
            count -= 1
            s += 1
            dest += 1
          end
        else
          while count != 0
            @data[dest] = source[s].ord
            count -= 1
            dest += 1
            s += 1
          end
        end
      end

      #
      # Writes an attribute.
      # 
      # `ident' is the character position within the buffer where the attribute
      # is to go. `attr' is the attribute to write.
      # 
      def putAttribute( indent, attr )
        @data[indent] = @data[indent] | ((attr << 8) & 0xFF00)
      end

      #
      # Writes a character.
      # 
      # `ident' is the character position within the buffer where the character
      # is to go. `c' is the character to write. This call inserts `c' into the
      # lower byte of the calling buffer.
      # 
      def putChar( indent, c )
        @data[indent] = @data[indent] | (c & 0xFF)
      end


      #------------------------------------------------------------------------
      #                                                                        
      #  ctrlToArrow                                                           
      #                                                                        
      #  argument:                                                             
      #                                                                        
      #      keyCode - scan code to be mapped to keypad arrow code             
      #                                                                        
      #  returns:                                                              
      #                                                                        
      #      scan code for arrow key corresponding to Wordstar key,            
      #      or original key code if no correspondence exists                  
      #                                                                        
      #------------------------------------------------------------------------
      def self.ctrlToArrow(keyCode)
        CtrlCodes = [
          KbCtrlS, KbCtrlD, KbCtrlE, KbCtrlX, KbCtrlA,
          KbCtrlF, KbCtrlG, KbCtrlV, KbCtrlR, KbCtrlC, KbCtrlH
        ]
        ArrowCodes = [
          KbLeft, KbRight, KbUp, KbDown, KbHome,
          KbEnd,  KbDel,   KbIns,KbPgUp, KbPgDn, KbBack
        ]

        0.upto(CtrlCodes.length-1) do |i|
          if keyCode & 0x00ff == CtrlCodes[i]
            return ArrowCodes[i]
          end
        end
        return keyCode
      end

      #------------------------------------------------------------------------
      #                                                                        
      #  cstrlen                                                               
      #                                                                        
      #  argument:                                                             
      #                                                                        
      #      s       - pointer to 0-terminated string                          
      #                                                                        
      #  returns                                                               
      #                                                                        
      #      length of string, ignoring '~' characters.                        
      #                                                                        
      #  Comments:                                                             
      #                                                                        
      #      Used in determining the displayed length of command strings,      
      #      which use '~' to toggle between display attributes                
      #                                                                        
      #------------------------------------------------------------------------

      def self.cstrlen( s )
        return s.gsub(/~/,'').length
      end

      #
      # Defines the array for this draw buffer.
      # 
      attr_accessor :data
      protected :data
  end
end

