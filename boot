rem Cargador para "Asalto y castigo"
rem Boot for "Asalto y castigo"

rem Este programa usa varios procedimientos y funciones de las siguientes extensiones de SuperBASIC:
rem This program uses several procedures and functions from the following SuperBASIC extensions:

rem De/From "DIY Toolkit", (C) Simon N. Goodwin:
rem   minimum
rem De/From "Display toolkit", (C) Dilwyn Jones:
rem   flim_w,flim_h,flim_x,flim_y,dmode

tk2_ext

let dev$=device$("ayc_bas")
lrespr dev$&"ext_display_code":print #0,"Display Toolkit"
lrespr dev$&"ext_megatk_code"
lrespr dev$&"ext_minmax_code":print #0,"DIY Toolkit - minmax"
let a=respr(flen(\dev$&"ext_inarray_code"))
lbytes dev$&"ext_inarray_code",a
poke a+301,0:rem forzar comparaciones exactas / force strict comparations
call a:print #0,"DIY Toolkit - inarray"

init_the_keyboard
init_the_screen
init_the_window
splash_screen
mrun dev$&"ayc_bas"
wipe_the_window
go to 100

deffn device$(file$)

  rem Devuelve el primer dispositivo en que se encuentra el fichero dado.
  rem Return the first device the given file is found in.

  loc dev_offset,number,devs$,dev$
  let dev$=""
  let devs$="windosflpmdv":rem WIN, DOS, FLP, MDV

  if ftest(file$)
    for dev_offset=1 to len(devs$) step 3
      for number=1 to 8
        let dev$=devs$(dev_offset to dev_offset+2)&number&"_"
        if not ftest(dev$&file$):exit dev_offset
      endfor number
    next dev_offset
      let dev$=""
    endfor dev_offset
  endif

  ret dev$

enddef

defproc init_the_keyboard

  rem Carga la tabla de teclado española para SMSQ si es necesario.
  rem If needed, load the Spanish SMSQ keybard table.

  loc Spanish
  let Spanish=34

  if ver$="HBA"
    if language<>Spanish
      lrespr dev$&"qxl-es_kbt"
      kbd_table Spanish
      lang_use Spanish
    endif
  endif

enddef

defproc init_the_screen

  rem Inicializa la pantalla, cambiando el modo y la modalidad de color si es necesario.
  rem Init the screen. If needed, change its mode and colour scheme.

  loc screen_mode
  let screen_mode=dmode
  sel on screen_mode
    =0:mode 8:init_ql_colours
    =8:init_ql_colours
    =remainder:init_pal_colours
  endsel
  let scr_w=flim_w(#0)
  let scr_h=flim_h(#0)

enddef

defproc init_pal_colours

  rem Fija el modo de color PAL y los colores a usar.
  rem Set the PAL colour mode and the needed colours.

  colour_pal
  let black=0
  let dark_cyan=7:palette_8 dark_cyan,rgb(0,139,139)
  let dark_green=17
  let light_grey=12
  let light_red=1:palette_8 light_red,rgb(255,51,51)
  let yellow=6

enddef

defproc init_ql_colours

  rem Fija los colores usados en el modo de color de QL.
  rem Set colours used in QL colour mode.

  let black=0
  let dark_cyan=5
  let dark_green=4
  let light_grey=7
  let light_red=2
  let yellow=6

enddef

deffn rgb(red,green,blue)

  ret red*65535+green*256+blue

enddef

defproc init_the_window

  rem Crea la ventana, hasta un máximo de 800x600.
  rem Init the window, maximum size 800x600.

  let csize_w=3-(scr_w=512)
  let csize_h=scr_w>512
  let tw=fopen("con_")
  csize #tw,csize_w,csize_h
  let tw_w=minimum(800,scr_w)
  let tw_h=minimum(600,scr_h)
  let tw_x=(scr_w-tw_w)/2
  let tw_y=(scr_h-tw_h)/2
  window #tw,tw_w,tw_h,tw_x,tw_y
  paper #tw,black
  ink #tw,light_grey
  wipe_the_window
  init_the_font

enddef

defproc wipe_the_window

  border #tw,0
  cls #tw
  border #tw,8

enddef

defproc splash_screen

  if flim_w(#0)=512 and flim_h(#0)=256 
    lbytes dev$&"img_ayc8_scr",address(#0)
  endif

enddef

defproc init_the_font

  loc font_size
  let font$=dev$&"iso8859-1_font"
  font_size=flen(\font$)
  font_address=alchp(font_size)
  lbytes font$,font_address
  iso_font

enddef

defproc iso_font

  fonts font_address

enddef

defproc ql_font

  fonts 0

enddef

defproc fonts(font_address)

  char_use #tw,font_address,0 

enddef
