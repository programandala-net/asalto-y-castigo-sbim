30000 rem Cargador para "Asalto y castigo"
30010 rem Boot for "Asalto y castigo"

30020 rem Este programa usa varios procedimientos y funciones de las siguientes extensiones de SuperBASIC:
30030 rem This program uses several procedures and functions from the following SuperBASIC extensions:

30040 rem De/From "DIY Toolkit", (C) Simon N. Goodwin:
30050 rem   minimum
30060 rem De/From "Display toolkit", (C) Dilwyn Jones:
30070 rem   flim_w,flim_h,flim_x,flim_y,dmode

30080 tk2_ext

30090 let dev$=device$("ayc_bas")
30100 lrespr dev$&"ext_display_code":print #0,"Display Toolkit"
30110 lrespr dev$&"ext_megatk_code"
30120 lrespr dev$&"ext_minmax_code":print #0,"DIY Toolkit - minmax"
30130 let a=respr(flen(\dev$&"ext_inarray_code"))
30140 lbytes dev$&"ext_inarray_code",a
30150 poke a+301,0:rem forzar comparaciones exactas / force strict comparisons
30160 call a:print #0,"DIY Toolkit - inarray"

30170 init_the_keyboard
30180 init_the_screen
30190 init_the_window
30200 splash_screen
30210 mrun dev$&"ayc_bas"
30220 wipe_the_window
30230 go to 100

30240 deffn device$(file$)

30250   rem Devuelve el primer dispositivo en que se encuentra el fichero dado.
30260   rem Return the first device the given file is found in.

30270   loc dev_offset,number,devs$,dev$
30280   let dev$=""
30290   let devs$="windosflpmdv":rem WIN, DOS, FLP, MDV

30300   if ftest(file$)
30310     for dev_offset=1 to len(devs$) step 3
30320       for number=1 to 8
30330         let dev$=devs$(dev_offset to dev_offset+2)&number&"_"
30340         if not ftest(dev$&file$):exit dev_offset
30350       endfor number
30360     next dev_offset
30370       let dev$=""
30380     endfor dev_offset
30390   endif

30400   ret dev$

30410 enddef

30420 defproc init_the_keyboard

30430   rem Carga la tabla de teclado española para SMSQ si es necesario.
30440   rem If needed, load the Spanish SMSQ keybard table.

30450   loc Spanish
30460   let Spanish=34

30470   if ver$="HBA"
30480     if language<>Spanish
30490       lrespr dev$&"qxl-es_kbt"
30500       kbd_table Spanish
30510       lang_use Spanish
30520     endif
30530   endif

30540 enddef

30550 defproc init_the_screen

30560   rem Inicializa la pantalla, cambiando el modo y la modalidad de color si es necesario.
30570   rem Init the screen. If needed, change its mode and colour scheme.

30580   loc screen_mode
30590   let screen_mode=dmode
30600   sel on screen_mode
30610     =0:mode 8:init_ql_colours
30620     =8:init_ql_colours
30630     =remainder:init_pal_colours
30640   endsel
30650   let scr_w=flim_w(#0)
30660   let scr_h=flim_h(#0)

30670 enddef

30680 defproc init_pal_colours

30690   rem Fija el modo de color PAL y los colores a usar.
30700   rem Set the PAL colour mode and the needed colours.

30710   colour_pal
30720   let black=0
30730   let dark_cyan=7:palette_8 dark_cyan,rgb(0,139,139)
30740   let dark_green=17
30750   let light_grey=12
30760   let light_red=1:palette_8 light_red,rgb(255,51,51)
30770   let yellow=6

30780 enddef

30790 defproc init_ql_colours

30800   rem Fija los colores usados en el modo de color de QL.
30810   rem Set colours used in QL colour mode.

30820   let black=0
30830   let dark_cyan=5
30840   let dark_green=4
30850   let light_grey=7
30860   let light_red=2
30870   let yellow=6

30880 enddef

30890 deffn rgb(red,green,blue)

30900   ret red*65535+green*256+blue

30910 enddef

30920 defproc init_the_window

30930   rem Crea la ventana, hasta un máximo de 800x600.
30940   rem Init the window, maximum size 800x600.

30950   let csize_w=3-(scr_w=512)
30960   let csize_h=scr_w>512
30970   let tw=fopen("con_")
30980   csize #tw,csize_w,csize_h
30990   let tw_w=minimum(800,scr_w)
31000   let tw_h=minimum(600,scr_h)
31010   let tw_x=(scr_w-tw_w)/2
31020   let tw_y=(scr_h-tw_h)/2
31030   window #tw,tw_w,tw_h,tw_x,tw_y
31040   paper #tw,black
31050   ink #tw,light_grey
31060   wipe_the_window
31070   init_the_font

31080 enddef

31090 defproc wipe_the_window

31100   border #tw,0
31110   cls #tw
31120   border #tw,8

31130 enddef

31140 defproc splash_screen

31150   if flim_w(#0)=512 and flim_h(#0)=256 
31160     lbytes dev$&"img_ayc8_scr",address(#0)
31170   endif

31180 enddef

31190 defproc init_the_font

31200   loc font_size
31210   let font$=dev$&"iso8859-1_font"
31220   font_size=flen(\font$)
31230   font_address=alchp(font_size)
31240   lbytes font$,font_address
31250   iso_font

31260 enddef

31270 defproc iso_font

31280   fonts font_address

31290 enddef

31300 defproc ql_font

31310   fonts 0

31320 enddef

31330 defproc fonts(font_address)

31340   char_use #tw,font_address,0 

31350 enddef
