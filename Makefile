roms := red-deathmode.gbc

red-deathmode_obj := audio_red.o main_red.o pics_red.o text_red.o wram_red.o


### Build tools

MD5 := md5sum -c
PYTHON3 := python3

RGBDS ?=
RGBASM  ?= $(RGBDS)rgbasm
RGBFIX  ?= $(RGBDS)rgbfix
RGBGFX  ?= $(RGBDS)rgbgfx
RGBLINK ?= $(RGBDS)rgblink


### Build targets

.SUFFIXES:
.SECONDEXPANSION:
.PRECIOUS:
.SECONDARY:
.PHONY: all red clean tidy compare tools config

all: $(roms) config
red: red-deathmode.gbc

config: red-deathmode.ini

# For contributors to make sure a change didn't affect the contents of the rom.
compare: $(roms)
	@$(MD5) roms.md5

clean:
	rm -f $(roms) $(red-deathmode_obj) $(roms:.gbc=.sym)
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' -o -iname '*.pic' -o -iname '*.lz' \) -exec rm {} +
	$(MAKE) clean -C tools/

tidy:
	rm -f $(roms) $(red-deathmode_obj) $(roms:.gbc=.sym)
	$(MAKE) clean -C tools/

tools:
	$(MAKE) -C tools/


# Build tools when building the rom.
# This has to happen before the rules are processed, since that's when scan_includes is run.
ifeq (,$(filter clean tools,$(MAKECMDGOALS)))
$(info $(shell $(MAKE) -C tools))
endif

# Echo current git revision into an include for the permaoptions screen to pick up
$(shell echo "db \"-"$(shell git log -1 --format="%h")"\"" > git-revision.asm)

%.asm: ;

%_red.o: dep = $(shell tools/scan_includes $(@D)/$*.asm)
$(red-deathmode_obj): %_red.o: %.asm $$(dep)
	$(RGBASM) -D _RED -h -o $@ $*.asm

red-deathmode_opt  = -cjsv -k 01 -l 0x33 -m 0x13 -p 0 -r 03 -t "RED_SPDC" -i KAPC

%.gbc: $$(%_obj)
	$(RGBLINK) -n $*.sym -l red-deathmode.link -m red-deathmode.map -o $@ $^
	$(RGBFIX) $($*_opt) $@
	sort $*.sym -o $*.sym

### LZ compression rules

%.lz: %
	tools/lzcomp $(LZFLAGS) -- $< $@


### Misc file-specific graphics rules

gfx/blue/intro_purin_1.2bpp: RGBGFX += -h
gfx/blue/intro_purin_2.2bpp: RGBGFX += -h
gfx/blue/intro_purin_3.2bpp: RGBGFX += -h
gfx/red/intro_nido_1.2bpp: RGBGFX += -h
gfx/red/intro_nido_2.2bpp: RGBGFX += -h
gfx/red/intro_nido_3.2bpp: RGBGFX += -h

gfx/game_boy.2bpp: tools/gfx += --remove-duplicates
gfx/theend.2bpp: tools/gfx += --interleave --png=$<
gfx/tilesets/%.2bpp: tools/gfx += --trim-whitespace

pic/bmon/%.2bpp: RGBGFX += -h
pic/monback/%.2bpp: RGBGFX += -h
pic/other/%.2bpp: RGBGFX += -h
pic/rgmon/%.2bpp: RGBGFX += -h
pic/trainer/%.2bpp: RGBGFX += -h
pic/ymon/%.2bpp: RGBGFX += -h
pic/ytrainer/%.2bpp: RGBGFX += -h


### Catch-all graphics rules

%.png: ;

%.2bpp: %.png
	$(RGBGFX) $(rgbgfx) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -o $@ $@)

%.1bpp: %.png
	$(RGBGFX) -d1 $(rgbgfx) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -d1 -o $@ $@)

%.ini: %.gbc %.sym
	$(PYTHON3) genrandoini.py $^ $@
	echo "MD5Hash="$(shell md5sum $< | cut -d' ' -f1) >> $@
