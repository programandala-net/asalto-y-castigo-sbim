rem This file is part of "Asalto y castigo",
rem a Spanish text adventure for Sinclair QL
rem http://programandala.net/es.programa.asalto_y_castigo.superbasic.html

rem Author: Marcos Cruz (programandala.net), 2011, 2015, 2017

' Last modified 201710022243

' ==============================================================
' Screen

window#0,scr_xlim,scr_ylim,0,0
cls#0
csize#0,3,1
close#1
close#2

' ==============================================================
' Requirements

data_use home_dir$

' From MegaToolkit, by Michael A. Crowe, 1992:
' `true`, `false`, `char_w`, `char_x`, `pos_x`, `pos_y`.

lrespr "ext_megatk_code"

' From "DIY Toolkit", by Simon N. Goodwin, 1988-1994:
' `minimum%` and `maximum%`,`inarray%`.

lrespr "ext_minmax_code"

let a=respr(flen(\"ext_inarray_code"))
lbytes "ext_inarray_code",a
poke a+301,0 ' force strict comparisons
call a

' From BMPCVT, by Wolfgang Lenerz, 2002:
' `wl_bmp3load`.

lrespr "ext_bmpcvt_code"

' From EasyPtr 4, by Albin Hessler and Marcel Kilgus, 2016:
' `l_wsa`, `wsars`, `wsain`, `wsasv`, `s_wsa`.

lrespr "ext_easyptr_code"

' From ARRAY, by Wolfgang Lenerz, 1991:
' `sar`, `saro`, `lar`.

lrespr "ext_array_code"

' ==============================================================
' Boot

lrun "ayc_bas"

' vim: filetype=sbim:textwidth=70
