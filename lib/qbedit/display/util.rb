require 'qbedit/display/escape'
require 'qbedit/display/str_util'
$VERBOSE=true

module Util

# bring StrUtil functions into our namespace
include StrUtil

# Try to determine if using a supported double-byte encoding
detected_encoding = Encoding.default_external.name || ''

@@target_encoding = nil
@@use_dec_special = true

# Set the byte encoding to assume when processing strings and the
# encoding to use when converting unicode strings.
def self.set_encoding( encoding )
    encoding = encoding.downcase

    if [ 'utf-8', 'utf8', 'utf' ].include? encoding
        StrUtil.set_byte_encoding("utf8")
        @@use_dec_special = false
    elsif [ 'euc-jp', # JISX 0208 only
            'euc-kr', 'euc-cn', 'euc-tw', # CNS 11643 plain 1 only
            'gb2312', 'gbk', 'big5', 'cn-gb', 'uhc',
            # these shouldn't happen, should they?
            'eucjp', 'euckr', 'euccn', 'euctw', 'cncb' ].include? encoding
        StrUtil.set_byte_encoding("wide")
        @@use_dec_special = true
    else
        StrUtil.set_byte_encoding("narrow")
        @@use_dec_special = true
    end

    # if encoding is valid for conversion from unicode, remember it
    @@target_encoding = 'ASCII-8BIT'
    begin
        if encoding
            "".encode(encoding, 'UTF-8')
            @@target_encoding = encoding
        end
    rescue RuntimeError
    end
end

# Get the mode Urwid is using when processing text strings.
# Returns 'narrow' for 8-bit encodings, 'wide' for CJK encodings
# or 'utf8' for UTF-8 encodings.
def self.get_encoding_mode()
    return StrUtil.get_byte_encoding()
end


# Return (encoded byte string, character set rle).
def self.apply_target_encoding( s )
    if @@use_dec_special && s.class == "".class
        # first convert drawing characters
        Escape::DEC_SPECIAL_CHARS.
          zip(Escape::ALT_DEC_SPECIAL_CHARS).each {|a|
          c, alt = *a
          s = s.gsub( c, Escape::SO+alt+Escape::SI )
        }
    end
    
    if s.class == "".class
        s = s.gsub( Escape::SI+Escape::SO, "" ) # remove redundant shifts
        s = s.encode( @@target_encoding )
    end

    sis = s.split( Escape::SO )

    sis0 = sis[0].gsub( Escape::SI, "" )
    sout = []
    cout = []
    if sis0
        sout << sis0
        cout << [nil,sis0.length]
    end
    
    if sis.length==1
        return sis0, cout
    end
    
    sis[1..-1].each { |sn|
        sl = sn.split( Escape::SI, 2 ) 
        if sl.length == 1
            sin = sl[0]
            sout << sin
            rle_append_modify(cout, [Escape::DEC_TAG, sin.length])
            next
        end
        sin, son = sl
        son = son.gsub( Escape::SI, "" )
        if sin
            sout << sin
            rle_append_modify(cout, [Escape::DEC_TAG, sin.length])
        end
        if son
            sout << son
            rle_append_modify(cout, [nil, son.length])
        end
    }
    
    return sout.join(''), cout
end
    
# Try to set the encoding using the one detected by the locale module
set_encoding( detected_encoding )

# Return true if python is able to convert non-ascii unicode strings
# to the current encoding.
def self.supports_unicode()
    return @@target_encoding && @@target_encoding != 'ASCII-8BIT'
end

# Calculate the result of trimming text.
# :call-seq:
# start_offs -- offset into text to treat as screen column 0
# end_offs -- offset into text to treat as the end of the line
# start_col -- screen column to trim at the left
# end_col -- screen column to trim at the right
#
# Returns (start, end, pad_left, pad_right), where:
# start -- resulting start offset
# end -- resulting end offset
# pad_left -- 0 for no pad or 1 for one space to be added
# pad_right -- 0 for no pad or 1 for one space to be added
def self.calc_trim_text( text, start_offs, end_offs, start_col, end_col )
    l = []
    spos = start_offs
    pad_left = pad_right = 0
    if start_col > 0
        spos, sc = calc_text_pos( text, spos, end_offs, start_col )
        if sc < start_col
            pad_left = 1
            spos, sc = calc_text_pos( text, start_offs, 
                end_offs, start_col+1 )
        end
    end
    run = end_col - start_col - pad_left
    pos, sc = calc_text_pos( text, spos, end_offs, run )
    if sc < run
        pad_right = 1
    end
    return spos, pos, pad_left, pad_right
end

# Return ( trimmed text, trimmed attr, trimmed cs ).
def self.trim_text_attr_cs( text, attr, cs, start_col, end_col )
    spos, epos, pad_left, pad_right = calc_trim_text( 
        text, 0, text.length, start_col, end_col )
    attrtr = rle_subseg( attr, spos, epos )
    cstr = rle_subseg( cs, spos, epos )
    if pad_left
        al = rle_get_at( attr, spos-1 )
        rle_append_beginning_modify( attrtr, [al, 1] )
        rle_append_beginning_modify( cstr, [nil, 1] )
    end
    if pad_right
        al = rle_get_at( attr, epos )
        rle_append_modify( attrtr, [al, 1] )
        rle_append_modify( cstr, [nil, 1] )
    end
    return " "*pad_left + text[spos..epos-1] + " "*pad_right, attrtr, cstr
end
        
# Return the attribute at offset pos.
def self.rle_get_at( rle, pos )
    x = 0
    if pos < 0
        return nil
    end
    rle.each {|i|
      a, run = *i

      if x+run > pos
          return a
      end
      x += run
    }
    return nil
end

