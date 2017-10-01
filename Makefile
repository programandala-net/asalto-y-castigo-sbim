# Makefile
#
# This file is part of _Asalto y castigo_
# (http://programandala.net/es.programa.asalto_y_castigo.superbasic.html)

# Last modified 201710011336
# See change log at the end of the file

# ==============================================================
# Requirements

# ImageMagick
# 	http://imagemagick.org
# SBim
# 	http://programandala.net/en.program.sbim.html

# ==============================================================
# Notes

# $@ = the name of the target of the rule
# $< = the name of the first prerequisite
# $? = the names of all the prerequisites that are newer than the target
# $^ = the names of all the prerequisites

# `%` works only at the start of the filter pattern

# ==============================================================

VPATH = ./

MAKEFLAGS = --no-print-directory

.ONESHELL:

.PHONY: all
all: target/boot target/ayc_bas

.PHONY: clean
clean:
	rm -f target/*_bas target/boot

target/boot: src/boot.bas
	sbim $< $@

target/ayc_bas: src/ayc.bas src/lib/iso_upper.bas
	sbim $< $@

.PHONY: images
# XXX OLD
images: $(wildcard img/*.png)
		for file in $^; do
	 	 	convert $$file BMP3:target/img/$$(basename $${file%\.*}).bmp
		done;

# ==============================================================
# Change log

# 2017-09-12: Start.
#
# 2017-09-16: Convert PNG splash screens to BMP.
#
# 2017-09-17: Update SBIM extension to BAS.
#
# 2017-09-18: Update the note about requirements.
#
# 2017-09-25: Include <src/lib/iso_upper.bas> as prerequisite.
#
# 2017-10-01: Deactivate conversion of PNG images to BMP. Their PIC versions
# are used instead.
