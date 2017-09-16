rem This file is part of "Asalto y castigo",
rem a Spanish text adventure for Sinclair QL
rem http://programandala.net/es.programa.asalto_y_castigo.superbasic.html

let version$="0.2.0-dev.37+201709170054" ' after http://semver.org

rem Copyright (C) 2011,2015,2017 Marcos Cruz (programandala.net)
rem License: http://programandala.net/license

' ==============================================================
' Credits

rem Original version
rem written in Sinclar BASIC (Sinclair ZX Spectrum),
rem Locomotive BASIC (Amstrad CPC) and Blassic:

rem Copyright (C) 2009 Baltasar el Arquero
rem http://caad.es/baltasarq/

rem The photo of the splash screen was extracted from the cassette
rem inlay designed by Neil Parsons for the original ZX Spectrum
rem version.

' ==============================================================
' Requirements

' From "MegaToolkit", (C) 1992 Michael A. Crowe:
'   true, false, char_w, char_x, pos_x, pos_y

' From "DIY Toolkit", (C) Simon N. Goodwin:
'   minimum, maximum, inarray%

' From "BMPCVT", (C) W. Lenerz 2002:
'   wl_bmp8load

' ==============================================================
' Main

main

defproc main

  first_time_init
  rep game
    about
    game_init
    end_of_scene
    intro
    do_look_around
    rep your_turn
      plot
      command
      if start_over%:\
        exit your_turn
    endrep your_turn
  endrep game

enddef

' ==============================================================
' Plot

defproc plot

  ' Check the plot conditions.

  sel on true

    =(current_location%=cave_entrance_loc% \
      and way_out%(cave_entrance_loc%,north%))

      ambush

    =under_attack%<>0

      battle

    =(current_location%=cave_strait_1_loc% \
      and (not is_accessible%(the_torch%) \
      or not lit_the_torch%))

      ' XXX TODO -- Why `>channel_sand_corner_loc%` in the
      ' original?  I put `=cave_strait_1_loc%`, which is the exit
      ' from `stalactites_loc%`
      '
      ' XXX TODO -2 Check if `stalactites_loc%` can be accessed
      ' from other exit. If so, the previous location should be
      ' checked here.

      dark_cave_strait_1

    =(current_location%=westmorland_loc%) ' XXX TODO move to `location_plot`?
      arrive_in_westmorland

  endsel

enddef

defproc ambush

  let way_out%(cave_entrance_loc%,north%)=nowhere%
  let under_attack%=1
  narrate "Una partida sajona aparece por el este. \
    Para cuando te vuelves al norte, ya no te queda ninguna duda: \
    era una trampa."
  short_pause
  narrate "En el estrecho paso es posible resistir, \
    aunque por desgracia sus tropas \
    son más numerosas que las tuyas."
  end_of_scene:\
  clear_screen
  narrate "Tus oficiales te conminan a huir."
  speak "Capturando a un general britano, ganan doblemente."
  narrate "Sabes que es cierto, y te duele."

enddef

defproc battle

  let under_attack%=under_attack%+1
  narrate "No sabes cuánto tiempo te queda..."
  if under_attack%>10 ' XXX TODO random
    captured
  endif
  if current_location%<cave_hall_loc% ' XXX TODO `=` is enough?
    narrate "Tus hombres luchan con denuedo contra los sajones."
  endif

enddef

defproc captured

  narrate "Los sajones te capturan. \
    Su general, sonriendo ampliamente, dice:"
  speak "Bien, bien... \
    Del gran Ulfius podremos sacar una buena ventaja."
  end_of_scene:\
  clear_screen
  do_end

enddef

defproc dark_cave_strait_1

  narrate "Ante la reinante e intimidante oscuridad, \
    retrocedes a donde puedes ver."
  short_pause
  enter stalactites_loc%

enddef

defproc arrive_in_westmorland

  narrate "Agotado, das parte en el castillo de tu llegada \
    y de lo que ha pasado."
  short_pause
  narrate "Pides audiencia al rey, Uther Pendragon."
  end_of_scene:\
  clear_screen
  speak "El rey"&r_quote$&", te indica el valido, "&l_quote$&\
    "ha ordenado que no se le moleste, \
    pues sufre una amarga tristeza."
  short_pause
  narrate "No puedes entenderlo. El rey, tu amigo."
  short_pause
  narrate "Agotado, decepcionado, apesadumbrado, \
    decides ir a dormir a tu casa. \
    Es lo poco que puedes hacer."
  short_pause
  narrate "Te has ganado un buen descanso."
  end_of_scene
  clear_screen
  do_end ' XXX TODO happy end instead

enddef

defproc location_plot

  ' Check the plot conditions related to the new location.

  sel on current_location%
    =big_lake_loc%,big_waterfall_loc%,inner_lake_loc%
      be_here the_lake%
    =saxon_village_loc% to fallen_away_loc%
      if way_out%(cave_entrance_loc%,north%):\
        narrate "Tus hombres siguen tus pasos."
    =water_passage_loc%
      narrate "En la distancia, \
        por entre los resquicios de las rocas, \
        y allende el canal de agua, \
        los sajones tratan de buscar la salida \
        que encontraste por casualidad."
    =north_gate_loc%
      if way_out%(north_gate_loc%,north%)
        narrate "Las rocas yacen desmoronadas a lo largo del pasaje."
      else
        narrate "Las rocas bloquean el camino."
      endif
    =refuge_loc%
      let way_out%(refuge_loc%,east%)=nowhere%
  endsel

  if not is_vanished%(ambrosio%) \
    and is_takeable%(the_key%) \
    and (current_location%=ambrosios_home_loc% or ambrosio_follows%)
    be_here ambrosio%
    narrate "Tu benefactor te sigue, esperanzado."
  endif

enddef

defproc rocks_and_log

  ' Action using the log with rocks.

  if hacked_the_log%
    narrate "Haciendo palanca, consigues desencajar una, \
      y el resto caen por su propio peso."
    vanish the_rocks%
    let way_out%(north_gate_loc%,north%)=precipice_loc%
  else
    narrate "Lo intentas con el tronco, \
      pero la punta es demasiado gruesa, \
      y no penetra entre los resquicios de las rocas."
  endif

enddef

defproc open_the_door

  ' Action opening the door.

  narrate "La puerta se abre, rechinando, \
    mientras hiedras y hierbas se rompen en su trazado."
  short_pause
  narrate "Ambrosio, alegre, se despide de ti."
  speak "Estoy seguro de que volveremos a vernos"&r_quote$&", dice."
  narrate "Se ha ido."
  vanish ambrosio%
  vanish the_key%
  let description$(the_door%)="Entreabierta."
  let description$(the_lock%)="Abierto."
  let way_out%(cave_exit_loc%,west%)=cave_exit_forest_loc%

enddef

' ==============================================================
' Parser

defproc command

  ' Accept a command, analize it and execute it.

  loc next_space%,command$

  let action%=nothing%
  let object%=nothing%
  let complement%=nothing%
  let command$=accept$

  rep find_word
    let next_space%=" " instr command$
    parse_word command$(1 to next_space%-1)
    if next_space%=len(command$):\
      exit find_word
    let command$=command$(next_space%+1 to)
  endrep find_word

  if fine_command:\
    do_action action%

enddef

defproc parse_word(word$)

  ' Analize the given word.

  if not action%
    let action%=parse_verb%(word$)
  else
    if not object%
      let object%=parse_noun%(word$)
    else
      if not complement%:\
        complement%=parse_noun%(word$)
    endif
  endif

enddef

deffn parse_verb%(word$)

  ' Analize the given word; it's supposed to be a verb.

  loc found%
  let found%=inarray%(verb$,0,word$)
  if found%<0:\
    ret 0
  ret verb_action(found%)

enddef

deffn parse_noun%(word$)

  ' Analize the given word; it's supposed to be a noun.

  loc found%
  let found%=inarray%(noun$,0,word$)
  if found%<0:\
    ret 0
  ret entity_of_noun%(found%)

enddef

deffn fine_command

  ' Check if the command is right: check its parts and the
  ' accesibility of the object and the complement, if present.
  ' Return `true` if it's right, or `false` otherwise.

  if action%

    sel on syntax%(action%)
      =object_needed%
        if not object%:\
          narrate not_understood$:\
          ret false
      =object_and_complement_needed%
        if (not object% or not complement%):\
          narrate not_understood$:\
          ret false
    endsel

    if object%:\
      if not is_accessible%(object%):\
         narrate not_seen$:\
         ret false

    if complement%:\
      if not is_accessible%(complement%):\
        narrate not_seen$:\
        ret false

  else

    narrate not_understood$:\
    ret false
    
  endif 

  ret true

enddef

' ==============================================================
' Actions

defproc do_action(action%)

  sel on action%
    =to_break%:do_break
    =to_drop%:do_drop
    =to_examine%:do_examine
    =to_finish%:do_end
    =to_fling%:do_fling
    =to_go_down%:do_move down%
    =to_go_east%:do_move east%
    =to_go_north%:do_move north%
    =to_go_south%:do_move south%
    =to_go_up%:do_move up%
    =to_go_west%:do_move west%
    =to_help%:do_help
    =to_insert%:do_insert
    =to_inventory%:do_inventory
    =to_look%:do_look
    =to_open%:do_open
    =to_sharpen%:do_sharpen
    =to_speak%:do_speak
    =to_swim%:do_swim
    =to_take%:do_take
    =remainder:narrate not_understood$
  endsel

enddef

