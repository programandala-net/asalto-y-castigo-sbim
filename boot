32100 REMark --------------------------------------------
32110 REMark Cargador para "Asalto y castigo"
32120 TK2_EXT
32130 if ver$="HBA"
32140   win_use "flp"
32150 endif
32160 DATA_USE "flp1_"
32170 ALTKEY "a","lrun ayc_bas"&CHR$(10):rem usado durante el desarrollo
32180 LRESPR "ext_megatk.rext"
32190 LRESPR "ext_display.cde":PRINT #0,"Display toolkit"
32200 LRESPR "ext_minmax_code":PRINT #0,"DIY Toolkit - minmax"
32210 LRESPR "ext_inarray_code":PRINT #0,"DIY Toolkit - inarray"
32220 rem LRESPR "ext_turbo_tk.code"
32230 if gd2(#0)
32240 else
32250   if dmode<>8:mode 8
32260   if flim_w(#0)=512 and flim_h(#0)=256
32270     LBYTES img_ayc8_scr,address(#0)
32280   endif
32290 endif
32300 MRUN "ayc_bas"
32310 GO TO 100