# Return a sub segment of an rle list.
def self.rle_subseg( rle, start, _end )
    l = []
    x = 0
    rle.each{ |i|
      a, run = *i

      if start
        if start >= run
          start -= run
          x += run
          next
        end
        x += start
        run -= start
        start = 0
      end
      if x >= _end
        break
      end
      if x+run > _end
        run = _end-x
      end
      x += run    
      l << [a, run]
    }
    return l
end

# Return the number of characters covered by a run length
# encoded attribute list.
def self.rle_len( rle )
    run = 0
    rle.each {|v|
        raise rle.to_s unless v.class == [].class
        a, r = *v
        run += r
    }
    return run
end

# Append (a, r) to BEGINNING of rle.
# Merge with first run when possible
#
# MODIFIES rle parameter contents. Returns nil.
def self.rle_append_beginning_modify( rle, i )
    a, r = *i
    if !rle
        rle[0..-1] = [[a, r]]
    else
        al, run = *rle[0]
        if a == al
            rle[0] = [a,run+r]
        else
            rle.insert(0, [al, r])
        end
    end
end
            
# Append (a,r) to the rle list rle.
# Merge with last run when possible.
# 
# MODIFIES rle parameter contents. Returns nil.
def self.rle_append_modify( rle, i )
    a, r = *i
    if !rle || rle[-1][0] != a
        rle << [a,r]
        return
    end
    la,lr = *rle[-1]
    rle[-1] = [a, lr+r]
end

# Append attribute list rle2 to rle.
# Merge last run of rle with first run of rle2 when possible.
#
# MODIFIES attr parameter contents. Returns nil.
def self.rle_join_modify( rle, rle2 )
    if !rle2
        return
    end
    rle_append_modify(rle, rle2[0])
    rle += rle2[1..-1]
end
        
# Merge the runs of rle1 and rle2 like this:
# eg.
# rle1 = [ ("a", 10), ("b", 5) ]
# rle2 = [ ("Q", 5), ("P", 10) ]
# rle_product: [ (("a","Q"), 5), (("a","P"), 5), (("b","P"), 5) ]
#
# rle1 and rle2 are assumed to cover the same total run.
def self.rle_product( rle1, rle2 )
    i1 = i2 = 1 # rle1, rle2 indexes
    if !rle1 || !rle2
      return []
    end
    a1, r1 = rle1[0]
    a2, r2 = rle2[0]
    
    l = []
    while r1 && r2
        r = [r1, r2].min
        rle_append_modify( l, [[a1,a2],r] )
        r1 -= r
        if r1 == 0 && i1< rle1.length
            a1, r1 = rle1[i1]
            i1 += 1
        end
        r2 -= r
        if r2 == 0 && i2< rle2.length
            a2, r2 = rle2[i2]
            i2 += 1
        end
    end
    return l    
end

# Inverse of rle_product.
def self.rle_factor( rle )
    rle1 = []
    rle2 = []
    rle.each {|i|
        j, r = *i
        a1, a2 = *j
        rle_append_modify( rle1, [a1, r] )
        rle_append_modify( rle2, [a2, r] )
    }
    return rle1, rle2
end

class TagMarkupException < RuntimeError
end

# Return (text string, attribute list) for tagmarkup passed.
def self.decompose_tagmarkup( tm )
    tl, al = tagmarkup_recurse( tm, nil )
    text = t1.join('')
    
    if al && al[-1][0].nil?
        al.delete_at(-1)
    end
        
    return text, al
end
    
# Return (text list, attribute list) for tagmarkup passed.
# 
# tm -- tagmarkup
# _attr -- current attribute or nil
def self._tagmarkup_recurse( tm, _attr )
    if tm.class == [].class
        # for lists recurse to process each subelement
        rtl = [] 
        ral = []
        tm.each{ |element|
            tl, al = tagmarkup_recurse( element, _attr )
            if ral
                # merge attributes when possible
                last_attr, last_run = *ral[-1]
                top_attr, top_run = *al[0]
                if last_attr == top_attr
                    ral[-1] = [top_attr, last_run + top_run]
                    al.delete_at(-1)
                end
            end
            rtl += tl
            ral += al
        }
        return rtl, ral
    end
        
    if tm.class == [].class
        # tuples mark a new attribute boundary
        if tm.length != 2
            raise TagMarkupException, "Tuples must be in the form (attribute, tagmarkup): %s" % tm.to_s
        end

        _attr, element = *tm
        return tagmarkup_recurse( element, _attr )
    end
    
    if ![str, unicode].include?(tm.class)
        # last ditch, try converting the object to unicode
        begin
            tm = uncode(tm)
        rescue
            raise TagMarkupException, "Invalid markup element: %s" % tm.to_s
        end
    end
    
    # text
    return [tm], [[_attr, tm.length]]
end

def self.is_mouse_event( ev )
    return ev.class == [].class && ev.length==4 && ev[0].include?("mouse")
end

def self.is_mouse_press( ev )
    return ev.include? "press"
end

# Scale val in the range [0, val_range-1] to an integer in the range 
# [0, out_range-1].  This implementaton uses the "round-half-up" rounding 
# method.
#
# >>> "%x" % int_scale(0x7, 0x10, 0x10000)
# '7777'
# >>> "%x" % int_scale(0x5f, 0x100, 0x10)
# '6'
# >>> int_scale(2, 6, 101)
# 40
# >>> int_scale(1, 3, 4)
# 2
def self.int_scale(val, val_range, out_range)
    num = (val * (out_range-1) * 2 + (val_range-1)).to_i
    dem = ((val_range-1) * 2)
    # if num % dem == 0 then we are exactly half-way and have rounded up.
    return num / dem
end

end