defproc do_help

  narrate "Direcciones: \
    n[orte], s[ur], e[ste], o[este], a[rriba] y [a]b[ajo]."
  narrate "m[irar] redescribe un lugar, \
    ex[aminar] permite examinar un objeto, \
    o en su defecto a ti."
  narrate "Se puede cortar, \
    nadar, atacar, empujar, golpear, coger, dejar, tirar..."
  narrate "Se aceptan formas verbales en infinitivo e imperativo; \
    y diversos sinónimos tanto de verbos como de nombres."
  narrate "El atajo de teclado Ctrl+B \
    (des)activa el bip de error de tecleo."

enddef

defproc do_examine

  if object%
    do_examine_object
  else
    do_look_around
  endif

enddef

defproc do_examine_object

  if is_accessible%(object%)
    narrate description$(object%)
  else
    narrate not_seen$
  endif

enddef

defproc do_end

  if yes%("¿Quieres volver a intentarlo?")
    let start_over%=true
  else
    clear_screen:\
    stop
  endif

enddef

defproc do_swim

  if current_location%=big_lake_loc%
    clear_screen
    narrate "Caes hacia el fondo por el peso de tu coraza. \
      Como puedes, te desprendes de ella y buceas, \
      pensando en avanzar, aunque perdido."
    short_pause
    narrate "Consigues emerger, \
      si bien en un sitio desconocido de la caverna..."
    end_of_scene
    enter secret_exit_loc%
    let under_attack%=false
  else
    narrate "No tiene sentido nadar ahora."
  endif

enddef

defproc do_open

  if current_location%=cave_exit_loc%
    if object%=the_door% or object%=the_lock%
      if is_accessible%(the_key%)
        open_the_door
      else
        narrate "El candado bloquea la puerta."
      endif
    else
      narrate "No tiene sentido abrir eso."
    endif
  else
    narrate "No hay nada que abrir ahora."
  endif

enddef

defproc do_drop

  ' XXX TODO -- Remove these cases:
  sel on object%
    =the_sword%:\
      if current_location%<secret_exit_loc%:\
        narrate "No, es lo que queda de mi padre.":\
        ret
    =the_torch%:\
      if lit_the_torch%:\
        narrate "No, sin luz es imposible moverse por la caverna.":\
        ret
  endsel

  if is_hold%(object%)
    be_here object%
    narrate "Hecho."
  else
    narrate i_dont_have_it$
  endif

enddef

defproc do_take

  if is_hold%(object%)
    narrate "Pero si ya lo tengo..."
  else
    if is_untakeable%(object%)
      if object%=the_key%
        narrate "Ambrosio la retiene consigo."
      else
        narrate "No es algo que uno pueda llevar consigo."
      endif
    else
      be_hold object%:\
      narrate "Hecho."
    endif
  endif

enddef

defproc do_break

  sel on object%

    =the_log%:\
      do_break_the_log

    =the_cloak%:\
      do_break_the_cloack

    =the_rocks%:\
      do_break_the_rocks

    =the_flint%

      ' XXX TODO move to the proper action

      sel on complement%
        =nothing%:\
          narrate not_by_hand$
        =the_sword%
          if is_accessible%(the_torch%)
            let lit_the_torch%=true
            let description$(the_torch%)=\
              "Ilumina perfectamente."
            narrate "Poderosas chispas salen \
              del choque entre espada y pedernal, \
              encendiendo la antorcha."
          else
            narrate "Ante el potente choque con la espada, \
              poderosas chispas saltan en todas direcciones."
          endif
        =remainder:\
          narrate not_with_that$
      endsel

    =the_snake%

      ' XXX TODO move to the proper action

      sel on complement%
        =nothing%:\
          narrate not_by_hand$
        =the_sword%
          narrate "Ante los amenazadores tajos, la serpiente huye."
          vanish the_snake%
          let way_out%(snake_passage_loc%,south%)=inner_lake_loc%
        =remainder:\
          narrate not_with_that$
      endsel

    =remainder:\
      narrate not_understood$

  endsel

enddef

defproc do_break_the_log
  sel on complement%
    =nothing%
      narrate not_by_hand$
    =the_sword%
      narrate not_by_sword$
    =remainder
      narrate not_understood$
  endsel
enddef

defproc do_break_the_cloak
  sel on complement%
    =nothing%
      narrate not_by_hand$
    =the_sword%
      vanish the_cloak%
      be_hold the_rags%
      be_hold the_thread%
      be_hold the_piece%
      narrate "Rasgas la capa, como buenamente puedes."
    =remainder
      narrate not_with_that$
  endsel
enddef

defproc do_break_the_rocks
  sel on complement%
    =nothing%:\
      narrate not_by_hand$
    =the_log%:\
      rocks_and_log
    =the_sword%:\
      narrate "Tu espada no hace nada." ' XXX TODO Improve.
    =remainder:\
      narrate not_with_that$
  endsel
enddef

defproc do_sharpen

  sel on object%

    =the_log%

      ' XXX factor, reuse with `to_break%`, `to_cut%`...

      if hacked_the_log%
        narrate "La punta ya está suficientemente afilada."
      else
        sel on complement%
          =nothing%
            narrate not_by_hand$
          =the_sword%
            narrate not_by_sword$
          =the_flint%
            let hacked_the_log%=true
            let description$(the_log%)=\
              description$(the_log%)&" Su punta está afilada."
            narrate "Con el pedernal, afilas la punta del tronco."
          =remainder
            ' XXX TODO factor
            narrate "El problema es encontrar \
              la herramienta adecuada para hacerlo."
        endsel

      endif

    =the_sword%
      narrate "La espada ya está suficientemente afilada."

    =remainder:\
      narrate not_understood$

  endsel

enddef

defproc do_speak

  sel on object%
    =ambrosio%:\
      talk_to_ambrosio
    =the_man%:\
      talk_to_the_man
    =remainder:\
      narrate "No tiene sentido hablar con eso." ' XXX TODO generalize
  endsel

enddef

defproc talk_to_ambrosio

  if location%(ambrosio%)=channel_sand_corner_loc%

    speak "Hola, buen hombre."
    speak "Hola, Ulfius. Mi nombre es Ambrosio."
    end_of_scene:\
    clear_screen
    narrate "Por primera vez, \
      te sientas y cuentas a Ambrosio todo lo que ha pasado. \
      Y, tras tanto acontecido, lloras desconsoladamente."
    end_of_scene:\
    clear_screen
    narrate "Ambrosio te propone un trato, que aceptas: \
      por ayudarle a salir de la cueva, \
      objetos, vitales para la empresa, te son entregados."
    be_hold the_torch%
    be_hold the_flint%
    short_pause
    speak "Bien, Ambrosio, emprendamos la marcha."
    let location%(ambrosio%)=ambrosios_home_loc%
    narrate "Te das la vuelta \
      para ver si Ambrosio te sigue, \
      pero... ha desaparecido."
    short_pause
    narrate "Piensas entonces \
      en el hecho curioso de que supiera tu nombre."
    end_of_scene:\
    clear_screen

  else

    if current_location%=ambrosios_home_loc%
      if not ambrosio_follows%
        speak "La llave, Ambrosio, estaba ya en tu poder. \
          Y es obvio que conocéis un camino más corto."
        speak "Estoy atrapado en la cueva \
          debido a magia de maligno poder. \
          En cuanto al camino, vos debéis hacer el vuestro, \
          verlo todo con vuestros ojos."
        narrate "Sacudes la cabeza."
        speak "No lo entiendo, la verdad."
      endif
    endif

    if current_location%>=passage_crossing_loc% \
      and current_location%<=cave_exit_loc%

      speak "Por favor, Ulfius, cumple tu promesa. \
        Toma la llave en tu mano y abre la puerta de la cueva."
      be_hold the_key%
      be_takeable the_key%
      let ambrosio_follows%=true

    endif

  endif

enddef

defproc talk_to_the_man

  if not talked_to_the_man%
    speak "Me llamo Ulfius y..."
    let talked_to_the_man%=true
    narrate "El hombre asiente, impaciente."
    speak "Somos refugiados de la gran guerra. Buscamos la paz."
    short_pause
  endif
  if is_accessible%(the_stone%)
    narrate "El hombre se irrita."
    speak "No podemos permitiros huir con la piedra del druida."
    narrate "Hace un gesto..."
    short_pause
    speak "La piedra debe ser devuelta a su lugar de encierro."
    narrate "Un hombre te arrebata la piedra y se la lleva."
    let location%(the_stone%)=stone_bridge_loc%
  else
    if is_accessible%(the_sword%)
      narrate "El hombre se enfurece, \
        y alza su mano indicando al norte."
      speak "Todo aquel que porte armas jamás podrá pasar."
    else
      let way_out%(refuge_loc%,east%)=spiral_loc%
      narrate "El hombre, calmado, indica hacia el este y habla:"
      speak "Si vienes en paz, puedes ir en paz."
      narrate "Todos se apartan y permiten ahora el paso al este."
    endif
  endif

enddef

defproc do_fling

  sel on current_location%
    =ruined_bridge_loc%,water_passage_loc%
      narrate "No hay suficiente profundidad."
    =channel_sand_corner_loc%
      if (object%=the_sword% or object%=the_stone%) \
        and talked_to_the_man%
        let location%(object%)=inside_waterfall_loc%
        narrate "La corriente lo arrastra fuertemente, \
          hasta perderlo de vista."
      else
        narrate "No quieres perder eso."
      endif
    =remainder:
      narrate "No tiene sentido tirar nada ahora."
  endsel

enddef

