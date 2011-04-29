30000 rem Cargador para "Asalto y castigo"
30010 rem Boot for "Assault and punishment"

30020 rem Este programa utiliza varios comandos y funciones de las siguientes extensiones de SuperBASIC:
30030 rem This program uses several commands and functions from the following SuperBASIC extensions:

30040 rem De/From "DIY Toolkit", (C) Simon N. Goodwin:
30050 rem   minimum
30060 rem De/From "Display toolkit", (C) Dilwyn Jones:
30070 rem   flim_w,flim_h,flim_x,flim_y,dmode

30080 tk2_ext

30090 let dev$=prog_device$
30110 lrespr dev$&"ext_megatk_code"
30120 lrespr dev$&"ext_minmax_code":print #0,"DIY Toolkit - minmax"
30130 lrespr dev$&"ext_inarray_code":print #0,"DIY Toolkit - inarray"
30140 lrespr dev$&"ext_display_code":print #0,"Display Toolkit"

30150 init_the_screen
30160 init_the_window
30170 splash_screen
30180 mrun dev$&"ayc_bas"
30190 wipe_the_window
30200 go to 100

30220 deffn prog_device$

30230   loc dev_offset,number,devs$,dev$
30240   let dev$=""
30250   let devs$="windosflpmdv"

30260   if not prog_found_in("")
30270     for dev_offset=1 to len(devs$) step 3
30280       for number=1 to 8
30290         let dev$=devs$(dev_offset to dev_offset+2)&number&"_"
30300         if prog_found_in(dev$):exit dev_offset
30310       endfor number
30320     next dev_offset
30330       let dev$=""
30340     endfor dev_offset
30350   endif

30360   ret dev$

30370 enddef

30380 deffn prog_found_in(device$)

30390   loc channel
30400   let channel=fopen(device$&"ayc_bas")
30410   if channel>0:close #channel
30420   return channel>0

30430 enddef

30440 defproc init_the_screen

30450   loc screen_mode:let screen_mode=dmode
30460   sel on screen_mode
30470     =0:mode 8:init_ql_colours
30480     =8:init_ql_colours
30490     =remainder:init_pal_colours
30500   endsel
30510   let scr_w=flim_w(#0)
30520   let scr_h=flim_h(#0)

30530 enddef

30540 defproc init_pal_colours

30550   colour_pal
30560   let black=0
30570   let dark_cyan=7:palette_8 dark_cyan,rgb(0,139,139)
30580   let dark_green=17
30590   let light_grey=12
30600   let light_red=1:palette_8 light_red,rgb(255,51,51)
30610   let yellow=6

30620 enddef

30630 defproc init_ql_colours

30640   let black=0
30650   let dark_cyan=5
30660   let dark_green=4
30670   let light_grey=7
30680   let light_red=2
30690   let yellow=6

30700 enddef

30710 deffn rgb(red,green,blue)

30720   ret red*65535+green*256+blue

30730 enddef

30740 defproc init_the_window

30750   let csize_w=3-(scr_w=512)
30760   let csize_h=scr_w>512
30770   let tw=fopen("con_")
30780   csize #tw,csize_w,csize_h
30790   let tw_w=minimum(800,scr_w)
30800   let tw_h=minimum(600,scr_h)
30810   let tw_x=(scr_w-tw_w)/2
30820   let tw_y=(scr_h-tw_h)/2
30830   window #tw,tw_w,tw_h,tw_x,tw_y
30840   paper #tw,black
30850   ink #tw,light_grey
30860   wipe_the_window
30870   init_the_font

30880 enddef

30890 defproc wipe_the_window

30900   border #tw,0
30910   cls #tw
30920   border #tw,8

30930 enddef

30940 defproc splash_screen

30950   if flim_w(#0)=512 and flim_h(#0)=256 
30960     lbytes dev$&"img_ayc8_scr",address(#0)
30970   endif

30980 enddef

30990 defproc init_the_font

31000   loc font_size
31010   let font$=dev$&"iso_8859-1_font"
31020   font_size=flen(\font$)
31030   font_address=alchp(font_size)
31040   lbytes font$,font_address
31050   iso_font

31060 enddef

31070 defproc iso_font

31080   fonts font_address

31090 enddef

31100 defproc ql_font

31110   fonts 0

31120 enddef

31130 defproc fonts(font_address)

31140   char_use #tw,font_address,0 

31150 enddef
