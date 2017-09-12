# Makefile
#
# This file is part of _Asalto y castigo_
# (http://programandala.net/es.programa.asalto_y_castigo.superbasic.html)

# ==============================================================

MAKEFLAGS = --no-print-directory

.ONESHELL:

.PHONY: all
all: target/boot target/ayc_bas

.PHONY: clean
clean:
	rm -f target/*_bas target/boot

target/boot: src/boot.sbim
	sbim $< $@

target/ayc_bas: src/ayc.sbim
	sbim $< $@

# ==============================================================
# Change log

# 2017-09-12: Start.