defproc do_insert

  ' XXX TODO rewrite, invert `sel` levels

  sel on complement%
    =the_rocks%
      if object%=the_log%
        rocks_and_log
      else
        narrate not_understood$
      endif
    =the_idol%
      sel on object%
        =the_emerald%,the_stone%
          vanish object%
          narrate "Encaja. Desaparece en su interior."
          if is_vanished%(the_stone%) \
            and is_vanished%(the_emerald%)
            let way_out%(idol_loc%,south%)=strait_passage_loc%
            narrate "La gran roca se desplaza y deja el paso libre."
          endif
        =remainder
          narrate not_understood$
      endsel
    =the_lock%
      if object%=the_key%
        narrate "La llave gira fácilmente dentro del candado."
        short_pause
        open_the_door
      else
        narrate not_understood$
      endif
    =remainder
      narrate not_understood$
  endsel

enddef

defproc do_move(direction%)

  if way_out%(current_location%,direction%)
    enter way_out%(current_location%,direction%)
  else
    narrate "No es posible."
  endif

enddef

defproc do_inventory

  loc i%,list$
  let list$=""

  for i%=1 to entities%
    if is_hold%(i%):\
      let list$=list$&"  - "&name$(i%)&nl$
  endfor i%
  if len(list$)
    narrate "Llevas contigo:"&nl$&list$
  else
    narrate "Nada llevas contigo."
  endif

enddef

defproc do_look

  if object%
    do_examine_object
  else
    do_look_around
  endif

enddef

defproc enter(new_location%)

  let current_location%=new_location%
  do_look_around

enddef

defproc do_look_around

  clear_screen
  ' narrate "["&current_location%&"]" ' XXX INFORMER

  describe location_description$(current_location%)

  location_plot ' XXX FIXME only when entering the location
  list_present_entities

enddef

defproc list_present_entities

  ' XXX TODO -- Improve with `item$` and "a"

  loc i%,list$

  let list$=""
  for i%=1 to entities%
    if is_here%(i%)
      if is_a_person%(i%)
        let list$=list$&"  - "&iso_upper_1$(name$(i%))&nl$
      else
        let list$=list$&"  - "&name$(i%)&nl$
      endif
    endif
  endfor i%
  if len(list$)
    narrate "Puedes ver:"&nl$&list$
  endif

enddef

' ==============================================================
' Data interface

deffn is_a_person%(entity%)

  ret attribute(entity%)=person_attr%

enddef

defproc be_takeable(entity%)

  let attribute(entity%)=takeable_attr%

enddef

defproc be_untakeable(entity%)

  ' XXX REMARK -- Not used.

  let attribute(entity%)=untakeable_attr%

enddef

deffn is_takeable%(entity%)

  ret attribute(entity%)=takeable_attr%

enddef

deffn is_untakeable%(entity%)

  ret attribute(entity%)<>takeable_attr%

enddef

defproc be_here(entity%)

  let location%(entity%)=current_location%

enddef

deffn is_here%(entity%)

  ret location%(entity%)=current_location%

enddef

defproc be_hold(entity%)

  let location%(entity%)=protagonist%

enddef

deffn is_hold%(entity%)

  ret location%(entity%)=protagonist%

enddef

deffn is_accessible%(entity%)

  ret is_hold%(entity%) or is_here%(entity%)

enddef

defproc vanish(entity%)

  let location%(entity%)=limbo%

enddef

deffn is_vanished%(entity%)

  ret location%(entity%)=limbo%

enddef

' ==============================================================
' Input

