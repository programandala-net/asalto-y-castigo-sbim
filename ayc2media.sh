#!/bin/sh
# ayc2media.sh

# Crea los ficheros ZIP y QLPAK del juego de QL "Asalto y castigo".
# Create the ZIP and QLPAK files of the QL game "Asalto y castigo".

# By Marcos Cruz (programandala.net)

# 2011-04-29 First version: QLPAK with MGE ROM, and ZIP.
# 2011-05-27 Added the qxl-es_kbt file.
# 2011-06-12 New QLPAK with JS ROM.

cd ~/ql/sb/ayc/media/content
zip -9 ../ayc.zip boot ayc_bas ext_display_code ext_inarray_code ext_megatk_code ext_minmax_code img_ayc8_scr iso8859-1_font qxl-es_kbt
zip -9 ../ayc_mge.qlpak boot ayc_bas ext_display_code ext_inarray_code ext_megatk_code ext_minmax_code img_ayc8_scr iso8859-1_font qxl-es_kbt mge.rom ayc_mge.qcf
zip -9 ../ayc_js.qlpak boot ayc_bas ext_display_code ext_inarray_code ext_megatk_code ext_minmax_code img_ayc8_scr iso8859-1_font qxl-es_kbt ayc_js.qcf
cd -
