REMark --------------------------------------------
REMark Cargador para "Asalto y castigo"
TK2_EXT
DATA_USE "flp1_"
ALTKEY "a","lrun ayc_bas"&CHR$(10):rem usado durante el desarrollo
LRESPR "ext_megatk.rext"
LRESPR "ext_display.cde":PRINT #0,"Display toolkit"
LRESPR "ext_minmax_code":PRINT #0,"DIY Toolkit - minmax"
LRESPR "ext_inarray_code":PRINT #0,"DIY Toolkit - inarray"
rem LRESPR "ext_turbo_tk.code"
if gd2(#0)
else
  if dmode<>8:mode 8
  if flim_w(#0)=512 and flim_h(#0)=256
    LBYTES img_ayc8_scr,address(#0)
  endif
endif
MRUN "ayc_bas"
GO TO 100
