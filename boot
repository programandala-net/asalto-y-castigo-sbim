30000 rem --------------------------------------------
30010 rem Cargador para "Asalto y castigo"
30020 rem Boot file for "Assault and punishment"

30030 tk2_ext
30040 rem lrespr "flp1_ext_display.cde":print #0,"Display toolkit":stop

30050 if ver$="HBA"
30060   let dev$="dos1_sb_ayc_"
30070   rem let dev$="win2_"
30080 else
30090   let dev$="flp1_"
30100 endif
30110 data_use dev$

30120 rem altkey "a","lrun ayc_bas"&chr$(10):rem tmp!!!

30130 lrespr "ext_display_code":print #0,"Display Toolkit"
30140 lrespr "ext_megatk_code"
30150 lrespr "ext_minmax_code":print #0,"DIY Toolkit - minmax"
30160 lrespr "ext_inarray_code":print #0,"DIY Toolkit - inarray"

30170 init_the_screen
30180 init_the_window
30190 splash_screen
30200 mrun "ayc_bas"
30210 wipe_the_window
30220 go to 100

30230 defproc init_the_screen

30240   loc screen_mode:let screen_mode=dmode
30250   sel on screen_mode
30260     =0:mode 8:init_ql_colours
30270     =8:init_ql_colours
30280     =remainder:init_pal_colours
30290   endsel
30300   let scr_w=flim_w(#0)
30310   let scr_h=flim_h(#0)

30320 enddef

30330 defproc init_pal_colours

30340   colour_pal
30350   let black=0
30360   let dark_cyan=7:palette_8 dark_cyan,rgb(0,139,139)
30370   let dark_green=17
30380   let light_grey=12
30390   let light_red=1:palette_8 light_red,rgb(255,51,51)
30400   let yellow=6

30410 enddef

30420 defproc init_ql_colours

30430   let black=0
30440   let dark_cyan=5
30450   let dark_green=4
30460   let light_grey=7
30470   let light_red=2
30480   let yellow=6

30490 enddef

30500 deffn rgb(red,green,blue)

30510   ret red*65535+green*256+blue

30520 enddef

30530 defproc init_the_window

30540   let csize_w=3-(scr_w=512)
30550   let csize_h=scr_w>512
30560   let tw=fopen("con_")
30570   csize #tw,csize_w,csize_h
30580   let tw_w=minimum(800,scr_w)
30590   let tw_h=minimum(600,scr_h)
30600   let tw_x=(scr_w-tw_w)/2
30610   let tw_y=(scr_h-tw_h)/2
30620   window #tw,tw_w,tw_h,tw_x,tw_y
30630   paper #tw,black
30640   ink #tw,light_grey
30650   wipe_the_window
30660   init_the_font

30670 enddef

30680 defproc wipe_the_window

30690   border #tw,0
30700   cls #tw
30710   border #tw,8

30720 enddef

30730 defproc splash_screen

30740   if flim_w(#0)=512 and flim_h(#0)=256 
30750     lbytes img_ayc8_scr,address(#0)
30760   endif

30770 enddef

30780 defproc init_the_font

30790   loc font_size
30800   let font$=dev$&"iso_8859-1_font"
30810   font_size=flen(\font$)
30820   font_address=alchp(font_size)
30830   lbytes font$,font_address
30840   iso_font

30850 enddef

30860 defproc iso_font

30870   fonts font_address

30880 enddef

30890 defproc ql_font

30900   fonts 0

30910 enddef

30920 defproc fonts(font_address)

30930   char_use #tw,font_address,0 

30940 enddef

