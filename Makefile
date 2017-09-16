# Makefile
#
# This file is part of _Asalto y castigo_
# (http://programandala.net/es.programa.asalto_y_castigo.superbasic.html)

# Last modifed 201709161840
# See change log at the end of the file

# ==============================================================
# Requirements

# ImageMagick (http://imagemagick.org)

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
all: target/boot target/ayc_bas images

.PHONY: clean
clean:
	rm -f target/*_bas target/boot

target/boot: src/boot.sbim
	sbim $< $@

target/ayc_bas: src/ayc.sbim
	sbim $< $@

.PHONY: images
images: $(wildcard img/*.png)
		for file in $^; do
	 	 	convert $$file BMP3:target/img/$$(basename $${file%\.*}).bmp
		done;

# ==============================================================
# Change log

# 2017-09-12: Start.
#
# 2017-09-16: Convert PNG splash screens to BMP.
