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
all: target/boot target/ayc_bas target/SMSQmulator.ini

# ==============================================================
# Cleaning

.PHONY: clean
clean: cleantarget cleanmedia

.PHONY: cleantarget
cleantarget:
	rm -f target/*_bas target/boot

.PHONY: cleanmedia
cleanmedia:
	rm -f media/*.zip media/*.win

# ==============================================================
# Target

lib_files=$(wildcard src/lib/*.bas)

target/boot: src/boot.bas
	sbim $< $@

target/ayc_bas: src/ayc.bas $(lib_files)
	sbim $< $@

target/SMSQmulator.ini: src/SMSQmulator.ini
	cp -f $< $@

# ==============================================================
# Images

# XXX OLD

.PHONY: images
images: $(wildcard img/*.png)
		for file in $^; do
	 	 	convert $$file BMP3:target/img/$$(basename $${file%\.*}).bmp
		done;

# ==============================================================
# Media

.PHONY: zip
zip: media/asalto_y_castigo.zip

media/asalto_y_castigo.zip: target/boot \
	 						target/ayc_bas \
							target/SMSQmulator.ini
	ln -sf target ayc
	cp README.adoc LICENSE.txt TO-DO.adoc ayc
	zip -9 -r \
		--exclude=**/.gitignore \
		media/asalto_y_castigo.zip ayc/*
	rm -f ayc/README.adoc ayc/LICENSE.txt ayc/TO-DO.adoc ayc

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
# are used instead. Add rule to build the zip package.