deffn accept$

  ' Return a new user command, formatted for the parsing.

  loc command$
  ink #tw%,yellow%
  print #tw%,"> ";
  let command$=iso_input$(#tw%,0)
  if command$(len(command$))<>" ":\
    let command$=command$&" "
  ink #tw%,light_grey%
  ret command$

enddef

deffn iso_input$(channel%,max_chars%)

  ' Return a text typed by the user.

  ' channel% = Channel of the window to be used, at the current cursor
  ' position.
  '
  ' max_chars% = Maximum length. If it's zero, it will be the maximum
  ' possible on the current line, with the current character size.

  ' Spanish chars are translated to ISO 8859-1; all letters are made
  ' lowercase.  Not allowed: starting or double spaces, digits and
  ' punctuation.

  loc output$,key$,key%,cursor_pos%,cursor_x0%,cursor_y0%

  let output$=""
  let cursor_pos%=1
  let cursor_x0%=pos_x(#channel%)
  let cursor_y0%=pos_y(#channel%)
  if max_chars%=0
    let max_chars%=char_x(#channel%)-cursor_x0%/char_w(#channel%)-2
  endif
  cursen #channel%
  rep typing
    let key$=inkey$(#channel%,-1)
    let key%=code(key$)
    sel on key%
      =2:let mistype_bell_active%=not mistype_bell_active% ' Ctrl+B
      =9:tab 8 ' Tab
      =nl%:if len(output$):exit typing:else mistype_bell
      =space%:type_space
      =65 to 90:type chr$(key%+32)
      =97 to 122:type key$
      =131,163:type chr$(233) ' é/É
      =135,167:type chr$(252) ' ü/Ü
      =137,169:type chr$(241) ' ñ/Ñ
      =140:type chr$(225) ' á
      =147:type chr$(237) ' í
      =150:type chr$(243) ' ó
      =153:type chr$(250) ' ú
      =192:cursor_left
      =193:start_of_line ' Alt+Left
      =194:backspace_char ' Ctrl+Left
      =195:delete_line_left ' Ctrl+Alt+Left
      =196:previous_word ' Shift+Left
      =200:cursor_right
      =201:end_of_line ' Alt+Right
      =202:delete_char ' Ctrl+Right
      =203:delete_line_right ' Ctrl+Alt+Right
      =204:next_word ' Shift+Right
      =253:tab -8 ' Shift+Tab
    endsel
  endrep typing
  curdis #channel%
  print #channel%\\\:
  ret output$

enddef

defproc type(char$)

  ' If possible, add the given character to the input line and
  ' display it.

  if len(output$)<max_chars%
    sel on cursor_pos%
    =len(output$)+1
      let output$=output$&char$
    =remainder
      let output$=output$(1 to cursor_pos%-1)\
        &char$\
        &output$(cursor_pos% to)
    endsel
    let cursor_pos%=cursor_pos%+1
    show_input
  else
    mistype_bell
  endif

enddef

defproc type_space

  ' If possible, add a space to the input line and display it.

  if cursor_pos%=1
    mistype_bell
  else
    if cursor_pos%>len(output$)
      if output$(cursor_pos%-1)=" "
        mistype_bell
      else
        type " "
      endif
    else
      if output$(cursor_pos%)=" " or output$(cursor_pos%-1)=" "
        mistype_bell
      else
        type " "
      endif
    endif
  endif

enddef

defproc tab(offset%)

  ' If possible, add the given offset to the cursor position.

  if (offset%<1 and cursor_pos%=1) \
    or (offset%>0 and cursor_pos%=len(output$)+1)
    mistype_bell
  else
    let cursor_pos%=cursor_pos%+offset%
    let cursor_pos%=maximum(cursor_pos%,1)
    let cursor_pos%=minimum(cursor_pos%,len(output$)+1)
    set_cursor cursor_pos%
  endif

enddef

defproc start_of_line

  ' Put the cursor at the start of the line.

  let cursor_pos%=1
  set_cursor cursor_pos%

enddef

defproc end_of_line

  ' Put the cursor at the end of the line.

  let cursor_pos%=len(output$)+1
  set_cursor cursor_pos%

enddef

defproc backspace_char

  ' If possible, delete the character at the left of the cursor.

  loc original$

  if len(output$)
    if cursor_pos%=1
        mistype_bell
    else
      let original$=output$
      let output$=original$(1 to cursor_pos%-2)
      if cursor_pos%<=len(original$)
        let output$=output$&original$(cursor_pos% to)
      endif
      let cursor_pos%=cursor_pos%-1
      show_input
    endif
  else
    mistype_bell
  endif

enddef

defproc delete_char

  ' If possible, delete the character under the cursor.

  loc original$

  if len(output$)
    if cursor_pos%=len(output$)+1
      mistype_bell
    else
      let original$=output$
      let output$=original$(1 to cursor_pos%-1)
      if cursor_pos%<len(original$)
        let output$=output$&original$(cursor_pos%+1 to)
      endif
      show_input
    endif
  else
    mistype_bell
  endif

enddef

defproc delete_line_right

  ' If possible, delete to end of line.

  if len(output$)
    if cursor_pos%=len(output$)+1
      mistype_bell
    else
      let output$=output$(1 to cursor_pos%-1)
      show_input
    endif
  else
    mistype_bell
  endif

enddef

defproc delete_line_left

  ' If possible, delete the character at the left of the cursor.

  if len(output$)
    if cursor_pos%=1
        mistype_bell
    else
      let output$=output$(cursor_pos% to)
      let cursor_pos%=1
      show_input
    endif
  else
    mistype_bell
  endif

enddef

defproc cursor_left

  ' If possible, move the cursor one character left.

  if cursor_pos%>1
    curdis #channel%
    let cursor_pos%=cursor_pos%-1
    set_cursor cursor_pos%
    cursen #channel%
  else
    mistype_bell
  endif

enddef

defproc cursor_right

  ' If possible, move the cursor one character right.

  if cursor_pos%<len(output$)+1
    curdis #channel%
    let cursor_pos%=cursor_pos%+1
    set_cursor cursor_pos%
    cursen #channel%
  else
    mistype_bell
  endif

enddef

defproc previous_word

  ' If possible, move the cursor to the start of the previous word.

  loc temp%,from_char%,to_char%

  if cursor_pos%=1

    mistype_bell

  else

    let temp%=0
    let to_char%=code(output$(cursor_pos%-(cursor_pos%>len(output$))))
    let from_char%=to_char%

    rep search

      if not ((cursor_pos%>1) \
        and not(from_char%<>space% and to_char%=space% and temp%>1)):\
          exit search

        let from_char%=to_char%
        let cursor_pos%=cursor_pos%-1
        let temp%=temp%+1
        let to_char%=code(output$(cursor_pos%))

    endrep search

    let cursor_pos%=cursor_pos%+(cursor_pos%<>1)
    set_cursor cursor_pos%
    show_input

  endif

enddef

defproc next_word

  ' If possible, move the cursor to the start of the next word (or to
  ' the end of the last word).

  loc from_char%,to_char%

  if cursor_pos%>len(output$)
    mistype_bell
  else
    let to_char%=code(output$(cursor_pos%))
    let from_char%=to_char%

    rep search

      if not ((cursor_pos%<len(output$)) \
        and not(from_char%=space% and to_char%<>space%)):\
          exit search

      let from_char%=to_char%
      let cursor_pos%=cursor_pos%+1
      let to_char%=code(output$(cursor_pos%))

    endrep search

    let cursor_pos%=cursor_pos%+(cursor_pos%=len(output$))
    set_cursor cursor_pos%
    show_input
  endif

enddef

defproc show_input

  ' Show the current text.

  curdis #channel%
  set_cursor 1
  print #channel%,output$;
  cls #channel%,4
  set_cursor cursor_pos%
  cursen #channel%

enddef

defproc set_cursor(column%)

  ' Set the text cursor at the pixel position of the given column
  ' (which is relative to the typed text).

  cursor #channel%,\
    cursor_x0%+(column%-1)*char_w(#channel%),\
    cursor_y0%

enddef

defproc mistype_bell

  ' Mistype sound.

  if mistype_bell_active%:\
    beep 1000,0

enddef

deffn yes%(question$)

  ' Show the given question and wait for S or N to be pressed
  ' (ignoring case).  Return 1 if S was pressed; 0 otherwise.

  loc answer$

  cursen #tw%
  print #tw%,question$!"(S/N)"!;
  rep answer
    let answer$=inkey$(#tw%,-1)
    if answer$ instr "sn"
      exit answer
    else
      mistype_bell
    endif
  endrep answer
  curdis #tw%
  ret answer$ instr "s"

enddef

defproc end_of_scene

  ' Show a prompt and do a long pause.

  ink #tw%,dark_green%
  print #tw%,"..."\\:
  long_pause

enddef

defproc short_pause

  ' Do a short pause; it's used between certain paragraphs.

  wait_for_key_press(2)

enddef

defproc long_pause

  ' Do a long pause; it's used after every scene.

  wait_for_key_press(16)

enddef

defproc wait_for_key_press(seconds%)

  ' Wait the given seconds, or until a key is pressed.

  loc start_time
  let start_time=date

  rep dont_press_a_key
    if inkey$(#tw%)="" or date>start_time+seconds%
      exit dont_press_a_key
    endif
  endrep dont_press_a_key
  rep press_a_key
    if inkey$(#tw%)<>"" or date>start_time+seconds%
      exit press_a_key
    endif
  endrep press_a_key

enddef

' ==============================================================
' Strings

deffn iso_upper%(char%)

  ' Return the uppercase char code of the given ISO 8859-1 char.

  sel on char%
    =97 to 122,224 to 246,248 to 254:\
      ret char%-32
    =remainder:\
      ret char%
  endsel

enddef

deffn iso_upper$(text$)

  ' Return the given ISO 8859-1 text in uppercase.

  loc i%,upper_text$
  let upper_text$=text$
  for i%=1 to len(upper_text$)
    let upper_text$(i%)=chr$(iso_upper%(code(text$(i%))))
  endfor i%
  ret upper_text$

enddef

deffn iso_upper_1$(text$)

  ' Return the given ISO 8859-1 text with the first letter in
  ' uppercase.

  ret iso_upper$(text$(1))&text$(2 to)

enddef

' ==============================================================
' Screen

defproc clear_screen

  ink #tw%,light_grey%
  cls #tw%

enddef

' ==============================================================
' Text output

defproc speak(quote$)

  ' Print a dialog quote, with the proper quote chars.

  loc last%
  ink #tw%,yellow%
  if r_quote$ instr quote$ and not l_quote$ instr quote$
    tell l_quote$&quote$
  else
    let last%=len(quote$)
    if quote$(last%)="." and quote$(last%-1)<>"."
      tell l_quote$&quote$(1 to last%-1)&r_quote$&"."
    else
      tell l_quote$&quote$&r_quote$
    endif
  endif

enddef

defproc describe(txt$)

  ' Print a location description.

  ink #tw%,dark_cyan%:\
  tell txt$

enddef

defproc narrate(txt$)

  ' Print a narrative text.

  ink #tw%,light_grey%:\
  tell txt$

enddef

defproc tell(txt$)

  ' Print a text, left justified.

  loc text$,first%,last%

  if len(txt$)
    let text$=txt$&" "
    let first%=1
    for last%=1 to len(text$)
      if text$(last%)=" "
        print #tw%,!text$(first% to last%-1);
        let first%=last%+1
      endif
    endfor last%
  endif
  print #tw%,\\:

enddef

' ==============================================================
' About

defproc about

  ' Show the credits.

  clear_screen
  ink #tw%,light_red%:\
  print #tw%,"Asalto y castigo"
  ink #tw%,dark_cyan%
  print #tw%,\"Por Baltasar el Arquero, 2009"
  print #tw%,"http://caad.es/baltasarq/"
  print #tw%,\"Reescrita en SuperBASIC para QL por"
  print #tw%,"Marcos Cruz (programandala.net), 2011, 2017"
  print #tw%,"http://programandala.net/"
  print #tw%,"Versión"!version$
  ink #tw%,light_grey%
  print #tw%,\\"http://www.caad.es/"
  print #tw%,"http://www.sinclairql.es/"\\\:

enddef

defproc intro

  ' Game intro.

  clear_screen
  narrate "El sol despunta de entre la niebla, \
    haciendo humear los tejados de paja."
  short_pause
  narrate "Piensas en el encargo realizado por Uther Pendragon. \
    Atacar una aldea tranquila, aunque sea una llena de sajones, \
    no te llena de orgullo."
  short_pause
  narrate "Los hombres se ciernen sobre la aldea, y la destruyen. \
    No hubo tropas enemigas, ni honor en la batalla."
  end_of_scene:\
  clear_screen
  speak "Sire Ulfius, la batalla ha terminado."
  narrate "Lentamente, das la orden de volver a casa. \
    Los oficiales detienen como pueden el saqueo."
  end_of_scene:\
  clear_screen

enddef

' ==============================================================
' Init

defproc first_time_init

  ' Init needed only once.

  let dev$=device$("ayc_bas","mdvflpwinsubdevdosnfasfafdk")
  init_keyboard
  init_screen
  init_windows
  load_splash_screen
  init_constants
  init_preferences
  clear_screen

enddef

#include device.bas

defproc game_init

  ' Init needed before every game.

  loc y%
  let y%=pos_y(#tw%)
  print #tw%,"Preparando los datos..."
  init_plot
  init_data
  let current_location%=saxon_village_loc%
  cls #tw%,3
  cursor #tw%,0,y%

  ' Special init conditions for checking and debuging:

  sel on true

    =false

      ' Check "to sharpen"

      be_here the_log%
      be_here the_flint%

  endsel

enddef

defproc init_keyboard

  ' If needed, load the Spanish SMSQ keybard table.

  loc spanish%
  let spanish%=34

  if ver$="HBA"
    if language<>spanish%
      lrespr dev$&"qxl-es_kbt"
      kbd_table spanish%
      lang_use spanish%
    endif
  endif

enddef

defproc init_screen

  ' Set the screen mode and colours.

  if disp_type<>32:\
    mode 32
  init_colours

enddef

defproc init_colours

  ' Set the PAL colour mode and the needed colours.

  colour_pal
  let black%=0
  let dark_cyan%=7:palette_8 dark_cyan%,$008B8B
  let dark_green%=17
  let light_grey%=12
  let light_red%=1:palette_8 light_red%,$FF3333
  let yellow%=6

enddef

defproc init_windows

  init_text_window
  init_splash_screen_window

enddef

defproc init_text_window

  ' XXX TMP -- Maximum size: 800x600.

  loc csize_w%,csize_h%
  loc tw_w%,tw_h%,tw_x%,tw_y%

  let csize_w%=3-(scr_xlim=512)
  let csize_h%=scr_xlim>512
  let tw%=fopen("con_")
  csize #tw%,csize_w%,csize_h%
  let tw_w%=minimum(800,scr_xlim)
  let tw_h%=minimum(600,scr_ylim)
  let tw_x%=(scr_xlim-tw_w%)/2
  let tw_y%=(scr_ylim-tw_h%)/2
  window #tw%,tw_w%,tw_h%,tw_x%,tw_y%
  paper #tw%,black%
  ink #tw%,light_grey%
  wipe_the_text_window
  init_font

enddef

defproc wipe_the_text_window

  border #tw%,0
  cls #tw%
  border #tw%,8

enddef

defproc init_splash_screen_window

  loc sw_w%,sw_h%,sw_x%,sw_y%

  sel on true
  =fits%(1280,800)
    let sw_w%=1280
    let sw_h%=800
  =fits%(1110,800)
    let sw_w%=1110
    let sw_h%=800
  =fits%(1024,768)
    let sw_w%=1024
    let sw_h%=768
  =fits%(1024,600)
    let sw_w%=1024
    let sw_h%=600
  =fits%(800,600)
    let sw_w%=800
    let sw_h%=600
  =fits%(800,577)
    let sw_w%=800
    let sw_h%=577
  =fits%(800,480)
    let sw_w%=800
    let sw_h%=480
  =fits%(640,480)
    let sw_w%=640
    let sw_h%=480
  =fits%(555,400)
    let sw_w%=555
    let sw_h%=400
  =fits%(512,256)
    let sw_w%=512
    let sw_h%=256
  =fits%(355,256)
    let sw_w%=355
    let sw_h%=256
  =remainder
    let sw_w%=256
    let sw_h%=256
  endsel

  let splash_screen_file$="splash_screen_"&sw_w%&"x"&sw_h%&".bmp"

  let sw_x%=(scr_xlim-sw_w%)/2
  let sw_y%=(scr_ylim-sw_h%)/2
  let sw%=fopen("scr_")
  window #sw%,sw_w%,sw_h%,sw_x%,sw_y%

enddef

deffn fits%(width%,height%)

  ret width%<=scr_xlim and height%<=scr_ylim

enddef 

defproc load_splash_screen

  load_bmp sw%,splash_screen_file$
  seconds 10

enddef

defproc seconds(n%)

  ' Wait _n%_ seconds or until a key is pressed.

  pause n%*50

enddef

defproc load_bmp(channel%,filename$)

  wl_bmp8load #channel%,dev$&"img_"&filename$

enddef

defproc init_font

  loc font_size%
  let font$=dev$&"iso8859-1_font"
  font_size%=flen(\font$)
  font_address=alchp(font_size%)
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

  char_use #tw%,font_address,0

enddef

defproc init_preferences

  ' Init the game preferences.

  let mistype_bell_active%=true

enddef

defproc init_constants

  ' Init all the constants.

  ' Misc

  let space%=32     ' char code
  let nl%=10        ' char code of the enter key
  let nl$=chr$(nl%) ' new line
  let l_quote$="«"  ' castilian left quote
  let r_quote$="»"  ' castilian right quote

  ' Syntax flags

  let no_object_needed%=0
  let object_needed%=1
  let object_and_complement_needed%=2

  ' Error messages

  let not_seen$="No lo veo, o no es importante."
  let i_dont_have_it$="No llevo eso conmigo."
  let not_with_that$="Con eso no..."
  let not_by_hand$="En cualquier caso, no con las manos desnudas."
  let not_understood$="¿Eh?"
  let not_by_sword$="Sabes que el resultado es \
    la hoja de tu espada, mellada. No."

  ' Generic identifiers

  let nothing%=0 ' action, object or complement

  ' Action identifiers

  let next_enum%=1

  let to_go_down%=enum%
  let to_open%=enum%
  let to_go_up%=enum%
  let to_break%=enum%
  let to_help%=enum%
  let to_swim%=enum%
  let to_take%=enum%
  let to_drop%=enum%
  let to_go_east%=enum%
  let to_examine%=enum%
  let to_speak%=enum%
  let to_insert%=enum%
  let to_look%=enum%
  let to_go_north%=enum%
  let to_go_west%=enum%
  let to_go_south%=enum%
  let to_finish%=enum%
  let to_fling%=enum%
  let to_sharpen%=enum%
  let to_inventory%=enum%
  ' XXX TODO calculate `actions%` here

  ' Entity identifiers

  let next_enum%=1

  let protagonist%=-1 ' XXX TMP until locations are combined with the entities

  let the_altar%=enum%
  let ambrosio%=enum%
  let the_torch%=enum%
  let the_flags%=enum%
  let the_cloak%=enum%
  let the_waterfall%=enum%
  let the_fallen_away%=enum%
  let the_emerald%=enum%
  let the_sword%=enum%
  let the_rags%=enum%
  let the_thread%=enum%
  let the_man%=enum%
  let the_idol%=enum%
  let the_lake%=enum%
  let the_key%=enum%
  let the_flint%=enum%
  let the_stone%=enum%
  let the_door%=enum%
  let the_rocks%=enum%
  let the_snake%=enum%
  let the_log%=enum%
  let the_piece%=enum%
  let the_lock%=enum%

  ' Location identifiers

  let nowhere%=0
  let limbo%=255 ' location of vanished entities

  let next_enum%=1

  let saxon_village_loc%=enum%
  let on_the_hill_loc%=enum%
  let path_between_hills_loc%=enum%
  let paths_crossing_loc%=enum%
  let near_the_forest_loc%=enum%
  let forest_loc%=enum%
  let dog_passage_loc%=enum%
  let cave_entrance_loc%=enum%
  let fallen_away_loc%=enum%
  let cave_hall_loc%=enum%
  let big_lake_loc%=enum%
  let secret_exit_loc%=enum%
  let ruined_bridge_loc%=enum%
  let cave_corner_loc%=enum%
  let sand_passage_loc%=enum%
  let water_passage_loc%=enum%
  let stalactites_loc%=enum%
  let stone_bridge_loc%=enum%
  let channel_sand_corner_loc%=enum%
  let cave_strait_1_loc%=enum%
  let cave_strait_2_loc%=enum%
  let cave_strait_3_loc%=enum%
  let cave_strait_4_loc%=enum%
  let cave_strait_5_loc%=enum%
  let cave_strait_6_loc%=enum%
  let cave_strait_7_loc%=enum%
  let cave_strait_8_loc%=enum%
  let refuge_loc%=enum%
  let spiral_loc%=enum%
  let spiral_start_loc%=enum%
  let north_gate_loc%=enum%
  let precipice_loc%=enum%
  let exit_passage_loc%=enum%
  let gravel_passage_loc%=enum%
  let bridge_over_aqueduct_loc%=enum%
  let pool_loc%=enum%
  let water_channel_loc%=enum%
  let big_waterfall_loc%=enum%
  let inside_waterfall_loc%=enum%
  let terrace_loc%=enum%
  let idol_loc%=enum%
  let strait_passage_loc%=enum%
  let snake_passage_loc%=enum%
  let inner_lake_loc%=enum%
  let passage_crossing_loc%=enum%
  let ambrosios_home_loc%=enum%
  let cave_exit_loc%=enum%
  let cave_exit_forest_loc%=enum%
  let forest_path_loc%=enum%
  let north_road_loc%=enum%
  let westmorland_loc%=enum%

  let locations%=next_enum%-1

  ' Direction identifiers
  
  let north%=0
  let south%=1
  let east%=2
  let west%=3
  let up%=4
  let down%=5
  let first_direction%=north%
  let last_direction%=down%

  ' Entity attribute

  ' XXX TODO -- Use a bitmask.
  let takeable_attr%=false
  let untakeable_attr%=true
  let person_attr%=2

enddef

deffn enum%

  let next_enum%=next_enum%+1
  ret next_enum%-1

enddef

defproc init_plot

  let ambrosio_follows%=false  ' Does Ambrosio follow me?
  let under_attack%=0          ' Battle counter
  let talked_to_the_man%=false ' Have I talked to the man?
  let hacked_the_log%=false    ' Did I hacked the log?
  let lit_the_torch%=false     ' Is the torch lit?
  let start_over%=false        ' Start a new game?

enddef

defproc init_data

  ' Init the data arrays. The first element (0) of the arrays is not
  ' used, except for the directions.

  loc i%,max_word_lenght%,action%,from_location%,to_location%,entity%

  let max_word_lenght%=11 ' XXX TODO calculate

  restore

  dim way_out%(locations%,last_direction%)
  restore @map
  for i%=1 to locations%
    read from_location%
    for to_location%=first_direction% to last_direction%
      read way_out%(from_location%,to_location%)
    endfor to_location%
  endfor i%

  let nouns%=@nouns_end-@nouns_start
  dim noun$(nouns%,max_word_lenght%)
  dim entity_of_noun%(nouns%)
  let entities%=(@entities_end-@entities_start)/2
  dim name$(entities%,max_word_lenght%)

  ' Note: The last synonym on the list will be the name of the entity.
  restore @nouns_start
  for i%=1 to nouns%
    read entity_of_noun%(i%),noun$(i%)
    let name$(entity_of_noun%(i%))=noun$(i%)
  endfor i%

  dim location%(entities%)
  dim attribute(entities%)
  dim description$(entities%,128)
  restore @entities_start
  for i%=1 to entities%
    read \
      entity%,\
      location%(entity%),\
      attribute(entity%),\
      description$(entity%)
  endfor i%

  let actions%=@actions_end-@actions_start
  dim syntax%(actions%)
  restore @actions_start
  for i%=1 to actions%
    read action%,syntax%(action%)
  endfor i%

  let verbs%=@verbs_end-@verbs_start
  dim verb$(verbs%,max_word_lenght%)
  dim verb_action(verbs%)
  restore @verbs_start
  for i%=1 to verbs%
    read verb_action(i%),verb$(i%)
  endfor i%

enddef

' ==============================================================
' Data

' Location descriptions

deffn location_description$(a_location%)

  ' Return the description of the given location.

  ' XXX REMARK -- 
  '
  ' Formerly, the description was read from its `data` line when
  ' needed, which method avoided duplication of the descriptions
  ' (in the source and in an array), saving some memory, which
  ' nevertheless is a negligible advantage in a modern QL
  ' system.
  '
  ' The problem was the calculation of the line number to
  ' `restore` made the constant identifiers be defined in a
  ' fixed order.
  '
  ' This new method, a function with a `sel` structure, solves
  ' that problem, while the speed penalty of the `sel` structure
  ' is negligible.
  '
  ' An added advantage of this method is the descriptions can be
  ' changed at run-time after the game conditions.

  sel on a_location%

    =saxon_village_loc%

    ret "Aldea Sajona. \
    No ha quedado nada en pie, ni piedra sobre piedra. \
    El entorno es desolador. \
    Solo resta volver al sur, a casa."

    =on_the_hill_loc%

    ret "Sobre la colina, \
    casi sobre la niebla de la aldea sajona arrasada al norte, \
    a tus pies. El camino desciende hacia el oeste."

    =path_between_hills_loc%

    ret "Camino entre colinas. \
    El camino avanza por el valle, desde la parte alta, \
    al este, a una zona harto boscosa, al oeste."

    =paths_crossing_loc%

    ret "Cruce de caminos. \
    Una senda parte al oeste, \
    a la sierra por el paso del Perro, \
    y otra hacia el norte, \
    por un frondoso bosque que la rodea."

    =near_the_forest_loc%

    ret "Desde la linde, al sur, \
    hacia el oeste se extiende \
    frondoso el bosque que rodea la sierra. \
    La salida se abre hacia el sur."

    =forest_loc%

    ret "Bosque. \
    Jirones de niebla se enzarcen en frondosas ramas y arbustos. \
    La senda serpentea entre raíces, \
    de un luminoso este al oeste."

    =dog_passage_loc%

    ret "Paso del Perro. \
    Abruptamente, del bosque se pasa \
    a un estrecho camino entre altas rocas. \
    El inquietante desfiladero tuerce de este a sur."

    =cave_entrance_loc%

    ret "Entrada a la cueva. \
    El paso entre el desfiladero sigue de norte a este. \
    La entrada a una cueva se abre al sur en la pared de roca."

    =fallen_away_loc%

    ret "Derrumbe. \
    El camino desciende hacia la agreste sierra, al oeste, \
    desde los verdes valles al este. \
    Pero un gran derrumbe bloquea la sierra."

    =cave_hall_loc%

    ret "Gruta de entrada. \
    El estrecho paso se adentra hacia el oeste, \
    desde la boca, al norte. "

    =big_lake_loc%

    ret "Gran lago. \
    Una gran estancia alberga un lago \
    de profundas e iridiscentes aguas, debido a la luz exterior. \
    No hay otra salida que el este."

    =secret_exit_loc%

    ret "Salida del paso secreto. \
    Una gran estancia se abre hacia el oeste, \
    y se estrecha hasta morir, \
    al este, en una parte de agua."

    =ruined_bridge_loc%

    ret "Puente semipodrido. \
    La sala se abre en semioscuridad \
    a un puente cubierto de podredumbre \
    sobre el lecho de un canal, de este a oeste."

    =cave_corner_loc%

    ret "Recodo de la cueva. \
    La iridiscente cueva gira de este a sur."

    =sand_passage_loc%

    ret "Pasaje arenoso. \
    La gruta desciende de norte a sur sobre un lecho arenoso. \
    Al este, un agujero del que llega claridad."

    =water_passage_loc%

    ret "Pasaje del agua. \
    Como un acueducto, \
    el agua baja con gran fuerza de norte a este, \
    aunque la salida practicable es la del oeste."

    =stalactites_loc%

    ret "Estalactitas. \
    Muchas estalactitas se agrupan encima de tu cabeza, \
    y se abren cual arco de entrada hacia el este y sur."

    =stone_bridge_loc%

    ret "Puente de piedra. \
    Un arco de piedra se eleva, cual puente sobre la oscuridad, \
    de este a oeste. En su mitad, un altar."

    =channel_sand_corner_loc%

    ret "Recodo arenoso del canal. \
    La furiosa corriente, de norte a este, \
    impide el paso, excepto al oeste. \
    Al fondo, se oye un gran estruendo."

    =cave_strait_1_loc%

    ret "Un tramo de cueva estrecho te permite avanzar \
    hacia el norte y el sur; un pasaje surge al este."

    =cave_strait_2_loc%

    ret "Un tramo de cueva estrecho te permite avanzar \
    de este a oeste; un pasaje surge al sur."

    =cave_strait_3_loc%

    ret "Un tramo de cueva estrecho te permite avanzar \
    de este a oeste; un pasaje surge al sur."

    =cave_strait_4_loc%

    ret "Un tramo de cueva estrecho te permite avanzar de oeste a sur."

    =cave_strait_5_loc%

    ret "Un tramo de cueva estrecho te permite avanzar de este a norte."

    =cave_strait_6_loc%

    ret "Un tramo de cueva estrecho te permite avanzar de este a oeste. \
    Al norte y al sur surgen pasajes."

    =cave_strait_7_loc%

    ret "Un tramo de cueva estrecho te permite avanzar de este a oeste. \
    Al norte surge un pasaje."

    =cave_strait_8_loc%

    ret "Un tramo de cueva estrecho te permite avanzar al oeste. \
    Al norte surge un pasaje."

    =refuge_loc%

    ret "Refugio. \
    Una amplia estancia de norte a este, \
    hace de albergue a refugiados: \
    hay banderas de ambos bandos. \
    Un hombre anciano te contempla. Los refugiados te rodean."

    =spiral_loc%

    ret "Espiral. \
    Cual escalera de caracol gigante, \
    desciende a las profundidades, \
    dejando a los refugiados al oeste."

    =spiral_start_loc%

    ret "Inicio de la espiral. \
    Se eleva en la penumbra. \
    La caverna se estrecha ahora como para una sola persona, \
    hacia el este."

    =north_gate_loc%

    ret "Puerta norte. \
    En este pasaje grandes rocas se encuentran entre las columnas \
    de un arco de medio punto."

    =precipice_loc%

    ret "Precipicio. \
    El camino ahora no excede de dos palmos de cornisa \
    sobre un abismo insondable. \
    El soporte de roca gira en 'U' de oeste a sur."

    =exit_passage_loc%

    ret "Pasaje de salida. \
    El paso se va haciendo menos estrecho \
    a medida que se avanza hacia el sur, \
    para entonces comenzar hacia el este."

    =gravel_passage_loc%

    ret "Pasaje de gravilla. \
    El paso se anchea de oeste a norte, \
    y guijarros mojados y mohosos tachonan el suelo de roca."

    =bridge_over_aqueduct_loc%

    ret "Puente sobre el acueducto. \
    Un puente se tiende de norte a sur sobre el curso del agua. \
    Resbaladizas escaleras descienden hacia el oeste."

    =pool_loc%

    ret "Remanso. \
    Estruendosa corriente baja con el pasaje elevado desde el oeste, \
    y forma un meandro arenoso. Unas escaleras suben al este."

    =water_channel_loc%

    ret "Canal de agua. \
    El agua baja del oeste con renovadas fuerzas, \
    dejando un estrecho paso elevado \
    lateral para avanzar a este o a oeste."

    =big_waterfall_loc%

    ret "Gran cascada. \
    Cae el agua hacia el este, \
    descendiendo con gran fuerza hacia el canal, \
    no sin antes embalsarse en un lago poco profundo."

    =inside_waterfall_loc%

    ret "Interior de la cascada. \
    Musgoso y rocoso, con la cortina de agua tras de ti, \
    el nivel del agua ha crecido un poco en este curioso hueco."

    =terrace_loc%

    ret "Explanada. \
    Una gran explanada enlosetada \
    contempla un bello panorama de estalactitas. \
    Unos casi imperceptibles escalones conducen al este."

    =idol_loc%

    ret "Ídolo. \
    El ídolo parece un centinela siniestro \
    de una gran roca que se encuentra al sur. \
    Se puede volver a la explanada al oeste."

    =strait_passage_loc%

    ret "Pasaje estrecho. \
    Como un pasillo que corteja el canal de agua, \
    a su lado, baja de norte a sur. \
    Se aprecia un aumento de luz hacia el sur."

    =snake_passage_loc%

    ret "Pasaje de la serpiente. \
    El pasaje sigue de norte a sur."

    =inner_lake_loc%

    ret "Lago interior. \
    Unas escaleras dan paso a un hermoso lago interior, \
    y siguen hacia el oeste. \
    Al norte, un oscuro y estrecho pasaje sube."

    =passage_crossing_loc%

    ret "Cruce de pasajes. \
    Estrechos pasos permiten ir al oeste, \
    al este (menos oscuro), y al sur, \
    un lugar de gran luminosidad."

    =ambrosios_home_loc%

    ret "Hogar de Ambrosio. \
    Un catre, algunas velas y una mesa es todo lo que tiene Ambrosio."

    =cave_exit_loc%

    ret "Salida de la cueva. \
    Por el oeste, una puerta impide, cuando cerrada, \
    la salida de la cueva. Se adivina la luz diurna al otro lado."

    =cave_exit_forest_loc%

    ret "Bosque a la entrada. \
    Apenas se puede reconocer la entrada de la cueva, al este. \
    El sendero sale del bosque hacia el oeste."

    =forest_path_loc%

    ret "Sendero del bosque. \
    El sendero recorre esta parte del bosque de este a oeste."

    =north_road_loc%

    ret "Camino norte. \
    El camino norte de Westmorland se interna hacia el bosque, \
    al norte (en tu estado no puedes ir), y a Westmorland, al sur."

    =westmorland_loc%

    ret "Westmorland. \
    La villa bulle de actividad \
    con el mercado en el centro de la plaza, \
    donde se encuentra el castillo."

  endsel

enddef

' Map

'  data: location,north,south,east,west,down,up
label @map
data saxon_village_loc%,nowhere%,on_the_hill_loc%,nowhere%,nowhere%,nowhere%,nowhere%
data on_the_hill_loc%,saxon_village_loc%,nowhere%,nowhere%,path_between_hills_loc%,nowhere%,nowhere%
data path_between_hills_loc%,nowhere%,nowhere%,on_the_hill_loc%,paths_crossing_loc%,nowhere%,nowhere%
data paths_crossing_loc%,near_the_forest_loc%,nowhere%,path_between_hills_loc%,fallen_away_loc%,nowhere%,nowhere%
data near_the_forest_loc%,nowhere%,paths_crossing_loc%,nowhere%,forest_loc%,nowhere%,nowhere%
data forest_loc%,nowhere%,nowhere%,near_the_forest_loc%,dog_passage_loc%,nowhere%,nowhere%
data dog_passage_loc%,nowhere%,cave_entrance_loc%,forest_loc%,nowhere%,nowhere%,nowhere%
data cave_entrance_loc%,dog_passage_loc%,cave_hall_loc%,nowhere%,nowhere%,nowhere%,nowhere%
data fallen_away_loc%,nowhere%,nowhere%,paths_crossing_loc%,nowhere%,nowhere%,nowhere%
data cave_hall_loc%,cave_entrance_loc%,nowhere%,nowhere%,big_lake_loc%,nowhere%,nowhere%
data big_lake_loc%,nowhere%,nowhere%,cave_hall_loc%,nowhere%,nowhere%,nowhere%
data secret_exit_loc%,nowhere%,nowhere%,nowhere%,ruined_bridge_loc%,nowhere%,nowhere%
data ruined_bridge_loc%,nowhere%,nowhere%,secret_exit_loc%,cave_corner_loc%,nowhere%,nowhere%
data cave_corner_loc%,nowhere%,sand_passage_loc%,ruined_bridge_loc%,nowhere%,nowhere%,nowhere%
data sand_passage_loc%,cave_corner_loc%,stalactites_loc%,water_passage_loc%,nowhere%,nowhere%,nowhere%
data water_passage_loc%,nowhere%,nowhere%,nowhere%,sand_passage_loc%,nowhere%,nowhere%
data stalactites_loc%,sand_passage_loc%,cave_strait_1_loc%,stone_bridge_loc%,nowhere%,nowhere%,nowhere%
data stone_bridge_loc%,nowhere%,nowhere%,channel_sand_corner_loc%,stalactites_loc%,nowhere%,nowhere%
data channel_sand_corner_loc%,nowhere%,nowhere%,nowhere%,stone_bridge_loc%,nowhere%,nowhere%
data cave_strait_1_loc%,stalactites_loc%,cave_strait_3_loc%,cave_strait_6_loc%,nowhere%,nowhere%,nowhere%
data cave_strait_2_loc%,nowhere%,cave_strait_8_loc%,cave_strait_4_loc%,cave_strait_1_loc%,nowhere%,nowhere%
data cave_strait_3_loc%,nowhere%,cave_strait_5_loc%,cave_strait_8_loc%,cave_strait_3_loc%,nowhere%,nowhere%
data cave_strait_4_loc%,nowhere%,cave_strait_6_loc%,nowhere%,cave_strait_2_loc%,nowhere%,nowhere%
data cave_strait_5_loc%,cave_strait_3_loc%,nowhere%,cave_strait_7_loc%,nowhere%,nowhere%,nowhere%
data cave_strait_6_loc%,cave_strait_3_loc%,refuge_loc%,cave_strait_4_loc%,cave_strait_2_loc%,nowhere%,nowhere%
data cave_strait_7_loc%,cave_strait_7_loc%,nowhere%,cave_strait_1_loc%,cave_strait_8_loc%,nowhere%,nowhere%
data cave_strait_8_loc%,cave_strait_8_loc%,nowhere%,nowhere%,cave_strait_6_loc%,nowhere%,nowhere%
data refuge_loc%,cave_strait_7_loc%,nowhere%,nowhere%,nowhere%,nowhere%,nowhere%
data spiral_loc%,nowhere%,nowhere%,nowhere%,refuge_loc%,nowhere%,spiral_start_loc%
data spiral_start_loc%,nowhere%,nowhere%,north_gate_loc%,nowhere%,spiral_loc%,nowhere%
data north_gate_loc%,nowhere%,nowhere%,nowhere%,spiral_start_loc%,nowhere%,nowhere%
data precipice_loc%,nowhere%,exit_passage_loc%,nowhere%,north_gate_loc%,nowhere%,nowhere%
data exit_passage_loc%,precipice_loc%,nowhere%,gravel_passage_loc%,nowhere%,nowhere%,nowhere%
data gravel_passage_loc%,bridge_over_aqueduct_loc%,nowhere%,nowhere%,exit_passage_loc%,nowhere%,nowhere%
data bridge_over_aqueduct_loc%,terrace_loc%,gravel_passage_loc%,nowhere%,pool_loc%,nowhere%,pool_loc%
data pool_loc%,nowhere%,nowhere%,bridge_over_aqueduct_loc%,water_channel_loc%,bridge_over_aqueduct_loc%,nowhere%
data water_channel_loc%,nowhere%,nowhere%,pool_loc%,big_waterfall_loc%,nowhere%,nowhere%
data big_waterfall_loc%,nowhere%,nowhere%,water_channel_loc%,inside_waterfall_loc%,nowhere%,nowhere%
data inside_waterfall_loc%,nowhere%,nowhere%,big_waterfall_loc%,nowhere%,nowhere%,nowhere%
data terrace_loc%,nowhere%,bridge_over_aqueduct_loc%,idol_loc%,nowhere%,nowhere%,nowhere%
data idol_loc%,nowhere%,nowhere%,nowhere%,terrace_loc%,nowhere%,nowhere%
data strait_passage_loc%,idol_loc%,snake_passage_loc%,nowhere%,nowhere%,nowhere%,nowhere%
data snake_passage_loc%,strait_passage_loc%,nowhere%,nowhere%,nowhere%,nowhere%,nowhere%
data inner_lake_loc%,snake_passage_loc%,nowhere%,nowhere%,passage_crossing_loc%,nowhere%,nowhere%
data passage_crossing_loc%,nowhere%,cave_exit_loc%,inner_lake_loc%,ambrosios_home_loc%,nowhere%,nowhere%
data ambrosios_home_loc%,nowhere%,nowhere%,passage_crossing_loc%,nowhere%,nowhere%,nowhere%
data cave_exit_loc%,passage_crossing_loc%,nowhere%,nowhere%,nowhere%,nowhere%,nowhere%
data cave_exit_forest_loc%,nowhere%,nowhere%,cave_exit_loc%,forest_path_loc%,nowhere%,nowhere%
data forest_path_loc%,nowhere%,nowhere%,cave_exit_forest_loc%,north_road_loc%,nowhere%,nowhere%
data north_road_loc%,nowhere%,westmorland_loc%,forest_path_loc%,nowhere%,nowhere%,nowhere%
data westmorland_loc%,north_road_loc%,nowhere%,nowhere%,nowhere%,nowhere%,nowhere%

' Nouns

' data: entity, noun
' (for every entity id, the last noun listed will be the main one)
label @nouns_start
data ambrosio%,"ambrosio"
data the_altar%,"altar"
data the_cloak%,"lana"
data the_cloak%,"prenda"
data the_cloak%,"capa"
data the_door%,"puerta"
data the_emerald%,"joya"
data the_emerald%,"brillante"
data the_emerald%,"esmeralda"
data the_fallen_away%,"derrumbe"
data the_flags%,"estandartes"
data the_flags%,"enseñas"
data the_flags%,"pendones"
data the_flags%,"banderas"
data the_flint%,"pedernal"
data the_idol%,"agujeros"
data the_idol%,"agujero"
data the_idol%,"ojos"
data the_idol%,"ojo"
data the_idol%,"ídolo"
data the_key%,"llave"
data the_lake%,"agua"
data the_lake%,"laguna"
data the_lake%,"lago"
data the_lock%,"cerradura"
data the_lock%,"cerrojo"
data the_lock%,"cierre"
data the_lock%,"candado"
data the_log%,"leño"
data the_log%,"madero"
data the_log%,"tronco"
data the_man%,"tipo"
data the_man%,"anciano"
data the_man%,"jefe"
data the_man%,"viejo"
data the_man%,"hombre"
data the_piece%,"pedazo"
data the_piece%,"trozo"
data the_rags%,"harapo"
data the_rocks%,"piedras"
data the_rocks%,"rocas"
data the_snake%,"culebra"
data the_snake%,"ofidio"
data the_snake%,"reptil"
data the_snake%,"serpiente"
data the_stone%,"pedrusco"
data the_stone%,"piedra"
data the_sword%,"arma"
data the_sword%,"tizona"
data the_sword%,"espada"
data the_thread%,"hebra"
data the_thread%,"hilo"
data the_torch%,"tea"
data the_torch%,"antorcha"
data the_waterfall%,"catarata"
data the_waterfall%,"cascada"
label @nouns_end
rem XXX TMP -- to prevent labels clash

' Entities

' data: entity,location,attribute,description
label @entities_start
data the_altar%,stone_bridge_loc%,untakeable_attr%
data "Justo en la mitad del puente, debe sostener algo importante."
data ambrosio%,channel_sand_corner_loc%,person_attr%
data "Ambrosio es un hombre de mediana edad, que te mira afable." ' XXX FIXME text
data the_torch%,limbo%,takeable_attr%
data "Está apagada."
data the_flags%,refuge_loc%,untakeable_attr%
data "Son las banderas britana y sajona: \
  dos dragones rampantes, rojo y blanco respectivamente, enfrentados."
data the_cloak%,protagonist%,takeable_attr%
data "Tu capa de general, de fina lana tintada de negro."
data the_waterfall%,big_waterfall_loc%,untakeable_attr%
data "No ves nada por la cortina de agua. \
  El lago es muy poco profundo."
data the_fallen_away%,fallen_away_loc%,untakeable_attr%
data "Muchas, inalcanzables rocas, apiladas una sobre otra."
data the_emerald%,inside_waterfall_loc%,takeable_attr%
data "Es preciosa."
data the_sword%,protagonist%,takeable_attr%
data "Legado de tu padre, fiel herramienta en mil batallas."
data the_rags%,limbo%,takeable_attr%
data "Un trozo un poco grande de capa."
data the_thread%,limbo%,takeable_attr%
data "Un hilo se ha desprendido al cortar la capa con la espada."
data the_man%,refuge_loc%,untakeable_attr%
data "Es el jefe de los refugiados."
data the_idol%,idol_loc%,untakeable_attr%
data "El ídolo tiene dos agujeros por ojos."
data the_lake%,inner_lake_loc%,untakeable_attr%
data "La luz entra por un resquicio, \
  y caprichosos reflejos te maravillan."
data the_key%,ambrosios_home_loc%,untakeable_attr%
data "Una llave grande, de hierro herrumboso."
data the_flint%,limbo%,takeable_attr%
data "Se trata de una dura y afilada piedra."
data the_stone%,channel_sand_corner_loc%,takeable_attr%
data "Recia y pesada, pero no muy grande, de forma piramidal."
data the_door%,cave_exit_loc%,untakeable_attr%
data "Muy recia y con un gran candado."
data the_rocks%,north_gate_loc%,untakeable_attr%
data "Son muchas, aunque parecen ligeras y con huecos entre ellas."
data the_snake%,snake_passage_loc%,untakeable_attr%
data "Una serpiente bloquea el paso al sur, \
  corriendo a su lado el agua."
data the_log%,sand_passage_loc%,takeable_attr%
data "Es un tronco recio, pero de liviano peso."
data the_piece%,limbo%,takeable_attr%
data "Es un poco de lo que antes era tu capa."
data the_lock%,cave_exit_loc%,untakeable_attr%
data "Está cerrado. Es muy grande y parece resistente."
label @entities_end
rem XXX TMP -- to prevent labels clash

' Actions

' data: action id,syntax
label @actions_start
data to_break%,object_needed%
data to_drop%,object_needed%
data to_examine%,no_object_needed%
data to_finish%,no_object_needed%
data to_fling%,object_needed%
data to_go_down%,no_object_needed%
data to_go_east%,no_object_needed%
data to_go_north%,no_object_needed%
data to_go_south%,no_object_needed%
data to_go_up%,no_object_needed%
data to_go_west%,no_object_needed%
data to_help%,no_object_needed%
data to_insert%,object_and_complement_needed%
data to_look%,no_object_needed%
data to_open%,object_needed%
data to_swim%,no_object_needed%
data to_take%,object_needed%
data to_speak%,object_needed%
data to_sharpen%,object_needed%
data to_inventory%,no_object_needed%
label @actions_end
rem XXX TMP -- to prevent labels clash

' Verbs

' data: action id,verb or synonym
label @verbs_start
data to_break%,"ataca"     ' XXX TODO to_attack%
data to_break%,"atacar"    ' XXX TODO to_attack%
data to_break%,"corta"     ' XXX TODO to_cut%
data to_break%,"cortar"    ' XXX TODO to_cut%
data to_break%,"destroza"
data to_break%,"destrozar"
data to_break%,"empuja"    ' XXX TODO to_push%
data to_break%,"empujar"   ' XXX TODO to_push%
data to_break%,"golpea"    ' XXX TODO to_hit%
data to_break%,"golpear"   ' XXX TODO to_hit%
data to_break%,"mata"      ' XXX TODO to_kill%
data to_break%,"matar"     ' XXX TODO to_kill%
data to_break%,"recorta"   ' XXX TODO to_cut%
data to_break%,"recortar"  ' XXX TODO to_cut%
data to_break%,"rompe"
data to_break%,"romper"
data to_break%,"sacude"    ' XXX TODO to_hit%
data to_break%,"sacudir"   ' XXX TODO to_hit%
data to_drop%,"deja"
data to_drop%,"dejar"
data to_drop%,"desprenderse"
data to_drop%,"despréndete"
data to_drop%,"soltar"
data to_drop%,"suelta"
data to_examine%,"ex"
data to_examine%,"examina"
data to_examine%,"examinar"
data to_examine%,"x"
data to_finish%,"acaba"
data to_finish%,"acabar"
data to_finish%,"fin"
data to_finish%,"finaliza"
data to_finish%,"finalizar"
data to_finish%,"rendirse"
data to_finish%,"ríndete"
data to_finish%,"termina"
data to_finish%,"terminar"
data to_fling%,"arroja"
data to_fling%,"arrojar"
data to_fling%,"lanza"
data to_fling%,"lanzar"
data to_fling%,"tira"
data to_fling%,"tirar"
data to_go_down%,"abajo"
data to_go_down%,"b"
data to_go_down%,"baja"
data to_go_down%,"bajar"
data to_go_down%,"descender"
data to_go_down%,"desciende"
data to_go_east%,"e"
data to_go_east%,"este"
data to_go_north%,"n"
data to_go_north%,"norte"
data to_go_south%,"s"
data to_go_south%,"sur"
data to_go_up%,"a"
data to_go_up%,"arriba"
data to_go_up%,"ascender"
data to_go_up%,"asciende"
data to_go_up%,"sube"
data to_go_up%,"subir"
data to_go_west%,"o"
data to_go_west%,"oeste"
data to_help%,"auxilio"
data to_help%,"ayuda"
data to_help%,"ayudar"
data to_help%,"ayúdame"
data to_help%,"socorro"
data to_insert%,"coloca"
data to_insert%,"colocar"
data to_insert%,"colocarle"
data to_insert%,"colócale"
data to_insert%,"inserta"
data to_insert%,"insertar"
data to_insert%,"insertarle"
data to_insert%,"insértale"
data to_insert%,"introduce"
data to_insert%,"introducir"
data to_insert%,"introducirle"
data to_insert%,"introdúcele"
data to_insert%,"mete"
data to_insert%,"meter"
data to_insert%,"meterle"
data to_insert%,"métele"
data to_insert%,"pon"
data to_insert%,"poner"
data to_insert%,"ponerle"
data to_insert%,"ponle"
data to_insert%,"situar"
data to_insert%,"situarle"
data to_insert%,"sitúa"
data to_inventory%,"examinarte"
data to_inventory%,"examínate"
data to_inventory%,"i"
data to_inventory%,"inventario"
data to_inventory%,"mirarte"
data to_inventory%,"mírate"
data to_look%,"m"
data to_look%,"mira"
data to_look%,"mirar"
data to_look%,"ojea"
data to_look%,"ojear"
data to_open%,"abre"
data to_open%,"abrir"
data to_sharpen%,"afila"
data to_sharpen%,"afilar"
data to_speak%,"charla"
data to_speak%,"charlar"
data to_speak%,"comenta"
data to_speak%,"comentar"
data to_speak%,"comentarle"
data to_speak%,"comentarlo"
data to_speak%,"comentárselo"
data to_speak%,"comunica"
data to_speak%,"comunicar"
data to_speak%,"comunicarle"
data to_speak%,"comunicarlo"
data to_speak%,"comunicárselo"
data to_speak%,"comunícale"
data to_speak%,"comunícalo"
data to_speak%,"comunícate"
data to_speak%,"coméntale"
data to_speak%,"coméntalo"
data to_speak%,"coméntaselo"
data to_speak%,"conversa"
data to_speak%,"conversar"
data to_speak%,"decir"
data to_speak%,"decirle"
data to_speak%,"decirlo"
data to_speak%,"decírselo"
data to_speak%,"di"
data to_speak%,"dile"
data to_speak%,"dilo"
data to_speak%,"díselo"
data to_speak%,"habla"
data to_speak%,"hablar"
data to_speak%,"hablarle"
data to_speak%,"háblale"
data to_speak%,"háblalo"
data to_speak%,"platica"
data to_speak%,"platicar"
data to_speak%,"platicarle"
data to_speak%,"platicarlo"
data to_speak%,"platicárselo"
data to_speak%,"platícale"
data to_speak%,"platícalo"
data to_speak%,"pregunta"
data to_speak%,"preguntar"
data to_speak%,"preguntarle"
data to_speak%,"preguntarlo"
data to_speak%,"preguntárselo"
data to_speak%,"pregúntale"
data to_speak%,"pregúntalo"
data to_swim%,"bañar"
data to_swim%,"bañarse"
data to_swim%,"bañarte"
data to_swim%,"bucea"
data to_swim%,"bucear"
data to_swim%,"báñate"
data to_swim%,"nada"
data to_swim%,"nadar"
data to_swim%,"zambullirse"
data to_swim%,"zambullirte"
data to_swim%,"zambúllete"
data to_take%,"agarra"
data to_take%,"agarrar"
data to_take%,"coge"
data to_take%,"coger"
data to_take%,"recoge"
data to_take%,"recoger"
data to_take%,"toma"
data to_take%,"tomar"
label @verbs_end

' ==============================================================
' Meta

defproc fatal_error(message$)

  ink #tw%,light_red%
  print #tw%,"Error fatal:"!message$
  stop

enddef

defproc _debug(text$)

  print #tw%,"Punto de depuración:"!text$

enddef

' vim: filetype=sbim:textwidth=70
