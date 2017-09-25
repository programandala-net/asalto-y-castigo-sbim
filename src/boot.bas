rem This file is part of "Asalto y castigo",
rem a Spanish text adventure for Sinclair QL
rem http://programandala.net/es.programa.asalto_y_castigo.superbasic.html

rem Author: Marcos Cruz (programandala.net), 2011, 2015, 2017

' Last modified 201709251805

' ==============================================================

big_windows

' Load "MegaToolkit", (C) 1992 Michael A. Crowe:
lrespr home_dir$&"ext_megatk_code"

' Load `minimum` and `maximum` from "DIY Toolkit", (C) Simon N. Goodwin:
lrespr home_dir$&"ext_minmax_code"
print #0,"DIY Toolkit - minimum, maximum"

' Load `inarray%` from "DIY Toolkit", (C) Simon N. Goodwin:
let a=respr(flen(\home_dir$&"ext_inarray_code"))
lbytes home_dir$&"ext_inarray_code",a
poke a+301,0 ' force strict comparisons
call a
print #0,"DIY Toolkit - inarray%"

' Load "BMPCVT", (C) W. Lenerz 2002
lrespr home_dir$&"ext_bmpcvt_code"
print #0,"bmpcvt"

' Load and run the main program:
lrun home_dir$&"ayc_bas"

defproc big_windows

  mode 32
  big_window 2
  big_window 1
  big_window 0:cls#0

enddef

defproc big_window(channel%)

  window #channel%,scr_xlim,scr_ylim,0,0
  csize #channel%,3,1
  paper #channel%,0 ' black background

enddef

' vim: filetype=sbim:textwidth=70
