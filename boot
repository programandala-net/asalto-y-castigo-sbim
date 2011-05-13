30000 rem Cargador para "Asalto y castigo"
30010 rem Boot for "Asalto y castigo"

30020 rem Este programa utiliza varios comandos y funciones de las siguientes extensiones de SuperBASIC:
30030 rem This program uses several commands and functions from the following SuperBASIC extensions:

30040 rem De/From "DIY Toolkit", (C) Simon N. Goodwin:
30050 rem   minimum
30060 rem De/From "Display toolkit", (C) Dilwyn Jones:
30070 rem   flim_w,flim_h,flim_x,flim_y,dmode

30080 tk2_ext

30090 let dev$=device$("ayc_bas")
30100 lrespr dev$&"ext_display_code":print #0,"Display Toolkit"
30110 lrespr dev$&"ext_megatk_code"
30120 lrespr dev$&"ext_minmax_code":print #0,"DIY Toolkit - minmax"
30130 lrespr dev$&"ext_inarray_code":print #0,"DIY Toolkit - inarray"

30140 init_the_keyboard
30150 init_the_screen
30160 init_the_window
30170 splash_screen
30180 mrun dev$&"ayc_bas"
30190 wipe_the_window
30200 go to 100

30210 deffn device$(file$)

30220   loc dev_offset,number,devs$,dev$
30230   let dev$=""
30240   let devs$="windosflpmdv"

30250   if ftest(file$)
30260     for dev_offset=1 to len(devs$) step 3
30270       for number=1 to 8
30280         let dev$=devs$(dev_offset to dev_offset+2)&number&"_"
30290         if not ftest(dev$&file$):exit dev_offset
30300       endfor number
30310     next dev_offset
30320       let dev$=""
30330     endfor dev_offset
30340   endif

30350   ret dev$

30360 enddef

30370 defproc init_the_keyboard
30380   if ver$="HBA"
30390     if language<>34
30400       lrespr dev$&"qxl-es_kbt"
30410       kbd_table 34
30420       lang_use 34
30430     endif
30440   endif
30450 enddef

30460 defproc init_the_screen

30470   loc screen_mode
30480   let screen_mode=dmode
30490   sel on screen_mode
30500     =0:mode 8:init_ql_colours
30510     =8:init_ql_colours
30520     =remainder:init_pal_colours
30530   endsel
30540   let scr_w=flim_w(#0)
30550   let scr_h=flim_h(#0)

30560 enddef

30570 defproc init_pal_colours

30580   colour_pal
30590   let black=0
30600   let dark_cyan=7:palette_8 dark_cyan,rgb(0,139,139)
30610   let dark_green=17
30620   let light_grey=12
30630   let light_red=1:palette_8 light_red,rgb(255,51,51)
30640   let yellow=6

30650 enddef

30660 defproc init_ql_colours

30670   let black=0
30680   let dark_cyan=5
30690   let dark_green=4
30700   let light_grey=7
30710   let light_red=2
30720   let yellow=6

30730 enddef

30740 deffn rgb(red,green,blue)

30750   ret red*65535+green*256+blue

30760 enddef

30770 defproc init_the_window

30780   let csize_w=3-(scr_w=512)
30790   let csize_h=scr_w>512
30800   let tw=fopen("con_")
30810   csize #tw,csize_w,csize_h
30820   let tw_w=minimum(800,scr_w)
30830   let tw_h=minimum(600,scr_h)
30840   let tw_x=(scr_w-tw_w)/2
30850   let tw_y=(scr_h-tw_h)/2
30860   window #tw,tw_w,tw_h,tw_x,tw_y
30870   paper #tw,black
30880   ink #tw,light_grey
30890   wipe_the_window
30900   init_the_font

30910 enddef

30920 defproc wipe_the_window

30930   border #tw,0
30940   cls #tw
30950   border #tw,8

30960 enddef

30970 defproc splash_screen

30980   if flim_w(#0)=512 and flim_h(#0)=256 
30990     lbytes dev$&"img_ayc8_scr",address(#0)
31000   endif

31010 enddef

31020 defproc init_the_font

31030   loc font_size
31040   let font$=dev$&"iso8859-1_font"
31050   font_size=flen(\font$)
31060   font_address=alchp(font_size)
31070   lbytes font$,font_address
31080   iso_font

31090 enddef

31100 defproc iso_font

31110   fonts font_address

31120 enddef

31130 defproc ql_font

31140   fonts 0

31150 enddef

31160 defproc fonts(font_address)

31170   char_use #tw,font_address,0 

31180 enddef
